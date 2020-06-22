//===- MipsLegalizerInfo.cpp ------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the Machinelegalizer class for Mips.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "MipsLegalizerInfo.h"
#include "MipsTargetMachine.h"
#include "llvm/CodeGen/GlobalISel/LegalizerHelper.h"
#include "llvm/IR/IntrinsicsMips.h"

using namespace llvm;

struct TypesAndMemOps {
  LLT ValTy;
  LLT PtrTy;
  unsigned MemSize;
  bool SystemSupportsUnalignedAccess;
};

// Assumes power of 2 memory size. Subtargets that have only naturally-aligned
// memory access need to perform additional legalization here.
static bool isUnalignedMemmoryAccess(uint64_t MemSize, uint64_t AlignInBits) {
  assert(isPowerOf2_64(MemSize) && "Expected power of 2 memory size");
  assert(isPowerOf2_64(AlignInBits) && "Expected power of 2 align");
  if (MemSize > AlignInBits)
    return true;
  return false;
}

static bool
CheckTy0Ty1MemSizeAlign(const LegalityQuery &Query,
                        std::initializer_list<TypesAndMemOps> SupportedValues) {
  unsigned QueryMemSize = Query.MMODescrs[0].SizeInBits;

  // Non power of two memory access is never legal.
  if (!isPowerOf2_64(QueryMemSize))
    return false;

  for (auto &Val : SupportedValues) {
    if (Val.ValTy != Query.Types[0])
      continue;
    if (Val.PtrTy != Query.Types[1])
      continue;
    if (Val.MemSize != QueryMemSize)
      continue;
    if (!Val.SystemSupportsUnalignedAccess &&
        isUnalignedMemmoryAccess(QueryMemSize, Query.MMODescrs[0].AlignInBits))
      return false;
    return true;
  }
  return false;
}

static bool CheckTyN(unsigned N, const LegalityQuery &Query,
                     std::initializer_list<LLT> SupportedValues) {
  for (auto &Val : SupportedValues)
    if (Val == Query.Types[N])
      return true;
  return false;
}

