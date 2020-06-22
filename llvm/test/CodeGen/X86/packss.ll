; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE --check-prefix=X86-SSE
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefix=AVX --check-prefix=AVX1 --check-prefix=X86-AVX --check-prefix=X86-AVX1
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2 --check-prefix=X86-AVX --check-prefix=X86-AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE --check-prefix=X64-SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefix=AVX --check-prefix=AVX1 --check-prefix=X64-AVX --check-prefix=X64-AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2 --check-prefix=X64-AVX --check-prefix=X64-AVX2

define <4 x i32> @trunc_ashr_v4i64(<4 x i64> %a) nounwind {
; SSE-LABEL: trunc_ashr_v4i64:
; SSE:       # %bb.0:
; SSE-NEXT:    psrad $31, %xmm1
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE-NEXT:    psrad $31, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE-NEXT:    packssdw %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX1-LABEL: trunc_ashr_v4i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpcmpgtq %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpcmpgtq %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    ret{{[l|q]}}
;
; AVX2-LABEL: trunc_ashr_v4i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpgtq %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    ret{{[l|q]}}
  %1 = ashr <4 x i64> %a, <i64 63, i64 63, i64 63, i64 63>
  %2 = trunc <4 x i64> %1 to <4 x i32>
  ret <4 x i32> %2
}

define <8 x i16> @trunc_ashr_v4i64_bitcast(<4 x i64> %a0) {
; SSE-LABEL: trunc_ashr_v4i64_bitcast:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm1, %xmm2
; SSE-NEXT:    psrad $31, %xmm2
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; SSE-NEXT:    psrad $17, %xmm1
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,3,2,3]
; SSE-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm2[0],xmm1[1],xmm2[1]
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    psrad $31, %xmm2
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,3,2,3]
; SSE-NEXT:    psrad $17, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,3,2,3]
; SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; SSE-NEXT:    packssdw %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX1-LABEL: trunc_ashr_v4i64_bitcast:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpsrad $31, %xmm1, %xmm2
; AVX1-NEXT:    vpsrad $17, %xmm1, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm2
; AVX1-NEXT:    vpsrad $17, %xmm0, %xmm0
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; AVX1-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    ret{{[l|q]}}
;
; AVX2-LABEL: trunc_ashr_v4i64_bitcast:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrad $31, %ymm0, %ymm1
; AVX2-NEXT:    vpsrad $17, %ymm0, %ymm0
; AVX2-NEXT:    vpshufd {{.*#+}} ymm0 = ymm0[1,1,3,3,5,5,7,7]
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0],ymm1[1],ymm0[2],ymm1[3],ymm0[4],ymm1[5],ymm0[6],ymm1[7]
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    ret{{[l|q]}}
   %1 = ashr <4 x i64> %a0, <i64 49, i64 49, i64 49, i64 49>
   %2 = bitcast <4 x i64> %1 to <8 x i32>
   %3 = trunc <8 x i32> %2 to <8 x i16>
   ret <8 x i16> %3
}

define <8 x i16> @trunc_ashr_v8i32(<8 x i32> %a) nounwind {
; SSE-LABEL: trunc_ashr_v8i32:
; SSE:       # %bb.0:
; SSE-NEXT:    psrad $31, %xmm1
; SSE-NEXT:    psrad $31, %xmm0
; SSE-NEXT:    packssdw %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX1-LABEL: trunc_ashr_v8i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpsrad $31, %xmm1, %xmm1
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm0
; AVX1-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    ret{{[l|q]}}
;
; AVX2-LABEL: trunc_ashr_v8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrad $31, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    ret{{[l|q]}}
  %1 = ashr <8 x i32> %a, <i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31>
  %2 = trunc <8 x i32> %1 to <8 x i16>
  ret <8 x i16> %2
}

