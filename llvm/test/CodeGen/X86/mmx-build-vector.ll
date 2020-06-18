; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown   -mattr=+mmx          | FileCheck %s --check-prefixes=X86,X86-MMX
; RUN: llc < %s -mtriple=i686-unknown-unknown   -mattr=+mmx,+sse2    | FileCheck %s --check-prefixes=X86,X86-SSE,X86-SSE2
; RUN: llc < %s -mtriple=i686-unknown-unknown   -mattr=+mmx,+ssse3   | FileCheck %s --check-prefixes=X86,X86-SSE,X86-SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+mmx,+sse2    | FileCheck %s --check-prefixes=X64,X64-SSE,X64-SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+mmx,+ssse3   | FileCheck %s --check-prefixes=X64,X64-SSE,X64-SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+mmx,+avx     | FileCheck %s --check-prefixes=X64,X64-AVX,X64-AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+mmx,+avx2    | FileCheck %s --check-prefixes=X64,X64-AVX,X64-AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+mmx,+avx512f | FileCheck %s --check-prefixes=X64,X64-AVX,X64-AVX512

declare x86_mmx @llvm.x86.mmx.padd.d(x86_mmx, x86_mmx)

;
; v2i32
;

define void @build_v2i32_01(x86_mmx *%p0, i32 %a0, i32 %a1) nounwind {
; X86-LABEL: build_v2i32_01:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm1
; X86-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X86-NEXT:    paddd %mm1, %mm1
; X86-NEXT:    movq %mm1, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: build_v2i32_01:
; X64:       # %bb.0:
; X64-NEXT:    movd %edx, %mm0
; X64-NEXT:    movd %esi, %mm1
; X64-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X64-NEXT:    paddd %mm1, %mm1
; X64-NEXT:    movq %mm1, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <2 x i32> undef, i32 %a0, i32 0
  %2 = insertelement <2 x i32>    %1, i32 %a1, i32 1
  %3 = bitcast <2 x i32> %2 to x86_mmx
  %4 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %3, x86_mmx %3)
  store x86_mmx %4, x86_mmx *%p0
  ret void
}

define void @build_v2i32_0z(x86_mmx *%p0, i32 %a0, i32 %a1) nounwind {
; X86-LABEL: build_v2i32_0z:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    paddd %mm0, %mm0
; X86-NEXT:    movq %mm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: build_v2i32_0z:
; X64:       # %bb.0:
; X64-NEXT:    movd %esi, %mm0
; X64-NEXT:    paddd %mm0, %mm0
; X64-NEXT:    movq %mm0, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <2 x i32> undef, i32 %a0, i32 0
  %2 = insertelement <2 x i32>    %1, i32   0, i32 1
  %3 = bitcast <2 x i32> %2 to x86_mmx
  %4 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %3, x86_mmx %3)
  store x86_mmx %4, x86_mmx *%p0
  ret void
}

define void @build_v2i32_u1(x86_mmx *%p0, i32 %a0, i32 %a1) nounwind {
; X86-MMX-LABEL: build_v2i32_u1:
; X86-MMX:       # %bb.0:
; X86-MMX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-MMX-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-MMX-NEXT:    punpckldq %mm0, %mm0 # mm0 = mm0[0,0]
; X86-MMX-NEXT:    paddd %mm0, %mm0
; X86-MMX-NEXT:    movq %mm0, (%eax)
; X86-MMX-NEXT:    retl
;
; X86-SSE-LABEL: build_v2i32_u1:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-SSE-NEXT:    pshufw $68, %mm0, %mm0 # mm0 = mm0[0,1,0,1]
; X86-SSE-NEXT:    paddd %mm0, %mm0
; X86-SSE-NEXT:    movq %mm0, (%eax)
; X86-SSE-NEXT:    retl
;
; X64-LABEL: build_v2i32_u1:
; X64:       # %bb.0:
; X64-NEXT:    movd %edx, %mm0
; X64-NEXT:    pshufw $68, %mm0, %mm0 # mm0 = mm0[0,1,0,1]
; X64-NEXT:    paddd %mm0, %mm0
; X64-NEXT:    movq %mm0, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <2 x i32> undef, i32 undef, i32 0
  %2 = insertelement <2 x i32>    %1, i32   %a1, i32 1
  %3 = bitcast <2 x i32> %2 to x86_mmx
  %4 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %3, x86_mmx %3)
  store x86_mmx %4, x86_mmx *%p0
  ret void
}

define void @build_v2i32_z1(x86_mmx *%p0, i32 %a0, i32 %a1) nounwind {
; X86-LABEL: build_v2i32_z1:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    pxor %mm1, %mm1
; X86-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X86-NEXT:    paddd %mm1, %mm1
; X86-NEXT:    movq %mm1, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: build_v2i32_z1:
; X64:       # %bb.0:
; X64-NEXT:    movd %edx, %mm0
; X64-NEXT:    pxor %mm1, %mm1
; X64-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X64-NEXT:    paddd %mm1, %mm1
; X64-NEXT:    movq %mm1, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <2 x i32> undef, i32   0, i32 0
  %2 = insertelement <2 x i32>    %1, i32 %a1, i32 1
  %3 = bitcast <2 x i32> %2 to x86_mmx
  %4 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %3, x86_mmx %3)
  store x86_mmx %4, x86_mmx *%p0
  ret void
}