MipsLegalizerInfo::MipsLegalizerInfo(const MipsSubtarget &ST) {
  using namespace TargetOpcode;

  const LLT s1 = LLT::scalar(1);
  const LLT s32 = LLT::scalar(32);
  const LLT s64 = LLT::scalar(64);
  const LLT v16s8 = LLT::vector(16, 8);
  const LLT v8s16 = LLT::vector(8, 16);
  const LLT v4s32 = LLT::vector(4, 32);
  const LLT v2s64 = LLT::vector(2, 64);
  const LLT p0 = LLT::pointer(0, 32);

  getActionDefinitionsBuilder({G_ADD, G_SUB, G_MUL})
      .legalIf([=, &ST](const LegalityQuery &Query) {
        if (CheckTyN(0, Query, {s32}))
          return true;
        if (ST.hasMSA() && CheckTyN(0, Query, {v16s8, v8s16, v4s32, v2s64}))
          return true;
        return false;
      })
      .clampScalar(0, s32, s32);

  getActionDefinitionsBuilder({G_UADDO, G_UADDE, G_USUBO, G_USUBE, G_UMULO})
      .lowerFor({{s32, s1}});

  getActionDefinitionsBuilder(G_UMULH)
      .legalFor({s32})
      .maxScalar(0, s32);

  // MIPS32r6 does not have alignment restrictions for memory access.
  // For MIPS32r5 and older memory access must be naturally-aligned i.e. aligned
  // to at least a multiple of its own size. There is however a two instruction
  // combination that performs 4 byte unaligned access (lwr/lwl and swl/swr)
  // therefore 4 byte load and store are legal and will use NoAlignRequirements.
  bool NoAlignRequirements = true;

  getActionDefinitionsBuilder({G_LOAD, G_STORE})
      .legalIf([=, &ST](const LegalityQuery &Query) {
        if (CheckTy0Ty1MemSizeAlign(
                Query, {{s32, p0, 8, NoAlignRequirements},
                        {s32, p0, 16, ST.systemSupportsUnalignedAccess()},
                        {s32, p0, 32, NoAlignRequirements},
                        {p0, p0, 32, NoAlignRequirements},
                        {s64, p0, 64, ST.systemSupportsUnalignedAccess()}}))
          return true;
        if (ST.hasMSA() && CheckTy0Ty1MemSizeAlign(
                               Query, {{v16s8, p0, 128, NoAlignRequirements},
                                       {v8s16, p0, 128, NoAlignRequirements},
                                       {v4s32, p0, 128, NoAlignRequirements},
                                       {v2s64, p0, 128, NoAlignRequirements}}))
          return true;
        return false;
      })
      // Custom lower scalar memory access, up to 8 bytes, for:
      // - non-power-of-2 MemSizes
      // - unaligned 2 or 8 byte MemSizes for MIPS32r5 and older
      .customIf([=, &ST](const LegalityQuery &Query) {
        if (!Query.Types[0].isScalar() || Query.Types[1] != p0 ||
            Query.Types[0] == s1)
          return false;

        unsigned Size = Query.Types[0].getSizeInBits();
        unsigned QueryMemSize = Query.MMODescrs[0].SizeInBits;
        assert(QueryMemSize <= Size && "Scalar can't hold MemSize");

        if (Size > 64 || QueryMemSize > 64)
          return false;

        if (!isPowerOf2_64(Query.MMODescrs[0].SizeInBits))
          return true;

        if (!ST.systemSupportsUnalignedAccess() &&
            isUnalignedMemmoryAccess(QueryMemSize,
                                     Query.MMODescrs[0].AlignInBits)) {
          assert(QueryMemSize != 32 && "4 byte load and store are legal");
          return true;
        }

        return false;
      })
      .minScalar(0, s32);

  getActionDefinitionsBuilder(G_IMPLICIT_DEF)
      .legalFor({s32, s64});

  getActionDefinitionsBuilder(G_UNMERGE_VALUES)
     .legalFor({{s32, s64}});

  getActionDefinitionsBuilder(G_MERGE_VALUES)
     .legalFor({{s64, s32}});

  getActionDefinitionsBuilder({G_ZEXTLOAD, G_SEXTLOAD})
      .legalForTypesWithMemDesc({{s32, p0, 8, 8},
                                 {s32, p0, 16, 8}})
      .clampScalar(0, s32, s32);

  getActionDefinitionsBuilder({G_ZEXT, G_SEXT, G_ANYEXT})
      .legalIf([](const LegalityQuery &Query) { return false; })
      .maxScalar(0, s32);

  getActionDefinitionsBuilder(G_TRUNC)
      .legalIf([](const LegalityQuery &Query) { return false; })
      .maxScalar(1, s32);

  getActionDefinitionsBuilder(G_SELECT)
      .legalForCartesianProduct({p0, s32, s64}, {s32})
      .minScalar(0, s32)
      .minScalar(1, s32);

  getActionDefinitionsBuilder(G_BRCOND)
      .legalFor({s32})
      .minScalar(0, s32);

  getActionDefinitionsBuilder(G_BRJT)
      .legalFor({{p0, s32}});

  getActionDefinitionsBuilder(G_BRINDIRECT)
      .legalFor({p0});

  getActionDefinitionsBuilder(G_PHI)
      .legalFor({p0, s32, s64})
      .minScalar(0, s32);

  getActionDefinitionsBuilder({G_AND, G_OR, G_XOR})
      .legalFor({s32})
      .clampScalar(0, s32, s32);

  getActionDefinitionsBuilder({G_SDIV, G_SREM, G_UDIV, G_UREM})
      .legalIf([=, &ST](const LegalityQuery &Query) {
        if (CheckTyN(0, Query, {s32}))
          return true;
        if (ST.hasMSA() && CheckTyN(0, Query, {v16s8, v8s16, v4s32, v2s64}))
          return true;
        return false;
      })
      .minScalar(0, s32)
      .libcallFor({s64});

  getActionDefinitionsBuilder({G_SHL, G_ASHR, G_LSHR})
      .legalFor({{s32, s32}})
      .clampScalar(1, s32, s32)
      .clampScalar(0, s32, s32);

  getActionDefinitionsBuilder(G_ICMP)
      .legalForCartesianProduct({s32}, {s32, p0})
      .clampScalar(1, s32, s32)
      .minScalar(0, s32);

  getActionDefinitionsBuilder(G_CONSTANT)
      .legalFor({s32})
      .clampScalar(0, s32, s32);

  getActionDefinitionsBuilder({G_PTR_ADD, G_INTTOPTR})
      .legalFor({{p0, s32}});

  getActionDefinitionsBuilder(G_PTRTOINT)
      .legalFor({{s32, p0}});

  getActionDefinitionsBuilder(G_FRAME_INDEX)
      .legalFor({p0});

  getActionDefinitionsBuilder({G_GLOBAL_VALUE, G_JUMP_TABLE})
      .legalFor({p0});

  getActionDefinitionsBuilder(G_DYN_STACKALLOC)
      .lowerFor({{p0, s32}});

  getActionDefinitionsBuilder(G_VASTART)
     .legalFor({p0});

  getActionDefinitionsBuilder(G_BSWAP)
      .legalIf([=, &ST](const LegalityQuery &Query) {
        if (ST.hasMips32r2() && CheckTyN(0, Query, {s32}))
          return true;
        return false;
      })
      .lowerIf([=, &ST](const LegalityQuery &Query) {
        if (!ST.hasMips32r2() && CheckTyN(0, Query, {s32}))
          return true;
        return false;
      })
      .maxScalar(0, s32);

  getActionDefinitionsBuilder(G_BITREVERSE)
      .lowerFor({s32})
      .maxScalar(0, s32);

  getActionDefinitionsBuilder(G_CTLZ)
      .legalFor({{s32, s32}})
      .maxScalar(0, s32)
      .maxScalar(1, s32);
  getActionDefinitionsBuilder(G_CTLZ_ZERO_UNDEF)
      .lowerFor({{s32, s32}});

  getActionDefinitionsBuilder(G_CTTZ)
      .lowerFor({{s32, s32}})
      .maxScalar(0, s32)
      .maxScalar(1, s32);
  getActionDefinitionsBuilder(G_CTTZ_ZERO_UNDEF)
      .lowerFor({{s32, s32}, {s64, s64}});

  getActionDefinitionsBuilder(G_CTPOP)
      .lowerFor({{s32, s32}})
      .clampScalar(0, s32, s32)
      .clampScalar(1, s32, s32);

  // FP instructions
  getActionDefinitionsBuilder(G_FCONSTANT)
      .legalFor({s32, s64});

  getActionDefinitionsBuilder({G_FADD, G_FSUB, G_FMUL, G_FDIV, G_FABS, G_FSQRT})
      .legalIf([=, &ST](const LegalityQuery &Query) {
        if (CheckTyN(0, Query, {s32, s64}))
          return true;
        if (ST.hasMSA() && CheckTyN(0, Query, {v16s8, v8s16, v4s32, v2s64}))
          return true;
        return false;
      });

  getActionDefinitionsBuilder(G_FCMP)
      .legalFor({{s32, s32}, {s32, s64}})
      .minScalar(0, s32);

  getActionDefinitionsBuilder({G_FCEIL, G_FFLOOR})
      .libcallFor({s32, s64});

  getActionDefinitionsBuilder(G_FPEXT)
      .legalFor({{s64, s32}});

  getActionDefinitionsBuilder(G_FPTRUNC)
      .legalFor({{s32, s64}});

  // FP to int conversion instructions
  getActionDefinitionsBuilder(G_FPTOSI)
      .legalForCartesianProduct({s32}, {s64, s32})
      .libcallForCartesianProduct({s64}, {s64, s32})
      .minScalar(0, s32);

  getActionDefinitionsBuilder(G_FPTOUI)
      .libcallForCartesianProduct({s64}, {s64, s32})
      .lowerForCartesianProduct({s32}, {s64, s32})
      .minScalar(0, s32);

  // Int to FP conversion instructions
  getActionDefinitionsBuilder(G_SITOFP)
      .legalForCartesianProduct({s64, s32}, {s32})
      .libcallForCartesianProduct({s64, s32}, {s64})
      .minScalar(1, s32);

  getActionDefinitionsBuilder(G_UITOFP)
      .libcallForCartesianProduct({s64, s32}, {s64})
      .customForCartesianProduct({s64, s32}, {s32})
      .minScalar(1, s32);

  getActionDefinitionsBuilder(G_SEXT_INREG).lower();

  computeTables();
  verify(*ST.getInstrInfo());
}

