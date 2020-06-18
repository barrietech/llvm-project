//===---------- TransformerClangTidyCheck.h - clang-tidy ------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CLANG_TOOLS_EXTRA_CLANG_TIDY_TRANSFORMER_CLANG_TIDY_CHECK_H
#define LLVM_CLANG_TOOLS_EXTRA_CLANG_TIDY_TRANSFORMER_CLANG_TIDY_CHECK_H

#include "../ClangTidy.h"
#include "IncludeInserter.h"
#include "IncludeSorter.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Tooling/Transformer/Transformer.h"
#include <deque>
#include <vector>

namespace clang {
namespace tidy {
namespace utils {

// A base class for defining a ClangTidy check based on a `RewriteRule`.
//
// For example, given a rule `MyCheckAsRewriteRule`, one can define a tidy check
// as follows:
//
// class MyCheck : public TransformerClangTidyCheck {
//  public:
//   MyCheck(StringRef Name, ClangTidyContext *Context)
//       : TransformerClangTidyCheck(MyCheckAsRewriteRule, Name, Context) {}
// };
//
// `TransformerClangTidyCheck` recognizes this clang-tidy option:
//
//  * IncludeStyle. A string specifying which file naming convention is used by
//      the source code, 'llvm' or 'google'.  Default is 'llvm'. The naming
//      convention influences how canonical headers are distinguished from other
//      includes.
class TransformerClangTidyCheck : public ClangTidyCheck {
public:
  // \p MakeRule generates the rewrite rule to be used by the check, based on
  // the given language and clang-tidy options. It can return \c None to handle
  // cases where the options disable the check.
  //
  // All cases in the rule generated by \p MakeRule must have a non-null \c
  // Explanation, even though \c Explanation is optional for RewriteRule in
  // general. Because the primary purpose of clang-tidy checks is to provide
  // users with diagnostics, we assume that a missing explanation is a bug.  If
  // no explanation is desired, indicate that explicitly (for example, by
  // passing `text("no explanation")` to `makeRule` as the `Explanation`
  // argument).
  TransformerClangTidyCheck(std::function<Optional<transformer::RewriteRule>(
                                const LangOptions &, const OptionsView &)>
                                MakeRule,
                            StringRef Name, ClangTidyContext *Context);

  // Convenience overload of the constructor when the rule doesn't depend on any
  // of the language or clang-tidy options.
  TransformerClangTidyCheck(transformer::RewriteRule R, StringRef Name,
                            ClangTidyContext *Context);

  void registerPPCallbacks(const SourceManager &SM, Preprocessor *PP,
                           Preprocessor *ModuleExpanderPP) override;
  void registerMatchers(ast_matchers::MatchFinder *Finder) final;
  void check(const ast_matchers::MatchFinder::MatchResult &Result) final;

  /// Derived classes that override this function should call this method from
  /// the overridden method.
  void storeOptions(ClangTidyOptions::OptionMap &Opts) override;

private:
  Optional<transformer::RewriteRule> Rule;
  const IncludeSorter::IncludeStyle IncludeStyle;
  std::unique_ptr<IncludeInserter> Inserter;
};

} // namespace utils
} // namespace tidy
} // namespace clang

#endif // LLVM_CLANG_TOOLS_EXTRA_CLANG_TIDY_TRANSFORMER_CLANG_TIDY_CHECK_H