define void @build_v2i32_00(x86_mmx *%p0, i32 %a0, i32 %a1) nounwind {
; X86-MMX-LABEL: build_v2i32_00:
; X86-MMX:       # %bb.0:
; X86-MMX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-MMX-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-MMX-NEXT:    punpckldq %mm0, %mm0 # mm0 = mm0[0,0]
; X86-MMX-NEXT:    paddd %mm0, %mm0
; X86-MMX-NEXT:    movq %mm0, (%eax)
; X86-MMX-NEXT:    retl
;
; X86-SSE-LABEL: build_v2i32_00:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-SSE-NEXT:    pshufw $68, %mm0, %mm0 # mm0 = mm0[0,1,0,1]
; X86-SSE-NEXT:    paddd %mm0, %mm0
; X86-SSE-NEXT:    movq %mm0, (%eax)
; X86-SSE-NEXT:    retl
;
; X64-LABEL: build_v2i32_00:
; X64:       # %bb.0:
; X64-NEXT:    movd %esi, %mm0
; X64-NEXT:    pshufw $68, %mm0, %mm0 # mm0 = mm0[0,1,0,1]
; X64-NEXT:    paddd %mm0, %mm0
; X64-NEXT:    movq %mm0, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <2 x i32> undef, i32 %a0, i32 0
  %2 = insertelement <2 x i32>    %1, i32 %a0, i32 1
  %3 = bitcast <2 x i32> %2 to x86_mmx
  %4 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %3, x86_mmx %3)
  store x86_mmx %4, x86_mmx *%p0
  ret void
}

;
; v4i16
;

define void @build_v4i16_0123(x86_mmx *%p0, i16 %a0, i16 %a1, i16 %a2, i16 %a3) nounwind {
; X86-LABEL: build_v4i16_0123:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm1
; X86-NEXT:    punpcklwd %mm0, %mm1 # mm1 = mm1[0],mm0[0],mm1[1],mm0[1]
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm2
; X86-NEXT:    punpcklwd %mm0, %mm2 # mm2 = mm2[0],mm0[0],mm2[1],mm0[1]
; X86-NEXT:    punpckldq %mm1, %mm2 # mm2 = mm2[0],mm1[0]
; X86-NEXT:    paddd %mm2, %mm2
; X86-NEXT:    movq %mm2, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: build_v4i16_0123:
; X64:       # %bb.0:
; X64-NEXT:    movd %r8d, %mm0
; X64-NEXT:    movd %ecx, %mm1
; X64-NEXT:    punpcklwd %mm0, %mm1 # mm1 = mm1[0],mm0[0],mm1[1],mm0[1]
; X64-NEXT:    movd %edx, %mm0
; X64-NEXT:    movd %esi, %mm2
; X64-NEXT:    punpcklwd %mm0, %mm2 # mm2 = mm2[0],mm0[0],mm2[1],mm0[1]
; X64-NEXT:    punpckldq %mm1, %mm2 # mm2 = mm2[0],mm1[0]
; X64-NEXT:    paddd %mm2, %mm2
; X64-NEXT:    movq %mm2, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <4 x i16> undef, i16 %a0, i32 0
  %2 = insertelement <4 x i16>    %1, i16 %a1, i32 1
  %3 = insertelement <4 x i16>    %2, i16 %a2, i32 2
  %4 = insertelement <4 x i16>    %3, i16 %a3, i32 3
  %5 = bitcast <4 x i16> %4 to x86_mmx
  %6 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %5, x86_mmx %5)
  store x86_mmx %6, x86_mmx *%p0
  ret void
}

define void @build_v4i16_01zz(x86_mmx *%p0, i16 %a0, i16 %a1, i16 %a2, i16 %a3) nounwind {
; X86-LABEL: build_v4i16_01zz:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm1
; X86-NEXT:    punpcklwd %mm0, %mm1 # mm1 = mm1[0],mm0[0],mm1[1],mm0[1]
; X86-NEXT:    pxor %mm0, %mm0
; X86-NEXT:    punpcklwd %mm0, %mm0 # mm0 = mm0[0,0,1,1]
; X86-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X86-NEXT:    paddd %mm1, %mm1
; X86-NEXT:    movq %mm1, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: build_v4i16_01zz:
; X64:       # %bb.0:
; X64-NEXT:    movd %edx, %mm0
; X64-NEXT:    movd %esi, %mm1
; X64-NEXT:    punpcklwd %mm0, %mm1 # mm1 = mm1[0],mm0[0],mm1[1],mm0[1]
; X64-NEXT:    pxor %mm0, %mm0
; X64-NEXT:    punpcklwd %mm0, %mm0 # mm0 = mm0[0,0,1,1]
; X64-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X64-NEXT:    paddd %mm1, %mm1
; X64-NEXT:    movq %mm1, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <4 x i16> undef, i16 %a0, i32 0
  %2 = insertelement <4 x i16>    %1, i16 %a1, i32 1
  %3 = insertelement <4 x i16>    %2, i16   0, i32 2
  %4 = insertelement <4 x i16>    %3, i16   0, i32 3
  %5 = bitcast <4 x i16> %4 to x86_mmx
  %6 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %5, x86_mmx %5)
  store x86_mmx %6, x86_mmx *%p0
  ret void
}