bool MipsLegalizerInfo::legalizeCustom(LegalizerHelper &Helper,
                                       MachineInstr &MI) const {
  using namespace TargetOpcode;

  MachineIRBuilder &MIRBuilder = Helper.MIRBuilder;
  MachineRegisterInfo &MRI = *MIRBuilder.getMRI();

  const LLT s32 = LLT::scalar(32);
  const LLT s64 = LLT::scalar(64);

  switch (MI.getOpcode()) {
  case G_LOAD:
  case G_STORE: {
    unsigned MemSize = (**MI.memoperands_begin()).getSize();
    Register Val = MI.getOperand(0).getReg();
    unsigned Size = MRI.getType(Val).getSizeInBits();

    MachineMemOperand *MMOBase = *MI.memoperands_begin();

    assert(MemSize <= 8 && "MemSize is too large");
    assert(Size <= 64 && "Scalar size is too large");

    // Split MemSize into two, P2HalfMemSize is largest power of two smaller
    // then MemSize. e.g. 8 = 4 + 4 , 6 = 4 + 2, 3 = 2 + 1.
    unsigned P2HalfMemSize, RemMemSize;
    if (isPowerOf2_64(MemSize)) {
      P2HalfMemSize = RemMemSize = MemSize / 2;
    } else {
      P2HalfMemSize = 1 << Log2_32(MemSize);
      RemMemSize = MemSize - P2HalfMemSize;
    }

    Register BaseAddr = MI.getOperand(1).getReg();
    LLT PtrTy = MRI.getType(BaseAddr);
    MachineFunction &MF = MIRBuilder.getMF();

    auto P2HalfMemOp = MF.getMachineMemOperand(MMOBase, 0, P2HalfMemSize);
    auto RemMemOp = MF.getMachineMemOperand(MMOBase, P2HalfMemSize, RemMemSize);

    if (MI.getOpcode() == G_STORE) {
      // Widen Val to s32 or s64 in order to create legal G_LSHR or G_UNMERGE.
      if (Size < 32)
        Val = MIRBuilder.buildAnyExt(s32, Val).getReg(0);
      if (Size > 32 && Size < 64)
        Val = MIRBuilder.buildAnyExt(s64, Val).getReg(0);

      auto C_P2HalfMemSize = MIRBuilder.buildConstant(s32, P2HalfMemSize);
      auto Addr = MIRBuilder.buildPtrAdd(PtrTy, BaseAddr, C_P2HalfMemSize);

      if (MI.getOpcode() == G_STORE && MemSize <= 4) {
        MIRBuilder.buildStore(Val, BaseAddr, *P2HalfMemOp);
        auto C_P2Half_InBits = MIRBuilder.buildConstant(s32, P2HalfMemSize * 8);
        auto Shift = MIRBuilder.buildLShr(s32, Val, C_P2Half_InBits);
        MIRBuilder.buildStore(Shift, Addr, *RemMemOp);
      } else {
        auto Unmerge = MIRBuilder.buildUnmerge(s32, Val);
        MIRBuilder.buildStore(Unmerge.getReg(0), BaseAddr, *P2HalfMemOp);
        MIRBuilder.buildStore(Unmerge.getReg(1), Addr, *RemMemOp);
      }
    }

    if (MI.getOpcode() == G_LOAD) {

      if (MemSize <= 4) {
        // This is anyextending load, use 4 byte lwr/lwl.
        auto *Load4MMO = MF.getMachineMemOperand(MMOBase, 0, 4);

        if (Size == 32)
          MIRBuilder.buildLoad(Val, BaseAddr, *Load4MMO);
        else {
          auto Load = MIRBuilder.buildLoad(s32, BaseAddr, *Load4MMO);
          MIRBuilder.buildTrunc(Val, Load.getReg(0));
        }

      } else {
        auto C_P2HalfMemSize = MIRBuilder.buildConstant(s32, P2HalfMemSize);
        auto Addr = MIRBuilder.buildPtrAdd(PtrTy, BaseAddr, C_P2HalfMemSize);

        auto Load_P2Half = MIRBuilder.buildLoad(s32, BaseAddr, *P2HalfMemOp);
        auto Load_Rem = MIRBuilder.buildLoad(s32, Addr, *RemMemOp);

        if (Size == 64)
          MIRBuilder.buildMerge(Val, {Load_P2Half, Load_Rem});
        else {
          auto Merge = MIRBuilder.buildMerge(s64, {Load_P2Half, Load_Rem});
          MIRBuilder.buildTrunc(Val, Merge);
        }
      }
    }
    MI.eraseFromParent();
    break;
  }
  case G_UITOFP: {
    Register Dst = MI.getOperand(0).getReg();
    Register Src = MI.getOperand(1).getReg();
    LLT DstTy = MRI.getType(Dst);
    LLT SrcTy = MRI.getType(Src);

    if (SrcTy != s32)
      return false;
    if (DstTy != s32 && DstTy != s64)
      return false;

    // Let 0xABCDEFGH be given unsigned in MI.getOperand(1). First let's convert
    // unsigned to double. Mantissa has 52 bits so we use following trick:
    // First make floating point bit mask 0x43300000ABCDEFGH.
    // Mask represents 2^52 * 0x1.00000ABCDEFGH i.e. 0x100000ABCDEFGH.0 .
    // Next, subtract  2^52 * 0x1.0000000000000 i.e. 0x10000000000000.0 from it.
    // Done. Trunc double to float if needed.

    auto C_HiMask = MIRBuilder.buildConstant(s32, UINT32_C(0x43300000));
    auto Bitcast = MIRBuilder.buildMerge(s64, {Src, C_HiMask.getReg(0)});

    MachineInstrBuilder TwoP52FP = MIRBuilder.buildFConstant(
        s64, BitsToDouble(UINT64_C(0x4330000000000000)));

    if (DstTy == s64)
      MIRBuilder.buildFSub(Dst, Bitcast, TwoP52FP);
    else {
      MachineInstrBuilder ResF64 = MIRBuilder.buildFSub(s64, Bitcast, TwoP52FP);
      MIRBuilder.buildFPTrunc(Dst, ResF64);
    }

    MI.eraseFromParent();
    break;
  }
  default:
    return false;
  }

  return true;
}

