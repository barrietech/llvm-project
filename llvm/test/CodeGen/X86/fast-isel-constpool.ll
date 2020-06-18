; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-apple-darwin -fast-isel -code-model=small < %s | FileCheck %s
; RUN: llc -mtriple=x86_64-apple-darwin -fast-isel -code-model=large < %s | FileCheck %s --check-prefix=LARGE
; RUN: llc -mtriple=x86_64-apple-darwin -fast-isel -code-model=small -mattr=avx < %s | FileCheck %s --check-prefix=AVX
; RUN: llc -mtriple=x86_64-apple-darwin -fast-isel -code-model=large -mattr=avx < %s | FileCheck %s --check-prefix=LARGE_AVX
; RUN: llc -mtriple=x86_64-apple-darwin -fast-isel -code-model=small -mattr=avx512f < %s | FileCheck %s --check-prefix=AVX
; RUN: llc -mtriple=x86_64-apple-darwin -fast-isel -code-model=large -mattr=avx512f < %s | FileCheck %s --check-prefix=LARGE_AVX

; This large code mode shouldn't mean anything on x86 but it used to
; generate 64-bit only instructions and asserted in the encoder.
; -show-mc-encoding here to assert if this breaks again.
; RUN: llc -mtriple=i686-apple-darwin -fast-isel -code-model=large -mattr=sse2 -show-mc-encoding < %s | FileCheck %s --check-prefix=X86-LARGE

; Make sure fast isel uses rip-relative addressing for the small code model.
define float @constpool_float(float %x) {
; CHECK-LABEL: constpool_float:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    addss %xmm1, %xmm0
; CHECK-NEXT:    retq
;
; LARGE-LABEL: constpool_float:
; LARGE:       ## %bb.0:
; LARGE-NEXT:    movabsq $LCPI0_0, %rax
; LARGE-NEXT:    addss (%rax), %xmm0
; LARGE-NEXT:    retq
;
; AVX-LABEL: constpool_float:
; AVX:       ## %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; LARGE_AVX-LABEL: constpool_float:
; LARGE_AVX:       ## %bb.0:
; LARGE_AVX-NEXT:    movabsq $LCPI0_0, %rax
; LARGE_AVX-NEXT:    vaddss (%rax), %xmm0, %xmm0
; LARGE_AVX-NEXT:    retq
;
; X86-LARGE-LABEL: constpool_float:
; X86-LARGE:       ## %bb.0:
; X86-LARGE-NEXT:    pushl %eax ## encoding: [0x50]
; X86-LARGE-NEXT:    .cfi_def_cfa_offset 8
; X86-LARGE-NEXT:    movss {{[0-9]+}}(%esp), %xmm0 ## encoding: [0xf3,0x0f,0x10,0x44,0x24,0x08]
; X86-LARGE-NEXT:    ## xmm0 = mem[0],zero,zero,zero
; X86-LARGE-NEXT:    addss LCPI0_0, %xmm0 ## encoding: [0xf3,0x0f,0x58,0x05,A,A,A,A]
; X86-LARGE-NEXT:    ## fixup A - offset: 4, value: LCPI0_0, kind: FK_Data_4
; X86-LARGE-NEXT:    movss %xmm0, (%esp) ## encoding: [0xf3,0x0f,0x11,0x04,0x24]
; X86-LARGE-NEXT:    flds (%esp) ## encoding: [0xd9,0x04,0x24]
; X86-LARGE-NEXT:    popl %eax ## encoding: [0x58]
; X86-LARGE-NEXT:    retl ## encoding: [0xc3]

  %1 = fadd float %x, 16.50e+01
  ret float %1
}

define double @constpool_double(double %x) nounwind {
; CHECK-LABEL: constpool_double:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    addsd %xmm1, %xmm0
; CHECK-NEXT:    retq
;
; LARGE-LABEL: constpool_double:
; LARGE:       ## %bb.0:
; LARGE-NEXT:    movabsq $LCPI1_0, %rax
; LARGE-NEXT:    addsd (%rax), %xmm0
; LARGE-NEXT:    retq
;
; AVX-LABEL: constpool_double:
; AVX:       ## %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; LARGE_AVX-LABEL: constpool_double:
; LARGE_AVX:       ## %bb.0:
; LARGE_AVX-NEXT:    movabsq $LCPI1_0, %rax
; LARGE_AVX-NEXT:    vaddsd (%rax), %xmm0, %xmm0
; LARGE_AVX-NEXT:    retq
;
; X86-LARGE-LABEL: constpool_double:
; X86-LARGE:       ## %bb.0:
; X86-LARGE-NEXT:    subl $12, %esp ## encoding: [0x83,0xec,0x0c]
; X86-LARGE-NEXT:    movsd {{[0-9]+}}(%esp), %xmm0 ## encoding: [0xf2,0x0f,0x10,0x44,0x24,0x10]
; X86-LARGE-NEXT:    ## xmm0 = mem[0],zero
; X86-LARGE-NEXT:    addsd LCPI1_0, %xmm0 ## encoding: [0xf2,0x0f,0x58,0x05,A,A,A,A]
; X86-LARGE-NEXT:    ## fixup A - offset: 4, value: LCPI1_0, kind: FK_Data_4
; X86-LARGE-NEXT:    movsd %xmm0, (%esp) ## encoding: [0xf2,0x0f,0x11,0x04,0x24]
; X86-LARGE-NEXT:    fldl (%esp) ## encoding: [0xdd,0x04,0x24]
; X86-LARGE-NEXT:    addl $12, %esp ## encoding: [0x83,0xc4,0x0c]
; X86-LARGE-NEXT:    retl ## encoding: [0xc3]

  %1 = fadd double %x, 8.500000e-01
  ret double %1
}