define void @build_v4i16_0uuz(x86_mmx *%p0, i16 %a0, i16 %a1, i16 %a2, i16 %a3) nounwind {
; X86-LABEL: build_v4i16_0uuz:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    paddd %mm0, %mm0
; X86-NEXT:    movq %mm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: build_v4i16_0uuz:
; X64:       # %bb.0:
; X64-NEXT:    movd %esi, %mm0
; X64-NEXT:    paddd %mm0, %mm0
; X64-NEXT:    movq %mm0, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <4 x i16> undef, i16   %a0, i32 0
  %2 = insertelement <4 x i16>    %1, i16 undef, i32 1
  %3 = insertelement <4 x i16>    %2, i16 undef, i32 2
  %4 = insertelement <4 x i16>    %3, i16     0, i32 3
  %5 = bitcast <4 x i16> %4 to x86_mmx
  %6 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %5, x86_mmx %5)
  store x86_mmx %6, x86_mmx *%p0
  ret void
}

define void @build_v4i16_0zuz(x86_mmx *%p0, i16 %a0, i16 %a1, i16 %a2, i16 %a3) nounwind {
; X86-LABEL: build_v4i16_0zuz:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd %eax, %mm0
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    paddd %mm0, %mm0
; X86-NEXT:    movq %mm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: build_v4i16_0zuz:
; X64:       # %bb.0:
; X64-NEXT:    movzwl %si, %eax
; X64-NEXT:    movd %eax, %mm0
; X64-NEXT:    paddd %mm0, %mm0
; X64-NEXT:    movq %mm0, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <4 x i16> undef, i16   %a0, i32 0
  %2 = insertelement <4 x i16>    %1, i16     0, i32 1
  %3 = insertelement <4 x i16>    %2, i16 undef, i32 2
  %4 = insertelement <4 x i16>    %3, i16     0, i32 3
  %5 = bitcast <4 x i16> %4 to x86_mmx
  %6 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %5, x86_mmx %5)
  store x86_mmx %6, x86_mmx *%p0
  ret void
}

define void @build_v4i16_012u(x86_mmx *%p0, i16 %a0, i16 %a1, i16 %a2, i16 %a3) nounwind {
; X86-LABEL: build_v4i16_012u:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    punpcklwd %mm0, %mm0 # mm0 = mm0[0,0,1,1]
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm1
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm2
; X86-NEXT:    punpcklwd %mm1, %mm2 # mm2 = mm2[0],mm1[0],mm2[1],mm1[1]
; X86-NEXT:    punpckldq %mm0, %mm2 # mm2 = mm2[0],mm0[0]
; X86-NEXT:    paddd %mm2, %mm2
; X86-NEXT:    movq %mm2, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: build_v4i16_012u:
; X64:       # %bb.0:
; X64-NEXT:    movd %ecx, %mm0
; X64-NEXT:    punpcklwd %mm0, %mm0 # mm0 = mm0[0,0,1,1]
; X64-NEXT:    movd %edx, %mm1
; X64-NEXT:    movd %esi, %mm2
; X64-NEXT:    punpcklwd %mm1, %mm2 # mm2 = mm2[0],mm1[0],mm2[1],mm1[1]
; X64-NEXT:    punpckldq %mm0, %mm2 # mm2 = mm2[0],mm0[0]
; X64-NEXT:    paddd %mm2, %mm2
; X64-NEXT:    movq %mm2, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <4 x i16> undef, i16   %a0, i32 0
  %2 = insertelement <4 x i16>    %1, i16   %a1, i32 1
  %3 = insertelement <4 x i16>    %2, i16   %a2, i32 2
  %4 = insertelement <4 x i16>    %3, i16 undef, i32 3
  %5 = bitcast <4 x i16> %4 to x86_mmx
  %6 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %5, x86_mmx %5)
  store x86_mmx %6, x86_mmx *%p0
  ret void
}

define void @build_v4i16_0u00(x86_mmx *%p0, i16 %a0, i16 %a1, i16 %a2, i16 %a3) nounwind {
; X86-MMX-LABEL: build_v4i16_0u00:
; X86-MMX:       # %bb.0:
; X86-MMX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-MMX-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-MMX-NEXT:    punpcklwd %mm0, %mm0 # mm0 = mm0[0,0,1,1]
; X86-MMX-NEXT:    punpckldq %mm0, %mm0 # mm0 = mm0[0,0]
; X86-MMX-NEXT:    paddd %mm0, %mm0
; X86-MMX-NEXT:    movq %mm0, (%eax)
; X86-MMX-NEXT:    retl
;
; X86-SSE-LABEL: build_v4i16_0u00:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-SSE-NEXT:    pshufw $0, %mm0, %mm0 # mm0 = mm0[0,0,0,0]
; X86-SSE-NEXT:    paddd %mm0, %mm0
; X86-SSE-NEXT:    movq %mm0, (%eax)
; X86-SSE-NEXT:    retl
;
; X64-LABEL: build_v4i16_0u00:
; X64:       # %bb.0:
; X64-NEXT:    movd %esi, %mm0
; X64-NEXT:    pshufw $0, %mm0, %mm0 # mm0 = mm0[0,0,0,0]
; X64-NEXT:    paddd %mm0, %mm0
; X64-NEXT:    movq %mm0, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <4 x i16> undef, i16   %a0, i32 0
  %2 = insertelement <4 x i16>    %1, i16 undef, i32 1
  %3 = insertelement <4 x i16>    %2, i16   %a0, i32 2
  %4 = insertelement <4 x i16>    %3, i16   %a0, i32 3
  %5 = bitcast <4 x i16> %4 to x86_mmx
  %6 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %5, x86_mmx %5)
  store x86_mmx %6, x86_mmx *%p0
  ret void
}

