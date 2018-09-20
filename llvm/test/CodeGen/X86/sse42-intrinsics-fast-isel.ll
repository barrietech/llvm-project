; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -mtriple=i386-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefixes=CHECK,X86,SSE,X86-SSE
; RUN: llc < %s -fast-isel -mtriple=i386-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=CHECK,X86,AVX,X86-AVX,AVX1,X86-AVX1
; RUN: llc < %s -fast-isel -mtriple=i386-unknown-unknown -mattr=+avx512f,+avx512bw,+avx512dq,+avx512vl | FileCheck %s --check-prefixes=CHECK,X86,AVX,X86-AVX,AVX512,X86-AVX512
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefixes=CHECK,X64,SSE,X64-SSE
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=CHECK,X64,AVX,X64-AVX,AVX1,X64-AVX1
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512bw,+avx512dq,+avx512vl | FileCheck %s --check-prefixes=CHECK,X64,AVX,X64-AVX,AVX512,X64-AVX512

; NOTE: This should use IR equivalent to what is generated by clang/test/CodeGen/sse42-builtins.c

define i32 @test_mm_cmpestra(<2 x i64> %a0, i32 %a1, <2 x i64> %a2, i32 %a3) nounwind {
; X86-SSE-LABEL: test_mm_cmpestra:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    pushl %ebx
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    xorl %ebx, %ebx
; X86-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0
; X86-SSE-NEXT:    seta %bl
; X86-SSE-NEXT:    movl %ebx, %eax
; X86-SSE-NEXT:    popl %ebx
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: test_mm_cmpestra:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    pushl %ebx
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-AVX-NEXT:    xorl %ebx, %ebx
; X86-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0
; X86-AVX-NEXT:    seta %bl
; X86-AVX-NEXT:    movl %ebx, %eax
; X86-AVX-NEXT:    popl %ebx
; X86-AVX-NEXT:    retl
;
; X64-SSE-LABEL: test_mm_cmpestra:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movl %esi, %edx
; X64-SSE-NEXT:    movl %edi, %eax
; X64-SSE-NEXT:    xorl %esi, %esi
; X64-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0
; X64-SSE-NEXT:    seta %sil
; X64-SSE-NEXT:    movl %esi, %eax
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: test_mm_cmpestra:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    movl %esi, %edx
; X64-AVX-NEXT:    movl %edi, %eax
; X64-AVX-NEXT:    xorl %esi, %esi
; X64-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0
; X64-AVX-NEXT:    seta %sil
; X64-AVX-NEXT:    movl %esi, %eax
; X64-AVX-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg2 = bitcast <2 x i64> %a2 to <16 x i8>
  %res = call i32 @llvm.x86.sse42.pcmpestria128(<16 x i8> %arg0, i32 %a1, <16 x i8> %arg2, i32 %a3, i8 7)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpestria128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone

define i32 @test_mm_cmpestrc(<2 x i64> %a0, i32 %a1, <2 x i64> %a2, i32 %a3) nounwind {
; X86-SSE-LABEL: test_mm_cmpestrc:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    pushl %ebx
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    xorl %ebx, %ebx
; X86-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0
; X86-SSE-NEXT:    setb %bl
; X86-SSE-NEXT:    movl %ebx, %eax
; X86-SSE-NEXT:    popl %ebx
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: test_mm_cmpestrc:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    pushl %ebx
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-AVX-NEXT:    xorl %ebx, %ebx
; X86-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0
; X86-AVX-NEXT:    setb %bl
; X86-AVX-NEXT:    movl %ebx, %eax
; X86-AVX-NEXT:    popl %ebx
; X86-AVX-NEXT:    retl
;
; X64-SSE-LABEL: test_mm_cmpestrc:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movl %esi, %edx
; X64-SSE-NEXT:    movl %edi, %eax
; X64-SSE-NEXT:    xorl %esi, %esi
; X64-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0
; X64-SSE-NEXT:    setb %sil
; X64-SSE-NEXT:    movl %esi, %eax
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: test_mm_cmpestrc:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    movl %esi, %edx
; X64-AVX-NEXT:    movl %edi, %eax
; X64-AVX-NEXT:    xorl %esi, %esi
; X64-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0
; X64-AVX-NEXT:    setb %sil
; X64-AVX-NEXT:    movl %esi, %eax
; X64-AVX-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg2 = bitcast <2 x i64> %a2 to <16 x i8>
  %res = call i32 @llvm.x86.sse42.pcmpestric128(<16 x i8> %arg0, i32 %a1, <16 x i8> %arg2, i32 %a3, i8 7)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpestric128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone

define i32 @test_mm_cmpestri(<2 x i64> %a0, i32 %a1, <2 x i64> %a2, i32 %a3) {
; X86-SSE-LABEL: test_mm_cmpestri:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0
; X86-SSE-NEXT:    movl %ecx, %eax
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: test_mm_cmpestri:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0
; X86-AVX-NEXT:    movl %ecx, %eax
; X86-AVX-NEXT:    retl
;
; X64-SSE-LABEL: test_mm_cmpestri:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movl %esi, %edx
; X64-SSE-NEXT:    movl %edi, %eax
; X64-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0
; X64-SSE-NEXT:    movl %ecx, %eax
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: test_mm_cmpestri:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    movl %esi, %edx
; X64-AVX-NEXT:    movl %edi, %eax
; X64-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0
; X64-AVX-NEXT:    movl %ecx, %eax
; X64-AVX-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg2 = bitcast <2 x i64> %a2 to <16 x i8>
  %res = call i32 @llvm.x86.sse42.pcmpestri128(<16 x i8> %arg0, i32 %a1, <16 x i8> %arg2, i32 %a3, i8 7)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpestri128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone

define <2 x i64> @test_mm_cmpestrm(<2 x i64> %a0, i32 %a1, <2 x i64> %a2, i32 %a3) {
; X86-SSE-LABEL: test_mm_cmpestrm:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    pcmpestrm $7, %xmm1, %xmm0
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: test_mm_cmpestrm:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-AVX-NEXT:    vpcmpestrm $7, %xmm1, %xmm0
; X86-AVX-NEXT:    retl
;
; X64-SSE-LABEL: test_mm_cmpestrm:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movl %esi, %edx
; X64-SSE-NEXT:    movl %edi, %eax
; X64-SSE-NEXT:    pcmpestrm $7, %xmm1, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: test_mm_cmpestrm:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    movl %esi, %edx
; X64-AVX-NEXT:    movl %edi, %eax
; X64-AVX-NEXT:    vpcmpestrm $7, %xmm1, %xmm0
; X64-AVX-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg2 = bitcast <2 x i64> %a2 to <16 x i8>
  %res = call <16 x i8> @llvm.x86.sse42.pcmpestrm128(<16 x i8> %arg0, i32 %a1, <16 x i8> %arg2, i32 %a3, i8 7)
  %bc = bitcast <16 x i8> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <16 x i8> @llvm.x86.sse42.pcmpestrm128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone

define i32 @test_mm_cmpestro(<2 x i64> %a0, i32 %a1, <2 x i64> %a2, i32 %a3) nounwind {
; X86-SSE-LABEL: test_mm_cmpestro:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    pushl %ebx
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    xorl %ebx, %ebx
; X86-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0
; X86-SSE-NEXT:    seto %bl
; X86-SSE-NEXT:    movl %ebx, %eax
; X86-SSE-NEXT:    popl %ebx
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: test_mm_cmpestro:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    pushl %ebx
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-AVX-NEXT:    xorl %ebx, %ebx
; X86-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0
; X86-AVX-NEXT:    seto %bl
; X86-AVX-NEXT:    movl %ebx, %eax
; X86-AVX-NEXT:    popl %ebx
; X86-AVX-NEXT:    retl
;
; X64-SSE-LABEL: test_mm_cmpestro:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movl %esi, %edx
; X64-SSE-NEXT:    movl %edi, %eax
; X64-SSE-NEXT:    xorl %esi, %esi
; X64-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0
; X64-SSE-NEXT:    seto %sil
; X64-SSE-NEXT:    movl %esi, %eax
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: test_mm_cmpestro:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    movl %esi, %edx
; X64-AVX-NEXT:    movl %edi, %eax
; X64-AVX-NEXT:    xorl %esi, %esi
; X64-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0
; X64-AVX-NEXT:    seto %sil
; X64-AVX-NEXT:    movl %esi, %eax
; X64-AVX-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg2 = bitcast <2 x i64> %a2 to <16 x i8>
  %res = call i32 @llvm.x86.sse42.pcmpestrio128(<16 x i8> %arg0, i32 %a1, <16 x i8> %arg2, i32 %a3, i8 7)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpestrio128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone

define i32 @test_mm_cmpestrs(<2 x i64> %a0, i32 %a1, <2 x i64> %a2, i32 %a3) nounwind {
; X86-SSE-LABEL: test_mm_cmpestrs:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    pushl %ebx
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    xorl %ebx, %ebx
; X86-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0
; X86-SSE-NEXT:    sets %bl
; X86-SSE-NEXT:    movl %ebx, %eax
; X86-SSE-NEXT:    popl %ebx
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: test_mm_cmpestrs:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    pushl %ebx
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-AVX-NEXT:    xorl %ebx, %ebx
; X86-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0
; X86-AVX-NEXT:    sets %bl
; X86-AVX-NEXT:    movl %ebx, %eax
; X86-AVX-NEXT:    popl %ebx
; X86-AVX-NEXT:    retl
;
; X64-SSE-LABEL: test_mm_cmpestrs:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movl %esi, %edx
; X64-SSE-NEXT:    movl %edi, %eax
; X64-SSE-NEXT:    xorl %esi, %esi
; X64-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0
; X64-SSE-NEXT:    sets %sil
; X64-SSE-NEXT:    movl %esi, %eax
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: test_mm_cmpestrs:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    movl %esi, %edx
; X64-AVX-NEXT:    movl %edi, %eax
; X64-AVX-NEXT:    xorl %esi, %esi
; X64-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0
; X64-AVX-NEXT:    sets %sil
; X64-AVX-NEXT:    movl %esi, %eax
; X64-AVX-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg2 = bitcast <2 x i64> %a2 to <16 x i8>
  %res = call i32 @llvm.x86.sse42.pcmpestris128(<16 x i8> %arg0, i32 %a1, <16 x i8> %arg2, i32 %a3, i8 7)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpestris128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone

define i32 @test_mm_cmpestrz(<2 x i64> %a0, i32 %a1, <2 x i64> %a2, i32 %a3) nounwind {
; X86-SSE-LABEL: test_mm_cmpestrz:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    pushl %ebx
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    xorl %ebx, %ebx
; X86-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0
; X86-SSE-NEXT:    sete %bl
; X86-SSE-NEXT:    movl %ebx, %eax
; X86-SSE-NEXT:    popl %ebx
; X86-SSE-NEXT:    retl
;
; X86-AVX-LABEL: test_mm_cmpestrz:
; X86-AVX:       # %bb.0:
; X86-AVX-NEXT:    pushl %ebx
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-AVX-NEXT:    xorl %ebx, %ebx
; X86-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0
; X86-AVX-NEXT:    sete %bl
; X86-AVX-NEXT:    movl %ebx, %eax
; X86-AVX-NEXT:    popl %ebx
; X86-AVX-NEXT:    retl
;
; X64-SSE-LABEL: test_mm_cmpestrz:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    movl %esi, %edx
; X64-SSE-NEXT:    movl %edi, %eax
; X64-SSE-NEXT:    xorl %esi, %esi
; X64-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0
; X64-SSE-NEXT:    sete %sil
; X64-SSE-NEXT:    movl %esi, %eax
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: test_mm_cmpestrz:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    movl %esi, %edx
; X64-AVX-NEXT:    movl %edi, %eax
; X64-AVX-NEXT:    xorl %esi, %esi
; X64-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0
; X64-AVX-NEXT:    sete %sil
; X64-AVX-NEXT:    movl %esi, %eax
; X64-AVX-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg2 = bitcast <2 x i64> %a2 to <16 x i8>
  %res = call i32 @llvm.x86.sse42.pcmpestriz128(<16 x i8> %arg0, i32 %a1, <16 x i8> %arg2, i32 %a3, i8 7)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpestriz128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone

define <2 x i64> @test_mm_cmpgt_epi64(<2 x i64> %a0, <2 x i64> %a1) {
; SSE-LABEL: test_mm_cmpgt_epi64:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpgtq %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX1-LABEL: test_mm_cmpgt_epi64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    ret{{[l|q]}}
;
; AVX512-LABEL: test_mm_cmpgt_epi64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpcmpgtq %xmm1, %xmm0, %k0
; AVX512-NEXT:    vpmovm2q %k0, %xmm0
; AVX512-NEXT:    ret{{[l|q]}}
  %cmp = icmp sgt <2 x i64> %a0, %a1
  %res = sext <2 x i1> %cmp to <2 x i64>
  ret <2 x i64> %res
}

define i32 @test_mm_cmpistra(<2 x i64> %a0, <2 x i64> %a1) {
; SSE-LABEL: test_mm_cmpistra:
; SSE:       # %bb.0:
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    pcmpistri $7, %xmm1, %xmm0
; SSE-NEXT:    seta %al
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: test_mm_cmpistra:
; AVX:       # %bb.0:
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    vpcmpistri $7, %xmm1, %xmm0
; AVX-NEXT:    seta %al
; AVX-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %res = call i32 @llvm.x86.sse42.pcmpistria128(<16 x i8> %arg0, <16 x i8> %arg1, i8 7)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpistria128(<16 x i8>, <16 x i8>, i8) nounwind readnone

define i32 @test_mm_cmpistrc(<2 x i64> %a0, <2 x i64> %a1) {
; SSE-LABEL: test_mm_cmpistrc:
; SSE:       # %bb.0:
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    pcmpistri $7, %xmm1, %xmm0
; SSE-NEXT:    setb %al
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: test_mm_cmpistrc:
; AVX:       # %bb.0:
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    vpcmpistri $7, %xmm1, %xmm0
; AVX-NEXT:    setb %al
; AVX-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %res = call i32 @llvm.x86.sse42.pcmpistric128(<16 x i8> %arg0, <16 x i8> %arg1, i8 7)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpistric128(<16 x i8>, <16 x i8>, i8) nounwind readnone

define i32 @test_mm_cmpistri(<2 x i64> %a0, <2 x i64> %a1) {
; SSE-LABEL: test_mm_cmpistri:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpistri $7, %xmm1, %xmm0
; SSE-NEXT:    movl %ecx, %eax
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: test_mm_cmpistri:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpistri $7, %xmm1, %xmm0
; AVX-NEXT:    movl %ecx, %eax
; AVX-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %res = call i32 @llvm.x86.sse42.pcmpistri128(<16 x i8> %arg0, <16 x i8> %arg1, i8 7)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpistri128(<16 x i8>, <16 x i8>, i8) nounwind readnone

define <2 x i64> @test_mm_cmpistrm(<2 x i64> %a0, <2 x i64> %a1) {
; SSE-LABEL: test_mm_cmpistrm:
; SSE:       # %bb.0:
; SSE-NEXT:    pcmpistrm $7, %xmm1, %xmm0
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: test_mm_cmpistrm:
; AVX:       # %bb.0:
; AVX-NEXT:    vpcmpistrm $7, %xmm1, %xmm0
; AVX-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %res = call <16 x i8> @llvm.x86.sse42.pcmpistrm128(<16 x i8> %arg0, <16 x i8> %arg1, i8 7)
  %bc = bitcast <16 x i8> %res to <2 x i64>
  ret <2 x i64> %bc
}
declare <16 x i8> @llvm.x86.sse42.pcmpistrm128(<16 x i8>, <16 x i8>, i8) nounwind readnone

define i32 @test_mm_cmpistro(<2 x i64> %a0, <2 x i64> %a1) {
; SSE-LABEL: test_mm_cmpistro:
; SSE:       # %bb.0:
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    pcmpistri $7, %xmm1, %xmm0
; SSE-NEXT:    seto %al
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: test_mm_cmpistro:
; AVX:       # %bb.0:
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    vpcmpistri $7, %xmm1, %xmm0
; AVX-NEXT:    seto %al
; AVX-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %res = call i32 @llvm.x86.sse42.pcmpistrio128(<16 x i8> %arg0, <16 x i8> %arg1, i8 7)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpistrio128(<16 x i8>, <16 x i8>, i8) nounwind readnone

define i32 @test_mm_cmpistrs(<2 x i64> %a0, <2 x i64> %a1) {
; SSE-LABEL: test_mm_cmpistrs:
; SSE:       # %bb.0:
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    pcmpistri $7, %xmm1, %xmm0
; SSE-NEXT:    sets %al
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: test_mm_cmpistrs:
; AVX:       # %bb.0:
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    vpcmpistri $7, %xmm1, %xmm0
; AVX-NEXT:    sets %al
; AVX-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %res = call i32 @llvm.x86.sse42.pcmpistris128(<16 x i8> %arg0, <16 x i8> %arg1, i8 7)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpistris128(<16 x i8>, <16 x i8>, i8) nounwind readnone

define i32 @test_mm_cmpistrz(<2 x i64> %a0, <2 x i64> %a1) {
; SSE-LABEL: test_mm_cmpistrz:
; SSE:       # %bb.0:
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    pcmpistri $7, %xmm1, %xmm0
; SSE-NEXT:    sete %al
; SSE-NEXT:    ret{{[l|q]}}
;
; AVX-LABEL: test_mm_cmpistrz:
; AVX:       # %bb.0:
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    vpcmpistri $7, %xmm1, %xmm0
; AVX-NEXT:    sete %al
; AVX-NEXT:    ret{{[l|q]}}
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %res = call i32 @llvm.x86.sse42.pcmpistriz128(<16 x i8> %arg0, <16 x i8> %arg1, i8 7)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpistriz128(<16 x i8>, <16 x i8>, i8) nounwind readnone

define i32 @test_mm_crc32_u8(i32 %a0, i8 %a1) {
; X86-LABEL: test_mm_crc32_u8:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    crc32b {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_mm_crc32_u8:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    crc32b %sil, %eax
; X64-NEXT:    retq
  %res = call i32 @llvm.x86.sse42.crc32.32.8(i32 %a0, i8 %a1)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.crc32.32.8(i32, i8) nounwind readnone

define i32 @test_mm_crc32_u16(i32 %a0, i16 %a1) {
; X86-LABEL: test_mm_crc32_u16:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    crc32w {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_mm_crc32_u16:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    crc32w %si, %eax
; X64-NEXT:    retq
  %res = call i32 @llvm.x86.sse42.crc32.32.16(i32 %a0, i16 %a1)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.crc32.32.16(i32, i16) nounwind readnone

define i32 @test_mm_crc32_u32(i32 %a0, i32 %a1) {
; X86-LABEL: test_mm_crc32_u32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    crc32l {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: test_mm_crc32_u32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    crc32l %esi, %eax
; X64-NEXT:    retq
  %res = call i32 @llvm.x86.sse42.crc32.32.32(i32 %a0, i32 %a1)
  ret i32 %res
}
declare i32 @llvm.x86.sse42.crc32.32.32(i32, i32) nounwind readnone
