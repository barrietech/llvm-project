; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s

define arm_aapcs_vfpcc <4 x i32> @sext_v4i32_v4i32_v4i1(<4 x i32> %m) {
; CHECK-LABEL: sext_v4i32_v4i32_v4i1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshl.i32 q0, q0, #31
; CHECK-NEXT:    vshr.s32 q0, q0, #31
; CHECK-NEXT:    bx lr
entry:
  %shl = shl <4 x i32> %m, <i32 31, i32 31, i32 31, i32 31>
  %shr = ashr exact <4 x i32> %shl, <i32 31, i32 31, i32 31, i32 31>
  ret <4 x i32> %shr
}

define arm_aapcs_vfpcc <4 x i32> @sext_v4i32_v4i32_v4i8(<4 x i32> %m) {
; CHECK-LABEL: sext_v4i32_v4i32_v4i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %shl = shl <4 x i32> %m, <i32 24, i32 24, i32 24, i32 24>
  %shr = ashr exact <4 x i32> %shl, <i32 24, i32 24, i32 24, i32 24>
  ret <4 x i32> %shr
}

define arm_aapcs_vfpcc <4 x i32> @sext_v4i32_v4i32_v4i16(<4 x i32> %m) {
; CHECK-LABEL: sext_v4i32_v4i32_v4i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %shl = shl <4 x i32> %m, <i32 16, i32 16, i32 16, i32 16>
  %shr = ashr exact <4 x i32> %shl, <i32 16, i32 16, i32 16, i32 16>
  ret <4 x i32> %shr
}

define arm_aapcs_vfpcc <8 x i16> @sext_v8i16_v8i16_v8i8(<8 x i16> %m) {
; CHECK-LABEL: sext_v8i16_v8i16_v8i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %shl = shl <8 x i16> %m, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %shr = ashr exact <8 x i16> %shl, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  ret <8 x i16> %shr
}

define arm_aapcs_vfpcc <8 x i16> @sext_v8i16_v8i16_v8i1(<8 x i16> %m) {
; CHECK-LABEL: sext_v8i16_v8i16_v8i1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vshl.i16 q0, q0, #15
; CHECK-NEXT:    vshr.s16 q0, q0, #15
; CHECK-NEXT:    bx lr
entry:
  %shl = shl <8 x i16> %m, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %shr = ashr exact <8 x i16> %shl, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  ret <8 x i16> %shr
}

define arm_aapcs_vfpcc <2 x i64> @sext_v2i64_v2i64_v2i32(<2 x i64> %m) {
; CHECK-LABEL: sext_v2i64_v2i64_v2i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vmov q0[2], q0[0], r1, r0
; CHECK-NEXT:    asrs r0, r0, #31
; CHECK-NEXT:    asrs r1, r1, #31
; CHECK-NEXT:    vmov q0[3], q0[1], r1, r0
; CHECK-NEXT:    bx lr
entry:
  %shl = shl <2 x i64> %m, <i64 32, i64 32>
  %shr = ashr exact <2 x i64> %shl, <i64 32, i64 32>
  ret <2 x i64> %shr
}

define arm_aapcs_vfpcc <2 x i64> @sext_v2i64_v2i64_v2i35(<2 x i64> %m) {
; CHECK-LABEL: sext_v2i64_v2i64_v2i35:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vmov r0, s3
; CHECK-NEXT:    vmov r1, s1
; CHECK-NEXT:    sbfx r0, r0, #0, #3
; CHECK-NEXT:    sbfx r1, r1, #0, #3
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r0
; CHECK-NEXT:    vmov q0, q1
; CHECK-NEXT:    bx lr
entry:
  %shl = shl <2 x i64> %m, <i64 29, i64 29>
  %shr = ashr exact <2 x i64> %shl, <i64 29, i64 29>
  ret <2 x i64> %shr
}