;
; v8i8
;

define void @build_v8i8_01234567(x86_mmx *%p0, i8 %a0, i8 %a1, i8 %a2, i8 %a3, i8 %a4, i8 %a5, i8 %a6, i8 %a7) nounwind {
; X86-LABEL: build_v8i8_01234567:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm1
; X86-NEXT:    punpcklbw %mm0, %mm1 # mm1 = mm1[0],mm0[0],mm1[1],mm0[1],mm1[2],mm0[2],mm1[3],mm0[3]
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm2
; X86-NEXT:    punpcklbw %mm0, %mm2 # mm2 = mm2[0],mm0[0],mm2[1],mm0[1],mm2[2],mm0[2],mm2[3],mm0[3]
; X86-NEXT:    punpcklwd %mm1, %mm2 # mm2 = mm2[0],mm1[0],mm2[1],mm1[1]
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm1
; X86-NEXT:    punpcklbw %mm0, %mm1 # mm1 = mm1[0],mm0[0],mm1[1],mm0[1],mm1[2],mm0[2],mm1[3],mm0[3]
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm3
; X86-NEXT:    punpcklbw %mm0, %mm3 # mm3 = mm3[0],mm0[0],mm3[1],mm0[1],mm3[2],mm0[2],mm3[3],mm0[3]
; X86-NEXT:    punpcklwd %mm1, %mm3 # mm3 = mm3[0],mm1[0],mm3[1],mm1[1]
; X86-NEXT:    punpckldq %mm2, %mm3 # mm3 = mm3[0],mm2[0]
; X86-NEXT:    paddd %mm3, %mm3
; X86-NEXT:    movq %mm3, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: build_v8i8_01234567:
; X64:       # %bb.0:
; X64-NEXT:    movd {{[0-9]+}}(%rsp), %mm0
; X64-NEXT:    movd {{[0-9]+}}(%rsp), %mm1
; X64-NEXT:    punpcklbw %mm0, %mm1 # mm1 = mm1[0],mm0[0],mm1[1],mm0[1],mm1[2],mm0[2],mm1[3],mm0[3]
; X64-NEXT:    movd %r9d, %mm0
; X64-NEXT:    movd {{[0-9]+}}(%rsp), %mm2
; X64-NEXT:    punpcklbw %mm2, %mm0 # mm0 = mm0[0],mm2[0],mm0[1],mm2[1],mm0[2],mm2[2],mm0[3],mm2[3]
; X64-NEXT:    punpcklwd %mm1, %mm0 # mm0 = mm0[0],mm1[0],mm0[1],mm1[1]
; X64-NEXT:    movd %r8d, %mm1
; X64-NEXT:    movd %ecx, %mm2
; X64-NEXT:    punpcklbw %mm1, %mm2 # mm2 = mm2[0],mm1[0],mm2[1],mm1[1],mm2[2],mm1[2],mm2[3],mm1[3]
; X64-NEXT:    movd %edx, %mm1
; X64-NEXT:    movd %esi, %mm3
; X64-NEXT:    punpcklbw %mm1, %mm3 # mm3 = mm3[0],mm1[0],mm3[1],mm1[1],mm3[2],mm1[2],mm3[3],mm1[3]
; X64-NEXT:    punpcklwd %mm2, %mm3 # mm3 = mm3[0],mm2[0],mm3[1],mm2[1]
; X64-NEXT:    punpckldq %mm0, %mm3 # mm3 = mm3[0],mm0[0]
; X64-NEXT:    paddd %mm3, %mm3
; X64-NEXT:    movq %mm3, (%rdi)
; X64-NEXT:    retq
  %1  = insertelement <8 x i8> undef, i8 %a0, i32 0
  %2  = insertelement <8 x i8>    %1, i8 %a1, i32 1
  %3  = insertelement <8 x i8>    %2, i8 %a2, i32 2
  %4  = insertelement <8 x i8>    %3, i8 %a3, i32 3
  %5  = insertelement <8 x i8>    %4, i8 %a4, i32 4
  %6  = insertelement <8 x i8>    %5, i8 %a5, i32 5
  %7  = insertelement <8 x i8>    %6, i8 %a6, i32 6
  %8  = insertelement <8 x i8>    %7, i8 %a7, i32 7
  %9  = bitcast <8 x i8> %8 to x86_mmx
  %10 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %9, x86_mmx %9)
  store x86_mmx %10, x86_mmx *%p0
  ret void
}

