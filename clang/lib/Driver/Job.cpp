//===- Job.cpp - Command to Execute ---------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "clang/Driver/Job.h"
#include "InputInfo.h"
#include "clang/Basic/LLVM.h"
#include "clang/Driver/Driver.h"
#include "clang/Driver/DriverDiagnostic.h"
#include "clang/Driver/Tool.h"
#include "clang/Driver/ToolChain.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/Support/CrashRecoveryContext.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/PrettyStackTrace.h"
#include "llvm/Support/Program.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <cassert>
#include <cstddef>
#include <string>
#include <system_error>
#include <utility>

using namespace clang;
using namespace driver;

Command::Command(const Action &Source, const Tool &Creator,
                 const char *Executable,
                 const llvm::opt::ArgStringList &Arguments,
                 ArrayRef<InputInfo> Inputs)
    : Source(Source), Creator(Creator), Executable(Executable),
      Arguments(Arguments) {
  for (const auto &II : Inputs) {
    if (II.isFilename())
      InputFilenames.push_back(II.getFilename());
    DependentActions.push_back(II.getAction());
  }
}

/// Check if the compiler flag in question should be skipped when
/// emitting a reproducer. Also track how many arguments it has and if the
/// option is some kind of include path.
static bool skipArgs(const char *Flag, bool HaveCrashVFS, int &SkipNum,
                     bool &IsInclude) {
  SkipNum = 2;
  // These flags are all of the form -Flag <Arg> and are treated as two
  // arguments.  Therefore, we need to skip the flag and the next argument.
  bool ShouldSkip = llvm::StringSwitch<bool>(Flag)
    .Cases("-MF", "-MT", "-MQ", "-serialize-diagnostic-file", true)
    .Cases("-o", "-dependency-file", true)
    .Cases("-fdebug-compilation-dir", "-diagnostic-log-file", true)
    .Cases("-dwarf-debug-flags", "-ivfsoverlay", true)
    .Default(false);
  if (ShouldSkip)
    return true;

  // Some include flags shouldn't be skipped if we have a crash VFS
  IsInclude = llvm::StringSwitch<bool>(Flag)
    .Cases("-include", "-header-include-file", true)
    .Cases("-idirafter", "-internal-isystem", "-iwithprefix", true)
    .Cases("-internal-externc-isystem", "-iprefix", true)
    .Cases("-iwithprefixbefore", "-isystem", "-iquote", true)
    .Cases("-isysroot", "-I", "-F", "-resource-dir", true)
    .Cases("-iframework", "-include-pch", true)
    .Default(false);
  if (IsInclude)
    return !HaveCrashVFS;

  // The remaining flags are treated as a single argument.

  // These flags are all of the form -Flag and have no second argument.
  ShouldSkip = llvm::StringSwitch<bool>(Flag)
    .Cases("-M", "-MM", "-MG", "-MP", "-MD", true)
    .Case("-MMD", true)
    .Default(false);

  // Match found.
  SkipNum = 1;
  if (ShouldSkip)
    return true;

  // These flags are treated as a single argument (e.g., -F<Dir>).
  StringRef FlagRef(Flag);
  IsInclude = FlagRef.startswith("-F") || FlagRef.startswith("-I");
  if (IsInclude)
    return !HaveCrashVFS;
  if (FlagRef.startswith("-fmodules-cache-path="))
    return true;

  SkipNum = 0;
  return false;
}

void Command::printArg(raw_ostream &OS, StringRef Arg, bool Quote) {
  const bool Escape = Arg.find_first_of(" \"\\$") != StringRef::npos;

  if (!Quote && !Escape) {
    OS << Arg;
    return;
  }

  // Quote and escape. This isn't really complete, but good enough.
  OS << '"';
  for (const auto c : Arg) {
    if (c == '"' || c == '\\' || c == '$')
      OS << '\\';
    OS << c;
  }
  OS << '"';
}

void Command::writeResponseFile(raw_ostream &OS) const {
  // In a file list, we only write the set of inputs to the response file
  if (Creator.getResponseFilesSupport() == Tool::RF_FileList) {
    for (const auto *Arg : InputFileList) {
      OS << Arg << '\n';
    }
    return;
  }

  // In regular response files, we send all arguments to the response file.
  // Wrapping all arguments in double quotes ensures that both Unix tools and
  // Windows tools understand the response file.
  for (const auto *Arg : Arguments) {
    OS << '"';

    for (; *Arg != '\0'; Arg++) {
      if (*Arg == '\"' || *Arg == '\\') {
        OS << '\\';
      }
      OS << *Arg;
    }

    OS << "\" ";
  }
}

