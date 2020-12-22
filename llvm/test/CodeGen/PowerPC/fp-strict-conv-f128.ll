; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s -mtriple=powerpc64-unknown-linux -mcpu=pwr8 | FileCheck %s\
; RUN:   -check-prefix=P8
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s -mtriple=powerpc64le-unknown-linux -mcpu=pwr9 | FileCheck %s \
; RUN:   -check-prefix=P9
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s -mtriple=powerpc64le-unknown-linux -mcpu=pwr8 -enable-soft-fp128 -mattr=-vsx \
; RUN:   | FileCheck %s -check-prefix=NOVSX

declare i1 @llvm.experimental.constrained.fptosi.i1.f128(fp128, metadata)
declare i32 @llvm.experimental.constrained.fptosi.i32.f128(fp128, metadata)
declare i64 @llvm.experimental.constrained.fptosi.i64.f128(fp128, metadata)
declare i64 @llvm.experimental.constrained.fptoui.i64.f128(fp128, metadata)
declare i32 @llvm.experimental.constrained.fptoui.i32.f128(fp128, metadata)
declare i1 @llvm.experimental.constrained.fptoui.i1.f128(fp128, metadata)

declare i1 @llvm.experimental.constrained.fptosi.i1.ppcf128(ppc_fp128, metadata)
declare i32 @llvm.experimental.constrained.fptosi.i32.ppcf128(ppc_fp128, metadata)
declare i64 @llvm.experimental.constrained.fptosi.i64.ppcf128(ppc_fp128, metadata)
declare i64 @llvm.experimental.constrained.fptoui.i64.ppcf128(ppc_fp128, metadata)
declare i32 @llvm.experimental.constrained.fptoui.i32.ppcf128(ppc_fp128, metadata)
declare i1 @llvm.experimental.constrained.fptoui.i1.ppcf128(ppc_fp128, metadata)

declare i128 @llvm.experimental.constrained.fptosi.i128.ppcf128(ppc_fp128, metadata)
declare i128 @llvm.experimental.constrained.fptoui.i128.ppcf128(ppc_fp128, metadata)
declare i128 @llvm.experimental.constrained.fptosi.i128.f128(fp128, metadata)
declare i128 @llvm.experimental.constrained.fptoui.i128.f128(fp128, metadata)

declare fp128 @llvm.experimental.constrained.sitofp.f128.i1(i1, metadata, metadata)
declare fp128 @llvm.experimental.constrained.sitofp.f128.i32(i32, metadata, metadata)
declare fp128 @llvm.experimental.constrained.sitofp.f128.i64(i64, metadata, metadata)
declare fp128 @llvm.experimental.constrained.uitofp.f128.i1(i1, metadata, metadata)
declare fp128 @llvm.experimental.constrained.uitofp.f128.i32(i32, metadata, metadata)
declare fp128 @llvm.experimental.constrained.uitofp.f128.i64(i64, metadata, metadata)

declare ppc_fp128 @llvm.experimental.constrained.sitofp.ppcf128.i1(i1, metadata, metadata)
declare ppc_fp128 @llvm.experimental.constrained.sitofp.ppcf128.i32(i32, metadata, metadata)
declare ppc_fp128 @llvm.experimental.constrained.sitofp.ppcf128.i64(i64, metadata, metadata)
declare ppc_fp128 @llvm.experimental.constrained.uitofp.ppcf128.i1(i1, metadata, metadata)
declare ppc_fp128 @llvm.experimental.constrained.uitofp.ppcf128.i32(i32, metadata, metadata)
declare ppc_fp128 @llvm.experimental.constrained.uitofp.ppcf128.i64(i64, metadata, metadata)

define i128 @q_to_i128(fp128 %m) #0 {
; P8-LABEL: q_to_i128:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixkfti
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_i128:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __fixkfti
; P9-NEXT:    nop
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_i128:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixkfti
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i128 @llvm.experimental.constrained.fptosi.i128.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i128 %conv
}

