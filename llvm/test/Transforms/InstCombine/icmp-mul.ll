; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare void @use(i8)

; Tests for slt/ult

define i1 @slt_positive_multip_rem_zero(i8 %x) {
; CHECK-LABEL: @slt_positive_multip_rem_zero(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp slt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, 7
  %b = icmp slt i8 %a, 21
  ret i1 %b
}

define i1 @slt_negative_multip_rem_zero(i8 %x) {
; CHECK-LABEL: @slt_negative_multip_rem_zero(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], -7
; CHECK-NEXT:    [[B:%.*]] = icmp slt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, -7
  %b = icmp slt i8 %a, 21
  ret i1 %b
}

define i1 @slt_positive_multip_rem_nz(i8 %x) {
; CHECK-LABEL: @slt_positive_multip_rem_nz(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B:%.*]] = icmp slt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, 5
  %b = icmp slt i8 %a, 21
  ret i1 %b
}

define i1 @ult_rem_zero(i8 %x) {
; CHECK-LABEL: @ult_rem_zero(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp ult i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nuw i8 %x, 7
  %b = icmp ult i8 %a, 21
  ret i1 %b
}

define i1 @ult_rem_nz(i8 %x) {
; CHECK-LABEL: @ult_rem_nz(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B:%.*]] = icmp ult i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nuw i8 %x, 5
  %b = icmp ult i8 %a, 21
  ret i1 %b
}

; Tests for sgt/ugt

define i1 @sgt_positive_multip_rem_zero(i8 %x) {
; CHECK-LABEL: @sgt_positive_multip_rem_zero(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp sgt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, 7
  %b = icmp sgt i8 %a, 21
  ret i1 %b
}

define i1 @sgt_negative_multip_rem_zero(i8 %x) {
; CHECK-LABEL: @sgt_negative_multip_rem_zero(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], -7
; CHECK-NEXT:    [[B:%.*]] = icmp sgt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, -7
  %b = icmp sgt i8 %a, 21
  ret i1 %b
}

define i1 @sgt_positive_multip_rem_nz(i8 %x) {
; CHECK-LABEL: @sgt_positive_multip_rem_nz(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B:%.*]] = icmp sgt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, 5
  %b = icmp sgt i8 %a, 21
  ret i1 %b
}

define i1 @ugt_rem_zero(i8 %x) {
; CHECK-LABEL: @ugt_rem_zero(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp ugt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nuw i8 %x, 7
  %b = icmp ugt i8 %a, 21
  ret i1 %b
}

define i1 @ugt_rem_nz(i8 %x) {
; CHECK-LABEL: @ugt_rem_nz(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B:%.*]] = icmp ugt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nuw i8 %x, 5
  %b = icmp ugt i8 %a, 21
  ret i1 %b
}

; Tests for eq/ne

