//===- ARMRegisterBankInfo.cpp -----------------------------------*- C++ -*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the RegisterBankInfo class for ARM.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "ARMRegisterBankInfo.h"
#include "ARMInstrInfo.h" // For the register classes
#include "ARMSubtarget.h"
#include "llvm/CodeGen/GlobalISel/RegisterBank.h"
#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"

#define GET_TARGET_REGBANK_IMPL
#include "ARMGenRegisterBank.inc"

using namespace llvm;

// FIXME: TableGen this.
// If it grows too much and TableGen still isn't ready to do the job, extract it
// into an ARMGenRegisterBankInfo.def (similar to AArch64).
namespace llvm {
namespace ARM {
enum PartialMappingIdx {
  PMI_GPR,
  PMI_SPR,
  PMI_DPR,
  PMI_Min = PMI_GPR,
};

RegisterBankInfo::PartialMapping PartMappings[]{
    // GPR Partial Mapping
    {0, 32, GPRRegBank},
    // SPR Partial Mapping
    {0, 32, FPRRegBank},
    // DPR Partial Mapping
    {0, 64, FPRRegBank},
};

#ifndef NDEBUG
static bool checkPartMapping(const RegisterBankInfo::PartialMapping &PM,
                             unsigned Start, unsigned Length,
                             unsigned RegBankID) {
  return PM.StartIdx == Start && PM.Length == Length &&
         PM.RegBank->getID() == RegBankID;
}

static void checkPartialMappings() {
  assert(
      checkPartMapping(PartMappings[PMI_GPR - PMI_Min], 0, 32, GPRRegBankID) &&
      "Wrong mapping for GPR");
  assert(
      checkPartMapping(PartMappings[PMI_SPR - PMI_Min], 0, 32, FPRRegBankID) &&
      "Wrong mapping for SPR");
  assert(
      checkPartMapping(PartMappings[PMI_DPR - PMI_Min], 0, 64, FPRRegBankID) &&
      "Wrong mapping for DPR");
}
#endif

enum ValueMappingIdx {
  InvalidIdx = 0,
  GPR3OpsIdx = 1,
  SPR3OpsIdx = 4,
  DPR3OpsIdx = 7,
};

RegisterBankInfo::ValueMapping ValueMappings[] = {
    // invalid
    {nullptr, 0},
    // 3 ops in GPRs
    {&PartMappings[PMI_GPR - PMI_Min], 1},
    {&PartMappings[PMI_GPR - PMI_Min], 1},
    {&PartMappings[PMI_GPR - PMI_Min], 1},
    // 3 ops in SPRs
    {&PartMappings[PMI_SPR - PMI_Min], 1},
    {&PartMappings[PMI_SPR - PMI_Min], 1},
    {&PartMappings[PMI_SPR - PMI_Min], 1},
    // 3 ops in DPRs
    {&PartMappings[PMI_DPR - PMI_Min], 1},
    {&PartMappings[PMI_DPR - PMI_Min], 1},
    {&PartMappings[PMI_DPR - PMI_Min], 1}};

#ifndef NDEBUG
static bool checkValueMapping(const RegisterBankInfo::ValueMapping &VM,
                              RegisterBankInfo::PartialMapping *BreakDown) {
  return VM.NumBreakDowns == 1 && VM.BreakDown == BreakDown;
}

static void checkValueMappings() {
  assert(checkValueMapping(ValueMappings[GPR3OpsIdx],
                           &PartMappings[PMI_GPR - PMI_Min]) &&
         "Wrong value mapping for 3 GPR ops instruction");
  assert(checkValueMapping(ValueMappings[GPR3OpsIdx + 1],
                           &PartMappings[PMI_GPR - PMI_Min]) &&
         "Wrong value mapping for 3 GPR ops instruction");
  assert(checkValueMapping(ValueMappings[GPR3OpsIdx + 2],
                           &PartMappings[PMI_GPR - PMI_Min]) &&
         "Wrong value mapping for 3 GPR ops instruction");

  assert(checkValueMapping(ValueMappings[SPR3OpsIdx],
                           &PartMappings[PMI_SPR - PMI_Min]) &&
         "Wrong value mapping for 3 SPR ops instruction");
  assert(checkValueMapping(ValueMappings[SPR3OpsIdx + 1],
                           &PartMappings[PMI_SPR - PMI_Min]) &&
         "Wrong value mapping for 3 SPR ops instruction");
  assert(checkValueMapping(ValueMappings[SPR3OpsIdx + 2],
                           &PartMappings[PMI_SPR - PMI_Min]) &&
         "Wrong value mapping for 3 SPR ops instruction");

  assert(checkValueMapping(ValueMappings[DPR3OpsIdx],
                           &PartMappings[PMI_DPR - PMI_Min]) &&
         "Wrong value mapping for 3 DPR ops instruction");
  assert(checkValueMapping(ValueMappings[DPR3OpsIdx + 1],
                           &PartMappings[PMI_DPR - PMI_Min]) &&
         "Wrong value mapping for 3 DPR ops instruction");
  assert(checkValueMapping(ValueMappings[DPR3OpsIdx + 2],
                           &PartMappings[PMI_DPR - PMI_Min]) &&
         "Wrong value mapping for 3 DPR ops instruction");
}
#endif
} // end namespace arm
} // end namespace llvm