static bool SelectMSA3OpIntrinsic(MachineInstr &MI, unsigned Opcode,
                                  MachineIRBuilder &MIRBuilder,
                                  const MipsSubtarget &ST) {
  assert(ST.hasMSA() && "MSA intrinsic not supported on target without MSA.");
  if (!MIRBuilder.buildInstr(Opcode)
           .add(MI.getOperand(0))
           .add(MI.getOperand(2))
           .add(MI.getOperand(3))
           .constrainAllUses(MIRBuilder.getTII(), *ST.getRegisterInfo(),
                             *ST.getRegBankInfo()))
    return false;
  MI.eraseFromParent();
  return true;
}

static bool MSA3OpIntrinsicToGeneric(MachineInstr &MI, unsigned Opcode,
                                     MachineIRBuilder &MIRBuilder,
                                     const MipsSubtarget &ST) {
  assert(ST.hasMSA() && "MSA intrinsic not supported on target without MSA.");
  MIRBuilder.buildInstr(Opcode)
      .add(MI.getOperand(0))
      .add(MI.getOperand(2))
      .add(MI.getOperand(3));
  MI.eraseFromParent();
  return true;
}

static bool MSA2OpIntrinsicToGeneric(MachineInstr &MI, unsigned Opcode,
                                     MachineIRBuilder &MIRBuilder,
                                     const MipsSubtarget &ST) {
  assert(ST.hasMSA() && "MSA intrinsic not supported on target without MSA.");
  MIRBuilder.buildInstr(Opcode)
      .add(MI.getOperand(0))
      .add(MI.getOperand(2));
  MI.eraseFromParent();
  return true;
}

