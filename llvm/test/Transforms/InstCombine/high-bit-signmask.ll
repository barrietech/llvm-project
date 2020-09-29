; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i64 @t0(i64 %x) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[T0_NEG:%.*]] = ashr i64 [[X:%.*]], 63
; CHECK-NEXT:    ret i64 [[T0_NEG]]
;
  %t0 = lshr i64 %x, 63
  %r = sub i64 0, %t0
  ret i64 %r
}
define i64 @t0_exact(i64 %x) {
; CHECK-LABEL: @t0_exact(
; CHECK-NEXT:    [[T0_NEG:%.*]] = ashr exact i64 [[X:%.*]], 63
; CHECK-NEXT:    ret i64 [[T0_NEG]]
;
  %t0 = lshr exact i64 %x, 63
  %r = sub i64 0, %t0
  ret i64 %r
}
define i64 @t2(i64 %x) {
; CHECK-LABEL: @t2(
; CHECK-NEXT:    [[T0_NEG:%.*]] = lshr i64 [[X:%.*]], 63
; CHECK-NEXT:    ret i64 [[T0_NEG]]
;
  %t0 = ashr i64 %x, 63
  %r = sub i64 0, %t0
  ret i64 %r
}
define i64 @t3_exact(i64 %x) {
; CHECK-LABEL: @t3_exact(
; CHECK-NEXT:    [[T0_NEG:%.*]] = lshr exact i64 [[X:%.*]], 63
; CHECK-NEXT:    ret i64 [[T0_NEG]]
;
  %t0 = ashr exact i64 %x, 63
  %r = sub i64 0, %t0
  ret i64 %r
}

define <2 x i64> @t4(<2 x i64> %x) {
; CHECK-LABEL: @t4(
; CHECK-NEXT:    [[T0_NEG:%.*]] = ashr <2 x i64> [[X:%.*]], <i64 63, i64 63>
; CHECK-NEXT:    ret <2 x i64> [[T0_NEG]]
;
  %t0 = lshr <2 x i64> %x, <i64 63, i64 63>
  %r = sub <2 x i64> zeroinitializer, %t0
  ret <2 x i64> %r
}

define <2 x i64> @t5(<2 x i64> %x) {
; CHECK-LABEL: @t5(
; CHECK-NEXT:    [[T0:%.*]] = lshr <2 x i64> [[X:%.*]], <i64 63, i64 undef>
; CHECK-NEXT:    [[R:%.*]] = sub <2 x i64> <i64 0, i64 undef>, [[T0]]
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %t0 = lshr <2 x i64> %x, <i64 63, i64 undef>
  %r = sub <2 x i64> <i64 0, i64 undef>, %t0
  ret <2 x i64> %r
}

declare void @use64(i64)
declare void @use32(i64)

define i64 @t6(i64 %x) {
; CHECK-LABEL: @t6(
; CHECK-NEXT:    [[T0_NEG:%.*]] = ashr i64 [[X:%.*]], 63
; CHECK-NEXT:    [[T0:%.*]] = lshr i64 [[X]], 63
; CHECK-NEXT:    call void @use64(i64 [[T0]])
; CHECK-NEXT:    ret i64 [[T0_NEG]]
;
  %t0 = lshr i64 %x, 63
  call void @use64(i64 %t0)
  %r = sub i64 0, %t0
  ret i64 %r
}

define i64 @n7(i64 %x) {
; CHECK-LABEL: @n7(
; CHECK-NEXT:    [[T0_NEG:%.*]] = ashr i64 [[X:%.*]], 63
; CHECK-NEXT:    [[T0:%.*]] = lshr i64 [[X]], 63
; CHECK-NEXT:    call void @use32(i64 [[T0]])
; CHECK-NEXT:    ret i64 [[T0_NEG]]
;
  %t0 = lshr i64 %x, 63
  call void @use32(i64 %t0)
  %r = sub i64 0, %t0
  ret i64 %r
}

define i64 @n8(i64 %x) {
; CHECK-LABEL: @n8(
; CHECK-NEXT:    [[T0_NEG:%.*]] = ashr i64 [[X:%.*]], 63
; CHECK-NEXT:    [[T0:%.*]] = lshr i64 [[X]], 63
; CHECK-NEXT:    call void @use64(i64 [[T0]])
; CHECK-NEXT:    call void @use32(i64 [[T0]])
; CHECK-NEXT:    ret i64 [[T0_NEG]]
;
  %t0 = lshr i64 %x, 63
  call void @use64(i64 %t0)
  call void @use32(i64 %t0)
  %r = sub i64 0, %t0
  ret i64 %r
}

define i64 @n9(i64 %x) {
; CHECK-LABEL: @n9(
; CHECK-NEXT:    [[T0:%.*]] = lshr i64 [[X:%.*]], 62
; CHECK-NEXT:    [[R:%.*]] = sub nsw i64 0, [[T0]]
; CHECK-NEXT:    ret i64 [[R]]
;
  %t0 = lshr i64 %x, 62
  %r = sub i64 0, %t0
  ret i64 %r
}

define i64 @n10(i64 %x) {
; CHECK-LABEL: @n10(
; CHECK-NEXT:    [[T0_NEG:%.*]] = ashr i64 [[X:%.*]], 63
; CHECK-NEXT:    [[R:%.*]] = add nsw i64 [[T0_NEG]], 1
; CHECK-NEXT:    ret i64 [[R]]
;
  %t0 = lshr i64 %x, 63
  %r = sub i64 1, %t0
  ret i64 %r
}