void Command::buildArgvForResponseFile(
    llvm::SmallVectorImpl<const char *> &Out) const {
  // When not a file list, all arguments are sent to the response file.
  // This leaves us to set the argv to a single parameter, requesting the tool
  // to read the response file.
  if (Creator.getResponseFilesSupport() != Tool::RF_FileList) {
    Out.push_back(Executable);
    Out.push_back(ResponseFileFlag.c_str());
    return;
  }

  llvm::StringSet<> Inputs;
  for (const auto *InputName : InputFileList)
    Inputs.insert(InputName);
  Out.push_back(Executable);
  // In a file list, build args vector ignoring parameters that will go in the
  // response file (elements of the InputFileList vector)
  bool FirstInput = true;
  for (const auto *Arg : Arguments) {
    if (Inputs.count(Arg) == 0) {
      Out.push_back(Arg);
    } else if (FirstInput) {
      FirstInput = false;
      Out.push_back(Creator.getResponseFileFlag());
      Out.push_back(ResponseFile);
    }
  }
}

/// Rewrite relative include-like flag paths to absolute ones.
static void
rewriteIncludes(const llvm::ArrayRef<const char *> &Args, size_t Idx,
                size_t NumArgs,
                llvm::SmallVectorImpl<llvm::SmallString<128>> &IncFlags) {
  using namespace llvm;
  using namespace sys;

  auto getAbsPath = [](StringRef InInc, SmallVectorImpl<char> &OutInc) -> bool {
    if (path::is_absolute(InInc)) // Nothing to do here...
      return false;
    std::error_code EC = fs::current_path(OutInc);
    if (EC)
      return false;
    path::append(OutInc, InInc);
    return true;
  };

  SmallString<128> NewInc;
  if (NumArgs == 1) {
    StringRef FlagRef(Args[Idx + NumArgs - 1]);
    assert((FlagRef.startswith("-F") || FlagRef.startswith("-I")) &&
            "Expecting -I or -F");
    StringRef Inc = FlagRef.slice(2, StringRef::npos);
    if (getAbsPath(Inc, NewInc)) {
      SmallString<128> NewArg(FlagRef.slice(0, 2));
      NewArg += NewInc;
      IncFlags.push_back(std::move(NewArg));
    }
    return;
  }

  assert(NumArgs == 2 && "Not expecting more than two arguments");
  StringRef Inc(Args[Idx + NumArgs - 1]);
  if (!getAbsPath(Inc, NewInc))
    return;
  IncFlags.push_back(SmallString<128>(Args[Idx]));
  IncFlags.push_back(std::move(NewInc));
}

void Command::Print(raw_ostream &OS, const char *Terminator, bool Quote,
                    CrashReportInfo *CrashInfo) const {
  // Always quote the exe.
  OS << ' ';
  printArg(OS, Executable, /*Quote=*/true);

  ArrayRef<const char *> Args = Arguments;
  SmallVector<const char *, 128> ArgsRespFile;
  if (ResponseFile != nullptr) {
    buildArgvForResponseFile(ArgsRespFile);
    Args = ArrayRef<const char *>(ArgsRespFile).slice(1); // no executable name
  }

  bool HaveCrashVFS = CrashInfo && !CrashInfo->VFSPath.empty();
  for (size_t i = 0, e = Args.size(); i < e; ++i) {
    const char *const Arg = Args[i];

    if (CrashInfo) {
      int NumArgs = 0;
      bool IsInclude = false;
      if (skipArgs(Arg, HaveCrashVFS, NumArgs, IsInclude)) {
        i += NumArgs - 1;
        continue;
      }

      // Relative includes need to be expanded to absolute paths.
      if (HaveCrashVFS && IsInclude) {
        SmallVector<SmallString<128>, 2> NewIncFlags;
        rewriteIncludes(Args, i, NumArgs, NewIncFlags);
        if (!NewIncFlags.empty()) {
          for (auto &F : NewIncFlags) {
            OS << ' ';
            printArg(OS, F.c_str(), Quote);
          }
          i += NumArgs - 1;
          continue;
        }
      }

      auto Found = llvm::find_if(InputFilenames,
                                 [&Arg](StringRef IF) { return IF == Arg; });
      if (Found != InputFilenames.end() &&
          (i == 0 || StringRef(Args[i - 1]) != "-main-file-name")) {
        // Replace the input file name with the crashinfo's file name.
        OS << ' ';
        StringRef ShortName = llvm::sys::path::filename(CrashInfo->Filename);
        printArg(OS, ShortName.str(), Quote);
        continue;
      }
    }

    OS << ' ';
    printArg(OS, Arg, Quote);
  }

  if (CrashInfo && HaveCrashVFS) {
    OS << ' ';
    printArg(OS, "-ivfsoverlay", Quote);
    OS << ' ';
    printArg(OS, CrashInfo->VFSPath.str(), Quote);

    // The leftover modules from the crash are stored in
    //  <name>.cache/vfs/modules
    // Leave it untouched for pcm inspection and provide a clean/empty dir
    // path to contain the future generated module cache:
    //  <name>.cache/vfs/repro-modules
    SmallString<128> RelModCacheDir = llvm::sys::path::parent_path(
        llvm::sys::path::parent_path(CrashInfo->VFSPath));
    llvm::sys::path::append(RelModCacheDir, "repro-modules");

    std::string ModCachePath = "-fmodules-cache-path=";
    ModCachePath.append(RelModCacheDir.c_str());

    OS << ' ';
    printArg(OS, ModCachePath, Quote);
  }

  if (ResponseFile != nullptr) {
    OS << "\n Arguments passed via response file:\n";
    writeResponseFile(OS);
    // Avoiding duplicated newline terminator, since FileLists are
    // newline-separated.
    if (Creator.getResponseFilesSupport() != Tool::RF_FileList)
      OS << "\n";
    OS << " (end of response file)";
  }

  OS << Terminator;
}

