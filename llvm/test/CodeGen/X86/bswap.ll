; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; bswap should be constant folded when it is passed a constant argument

; RUN: llc < %s -mtriple=i686-- -mcpu=i686 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s --check-prefix=CHECK64

declare i16 @llvm.bswap.i16(i16)

declare i32 @llvm.bswap.i32(i32)

declare i64 @llvm.bswap.i64(i64)

define i16 @W(i16 %A) {
; CHECK-LABEL: W:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    rolw $8, %ax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: W:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movl %edi, %eax
; CHECK64-NEXT:    rolw $8, %ax
; CHECK64-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK64-NEXT:    retq
        %Z = call i16 @llvm.bswap.i16( i16 %A )         ; <i16> [#uses=1]
        ret i16 %Z
}

define i32 @X(i32 %A) {
; CHECK-LABEL: X:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    bswapl %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: X:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movl %edi, %eax
; CHECK64-NEXT:    bswapl %eax
; CHECK64-NEXT:    retq
        %Z = call i32 @llvm.bswap.i32( i32 %A )         ; <i32> [#uses=1]
        ret i32 %Z
}

define i64 @Y(i64 %A) {
; CHECK-LABEL: Y:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    bswapl %eax
; CHECK-NEXT:    bswapl %edx
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: Y:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movq %rdi, %rax
; CHECK64-NEXT:    bswapq %rax
; CHECK64-NEXT:    retq
        %Z = call i64 @llvm.bswap.i64( i64 %A )         ; <i64> [#uses=1]
        ret i64 %Z
}

; rdar://9164521
define i32 @test1(i32 %a) nounwind readnone {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    bswapl %eax
; CHECK-NEXT:    shrl $16, %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: test1:
; CHECK64:       # %bb.0: # %entry
; CHECK64-NEXT:    movl %edi, %eax
; CHECK64-NEXT:    bswapl %eax
; CHECK64-NEXT:    shrl $16, %eax
; CHECK64-NEXT:    retq
entry:

  %and = lshr i32 %a, 8
  %shr3 = and i32 %and, 255
  %and2 = shl i32 %a, 8
  %shl = and i32 %and2, 65280
  %or = or i32 %shr3, %shl
  ret i32 %or
}

define i32 @test2(i32 %a) nounwind readnone {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    bswapl %eax
; CHECK-NEXT:    sarl $16, %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: test2:
; CHECK64:       # %bb.0: # %entry
; CHECK64-NEXT:    movl %edi, %eax
; CHECK64-NEXT:    bswapl %eax
; CHECK64-NEXT:    sarl $16, %eax
; CHECK64-NEXT:    retq
entry:

  %and = lshr i32 %a, 8
  %shr4 = and i32 %and, 255
  %and2 = shl i32 %a, 8
  %or = or i32 %shr4, %and2
  %sext = shl i32 %or, 16
  %conv3 = ashr exact i32 %sext, 16
  ret i32 %conv3
}

@var8 = global i8 0
@var16 = global i16 0

; The "shl" below can move bits into the high parts of the value, so the
; operation is not a "bswap, shr" pair.

; rdar://problem/14814049
define i64 @not_bswap() {
; CHECK-LABEL: not_bswap:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzwl var16, %eax
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    shrl $8, %ecx
; CHECK-NEXT:    shll $8, %eax
; CHECK-NEXT:    orl %ecx, %eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: not_bswap:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movzwl {{.*}}(%rip), %eax
; CHECK64-NEXT:    movq %rax, %rcx
; CHECK64-NEXT:    shrq $8, %rcx
; CHECK64-NEXT:    shlq $8, %rax
; CHECK64-NEXT:    orq %rcx, %rax
; CHECK64-NEXT:    retq
  %init = load i16, i16* @var16
  %big = zext i16 %init to i64

  %hishifted = lshr i64 %big, 8
  %loshifted = shl i64 %big, 8

  %notswapped = or i64 %hishifted, %loshifted

  ret i64 %notswapped
}

; This time, the lshr (and subsequent or) is completely useless. While it's
; technically correct to convert this into a "bswap, shr", it's suboptimal. A
; simple shl works better.

define i64 @not_useful_bswap() {
; CHECK-LABEL: not_useful_bswap:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzbl var8, %eax
; CHECK-NEXT:    shll $8, %eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: not_useful_bswap:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movzbl {{.*}}(%rip), %eax
; CHECK64-NEXT:    shlq $8, %rax
; CHECK64-NEXT:    retq
  %init = load i8, i8* @var8
  %big = zext i8 %init to i64

  %hishifted = lshr i64 %big, 8
  %loshifted = shl i64 %big, 8

  %notswapped = or i64 %hishifted, %loshifted

  ret i64 %notswapped
}

; Finally, it *is* OK to just mask off the shl if we know that the value is zero
; beyond 16 bits anyway. This is a legitimate bswap.

define i64 @finally_useful_bswap() {
; CHECK-LABEL: finally_useful_bswap:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzwl var16, %eax
; CHECK-NEXT:    bswapl %eax
; CHECK-NEXT:    shrl $16, %eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: finally_useful_bswap:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movzwl {{.*}}(%rip), %eax
; CHECK64-NEXT:    bswapq %rax
; CHECK64-NEXT:    shrq $48, %rax
; CHECK64-NEXT:    retq
  %init = load i16, i16* @var16
  %big = zext i16 %init to i64

  %hishifted = lshr i64 %big, 8
  %lomasked = and i64 %big, 255
  %loshifted = shl i64 %lomasked, 8

  %swapped = or i64 %hishifted, %loshifted

  ret i64 %swapped
}

