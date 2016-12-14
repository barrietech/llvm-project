//===- RedundantStringCStrCheck.cpp - Check for redundant c_str calls -----===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
//  This file implements a check for redundant calls of c_str() on strings.
//
//===----------------------------------------------------------------------===//

#include "RedundantStringCStrCheck.h"
#include "clang/Lex/Lexer.h"

using namespace clang::ast_matchers;

namespace clang {
namespace tidy {
namespace readability {

namespace {

template <typename T>
StringRef getText(const ast_matchers::MatchFinder::MatchResult &Result,
                  T const &Node) {
  return Lexer::getSourceText(
      CharSourceRange::getTokenRange(Node.getSourceRange()),
      *Result.SourceManager, Result.Context->getLangOpts());
}

// Return true if expr needs to be put in parens when it is an argument of a
// prefix unary operator, e.g. when it is a binary or ternary operator
// syntactically.
bool needParensAfterUnaryOperator(const Expr &ExprNode) {
  if (isa<clang::BinaryOperator>(&ExprNode) ||
      isa<clang::ConditionalOperator>(&ExprNode)) {
    return true;
  }
  if (const auto *Op = dyn_cast<CXXOperatorCallExpr>(&ExprNode)) {
    return Op->getNumArgs() == 2 && Op->getOperator() != OO_PlusPlus &&
           Op->getOperator() != OO_MinusMinus && Op->getOperator() != OO_Call &&
           Op->getOperator() != OO_Subscript;
  }
  return false;
}

// Format a pointer to an expression: prefix with '*' but simplify
// when it already begins with '&'.  Return empty string on failure.
std::string
formatDereference(const ast_matchers::MatchFinder::MatchResult &Result,
                  const Expr &ExprNode) {
  if (const auto *Op = dyn_cast<clang::UnaryOperator>(&ExprNode)) {
    if (Op->getOpcode() == UO_AddrOf) {
      // Strip leading '&'.
      return getText(Result, *Op->getSubExpr()->IgnoreParens());
    }
  }
  StringRef Text = getText(Result, ExprNode);
  if (Text.empty())
    return std::string();
  // Add leading '*'.
  if (needParensAfterUnaryOperator(ExprNode)) {
    return (llvm::Twine("*(") + Text + ")").str();
  }
  return (llvm::Twine("*") + Text).str();
}

} // end namespace

void RedundantStringCStrCheck::registerMatchers(
    ast_matchers::MatchFinder *Finder) {
  // Only register the matchers for C++; the functionality currently does not
  // provide any benefit to other languages, despite being benign.
  if (!getLangOpts().CPlusPlus)
    return;

  // Match expressions of type 'string' or 'string*'.
  const auto StringDecl = cxxRecordDecl(hasName("::std::basic_string"));
  const auto StringExpr =
      expr(anyOf(hasType(StringDecl), hasType(qualType(pointsTo(StringDecl)))));

  // Match string constructor.
  const auto StringConstructorExpr = expr(anyOf(
      cxxConstructExpr(argumentCountIs(1),
                       hasDeclaration(cxxMethodDecl(hasName("basic_string")))),
      cxxConstructExpr(
          argumentCountIs(2),
          hasDeclaration(cxxMethodDecl(hasName("basic_string"))),
          // If present, the second argument is the alloc object which must not
          // be present explicitly.
          hasArgument(1, cxxDefaultArgExpr()))));

  // Match a call to the string 'c_str()' method.
  const auto StringCStrCallExpr =
      cxxMemberCallExpr(on(StringExpr.bind("arg")),
                        callee(memberExpr().bind("member")),
                        callee(cxxMethodDecl(hasAnyName("c_str", "data"))))
          .bind("call");

  // Detect redundant 'c_str()' calls through a string constructor.
  Finder->addMatcher(cxxConstructExpr(StringConstructorExpr,
                                      hasArgument(0, StringCStrCallExpr)),
                     this);

  // Detect: 's == str.c_str()'  ->  's == str'
  Finder->addMatcher(
      cxxOperatorCallExpr(
          anyOf(
              hasOverloadedOperatorName("<"), hasOverloadedOperatorName(">"),
              hasOverloadedOperatorName(">="), hasOverloadedOperatorName("<="),
              hasOverloadedOperatorName("!="), hasOverloadedOperatorName("=="),
              hasOverloadedOperatorName("+")),
          anyOf(allOf(hasArgument(0, StringExpr),
                      hasArgument(1, StringCStrCallExpr)),
                allOf(hasArgument(0, StringCStrCallExpr),
                      hasArgument(1, StringExpr)))),
      this);

  // Detect: 'dst += str.c_str()'  ->  'dst += str'
  // Detect: 's = str.c_str()'  ->  's = str'
  Finder->addMatcher(cxxOperatorCallExpr(anyOf(hasOverloadedOperatorName("="),
                                               hasOverloadedOperatorName("+=")),
                                         hasArgument(0, StringExpr),
                                         hasArgument(1, StringCStrCallExpr)),
                     this);

  // Detect: 'dst.append(str.c_str())'  ->  'dst.append(str)'
  Finder->addMatcher(
      cxxMemberCallExpr(on(StringExpr), callee(decl(cxxMethodDecl(hasAnyName(
                                            "append", "assign", "compare")))),
                        argumentCountIs(1), hasArgument(0, StringCStrCallExpr)),
      this);

  // Detect: 'dst.compare(p, n, str.c_str())'  ->  'dst.compare(p, n, str)'
  Finder->addMatcher(
      cxxMemberCallExpr(on(StringExpr),
                        callee(decl(cxxMethodDecl(hasName("compare")))),
                        argumentCountIs(3), hasArgument(2, StringCStrCallExpr)),
      this);

  // Detect: 'dst.find(str.c_str())'  ->  'dst.find(str)'
  Finder->addMatcher(
      cxxMemberCallExpr(on(StringExpr),
                        callee(decl(cxxMethodDecl(hasAnyName(
                            "find", "find_first_not_of", "find_first_of",
                            "find_last_not_of", "find_last_of", "rfind")))),
                        anyOf(argumentCountIs(1), argumentCountIs(2)),
                        hasArgument(0, StringCStrCallExpr)),
      this);

  // Detect: 'dst.insert(pos, str.c_str())'  ->  'dst.insert(pos, str)'
  Finder->addMatcher(
      cxxMemberCallExpr(on(StringExpr),
                        callee(decl(cxxMethodDecl(hasName("insert")))),
                        argumentCountIs(2), hasArgument(1, StringCStrCallExpr)),
      this);

  // Detect redundant 'c_str()' calls through a StringRef constructor.
  Finder->addMatcher(
      cxxConstructExpr(
          // Implicit constructors of these classes are overloaded
          // wrt. string types and they internally make a StringRef
          // referring to the argument.  Passing a string directly to
          // them is preferred to passing a char pointer.
          hasDeclaration(cxxMethodDecl(hasAnyName(
              "::llvm::StringRef::StringRef", "::llvm::Twine::Twine"))),
          argumentCountIs(1),
          // The only argument must have the form x.c_str() or p->c_str()
          // where the method is string::c_str().  StringRef also has
          // a constructor from string which is more efficient (avoids
          // strlen), so we can construct StringRef from the string
          // directly.
          hasArgument(0, StringCStrCallExpr)),
      this);
}

void RedundantStringCStrCheck::check(const MatchFinder::MatchResult &Result) {
  const auto *Call = Result.Nodes.getNodeAs<CallExpr>("call");
  const auto *Arg = Result.Nodes.getNodeAs<Expr>("arg");
  const auto *Member = Result.Nodes.getNodeAs<MemberExpr>("member");
  bool Arrow = Member->isArrow();
  // Replace the "call" node with the "arg" node, prefixed with '*'
  // if the call was using '->' rather than '.'.
  std::string ArgText =
      Arrow ? formatDereference(Result, *Arg) : getText(Result, *Arg).str();
  if (ArgText.empty())
    return;

  diag(Call->getLocStart(), "redundant call to %0")
      << Member->getMemberDecl()
      << FixItHint::CreateReplacement(Call->getSourceRange(), ArgText);
}

} // namespace readability
} // namespace tidy
} // namespace clang
