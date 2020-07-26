; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -constprop -S | FileCheck %s

@g = external global i16, align 1
@g2 = external global i16, align 1

define i64 @ptrdiff1() {
; CHECK-LABEL: @ptrdiff1(
; CHECK-NEXT:    [[R:%.*]] = freeze i64 sub (i64 ptrtoint (i16* @g to i64), i64 ptrtoint (i16* @g2 to i64))
; CHECK-NEXT:    ret i64 [[R]]
;
  %i = ptrtoint i16* @g to i64
  %i2 = ptrtoint i16* @g2 to i64
  %diff = sub i64 %i, %i2
  %r = freeze i64 %diff
  ret i64 %r
}

define i64 @ptrdiff2() {
; CHECK-LABEL: @ptrdiff2(
; CHECK-NEXT:    [[R:%.*]] = freeze i64 -2
; CHECK-NEXT:    ret i64 [[R]]
;
  %i = ptrtoint i16* @g to i64
  %gep = getelementptr i16, i16* @g, i64 1
  %i2 = ptrtoint i16* %gep to i64
  %diff = sub i64 %i, %i2
  %r = freeze i64 %diff
  ret i64 %r
}
