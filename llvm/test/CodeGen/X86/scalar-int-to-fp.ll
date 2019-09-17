; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown-unknown     -mattr=+avx512f,+avx512dq,+avx512vl | FileCheck %s --check-prefixes=CHECK,CHECK32,AVX512_32,AVX512DQVL_32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown   -mattr=+avx512f,+avx512dq,+avx512vl | FileCheck %s --check-prefixes=CHECK,CHECK64,AVX512_64,AVX512DQVL_64
; RUN: llc < %s -mtriple=i386-unknown-unknown     -mattr=+avx512f,+avx512dq | FileCheck %s --check-prefixes=CHECK,CHECK32,AVX512_32,AVX512DQ_32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown   -mattr=+avx512f,+avx512dq | FileCheck %s --check-prefixes=CHECK,CHECK64,AVX512_64,AVX512DQ_64
; RUN: llc < %s -mtriple=i386-unknown-unknown     -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,CHECK32,AVX512_32,AVX512F_32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown   -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,CHECK64,AVX512_64,AVX512F_64
; RUN: llc < %s -mtriple=i386-unknown-unknown     -mattr=+sse2    | FileCheck %s --check-prefixes=CHECK,CHECK32,SSE2_32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown   -mattr=+sse2    | FileCheck %s --check-prefixes=CHECK,CHECK64,SSE2_64
; RUN: llc < %s -mtriple=i386-unknown-unknown     -mattr=-sse     | FileCheck %s --check-prefixes=CHECK,CHECK32,X87

; Verify that scalar integer conversions to FP compile successfully
; (at one time long double failed with avx512f), and that reasonable
; instruction sequences are selected based on subtarget features.

define float @u32_to_f(i32 %a) nounwind {
; AVX512_32-LABEL: u32_to_f:
; AVX512_32:       # %bb.0:
; AVX512_32-NEXT:    pushl %eax
; AVX512_32-NEXT:    vcvtusi2ssl {{[0-9]+}}(%esp), %xmm0, %xmm0
; AVX512_32-NEXT:    vmovss %xmm0, (%esp)
; AVX512_32-NEXT:    flds (%esp)
; AVX512_32-NEXT:    popl %eax
; AVX512_32-NEXT:    retl
;
; AVX512_64-LABEL: u32_to_f:
; AVX512_64:       # %bb.0:
; AVX512_64-NEXT:    vcvtusi2ss %edi, %xmm0, %xmm0
; AVX512_64-NEXT:    retq
;
; SSE2_32-LABEL: u32_to_f:
; SSE2_32:       # %bb.0:
; SSE2_32-NEXT:    pushl %eax
; SSE2_32-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE2_32-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE2_32-NEXT:    orpd %xmm0, %xmm1
; SSE2_32-NEXT:    subsd %xmm0, %xmm1
; SSE2_32-NEXT:    xorps %xmm0, %xmm0
; SSE2_32-NEXT:    cvtsd2ss %xmm1, %xmm0
; SSE2_32-NEXT:    movss %xmm0, (%esp)
; SSE2_32-NEXT:    flds (%esp)
; SSE2_32-NEXT:    popl %eax
; SSE2_32-NEXT:    retl
;
; SSE2_64-LABEL: u32_to_f:
; SSE2_64:       # %bb.0:
; SSE2_64-NEXT:    movl %edi, %eax
; SSE2_64-NEXT:    cvtsi2ss %rax, %xmm0
; SSE2_64-NEXT:    retq
;
; X87-LABEL: u32_to_f:
; X87:       # %bb.0:
; X87-NEXT:    pushl %ebp
; X87-NEXT:    movl %esp, %ebp
; X87-NEXT:    andl $-8, %esp
; X87-NEXT:    subl $8, %esp
; X87-NEXT:    movl 8(%ebp), %eax
; X87-NEXT:    movl %eax, (%esp)
; X87-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X87-NEXT:    fildll (%esp)
; X87-NEXT:    movl %ebp, %esp
; X87-NEXT:    popl %ebp
; X87-NEXT:    retl
  %r = uitofp i32 %a to float
  ret float %r
}

define float @s32_to_f(i32 %a) nounwind {
; AVX512_32-LABEL: s32_to_f:
; AVX512_32:       # %bb.0:
; AVX512_32-NEXT:    pushl %eax
; AVX512_32-NEXT:    vcvtsi2ssl {{[0-9]+}}(%esp), %xmm0, %xmm0
; AVX512_32-NEXT:    vmovss %xmm0, (%esp)
; AVX512_32-NEXT:    flds (%esp)
; AVX512_32-NEXT:    popl %eax
; AVX512_32-NEXT:    retl
;
; AVX512_64-LABEL: s32_to_f:
; AVX512_64:       # %bb.0:
; AVX512_64-NEXT:    vcvtsi2ss %edi, %xmm0, %xmm0
; AVX512_64-NEXT:    retq
;
; SSE2_32-LABEL: s32_to_f:
; SSE2_32:       # %bb.0:
; SSE2_32-NEXT:    pushl %eax
; SSE2_32-NEXT:    cvtsi2ssl {{[0-9]+}}(%esp), %xmm0
; SSE2_32-NEXT:    movss %xmm0, (%esp)
; SSE2_32-NEXT:    flds (%esp)
; SSE2_32-NEXT:    popl %eax
; SSE2_32-NEXT:    retl
;
; SSE2_64-LABEL: s32_to_f:
; SSE2_64:       # %bb.0:
; SSE2_64-NEXT:    cvtsi2ss %edi, %xmm0
; SSE2_64-NEXT:    retq
;
; X87-LABEL: s32_to_f:
; X87:       # %bb.0:
; X87-NEXT:    pushl %eax
; X87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-NEXT:    movl %eax, (%esp)
; X87-NEXT:    fildl (%esp)
; X87-NEXT:    popl %eax
; X87-NEXT:    retl
  %r = sitofp i32 %a to float
  ret float %r
}