define <8 x i16> @trunc_ashr_v4i32_icmp_v4i32(<4 x i32> %a, <4 x i32> %b) nounwind {
; X86-SSE-LABEL: trunc_ashr_v4i32_icmp_v4i32:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    psrad $31, %xmm0
; X86-SSE-NEXT:    pcmpgtd {{\.LCPI.*}}, %xmm1
; X86-SSE-NEXT:    packssdw %xmm1, %xmm0
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: trunc_ashr_v4i32_icmp_v4i32:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    vpsrad $31, %xmm0, %xmm0
; X86-AVX-NEXT:    vpcmpgtd {{\.LCPI.*}}, %xmm1, %xmm1
; X86-AVX-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; X86-AVX-NEXT:    retl
;
; X64-SSE-LABEL: trunc_ashr_v4i32_icmp_v4i32:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    psrad $31, %xmm0
; X64-SSE-NEXT:    pcmpgtd {{.*}}(%rip), %xmm1
; X64-SSE-NEXT:    packssdw %xmm1, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: trunc_ashr_v4i32_icmp_v4i32:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vpsrad $31, %xmm0, %xmm0
; X64-AVX-NEXT:    vpcmpgtd {{.*}}(%rip), %xmm1, %xmm1
; X64-AVX-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; X64-AVX-NEXT:    retq
  %1 = ashr <4 x i32> %a, <i32 31, i32 31, i32 31, i32 31>
  %2 = icmp sgt <4 x i32> %b, <i32 1, i32 16, i32 255, i32 65535>
  %3 = sext <4 x i1> %2 to <4 x i32>
  %4 = shufflevector <4 x i32> %1, <4 x i32> %3, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %5 = trunc <8 x i32> %4 to <8 x i16>
  ret <8 x i16> %5
}

