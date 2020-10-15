//===- MinGW.cpp ----------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "MinGW.h"
#include "Driver.h"
#include "InputFiles.h"
#include "SymbolTable.h"
#include "lld/Common/ErrorHandler.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/Object/COFF.h"
#include "llvm/Support/Parallel.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;
using namespace llvm::COFF;
using namespace lld;
using namespace lld::coff;

AutoExporter::AutoExporter() {
  excludeLibs = {
      "libgcc",
      "libgcc_s",
      "libstdc++",
      "libmingw32",
      "libmingwex",
      "libg2c",
      "libsupc++",
      "libobjc",
      "libgcj",
      "libclang_rt.builtins",
      "libclang_rt.builtins-aarch64",
      "libclang_rt.builtins-arm",
      "libclang_rt.builtins-i386",
      "libclang_rt.builtins-x86_64",
      "libclang_rt.profile",
      "libclang_rt.profile-aarch64",
      "libclang_rt.profile-arm",
      "libclang_rt.profile-i386",
      "libclang_rt.profile-x86_64",
      "libc++",
      "libc++abi",
      "libunwind",
      "libmsvcrt",
      "libucrtbase",
  };

  excludeObjects = {
      "crt0.o",    "crt1.o",  "crt1u.o", "crt2.o",  "crt2u.o",    "dllcrt1.o",
      "dllcrt2.o", "gcrt0.o", "gcrt1.o", "gcrt2.o", "crtbegin.o", "crtend.o",
  };

  excludeSymbolPrefixes = {
      // Import symbols
      "__imp_",
      "__IMPORT_DESCRIPTOR_",
      // Extra import symbols from GNU import libraries
      "__nm_",
      // C++ symbols
      "__rtti_",
      "__builtin_",
      // Artificial symbols such as .refptr
      ".",
      // profile generate symbols
      "__profc_",
      "__profd_",
      "__profvp_",
  };

  excludeSymbolSuffixes = {
      "_iname",
      "_NULL_THUNK_DATA",
  };

  if (config->machine == I386) {
    excludeSymbols = {
        "__NULL_IMPORT_DESCRIPTOR",
        "__pei386_runtime_relocator",
        "_do_pseudo_reloc",
        "_impure_ptr",
        "__impure_ptr",
        "__fmode",
        "_environ",
        "___dso_handle",
        // These are the MinGW names that differ from the standard
        // ones (lacking an extra underscore).
        "_DllMain@12",
        "_DllEntryPoint@12",
        "_DllMainCRTStartup@12",
    };
    excludeSymbolPrefixes.insert("__head_");
  } else {
    excludeSymbols = {
        "__NULL_IMPORT_DESCRIPTOR",
        "_pei386_runtime_relocator",
        "do_pseudo_reloc",
        "impure_ptr",
        "_impure_ptr",
        "_fmode",
        "environ",
        "__dso_handle",
        // These are the MinGW names that differ from the standard
        // ones (lacking an extra underscore).
        "DllMain",
        "DllEntryPoint",
        "DllMainCRTStartup",
    };
    excludeSymbolPrefixes.insert("_head_");
  }
}

void AutoExporter::addWholeArchive(StringRef path) {
  StringRef libName = sys::path::filename(path);
  // Drop the file extension, to match the processing below.
  libName = libName.substr(0, libName.rfind('.'));
  excludeLibs.erase(libName);
}

