//===-- RemoteAwarePlatformTest.cpp ---------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "lldb/Target/RemoteAwarePlatform.h"
#include "lldb/Core/Debugger.h"
#include "lldb/Core/Module.h"
#include "lldb/Core/ModuleSpec.h"
#include "lldb/Host/FileSystem.h"
#include "lldb/Target/Platform.h"
#include "lldb/Target/Process.h"
#include "gmock/gmock.h"
#include "gtest/gtest.h"

using namespace lldb_private;
using namespace lldb;
using namespace testing;

class RemoteAwarePlatformTester : public RemoteAwarePlatform {
public:
  using RemoteAwarePlatform::RemoteAwarePlatform;

  MOCK_METHOD0(GetDescription, const char *());
  MOCK_METHOD0(GetPluginVersion, uint32_t());
  MOCK_METHOD0(GetPluginName, ConstString());
  MOCK_METHOD2(GetSupportedArchitectureAtIndex, bool(uint32_t, ArchSpec &));
  MOCK_METHOD4(Attach,
               ProcessSP(ProcessAttachInfo &, Debugger &, Target *, Status &));
  MOCK_METHOD0(CalculateTrapHandlerSymbolNames, void());

  void SetRemotePlatform(lldb::PlatformSP platform) {
    m_remote_platform_sp = platform;
  }
};

class TargetPlatformTester : public Platform {
public:
  using Platform::Platform;

  MOCK_METHOD0(GetDescription, const char *());
  MOCK_METHOD0(GetPluginVersion, uint32_t());
  MOCK_METHOD0(GetPluginName, ConstString());
  MOCK_METHOD2(GetSupportedArchitectureAtIndex, bool(uint32_t, ArchSpec &));
  MOCK_METHOD4(Attach,
               ProcessSP(ProcessAttachInfo &, Debugger &, Target *, Status &));
  MOCK_METHOD0(CalculateTrapHandlerSymbolNames, void());
  MOCK_METHOD0(GetUserIDResolver, UserIDResolver &());

  MOCK_METHOD2(ResolveExecutable,
               std::pair<Status, ModuleSP>(const ModuleSpec &,
                                           const FileSpecList *));
  Status
  ResolveExecutable(const ModuleSpec &module_spec,
                    lldb::ModuleSP &exe_module_sp,
                    const FileSpecList *module_search_paths_ptr) /*override*/ {
    auto pair = ResolveExecutable(module_spec, module_search_paths_ptr);
    exe_module_sp = pair.second;
    return pair.first;
  }
};

namespace {
class RemoteAwarePlatformTest : public testing::Test {
public:
  static void SetUpTestCase() { FileSystem::Initialize(); }
  static void TearDownTestCase() { FileSystem::Terminate(); }
};
} // namespace

TEST_F(RemoteAwarePlatformTest, TestResolveExecutabelOnClientByPlatform) {
  ModuleSpec executable_spec;
  ModuleSP expected_executable(new Module(executable_spec));

  auto platform_sp = std::make_shared<TargetPlatformTester>(false);
  EXPECT_CALL(*platform_sp, ResolveExecutable(_, _))
      .WillRepeatedly(Return(std::make_pair(Status(), expected_executable)));

  RemoteAwarePlatformTester platform(false);
  EXPECT_CALL(platform, GetSupportedArchitectureAtIndex(_, _))
      .WillRepeatedly(Return(false));

  platform.SetRemotePlatform(platform_sp);

  ModuleSP resolved_sp;
  lldb_private::Status status =
      platform.ResolveExecutable(executable_spec, resolved_sp, nullptr);

  ASSERT_TRUE(status.Success());
  EXPECT_EQ(expected_executable.get(), resolved_sp.get());
}