define double @u32_to_d(i32 %a) nounwind {
; AVX512_32-LABEL: u32_to_d:
; AVX512_32:       # %bb.0:
; AVX512_32-NEXT:    pushl %ebp
; AVX512_32-NEXT:    movl %esp, %ebp
; AVX512_32-NEXT:    andl $-8, %esp
; AVX512_32-NEXT:    subl $8, %esp
; AVX512_32-NEXT:    vcvtusi2sdl 8(%ebp), %xmm0, %xmm0
; AVX512_32-NEXT:    vmovsd %xmm0, (%esp)
; AVX512_32-NEXT:    fldl (%esp)
; AVX512_32-NEXT:    movl %ebp, %esp
; AVX512_32-NEXT:    popl %ebp
; AVX512_32-NEXT:    retl
;
; AVX512_64-LABEL: u32_to_d:
; AVX512_64:       # %bb.0:
; AVX512_64-NEXT:    vcvtusi2sd %edi, %xmm0, %xmm0
; AVX512_64-NEXT:    retq
;
; SSE2_32-LABEL: u32_to_d:
; SSE2_32:       # %bb.0:
; SSE2_32-NEXT:    pushl %ebp
; SSE2_32-NEXT:    movl %esp, %ebp
; SSE2_32-NEXT:    andl $-8, %esp
; SSE2_32-NEXT:    subl $8, %esp
; SSE2_32-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE2_32-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE2_32-NEXT:    orpd %xmm0, %xmm1
; SSE2_32-NEXT:    subsd %xmm0, %xmm1
; SSE2_32-NEXT:    movsd %xmm1, (%esp)
; SSE2_32-NEXT:    fldl (%esp)
; SSE2_32-NEXT:    movl %ebp, %esp
; SSE2_32-NEXT:    popl %ebp
; SSE2_32-NEXT:    retl
;
; SSE2_64-LABEL: u32_to_d:
; SSE2_64:       # %bb.0:
; SSE2_64-NEXT:    movl %edi, %eax
; SSE2_64-NEXT:    cvtsi2sd %rax, %xmm0
; SSE2_64-NEXT:    retq
;
; X87-LABEL: u32_to_d:
; X87:       # %bb.0:
; X87-NEXT:    pushl %ebp
; X87-NEXT:    movl %esp, %ebp
; X87-NEXT:    andl $-8, %esp
; X87-NEXT:    subl $8, %esp
; X87-NEXT:    movl 8(%ebp), %eax
; X87-NEXT:    movl %eax, (%esp)
; X87-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X87-NEXT:    fildll (%esp)
; X87-NEXT:    movl %ebp, %esp
; X87-NEXT:    popl %ebp
; X87-NEXT:    retl
  %r = uitofp i32 %a to double
  ret double %r
}

define double @s32_to_d(i32 %a) nounwind {
; AVX512_32-LABEL: s32_to_d:
; AVX512_32:       # %bb.0:
; AVX512_32-NEXT:    pushl %ebp
; AVX512_32-NEXT:    movl %esp, %ebp
; AVX512_32-NEXT:    andl $-8, %esp
; AVX512_32-NEXT:    subl $8, %esp
; AVX512_32-NEXT:    vcvtsi2sdl 8(%ebp), %xmm0, %xmm0
; AVX512_32-NEXT:    vmovsd %xmm0, (%esp)
; AVX512_32-NEXT:    fldl (%esp)
; AVX512_32-NEXT:    movl %ebp, %esp
; AVX512_32-NEXT:    popl %ebp
; AVX512_32-NEXT:    retl
;
; AVX512_64-LABEL: s32_to_d:
; AVX512_64:       # %bb.0:
; AVX512_64-NEXT:    vcvtsi2sd %edi, %xmm0, %xmm0
; AVX512_64-NEXT:    retq
;
; SSE2_32-LABEL: s32_to_d:
; SSE2_32:       # %bb.0:
; SSE2_32-NEXT:    pushl %ebp
; SSE2_32-NEXT:    movl %esp, %ebp
; SSE2_32-NEXT:    andl $-8, %esp
; SSE2_32-NEXT:    subl $8, %esp
; SSE2_32-NEXT:    cvtsi2sdl 8(%ebp), %xmm0
; SSE2_32-NEXT:    movsd %xmm0, (%esp)
; SSE2_32-NEXT:    fldl (%esp)
; SSE2_32-NEXT:    movl %ebp, %esp
; SSE2_32-NEXT:    popl %ebp
; SSE2_32-NEXT:    retl
;
; SSE2_64-LABEL: s32_to_d:
; SSE2_64:       # %bb.0:
; SSE2_64-NEXT:    cvtsi2sd %edi, %xmm0
; SSE2_64-NEXT:    retq
;
; X87-LABEL: s32_to_d:
; X87:       # %bb.0:
; X87-NEXT:    pushl %eax
; X87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-NEXT:    movl %eax, (%esp)
; X87-NEXT:    fildl (%esp)
; X87-NEXT:    popl %eax
; X87-NEXT:    retl
  %r = sitofp i32 %a to double
  ret double %r
}