define i128 @q_to_u128(fp128 %m) #0 {
; P8-LABEL: q_to_u128:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixunskfti
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_u128:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __fixunskfti
; P9-NEXT:    nop
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_u128:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixunskfti
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i128 @llvm.experimental.constrained.fptoui.i128.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i128 %conv
}

define i1 @q_to_s1(fp128 %m) #0 {
; P8-LABEL: q_to_s1:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixkfsi
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_s1:
; P9:       # %bb.0: # %entry
; P9-NEXT:    xscvqpswz v2, v2
; P9-NEXT:    mfvsrwz r3, v2
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_s1:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixkfsi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i1 @llvm.experimental.constrained.fptosi.i1.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i1 %conv
}

define i1 @q_to_u1(fp128 %m) #0 {
; P8-LABEL: q_to_u1:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixunskfsi
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_u1:
; P9:       # %bb.0: # %entry
; P9-NEXT:    xscvqpswz v2, v2
; P9-NEXT:    mfvsrwz r3, v2
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_u1:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixkfsi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i1 @llvm.experimental.constrained.fptoui.i1.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i1 %conv
}

define i128 @ppcq_to_i128(ppc_fp128 %m) #0 {
; P8-LABEL: ppcq_to_i128:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixtfti
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: ppcq_to_i128:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __fixtfti
; P9-NEXT:    nop
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: ppcq_to_i128:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixtfti
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i128 @llvm.experimental.constrained.fptosi.i128.ppcf128(ppc_fp128 %m, metadata !"fpexcept.strict") #0
  ret i128 %conv
}

define i128 @ppcq_to_u128(ppc_fp128 %m) #0 {
; P8-LABEL: ppcq_to_u128:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixtfti
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: ppcq_to_u128:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __fixtfti
; P9-NEXT:    nop
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: ppcq_to_u128:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixtfti
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i128 @llvm.experimental.constrained.fptosi.i128.ppcf128(ppc_fp128 %m, metadata !"fpexcept.strict") #0
  ret i128 %conv
}

define signext i32 @q_to_i32(fp128 %m) #0 {
; P8-LABEL: q_to_i32:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixkfsi
; P8-NEXT:    nop
; P8-NEXT:    extsw r3, r3
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_i32:
; P9:       # %bb.0: # %entry
; P9-NEXT:    xscvqpswz v2, v2
; P9-NEXT:    mfvsrwz r3, v2
; P9-NEXT:    extsw r3, r3
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_i32:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixkfsi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    extsw r3, r3
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i32 @llvm.experimental.constrained.fptosi.i32.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i32 %conv
}

define i64 @q_to_i64(fp128 %m) #0 {
; P8-LABEL: q_to_i64:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixkfdi
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_i64:
; P9:       # %bb.0: # %entry
; P9-NEXT:    xscvqpsdz v2, v2
; P9-NEXT:    mfvsrd r3, v2
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_i64:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixkfdi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i64 @llvm.experimental.constrained.fptosi.i64.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i64 %conv
}

define i64 @q_to_u64(fp128 %m) #0 {
; P8-LABEL: q_to_u64:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixunskfdi
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_u64:
; P9:       # %bb.0: # %entry
; P9-NEXT:    xscvqpudz v2, v2
; P9-NEXT:    mfvsrd r3, v2
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_u64:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixunskfdi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i64 @llvm.experimental.constrained.fptoui.i64.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i64 %conv
}

define zeroext i32 @q_to_u32(fp128 %m) #0 {
; P8-LABEL: q_to_u32:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixunskfsi
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: q_to_u32:
; P9:       # %bb.0: # %entry
; P9-NEXT:    xscvqpuwz v2, v2
; P9-NEXT:    mfvsrwz r3, v2
; P9-NEXT:    clrldi r3, r3, 32
; P9-NEXT:    blr
;
; NOVSX-LABEL: q_to_u32:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixunskfsi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i32 @llvm.experimental.constrained.fptoui.i32.f128(fp128 %m, metadata !"fpexcept.strict") #0
  ret i32 %conv
}