ARMRegisterBankInfo::ARMRegisterBankInfo(const TargetRegisterInfo &TRI)
    : ARMGenRegisterBankInfo() {
  static bool AlreadyInit = false;
  // We have only one set of register banks, whatever the subtarget
  // is. Therefore, the initialization of the RegBanks table should be
  // done only once. Indeed the table of all register banks
  // (ARM::RegBanks) is unique in the compiler. At some point, it
  // will get tablegen'ed and the whole constructor becomes empty.
  if (AlreadyInit)
    return;
  AlreadyInit = true;

  const RegisterBank &RBGPR = getRegBank(ARM::GPRRegBankID);
  (void)RBGPR;
  assert(&ARM::GPRRegBank == &RBGPR && "The order in RegBanks is messed up");

  // Initialize the GPR bank.
  assert(RBGPR.covers(*TRI.getRegClass(ARM::GPRRegClassID)) &&
         "Subclass not added?");
  assert(RBGPR.covers(*TRI.getRegClass(ARM::GPRwithAPSRRegClassID)) &&
         "Subclass not added?");
  assert(RBGPR.covers(*TRI.getRegClass(ARM::GPRnopcRegClassID)) &&
         "Subclass not added?");
  assert(RBGPR.covers(*TRI.getRegClass(ARM::rGPRRegClassID)) &&
         "Subclass not added?");
  assert(RBGPR.covers(*TRI.getRegClass(ARM::tGPRRegClassID)) &&
         "Subclass not added?");
  assert(RBGPR.covers(*TRI.getRegClass(ARM::tcGPRRegClassID)) &&
         "Subclass not added?");
  assert(RBGPR.covers(*TRI.getRegClass(ARM::tGPR_and_tcGPRRegClassID)) &&
         "Subclass not added?");
  assert(RBGPR.covers(*TRI.getRegClass(ARM::tGPREven_and_tGPR_and_tcGPRRegClassID)) &&
         "Subclass not added?");
  assert(RBGPR.covers(*TRI.getRegClass(ARM::tGPROdd_and_tcGPRRegClassID)) &&
         "Subclass not added?");
  assert(RBGPR.getSize() == 32 && "GPRs should hold up to 32-bit");

#ifndef NDEBUG
  ARM::checkPartialMappings();
  ARM::checkValueMappings();
#endif
}

const RegisterBank &
ARMRegisterBankInfo::getRegBankFromRegClass(const TargetRegisterClass &RC,
                                            LLT) const {
  using namespace ARM;

  switch (RC.getID()) {
  case GPRRegClassID:
  case GPRwithAPSRRegClassID:
  case GPRnopcRegClassID:
  case rGPRRegClassID:
  case GPRspRegClassID:
  case tGPR_and_tcGPRRegClassID:
  case tcGPRRegClassID:
  case tGPRRegClassID:
  case tGPREvenRegClassID:
  case tGPROddRegClassID:
  case tGPR_and_tGPREvenRegClassID:
  case tGPR_and_tGPROddRegClassID:
  case tGPREven_and_tcGPRRegClassID:
  case tGPREven_and_tGPR_and_tcGPRRegClassID:
  case tGPROdd_and_tcGPRRegClassID:
    return getRegBank(ARM::GPRRegBankID);
  case HPRRegClassID:
  case SPR_8RegClassID:
  case SPRRegClassID:
  case DPR_8RegClassID:
  case DPRRegClassID:
  case QPRRegClassID:
    return getRegBank(ARM::FPRRegBankID);
  default:
    llvm_unreachable("Unsupported register kind");
  }

  llvm_unreachable("Switch should handle all register classes");
}