define x86_fp80 @u32_to_x(i32 %a) nounwind {
; AVX512_32-LABEL: u32_to_x:
; AVX512_32:       # %bb.0:
; AVX512_32-NEXT:    pushl %ebp
; AVX512_32-NEXT:    movl %esp, %ebp
; AVX512_32-NEXT:    andl $-8, %esp
; AVX512_32-NEXT:    subl $8, %esp
; AVX512_32-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX512_32-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX512_32-NEXT:    vorpd %xmm0, %xmm1, %xmm1
; AVX512_32-NEXT:    vsubsd %xmm0, %xmm1, %xmm0
; AVX512_32-NEXT:    vmovsd %xmm0, (%esp)
; AVX512_32-NEXT:    fldl (%esp)
; AVX512_32-NEXT:    movl %ebp, %esp
; AVX512_32-NEXT:    popl %ebp
; AVX512_32-NEXT:    retl
;
; CHECK64-LABEL: u32_to_x:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movl %edi, %eax
; CHECK64-NEXT:    movq %rax, -{{[0-9]+}}(%rsp)
; CHECK64-NEXT:    fildll -{{[0-9]+}}(%rsp)
; CHECK64-NEXT:    retq
;
; SSE2_32-LABEL: u32_to_x:
; SSE2_32:       # %bb.0:
; SSE2_32-NEXT:    pushl %ebp
; SSE2_32-NEXT:    movl %esp, %ebp
; SSE2_32-NEXT:    andl $-8, %esp
; SSE2_32-NEXT:    subl $8, %esp
; SSE2_32-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE2_32-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE2_32-NEXT:    orpd %xmm0, %xmm1
; SSE2_32-NEXT:    subsd %xmm0, %xmm1
; SSE2_32-NEXT:    movsd %xmm1, (%esp)
; SSE2_32-NEXT:    fldl (%esp)
; SSE2_32-NEXT:    movl %ebp, %esp
; SSE2_32-NEXT:    popl %ebp
; SSE2_32-NEXT:    retl
;
; X87-LABEL: u32_to_x:
; X87:       # %bb.0:
; X87-NEXT:    pushl %ebp
; X87-NEXT:    movl %esp, %ebp
; X87-NEXT:    andl $-8, %esp
; X87-NEXT:    subl $8, %esp
; X87-NEXT:    movl 8(%ebp), %eax
; X87-NEXT:    movl %eax, (%esp)
; X87-NEXT:    movl $0, {{[0-9]+}}(%esp)
; X87-NEXT:    fildll (%esp)
; X87-NEXT:    movl %ebp, %esp
; X87-NEXT:    popl %ebp
; X87-NEXT:    retl
  %r = uitofp i32 %a to x86_fp80
  ret x86_fp80 %r
}

define x86_fp80 @s32_to_x(i32 %a) nounwind {
; CHECK32-LABEL: s32_to_x:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    movl %eax, (%esp)
; CHECK32-NEXT:    fildl (%esp)
; CHECK32-NEXT:    popl %eax
; CHECK32-NEXT:    retl
;
; CHECK64-LABEL: s32_to_x:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movl %edi, -{{[0-9]+}}(%rsp)
; CHECK64-NEXT:    fildl -{{[0-9]+}}(%rsp)
; CHECK64-NEXT:    retq
  %r = sitofp i32 %a to x86_fp80
  ret x86_fp80 %r
}

define float @u64_to_f(i64 %a) nounwind {
; AVX512DQVL_32-LABEL: u64_to_f:
; AVX512DQVL_32:       # %bb.0:
; AVX512DQVL_32-NEXT:    pushl %eax
; AVX512DQVL_32-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX512DQVL_32-NEXT:    vcvtuqq2ps %ymm0, %xmm0
; AVX512DQVL_32-NEXT:    vmovss %xmm0, (%esp)
; AVX512DQVL_32-NEXT:    flds (%esp)
; AVX512DQVL_32-NEXT:    popl %eax
; AVX512DQVL_32-NEXT:    vzeroupper
; AVX512DQVL_32-NEXT:    retl
;
; AVX512_64-LABEL: u64_to_f:
; AVX512_64:       # %bb.0:
; AVX512_64-NEXT:    vcvtusi2ss %rdi, %xmm0, %xmm0
; AVX512_64-NEXT:    retq
;
; AVX512DQ_32-LABEL: u64_to_f:
; AVX512DQ_32:       # %bb.0:
; AVX512DQ_32-NEXT:    pushl %eax
; AVX512DQ_32-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX512DQ_32-NEXT:    vcvtuqq2ps %zmm0, %ymm0
; AVX512DQ_32-NEXT:    vmovss %xmm0, (%esp)
; AVX512DQ_32-NEXT:    flds (%esp)
; AVX512DQ_32-NEXT:    popl %eax
; AVX512DQ_32-NEXT:    vzeroupper
; AVX512DQ_32-NEXT:    retl
;
; AVX512F_32-LABEL: u64_to_f:
; AVX512F_32:       # %bb.0:
; AVX512F_32-NEXT:    pushl %ebp
; AVX512F_32-NEXT:    movl %esp, %ebp
; AVX512F_32-NEXT:    andl $-8, %esp
; AVX512F_32-NEXT:    subl $16, %esp
; AVX512F_32-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX512F_32-NEXT:    vmovlps %xmm0, {{[0-9]+}}(%esp)
; AVX512F_32-NEXT:    xorl %eax, %eax
; AVX512F_32-NEXT:    cmpl $0, 12(%ebp)
; AVX512F_32-NEXT:    setns %al
; AVX512F_32-NEXT:    fildll {{[0-9]+}}(%esp)
; AVX512F_32-NEXT:    fadds {{\.LCPI.*}}(,%eax,4)
; AVX512F_32-NEXT:    fstps {{[0-9]+}}(%esp)
; AVX512F_32-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX512F_32-NEXT:    vmovss %xmm0, (%esp)
; AVX512F_32-NEXT:    flds (%esp)
; AVX512F_32-NEXT:    movl %ebp, %esp
; AVX512F_32-NEXT:    popl %ebp
; AVX512F_32-NEXT:    retl
;
; SSE2_32-LABEL: u64_to_f:
; SSE2_32:       # %bb.0:
; SSE2_32-NEXT:    pushl %ebp
; SSE2_32-NEXT:    movl %esp, %ebp
; SSE2_32-NEXT:    andl $-8, %esp
; SSE2_32-NEXT:    subl $16, %esp
; SSE2_32-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE2_32-NEXT:    movlps %xmm0, {{[0-9]+}}(%esp)
; SSE2_32-NEXT:    xorl %eax, %eax
; SSE2_32-NEXT:    cmpl $0, 12(%ebp)
; SSE2_32-NEXT:    setns %al
; SSE2_32-NEXT:    fildll {{[0-9]+}}(%esp)
; SSE2_32-NEXT:    fadds {{\.LCPI.*}}(,%eax,4)
; SSE2_32-NEXT:    fstps {{[0-9]+}}(%esp)
; SSE2_32-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE2_32-NEXT:    movss %xmm0, (%esp)
; SSE2_32-NEXT:    flds (%esp)
; SSE2_32-NEXT:    movl %ebp, %esp
; SSE2_32-NEXT:    popl %ebp
; SSE2_32-NEXT:    retl
;
; SSE2_64-LABEL: u64_to_f:
; SSE2_64:       # %bb.0:
; SSE2_64-NEXT:    testq %rdi, %rdi
; SSE2_64-NEXT:    js .LBB6_1
; SSE2_64-NEXT:  # %bb.2:
; SSE2_64-NEXT:    cvtsi2ss %rdi, %xmm0
; SSE2_64-NEXT:    retq
; SSE2_64-NEXT:  .LBB6_1:
; SSE2_64-NEXT:    movq %rdi, %rax
; SSE2_64-NEXT:    shrq %rax
; SSE2_64-NEXT:    andl $1, %edi
; SSE2_64-NEXT:    orq %rax, %rdi
; SSE2_64-NEXT:    cvtsi2ss %rdi, %xmm0
; SSE2_64-NEXT:    addss %xmm0, %xmm0
; SSE2_64-NEXT:    retq
;
; X87-LABEL: u64_to_f:
; X87:       # %bb.0:
; X87-NEXT:    pushl %ebp
; X87-NEXT:    movl %esp, %ebp
; X87-NEXT:    andl $-8, %esp
; X87-NEXT:    subl $16, %esp
; X87-NEXT:    movl 8(%ebp), %eax
; X87-NEXT:    movl 12(%ebp), %ecx
; X87-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; X87-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; X87-NEXT:    xorl %eax, %eax
; X87-NEXT:    testl %ecx, %ecx
; X87-NEXT:    setns %al
; X87-NEXT:    fildll {{[0-9]+}}(%esp)
; X87-NEXT:    fadds {{\.LCPI.*}}(,%eax,4)
; X87-NEXT:    fstps {{[0-9]+}}(%esp)
; X87-NEXT:    flds {{[0-9]+}}(%esp)
; X87-NEXT:    movl %ebp, %esp
; X87-NEXT:    popl %ebp
; X87-NEXT:    retl
  %r = uitofp i64 %a to float
  ret float %r
}

