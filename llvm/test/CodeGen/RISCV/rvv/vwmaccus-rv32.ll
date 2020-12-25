; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v,+f -verify-machineinstrs \
; RUN:   --riscv-no-aliases < %s | FileCheck %s
declare <vscale x 1 x i16> @llvm.riscv.vwmaccus.nxv1i16.i8(
  <vscale x 1 x i16>,
  i8,
  <vscale x 1 x i8>,
  i32);

define <vscale x 1 x i16>  @intrinsic_vwmaccus_vx_nxv1i16_i8_nxv1i8(<vscale x 1 x i16> %0, i8 %1, <vscale x 1 x i8> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_vx_nxv1i16_i8_nxv1i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e8,mf8,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v17
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x i16> @llvm.riscv.vwmaccus.nxv1i16.i8(
    <vscale x 1 x i16> %0,
    i8 %1,
    <vscale x 1 x i8> %2,
    i32 %3)

  ret <vscale x 1 x i16> %a
}

declare <vscale x 1 x i16> @llvm.riscv.vwmaccus.mask.nxv1i16.i8(
  <vscale x 1 x i16>,
  i8,
  <vscale x 1 x i8>,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x i16> @intrinsic_vwmaccus_mask_vx_nxv1i16_i8_nxv1i8(<vscale x 1 x i16> %0, i8 %1, <vscale x 1 x i8> %2, <vscale x 1 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_mask_vx_nxv1i16_i8_nxv1i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e8,mf8,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v17, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x i16> @llvm.riscv.vwmaccus.mask.nxv1i16.i8(
    <vscale x 1 x i16> %0,
    i8 %1,
    <vscale x 1 x i8> %2,
    <vscale x 1 x i1> %3,
    i32 %4)

  ret <vscale x 1 x i16> %a
}

declare <vscale x 2 x i16> @llvm.riscv.vwmaccus.nxv2i16.i8(
  <vscale x 2 x i16>,
  i8,
  <vscale x 2 x i8>,
  i32);

define <vscale x 2 x i16>  @intrinsic_vwmaccus_vx_nxv2i16_i8_nxv2i8(<vscale x 2 x i16> %0, i8 %1, <vscale x 2 x i8> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_vx_nxv2i16_i8_nxv2i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e8,mf4,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v17
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x i16> @llvm.riscv.vwmaccus.nxv2i16.i8(
    <vscale x 2 x i16> %0,
    i8 %1,
    <vscale x 2 x i8> %2,
    i32 %3)

  ret <vscale x 2 x i16> %a
}

declare <vscale x 2 x i16> @llvm.riscv.vwmaccus.mask.nxv2i16.i8(
  <vscale x 2 x i16>,
  i8,
  <vscale x 2 x i8>,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x i16> @intrinsic_vwmaccus_mask_vx_nxv2i16_i8_nxv2i8(<vscale x 2 x i16> %0, i8 %1, <vscale x 2 x i8> %2, <vscale x 2 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_mask_vx_nxv2i16_i8_nxv2i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e8,mf4,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v17, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x i16> @llvm.riscv.vwmaccus.mask.nxv2i16.i8(
    <vscale x 2 x i16> %0,
    i8 %1,
    <vscale x 2 x i8> %2,
    <vscale x 2 x i1> %3,
    i32 %4)

  ret <vscale x 2 x i16> %a
}

declare <vscale x 4 x i16> @llvm.riscv.vwmaccus.nxv4i16.i8(
  <vscale x 4 x i16>,
  i8,
  <vscale x 4 x i8>,
  i32);

define <vscale x 4 x i16>  @intrinsic_vwmaccus_vx_nxv4i16_i8_nxv4i8(<vscale x 4 x i16> %0, i8 %1, <vscale x 4 x i8> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_vx_nxv4i16_i8_nxv4i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e8,mf2,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v17
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x i16> @llvm.riscv.vwmaccus.nxv4i16.i8(
    <vscale x 4 x i16> %0,
    i8 %1,
    <vscale x 4 x i8> %2,
    i32 %3)

  ret <vscale x 4 x i16> %a
}

declare <vscale x 4 x i16> @llvm.riscv.vwmaccus.mask.nxv4i16.i8(
  <vscale x 4 x i16>,
  i8,
  <vscale x 4 x i8>,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x i16> @intrinsic_vwmaccus_mask_vx_nxv4i16_i8_nxv4i8(<vscale x 4 x i16> %0, i8 %1, <vscale x 4 x i8> %2, <vscale x 4 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_mask_vx_nxv4i16_i8_nxv4i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e8,mf2,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v17, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x i16> @llvm.riscv.vwmaccus.mask.nxv4i16.i8(
    <vscale x 4 x i16> %0,
    i8 %1,
    <vscale x 4 x i8> %2,
    <vscale x 4 x i1> %3,
    i32 %4)

  ret <vscale x 4 x i16> %a
}

declare <vscale x 8 x i16> @llvm.riscv.vwmaccus.nxv8i16.i8(
  <vscale x 8 x i16>,
  i8,
  <vscale x 8 x i8>,
  i32);

define <vscale x 8 x i16>  @intrinsic_vwmaccus_vx_nxv8i16_i8_nxv8i8(<vscale x 8 x i16> %0, i8 %1, <vscale x 8 x i8> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_vx_nxv8i16_i8_nxv8i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e8,m1,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v18
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x i16> @llvm.riscv.vwmaccus.nxv8i16.i8(
    <vscale x 8 x i16> %0,
    i8 %1,
    <vscale x 8 x i8> %2,
    i32 %3)

  ret <vscale x 8 x i16> %a
}

declare <vscale x 8 x i16> @llvm.riscv.vwmaccus.mask.nxv8i16.i8(
  <vscale x 8 x i16>,
  i8,
  <vscale x 8 x i8>,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x i16> @intrinsic_vwmaccus_mask_vx_nxv8i16_i8_nxv8i8(<vscale x 8 x i16> %0, i8 %1, <vscale x 8 x i8> %2, <vscale x 8 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_mask_vx_nxv8i16_i8_nxv8i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e8,m1,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v18, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x i16> @llvm.riscv.vwmaccus.mask.nxv8i16.i8(
    <vscale x 8 x i16> %0,
    i8 %1,
    <vscale x 8 x i8> %2,
    <vscale x 8 x i1> %3,
    i32 %4)

  ret <vscale x 8 x i16> %a
}

declare <vscale x 16 x i16> @llvm.riscv.vwmaccus.nxv16i16.i8(
  <vscale x 16 x i16>,
  i8,
  <vscale x 16 x i8>,
  i32);

define <vscale x 16 x i16>  @intrinsic_vwmaccus_vx_nxv16i16_i8_nxv16i8(<vscale x 16 x i16> %0, i8 %1, <vscale x 16 x i8> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_vx_nxv16i16_i8_nxv16i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e8,m2,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v20
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x i16> @llvm.riscv.vwmaccus.nxv16i16.i8(
    <vscale x 16 x i16> %0,
    i8 %1,
    <vscale x 16 x i8> %2,
    i32 %3)

  ret <vscale x 16 x i16> %a
}

declare <vscale x 16 x i16> @llvm.riscv.vwmaccus.mask.nxv16i16.i8(
  <vscale x 16 x i16>,
  i8,
  <vscale x 16 x i8>,
  <vscale x 16 x i1>,
  i32);

define <vscale x 16 x i16> @intrinsic_vwmaccus_mask_vx_nxv16i16_i8_nxv16i8(<vscale x 16 x i16> %0, i8 %1, <vscale x 16 x i8> %2, <vscale x 16 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_mask_vx_nxv16i16_i8_nxv16i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e8,m2,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v20, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x i16> @llvm.riscv.vwmaccus.mask.nxv16i16.i8(
    <vscale x 16 x i16> %0,
    i8 %1,
    <vscale x 16 x i8> %2,
    <vscale x 16 x i1> %3,
    i32 %4)

  ret <vscale x 16 x i16> %a
}

declare <vscale x 32 x i16> @llvm.riscv.vwmaccus.nxv32i16.i8(
  <vscale x 32 x i16>,
  i8,
  <vscale x 32 x i8>,
  i32);

define <vscale x 32 x i16>  @intrinsic_vwmaccus_vx_nxv32i16_i8_nxv32i8(<vscale x 32 x i16> %0, i8 %1, <vscale x 32 x i8> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_vx_nxv32i16_i8_nxv32i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a3, zero, e8,m4,ta,mu
; CHECK-NEXT:    vle8.v v28, (a1)
; CHECK-NEXT:    vsetvli a1, a2, e8,m4,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v28
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 32 x i16> @llvm.riscv.vwmaccus.nxv32i16.i8(
    <vscale x 32 x i16> %0,
    i8 %1,
    <vscale x 32 x i8> %2,
    i32 %3)

  ret <vscale x 32 x i16> %a
}

declare <vscale x 32 x i16> @llvm.riscv.vwmaccus.mask.nxv32i16.i8(
  <vscale x 32 x i16>,
  i8,
  <vscale x 32 x i8>,
  <vscale x 32 x i1>,
  i32);

define <vscale x 32 x i16> @intrinsic_vwmaccus_mask_vx_nxv32i16_i8_nxv32i8(<vscale x 32 x i16> %0, i8 %1, <vscale x 32 x i8> %2, <vscale x 32 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_mask_vx_nxv32i16_i8_nxv32i8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a3, zero, e8,m4,ta,mu
; CHECK-NEXT:    vle8.v v28, (a1)
; CHECK-NEXT:    vsetvli a1, a2, e8,m4,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v28, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 32 x i16> @llvm.riscv.vwmaccus.mask.nxv32i16.i8(
    <vscale x 32 x i16> %0,
    i8 %1,
    <vscale x 32 x i8> %2,
    <vscale x 32 x i1> %3,
    i32 %4)

  ret <vscale x 32 x i16> %a
}

declare <vscale x 1 x i32> @llvm.riscv.vwmaccus.nxv1i32.i16(
  <vscale x 1 x i32>,
  i16,
  <vscale x 1 x i16>,
  i32);

define <vscale x 1 x i32>  @intrinsic_vwmaccus_vx_nxv1i32_i16_nxv1i16(<vscale x 1 x i32> %0, i16 %1, <vscale x 1 x i16> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_vx_nxv1i32_i16_nxv1i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e16,mf4,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v17
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x i32> @llvm.riscv.vwmaccus.nxv1i32.i16(
    <vscale x 1 x i32> %0,
    i16 %1,
    <vscale x 1 x i16> %2,
    i32 %3)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 1 x i32> @llvm.riscv.vwmaccus.mask.nxv1i32.i16(
  <vscale x 1 x i32>,
  i16,
  <vscale x 1 x i16>,
  <vscale x 1 x i1>,
  i32);

define <vscale x 1 x i32> @intrinsic_vwmaccus_mask_vx_nxv1i32_i16_nxv1i16(<vscale x 1 x i32> %0, i16 %1, <vscale x 1 x i16> %2, <vscale x 1 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_mask_vx_nxv1i32_i16_nxv1i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e16,mf4,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v17, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x i32> @llvm.riscv.vwmaccus.mask.nxv1i32.i16(
    <vscale x 1 x i32> %0,
    i16 %1,
    <vscale x 1 x i16> %2,
    <vscale x 1 x i1> %3,
    i32 %4)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vwmaccus.nxv2i32.i16(
  <vscale x 2 x i32>,
  i16,
  <vscale x 2 x i16>,
  i32);

define <vscale x 2 x i32>  @intrinsic_vwmaccus_vx_nxv2i32_i16_nxv2i16(<vscale x 2 x i32> %0, i16 %1, <vscale x 2 x i16> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_vx_nxv2i32_i16_nxv2i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e16,mf2,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v17
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x i32> @llvm.riscv.vwmaccus.nxv2i32.i16(
    <vscale x 2 x i32> %0,
    i16 %1,
    <vscale x 2 x i16> %2,
    i32 %3)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vwmaccus.mask.nxv2i32.i16(
  <vscale x 2 x i32>,
  i16,
  <vscale x 2 x i16>,
  <vscale x 2 x i1>,
  i32);

define <vscale x 2 x i32> @intrinsic_vwmaccus_mask_vx_nxv2i32_i16_nxv2i16(<vscale x 2 x i32> %0, i16 %1, <vscale x 2 x i16> %2, <vscale x 2 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_mask_vx_nxv2i32_i16_nxv2i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e16,mf2,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v17, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x i32> @llvm.riscv.vwmaccus.mask.nxv2i32.i16(
    <vscale x 2 x i32> %0,
    i16 %1,
    <vscale x 2 x i16> %2,
    <vscale x 2 x i1> %3,
    i32 %4)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vwmaccus.nxv4i32.i16(
  <vscale x 4 x i32>,
  i16,
  <vscale x 4 x i16>,
  i32);

define <vscale x 4 x i32>  @intrinsic_vwmaccus_vx_nxv4i32_i16_nxv4i16(<vscale x 4 x i32> %0, i16 %1, <vscale x 4 x i16> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_vx_nxv4i32_i16_nxv4i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e16,m1,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v18
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x i32> @llvm.riscv.vwmaccus.nxv4i32.i16(
    <vscale x 4 x i32> %0,
    i16 %1,
    <vscale x 4 x i16> %2,
    i32 %3)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vwmaccus.mask.nxv4i32.i16(
  <vscale x 4 x i32>,
  i16,
  <vscale x 4 x i16>,
  <vscale x 4 x i1>,
  i32);

define <vscale x 4 x i32> @intrinsic_vwmaccus_mask_vx_nxv4i32_i16_nxv4i16(<vscale x 4 x i32> %0, i16 %1, <vscale x 4 x i16> %2, <vscale x 4 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_mask_vx_nxv4i32_i16_nxv4i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e16,m1,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v18, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x i32> @llvm.riscv.vwmaccus.mask.nxv4i32.i16(
    <vscale x 4 x i32> %0,
    i16 %1,
    <vscale x 4 x i16> %2,
    <vscale x 4 x i1> %3,
    i32 %4)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vwmaccus.nxv8i32.i16(
  <vscale x 8 x i32>,
  i16,
  <vscale x 8 x i16>,
  i32);

define <vscale x 8 x i32>  @intrinsic_vwmaccus_vx_nxv8i32_i16_nxv8i16(<vscale x 8 x i32> %0, i16 %1, <vscale x 8 x i16> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_vx_nxv8i32_i16_nxv8i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e16,m2,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v20
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x i32> @llvm.riscv.vwmaccus.nxv8i32.i16(
    <vscale x 8 x i32> %0,
    i16 %1,
    <vscale x 8 x i16> %2,
    i32 %3)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vwmaccus.mask.nxv8i32.i16(
  <vscale x 8 x i32>,
  i16,
  <vscale x 8 x i16>,
  <vscale x 8 x i1>,
  i32);

define <vscale x 8 x i32> @intrinsic_vwmaccus_mask_vx_nxv8i32_i16_nxv8i16(<vscale x 8 x i32> %0, i16 %1, <vscale x 8 x i16> %2, <vscale x 8 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_mask_vx_nxv8i32_i16_nxv8i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e16,m2,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v20, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x i32> @llvm.riscv.vwmaccus.mask.nxv8i32.i16(
    <vscale x 8 x i32> %0,
    i16 %1,
    <vscale x 8 x i16> %2,
    <vscale x 8 x i1> %3,
    i32 %4)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vwmaccus.nxv16i32.i16(
  <vscale x 16 x i32>,
  i16,
  <vscale x 16 x i16>,
  i32);

define <vscale x 16 x i32>  @intrinsic_vwmaccus_vx_nxv16i32_i16_nxv16i16(<vscale x 16 x i32> %0, i16 %1, <vscale x 16 x i16> %2, i32 %3) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_vx_nxv16i32_i16_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a3, zero, e16,m4,ta,mu
; CHECK-NEXT:    vle16.v v28, (a1)
; CHECK-NEXT:    vsetvli a1, a2, e16,m4,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v28
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x i32> @llvm.riscv.vwmaccus.nxv16i32.i16(
    <vscale x 16 x i32> %0,
    i16 %1,
    <vscale x 16 x i16> %2,
    i32 %3)

  ret <vscale x 16 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vwmaccus.mask.nxv16i32.i16(
  <vscale x 16 x i32>,
  i16,
  <vscale x 16 x i16>,
  <vscale x 16 x i1>,
  i32);

define <vscale x 16 x i32> @intrinsic_vwmaccus_mask_vx_nxv16i32_i16_nxv16i16(<vscale x 16 x i32> %0, i16 %1, <vscale x 16 x i16> %2, <vscale x 16 x i1> %3, i32 %4) nounwind {
; CHECK-LABEL: intrinsic_vwmaccus_mask_vx_nxv16i32_i16_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a3, zero, e16,m4,ta,mu
; CHECK-NEXT:    vle16.v v28, (a1)
; CHECK-NEXT:    vsetvli a1, a2, e16,m4,ta,mu
; CHECK-NEXT:    vwmaccus.vx v16, a0, v28, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x i32> @llvm.riscv.vwmaccus.mask.nxv16i32.i16(
    <vscale x 16 x i32> %0,
    i16 %1,
    <vscale x 16 x i16> %2,
    <vscale x 16 x i1> %3,
    i32 %4)

  ret <vscale x 16 x i32> %a
}