const RegisterBankInfo::InstructionMapping &
ARMRegisterBankInfo::getInstrMapping(const MachineInstr &MI) const {
  auto Opc = MI.getOpcode();

  // Try the default logic for non-generic instructions that are either copies
  // or already have some operands assigned to banks.
  if (!isPreISelGenericOpcode(Opc) || Opc == TargetOpcode::G_PHI) {
    const InstructionMapping &Mapping = getInstrMappingImpl(MI);
    if (Mapping.isValid())
      return Mapping;
  }

  using namespace TargetOpcode;

  const MachineFunction &MF = *MI.getParent()->getParent();
  const MachineRegisterInfo &MRI = MF.getRegInfo();
  unsigned NumOperands = MI.getNumOperands();
  const ValueMapping *OperandsMapping = &ARM::ValueMappings[ARM::GPR3OpsIdx];

  switch (Opc) {
  case G_ADD:
  case G_SUB: {
    // Integer operations where the source and destination are in the
    // same register class.
    LLT Ty = MRI.getType(MI.getOperand(0).getReg());
    OperandsMapping = Ty.getSizeInBits() == 64
                          ? &ARM::ValueMappings[ARM::DPR3OpsIdx]
                          : &ARM::ValueMappings[ARM::GPR3OpsIdx];
    break;
  }
  case G_MUL:
  case G_AND:
  case G_OR:
  case G_XOR:
  case G_LSHR:
  case G_ASHR:
  case G_SHL:
  case G_SDIV:
  case G_UDIV:
  case G_SEXT:
  case G_ZEXT:
  case G_ANYEXT:
  case G_PTR_ADD:
  case G_INTTOPTR:
  case G_PTRTOINT:
  case G_CTLZ:
    // FIXME: We're abusing the fact that everything lives in a GPR for now; in
    // the real world we would use different mappings.
    OperandsMapping = &ARM::ValueMappings[ARM::GPR3OpsIdx];
    break;
  case G_TRUNC: {
    // In some cases we may end up with a G_TRUNC from a 64-bit value to a
    // 32-bit value. This isn't a real floating point trunc (that would be a
    // G_FPTRUNC). Instead it is an integer trunc in disguise, which can appear
    // because the legalizer doesn't distinguish between integer and floating
    // point values so it may leave some 64-bit integers un-narrowed. Until we
    // have a more principled solution that doesn't let such things sneak all
    // the way to this point, just map the source to a DPR and the destination
    // to a GPR.
    LLT LargeTy = MRI.getType(MI.getOperand(1).getReg());
    OperandsMapping =
        LargeTy.getSizeInBits() <= 32
            ? &ARM::ValueMappings[ARM::GPR3OpsIdx]
            : getOperandsMapping({&ARM::ValueMappings[ARM::GPR3OpsIdx],
                                  &ARM::ValueMappings[ARM::DPR3OpsIdx]});
    break;
  }
  case G_LOAD:
  case G_STORE: {
    LLT Ty = MRI.getType(MI.getOperand(0).getReg());
    OperandsMapping =
        Ty.getSizeInBits() == 64
            ? getOperandsMapping({&ARM::ValueMappings[ARM::DPR3OpsIdx],
                                  &ARM::ValueMappings[ARM::GPR3OpsIdx]})
            : &ARM::ValueMappings[ARM::GPR3OpsIdx];
    break;
  }
  case G_FADD:
  case G_FSUB:
  case G_FMUL:
  case G_FDIV:
  case G_FNEG: {
    LLT Ty = MRI.getType(MI.getOperand(0).getReg());
    OperandsMapping =Ty.getSizeInBits() == 64
                          ? &ARM::ValueMappings[ARM::DPR3OpsIdx]
                          : &ARM::ValueMappings[ARM::SPR3OpsIdx];
    break;
  }
  case G_FMA: {
    LLT Ty = MRI.getType(MI.getOperand(0).getReg());
    OperandsMapping =
        Ty.getSizeInBits() == 64
            ? getOperandsMapping({&ARM::ValueMappings[ARM::DPR3OpsIdx],
                                  &ARM::ValueMappings[ARM::DPR3OpsIdx],
                                  &ARM::ValueMappings[ARM::DPR3OpsIdx],
                                  &ARM::ValueMappings[ARM::DPR3OpsIdx]})
            : getOperandsMapping({&ARM::ValueMappings[ARM::SPR3OpsIdx],
                                  &ARM::ValueMappings[ARM::SPR3OpsIdx],
                                  &ARM::ValueMappings[ARM::SPR3OpsIdx],
                                  &ARM::ValueMappings[ARM::SPR3OpsIdx]});
    break;
  }
  case G_FPEXT: {
    LLT ToTy = MRI.getType(MI.getOperand(0).getReg());
    LLT FromTy = MRI.getType(MI.getOperand(1).getReg());
    if (ToTy.getSizeInBits() == 64 && FromTy.getSizeInBits() == 32)
      OperandsMapping =
          getOperandsMapping({&ARM::ValueMappings[ARM::DPR3OpsIdx],
                              &ARM::ValueMappings[ARM::SPR3OpsIdx]});
    break;
  }
  case G_FPTRUNC: {
    LLT ToTy = MRI.getType(MI.getOperand(0).getReg());
    LLT FromTy = MRI.getType(MI.getOperand(1).getReg());
    if (ToTy.getSizeInBits() == 32 && FromTy.getSizeInBits() == 64)
      OperandsMapping =
          getOperandsMapping({&ARM::ValueMappings[ARM::SPR3OpsIdx],
                              &ARM::ValueMappings[ARM::DPR3OpsIdx]});
    break;
  }
  case G_FPTOSI:
  case G_FPTOUI: {
    LLT ToTy = MRI.getType(MI.getOperand(0).getReg());
    LLT FromTy = MRI.getType(MI.getOperand(1).getReg());
    if ((FromTy.getSizeInBits() == 32 || FromTy.getSizeInBits() == 64) &&
        ToTy.getSizeInBits() == 32)
      OperandsMapping =
          FromTy.getSizeInBits() == 64
              ? getOperandsMapping({&ARM::ValueMappings[ARM::GPR3OpsIdx],
                                    &ARM::ValueMappings[ARM::DPR3OpsIdx]})
              : getOperandsMapping({&ARM::ValueMappings[ARM::GPR3OpsIdx],
                                    &ARM::ValueMappings[ARM::SPR3OpsIdx]});
    break;
  }
  case G_SITOFP:
  case G_UITOFP: {
    LLT ToTy = MRI.getType(MI.getOperand(0).getReg());
    LLT FromTy = MRI.getType(MI.getOperand(1).getReg());
    if (FromTy.getSizeInBits() == 32 &&
        (ToTy.getSizeInBits() == 32 || ToTy.getSizeInBits() == 64))
      OperandsMapping =
          ToTy.getSizeInBits() == 64
              ? getOperandsMapping({&ARM::ValueMappings[ARM::DPR3OpsIdx],
                                    &ARM::ValueMappings[ARM::GPR3OpsIdx]})
              : getOperandsMapping({&ARM::ValueMappings[ARM::SPR3OpsIdx],
                                    &ARM::ValueMappings[ARM::GPR3OpsIdx]});
    break;
  }
  case G_FCONSTANT: {
    LLT Ty = MRI.getType(MI.getOperand(0).getReg());
    OperandsMapping = getOperandsMapping(
        {Ty.getSizeInBits() == 64 ? &ARM::ValueMappings[ARM::DPR3OpsIdx]
                                  : &ARM::ValueMappings[ARM::SPR3OpsIdx],
         nullptr});
    break;
  }
  case G_CONSTANT:
  case G_FRAME_INDEX:
  case G_GLOBAL_VALUE:
    OperandsMapping =
        getOperandsMapping({&ARM::ValueMappings[ARM::GPR3OpsIdx], nullptr});
    break;
  case G_SELECT: {
    LLT Ty = MRI.getType(MI.getOperand(0).getReg());
    (void)Ty;
    LLT Ty2 = MRI.getType(MI.getOperand(1).getReg());
    (void)Ty2;
    assert(Ty.getSizeInBits() == 32 && "Unsupported size for G_SELECT");
    assert(Ty2.getSizeInBits() == 1 && "Unsupported size for G_SELECT");
    OperandsMapping =
        getOperandsMapping({&ARM::ValueMappings[ARM::GPR3OpsIdx],
                            &ARM::ValueMappings[ARM::GPR3OpsIdx],
                            &ARM::ValueMappings[ARM::GPR3OpsIdx],
                            &ARM::ValueMappings[ARM::GPR3OpsIdx]});
    break;
  }
  case G_ICMP: {
    LLT Ty2 = MRI.getType(MI.getOperand(2).getReg());
    (void)Ty2;
    assert(Ty2.getSizeInBits() == 32 && "Unsupported size for G_ICMP");
    OperandsMapping =
        getOperandsMapping({&ARM::ValueMappings[ARM::GPR3OpsIdx], nullptr,
                            &ARM::ValueMappings[ARM::GPR3OpsIdx],
                            &ARM::ValueMappings[ARM::GPR3OpsIdx]});
    break;
  }
  case G_FCMP: {
    LLT Ty = MRI.getType(MI.getOperand(0).getReg());
    (void)Ty;
    LLT Ty1 = MRI.getType(MI.getOperand(2).getReg());
    LLT Ty2 = MRI.getType(MI.getOperand(3).getReg());
    (void)Ty2;
    assert(Ty.getSizeInBits() == 1 && "Unsupported size for G_FCMP");
    assert(Ty1.getSizeInBits() == Ty2.getSizeInBits() &&
           "Mismatched operand sizes for G_FCMP");

    unsigned Size = Ty1.getSizeInBits();
    assert((Size == 32 || Size == 64) && "Unsupported size for G_FCMP");

    auto FPRValueMapping = Size == 32 ? &ARM::ValueMappings[ARM::SPR3OpsIdx]
                                      : &ARM::ValueMappings[ARM::DPR3OpsIdx];
    OperandsMapping =
        getOperandsMapping({&ARM::ValueMappings[ARM::GPR3OpsIdx], nullptr,
                            FPRValueMapping, FPRValueMapping});
    break;
  }
  case G_MERGE_VALUES: {
    // We only support G_MERGE_VALUES for creating a double precision floating
    // point value out of two GPRs.
    LLT Ty = MRI.getType(MI.getOperand(0).getReg());
    LLT Ty1 = MRI.getType(MI.getOperand(1).getReg());
    LLT Ty2 = MRI.getType(MI.getOperand(2).getReg());
    if (Ty.getSizeInBits() != 64 || Ty1.getSizeInBits() != 32 ||
        Ty2.getSizeInBits() != 32)
      return getInvalidInstructionMapping();
    OperandsMapping =
        getOperandsMapping({&ARM::ValueMappings[ARM::DPR3OpsIdx],
                            &ARM::ValueMappings[ARM::GPR3OpsIdx],
                            &ARM::ValueMappings[ARM::GPR3OpsIdx]});
    break;
  }
  case G_UNMERGE_VALUES: {
    // We only support G_UNMERGE_VALUES for splitting a double precision
    // floating point value into two GPRs.
    LLT Ty = MRI.getType(MI.getOperand(0).getReg());
    LLT Ty1 = MRI.getType(MI.getOperand(1).getReg());
    LLT Ty2 = MRI.getType(MI.getOperand(2).getReg());
    if (Ty.getSizeInBits() != 32 || Ty1.getSizeInBits() != 32 ||
        Ty2.getSizeInBits() != 64)
      return getInvalidInstructionMapping();
    OperandsMapping =
        getOperandsMapping({&ARM::ValueMappings[ARM::GPR3OpsIdx],
                            &ARM::ValueMappings[ARM::GPR3OpsIdx],
                            &ARM::ValueMappings[ARM::DPR3OpsIdx]});
    break;
  }
  case G_BR:
    OperandsMapping = getOperandsMapping({nullptr});
    break;
  case G_BRCOND:
    OperandsMapping =
        getOperandsMapping({&ARM::ValueMappings[ARM::GPR3OpsIdx], nullptr});
    break;
  case DBG_VALUE: {
    SmallVector<const ValueMapping *, 4> OperandBanks(NumOperands);
    const MachineOperand &MaybeReg = MI.getOperand(0);
    if (MaybeReg.isReg() && MaybeReg.getReg()) {
      unsigned Size = MRI.getType(MaybeReg.getReg()).getSizeInBits();
      if (Size > 32 && Size != 64)
        return getInvalidInstructionMapping();
      OperandBanks[0] = Size == 64 ? &ARM::ValueMappings[ARM::DPR3OpsIdx]
                                   : &ARM::ValueMappings[ARM::GPR3OpsIdx];
    }
    OperandsMapping = getOperandsMapping(OperandBanks);
    break;
  }
  default:
    return getInvalidInstructionMapping();
  }

#ifndef NDEBUG
  for (unsigned i = 0; i < NumOperands; i++) {
    for (const auto &Mapping : OperandsMapping[i]) {
      assert(
          (Mapping.RegBank->getID() != ARM::FPRRegBankID ||
           MF.getSubtarget<ARMSubtarget>().hasVFP2Base()) &&
          "Trying to use floating point register bank on target without vfp");
    }
  }
#endif

  return getInstructionMapping(DefaultMappingID, /*Cost=*/1, OperandsMapping,
                               NumOperands);
}