define float @s64_to_f(i64 %a) nounwind {
; AVX512DQVL_32-LABEL: s64_to_f:
; AVX512DQVL_32:       # %bb.0:
; AVX512DQVL_32-NEXT:    pushl %eax
; AVX512DQVL_32-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX512DQVL_32-NEXT:    vcvtqq2ps %ymm0, %xmm0
; AVX512DQVL_32-NEXT:    vmovss %xmm0, (%esp)
; AVX512DQVL_32-NEXT:    flds (%esp)
; AVX512DQVL_32-NEXT:    popl %eax
; AVX512DQVL_32-NEXT:    vzeroupper
; AVX512DQVL_32-NEXT:    retl
;
; AVX512_64-LABEL: s64_to_f:
; AVX512_64:       # %bb.0:
; AVX512_64-NEXT:    vcvtsi2ss %rdi, %xmm0, %xmm0
; AVX512_64-NEXT:    retq
;
; AVX512DQ_32-LABEL: s64_to_f:
; AVX512DQ_32:       # %bb.0:
; AVX512DQ_32-NEXT:    pushl %eax
; AVX512DQ_32-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX512DQ_32-NEXT:    vcvtqq2ps %zmm0, %ymm0
; AVX512DQ_32-NEXT:    vmovss %xmm0, (%esp)
; AVX512DQ_32-NEXT:    flds (%esp)
; AVX512DQ_32-NEXT:    popl %eax
; AVX512DQ_32-NEXT:    vzeroupper
; AVX512DQ_32-NEXT:    retl
;
; AVX512F_32-LABEL: s64_to_f:
; AVX512F_32:       # %bb.0:
; AVX512F_32-NEXT:    pushl %eax
; AVX512F_32-NEXT:    fildll {{[0-9]+}}(%esp)
; AVX512F_32-NEXT:    fstps (%esp)
; AVX512F_32-NEXT:    flds (%esp)
; AVX512F_32-NEXT:    popl %eax
; AVX512F_32-NEXT:    retl
;
; SSE2_32-LABEL: s64_to_f:
; SSE2_32:       # %bb.0:
; SSE2_32-NEXT:    pushl %eax
; SSE2_32-NEXT:    fildll {{[0-9]+}}(%esp)
; SSE2_32-NEXT:    fstps (%esp)
; SSE2_32-NEXT:    flds (%esp)
; SSE2_32-NEXT:    popl %eax
; SSE2_32-NEXT:    retl
;
; SSE2_64-LABEL: s64_to_f:
; SSE2_64:       # %bb.0:
; SSE2_64-NEXT:    cvtsi2ss %rdi, %xmm0
; SSE2_64-NEXT:    retq
;
; X87-LABEL: s64_to_f:
; X87:       # %bb.0:
; X87-NEXT:    fildll {{[0-9]+}}(%esp)
; X87-NEXT:    retl
  %r = sitofp i64 %a to float
  ret float %r
}

