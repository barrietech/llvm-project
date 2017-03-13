; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown < %s | FileCheck %s

; These tests use cmp+adc/sbb in place of test+set+add/sub. Should this transform
; be enabled by micro-architecture rather than as part of generic lowering/isel?

define i8 @test1(i8 %a, i8 %b) nounwind {
; CHECK-LABEL: test1:
; CHECK:       # BB#0:
; CHECK-NEXT:    cmpb %sil, %dil
; CHECK-NEXT:    adcb $0, %sil
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %cmp = icmp ult i8 %a, %b
  %cond = zext i1 %cmp to i8
  %add = add i8 %cond, %b
  ret i8 %add
}

define i32 @test2(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test2:
; CHECK:       # BB#0:
; CHECK-NEXT:    cmpl %esi, %edi
; CHECK-NEXT:    adcl $0, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %cmp = icmp ult i32 %a, %b
  %cond = zext i1 %cmp to i32
  %add = add i32 %cond, %b
  ret i32 %add
}

define i64 @test3(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test3:
; CHECK:       # BB#0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    adcq $0, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %cmp = icmp ult i64 %a, %b
  %conv = zext i1 %cmp to i64
  %add = add i64 %conv, %b
  ret i64 %add
}

define i8 @test4(i8 %a, i8 %b) nounwind {
; CHECK-LABEL: test4:
; CHECK:       # BB#0:
; CHECK-NEXT:    cmpb %sil, %dil
; CHECK-NEXT:    sbbb $0, %sil
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %cmp = icmp ult i8 %a, %b
  %cond = zext i1 %cmp to i8
  %sub = sub i8 %b, %cond
  ret i8 %sub
}

define i32 @test5(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test5:
; CHECK:       # BB#0:
; CHECK-NEXT:    cmpl %esi, %edi
; CHECK-NEXT:    sbbl $0, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %cmp = icmp ult i32 %a, %b
  %cond = zext i1 %cmp to i32
  %sub = sub i32 %b, %cond
  ret i32 %sub
}

define i64 @test6(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test6:
; CHECK:       # BB#0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    sbbq $0, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %cmp = icmp ult i64 %a, %b
  %conv = zext i1 %cmp to i64
  %sub = sub i64 %b, %conv
  ret i64 %sub
}

define i8 @test7(i8 %a, i8 %b) nounwind {
; CHECK-LABEL: test7:
; CHECK:       # BB#0:
; CHECK-NEXT:    cmpb %sil, %dil
; CHECK-NEXT:    adcb $0, %sil
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %cmp = icmp ult i8 %a, %b
  %cond = sext i1 %cmp to i8
  %sub = sub i8 %b, %cond
  ret i8 %sub
}

define i32 @test8(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test8:
; CHECK:       # BB#0:
; CHECK-NEXT:    cmpl %esi, %edi
; CHECK-NEXT:    adcl $0, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %cmp = icmp ult i32 %a, %b
  %cond = sext i1 %cmp to i32
  %sub = sub i32 %b, %cond
  ret i32 %sub
}

define i64 @test9(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: test9:
; CHECK:       # BB#0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    adcq $0, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %cmp = icmp ult i64 %a, %b
  %conv = sext i1 %cmp to i64
  %sub = sub i64 %b, %conv
  ret i64 %sub
}