bool AutoExporter::shouldExport(Defined *sym) const {
  if (!sym || !sym->isLive() || !sym->getChunk())
    return false;

  // Only allow the symbol kinds that make sense to export; in particular,
  // disallow import symbols.
  if (!isa<DefinedRegular>(sym) && !isa<DefinedCommon>(sym))
    return false;
  if (excludeSymbols.count(sym->getName()))
    return false;

  for (StringRef prefix : excludeSymbolPrefixes.keys())
    if (sym->getName().startswith(prefix))
      return false;
  for (StringRef suffix : excludeSymbolSuffixes.keys())
    if (sym->getName().endswith(suffix))
      return false;

  // If a corresponding __imp_ symbol exists and is defined, don't export it.
  if (symtab->find(("__imp_" + sym->getName()).str()))
    return false;

  // Check that file is non-null before dereferencing it, symbols not
  // originating in regular object files probably shouldn't be exported.
  if (!sym->getFile())
    return false;

  StringRef libName = sys::path::filename(sym->getFile()->parentName);

  // Drop the file extension.
  libName = libName.substr(0, libName.rfind('.'));
  if (!libName.empty())
    return !excludeLibs.count(libName);

  StringRef fileName = sys::path::filename(sym->getFile()->getName());
  return !excludeObjects.count(fileName);
}

void lld::coff::writeDefFile(StringRef name) {
  std::error_code ec;
  raw_fd_ostream os(name, ec, sys::fs::OF_None);
  if (ec)
    fatal("cannot open " + name + ": " + ec.message());

  os << "EXPORTS\n";
  for (Export &e : config->exports) {
    os << "    " << e.exportName << " "
       << "@" << e.ordinal;
    if (auto *def = dyn_cast_or_null<Defined>(e.sym)) {
      if (def && def->getChunk() &&
          !(def->getChunk()->getOutputCharacteristics() & IMAGE_SCN_MEM_EXECUTE))
        os << " DATA";
    }
    os << "\n";
  }
}

static StringRef mangle(Twine sym) {
  assert(config->machine != IMAGE_FILE_MACHINE_UNKNOWN);
  if (config->machine == I386)
    return saver.save("_" + sym);
  return saver.save(sym);
}

// Handles -wrap option.
//
// This function instantiates wrapper symbols. At this point, they seem
// like they are not being used at all, so we explicitly set some flags so
// that LTO won't eliminate them.
std::vector<WrappedSymbol>
lld::coff::addWrappedSymbols(opt::InputArgList &args) {
  std::vector<WrappedSymbol> v;
  DenseSet<StringRef> seen;

  for (auto *arg : args.filtered(OPT_wrap)) {
    StringRef name = arg->getValue();
    if (!seen.insert(name).second)
      continue;

    Symbol *sym = symtab->findUnderscore(name);
    if (!sym)
      continue;

    Symbol *real = symtab->addUndefined(mangle("__real_" + name));
    Symbol *wrap = symtab->addUndefined(mangle("__wrap_" + name));
    v.push_back({sym, real, wrap});

    // These symbols may seem undefined initially, but don't bail out
    // at symtab->reportUnresolvable() due to them, but let wrapSymbols
    // below sort things out before checking finally with
    // symtab->resolveRemainingUndefines().
    sym->deferUndefined = true;
    real->deferUndefined = true;
    // We want to tell LTO not to inline symbols to be overwritten
    // because LTO doesn't know the final symbol contents after renaming.
    real->canInline = false;
    sym->canInline = false;

    // Tell LTO not to eliminate these symbols.
    sym->isUsedInRegularObj = true;
    if (!isa<Undefined>(wrap))
      wrap->isUsedInRegularObj = true;
  }
  return v;
}

// Do renaming for -wrap by updating pointers to symbols.
//
// When this function is executed, only InputFiles and symbol table
// contain pointers to symbol objects. We visit them to replace pointers,
// so that wrapped symbols are swapped as instructed by the command line.
void lld::coff::wrapSymbols(ArrayRef<WrappedSymbol> wrapped) {
  DenseMap<Symbol *, Symbol *> map;
  for (const WrappedSymbol &w : wrapped) {
    map[w.sym] = w.wrap;
    map[w.real] = w.sym;
  }

  // Update pointers in input files.
  parallelForEach(ObjFile::instances, [&](ObjFile *file) {
    MutableArrayRef<Symbol *> syms = file->getMutableSymbols();
    for (size_t i = 0, e = syms.size(); i != e; ++i)
      if (Symbol *s = map.lookup(syms[i]))
        syms[i] = s;
  });
}