define float @s64_to_f_2(i64 %a) nounwind {
; AVX512DQVL_32-LABEL: s64_to_f_2:
; AVX512DQVL_32:       # %bb.0:
; AVX512DQVL_32-NEXT:    pushl %eax
; AVX512DQVL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512DQVL_32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; AVX512DQVL_32-NEXT:    addl $5, %eax
; AVX512DQVL_32-NEXT:    adcl $0, %ecx
; AVX512DQVL_32-NEXT:    vmovd %eax, %xmm0
; AVX512DQVL_32-NEXT:    vpinsrd $1, %ecx, %xmm0, %xmm0
; AVX512DQVL_32-NEXT:    vcvtqq2ps %ymm0, %xmm0
; AVX512DQVL_32-NEXT:    vmovss %xmm0, (%esp)
; AVX512DQVL_32-NEXT:    flds (%esp)
; AVX512DQVL_32-NEXT:    popl %eax
; AVX512DQVL_32-NEXT:    vzeroupper
; AVX512DQVL_32-NEXT:    retl
;
; AVX512_64-LABEL: s64_to_f_2:
; AVX512_64:       # %bb.0:
; AVX512_64-NEXT:    addq $5, %rdi
; AVX512_64-NEXT:    vcvtsi2ss %rdi, %xmm0, %xmm0
; AVX512_64-NEXT:    retq
;
; AVX512DQ_32-LABEL: s64_to_f_2:
; AVX512DQ_32:       # %bb.0:
; AVX512DQ_32-NEXT:    pushl %eax
; AVX512DQ_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX512DQ_32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; AVX512DQ_32-NEXT:    addl $5, %eax
; AVX512DQ_32-NEXT:    adcl $0, %ecx
; AVX512DQ_32-NEXT:    vmovd %eax, %xmm0
; AVX512DQ_32-NEXT:    vpinsrd $1, %ecx, %xmm0, %xmm0
; AVX512DQ_32-NEXT:    vcvtqq2ps %zmm0, %ymm0
; AVX512DQ_32-NEXT:    vmovss %xmm0, (%esp)
; AVX512DQ_32-NEXT:    flds (%esp)
; AVX512DQ_32-NEXT:    popl %eax
; AVX512DQ_32-NEXT:    vzeroupper
; AVX512DQ_32-NEXT:    retl
;
; AVX512F_32-LABEL: s64_to_f_2:
; AVX512F_32:       # %bb.0:
; AVX512F_32-NEXT:    pushl %ebp
; AVX512F_32-NEXT:    movl %esp, %ebp
; AVX512F_32-NEXT:    andl $-8, %esp
; AVX512F_32-NEXT:    subl $16, %esp
; AVX512F_32-NEXT:    movl 8(%ebp), %eax
; AVX512F_32-NEXT:    movl 12(%ebp), %ecx
; AVX512F_32-NEXT:    addl $5, %eax
; AVX512F_32-NEXT:    adcl $0, %ecx
; AVX512F_32-NEXT:    vmovd %eax, %xmm0
; AVX512F_32-NEXT:    vpinsrd $1, %ecx, %xmm0, %xmm0
; AVX512F_32-NEXT:    vmovq %xmm0, {{[0-9]+}}(%esp)
; AVX512F_32-NEXT:    fildll {{[0-9]+}}(%esp)
; AVX512F_32-NEXT:    fstps {{[0-9]+}}(%esp)
; AVX512F_32-NEXT:    flds {{[0-9]+}}(%esp)
; AVX512F_32-NEXT:    movl %ebp, %esp
; AVX512F_32-NEXT:    popl %ebp
; AVX512F_32-NEXT:    retl
;
; SSE2_32-LABEL: s64_to_f_2:
; SSE2_32:       # %bb.0:
; SSE2_32-NEXT:    pushl %ebp
; SSE2_32-NEXT:    movl %esp, %ebp
; SSE2_32-NEXT:    andl $-8, %esp
; SSE2_32-NEXT:    subl $16, %esp
; SSE2_32-NEXT:    movl 8(%ebp), %eax
; SSE2_32-NEXT:    movl 12(%ebp), %ecx
; SSE2_32-NEXT:    addl $5, %eax
; SSE2_32-NEXT:    adcl $0, %ecx
; SSE2_32-NEXT:    movd %ecx, %xmm0
; SSE2_32-NEXT:    movd %eax, %xmm1
; SSE2_32-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; SSE2_32-NEXT:    movq %xmm1, {{[0-9]+}}(%esp)
; SSE2_32-NEXT:    fildll {{[0-9]+}}(%esp)
; SSE2_32-NEXT:    fstps {{[0-9]+}}(%esp)
; SSE2_32-NEXT:    flds {{[0-9]+}}(%esp)
; SSE2_32-NEXT:    movl %ebp, %esp
; SSE2_32-NEXT:    popl %ebp
; SSE2_32-NEXT:    retl
;
; SSE2_64-LABEL: s64_to_f_2:
; SSE2_64:       # %bb.0:
; SSE2_64-NEXT:    addq $5, %rdi
; SSE2_64-NEXT:    cvtsi2ss %rdi, %xmm0
; SSE2_64-NEXT:    retq
;
; X87-LABEL: s64_to_f_2:
; X87:       # %bb.0:
; X87-NEXT:    pushl %ebp
; X87-NEXT:    movl %esp, %ebp
; X87-NEXT:    andl $-8, %esp
; X87-NEXT:    subl $8, %esp
; X87-NEXT:    movl 8(%ebp), %eax
; X87-NEXT:    movl 12(%ebp), %ecx
; X87-NEXT:    addl $5, %eax
; X87-NEXT:    adcl $0, %ecx
; X87-NEXT:    movl %eax, (%esp)
; X87-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; X87-NEXT:    fildll (%esp)
; X87-NEXT:    movl %ebp, %esp
; X87-NEXT:    popl %ebp
; X87-NEXT:    retl
  %a1 = add i64 %a, 5
  %r = sitofp i64 %a1 to float
  ret float %r
}