define i1 @eq_nsw_rem_zero(i8 %x) {
; CHECK-LABEL: @eq_nsw_rem_zero(
; CHECK-NEXT:    [[B:%.*]] = icmp eq i8 [[X:%.*]], -4
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, -5
  %b = icmp eq i8 %a, 20
  ret i1 %b
}

define <2 x i1> @ne_nsw_rem_zero(<2 x i8> %x) {
; CHECK-LABEL: @ne_nsw_rem_zero(
; CHECK-NEXT:    [[B:%.*]] = icmp ne <2 x i8> [[X:%.*]], <i8 -6, i8 -6>
; CHECK-NEXT:    ret <2 x i1> [[B]]
;
  %a = mul nsw <2 x i8> %x, <i8 5, i8 5>
  %b = icmp ne <2 x i8> %a, <i8 -30, i8 -30>
  ret <2 x i1> %b
}

; TODO: Missed fold with undef.

define <2 x i1> @ne_nsw_rem_zero_undef1(<2 x i8> %x) {
; CHECK-LABEL: @ne_nsw_rem_zero_undef1(
; CHECK-NEXT:    [[A:%.*]] = mul nsw <2 x i8> [[X:%.*]], <i8 5, i8 undef>
; CHECK-NEXT:    [[B:%.*]] = icmp ne <2 x i8> [[A]], <i8 -30, i8 -30>
; CHECK-NEXT:    ret <2 x i1> [[B]]
;
  %a = mul nsw <2 x i8> %x, <i8 5, i8 undef>
  %b = icmp ne <2 x i8> %a, <i8 -30, i8 -30>
  ret <2 x i1> %b
}

; TODO: Missed fold with undef.

define <2 x i1> @ne_nsw_rem_zero_undef2(<2 x i8> %x) {
; CHECK-LABEL: @ne_nsw_rem_zero_undef2(
; CHECK-NEXT:    [[A:%.*]] = mul nsw <2 x i8> [[X:%.*]], <i8 5, i8 5>
; CHECK-NEXT:    [[B:%.*]] = icmp ne <2 x i8> [[A]], <i8 -30, i8 undef>
; CHECK-NEXT:    ret <2 x i1> [[B]]
;
  %a = mul nsw <2 x i8> %x, <i8 5, i8 5>
  %b = icmp ne <2 x i8> %a, <i8 -30, i8 undef>
  ret <2 x i1> %b
}

define i1 @eq_nsw_rem_zero_uses(i8 %x) {
; CHECK-LABEL: @eq_nsw_rem_zero_uses(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], -5
; CHECK-NEXT:    call void @use(i8 [[A]])
; CHECK-NEXT:    [[B:%.*]] = icmp eq i8 [[X]], -4
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, -5
  call void @use(i8 %a)
  %b = icmp eq i8 %a, 20
  ret i1 %b
}

; Impossible multiple should be handled by instsimplify.

define i1 @eq_nsw_rem_nz(i8 %x) {
; CHECK-LABEL: @eq_nsw_rem_nz(
; CHECK-NEXT:    ret i1 false
;
  %a = mul nsw i8 %x, 5
  %b = icmp eq i8 %a, 245
  ret i1 %b
}

; Impossible multiple should be handled by instsimplify.

define i1 @ne_nsw_rem_nz(i8 %x) {
; CHECK-LABEL: @ne_nsw_rem_nz(
; CHECK-NEXT:    ret i1 true
;
  %a = mul nsw i8 %x, 5
  %b = icmp ne i8 %a, 130
  ret i1 %b
}

define <2 x i1> @eq_nuw_rem_zero(<2 x i8> %x) {
; CHECK-LABEL: @eq_nuw_rem_zero(
; CHECK-NEXT:    [[B:%.*]] = icmp eq <2 x i8> [[X:%.*]], <i8 4, i8 4>
; CHECK-NEXT:    ret <2 x i1> [[B]]
;
  %a = mul nuw <2 x i8> %x, <i8 5, i8 5>
  %b = icmp eq <2 x i8> %a, <i8 20, i8 20>
  ret <2 x i1> %b
}

; TODO: Missed fold with undef.

define <2 x i1> @eq_nuw_rem_zero_undef1(<2 x i8> %x) {
; CHECK-LABEL: @eq_nuw_rem_zero_undef1(
; CHECK-NEXT:    [[A:%.*]] = mul nuw <2 x i8> [[X:%.*]], <i8 undef, i8 5>
; CHECK-NEXT:    [[B:%.*]] = icmp eq <2 x i8> [[A]], <i8 20, i8 20>
; CHECK-NEXT:    ret <2 x i1> [[B]]
;
  %a = mul nuw <2 x i8> %x, <i8 undef, i8 5>
  %b = icmp eq <2 x i8> %a, <i8 20, i8 20>
  ret <2 x i1> %b
}

; TODO: Missed fold with undef.

define <2 x i1> @eq_nuw_rem_zero_undef2(<2 x i8> %x) {
; CHECK-LABEL: @eq_nuw_rem_zero_undef2(
; CHECK-NEXT:    [[A:%.*]] = mul nuw <2 x i8> [[X:%.*]], <i8 5, i8 5>
; CHECK-NEXT:    [[B:%.*]] = icmp eq <2 x i8> [[A]], <i8 undef, i8 20>
; CHECK-NEXT:    ret <2 x i1> [[B]]
;
  %a = mul nuw <2 x i8> %x, <i8 5, i8 5>
  %b = icmp eq <2 x i8> %a, <i8 undef, i8 20>
  ret <2 x i1> %b
}

define i1 @ne_nuw_rem_zero(i8 %x) {
; CHECK-LABEL: @ne_nuw_rem_zero(
; CHECK-NEXT:    [[B:%.*]] = icmp ne i8 [[X:%.*]], 26
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nuw i8 %x, 5
  %b = icmp ne i8 %a, 130
  ret i1 %b
}

define i1 @ne_nuw_rem_zero_uses(i8 %x) {
; CHECK-LABEL: @ne_nuw_rem_zero_uses(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i8 [[X:%.*]], 5
; CHECK-NEXT:    call void @use(i8 [[A]])
; CHECK-NEXT:    [[B:%.*]] = icmp ne i8 [[X]], 26
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nuw i8 %x, 5
  call void @use(i8 %a)
  %b = icmp ne i8 %a, 130
  ret i1 %b
}

; Impossible multiple should be handled by instsimplify.

define i1 @eq_nuw_rem_nz(i8 %x) {
; CHECK-LABEL: @eq_nuw_rem_nz(
; CHECK-NEXT:    ret i1 false
;
  %a = mul nuw i8 %x, -5
  %b = icmp eq i8 %a, 20
  ret i1 %b
}

; Impossible multiple should be handled by instsimplify.

define i1 @ne_nuw_rem_nz(i8 %x) {
; CHECK-LABEL: @ne_nuw_rem_nz(
; CHECK-NEXT:    ret i1 true
;
  %a = mul nuw i8 %x, 5
  %b = icmp ne i8 %a, -30
  ret i1 %b
}

; Negative tests for the icmp mul folds

define i1 @sgt_positive_multip_rem_zero_nonsw(i8 %x) {
; CHECK-LABEL: @sgt_positive_multip_rem_zero_nonsw(
; CHECK-NEXT:    [[A:%.*]] = mul i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp sgt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul i8 %x, 7
  %b = icmp sgt i8 %a, 21
  ret i1 %b
}

define i1 @ult_multip_rem_zero_nonsw(i8 %x) {
; CHECK-LABEL: @ult_multip_rem_zero_nonsw(
; CHECK-NEXT:    [[A:%.*]] = mul i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp ult i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul i8 %x, 7
  %b = icmp ult i8 %a, 21
  ret i1 %b
}

define i1 @ugt_rem_zero_nonuw(i8 %x) {
; CHECK-LABEL: @ugt_rem_zero_nonuw(
; CHECK-NEXT:    [[A:%.*]] = mul i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp ugt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul i8 %x, 7
  %b = icmp ugt i8 %a, 21
  ret i1 %b
}

define i1 @sgt_minnum(i8 %x) {
; CHECK-LABEL: @sgt_minnum(
; CHECK-NEXT:    ret i1 true
;
  %a = mul nsw i8 %x, 7
  %b = icmp sgt i8 %a, -128
  ret i1 %b
}

define i1 @ule_bignum(i8 %x) {
; CHECK-LABEL: @ule_bignum(
; CHECK-NEXT:    [[B:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul i8 %x, 2147483647
  %b = icmp ule i8 %a, 0
  ret i1 %b
}

define i1 @sgt_mulzero(i8 %x) {
; CHECK-LABEL: @sgt_mulzero(
; CHECK-NEXT:    ret i1 false
;
  %a = mul nsw i8 %x, 0
  %b = icmp sgt i8 %a, 21
  ret i1 %b
}

define i1 @eq_rem_zero_nonuw(i8 %x) {
; CHECK-LABEL: @eq_rem_zero_nonuw(
; CHECK-NEXT:    [[A:%.*]] = mul i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B:%.*]] = icmp eq i8 [[A]], 20
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul i8 %x, 5
  %b = icmp eq i8 %a, 20
  ret i1 %b
}

define i1 @ne_rem_zero_nonuw(i8 %x) {
; CHECK-LABEL: @ne_rem_zero_nonuw(
; CHECK-NEXT:    [[A:%.*]] = mul i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B:%.*]] = icmp ne i8 [[A]], 30
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul i8 %x, 5
  %b = icmp ne i8 %a, 30
  ret i1 %b
}
