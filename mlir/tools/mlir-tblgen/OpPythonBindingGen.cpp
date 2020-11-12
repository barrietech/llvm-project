//===- OpPythonBindingGen.cpp - Generator of Python API for MLIR Ops ------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// OpPythonBindingGen uses ODS specification of MLIR ops to generate Python
// binding classes wrapping a generic operation API.
//
//===----------------------------------------------------------------------===//

#include "mlir/TableGen/GenInfo.h"
#include "mlir/TableGen/Operator.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FormatVariadic.h"
#include "llvm/TableGen/Error.h"
#include "llvm/TableGen/Record.h"

using namespace mlir;
using namespace mlir::tblgen;

/// File header and includes.
constexpr const char *fileHeader = R"Py(
# Autogenerated by mlir-tblgen; don't manually edit.

import array
from . import _cext
from . import _segmented_accessor, _equally_sized_accessor
_ir = _cext.ir
)Py";

/// Template for dialect class:
///   {0} is the dialect namespace.
constexpr const char *dialectClassTemplate = R"Py(
@_cext.register_dialect
class _Dialect(_ir.Dialect):
  DIALECT_NAMESPACE = "{0}"
  pass

)Py";

/// Template for operation class:
///   {0} is the Python class name;
///   {1} is the operation name.
constexpr const char *opClassTemplate = R"Py(
@_cext.register_operation(_Dialect)
class {0}(_ir.OpView):
  OPERATION_NAME = "{1}"
)Py";

/// Template for single-element accessor:
///   {0} is the name of the accessor;
///   {1} is either 'operand' or 'result';
///   {2} is the position in the element list.
constexpr const char *opSingleTemplate = R"Py(
  @property
  def {0}(self):
    return self.operation.{1}s[{2}]
)Py";

/// Template for single-element accessor after a variable-length group:
///   {0} is the name of the accessor;
///   {1} is either 'operand' or 'result';
///   {2} is the total number of element groups;
///   {3} is the position of the current group in the group list.
/// This works for both a single variadic group (non-negative length) and an
/// single optional element (zero length if the element is absent).
constexpr const char *opSingleAfterVariableTemplate = R"Py(
  @property
  def {0}(self):
    variadic_group_length = len(self.operation.{1}s) - {2} + 1
    return self.operation.{1}s[{3} + variadic_group_length - 1]
)Py";

/// Template for an optional element accessor:
///   {0} is the name of the accessor;
///   {1} is either 'operand' or 'result';
///   {2} is the total number of element groups;
///   {3} is the position of the current group in the group list.
constexpr const char *opOneOptionalTemplate = R"Py(
  @property
  def {0}(self);
    return self.operation.{1}s[{3}] if len(self.operation.{1}s) > {2}
                                    else None
)Py";

/// Template for the variadic group accessor in the single variadic group case:
///   {0} is the name of the accessor;
///   {1} is either 'operand' or 'result';
///   {2} is the total number of element groups;
///   {3} is the position of the current group in the group list.
constexpr const char *opOneVariadicTemplate = R"Py(
  @property
  def {0}(self):
    variadic_group_length = len(self.operation.{1}s) - {2} + 1
    return self.operation.{1}s[{3}:{3} + variadic_group_length]
)Py";

/// First part of the template for equally-sized variadic group accessor:
///   {0} is the name of the accessor;
///   {1} is either 'operand' or 'result';
///   {2} is the total number of variadic groups;
///   {3} is the number of non-variadic groups preceding the current group;
///   {3} is the number of variadic groups preceding the current group.
constexpr const char *opVariadicEqualPrefixTemplate = R"Py(
  @property
  def {0}(self):
    start, pg = _equally_sized_accessor(operation.{1}s, {2}, {3}, {4}))Py";

/// Second part of the template for equally-sized case, accessing a single
/// element:
///   {0} is either 'operand' or 'result'.
constexpr const char *opVariadicEqualSimpleTemplate = R"Py(
    return self.operation.{0}s[start]
)Py";

/// Second part of the template for equally-sized case, accessing a variadic
/// group:
///   {0} is either 'operand' or 'result'.
constexpr const char *opVariadicEqualVariadicTemplate = R"Py(
    return self.operation.{0}s[start:start + pg]
)Py";

/// Template for an attribute-sized group accessor:
///   {0} is the name of the accessor;
///   {1} is either 'operand' or 'result';
///   {2} is the position of the group in the group list;
///   {3} is a return suffix (expected [0] for single-element, empty for
///       variadic, and opVariadicSegmentOptionalTrailingTemplate for optional).
constexpr const char *opVariadicSegmentTemplate = R"Py(
  @property
  def {0}(self):
    {1}_range = _segmented_accessor(
         self.operation.{1}s,
         self.operation.attributes["{1}_segment_sizes"], {2})
    return {1}_range{3}
)Py";