define double @u64_to_d(i64 %a) nounwind {
; AVX512DQVL_32-LABEL: u64_to_d:
; AVX512DQVL_32:       # %bb.0:
; AVX512DQVL_32-NEXT:    pushl %ebp
; AVX512DQVL_32-NEXT:    movl %esp, %ebp
; AVX512DQVL_32-NEXT:    andl $-8, %esp
; AVX512DQVL_32-NEXT:    subl $8, %esp
; AVX512DQVL_32-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX512DQVL_32-NEXT:    vcvtuqq2pd %ymm0, %ymm0
; AVX512DQVL_32-NEXT:    vmovlps %xmm0, (%esp)
; AVX512DQVL_32-NEXT:    fldl (%esp)
; AVX512DQVL_32-NEXT:    movl %ebp, %esp
; AVX512DQVL_32-NEXT:    popl %ebp
; AVX512DQVL_32-NEXT:    vzeroupper
; AVX512DQVL_32-NEXT:    retl
;
; AVX512_64-LABEL: u64_to_d:
; AVX512_64:       # %bb.0:
; AVX512_64-NEXT:    vcvtusi2sd %rdi, %xmm0, %xmm0
; AVX512_64-NEXT:    retq
;
; AVX512DQ_32-LABEL: u64_to_d:
; AVX512DQ_32:       # %bb.0:
; AVX512DQ_32-NEXT:    pushl %ebp
; AVX512DQ_32-NEXT:    movl %esp, %ebp
; AVX512DQ_32-NEXT:    andl $-8, %esp
; AVX512DQ_32-NEXT:    subl $8, %esp
; AVX512DQ_32-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX512DQ_32-NEXT:    vcvtuqq2pd %zmm0, %zmm0
; AVX512DQ_32-NEXT:    vmovlps %xmm0, (%esp)
; AVX512DQ_32-NEXT:    fldl (%esp)
; AVX512DQ_32-NEXT:    movl %ebp, %esp
; AVX512DQ_32-NEXT:    popl %ebp
; AVX512DQ_32-NEXT:    vzeroupper
; AVX512DQ_32-NEXT:    retl
;
; AVX512F_32-LABEL: u64_to_d:
; AVX512F_32:       # %bb.0:
; AVX512F_32-NEXT:    pushl %ebp
; AVX512F_32-NEXT:    movl %esp, %ebp
; AVX512F_32-NEXT:    andl $-8, %esp
; AVX512F_32-NEXT:    subl $8, %esp
; AVX512F_32-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX512F_32-NEXT:    vunpcklps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; AVX512F_32-NEXT:    vsubpd {{\.LCPI.*}}, %xmm0, %xmm0
; AVX512F_32-NEXT:    vhaddpd %xmm0, %xmm0, %xmm0
; AVX512F_32-NEXT:    vmovlpd %xmm0, (%esp)
; AVX512F_32-NEXT:    fldl (%esp)
; AVX512F_32-NEXT:    movl %ebp, %esp
; AVX512F_32-NEXT:    popl %ebp
; AVX512F_32-NEXT:    retl
;
; SSE2_32-LABEL: u64_to_d:
; SSE2_32:       # %bb.0:
; SSE2_32-NEXT:    pushl %ebp
; SSE2_32-NEXT:    movl %esp, %ebp
; SSE2_32-NEXT:    andl $-8, %esp
; SSE2_32-NEXT:    subl $8, %esp
; SSE2_32-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE2_32-NEXT:    unpcklps {{.*#+}} xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; SSE2_32-NEXT:    subpd {{\.LCPI.*}}, %xmm0
; SSE2_32-NEXT:    movapd %xmm0, %xmm1
; SSE2_32-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1],xmm0[1]
; SSE2_32-NEXT:    addsd %xmm0, %xmm1
; SSE2_32-NEXT:    movsd %xmm1, (%esp)
; SSE2_32-NEXT:    fldl (%esp)
; SSE2_32-NEXT:    movl %ebp, %esp
; SSE2_32-NEXT:    popl %ebp
; SSE2_32-NEXT:    retl
;
; SSE2_64-LABEL: u64_to_d:
; SSE2_64:       # %bb.0:
; SSE2_64-NEXT:    movq %rdi, %xmm1
; SSE2_64-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],mem[0],xmm1[1],mem[1]
; SSE2_64-NEXT:    subpd {{.*}}(%rip), %xmm1
; SSE2_64-NEXT:    movapd %xmm1, %xmm0
; SSE2_64-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1],xmm1[1]
; SSE2_64-NEXT:    addsd %xmm1, %xmm0
; SSE2_64-NEXT:    retq
;
; X87-LABEL: u64_to_d:
; X87:       # %bb.0:
; X87-NEXT:    pushl %ebp
; X87-NEXT:    movl %esp, %ebp
; X87-NEXT:    andl $-8, %esp
; X87-NEXT:    subl $16, %esp
; X87-NEXT:    movl 8(%ebp), %eax
; X87-NEXT:    movl 12(%ebp), %ecx
; X87-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; X87-NEXT:    movl %eax, (%esp)
; X87-NEXT:    xorl %eax, %eax
; X87-NEXT:    testl %ecx, %ecx
; X87-NEXT:    setns %al
; X87-NEXT:    fildll (%esp)
; X87-NEXT:    fadds {{\.LCPI.*}}(,%eax,4)
; X87-NEXT:    fstpl {{[0-9]+}}(%esp)
; X87-NEXT:    fldl {{[0-9]+}}(%esp)
; X87-NEXT:    movl %ebp, %esp
; X87-NEXT:    popl %ebp
; X87-NEXT:    retl
  %r = uitofp i64 %a to double
  ret double %r
}