define void @build_v8i8_0u2345z7(x86_mmx *%p0, i8 %a0, i8 %a1, i8 %a2, i8 %a3, i8 %a4, i8 %a5, i8 %a6, i8 %a7) nounwind {
; X86-LABEL: build_v8i8_0u2345z7:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    pxor %mm1, %mm1
; X86-NEXT:    punpcklbw %mm0, %mm1 # mm1 = mm1[0],mm0[0],mm1[1],mm0[1],mm1[2],mm0[2],mm1[3],mm0[3]
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm2
; X86-NEXT:    punpcklbw %mm0, %mm2 # mm2 = mm2[0],mm0[0],mm2[1],mm0[1],mm2[2],mm0[2],mm2[3],mm0[3]
; X86-NEXT:    punpcklwd %mm1, %mm2 # mm2 = mm2[0],mm1[0],mm2[1],mm1[1]
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm1
; X86-NEXT:    punpcklbw %mm0, %mm1 # mm1 = mm1[0],mm0[0],mm1[1],mm0[1],mm1[2],mm0[2],mm1[3],mm0[3]
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    punpcklbw %mm0, %mm0 # mm0 = mm0[0,0,1,1,2,2,3,3]
; X86-NEXT:    punpcklwd %mm1, %mm0 # mm0 = mm0[0],mm1[0],mm0[1],mm1[1]
; X86-NEXT:    punpckldq %mm2, %mm0 # mm0 = mm0[0],mm2[0]
; X86-NEXT:    paddd %mm0, %mm0
; X86-NEXT:    movq %mm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: build_v8i8_0u2345z7:
; X64:       # %bb.0:
; X64-NEXT:    movd {{[0-9]+}}(%rsp), %mm0
; X64-NEXT:    pxor %mm1, %mm1
; X64-NEXT:    punpcklbw %mm0, %mm1 # mm1 = mm1[0],mm0[0],mm1[1],mm0[1],mm1[2],mm0[2],mm1[3],mm0[3]
; X64-NEXT:    movd %r9d, %mm0
; X64-NEXT:    movd {{[0-9]+}}(%rsp), %mm2
; X64-NEXT:    punpcklbw %mm2, %mm0 # mm0 = mm0[0],mm2[0],mm0[1],mm2[1],mm0[2],mm2[2],mm0[3],mm2[3]
; X64-NEXT:    punpcklwd %mm1, %mm0 # mm0 = mm0[0],mm1[0],mm0[1],mm1[1]
; X64-NEXT:    movd %r8d, %mm1
; X64-NEXT:    movd %ecx, %mm2
; X64-NEXT:    punpcklbw %mm1, %mm2 # mm2 = mm2[0],mm1[0],mm2[1],mm1[1],mm2[2],mm1[2],mm2[3],mm1[3]
; X64-NEXT:    movd %esi, %mm1
; X64-NEXT:    punpcklbw %mm1, %mm1 # mm1 = mm1[0,0,1,1,2,2,3,3]
; X64-NEXT:    punpcklwd %mm2, %mm1 # mm1 = mm1[0],mm2[0],mm1[1],mm2[1]
; X64-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X64-NEXT:    paddd %mm1, %mm1
; X64-NEXT:    movq %mm1, (%rdi)
; X64-NEXT:    retq
  %1  = insertelement <8 x i8> undef, i8   %a0, i32 0
  %2  = insertelement <8 x i8>    %1, i8 undef, i32 1
  %3  = insertelement <8 x i8>    %2, i8   %a2, i32 2
  %4  = insertelement <8 x i8>    %3, i8   %a3, i32 3
  %5  = insertelement <8 x i8>    %4, i8   %a4, i32 4
  %6  = insertelement <8 x i8>    %5, i8   %a5, i32 5
  %7  = insertelement <8 x i8>    %6, i8    0,  i32 6
  %8  = insertelement <8 x i8>    %7, i8   %a7, i32 7
  %9  = bitcast <8 x i8> %8 to x86_mmx
  %10 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %9, x86_mmx %9)
  store x86_mmx %10, x86_mmx *%p0
  ret void
}

define void @build_v8i8_0123zzzu(x86_mmx *%p0, i8 %a0, i8 %a1, i8 %a2, i8 %a3, i8 %a4, i8 %a5, i8 %a6, i8 %a7) nounwind {
; X86-LABEL: build_v8i8_0123zzzu:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm1
; X86-NEXT:    punpcklbw %mm0, %mm1 # mm1 = mm1[0],mm0[0],mm1[1],mm0[1],mm1[2],mm0[2],mm1[3],mm0[3]
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm2
; X86-NEXT:    punpcklbw %mm0, %mm2 # mm2 = mm2[0],mm0[0],mm2[1],mm0[1],mm2[2],mm0[2],mm2[3],mm0[3]
; X86-NEXT:    punpcklwd %mm1, %mm2 # mm2 = mm2[0],mm1[0],mm2[1],mm1[1]
; X86-NEXT:    pxor %mm0, %mm0
; X86-NEXT:    pxor %mm1, %mm1
; X86-NEXT:    punpcklbw %mm1, %mm1 # mm1 = mm1[0,0,1,1,2,2,3,3]
; X86-NEXT:    punpcklbw %mm0, %mm0 # mm0 = mm0[0,0,1,1,2,2,3,3]
; X86-NEXT:    punpcklwd %mm1, %mm0 # mm0 = mm0[0],mm1[0],mm0[1],mm1[1]
; X86-NEXT:    punpckldq %mm0, %mm2 # mm2 = mm2[0],mm0[0]
; X86-NEXT:    paddd %mm2, %mm2
; X86-NEXT:    movq %mm2, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: build_v8i8_0123zzzu:
; X64:       # %bb.0:
; X64-NEXT:    movd %r8d, %mm0
; X64-NEXT:    movd %ecx, %mm1
; X64-NEXT:    punpcklbw %mm0, %mm1 # mm1 = mm1[0],mm0[0],mm1[1],mm0[1],mm1[2],mm0[2],mm1[3],mm0[3]
; X64-NEXT:    movd %edx, %mm0
; X64-NEXT:    movd %esi, %mm2
; X64-NEXT:    punpcklbw %mm0, %mm2 # mm2 = mm2[0],mm0[0],mm2[1],mm0[1],mm2[2],mm0[2],mm2[3],mm0[3]
; X64-NEXT:    punpcklwd %mm1, %mm2 # mm2 = mm2[0],mm1[0],mm2[1],mm1[1]
; X64-NEXT:    pxor %mm0, %mm0
; X64-NEXT:    pxor %mm1, %mm1
; X64-NEXT:    punpcklbw %mm1, %mm1 # mm1 = mm1[0,0,1,1,2,2,3,3]
; X64-NEXT:    punpcklbw %mm0, %mm0 # mm0 = mm0[0,0,1,1,2,2,3,3]
; X64-NEXT:    punpcklwd %mm1, %mm0 # mm0 = mm0[0],mm1[0],mm0[1],mm1[1]
; X64-NEXT:    punpckldq %mm0, %mm2 # mm2 = mm2[0],mm0[0]
; X64-NEXT:    paddd %mm2, %mm2
; X64-NEXT:    movq %mm2, (%rdi)
; X64-NEXT:    retq
  %1  = insertelement <8 x i8> undef, i8   %a0, i32 0
  %2  = insertelement <8 x i8>    %1, i8   %a1, i32 1
  %3  = insertelement <8 x i8>    %2, i8   %a2, i32 2
  %4  = insertelement <8 x i8>    %3, i8   %a3, i32 3
  %5  = insertelement <8 x i8>    %4, i8     0, i32 4
  %6  = insertelement <8 x i8>    %5, i8     0, i32 5
  %7  = insertelement <8 x i8>    %6, i8     0, i32 6
  %8  = insertelement <8 x i8>    %7, i8 undef, i32 7
  %9  = bitcast <8 x i8> %8 to x86_mmx
  %10 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %9, x86_mmx %9)
  store x86_mmx %10, x86_mmx *%p0
  ret void
}