/// Template for a suffix when accessing an optional element in the
/// attribute-sized case:
///   {0} is either 'operand' or 'result';
constexpr const char *opVariadicSegmentOptionalTrailingTemplate =
    R"Py([0] if len({0}_range) > 0 else None)Py";

static llvm::cl::OptionCategory
    clOpPythonBindingCat("Options for -gen-python-op-bindings");

static llvm::cl::opt<std::string>
    clDialectName("bind-dialect",
                  llvm::cl::desc("The dialect to run the generator for"),
                  llvm::cl::init(""), llvm::cl::cat(clOpPythonBindingCat));

/// Checks whether `str` is a Python keyword.
static bool isPythonKeyword(StringRef str) {
  static llvm::StringSet<> keywords(
      {"and",   "as",     "assert",   "break", "class",  "continue",
       "def",   "del",    "elif",     "else",  "except", "finally",
       "for",   "from",   "global",   "if",    "import", "in",
       "is",    "lambda", "nonlocal", "not",   "or",     "pass",
       "raise", "return", "try",      "while", "with",   "yield"});
  return keywords.contains(str);
};

/// Modifies the `name` in a way that it becomes suitable for Python bindings
/// (does not change the `name` if it already is suitable) and returns the
/// modified version.
static std::string sanitizeName(StringRef name) {
  if (isPythonKeyword(name))
    return (name + "_").str();
  return name.str();
}

static std::string attrSizedTraitForKind(const char *kind) {
  return llvm::formatv("::mlir::OpTrait::AttrSized{0}{1}Segments",
                       llvm::StringRef(kind).take_front().upper(),
                       llvm::StringRef(kind).drop_front());
}

/// Emits accessors to "elements" of an Op definition. Currently, the supported
/// elements are operands and results, indicated by `kind`, which must be either
/// `operand` or `result` and is used verbatim in the emitted code.
static void emitElementAccessors(
    const Operator &op, raw_ostream &os, const char *kind,
    llvm::function_ref<unsigned(const Operator &)> getNumVariadic,
    llvm::function_ref<int(const Operator &)> getNumElements,
    llvm::function_ref<const NamedTypeConstraint &(const Operator &, int)>
        getElement) {
  assert(llvm::is_contained(
             llvm::SmallVector<StringRef, 2>{"operand", "result"}, kind) &&
         "unsupported kind");

  // Traits indicating how to process variadic elements.
  std::string sameSizeTrait =
      llvm::formatv("::mlir::OpTrait::SameVariadic{0}{1}Size",
                    llvm::StringRef(kind).take_front().upper(),
                    llvm::StringRef(kind).drop_front());
  std::string attrSizedTrait = attrSizedTraitForKind(kind);

  unsigned numVariadic = getNumVariadic(op);

  // If there is only one variadic element group, its size can be inferred from
  // the total number of elements. If there are none, the generation is
  // straightforward.
  if (numVariadic <= 1) {
    bool seenVariableLength = false;
    for (int i = 0, e = getNumElements(op); i < e; ++i) {
      const NamedTypeConstraint &element = getElement(op, i);
      if (element.isVariableLength())
        seenVariableLength = true;
      if (element.name.empty())
        continue;
      if (element.isVariableLength()) {
        os << llvm::formatv(element.isOptional() ? opOneOptionalTemplate
                                                 : opOneVariadicTemplate,
                            sanitizeName(element.name), kind,
                            getNumElements(op), i);
      } else if (seenVariableLength) {
        os << llvm::formatv(opSingleAfterVariableTemplate,
                            sanitizeName(element.name), kind,
                            getNumElements(op), i);
      } else {
        os << llvm::formatv(opSingleTemplate, sanitizeName(element.name), kind,
                            i);
      }
    }
    return;
  }

  // Handle the operations where variadic groups have the same size.
  if (op.getTrait(sameSizeTrait)) {
    int numPrecedingSimple = 0;
    int numPrecedingVariadic = 0;
    for (int i = 0, e = getNumElements(op); i < e; ++i) {
      const NamedTypeConstraint &element = getElement(op, i);
      if (!element.name.empty()) {
        os << llvm::formatv(opVariadicEqualPrefixTemplate,
                            sanitizeName(element.name), kind, numVariadic,
                            numPrecedingSimple, numPrecedingVariadic);
        os << llvm::formatv(element.isVariableLength()
                                ? opVariadicEqualVariadicTemplate
                                : opVariadicEqualSimpleTemplate,
                            kind);
      }
      if (element.isVariableLength())
        ++numPrecedingVariadic;
      else
        ++numPrecedingSimple;
    }
    return;
  }

  // Handle the operations where the size of groups (variadic or not) is
  // provided as an attribute. For non-variadic elements, make sure to return
  // an element rather than a singleton container.
  if (op.getTrait(attrSizedTrait)) {
    for (int i = 0, e = getNumElements(op); i < e; ++i) {
      const NamedTypeConstraint &element = getElement(op, i);
      if (element.name.empty())
        continue;
      std::string trailing;
      if (!element.isVariableLength())
        trailing = "[0]";
      else if (element.isOptional())
        trailing = std::string(
            llvm::formatv(opVariadicSegmentOptionalTrailingTemplate, kind));
      os << llvm::formatv(opVariadicSegmentTemplate, sanitizeName(element.name),
                          kind, i, trailing);
    }
    return;
  }

  llvm::PrintFatalError("unsupported " + llvm::Twine(kind) + " structure");
}