define arm_aapcs_vfpcc <8 x i16> @sext_v8i8_v8i16(<8 x i8> %src) {
; CHECK-LABEL: sext_v8i8_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = sext <8 x i8> %src to <8 x i16>
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @sext_v4i16_v4i32(<4 x i16> %src) {
; CHECK-LABEL: sext_v4i16_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = sext <4 x i16> %src to <4 x i32>
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <4 x i32> @sext_v4i8_v4i32(<4 x i8> %src) {
; CHECK-LABEL: sext_v4i8_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.s8 q0, q0
; CHECK-NEXT:    vmovlb.s16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = sext <4 x i8> %src to <4 x i32>
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <16 x i16> @sext_v16i8_v16i16(<16 x i8> %src) {
; CHECK-LABEL: sext_v16i8_v16i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.u8 r0, q0[0]
; CHECK-NEXT:    vmov.16 q1[0], r0
; CHECK-NEXT:    vmov.u8 r0, q0[1]
; CHECK-NEXT:    vmov.16 q1[1], r0
; CHECK-NEXT:    vmov.u8 r0, q0[2]
; CHECK-NEXT:    vmov.16 q1[2], r0
; CHECK-NEXT:    vmov.u8 r0, q0[3]
; CHECK-NEXT:    vmov.16 q1[3], r0
; CHECK-NEXT:    vmov.u8 r0, q0[4]
; CHECK-NEXT:    vmov.16 q1[4], r0
; CHECK-NEXT:    vmov.u8 r0, q0[5]
; CHECK-NEXT:    vmov.16 q1[5], r0
; CHECK-NEXT:    vmov.u8 r0, q0[6]
; CHECK-NEXT:    vmov.16 q1[6], r0
; CHECK-NEXT:    vmov.u8 r0, q0[7]
; CHECK-NEXT:    vmov.16 q1[7], r0
; CHECK-NEXT:    vmov.u8 r0, q0[8]
; CHECK-NEXT:    vmovlb.s8 q2, q1
; CHECK-NEXT:    vmov.16 q1[0], r0
; CHECK-NEXT:    vmov.u8 r0, q0[9]
; CHECK-NEXT:    vmov.16 q1[1], r0
; CHECK-NEXT:    vmov.u8 r0, q0[10]
; CHECK-NEXT:    vmov.16 q1[2], r0
; CHECK-NEXT:    vmov.u8 r0, q0[11]
; CHECK-NEXT:    vmov.16 q1[3], r0
; CHECK-NEXT:    vmov.u8 r0, q0[12]
; CHECK-NEXT:    vmov.16 q1[4], r0
; CHECK-NEXT:    vmov.u8 r0, q0[13]
; CHECK-NEXT:    vmov.16 q1[5], r0
; CHECK-NEXT:    vmov.u8 r0, q0[14]
; CHECK-NEXT:    vmov.16 q1[6], r0
; CHECK-NEXT:    vmov.u8 r0, q0[15]
; CHECK-NEXT:    vmov.16 q1[7], r0
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    vmovlb.s8 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = sext <16 x i8> %src to <16 x i16>
  ret <16 x i16> %0
}

define arm_aapcs_vfpcc <8 x i32> @sext_v8i16_v8i32(<8 x i16> %src) {
; CHECK-LABEL: sext_v8i16_v8i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.u16 r0, q0[2]
; CHECK-NEXT:    vmov.u16 r1, q0[0]
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q0[3]
; CHECK-NEXT:    vmov.u16 r1, q0[1]
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q0[6]
; CHECK-NEXT:    vmov.u16 r1, q0[4]
; CHECK-NEXT:    vmovlb.s16 q2, q1
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q0[7]
; CHECK-NEXT:    vmov.u16 r1, q0[5]
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r0
; CHECK-NEXT:    vmovlb.s16 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = sext <8 x i16> %src to <8 x i32>
  ret <8 x i32> %0
}

define arm_aapcs_vfpcc <16 x i32> @sext_v16i8_v16i32(<16 x i8> %src) {
; CHECK-LABEL: sext_v16i8_v16i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vmov.u8 r0, q0[2]
; CHECK-NEXT:    vmov.u8 r1, q0[0]
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[3]
; CHECK-NEXT:    vmov.u8 r1, q0[1]
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[6]
; CHECK-NEXT:    vmovlb.s8 q1, q1
; CHECK-NEXT:    vmov.u8 r1, q0[4]
; CHECK-NEXT:    vmovlb.s16 q4, q1
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[7]
; CHECK-NEXT:    vmov.u8 r1, q0[5]
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[10]
; CHECK-NEXT:    vmov.u8 r1, q0[8]
; CHECK-NEXT:    vmovlb.s8 q1, q1
; CHECK-NEXT:    vmov q2[2], q2[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[11]
; CHECK-NEXT:    vmov.u8 r1, q0[9]
; CHECK-NEXT:    vmovlb.s16 q1, q1
; CHECK-NEXT:    vmov q2[3], q2[1], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[14]
; CHECK-NEXT:    vmov.u8 r1, q0[12]
; CHECK-NEXT:    vmovlb.s8 q2, q2
; CHECK-NEXT:    vmov q3[2], q3[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[15]
; CHECK-NEXT:    vmov.u8 r1, q0[13]
; CHECK-NEXT:    vmovlb.s16 q2, q2
; CHECK-NEXT:    vmov q3[3], q3[1], r1, r0
; CHECK-NEXT:    vmovlb.s8 q0, q3
; CHECK-NEXT:    vmovlb.s16 q3, q0
; CHECK-NEXT:    vmov q0, q4
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %0 = sext <16 x i8> %src to <16 x i32>
  ret <16 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @sext_v2i32_v2i64(<2 x i32> %src) {
; CHECK-LABEL: sext_v2i32_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov r0, s2
; CHECK-NEXT:    vmov r1, s0
; CHECK-NEXT:    vmov q0[2], q0[0], r1, r0
; CHECK-NEXT:    asrs r0, r0, #31
; CHECK-NEXT:    asrs r1, r1, #31
; CHECK-NEXT:    vmov q0[3], q0[1], r1, r0
; CHECK-NEXT:    bx lr
entry:
  %0 = sext <2 x i32> %src to <2 x i64>
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <8 x i16> @zext_v8i8_v8i16(<8 x i8> %src) {
; CHECK-LABEL: zext_v8i8_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.u8 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext <8 x i8> %src to <8 x i16>
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <4 x i32> @zext_v4i16_v4i32(<4 x i16> %src) {
; CHECK-LABEL: zext_v4i16_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmovlb.u16 q0, q0
; CHECK-NEXT:    bx lr
entry:
  %0 = zext <4 x i16> %src to <4 x i32>
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <4 x i32> @zext_v4i8_v4i32(<4 x i8> %src) {
; CHECK-LABEL: zext_v4i8_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i32 q1, #0xff
; CHECK-NEXT:    vand q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext <4 x i8> %src to <4 x i32>
  ret <4 x i32> %0
}

define arm_aapcs_vfpcc <16 x i16> @zext_v16i8_v16i16(<16 x i8> %src) {
; CHECK-LABEL: zext_v16i8_v16i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.u8 r0, q0[0]
; CHECK-NEXT:    vmov.16 q1[0], r0
; CHECK-NEXT:    vmov.u8 r0, q0[1]
; CHECK-NEXT:    vmov.16 q1[1], r0
; CHECK-NEXT:    vmov.u8 r0, q0[2]
; CHECK-NEXT:    vmov.16 q1[2], r0
; CHECK-NEXT:    vmov.u8 r0, q0[3]
; CHECK-NEXT:    vmov.16 q1[3], r0
; CHECK-NEXT:    vmov.u8 r0, q0[4]
; CHECK-NEXT:    vmov.16 q1[4], r0
; CHECK-NEXT:    vmov.u8 r0, q0[5]
; CHECK-NEXT:    vmov.16 q1[5], r0
; CHECK-NEXT:    vmov.u8 r0, q0[6]
; CHECK-NEXT:    vmov.16 q1[6], r0
; CHECK-NEXT:    vmov.u8 r0, q0[7]
; CHECK-NEXT:    vmov.16 q1[7], r0
; CHECK-NEXT:    vmov.u8 r0, q0[8]
; CHECK-NEXT:    vmovlb.u8 q2, q1
; CHECK-NEXT:    vmov.16 q1[0], r0
; CHECK-NEXT:    vmov.u8 r0, q0[9]
; CHECK-NEXT:    vmov.16 q1[1], r0
; CHECK-NEXT:    vmov.u8 r0, q0[10]
; CHECK-NEXT:    vmov.16 q1[2], r0
; CHECK-NEXT:    vmov.u8 r0, q0[11]
; CHECK-NEXT:    vmov.16 q1[3], r0
; CHECK-NEXT:    vmov.u8 r0, q0[12]
; CHECK-NEXT:    vmov.16 q1[4], r0
; CHECK-NEXT:    vmov.u8 r0, q0[13]
; CHECK-NEXT:    vmov.16 q1[5], r0
; CHECK-NEXT:    vmov.u8 r0, q0[14]
; CHECK-NEXT:    vmov.16 q1[6], r0
; CHECK-NEXT:    vmov.u8 r0, q0[15]
; CHECK-NEXT:    vmov.16 q1[7], r0
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    vmovlb.u8 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext <16 x i8> %src to <16 x i16>
  ret <16 x i16> %0
}

define arm_aapcs_vfpcc <8 x i32> @zext_v8i16_v8i32(<8 x i16> %src) {
; CHECK-LABEL: zext_v8i16_v8i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.u16 r0, q0[2]
; CHECK-NEXT:    vmov.u16 r1, q0[0]
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q0[3]
; CHECK-NEXT:    vmov.u16 r1, q0[1]
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q0[6]
; CHECK-NEXT:    vmov.u16 r1, q0[4]
; CHECK-NEXT:    vmovlb.u16 q2, q1
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vmov.u16 r0, q0[7]
; CHECK-NEXT:    vmov.u16 r1, q0[5]
; CHECK-NEXT:    vmov q0, q2
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r0
; CHECK-NEXT:    vmovlb.u16 q1, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext <8 x i16> %src to <8 x i32>
  ret <8 x i32> %0
}

define arm_aapcs_vfpcc <16 x i32> @zext_v16i8_v16i32(<16 x i8> %src) {
; CHECK-LABEL: zext_v16i8_v16i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-NEXT:    vmov.u8 r0, q0[2]
; CHECK-NEXT:    vmov.u8 r1, q0[0]
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[3]
; CHECK-NEXT:    vmov.u8 r1, q0[1]
; CHECK-NEXT:    vmov.i32 q3, #0xff
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[6]
; CHECK-NEXT:    vmov.u8 r1, q0[4]
; CHECK-NEXT:    vand q4, q1, q3
; CHECK-NEXT:    vmov q1[2], q1[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[7]
; CHECK-NEXT:    vmov.u8 r1, q0[5]
; CHECK-NEXT:    vmov q1[3], q1[1], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[10]
; CHECK-NEXT:    vmov.u8 r1, q0[8]
; CHECK-NEXT:    vand q1, q1, q3
; CHECK-NEXT:    vmov q2[2], q2[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[11]
; CHECK-NEXT:    vmov.u8 r1, q0[9]
; CHECK-NEXT:    vmov q2[3], q2[1], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[14]
; CHECK-NEXT:    vmov.u8 r1, q0[12]
; CHECK-NEXT:    vand q2, q2, q3
; CHECK-NEXT:    vmov q5[2], q5[0], r1, r0
; CHECK-NEXT:    vmov.u8 r0, q0[15]
; CHECK-NEXT:    vmov.u8 r1, q0[13]
; CHECK-NEXT:    vmov q0, q4
; CHECK-NEXT:    vmov q5[3], q5[1], r1, r0
; CHECK-NEXT:    vand q3, q5, q3
; CHECK-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-NEXT:    bx lr
entry:
  %0 = zext <16 x i8> %src to <16 x i32>
  ret <16 x i32> %0
}

define arm_aapcs_vfpcc <2 x i64> @zext_v2i32_v2i64(<2 x i32> %src) {
; CHECK-LABEL: zext_v2i32_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i64 q1, #0xffffffff
; CHECK-NEXT:    vand q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %0 = zext <2 x i32> %src to <2 x i64>
  ret <2 x i64> %0
}


define arm_aapcs_vfpcc <8 x i8> @trunc_v8i16_v8i8(<8 x i16> %src) {
; CHECK-LABEL: trunc_v8i16_v8i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0 = trunc <8 x i16> %src to <8 x i8>
  ret <8 x i8> %0
}

define arm_aapcs_vfpcc <4 x i16> @trunc_v4i32_v4i16(<4 x i32> %src) {
; CHECK-LABEL: trunc_v4i32_v4i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0 = trunc <4 x i32> %src to <4 x i16>
  ret <4 x i16> %0
}

define arm_aapcs_vfpcc <4 x i8> @trunc_v4i32_v4i8(<4 x i32> %src) {
; CHECK-LABEL: trunc_v4i32_v4i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0 = trunc <4 x i32> %src to <4 x i8>
  ret <4 x i8> %0
}

define arm_aapcs_vfpcc <16 x i8> @trunc_v16i16_v16i8(<16 x i16> %src) {
; CHECK-LABEL: trunc_v16i16_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov q2, q0
; CHECK-NEXT:    vmov.u16 r0, q0[0]
; CHECK-NEXT:    vmov.8 q0[0], r0
; CHECK-NEXT:    vmov.u16 r0, q2[1]
; CHECK-NEXT:    vmov.8 q0[1], r0
; CHECK-NEXT:    vmov.u16 r0, q2[2]
; CHECK-NEXT:    vmov.8 q0[2], r0
; CHECK-NEXT:    vmov.u16 r0, q2[3]
; CHECK-NEXT:    vmov.8 q0[3], r0
; CHECK-NEXT:    vmov.u16 r0, q2[4]
; CHECK-NEXT:    vmov.8 q0[4], r0
; CHECK-NEXT:    vmov.u16 r0, q2[5]
; CHECK-NEXT:    vmov.8 q0[5], r0
; CHECK-NEXT:    vmov.u16 r0, q2[6]
; CHECK-NEXT:    vmov.8 q0[6], r0
; CHECK-NEXT:    vmov.u16 r0, q2[7]
; CHECK-NEXT:    vmov.8 q0[7], r0
; CHECK-NEXT:    vmov.u16 r0, q1[0]
; CHECK-NEXT:    vmov.8 q0[8], r0
; CHECK-NEXT:    vmov.u16 r0, q1[1]
; CHECK-NEXT:    vmov.8 q0[9], r0
; CHECK-NEXT:    vmov.u16 r0, q1[2]
; CHECK-NEXT:    vmov.8 q0[10], r0
; CHECK-NEXT:    vmov.u16 r0, q1[3]
; CHECK-NEXT:    vmov.8 q0[11], r0
; CHECK-NEXT:    vmov.u16 r0, q1[4]
; CHECK-NEXT:    vmov.8 q0[12], r0
; CHECK-NEXT:    vmov.u16 r0, q1[5]
; CHECK-NEXT:    vmov.8 q0[13], r0
; CHECK-NEXT:    vmov.u16 r0, q1[6]
; CHECK-NEXT:    vmov.8 q0[14], r0
; CHECK-NEXT:    vmov.u16 r0, q1[7]
; CHECK-NEXT:    vmov.8 q0[15], r0
; CHECK-NEXT:    bx lr
entry:
  %0 = trunc <16 x i16> %src to <16 x i8>
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <8 x i16> @trunc_v8i32_v8i16(<8 x i32> %src) {
; CHECK-LABEL: trunc_v8i32_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov q2, q0
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmov.16 q0[0], r0
; CHECK-NEXT:    vmov r0, s9
; CHECK-NEXT:    vmov.16 q0[1], r0
; CHECK-NEXT:    vmov r0, s10
; CHECK-NEXT:    vmov.16 q0[2], r0
; CHECK-NEXT:    vmov r0, s11
; CHECK-NEXT:    vmov.16 q0[3], r0
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov.16 q0[4], r0
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmov.16 q0[5], r0
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov.16 q0[6], r0
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    vmov.16 q0[7], r0
; CHECK-NEXT:    bx lr
entry:
  %0 = trunc <8 x i32> %src to <8 x i16>
  ret <8 x i16> %0
}

define arm_aapcs_vfpcc <16 x i8> @trunc_v16i32_v16i8(<16 x i32> %src) {
; CHECK-LABEL: trunc_v16i32_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    vmov q4, q0
; CHECK-NEXT:    vmov r0, s16
; CHECK-NEXT:    vmov.8 q0[0], r0
; CHECK-NEXT:    vmov r0, s17
; CHECK-NEXT:    vmov.8 q0[1], r0
; CHECK-NEXT:    vmov r0, s18
; CHECK-NEXT:    vmov.8 q0[2], r0
; CHECK-NEXT:    vmov r0, s19
; CHECK-NEXT:    vmov.8 q0[3], r0
; CHECK-NEXT:    vmov r0, s4
; CHECK-NEXT:    vmov.8 q0[4], r0
; CHECK-NEXT:    vmov r0, s5
; CHECK-NEXT:    vmov.8 q0[5], r0
; CHECK-NEXT:    vmov r0, s6
; CHECK-NEXT:    vmov.8 q0[6], r0
; CHECK-NEXT:    vmov r0, s7
; CHECK-NEXT:    vmov.8 q0[7], r0
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vmov.8 q0[8], r0
; CHECK-NEXT:    vmov r0, s9
; CHECK-NEXT:    vmov.8 q0[9], r0
; CHECK-NEXT:    vmov r0, s10
; CHECK-NEXT:    vmov.8 q0[10], r0
; CHECK-NEXT:    vmov r0, s11
; CHECK-NEXT:    vmov.8 q0[11], r0
; CHECK-NEXT:    vmov r0, s12
; CHECK-NEXT:    vmov.8 q0[12], r0
; CHECK-NEXT:    vmov r0, s13
; CHECK-NEXT:    vmov.8 q0[13], r0
; CHECK-NEXT:    vmov r0, s14
; CHECK-NEXT:    vmov.8 q0[14], r0
; CHECK-NEXT:    vmov r0, s15
; CHECK-NEXT:    vmov.8 q0[15], r0
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    bx lr
entry:
  %0 = trunc <16 x i32> %src to <16 x i8>
  ret <16 x i8> %0
}

define arm_aapcs_vfpcc <2 x i32> @trunc_v2i64_v2i32(<2 x i64> %src) {
; CHECK-LABEL: trunc_v2i64_v2i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %0 = trunc <2 x i64> %src to <2 x i32>
  ret <2 x i32> %0
}