define void @build_v8i8_0uuuuzzz(x86_mmx *%p0, i8 %a0, i8 %a1, i8 %a2, i8 %a3, i8 %a4, i8 %a5, i8 %a6, i8 %a7) nounwind {
; X86-LABEL: build_v8i8_0uuuuzzz:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-NEXT:    paddd %mm0, %mm0
; X86-NEXT:    movq %mm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: build_v8i8_0uuuuzzz:
; X64:       # %bb.0:
; X64-NEXT:    movd %esi, %mm0
; X64-NEXT:    paddd %mm0, %mm0
; X64-NEXT:    movq %mm0, (%rdi)
; X64-NEXT:    retq
  %1  = insertelement <8 x i8> undef, i8   %a0, i32 0
  %2  = insertelement <8 x i8>    %1, i8 undef, i32 1
  %3  = insertelement <8 x i8>    %2, i8 undef, i32 2
  %4  = insertelement <8 x i8>    %3, i8 undef, i32 3
  %5  = insertelement <8 x i8>    %4, i8 undef, i32 4
  %6  = insertelement <8 x i8>    %5, i8     0, i32 5
  %7  = insertelement <8 x i8>    %6, i8     0, i32 6
  %8  = insertelement <8 x i8>    %7, i8     0, i32 7
  %9  = bitcast <8 x i8> %8 to x86_mmx
  %10 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %9, x86_mmx %9)
  store x86_mmx %10, x86_mmx *%p0
  ret void
}

define void @build_v8i8_0zzzzzzu(x86_mmx *%p0, i8 %a0, i8 %a1, i8 %a2, i8 %a3, i8 %a4, i8 %a5, i8 %a6, i8 %a7) nounwind {
; X86-LABEL: build_v8i8_0zzzzzzu:
; X86:       # %bb.0:
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movd %eax, %mm0
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    paddd %mm0, %mm0
; X86-NEXT:    movq %mm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: build_v8i8_0zzzzzzu:
; X64:       # %bb.0:
; X64-NEXT:    movzbl %sil, %eax
; X64-NEXT:    movd %eax, %mm0
; X64-NEXT:    paddd %mm0, %mm0
; X64-NEXT:    movq %mm0, (%rdi)
; X64-NEXT:    retq
  %1  = insertelement <8 x i8> undef, i8   %a0, i32 0
  %2  = insertelement <8 x i8>    %1, i8     0, i32 1
  %3  = insertelement <8 x i8>    %2, i8     0, i32 2
  %4  = insertelement <8 x i8>    %3, i8     0, i32 3
  %5  = insertelement <8 x i8>    %4, i8     0, i32 4
  %6  = insertelement <8 x i8>    %5, i8     0, i32 5
  %7  = insertelement <8 x i8>    %6, i8     0, i32 6
  %8  = insertelement <8 x i8>    %7, i8 undef, i32 7
  %9  = bitcast <8 x i8> %8 to x86_mmx
  %10 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %9, x86_mmx %9)
  store x86_mmx %10, x86_mmx *%p0
  ret void
}