define signext i32 @ppcq_to_i32(ppc_fp128 %m) #0 {
; P8-LABEL: ppcq_to_i32:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mffs f0
; P8-NEXT:    mtfsb1 31
; P8-NEXT:    mtfsb0 30
; P8-NEXT:    fadd f1, f2, f1
; P8-NEXT:    mtfsf 1, f0
; P8-NEXT:    xscvdpsxws f0, f1
; P8-NEXT:    mffprwz r3, f0
; P8-NEXT:    extsw r3, r3
; P8-NEXT:    blr
;
; P9-LABEL: ppcq_to_i32:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mffs f0
; P9-NEXT:    mtfsb1 31
; P9-NEXT:    mtfsb0 30
; P9-NEXT:    fadd f1, f2, f1
; P9-NEXT:    mtfsf 1, f0
; P9-NEXT:    xscvdpsxws f0, f1
; P9-NEXT:    mffprwz r3, f0
; P9-NEXT:    extsw r3, r3
; P9-NEXT:    blr
;
; NOVSX-LABEL: ppcq_to_i32:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mffs f0
; NOVSX-NEXT:    mtfsb1 31
; NOVSX-NEXT:    addi r3, r1, -4
; NOVSX-NEXT:    mtfsb0 30
; NOVSX-NEXT:    fadd f1, f2, f1
; NOVSX-NEXT:    mtfsf 1, f0
; NOVSX-NEXT:    fctiwz f0, f1
; NOVSX-NEXT:    stfiwx f0, 0, r3
; NOVSX-NEXT:    lwa r3, -4(r1)
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i32 @llvm.experimental.constrained.fptosi.i32.ppcf128(ppc_fp128 %m, metadata !"fpexcept.strict") #0
  ret i32 %conv
}

define i64 @ppcq_to_i64(ppc_fp128 %m) #0 {
; P8-LABEL: ppcq_to_i64:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixtfdi
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: ppcq_to_i64:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __fixtfdi
; P9-NEXT:    nop
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: ppcq_to_i64:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixtfdi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i64 @llvm.experimental.constrained.fptosi.i64.ppcf128(ppc_fp128 %m, metadata !"fpexcept.strict") #0
  ret i64 %conv
}

define i64 @ppcq_to_u64(ppc_fp128 %m) #0 {
; P8-LABEL: ppcq_to_u64:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __fixunstfdi
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: ppcq_to_u64:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -32(r1)
; P9-NEXT:    .cfi_def_cfa_offset 32
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    bl __fixunstfdi
; P9-NEXT:    nop
; P9-NEXT:    addi r1, r1, 32
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: ppcq_to_u64:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __fixunstfdi
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i64 @llvm.experimental.constrained.fptoui.i64.ppcf128(ppc_fp128 %m, metadata !"fpexcept.strict") #0
  ret i64 %conv
}