define <8 x i16> @trunc_ashr_v4i64_demandedelts(<4 x i64> %a0) {
; X86-SSE-LABEL: trunc_ashr_v4i64_demandedelts:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    psllq $63, %xmm1
; X86-SSE-NEXT:    psllq $63, %xmm0
; X86-SSE-NEXT:    psrlq $63, %xmm0
; X86-SSE-NEXT:    movdqa {{.*#+}} xmm2 = [1,0,0,0]
; X86-SSE-NEXT:    pxor %xmm2, %xmm0
; X86-SSE-NEXT:    psubq %xmm2, %xmm0
; X86-SSE-NEXT:    psrlq $63, %xmm1
; X86-SSE-NEXT:    pxor %xmm2, %xmm1
; X86-SSE-NEXT:    psubq %xmm2, %xmm1
; X86-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,0,0,0]
; X86-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; X86-SSE-NEXT:    packssdw %xmm1, %xmm0
; X86-SSE-NEXT:    retl
;
; X86-AVX1-LABEL: trunc_ashr_v4i64_demandedelts:
; X86-AVX1:       # %bb.0:
; X86-AVX1-NEXT:    vpsllq $63, %xmm0, %xmm1
; X86-AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; X86-AVX1-NEXT:    vpsllq $63, %xmm0, %xmm0
; X86-AVX1-NEXT:    vpsrlq $63, %xmm0, %xmm0
; X86-AVX1-NEXT:    vmovddup {{.*#+}} xmm2 = [1,1]
; X86-AVX1-NEXT:    # xmm2 = mem[0,0]
; X86-AVX1-NEXT:    vpxor %xmm2, %xmm0, %xmm0
; X86-AVX1-NEXT:    vpcmpeqd %xmm3, %xmm3, %xmm3
; X86-AVX1-NEXT:    vpaddq %xmm3, %xmm0, %xmm0
; X86-AVX1-NEXT:    vpsrlq $63, %xmm1, %xmm1
; X86-AVX1-NEXT:    vpxor %xmm2, %xmm1, %xmm1
; X86-AVX1-NEXT:    vpaddq %xmm3, %xmm1, %xmm1
; X86-AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; X86-AVX1-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[0,0,0,0,4,4,4,4]
; X86-AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X86-AVX1-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; X86-AVX1-NEXT:    vzeroupper
; X86-AVX1-NEXT:    retl
;
; X86-AVX2-LABEL: trunc_ashr_v4i64_demandedelts:
; X86-AVX2:       # %bb.0:
; X86-AVX2-NEXT:    vbroadcasti128 {{.*#+}} ymm1 = [63,0,0,0,63,0,0,0]
; X86-AVX2-NEXT:    # ymm1 = mem[0,1,0,1]
; X86-AVX2-NEXT:    vpsllvq %ymm1, %ymm0, %ymm0
; X86-AVX2-NEXT:    vmovdqa {{.*#+}} ymm2 = [0,2147483648,0,2147483648,0,2147483648,0,2147483648]
; X86-AVX2-NEXT:    vpsrlvq %ymm1, %ymm2, %ymm2
; X86-AVX2-NEXT:    vpsrlvq %ymm1, %ymm0, %ymm0
; X86-AVX2-NEXT:    vpxor %ymm2, %ymm0, %ymm0
; X86-AVX2-NEXT:    vpsubq %ymm2, %ymm0, %ymm0
; X86-AVX2-NEXT:    vpshufd {{.*#+}} ymm0 = ymm0[0,0,0,0,4,4,4,4]
; X86-AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; X86-AVX2-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; X86-AVX2-NEXT:    vzeroupper
; X86-AVX2-NEXT:    retl
;
; X64-SSE-LABEL: trunc_ashr_v4i64_demandedelts:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    psllq $63, %xmm1
; X64-SSE-NEXT:    psllq $63, %xmm0
; X64-SSE-NEXT:    psrlq $63, %xmm0
; X64-SSE-NEXT:    movdqa {{.*#+}} xmm2 = [1,9223372036854775808]
; X64-SSE-NEXT:    pxor %xmm2, %xmm0
; X64-SSE-NEXT:    psubq %xmm2, %xmm0
; X64-SSE-NEXT:    psrlq $63, %xmm1
; X64-SSE-NEXT:    pxor %xmm2, %xmm1
; X64-SSE-NEXT:    psubq %xmm2, %xmm1
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,0,0,0]
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,0,0,0]
; X64-SSE-NEXT:    packssdw %xmm1, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX1-LABEL: trunc_ashr_v4i64_demandedelts:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vpsllq $63, %xmm0, %xmm1
; X64-AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; X64-AVX1-NEXT:    vpsllq $63, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpsrlq $63, %xmm0, %xmm0
; X64-AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [1,9223372036854775808]
; X64-AVX1-NEXT:    vpxor %xmm2, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpsubq %xmm2, %xmm0, %xmm0
; X64-AVX1-NEXT:    vpsrlq $63, %xmm1, %xmm1
; X64-AVX1-NEXT:    vpxor %xmm2, %xmm1, %xmm1
; X64-AVX1-NEXT:    vpsubq %xmm2, %xmm1, %xmm1
; X64-AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; X64-AVX1-NEXT:    vpermilps {{.*#+}} ymm0 = ymm0[0,0,0,0,4,4,4,4]
; X64-AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; X64-AVX1-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; X64-AVX1-NEXT:    vzeroupper
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: trunc_ashr_v4i64_demandedelts:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpbroadcastq {{.*#+}} ymm1 = [1,1,1,1]
; X64-AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm0
; X64-AVX2-NEXT:    vbroadcasti128 {{.*#+}} ymm1 = [1,9223372036854775808,1,9223372036854775808]
; X64-AVX2-NEXT:    # ymm1 = mem[0,1,0,1]
; X64-AVX2-NEXT:    vpxor %ymm1, %ymm0, %ymm0
; X64-AVX2-NEXT:    vpsubq %ymm1, %ymm0, %ymm0
; X64-AVX2-NEXT:    vpshufd {{.*#+}} ymm0 = ymm0[0,0,0,0,4,4,4,4]
; X64-AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; X64-AVX2-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    vzeroupper
; X64-AVX2-NEXT:    retq
  %1 = shl <4 x i64> %a0, <i64 63, i64 0, i64 63, i64 0>
  %2 = ashr <4 x i64> %1, <i64 63, i64 0, i64 63, i64 0>
  %3 = bitcast <4 x i64> %2 to <8 x i32>
  %4 = shufflevector <8 x i32> %3, <8 x i32> undef, <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 4, i32 4, i32 4, i32 4>
  %5 = trunc <8 x i32> %4 to <8 x i16>
  ret <8 x i16> %5
}

define <16 x i8> @packsswb_icmp_zero_128(<8 x i16> %a0) {
; SSE-LABEL: packsswb_icmp_zero_128:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    pcmpeqw %xmm1, %xmm0
; SSE-NEXT:    packsswb %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: packsswb_icmp_zero_128:
; AVX:       # %bb.0:
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %1 = icmp eq <8 x i16> %a0, zeroinitializer
  %2 = sext <8 x i1> %1 to <8 x i8>
  %3 = shufflevector <8 x i8> %2, <8 x i8> zeroinitializer, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  ret <16 x i8> %3
}

define <16 x i8> @packsswb_icmp_zero_trunc_128(<8 x i16> %a0) {
; SSE-LABEL: packsswb_icmp_zero_trunc_128:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    pcmpeqw %xmm1, %xmm0
; SSE-NEXT:    packsswb %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: packsswb_icmp_zero_trunc_128:
; AVX:       # %bb.0:
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %1 = icmp eq <8 x i16> %a0, zeroinitializer
  %2 = sext <8 x i1> %1 to <8 x i16>
  %3 = shufflevector <8 x i16> %2, <8 x i16> zeroinitializer, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %4 = trunc <16 x i16> %3 to <16 x i8>
  ret <16 x i8> %4
}

define <32 x i8> @packsswb_icmp_zero_256(<16 x i16> %a0) {
; SSE-LABEL: packsswb_icmp_zero_256:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm2, %xmm2
; SSE-NEXT:    pcmpeqw %xmm2, %xmm1
; SSE-NEXT:    pcmpeqw %xmm2, %xmm0
; SSE-NEXT:    pxor %xmm3, %xmm3
; SSE-NEXT:    packsswb %xmm0, %xmm3
; SSE-NEXT:    packsswb %xmm1, %xmm2
; SSE-NEXT:    movdqa %xmm3, %xmm0
; SSE-NEXT:    movdqa %xmm2, %xmm1
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX1-LABEL: packsswb_icmp_zero_256:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpcmpeqw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpacksswb %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vpacksswb %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    ret{{[l|q]}}
;
; AVX2-LABEL: packsswb_icmp_zero_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpeqw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpacksswb %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    ret{{[l|q]}}
  %1 = icmp eq <16 x i16> %a0, zeroinitializer
  %2 = sext <16 x i1> %1 to <16 x i16>
  %3 = bitcast <16 x i16> %2 to <32 x i8>
  %4 = shufflevector <32 x i8> zeroinitializer, <32 x i8> %3, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 32, i32 34, i32 36, i32 38, i32 40, i32 42, i32 44, i32 46, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 48, i32 50, i32 52, i32 54, i32 56, i32 58, i32 60, i32 62>
  ret <32 x i8> %4
}

define <32 x i8> @packsswb_icmp_zero_trunc_256(<16 x i16> %a0) {
; SSE-LABEL: packsswb_icmp_zero_trunc_256:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm2, %xmm2
; SSE-NEXT:    pcmpeqw %xmm2, %xmm1
; SSE-NEXT:    pcmpeqw %xmm2, %xmm0
; SSE-NEXT:    pxor %xmm3, %xmm3
; SSE-NEXT:    packsswb %xmm0, %xmm3
; SSE-NEXT:    packsswb %xmm1, %xmm2
; SSE-NEXT:    movdqa %xmm3, %xmm0
; SSE-NEXT:    movdqa %xmm2, %xmm1
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX1-LABEL: packsswb_icmp_zero_trunc_256:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpcmpeqw %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpcmpeqw %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; AVX1-NEXT:    vperm2f128 {{.*#+}} ymm2 = zero,zero,ymm0[0,1]
; AVX1-NEXT:    vblendps {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm1
; AVX1-NEXT:    vpacksswb %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    ret{{[l|q]}}
;
; AVX2-LABEL: packsswb_icmp_zero_trunc_256:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpeqw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpblendd {{.*#+}} ymm1 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX2-NEXT:    vperm2i128 {{.*#+}} ymm0 = zero,zero,ymm0[0,1]
; AVX2-NEXT:    vpacksswb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,1,3]
; AVX2-NEXT:    ret{{[l|q]}}
  %1 = icmp eq <16 x i16> %a0, zeroinitializer
  %2 = sext <16 x i1> %1 to <16 x i16>
  %3 = shufflevector <16 x i16> zeroinitializer, <16 x i16> %2, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %4 = trunc <32 x i16> %3 to <32 x i8>
  ret <32 x i8> %4
}
