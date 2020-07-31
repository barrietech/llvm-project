; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -deadargelim -S | FileCheck %s

declare void @sideeffect()

define void @unused_byref_arg(i32* byref(i32) %dead_arg) {
; CHECK-LABEL: @unused_byref_arg(
; CHECK-NEXT:    tail call void @sideeffect()
; CHECK-NEXT:    ret void
;
  tail call void @sideeffect()
  ret void
}

define void @dont_replace_by_undef(i32* %ptr) {
; CHECK-LABEL: @dont_replace_by_undef(
; CHECK-NEXT:    call void @unused_byref_arg(i32* undef)
; CHECK-NEXT:    ret void
;
  call void @unused_byref_arg(i32* %ptr)
  ret void
}