/// Free function helpers accessing Operator components.
static int getNumOperands(const Operator &op) { return op.getNumOperands(); }
static const NamedTypeConstraint &getOperand(const Operator &op, int i) {
  return op.getOperand(i);
}
static int getNumResults(const Operator &op) { return op.getNumResults(); }
static const NamedTypeConstraint &getResult(const Operator &op, int i) {
  return op.getResult(i);
}

/// Emits accessor to Op operands.
static void emitOperandAccessors(const Operator &op, raw_ostream &os) {
  auto getNumVariadic = [](const Operator &oper) {
    return oper.getNumVariableLengthOperands();
  };
  emitElementAccessors(op, os, "operand", getNumVariadic, getNumOperands,
                       getOperand);
}

/// Emits access or Op results.
static void emitResultAccessors(const Operator &op, raw_ostream &os) {
  auto getNumVariadic = [](const Operator &oper) {
    return oper.getNumVariableLengthResults();
  };
  emitElementAccessors(op, os, "result", getNumVariadic, getNumResults,
                       getResult);
}

/// Template for the default auto-generated builder.
///   {0} is the operation name;
///   {1} is a comma-separated list of builder arguments, including the trailing
///       `loc` and `ip`;
///   {2} is the code populating `operands`, `results` and `attributes` fields.
constexpr const char *initTemplate = R"Py(
  def __init__(self, {1}):
    operands = []
    results = []
    attributes = {{}
    {2}
    super().__init__(_ir.Operation.create(
      "{0}", attributes=attributes, operands=operands, results=results,
      loc=loc, ip=ip))
)Py";

/// Template for appending a single element to the operand/result list.
///   {0} is either 'operand' or 'result';
///   {1} is the field name.
constexpr const char *singleElementAppendTemplate = "{0}s.append({1})";

/// Template for appending an optional element to the operand/result list.
///   {0} is either 'operand' or 'result';
///   {1} is the field name.
constexpr const char *optionalAppendTemplate =
    "if {1} is not None: {0}s.append({1})";

/// Template for appending a variadic element to the operand/result list.
///   {0} is either 'operand' or 'result';
///   {1} is the field name.
constexpr const char *variadicAppendTemplate = "{0}s += [*{1}]";

/// Template for setting up the segment sizes buffer.
constexpr const char *segmentDeclarationTemplate =
    "{0}_segment_sizes = array.array('L')";

/// Template for attaching segment sizes to the attribute list.
constexpr const char *segmentAttributeTemplate =
    R"Py(attributes["{0}_segment_sizes"] = _ir.DenseElementsAttr.get({0}_segment_sizes,
      context=Location.current.context if loc is None else loc.context))Py";

/// Template for appending the unit size to the segment sizes.
///   {0} is either 'operand' or 'result';
///   {1} is the field name.
constexpr const char *singleElementSegmentTemplate =
    "{0}_segment_sizes.append(1) # {1}";

/// Template for appending 0/1 for an optional element to the segment sizes.
///   {0} is either 'operand' or 'result';
///   {1} is the field name.
constexpr const char *optionalSegmentTemplate =
    "{0}_segment_sizes.append(0 if {1} is None else 1)";

/// Template for appending the length of a variadic group to the segment sizes.
///   {0} is either 'operand' or 'result';
///   {1} is the field name.
constexpr const char *variadicSegmentTemplate =
    "{0}_segment_sizes.append(len({1}))";