define double @s64_to_d(i64 %a) nounwind {
; AVX512DQVL_32-LABEL: s64_to_d:
; AVX512DQVL_32:       # %bb.0:
; AVX512DQVL_32-NEXT:    pushl %ebp
; AVX512DQVL_32-NEXT:    movl %esp, %ebp
; AVX512DQVL_32-NEXT:    andl $-8, %esp
; AVX512DQVL_32-NEXT:    subl $8, %esp
; AVX512DQVL_32-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX512DQVL_32-NEXT:    vcvtqq2pd %ymm0, %ymm0
; AVX512DQVL_32-NEXT:    vmovlps %xmm0, (%esp)
; AVX512DQVL_32-NEXT:    fldl (%esp)
; AVX512DQVL_32-NEXT:    movl %ebp, %esp
; AVX512DQVL_32-NEXT:    popl %ebp
; AVX512DQVL_32-NEXT:    vzeroupper
; AVX512DQVL_32-NEXT:    retl
;
; AVX512_64-LABEL: s64_to_d:
; AVX512_64:       # %bb.0:
; AVX512_64-NEXT:    vcvtsi2sd %rdi, %xmm0, %xmm0
; AVX512_64-NEXT:    retq
;
; AVX512DQ_32-LABEL: s64_to_d:
; AVX512DQ_32:       # %bb.0:
; AVX512DQ_32-NEXT:    pushl %ebp
; AVX512DQ_32-NEXT:    movl %esp, %ebp
; AVX512DQ_32-NEXT:    andl $-8, %esp
; AVX512DQ_32-NEXT:    subl $8, %esp
; AVX512DQ_32-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX512DQ_32-NEXT:    vcvtqq2pd %zmm0, %zmm0
; AVX512DQ_32-NEXT:    vmovlps %xmm0, (%esp)
; AVX512DQ_32-NEXT:    fldl (%esp)
; AVX512DQ_32-NEXT:    movl %ebp, %esp
; AVX512DQ_32-NEXT:    popl %ebp
; AVX512DQ_32-NEXT:    vzeroupper
; AVX512DQ_32-NEXT:    retl
;
; AVX512F_32-LABEL: s64_to_d:
; AVX512F_32:       # %bb.0:
; AVX512F_32-NEXT:    pushl %ebp
; AVX512F_32-NEXT:    movl %esp, %ebp
; AVX512F_32-NEXT:    andl $-8, %esp
; AVX512F_32-NEXT:    subl $8, %esp
; AVX512F_32-NEXT:    fildll 8(%ebp)
; AVX512F_32-NEXT:    fstpl (%esp)
; AVX512F_32-NEXT:    fldl (%esp)
; AVX512F_32-NEXT:    movl %ebp, %esp
; AVX512F_32-NEXT:    popl %ebp
; AVX512F_32-NEXT:    retl
;
; SSE2_32-LABEL: s64_to_d:
; SSE2_32:       # %bb.0:
; SSE2_32-NEXT:    pushl %ebp
; SSE2_32-NEXT:    movl %esp, %ebp
; SSE2_32-NEXT:    andl $-8, %esp
; SSE2_32-NEXT:    subl $8, %esp
; SSE2_32-NEXT:    fildll 8(%ebp)
; SSE2_32-NEXT:    fstpl (%esp)
; SSE2_32-NEXT:    fldl (%esp)
; SSE2_32-NEXT:    movl %ebp, %esp
; SSE2_32-NEXT:    popl %ebp
; SSE2_32-NEXT:    retl
;
; SSE2_64-LABEL: s64_to_d:
; SSE2_64:       # %bb.0:
; SSE2_64-NEXT:    cvtsi2sd %rdi, %xmm0
; SSE2_64-NEXT:    retq
;
; X87-LABEL: s64_to_d:
; X87:       # %bb.0:
; X87-NEXT:    fildll {{[0-9]+}}(%esp)
; X87-NEXT:    retl
  %r = sitofp i64 %a to double
  ret double %r
}