define void @build_v8i8_00000000(x86_mmx *%p0, i8 %a0, i8 %a1, i8 %a2, i8 %a3, i8 %a4, i8 %a5, i8 %a6, i8 %a7) nounwind {
; X86-MMX-LABEL: build_v8i8_00000000:
; X86-MMX:       # %bb.0:
; X86-MMX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-MMX-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-MMX-NEXT:    punpcklbw %mm0, %mm0 # mm0 = mm0[0,0,1,1,2,2,3,3]
; X86-MMX-NEXT:    punpcklwd %mm0, %mm0 # mm0 = mm0[0,0,1,1]
; X86-MMX-NEXT:    punpckldq %mm0, %mm0 # mm0 = mm0[0,0]
; X86-MMX-NEXT:    paddd %mm0, %mm0
; X86-MMX-NEXT:    movq %mm0, (%eax)
; X86-MMX-NEXT:    retl
;
; X86-SSE-LABEL: build_v8i8_00000000:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-SSE-NEXT:    punpcklbw %mm0, %mm0 # mm0 = mm0[0,0,1,1,2,2,3,3]
; X86-SSE-NEXT:    pshufw $0, %mm0, %mm0 # mm0 = mm0[0,0,0,0]
; X86-SSE-NEXT:    paddd %mm0, %mm0
; X86-SSE-NEXT:    movq %mm0, (%eax)
; X86-SSE-NEXT:    retl
;
; X64-LABEL: build_v8i8_00000000:
; X64:       # %bb.0:
; X64-NEXT:    movd %esi, %mm0
; X64-NEXT:    punpcklbw %mm0, %mm0 # mm0 = mm0[0,0,1,1,2,2,3,3]
; X64-NEXT:    pshufw $0, %mm0, %mm0 # mm0 = mm0[0,0,0,0]
; X64-NEXT:    paddd %mm0, %mm0
; X64-NEXT:    movq %mm0, (%rdi)
; X64-NEXT:    retq
  %1  = insertelement <8 x i8> undef, i8 %a0, i32 0
  %2  = insertelement <8 x i8>    %1, i8 %a0, i32 1
  %3  = insertelement <8 x i8>    %2, i8 %a0, i32 2
  %4  = insertelement <8 x i8>    %3, i8 %a0, i32 3
  %5  = insertelement <8 x i8>    %4, i8 %a0, i32 4
  %6  = insertelement <8 x i8>    %5, i8 %a0, i32 5
  %7  = insertelement <8 x i8>    %6, i8 %a0, i32 6
  %8  = insertelement <8 x i8>    %7, i8 %a0, i32 7
  %9  = bitcast <8 x i8> %8 to x86_mmx
  %10 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %9, x86_mmx %9)
  store x86_mmx %10, x86_mmx *%p0
  ret void
}

;
; v2f32
;

define void @build_v2f32_01(x86_mmx *%p0, float %a0, float %a1) nounwind {
; X86-MMX-LABEL: build_v2f32_01:
; X86-MMX:       # %bb.0:
; X86-MMX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-MMX-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-MMX-NEXT:    movd {{[0-9]+}}(%esp), %mm1
; X86-MMX-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X86-MMX-NEXT:    paddd %mm1, %mm1
; X86-MMX-NEXT:    movq %mm1, (%eax)
; X86-MMX-NEXT:    retl
;
; X86-SSE-LABEL: build_v2f32_01:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-SSE-NEXT:    movdq2q %xmm0, %mm0
; X86-SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-SSE-NEXT:    movdq2q %xmm0, %mm1
; X86-SSE-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X86-SSE-NEXT:    paddd %mm1, %mm1
; X86-SSE-NEXT:    movq %mm1, (%eax)
; X86-SSE-NEXT:    retl
;
; X64-LABEL: build_v2f32_01:
; X64:       # %bb.0:
; X64-NEXT:    movdq2q %xmm1, %mm0
; X64-NEXT:    movdq2q %xmm0, %mm1
; X64-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X64-NEXT:    paddd %mm1, %mm1
; X64-NEXT:    movq %mm1, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <2 x float> undef, float %a0, i32 0
  %2 = insertelement <2 x float>    %1, float %a1, i32 1
  %3 = bitcast <2 x float> %2 to x86_mmx
  %4 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %3, x86_mmx %3)
  store x86_mmx %4, x86_mmx *%p0
  ret void
}

define void @build_v2f32_0z(x86_mmx *%p0, float %a0, float %a1) nounwind {
; X86-MMX-LABEL: build_v2f32_0z:
; X86-MMX:       # %bb.0:
; X86-MMX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-MMX-NEXT:    pxor %mm0, %mm0
; X86-MMX-NEXT:    movd {{[0-9]+}}(%esp), %mm1
; X86-MMX-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X86-MMX-NEXT:    paddd %mm1, %mm1
; X86-MMX-NEXT:    movq %mm1, (%eax)
; X86-MMX-NEXT:    retl
;
; X86-SSE-LABEL: build_v2f32_0z:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-SSE-NEXT:    movdq2q %xmm0, %mm0
; X86-SSE-NEXT:    pxor %mm1, %mm1
; X86-SSE-NEXT:    punpckldq %mm1, %mm0 # mm0 = mm0[0],mm1[0]
; X86-SSE-NEXT:    paddd %mm0, %mm0
; X86-SSE-NEXT:    movq %mm0, (%eax)
; X86-SSE-NEXT:    retl
;
; X64-LABEL: build_v2f32_0z:
; X64:       # %bb.0:
; X64-NEXT:    movdq2q %xmm0, %mm0
; X64-NEXT:    pxor %mm1, %mm1
; X64-NEXT:    punpckldq %mm1, %mm0 # mm0 = mm0[0],mm1[0]
; X64-NEXT:    paddd %mm0, %mm0
; X64-NEXT:    movq %mm0, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <2 x float> undef, float %a0, i32 0
  %2 = insertelement <2 x float>    %1, float 0.0, i32 1
  %3 = bitcast <2 x float> %2 to x86_mmx
  %4 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %3, x86_mmx %3)
  store x86_mmx %4, x86_mmx *%p0
  ret void
}