define zeroext i32 @ppcq_to_u32(ppc_fp128 %m) #0 {
; P8-LABEL: ppcq_to_u32:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -128(r1)
; P8-NEXT:    .cfi_def_cfa_offset 128
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    .cfi_offset r30, -16
; P8-NEXT:    addis r3, r2, .LCPI13_0@toc@ha
; P8-NEXT:    xxlxor f3, f3, f3
; P8-NEXT:    std r30, 112(r1) # 8-byte Folded Spill
; P8-NEXT:    lfs f0, .LCPI13_0@toc@l(r3)
; P8-NEXT:    fcmpo cr0, f2, f3
; P8-NEXT:    lis r3, -32768
; P8-NEXT:    xxlxor f3, f3, f3
; P8-NEXT:    fcmpo cr1, f1, f0
; P8-NEXT:    crand 4*cr5+lt, 4*cr1+eq, lt
; P8-NEXT:    crandc 4*cr5+gt, 4*cr1+lt, 4*cr1+eq
; P8-NEXT:    cror 4*cr5+lt, 4*cr5+gt, 4*cr5+lt
; P8-NEXT:    isel r30, 0, r3, 4*cr5+lt
; P8-NEXT:    bc 12, 4*cr5+lt, .LBB13_2
; P8-NEXT:  # %bb.1: # %entry
; P8-NEXT:    fmr f3, f0
; P8-NEXT:  .LBB13_2: # %entry
; P8-NEXT:    xxlxor f4, f4, f4
; P8-NEXT:    bl __gcc_qsub
; P8-NEXT:    nop
; P8-NEXT:    mffs f0
; P8-NEXT:    mtfsb1 31
; P8-NEXT:    mtfsb0 30
; P8-NEXT:    fadd f1, f2, f1
; P8-NEXT:    mtfsf 1, f0
; P8-NEXT:    xscvdpsxws f0, f1
; P8-NEXT:    mffprwz r3, f0
; P8-NEXT:    xor r3, r3, r30
; P8-NEXT:    ld r30, 112(r1) # 8-byte Folded Reload
; P8-NEXT:    clrldi r3, r3, 32
; P8-NEXT:    addi r1, r1, 128
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: ppcq_to_u32:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mflr r0
; P9-NEXT:    .cfi_def_cfa_offset 48
; P9-NEXT:    .cfi_offset lr, 16
; P9-NEXT:    .cfi_offset r30, -16
; P9-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; P9-NEXT:    std r0, 16(r1)
; P9-NEXT:    stdu r1, -48(r1)
; P9-NEXT:    addis r3, r2, .LCPI13_0@toc@ha
; P9-NEXT:    xxlxor f3, f3, f3
; P9-NEXT:    lfs f0, .LCPI13_0@toc@l(r3)
; P9-NEXT:    fcmpo cr1, f2, f3
; P9-NEXT:    lis r3, -32768
; P9-NEXT:    fcmpo cr0, f1, f0
; P9-NEXT:    xxlxor f3, f3, f3
; P9-NEXT:    crand 4*cr5+lt, eq, 4*cr1+lt
; P9-NEXT:    crandc 4*cr5+gt, lt, eq
; P9-NEXT:    cror 4*cr5+lt, 4*cr5+gt, 4*cr5+lt
; P9-NEXT:    isel r30, 0, r3, 4*cr5+lt
; P9-NEXT:    bc 12, 4*cr5+lt, .LBB13_2
; P9-NEXT:  # %bb.1: # %entry
; P9-NEXT:    fmr f3, f0
; P9-NEXT:  .LBB13_2: # %entry
; P9-NEXT:    xxlxor f4, f4, f4
; P9-NEXT:    bl __gcc_qsub
; P9-NEXT:    nop
; P9-NEXT:    mffs f0
; P9-NEXT:    mtfsb1 31
; P9-NEXT:    mtfsb0 30
; P9-NEXT:    fadd f1, f2, f1
; P9-NEXT:    mtfsf 1, f0
; P9-NEXT:    xscvdpsxws f0, f1
; P9-NEXT:    mffprwz r3, f0
; P9-NEXT:    xor r3, r3, r30
; P9-NEXT:    clrldi r3, r3, 32
; P9-NEXT:    addi r1, r1, 48
; P9-NEXT:    ld r0, 16(r1)
; P9-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; P9-NEXT:    mtlr r0
; P9-NEXT:    blr
;
; NOVSX-LABEL: ppcq_to_u32:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mfocrf r12, 32
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stw r12, 8(r1)
; NOVSX-NEXT:    stdu r1, -48(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 48
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    .cfi_offset cr2, 8
; NOVSX-NEXT:    addis r3, r2, .LCPI13_0@toc@ha
; NOVSX-NEXT:    addis r4, r2, .LCPI13_1@toc@ha
; NOVSX-NEXT:    lfs f0, .LCPI13_0@toc@l(r3)
; NOVSX-NEXT:    lfs f4, .LCPI13_1@toc@l(r4)
; NOVSX-NEXT:    fcmpo cr0, f1, f0
; NOVSX-NEXT:    fcmpo cr1, f2, f4
; NOVSX-NEXT:    fmr f3, f4
; NOVSX-NEXT:    crand 4*cr5+lt, eq, 4*cr1+lt
; NOVSX-NEXT:    crandc 4*cr5+gt, lt, eq
; NOVSX-NEXT:    cror 4*cr2+lt, 4*cr5+gt, 4*cr5+lt
; NOVSX-NEXT:    bc 12, 4*cr2+lt, .LBB13_2
; NOVSX-NEXT:  # %bb.1: # %entry
; NOVSX-NEXT:    fmr f3, f0
; NOVSX-NEXT:  .LBB13_2: # %entry
; NOVSX-NEXT:    bl __gcc_qsub
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    mffs f0
; NOVSX-NEXT:    mtfsb1 31
; NOVSX-NEXT:    addi r3, r1, 44
; NOVSX-NEXT:    mtfsb0 30
; NOVSX-NEXT:    fadd f1, f2, f1
; NOVSX-NEXT:    mtfsf 1, f0
; NOVSX-NEXT:    fctiwz f0, f1
; NOVSX-NEXT:    stfiwx f0, 0, r3
; NOVSX-NEXT:    lis r3, -32768
; NOVSX-NEXT:    lwz r4, 44(r1)
; NOVSX-NEXT:    isel r3, 0, r3, 4*cr2+lt
; NOVSX-NEXT:    xor r3, r4, r3
; NOVSX-NEXT:    clrldi r3, r3, 32
; NOVSX-NEXT:    addi r1, r1, 48
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    lwz r12, 8(r1)
; NOVSX-NEXT:    mtocrf 32, r12
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call i32 @llvm.experimental.constrained.fptoui.i32.ppcf128(ppc_fp128 %m, metadata !"fpexcept.strict") #0
  ret i32 %conv
}