/// Populates `builderArgs` with the list of `__init__` arguments that
/// correspond to either operands or results of `op`, and `builderLines` with
/// additional lines that are required in the builder. `kind` must be either
/// "operand" or "result". `unnamedTemplate` is used to generate names for
/// operands or results that don't have the name in ODS.
static void populateBuilderLines(
    const Operator &op, const char *kind, const char *unnamedTemplate,
    llvm::SmallVectorImpl<std::string> &builderArgs,
    llvm::SmallVectorImpl<std::string> &builderLines,
    llvm::function_ref<int(const Operator &)> getNumElements,
    llvm::function_ref<const NamedTypeConstraint &(const Operator &, int)>
        getElement) {
  // The segment sizes buffer only has to be populated if there attr-sized
  // segments trait is present.
  bool includeSegments = op.getTrait(attrSizedTraitForKind(kind)) != nullptr;
  if (includeSegments)
    builderLines.push_back(llvm::formatv(segmentDeclarationTemplate, kind));

  // For each element, find or generate a name.
  for (int i = 0, e = getNumElements(op); i < e; ++i) {
    const NamedTypeConstraint &element = getElement(op, i);
    std::string name = element.name.str();
    if (name.empty())
      name = llvm::formatv(unnamedTemplate, i).str();
    name = sanitizeName(name);
    builderArgs.push_back(name);

    // Choose the formatting string based on the element kind.
    llvm::StringRef formatString, segmentFormatString;
    if (!element.isVariableLength()) {
      formatString = singleElementAppendTemplate;
      segmentFormatString = singleElementSegmentTemplate;
    } else if (element.isOptional()) {
      formatString = optionalAppendTemplate;
      segmentFormatString = optionalSegmentTemplate;
    } else {
      assert(element.isVariadic() && "unhandled element group type");
      formatString = variadicAppendTemplate;
      segmentFormatString = variadicSegmentTemplate;
    }

    // Add the lines.
    builderLines.push_back(llvm::formatv(formatString.data(), kind, name));
    if (includeSegments)
      builderLines.push_back(
          llvm::formatv(segmentFormatString.data(), kind, name));
  }

  if (includeSegments)
    builderLines.push_back(llvm::formatv(segmentAttributeTemplate, kind));
}

/// Emits a default builder constructing an operation from the list of its
/// result types, followed by a list of its operands.
static void emitDefaultOpBuilder(const Operator &op, raw_ostream &os) {
  // TODO: support attribute types.
  if (op.getNumNativeAttributes() != 0)
    return;

  // If we are asked to skip default builders, comply.
  if (op.skipDefaultBuilders())
    return;

  llvm::SmallVector<std::string, 8> builderArgs;
  llvm::SmallVector<std::string, 8> builderLines;
  builderArgs.reserve(op.getNumOperands() + op.getNumResults());
  populateBuilderLines(op, "result", "_gen_res_{0}", builderArgs, builderLines,
                       getNumResults, getResult);
  populateBuilderLines(op, "operand", "_gen_arg_{0}", builderArgs, builderLines,
                       getNumOperands, getOperand);

  builderArgs.push_back("loc=None");
  builderArgs.push_back("ip=None");
  os << llvm::formatv(initTemplate, op.getOperationName(),
                      llvm::join(builderArgs, ", "),
                      llvm::join(builderLines, "\n    "));
}

/// Emits bindings for a specific Op to the given output stream.
static void emitOpBindings(const Operator &op, raw_ostream &os) {
  os << llvm::formatv(opClassTemplate, op.getCppClassName(),
                      op.getOperationName());
  emitDefaultOpBuilder(op, os);
  emitOperandAccessors(op, os);
  emitResultAccessors(op, os);
}

/// Emits bindings for the dialect specified in the command line, including file
/// headers and utilities. Returns `false` on success to comply with Tablegen
/// registration requirements.
static bool emitAllOps(const llvm::RecordKeeper &records, raw_ostream &os) {
  if (clDialectName.empty())
    llvm::PrintFatalError("dialect name not provided");

  os << fileHeader;
  os << llvm::formatv(dialectClassTemplate, clDialectName.getValue());
  for (const llvm::Record *rec : records.getAllDerivedDefinitions("Op")) {
    Operator op(rec);
    if (op.getDialectName() == clDialectName.getValue())
      emitOpBindings(op, os);
  }
  return false;
}

static GenRegistration
    genPythonBindings("gen-python-op-bindings",
                      "Generate Python bindings for MLIR Ops", &emitAllOps);
