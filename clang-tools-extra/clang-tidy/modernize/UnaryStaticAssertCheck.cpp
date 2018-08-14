//===--- UnaryStaticAssertCheck.cpp - clang-tidy---------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "UnaryStaticAssertCheck.h"
#include "clang/AST/ASTContext.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"

using namespace clang::ast_matchers;

namespace clang {
namespace tidy {
namespace modernize {

void UnaryStaticAssertCheck::registerMatchers(MatchFinder *Finder) {
  if (!getLangOpts().CPlusPlus17)
    return;

  Finder->addMatcher(staticAssertDecl().bind("static_assert"), this);
}

void UnaryStaticAssertCheck::check(const MatchFinder::MatchResult &Result) {
  const auto *MatchedDecl =
      Result.Nodes.getNodeAs<StaticAssertDecl>("static_assert");
  const StringLiteral *AssertMessage = MatchedDecl->getMessage();

  SourceLocation Loc = MatchedDecl->getLocation();

  if (!AssertMessage || AssertMessage->getLength() ||
      AssertMessage->getBeginLoc().isMacroID() || Loc.isMacroID())
    return;

  diag(Loc,
       "use unary 'static_assert' when the string literal is an empty string")
      << FixItHint::CreateRemoval(AssertMessage->getSourceRange());
}

} // namespace modernize
} // namespace tidy
} // namespace clang