define fp128 @i1_to_q(i1 signext %m) #0 {
; P8-LABEL: i1_to_q:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __floatsikf
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: i1_to_q:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mtvsrwa v2, r3
; P9-NEXT:    xscvsdqp v2, v2
; P9-NEXT:    blr
;
; NOVSX-LABEL: i1_to_q:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __floatsikf
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call fp128 @llvm.experimental.constrained.sitofp.f128.i1(i1 %m, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %conv
}

define fp128 @u1_to_q(i1 zeroext %m) #0 {
; P8-LABEL: u1_to_q:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __floatunsikf
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: u1_to_q:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mtvsrwa v2, r3
; P9-NEXT:    xscvsdqp v2, v2
; P9-NEXT:    blr
;
; NOVSX-LABEL: u1_to_q:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __floatsikf
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call fp128 @llvm.experimental.constrained.uitofp.f128.i1(i1 %m, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %conv
}

define ppc_fp128 @i1_to_ppcq(i1 signext %m) #0 {
; P8-LABEL: i1_to_ppcq:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mtfprwa f0, r3
; P8-NEXT:    xxlxor f2, f2, f2
; P8-NEXT:    xscvsxddp f1, f0
; P8-NEXT:    blr
;
; P9-LABEL: i1_to_ppcq:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mtfprwa f0, r3
; P9-NEXT:    xxlxor f2, f2, f2
; P9-NEXT:    xscvsxddp f1, f0
; P9-NEXT:    blr
;
; NOVSX-LABEL: i1_to_ppcq:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    addi r4, r1, -4
; NOVSX-NEXT:    stw r3, -4(r1)
; NOVSX-NEXT:    addis r3, r2, .LCPI16_0@toc@ha
; NOVSX-NEXT:    lfiwax f0, 0, r4
; NOVSX-NEXT:    lfs f2, .LCPI16_0@toc@l(r3)
; NOVSX-NEXT:    fcfid f1, f0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call ppc_fp128 @llvm.experimental.constrained.sitofp.ppcf128.i1(i1 %m, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret ppc_fp128 %conv
}