bool MipsLegalizerInfo::legalizeIntrinsic(LegalizerHelper &Helper,
                                          MachineInstr &MI) const {
  MachineIRBuilder &MIRBuilder = Helper.MIRBuilder;
  MachineRegisterInfo &MRI = *MIRBuilder.getMRI();
  const MipsSubtarget &ST =
      static_cast<const MipsSubtarget &>(MI.getMF()->getSubtarget());
  const MipsInstrInfo &TII = *ST.getInstrInfo();
  const MipsRegisterInfo &TRI = *ST.getRegisterInfo();
  const RegisterBankInfo &RBI = *ST.getRegBankInfo();

  switch (MI.getIntrinsicID()) {
  case Intrinsic::memcpy:
  case Intrinsic::memset:
  case Intrinsic::memmove:
    if (createMemLibcall(MIRBuilder, MRI, MI) ==
        LegalizerHelper::UnableToLegalize)
      return false;
    MI.eraseFromParent();
    return true;
  case Intrinsic::trap: {
    MachineInstr *Trap = MIRBuilder.buildInstr(Mips::TRAP);
    MI.eraseFromParent();
    return constrainSelectedInstRegOperands(*Trap, TII, TRI, RBI);
  }
  case Intrinsic::vacopy: {
    MachinePointerInfo MPO;
    auto Tmp =
        MIRBuilder.buildLoad(LLT::pointer(0, 32), MI.getOperand(2),
                             *MI.getMF()->getMachineMemOperand(
                                 MPO, MachineMemOperand::MOLoad, 4, Align(4)));
    MIRBuilder.buildStore(Tmp, MI.getOperand(1),
                          *MI.getMF()->getMachineMemOperand(
                              MPO, MachineMemOperand::MOStore, 4, Align(4)));
    MI.eraseFromParent();
    return true;
  }
  case Intrinsic::mips_addv_b:
  case Intrinsic::mips_addv_h:
  case Intrinsic::mips_addv_w:
  case Intrinsic::mips_addv_d:
    return MSA3OpIntrinsicToGeneric(MI, TargetOpcode::G_ADD, MIRBuilder, ST);
  case Intrinsic::mips_addvi_b:
    return SelectMSA3OpIntrinsic(MI, Mips::ADDVI_B, MIRBuilder, ST);
  case Intrinsic::mips_addvi_h:
    return SelectMSA3OpIntrinsic(MI, Mips::ADDVI_H, MIRBuilder, ST);
  case Intrinsic::mips_addvi_w:
    return SelectMSA3OpIntrinsic(MI, Mips::ADDVI_W, MIRBuilder, ST);
  case Intrinsic::mips_addvi_d:
    return SelectMSA3OpIntrinsic(MI, Mips::ADDVI_D, MIRBuilder, ST);
  case Intrinsic::mips_subv_b:
  case Intrinsic::mips_subv_h:
  case Intrinsic::mips_subv_w:
  case Intrinsic::mips_subv_d:
    return MSA3OpIntrinsicToGeneric(MI, TargetOpcode::G_SUB, MIRBuilder, ST);
  case Intrinsic::mips_subvi_b:
    return SelectMSA3OpIntrinsic(MI, Mips::SUBVI_B, MIRBuilder, ST);
  case Intrinsic::mips_subvi_h:
    return SelectMSA3OpIntrinsic(MI, Mips::SUBVI_H, MIRBuilder, ST);
  case Intrinsic::mips_subvi_w:
    return SelectMSA3OpIntrinsic(MI, Mips::SUBVI_W, MIRBuilder, ST);
  case Intrinsic::mips_subvi_d:
    return SelectMSA3OpIntrinsic(MI, Mips::SUBVI_D, MIRBuilder, ST);
  case Intrinsic::mips_mulv_b:
  case Intrinsic::mips_mulv_h:
  case Intrinsic::mips_mulv_w:
  case Intrinsic::mips_mulv_d:
    return MSA3OpIntrinsicToGeneric(MI, TargetOpcode::G_MUL, MIRBuilder, ST);
  case Intrinsic::mips_div_s_b:
  case Intrinsic::mips_div_s_h:
  case Intrinsic::mips_div_s_w:
  case Intrinsic::mips_div_s_d:
    return MSA3OpIntrinsicToGeneric(MI, TargetOpcode::G_SDIV, MIRBuilder, ST);
  case Intrinsic::mips_mod_s_b:
  case Intrinsic::mips_mod_s_h:
  case Intrinsic::mips_mod_s_w:
  case Intrinsic::mips_mod_s_d:
    return MSA3OpIntrinsicToGeneric(MI, TargetOpcode::G_SREM, MIRBuilder, ST);
  case Intrinsic::mips_div_u_b:
  case Intrinsic::mips_div_u_h:
  case Intrinsic::mips_div_u_w:
  case Intrinsic::mips_div_u_d:
    return MSA3OpIntrinsicToGeneric(MI, TargetOpcode::G_UDIV, MIRBuilder, ST);
  case Intrinsic::mips_mod_u_b:
  case Intrinsic::mips_mod_u_h:
  case Intrinsic::mips_mod_u_w:
  case Intrinsic::mips_mod_u_d:
    return MSA3OpIntrinsicToGeneric(MI, TargetOpcode::G_UREM, MIRBuilder, ST);
  case Intrinsic::mips_fadd_w:
  case Intrinsic::mips_fadd_d:
    return MSA3OpIntrinsicToGeneric(MI, TargetOpcode::G_FADD, MIRBuilder, ST);
  case Intrinsic::mips_fsub_w:
  case Intrinsic::mips_fsub_d:
    return MSA3OpIntrinsicToGeneric(MI, TargetOpcode::G_FSUB, MIRBuilder, ST);
  case Intrinsic::mips_fmul_w:
  case Intrinsic::mips_fmul_d:
    return MSA3OpIntrinsicToGeneric(MI, TargetOpcode::G_FMUL, MIRBuilder, ST);
  case Intrinsic::mips_fdiv_w:
  case Intrinsic::mips_fdiv_d:
    return MSA3OpIntrinsicToGeneric(MI, TargetOpcode::G_FDIV, MIRBuilder, ST);
  case Intrinsic::mips_fmax_a_w:
    return SelectMSA3OpIntrinsic(MI, Mips::FMAX_A_W, MIRBuilder, ST);
  case Intrinsic::mips_fmax_a_d:
    return SelectMSA3OpIntrinsic(MI, Mips::FMAX_A_D, MIRBuilder, ST);
  case Intrinsic::mips_fsqrt_w:
    return MSA2OpIntrinsicToGeneric(MI, TargetOpcode::G_FSQRT, MIRBuilder, ST);
  case Intrinsic::mips_fsqrt_d:
    return MSA2OpIntrinsicToGeneric(MI, TargetOpcode::G_FSQRT, MIRBuilder, ST);
  default:
    break;
  }
  return true;
}
