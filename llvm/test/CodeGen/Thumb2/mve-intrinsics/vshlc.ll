; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main -mattr=+mve -verify-machineinstrs -o - %s | FileCheck %s

define arm_aapcs_vfpcc <16 x i8> @test_vshlcq_s8(<16 x i8> %a, i32* nocapture %b) {
; CHECK-LABEL: test_vshlcq_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    vshlc q0, r1, #18
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load i32, i32* %b, align 4
  %1 = tail call { i32, <16 x i8> } @llvm.arm.mve.vshlc.v16i8(<16 x i8> %a, i32 %0, i32 18)
  %2 = extractvalue { i32, <16 x i8> } %1, 0
  store i32 %2, i32* %b, align 4
  %3 = extractvalue { i32, <16 x i8> } %1, 1
  ret <16 x i8> %3
}

define arm_aapcs_vfpcc <8 x i16> @test_vshlcq_s16(<8 x i16> %a, i32* nocapture %b) {
; CHECK-LABEL: test_vshlcq_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    vshlc q0, r1, #16
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load i32, i32* %b, align 4
  %1 = tail call { i32, <8 x i16> } @llvm.arm.mve.vshlc.v8i16(<8 x i16> %a, i32 %0, i32 16)
  %2 = extractvalue { i32, <8 x i16> } %1, 0
  store i32 %2, i32* %b, align 4
  %3 = extractvalue { i32, <8 x i16> } %1, 1
  ret <8 x i16> %3
}

define arm_aapcs_vfpcc <4 x i32> @test_vshlcq_s32(<4 x i32> %a, i32* nocapture %b) {
; CHECK-LABEL: test_vshlcq_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    vshlc q0, r1, #4
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load i32, i32* %b, align 4
  %1 = tail call { i32, <4 x i32> } @llvm.arm.mve.vshlc.v4i32(<4 x i32> %a, i32 %0, i32 4)
  %2 = extractvalue { i32, <4 x i32> } %1, 0
  store i32 %2, i32* %b, align 4
  %3 = extractvalue { i32, <4 x i32> } %1, 1
  ret <4 x i32> %3
}

define arm_aapcs_vfpcc <16 x i8> @test_vshlcq_u8(<16 x i8> %a, i32* nocapture %b) {
; CHECK-LABEL: test_vshlcq_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    vshlc q0, r1, #17
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load i32, i32* %b, align 4
  %1 = tail call { i32, <16 x i8> } @llvm.arm.mve.vshlc.v16i8(<16 x i8> %a, i32 %0, i32 17)
  %2 = extractvalue { i32, <16 x i8> } %1, 0
  store i32 %2, i32* %b, align 4
  %3 = extractvalue { i32, <16 x i8> } %1, 1
  ret <16 x i8> %3
}

define arm_aapcs_vfpcc <8 x i16> @test_vshlcq_u16(<8 x i16> %a, i32* nocapture %b) {
; CHECK-LABEL: test_vshlcq_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    vshlc q0, r1, #17
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load i32, i32* %b, align 4
  %1 = tail call { i32, <8 x i16> } @llvm.arm.mve.vshlc.v8i16(<8 x i16> %a, i32 %0, i32 17)
  %2 = extractvalue { i32, <8 x i16> } %1, 0
  store i32 %2, i32* %b, align 4
  %3 = extractvalue { i32, <8 x i16> } %1, 1
  ret <8 x i16> %3
}

define arm_aapcs_vfpcc <4 x i32> @test_vshlcq_u32(<4 x i32> %a, i32* nocapture %b) {
; CHECK-LABEL: test_vshlcq_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    vshlc q0, r1, #20
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load i32, i32* %b, align 4
  %1 = tail call { i32, <4 x i32> } @llvm.arm.mve.vshlc.v4i32(<4 x i32> %a, i32 %0, i32 20)
  %2 = extractvalue { i32, <4 x i32> } %1, 0
  store i32 %2, i32* %b, align 4
  %3 = extractvalue { i32, <4 x i32> } %1, 1
  ret <4 x i32> %3
}

define arm_aapcs_vfpcc <16 x i8> @test_vshlcq_m_s8(<16 x i8> %a, i32* nocapture %b, i16 zeroext %p) {
; CHECK-LABEL: test_vshlcq_m_s8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vshlct q0, r1, #29
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load i32, i32* %b, align 4
  %1 = zext i16 %p to i32
  %2 = tail call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %1)
  %3 = tail call { i32, <16 x i8> } @llvm.arm.mve.vshlc.predicated.v16i8.v16i1(<16 x i8> %a, i32 %0, i32 29, <16 x i1> %2)
  %4 = extractvalue { i32, <16 x i8> } %3, 0
  store i32 %4, i32* %b, align 4
  %5 = extractvalue { i32, <16 x i8> } %3, 1
  ret <16 x i8> %5
}