define void @build_v2f32_u1(x86_mmx *%p0, float %a0, float %a1) nounwind {
; X86-MMX-LABEL: build_v2f32_u1:
; X86-MMX:       # %bb.0:
; X86-MMX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-MMX-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-MMX-NEXT:    punpckldq %mm0, %mm0 # mm0 = mm0[0,0]
; X86-MMX-NEXT:    paddd %mm0, %mm0
; X86-MMX-NEXT:    movq %mm0, (%eax)
; X86-MMX-NEXT:    retl
;
; X86-SSE-LABEL: build_v2f32_u1:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-SSE-NEXT:    movdq2q %xmm0, %mm0
; X86-SSE-NEXT:    pshufw $68, %mm0, %mm0 # mm0 = mm0[0,1,0,1]
; X86-SSE-NEXT:    paddd %mm0, %mm0
; X86-SSE-NEXT:    movq %mm0, (%eax)
; X86-SSE-NEXT:    retl
;
; X64-LABEL: build_v2f32_u1:
; X64:       # %bb.0:
; X64-NEXT:    movdq2q %xmm1, %mm0
; X64-NEXT:    pshufw $68, %mm0, %mm0 # mm0 = mm0[0,1,0,1]
; X64-NEXT:    paddd %mm0, %mm0
; X64-NEXT:    movq %mm0, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <2 x float> undef, float undef, i32 0
  %2 = insertelement <2 x float>    %1, float   %a1, i32 1
  %3 = bitcast <2 x float> %2 to x86_mmx
  %4 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %3, x86_mmx %3)
  store x86_mmx %4, x86_mmx *%p0
  ret void
}

define void @build_v2f32_z1(x86_mmx *%p0, float %a0, float %a1) nounwind {
; X86-MMX-LABEL: build_v2f32_z1:
; X86-MMX:       # %bb.0:
; X86-MMX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-MMX-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-MMX-NEXT:    pxor %mm1, %mm1
; X86-MMX-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X86-MMX-NEXT:    paddd %mm1, %mm1
; X86-MMX-NEXT:    movq %mm1, (%eax)
; X86-MMX-NEXT:    retl
;
; X86-SSE-LABEL: build_v2f32_z1:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-SSE-NEXT:    movdq2q %xmm0, %mm0
; X86-SSE-NEXT:    pxor %mm1, %mm1
; X86-SSE-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X86-SSE-NEXT:    paddd %mm1, %mm1
; X86-SSE-NEXT:    movq %mm1, (%eax)
; X86-SSE-NEXT:    retl
;
; X64-LABEL: build_v2f32_z1:
; X64:       # %bb.0:
; X64-NEXT:    movdq2q %xmm1, %mm0
; X64-NEXT:    pxor %mm1, %mm1
; X64-NEXT:    punpckldq %mm0, %mm1 # mm1 = mm1[0],mm0[0]
; X64-NEXT:    paddd %mm1, %mm1
; X64-NEXT:    movq %mm1, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <2 x float> undef, float 0.0, i32 0
  %2 = insertelement <2 x float>    %1, float %a1, i32 1
  %3 = bitcast <2 x float> %2 to x86_mmx
  %4 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %3, x86_mmx %3)
  store x86_mmx %4, x86_mmx *%p0
  ret void
}

define void @build_v2f32_00(x86_mmx *%p0, float %a0, float %a1) nounwind {
; X86-MMX-LABEL: build_v2f32_00:
; X86-MMX:       # %bb.0:
; X86-MMX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-MMX-NEXT:    movd {{[0-9]+}}(%esp), %mm0
; X86-MMX-NEXT:    punpckldq %mm0, %mm0 # mm0 = mm0[0,0]
; X86-MMX-NEXT:    paddd %mm0, %mm0
; X86-MMX-NEXT:    movq %mm0, (%eax)
; X86-MMX-NEXT:    retl
;
; X86-SSE-LABEL: build_v2f32_00:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-SSE-NEXT:    movdq2q %xmm0, %mm0
; X86-SSE-NEXT:    pshufw $68, %mm0, %mm0 # mm0 = mm0[0,1,0,1]
; X86-SSE-NEXT:    paddd %mm0, %mm0
; X86-SSE-NEXT:    movq %mm0, (%eax)
; X86-SSE-NEXT:    retl
;
; X64-LABEL: build_v2f32_00:
; X64:       # %bb.0:
; X64-NEXT:    movdq2q %xmm0, %mm0
; X64-NEXT:    pshufw $68, %mm0, %mm0 # mm0 = mm0[0,1,0,1]
; X64-NEXT:    paddd %mm0, %mm0
; X64-NEXT:    movq %mm0, (%rdi)
; X64-NEXT:    retq
  %1 = insertelement <2 x float> undef, float %a0, i32 0
  %2 = insertelement <2 x float>    %1, float %a0, i32 1
  %3 = bitcast <2 x float> %2 to x86_mmx
  %4 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %3, x86_mmx %3)
  store x86_mmx %4, x86_mmx *%p0
  ret void
}
