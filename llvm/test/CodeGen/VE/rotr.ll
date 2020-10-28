; RUN: llc < %s -mtriple=ve-unknown-unknown | FileCheck %s

define i64 @func1(i64 %a, i32 %b) {
; CHECK-LABEL: func1:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    srl %s2, %s0, %s1
; CHECK-NEXT:    lea %s3, 64
; CHECK-NEXT:    subs.w.sx %s1, %s3, %s1
; CHECK-NEXT:    sll %s0, %s0, %s1
; CHECK-NEXT:    or %s0, %s0, %s2
; CHECK-NEXT:    or %s11, 0, %s9
  %b64 = zext i32 %b to i64
  %a.lr = lshr i64 %a, %b64
  %b.inv = sub nsw i32 64, %b
  %b.inv64 = zext i32 %b.inv to i64
  %a.sl = shl i64 %a, %b.inv64
  %r = or i64 %a.sl, %a.lr
  ret i64 %r
}

define i32 @func2(i32 %a, i32 %b) {
; CHECK-LABEL: func2:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    and %s2, %s0, (32)0
; CHECK-NEXT:    srl %s2, %s2, %s1
; CHECK-NEXT:    subs.w.sx %s1, 32, %s1
; CHECK-NEXT:    sla.w.sx %s0, %s0, %s1
; CHECK-NEXT:    or %s0, %s0, %s2
; CHECK-NEXT:    or %s11, 0, %s9
  %a.lr = lshr i32 %a, %b
  %b.inv = sub nsw i32 32, %b
  %a.sl = shl i32 %a, %b.inv
  %r = or i32 %a.sl, %a.lr
  ret i32 %r
}