define arm_aapcs_vfpcc <8 x i16> @test_vshlcq_m_s16(<8 x i16> %a, i32* nocapture %b, i16 zeroext %p) {
; CHECK-LABEL: test_vshlcq_m_s16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vshlct q0, r1, #17
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load i32, i32* %b, align 4
  %1 = zext i16 %p to i32
  %2 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %1)
  %3 = tail call { i32, <8 x i16> } @llvm.arm.mve.vshlc.predicated.v8i16.v8i1(<8 x i16> %a, i32 %0, i32 17, <8 x i1> %2)
  %4 = extractvalue { i32, <8 x i16> } %3, 0
  store i32 %4, i32* %b, align 4
  %5 = extractvalue { i32, <8 x i16> } %3, 1
  ret <8 x i16> %5
}

define arm_aapcs_vfpcc <4 x i32> @test_vshlcq_m_s32(<4 x i32> %a, i32* nocapture %b, i16 zeroext %p) {
; CHECK-LABEL: test_vshlcq_m_s32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vshlct q0, r1, #9
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load i32, i32* %b, align 4
  %1 = zext i16 %p to i32
  %2 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %1)
  %3 = tail call { i32, <4 x i32> } @llvm.arm.mve.vshlc.predicated.v4i32.v4i1(<4 x i32> %a, i32 %0, i32 9, <4 x i1> %2)
  %4 = extractvalue { i32, <4 x i32> } %3, 0
  store i32 %4, i32* %b, align 4
  %5 = extractvalue { i32, <4 x i32> } %3, 1
  ret <4 x i32> %5
}

define arm_aapcs_vfpcc <16 x i8> @test_vshlcq_m_u8(<16 x i8> %a, i32* nocapture %b, i16 zeroext %p) {
; CHECK-LABEL: test_vshlcq_m_u8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vshlct q0, r1, #21
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load i32, i32* %b, align 4
  %1 = zext i16 %p to i32
  %2 = tail call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 %1)
  %3 = tail call { i32, <16 x i8> } @llvm.arm.mve.vshlc.predicated.v16i8.v16i1(<16 x i8> %a, i32 %0, i32 21, <16 x i1> %2)
  %4 = extractvalue { i32, <16 x i8> } %3, 0
  store i32 %4, i32* %b, align 4
  %5 = extractvalue { i32, <16 x i8> } %3, 1
  ret <16 x i8> %5
}

define arm_aapcs_vfpcc <8 x i16> @test_vshlcq_m_u16(<8 x i16> %a, i32* nocapture %b, i16 zeroext %p) {
; CHECK-LABEL: test_vshlcq_m_u16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vshlct q0, r1, #24
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load i32, i32* %b, align 4
  %1 = zext i16 %p to i32
  %2 = tail call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 %1)
  %3 = tail call { i32, <8 x i16> } @llvm.arm.mve.vshlc.predicated.v8i16.v8i1(<8 x i16> %a, i32 %0, i32 24, <8 x i1> %2)
  %4 = extractvalue { i32, <8 x i16> } %3, 0
  store i32 %4, i32* %b, align 4
  %5 = extractvalue { i32, <8 x i16> } %3, 1
  ret <8 x i16> %5
}

define arm_aapcs_vfpcc <4 x i32> @test_vshlcq_m_u32(<4 x i32> %a, i32* nocapture %b, i16 zeroext %p) {
; CHECK-LABEL: test_vshlcq_m_u32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmsr p0, r1
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vshlct q0, r1, #26
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = load i32, i32* %b, align 4
  %1 = zext i16 %p to i32
  %2 = tail call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 %1)
  %3 = tail call { i32, <4 x i32> } @llvm.arm.mve.vshlc.predicated.v4i32.v4i1(<4 x i32> %a, i32 %0, i32 26, <4 x i1> %2)
  %4 = extractvalue { i32, <4 x i32> } %3, 0
  store i32 %4, i32* %b, align 4
  %5 = extractvalue { i32, <4 x i32> } %3, 1
  ret <4 x i32> %5
}

declare { i32, <16 x i8> } @llvm.arm.mve.vshlc.v16i8(<16 x i8>, i32, i32)
declare { i32, <8 x i16> } @llvm.arm.mve.vshlc.v8i16(<8 x i16>, i32, i32)
declare { i32, <4 x i32> } @llvm.arm.mve.vshlc.v4i32(<4 x i32>, i32, i32)
declare <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32)
declare { i32, <16 x i8> } @llvm.arm.mve.vshlc.predicated.v16i8.v16i1(<16 x i8>, i32, i32, <16 x i1>)
declare <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32)
declare { i32, <8 x i16> } @llvm.arm.mve.vshlc.predicated.v8i16.v8i1(<8 x i16>, i32, i32, <8 x i1>)
declare <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32)
declare { i32, <4 x i32> } @llvm.arm.mve.vshlc.predicated.v4i32.v4i1(<4 x i32>, i32, i32, <4 x i1>)