define double @s64_to_d_2(i64 %a) nounwind {
; AVX512DQVL_32-LABEL: s64_to_d_2:
; AVX512DQVL_32:       # %bb.0:
; AVX512DQVL_32-NEXT:    pushl %ebp
; AVX512DQVL_32-NEXT:    movl %esp, %ebp
; AVX512DQVL_32-NEXT:    andl $-8, %esp
; AVX512DQVL_32-NEXT:    subl $8, %esp
; AVX512DQVL_32-NEXT:    movl 8(%ebp), %eax
; AVX512DQVL_32-NEXT:    movl 12(%ebp), %ecx
; AVX512DQVL_32-NEXT:    addl $5, %eax
; AVX512DQVL_32-NEXT:    adcl $0, %ecx
; AVX512DQVL_32-NEXT:    vmovd %eax, %xmm0
; AVX512DQVL_32-NEXT:    vpinsrd $1, %ecx, %xmm0, %xmm0
; AVX512DQVL_32-NEXT:    vcvtqq2pd %ymm0, %ymm0
; AVX512DQVL_32-NEXT:    vmovlps %xmm0, (%esp)
; AVX512DQVL_32-NEXT:    fldl (%esp)
; AVX512DQVL_32-NEXT:    movl %ebp, %esp
; AVX512DQVL_32-NEXT:    popl %ebp
; AVX512DQVL_32-NEXT:    vzeroupper
; AVX512DQVL_32-NEXT:    retl
;
; AVX512_64-LABEL: s64_to_d_2:
; AVX512_64:       # %bb.0:
; AVX512_64-NEXT:    addq $5, %rdi
; AVX512_64-NEXT:    vcvtsi2sd %rdi, %xmm0, %xmm0
; AVX512_64-NEXT:    retq
;
; AVX512DQ_32-LABEL: s64_to_d_2:
; AVX512DQ_32:       # %bb.0:
; AVX512DQ_32-NEXT:    pushl %ebp
; AVX512DQ_32-NEXT:    movl %esp, %ebp
; AVX512DQ_32-NEXT:    andl $-8, %esp
; AVX512DQ_32-NEXT:    subl $8, %esp
; AVX512DQ_32-NEXT:    movl 8(%ebp), %eax
; AVX512DQ_32-NEXT:    movl 12(%ebp), %ecx
; AVX512DQ_32-NEXT:    addl $5, %eax
; AVX512DQ_32-NEXT:    adcl $0, %ecx
; AVX512DQ_32-NEXT:    vmovd %eax, %xmm0
; AVX512DQ_32-NEXT:    vpinsrd $1, %ecx, %xmm0, %xmm0
; AVX512DQ_32-NEXT:    vcvtqq2pd %zmm0, %zmm0
; AVX512DQ_32-NEXT:    vmovlps %xmm0, (%esp)
; AVX512DQ_32-NEXT:    fldl (%esp)
; AVX512DQ_32-NEXT:    movl %ebp, %esp
; AVX512DQ_32-NEXT:    popl %ebp
; AVX512DQ_32-NEXT:    vzeroupper
; AVX512DQ_32-NEXT:    retl
;
; AVX512F_32-LABEL: s64_to_d_2:
; AVX512F_32:       # %bb.0:
; AVX512F_32-NEXT:    pushl %ebp
; AVX512F_32-NEXT:    movl %esp, %ebp
; AVX512F_32-NEXT:    andl $-8, %esp
; AVX512F_32-NEXT:    subl $16, %esp
; AVX512F_32-NEXT:    movl 8(%ebp), %eax
; AVX512F_32-NEXT:    movl 12(%ebp), %ecx
; AVX512F_32-NEXT:    addl $5, %eax
; AVX512F_32-NEXT:    adcl $0, %ecx
; AVX512F_32-NEXT:    vmovd %eax, %xmm0
; AVX512F_32-NEXT:    vpinsrd $1, %ecx, %xmm0, %xmm0
; AVX512F_32-NEXT:    vmovq %xmm0, {{[0-9]+}}(%esp)
; AVX512F_32-NEXT:    fildll {{[0-9]+}}(%esp)
; AVX512F_32-NEXT:    fstpl (%esp)
; AVX512F_32-NEXT:    fldl (%esp)
; AVX512F_32-NEXT:    movl %ebp, %esp
; AVX512F_32-NEXT:    popl %ebp
; AVX512F_32-NEXT:    retl
;
; SSE2_32-LABEL: s64_to_d_2:
; SSE2_32:       # %bb.0:
; SSE2_32-NEXT:    pushl %ebp
; SSE2_32-NEXT:    movl %esp, %ebp
; SSE2_32-NEXT:    andl $-8, %esp
; SSE2_32-NEXT:    subl $16, %esp
; SSE2_32-NEXT:    movl 8(%ebp), %eax
; SSE2_32-NEXT:    movl 12(%ebp), %ecx
; SSE2_32-NEXT:    addl $5, %eax
; SSE2_32-NEXT:    adcl $0, %ecx
; SSE2_32-NEXT:    movd %ecx, %xmm0
; SSE2_32-NEXT:    movd %eax, %xmm1
; SSE2_32-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; SSE2_32-NEXT:    movq %xmm1, {{[0-9]+}}(%esp)
; SSE2_32-NEXT:    fildll {{[0-9]+}}(%esp)
; SSE2_32-NEXT:    fstpl (%esp)
; SSE2_32-NEXT:    fldl (%esp)
; SSE2_32-NEXT:    movl %ebp, %esp
; SSE2_32-NEXT:    popl %ebp
; SSE2_32-NEXT:    retl
;
; SSE2_64-LABEL: s64_to_d_2:
; SSE2_64:       # %bb.0:
; SSE2_64-NEXT:    addq $5, %rdi
; SSE2_64-NEXT:    cvtsi2sd %rdi, %xmm0
; SSE2_64-NEXT:    retq
;
; X87-LABEL: s64_to_d_2:
; X87:       # %bb.0:
; X87-NEXT:    pushl %ebp
; X87-NEXT:    movl %esp, %ebp
; X87-NEXT:    andl $-8, %esp
; X87-NEXT:    subl $8, %esp
; X87-NEXT:    movl 8(%ebp), %eax
; X87-NEXT:    movl 12(%ebp), %ecx
; X87-NEXT:    addl $5, %eax
; X87-NEXT:    adcl $0, %ecx
; X87-NEXT:    movl %eax, (%esp)
; X87-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; X87-NEXT:    fildll (%esp)
; X87-NEXT:    movl %ebp, %esp
; X87-NEXT:    popl %ebp
; X87-NEXT:    retl
  %b = add i64 %a, 5
  %f = sitofp i64 %b to double
  ret double %f
}

define x86_fp80 @u64_to_x(i64 %a) nounwind {
; CHECK32-LABEL: u64_to_x:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %ebp
; CHECK32-NEXT:    movl %esp, %ebp
; CHECK32-NEXT:    andl $-8, %esp
; CHECK32-NEXT:    subl $8, %esp
; CHECK32-NEXT:    movl 8(%ebp), %eax
; CHECK32-NEXT:    movl 12(%ebp), %ecx
; CHECK32-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; CHECK32-NEXT:    movl %eax, (%esp)
; CHECK32-NEXT:    xorl %eax, %eax
; CHECK32-NEXT:    testl %ecx, %ecx
; CHECK32-NEXT:    setns %al
; CHECK32-NEXT:    fildll (%esp)
; CHECK32-NEXT:    fadds {{\.LCPI.*}}(,%eax,4)
; CHECK32-NEXT:    movl %ebp, %esp
; CHECK32-NEXT:    popl %ebp
; CHECK32-NEXT:    retl
;
; CHECK64-LABEL: u64_to_x:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movq %rdi, -{{[0-9]+}}(%rsp)
; CHECK64-NEXT:    xorl %eax, %eax
; CHECK64-NEXT:    testq %rdi, %rdi
; CHECK64-NEXT:    setns %al
; CHECK64-NEXT:    fildll -{{[0-9]+}}(%rsp)
; CHECK64-NEXT:    fadds {{\.LCPI.*}}(,%rax,4)
; CHECK64-NEXT:    retq
  %r = uitofp i64 %a to x86_fp80
  ret x86_fp80 %r
}

define x86_fp80 @s64_to_x(i64 %a) nounwind {
; CHECK32-LABEL: s64_to_x:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fildll {{[0-9]+}}(%esp)
; CHECK32-NEXT:    retl
;
; CHECK64-LABEL: s64_to_x:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movq %rdi, -{{[0-9]+}}(%rsp)
; CHECK64-NEXT:    fildll -{{[0-9]+}}(%rsp)
; CHECK64-NEXT:    retq
  %r = sitofp i64 %a to x86_fp80
  ret x86_fp80 %r
}
