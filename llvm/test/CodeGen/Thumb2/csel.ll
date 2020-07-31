; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi %s -verify-machineinstrs -o - | FileCheck %s

define i32 @csinc_const_65(i32 %a) {
; CHECK-LABEL: csinc_const_65:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r1, #5
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    cinc r0, r1, gt
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %spec.select = select i1 %cmp, i32 6, i32 5
  ret i32 %spec.select
}

define i32 @csinc_const_56(i32 %a) {
; CHECK-LABEL: csinc_const_56:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r1, #5
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    cinc r0, r1, le
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %spec.select = select i1 %cmp, i32 5, i32 6
  ret i32 %spec.select
}

define i32 @csinc_const_zext(i32 %a) {
; CHECK-LABEL: csinc_const_zext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    cset r0, gt
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %spec.select = zext i1 %cmp to i32
  ret i32 %spec.select
}

define i32 @csinv_const_56(i32 %a) {
; CHECK-LABEL: csinv_const_56:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r1, #5
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    cinv r0, r1, gt
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %spec.select = select i1 %cmp, i32 -6, i32 5
  ret i32 %spec.select
}

define i32 @csinv_const_65(i32 %a) {
; CHECK-LABEL: csinv_const_65:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r1, #5
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    cinv r0, r1, le
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %spec.select = select i1 %cmp, i32 5, i32 -6
  ret i32 %spec.select
}

define i32 @csinv_const_sext(i32 %a) {
; CHECK-LABEL: csinv_const_sext:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    csetm r0, gt
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %spec.select = sext i1 %cmp to i32
  ret i32 %spec.select
}

define i32 @csneg_const(i32 %a) {
; CHECK-LABEL: csneg_const:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r1, #1
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    cneg r0, r1, le
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %spec.select = select i1 %cmp, i32 1, i32 -1
  ret i32 %spec.select
}

define i32 @csneg_const_r(i32 %a) {
; CHECK-LABEL: csneg_const_r:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r1, #1
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    cneg r0, r1, gt
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %spec.select = select i1 %cmp, i32 -1, i32 1
  ret i32 %spec.select
}

define i32 @csel_var(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csel_var:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    csel r0, r1, r2, gt
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %spec.select = select i1 %cmp, i32 %b, i32 %c
  ret i32 %spec.select
}

define i32 @csinc_var(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csinc_var:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    csinc r0, r1, r2, gt
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %cplus1 = add nsw i32 %c, 1
  %spec.select = select i1 %cmp, i32 %b, i32 %cplus1
  ret i32 %spec.select
}

define i32 @csinc_swap_var(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csinc_swap_var:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    csinc r0, r2, r1, le
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %bplus1 = add nsw i32 %b, 1
  %spec.select = select i1 %cmp, i32 %bplus1, i32 %c
  ret i32 %spec.select
}

define i32 @csinv_var(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csinv_var:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    csinv r0, r1, r2, gt
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %cinv = xor i32 %c, -1
  %spec.select = select i1 %cmp, i32 %b, i32 %cinv
  ret i32 %spec.select
}

define i32 @csinv_swap_var(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csinv_swap_var:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    csinv r0, r2, r1, le
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %binv = xor i32 %b, -1
  %spec.select = select i1 %cmp, i32 %binv, i32 %c
  ret i32 %spec.select
}

define i32 @csneg_var(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csneg_var:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    csneg r0, r1, r2, gt
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %cneg = sub i32 0, %c
  %spec.select = select i1 %cmp, i32 %b, i32 %cneg
  ret i32 %spec.select
}

define i32 @csneg_swap_var_sgt(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csneg_swap_var_sgt:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    csneg r0, r2, r1, le
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 45
  %bneg = sub i32 0, %b
  %spec.select = select i1 %cmp, i32 %bneg, i32 %c
  ret i32 %spec.select
}

define i32 @csneg_swap_var_sge(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csneg_swap_var_sge:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #44
; CHECK-NEXT:    csneg r0, r2, r1, le
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sge i32 %a, 45
  %bneg = sub i32 0, %b
  %spec.select = select i1 %cmp, i32 %bneg, i32 %c
  ret i32 %spec.select
}

define i32 @csneg_swap_var_sle(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csneg_swap_var_sle:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #46
; CHECK-NEXT:    csneg r0, r2, r1, ge
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sle i32 %a, 45
  %bneg = sub i32 0, %b
  %spec.select = select i1 %cmp, i32 %bneg, i32 %c
  ret i32 %spec.select
}

define i32 @csneg_swap_var_slt(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csneg_swap_var_slt:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    csneg r0, r2, r1, ge
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp slt i32 %a, 45
  %bneg = sub i32 0, %b
  %spec.select = select i1 %cmp, i32 %bneg, i32 %c
  ret i32 %spec.select
}

define i32 @csneg_swap_var_ugt(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csneg_swap_var_ugt:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    csneg r0, r2, r1, ls
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp ugt i32 %a, 45
  %bneg = sub i32 0, %b
  %spec.select = select i1 %cmp, i32 %bneg, i32 %c
  ret i32 %spec.select
}

define i32 @csneg_swap_var_uge(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csneg_swap_var_uge:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #44
; CHECK-NEXT:    csneg r0, r2, r1, ls
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp uge i32 %a, 45
  %bneg = sub i32 0, %b
  %spec.select = select i1 %cmp, i32 %bneg, i32 %c
  ret i32 %spec.select
}

define i32 @csneg_swap_var_ule(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csneg_swap_var_ule:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #46
; CHECK-NEXT:    csneg r0, r2, r1, hs
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp ule i32 %a, 45
  %bneg = sub i32 0, %b
  %spec.select = select i1 %cmp, i32 %bneg, i32 %c
  ret i32 %spec.select
}

define i32 @csneg_swap_var_ult(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csneg_swap_var_ult:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    csneg r0, r2, r1, hs
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp ult i32 %a, 45
  %bneg = sub i32 0, %b
  %spec.select = select i1 %cmp, i32 %bneg, i32 %c
  ret i32 %spec.select
}

define i32 @csneg_swap_var_ne(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csneg_swap_var_ne:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    csneg r0, r2, r1, ne
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp eq i32 %a, 45
  %bneg = sub i32 0, %b
  %spec.select = select i1 %cmp, i32 %bneg, i32 %c
  ret i32 %spec.select
}

define i32 @csneg_swap_var_eq(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: csneg_swap_var_eq:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r0, #45
; CHECK-NEXT:    csneg r0, r2, r1, eq
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp ne i32 %a, 45
  %bneg = sub i32 0, %b
  %spec.select = select i1 %cmp, i32 %bneg, i32 %c
  ret i32 %spec.select
}

define i32 @csinc_inplace(i32 %a, i32 %b) {
; CHECK-LABEL: csinc_inplace:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r1, #45
; CHECK-NEXT:    cinc r0, r0, gt
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %b, 45
  %inc = zext i1 %cmp to i32
  %spec.select = add nsw i32 %inc, %a
  ret i32 %spec.select
}

define i32 @csinv_inplace(i32 %a, i32 %b) {
; CHECK-LABEL: csinv_inplace:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r1, #45
; CHECK-NEXT:    cinv r0, r0, gt
; CHECK-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %b, 45
  %sub = sext i1 %cmp to i32
  %xor = xor i32 %sub, %a
  ret i32 %xor
}