define ppc_fp128 @u1_to_ppcq(i1 zeroext %m) #0 {
; P8-LABEL: u1_to_ppcq:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mtfprwa f0, r3
; P8-NEXT:    xxlxor f2, f2, f2
; P8-NEXT:    xscvsxddp f1, f0
; P8-NEXT:    blr
;
; P9-LABEL: u1_to_ppcq:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mtfprwa f0, r3
; P9-NEXT:    xxlxor f2, f2, f2
; P9-NEXT:    xscvsxddp f1, f0
; P9-NEXT:    blr
;
; NOVSX-LABEL: u1_to_ppcq:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    addi r4, r1, -4
; NOVSX-NEXT:    stw r3, -4(r1)
; NOVSX-NEXT:    addis r3, r2, .LCPI17_0@toc@ha
; NOVSX-NEXT:    lfiwax f0, 0, r4
; NOVSX-NEXT:    lfs f2, .LCPI17_0@toc@l(r3)
; NOVSX-NEXT:    fcfid f1, f0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call ppc_fp128 @llvm.experimental.constrained.uitofp.ppcf128.i1(i1 %m, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret ppc_fp128 %conv
}

define fp128 @i32_to_q(i32 signext %m) #0 {
; P8-LABEL: i32_to_q:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __floatsikf
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: i32_to_q:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mtvsrwa v2, r3
; P9-NEXT:    xscvsdqp v2, v2
; P9-NEXT:    blr
;
; NOVSX-LABEL: i32_to_q:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __floatsikf
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call fp128 @llvm.experimental.constrained.sitofp.f128.i32(i32 %m, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %conv
}

define fp128 @i64_to_q(i64 %m) #0 {
; P8-LABEL: i64_to_q:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __floatdikf
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: i64_to_q:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mtvsrd v2, r3
; P9-NEXT:    xscvsdqp v2, v2
; P9-NEXT:    blr
;
; NOVSX-LABEL: i64_to_q:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __floatdikf
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call fp128 @llvm.experimental.constrained.sitofp.f128.i64(i64 %m, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %conv
}

define fp128 @u32_to_q(i32 zeroext %m) #0 {
; P8-LABEL: u32_to_q:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __floatunsikf
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: u32_to_q:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mtvsrwz v2, r3
; P9-NEXT:    xscvudqp v2, v2
; P9-NEXT:    blr
;
; NOVSX-LABEL: u32_to_q:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __floatunsikf
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call fp128 @llvm.experimental.constrained.uitofp.f128.i32(i32 %m, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %conv
}

define fp128 @u64_to_q(i64 %m) #0 {
; P8-LABEL: u64_to_q:
; P8:       # %bb.0: # %entry
; P8-NEXT:    mflr r0
; P8-NEXT:    std r0, 16(r1)
; P8-NEXT:    stdu r1, -112(r1)
; P8-NEXT:    .cfi_def_cfa_offset 112
; P8-NEXT:    .cfi_offset lr, 16
; P8-NEXT:    bl __floatundikf
; P8-NEXT:    nop
; P8-NEXT:    addi r1, r1, 112
; P8-NEXT:    ld r0, 16(r1)
; P8-NEXT:    mtlr r0
; P8-NEXT:    blr
;
; P9-LABEL: u64_to_q:
; P9:       # %bb.0: # %entry
; P9-NEXT:    mtvsrd v2, r3
; P9-NEXT:    xscvudqp v2, v2
; P9-NEXT:    blr
;
; NOVSX-LABEL: u64_to_q:
; NOVSX:       # %bb.0: # %entry
; NOVSX-NEXT:    mflr r0
; NOVSX-NEXT:    std r0, 16(r1)
; NOVSX-NEXT:    stdu r1, -32(r1)
; NOVSX-NEXT:    .cfi_def_cfa_offset 32
; NOVSX-NEXT:    .cfi_offset lr, 16
; NOVSX-NEXT:    bl __floatundikf
; NOVSX-NEXT:    nop
; NOVSX-NEXT:    addi r1, r1, 32
; NOVSX-NEXT:    ld r0, 16(r1)
; NOVSX-NEXT:    mtlr r0
; NOVSX-NEXT:    blr
entry:
  %conv = tail call fp128 @llvm.experimental.constrained.uitofp.f128.i64(i64 %m, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %conv
}

attributes #0 = { strictfp }