define void @constpool_float_no_fp_args(float* %x) nounwind {
; CHECK-LABEL: constpool_float_no_fp_args:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    addss (%rdi), %xmm0
; CHECK-NEXT:    movss %xmm0, (%rdi)
; CHECK-NEXT:    retq
;
; LARGE-LABEL: constpool_float_no_fp_args:
; LARGE:       ## %bb.0:
; LARGE-NEXT:    movabsq $LCPI2_0, %rax
; LARGE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; LARGE-NEXT:    addss (%rdi), %xmm0
; LARGE-NEXT:    movss %xmm0, (%rdi)
; LARGE-NEXT:    retq
;
; AVX-LABEL: constpool_float_no_fp_args:
; AVX:       ## %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vaddss (%rdi), %xmm0, %xmm0
; AVX-NEXT:    vmovss %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; LARGE_AVX-LABEL: constpool_float_no_fp_args:
; LARGE_AVX:       ## %bb.0:
; LARGE_AVX-NEXT:    movabsq $LCPI2_0, %rax
; LARGE_AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; LARGE_AVX-NEXT:    vaddss (%rdi), %xmm0, %xmm0
; LARGE_AVX-NEXT:    vmovss %xmm0, (%rdi)
; LARGE_AVX-NEXT:    retq
;
; X86-LARGE-LABEL: constpool_float_no_fp_args:
; X86-LARGE:       ## %bb.0:
; X86-LARGE-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; X86-LARGE-NEXT:    movss LCPI2_0, %xmm0 ## encoding: [0xf3,0x0f,0x10,0x05,A,A,A,A]
; X86-LARGE-NEXT:    ## fixup A - offset: 4, value: LCPI2_0, kind: FK_Data_4
; X86-LARGE-NEXT:    ## xmm0 = mem[0],zero,zero,zero
; X86-LARGE-NEXT:    addss (%eax), %xmm0 ## encoding: [0xf3,0x0f,0x58,0x00]
; X86-LARGE-NEXT:    movss %xmm0, (%eax) ## encoding: [0xf3,0x0f,0x11,0x00]
; X86-LARGE-NEXT:    retl ## encoding: [0xc3]
  %a = load float, float* %x
  %b = fadd float %a, 16.50e+01
  store float %b, float* %x
  ret void
}

define void @constpool_double_no_fp_args(double* %x) nounwind {
; CHECK-LABEL: constpool_double_no_fp_args:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    addsd (%rdi), %xmm0
; CHECK-NEXT:    movsd %xmm0, (%rdi)
; CHECK-NEXT:    retq
;
; LARGE-LABEL: constpool_double_no_fp_args:
; LARGE:       ## %bb.0:
; LARGE-NEXT:    movabsq $LCPI3_0, %rax
; LARGE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; LARGE-NEXT:    addsd (%rdi), %xmm0
; LARGE-NEXT:    movsd %xmm0, (%rdi)
; LARGE-NEXT:    retq
;
; AVX-LABEL: constpool_double_no_fp_args:
; AVX:       ## %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vaddsd (%rdi), %xmm0, %xmm0
; AVX-NEXT:    vmovsd %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; LARGE_AVX-LABEL: constpool_double_no_fp_args:
; LARGE_AVX:       ## %bb.0:
; LARGE_AVX-NEXT:    movabsq $LCPI3_0, %rax
; LARGE_AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; LARGE_AVX-NEXT:    vaddsd (%rdi), %xmm0, %xmm0
; LARGE_AVX-NEXT:    vmovsd %xmm0, (%rdi)
; LARGE_AVX-NEXT:    retq
;
; X86-LARGE-LABEL: constpool_double_no_fp_args:
; X86-LARGE:       ## %bb.0:
; X86-LARGE-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; X86-LARGE-NEXT:    movsd LCPI3_0, %xmm0 ## encoding: [0xf2,0x0f,0x10,0x05,A,A,A,A]
; X86-LARGE-NEXT:    ## fixup A - offset: 4, value: LCPI3_0, kind: FK_Data_4
; X86-LARGE-NEXT:    ## xmm0 = mem[0],zero
; X86-LARGE-NEXT:    addsd (%eax), %xmm0 ## encoding: [0xf2,0x0f,0x58,0x00]
; X86-LARGE-NEXT:    movsd %xmm0, (%eax) ## encoding: [0xf2,0x0f,0x11,0x00]
; X86-LARGE-NEXT:    retl ## encoding: [0xc3]
  %a = load double, double* %x
  %b = fadd double %a, 8.500000e-01
  store double %b, double* %x
  ret void
}