void Command::setResponseFile(const char *FileName) {
  ResponseFile = FileName;
  ResponseFileFlag = Creator.getResponseFileFlag();
  ResponseFileFlag += FileName;
}

void Command::setEnvironment(llvm::ArrayRef<const char *> NewEnvironment) {
  Environment.reserve(NewEnvironment.size() + 1);
  Environment.assign(NewEnvironment.begin(), NewEnvironment.end());
  Environment.push_back(nullptr);
}

void Command::PrintFileNames() const {
  if (PrintInputFilenames) {
    for (const char *Arg : InputFilenames)
      llvm::outs() << llvm::sys::path::filename(Arg) << "\n";
    llvm::outs().flush();
  }
}

int Command::Execute(ArrayRef<llvm::Optional<StringRef>> Redirects,
                     std::string *ErrMsg, bool *ExecutionFailed) const {
  PrintFileNames();

  SmallVector<const char *, 128> Argv;
  if (ResponseFile == nullptr) {
    Argv.push_back(Executable);
    Argv.append(Arguments.begin(), Arguments.end());
    Argv.push_back(nullptr);
  } else {
    // If the command is too large, we need to put arguments in a response file.
    std::string RespContents;
    llvm::raw_string_ostream SS(RespContents);

    // Write file contents and build the Argv vector
    writeResponseFile(SS);
    buildArgvForResponseFile(Argv);
    Argv.push_back(nullptr);
    SS.flush();

    // Save the response file in the appropriate encoding
    if (std::error_code EC = writeFileWithEncoding(
            ResponseFile, RespContents, Creator.getResponseFileEncoding())) {
      if (ErrMsg)
        *ErrMsg = EC.message();
      if (ExecutionFailed)
        *ExecutionFailed = true;
      // Return -1 by convention (see llvm/include/llvm/Support/Program.h) to
      // indicate the requested executable cannot be started.
      return -1;
    }
  }

  Optional<ArrayRef<StringRef>> Env;
  std::vector<StringRef> ArgvVectorStorage;
  if (!Environment.empty()) {
    assert(Environment.back() == nullptr &&
           "Environment vector should be null-terminated by now");
    ArgvVectorStorage = llvm::toStringRefArray(Environment.data());
    Env = makeArrayRef(ArgvVectorStorage);
  }

  auto Args = llvm::toStringRefArray(Argv.data());
  return llvm::sys::ExecuteAndWait(Executable, Args, Env, Redirects,
                                   /*secondsToWait*/ 0,
                                   /*memoryLimit*/ 0, ErrMsg, ExecutionFailed);
}

CC1Command::CC1Command(const Action &Source, const Tool &Creator,
                       const char *Executable,
                       const llvm::opt::ArgStringList &Arguments,
                       ArrayRef<InputInfo> Inputs)
    : Command(Source, Creator, Executable, Arguments, Inputs) {
  InProcess = true;
}

void CC1Command::Print(raw_ostream &OS, const char *Terminator, bool Quote,
                       CrashReportInfo *CrashInfo) const {
  if (InProcess)
    OS << " (in-process)\n";
  Command::Print(OS, Terminator, Quote, CrashInfo);
}

