; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=knl -mattr=+avx512dq | FileCheck %s

declare <2 x double> @llvm.x86.avx512.mask.vextractf64x2.512(<8 x double>, i32, <2 x double>, i8)

define <2 x double>@test_int_x86_avx512_mask_vextractf64x2_512(<8 x double> %x0, <2 x double> %x2, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vextractf64x2_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vextractf64x2 $1, %zmm0, %xmm0
; CHECK-NEXT:    kmovb %edi, %k0
; CHECK-NEXT:    kshiftlb $7, %k0, %k1
; CHECK-NEXT:    kshiftrb $7, %k1, %k1
; CHECK-NEXT:    kshiftlb $6, %k0, %k0
; CHECK-NEXT:    kshiftrb $7, %k0, %k0
; CHECK-NEXT:    kmovw %k0, %eax
; CHECK-NEXT:    vmovq %rax, %xmm2
; CHECK-NEXT:    kmovw %k1, %eax
; CHECK-NEXT:    vmovq %rax, %xmm3
; CHECK-NEXT:    vpunpcklqdq {{.*#+}} xmm2 = xmm3[0],xmm2[0]
; CHECK-NEXT:    vpsllq $63, %xmm2, %xmm2
; CHECK-NEXT:    vpsraq $63, %zmm2, %zmm2
; CHECK-NEXT:    vblendvpd %xmm2, %xmm0, %xmm1, %xmm1
; CHECK-NEXT:    vandpd %xmm0, %xmm2, %xmm2
; CHECK-NEXT:    vaddpd %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vaddpd %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x double> @llvm.x86.avx512.mask.vextractf64x2.512(<8 x double> %x0,i32 1, <2 x double> %x2, i8 %x3)
  %res2 = call <2 x double> @llvm.x86.avx512.mask.vextractf64x2.512(<8 x double> %x0,i32 1, <2 x double> zeroinitializer, i8 %x3)
  %res1 = call <2 x double> @llvm.x86.avx512.mask.vextractf64x2.512(<8 x double> %x0,i32 1, <2 x double> zeroinitializer, i8 -1)
  %res3 = fadd <2 x double> %res, %res1
  %res4 = fadd <2 x double> %res2, %res3
  ret <2 x double> %res4
}

declare <8 x float> @llvm.x86.avx512.mask.vextractf32x8.512(<16 x float>, i32, <8 x float>, i8)

define <8 x float>@test_int_x86_avx512_mask_vextractf32x8(<16 x float> %x0, <8 x float> %x2, i8 %x3) {
; CHECK-LABEL: test_int_x86_avx512_mask_vextractf32x8:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vextractf32x8 $1, %zmm0, %ymm2
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vextractf32x8 $1, %zmm0, %ymm1 {%k1}
; CHECK-NEXT:    vextractf32x8 $1, %zmm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    vaddps %ymm2, %ymm1, %ymm1
; CHECK-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %res  = call <8 x float> @llvm.x86.avx512.mask.vextractf32x8.512(<16 x float> %x0,i32 1, <8 x float> %x2, i8 %x3)
  %res2 = call <8 x float> @llvm.x86.avx512.mask.vextractf32x8.512(<16 x float> %x0,i32 1, <8 x float> zeroinitializer, i8 %x3)
  %res1 = call <8 x float> @llvm.x86.avx512.mask.vextractf32x8.512(<16 x float> %x0,i32 1, <8 x float> zeroinitializer, i8 -1)
  %res3 = fadd <8 x float> %res, %res1
  %res4 = fadd <8 x float> %res2, %res3
  ret <8 x float> %res4
}

declare <16 x float> @llvm.x86.avx512.mask.insertf32x8.512(<16 x float>, <8 x float>, i32, <16 x float>, i16)

define <16 x float>@test_int_x86_avx512_mask_insertf32x8_512(<16 x float> %x0, <8 x float> %x1, <16 x float> %x3, i16 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_insertf32x8_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vinsertf32x8 $1, %ymm1, %zmm0, %zmm3
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vinsertf32x8 $1, %ymm1, %zmm0, %zmm2 {%k1}
; CHECK-NEXT:    vinsertf32x8 $1, %ymm1, %zmm0, %zmm0 {%k1} {z}
; CHECK-NEXT:    vaddps %zmm0, %zmm2, %zmm0
; CHECK-NEXT:    vaddps %zmm0, %zmm3, %zmm0
; CHECK-NEXT:    retq
  %res = call <16 x float> @llvm.x86.avx512.mask.insertf32x8.512(<16 x float> %x0, <8 x float> %x1, i32 1, <16 x float> %x3, i16 %x4)
  %res1 = call <16 x float> @llvm.x86.avx512.mask.insertf32x8.512(<16 x float> %x0, <8 x float> %x1, i32 1, <16 x float> zeroinitializer, i16 %x4)
  %res2 = call <16 x float> @llvm.x86.avx512.mask.insertf32x8.512(<16 x float> %x0, <8 x float> %x1, i32 1, <16 x float> %x3, i16 -1)
  %res3 = fadd <16 x float> %res, %res1
  %res4 = fadd <16 x float> %res2, %res3
  ret <16 x float> %res4
}

declare <8 x double> @llvm.x86.avx512.mask.insertf64x2.512(<8 x double>, <2 x double>, i32, <8 x double>, i8)

define <8 x double>@test_int_x86_avx512_mask_insertf64x2_512(<8 x double> %x0, <2 x double> %x1,<8 x double> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_insertf64x2_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vinsertf64x2 $1, %xmm1, %zmm0, %zmm3
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vinsertf64x2 $1, %xmm1, %zmm0, %zmm2 {%k1}
; CHECK-NEXT:    vinsertf64x2 $1, %xmm1, %zmm0, %zmm0 {%k1} {z}
; CHECK-NEXT:    vaddpd %zmm0, %zmm2, %zmm0
; CHECK-NEXT:    vaddpd %zmm3, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x double> @llvm.x86.avx512.mask.insertf64x2.512(<8 x double> %x0, <2 x double> %x1, i32 1, <8 x double> %x3, i8 %x4)
  %res1 = call <8 x double> @llvm.x86.avx512.mask.insertf64x2.512(<8 x double> %x0, <2 x double> %x1, i32 1, <8 x double> zeroinitializer, i8 %x4)
  %res2 = call <8 x double> @llvm.x86.avx512.mask.insertf64x2.512(<8 x double> %x0, <2 x double> %x1, i32 1, <8 x double> %x3, i8 -1)
  %res3 = fadd <8 x double> %res, %res1
  %res4 = fadd <8 x double> %res3, %res2
  ret <8 x double> %res4
}

declare <16 x i32> @llvm.x86.avx512.mask.inserti32x8.512(<16 x i32>, <8 x i32>, i32, <16 x i32>, i16)

define <16 x i32>@test_int_x86_avx512_mask_inserti32x8_512(<16 x i32> %x0, <8 x i32> %x1, <16 x i32> %x3, i16 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_inserti32x8_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vinserti32x8 $1, %ymm1, %zmm0, %zmm3
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vinserti32x8 $1, %ymm1, %zmm0, %zmm2 {%k1}
; CHECK-NEXT:    vinserti32x8 $1, %ymm1, %zmm0, %zmm0 {%k1} {z}
; CHECK-NEXT:    vpaddd %zmm0, %zmm2, %zmm0
; CHECK-NEXT:    vpaddd %zmm3, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %res = call <16 x i32> @llvm.x86.avx512.mask.inserti32x8.512(<16 x i32> %x0, <8 x i32> %x1, i32 1, <16 x i32> %x3, i16 %x4)
  %res1 = call <16 x i32> @llvm.x86.avx512.mask.inserti32x8.512(<16 x i32> %x0, <8 x i32> %x1, i32 1, <16 x i32> zeroinitializer, i16 %x4)
  %res2 = call <16 x i32> @llvm.x86.avx512.mask.inserti32x8.512(<16 x i32> %x0, <8 x i32> %x1, i32 1, <16 x i32> %x3, i16 -1)
  %res3 = add <16 x i32> %res, %res1
  %res4 = add <16 x i32> %res3, %res2
  ret <16 x i32> %res4
}

declare <8 x i64> @llvm.x86.avx512.mask.inserti64x2.512(<8 x i64>, <2 x i64>, i32, <8 x i64>, i8)

define <8 x i64>@test_int_x86_avx512_mask_inserti64x2_512(<8 x i64> %x0, <2 x i64> %x1, <8 x i64> %x3, i8 %x4) {
; CHECK-LABEL: test_int_x86_avx512_mask_inserti64x2_512:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vinserti64x2 $1, %xmm1, %zmm0, %zmm3
; CHECK-NEXT:    kmovb %edi, %k1
; CHECK-NEXT:    vinserti64x2 $1, %xmm1, %zmm0, %zmm2 {%k1}
; CHECK-NEXT:    vinserti64x2 $1, %xmm1, %zmm0, %zmm0 {%k1} {z}
; CHECK-NEXT:    vpaddq %zmm0, %zmm2, %zmm0
; CHECK-NEXT:    vpaddq %zmm0, %zmm3, %zmm0
; CHECK-NEXT:    retq
  %res = call <8 x i64> @llvm.x86.avx512.mask.inserti64x2.512(<8 x i64> %x0, <2 x i64> %x1, i32 1, <8 x i64> %x3, i8 %x4)
  %res1 = call <8 x i64> @llvm.x86.avx512.mask.inserti64x2.512(<8 x i64> %x0, <2 x i64> %x1, i32 1, <8 x i64> zeroinitializer, i8 %x4)
  %res2 = call <8 x i64> @llvm.x86.avx512.mask.inserti64x2.512(<8 x i64> %x0, <2 x i64> %x1, i32 1, <8 x i64> %x3, i8 -1)
  %res3 = add <8 x i64> %res, %res1
  %res4 = add <8 x i64> %res2, %res3
  ret <8 x i64> %res4
}