int CC1Command::Execute(ArrayRef<llvm::Optional<StringRef>> Redirects,
                        std::string *ErrMsg, bool *ExecutionFailed) const {
  // FIXME: Currently, if there're more than one job, we disable
  // -fintegrate-cc1. If we're no longer a integrated-cc1 job, fallback to
  // out-of-process execution. See discussion in https://reviews.llvm.org/D74447
  if (!InProcess)
    return Command::Execute(Redirects, ErrMsg, ExecutionFailed);

  PrintFileNames();

  SmallVector<const char *, 128> Argv;
  Argv.push_back(getExecutable());
  Argv.append(getArguments().begin(), getArguments().end());
  Argv.push_back(nullptr);

  // This flag simply indicates that the program couldn't start, which isn't
  // applicable here.
  if (ExecutionFailed)
    *ExecutionFailed = false;

  llvm::CrashRecoveryContext CRC;
  CRC.DumpStackAndCleanupOnFailure = true;

  const void *PrettyState = llvm::SavePrettyStackState();
  const Driver &D = getCreator().getToolChain().getDriver();

  int R = 0;
  // Enter ExecuteCC1Tool() instead of starting up a new process
  if (!CRC.RunSafely([&]() { R = D.CC1Main(Argv); })) {
    llvm::RestorePrettyStackState(PrettyState);
    return CRC.RetCode;
  }
  return R;
}

void CC1Command::setEnvironment(llvm::ArrayRef<const char *> NewEnvironment) {
  // We don't support set a new environment when calling into ExecuteCC1Tool()
  llvm_unreachable(
      "The CC1Command doesn't support changing the environment vars!");
}

FallbackCommand::FallbackCommand(const Action &Source_, const Tool &Creator_,
                                 const char *Executable_,
                                 const llvm::opt::ArgStringList &Arguments_,
                                 ArrayRef<InputInfo> Inputs,
                                 std::unique_ptr<Command> Fallback_)
    : Command(Source_, Creator_, Executable_, Arguments_, Inputs),
      Fallback(std::move(Fallback_)) {}

void FallbackCommand::Print(raw_ostream &OS, const char *Terminator,
                            bool Quote, CrashReportInfo *CrashInfo) const {
  Command::Print(OS, "", Quote, CrashInfo);
  OS << " ||";
  Fallback->Print(OS, Terminator, Quote, CrashInfo);
}

static bool ShouldFallback(int ExitCode) {
  // FIXME: We really just want to fall back for internal errors, such
  // as when some symbol cannot be mangled, when we should be able to
  // parse something but can't, etc.
  return ExitCode != 0;
}

int FallbackCommand::Execute(ArrayRef<llvm::Optional<StringRef>> Redirects,
                             std::string *ErrMsg, bool *ExecutionFailed) const {
  int PrimaryStatus = Command::Execute(Redirects, ErrMsg, ExecutionFailed);
  if (!ShouldFallback(PrimaryStatus))
    return PrimaryStatus;

  // Clear ExecutionFailed and ErrMsg before falling back.
  if (ErrMsg)
    ErrMsg->clear();
  if (ExecutionFailed)
    *ExecutionFailed = false;

  const Driver &D = getCreator().getToolChain().getDriver();
  D.Diag(diag::warn_drv_invoking_fallback) << Fallback->getExecutable();

  int SecondaryStatus = Fallback->Execute(Redirects, ErrMsg, ExecutionFailed);
  return SecondaryStatus;
}

ForceSuccessCommand::ForceSuccessCommand(
    const Action &Source_, const Tool &Creator_, const char *Executable_,
    const llvm::opt::ArgStringList &Arguments_, ArrayRef<InputInfo> Inputs)
    : Command(Source_, Creator_, Executable_, Arguments_, Inputs) {}

void ForceSuccessCommand::Print(raw_ostream &OS, const char *Terminator,
                            bool Quote, CrashReportInfo *CrashInfo) const {
  Command::Print(OS, "", Quote, CrashInfo);
  OS << " || (exit 0)" << Terminator;
}

int ForceSuccessCommand::Execute(ArrayRef<llvm::Optional<StringRef>> Redirects,
                                 std::string *ErrMsg,
                                 bool *ExecutionFailed) const {
  int Status = Command::Execute(Redirects, ErrMsg, ExecutionFailed);
  (void)Status;
  if (ExecutionFailed)
    *ExecutionFailed = false;
  return 0;
}

void JobList::Print(raw_ostream &OS, const char *Terminator, bool Quote,
                    CrashReportInfo *CrashInfo) const {
  for (const auto &Job : *this)
    Job.Print(OS, Terminator, Quote, CrashInfo);
}

void JobList::clear() { Jobs.clear(); }
