; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

; Check that we don't create two redundant phi nodes when %val is used in a
; form where we can't rewrite it in terms of the new phi node.

; Use %val in an instruction type not supported by optimizeBitCastFromPhi.
define float @sitofp(float %x) {
; CHECK-LABEL: @sitofp(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop_header:
; CHECK-NEXT:    [[TMP0:%.*]] = phi float [ 0.000000e+00, [[ENTRY:%.*]] ], [ [[VAL_INCR:%.*]], [[LOOP:%.*]] ]
; CHECK-NEXT:    [[VAL:%.*]] = phi float [ 0.000000e+00, [[ENTRY]] ], [ [[PHITMP:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt float [[TMP0]], [[X:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[LOOP]]
; CHECK:       loop:
; CHECK-NEXT:    [[VAL_INCR]] = fadd float [[TMP0]], 1.000000e+00
; CHECK-NEXT:    [[VAL_INCR_CASTED:%.*]] = bitcast float [[VAL_INCR]] to i32
; CHECK-NEXT:    [[PHITMP]] = sitofp i32 [[VAL_INCR_CASTED]] to float
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       end:
; CHECK-NEXT:    ret float [[VAL]]
;
entry:
  br label %loop_header
loop_header:
  %val = phi i32 [ 0, %entry ], [ %val_incr_casted, %loop ]
  %val_casted = bitcast i32 %val to float
  %cmp = fcmp ogt float %val_casted, %x
  br i1 %cmp, label %end, label %loop
loop:
  %val_incr = fadd float %val_casted, 1.0
  %val_incr_casted = bitcast float %val_incr to i32
  br label %loop_header
end:
  %result = sitofp i32 %val to float
  ret float %result
}

; Use %val in an incompatible bitcast.
define <2 x i16> @bitcast(float %x) {
; CHECK-LABEL: @bitcast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop_header:
; CHECK-NEXT:    [[TMP0:%.*]] = phi float [ 0.000000e+00, [[ENTRY:%.*]] ], [ [[VAL_INCR:%.*]], [[LOOP:%.*]] ]
; CHECK-NEXT:    [[VAL:%.*]] = phi <2 x i16> [ zeroinitializer, [[ENTRY]] ], [ [[PHITMP:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt float [[TMP0]], [[X:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[LOOP]]
; CHECK:       loop:
; CHECK-NEXT:    [[VAL_INCR]] = fadd float [[TMP0]], 1.000000e+00
; CHECK-NEXT:    [[PHITMP]] = bitcast float [[VAL_INCR]] to <2 x i16>
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       end:
; CHECK-NEXT:    ret <2 x i16> [[VAL]]
;
entry:
  br label %loop_header
loop_header:
  %val = phi i32 [ 0, %entry ], [ %val_incr_casted, %loop ]
  %val_casted = bitcast i32 %val to float
  %cmp = fcmp ogt float %val_casted, %x
  br i1 %cmp, label %end, label %loop
loop:
  %val_incr = fadd float %val_casted, 1.0
  %val_incr_casted = bitcast float %val_incr to i32
  br label %loop_header
end:
  %result = bitcast i32 %val to <2 x i16>
  ret <2 x i16> %result
}

@global = global i32 0

; Use %val with a volatile store.
define void @store_volatile(float %x) {
; CHECK-LABEL: @store_volatile(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop_header:
; CHECK-NEXT:    [[TMP0:%.*]] = phi float [ 0.000000e+00, [[ENTRY:%.*]] ], [ [[VAL_INCR:%.*]], [[LOOP:%.*]] ]
; CHECK-NEXT:    [[VAL:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[VAL_INCR_CASTED:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt float [[TMP0]], [[X:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[LOOP]]
; CHECK:       loop:
; CHECK-NEXT:    [[VAL_INCR]] = fadd float [[TMP0]], 1.000000e+00
; CHECK-NEXT:    [[VAL_INCR_CASTED]] = bitcast float [[VAL_INCR]] to i32
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       end:
; CHECK-NEXT:    store volatile i32 [[VAL]], i32* @global, align 4
; CHECK-NEXT:    ret void
;
entry:
  br label %loop_header
loop_header:
  %val = phi i32 [ 0, %entry ], [ %val_incr_casted, %loop ]
  %val_casted = bitcast i32 %val to float
  %cmp = fcmp ogt float %val_casted, %x
  br i1 %cmp, label %end, label %loop
loop:
  %val_incr = fadd float %val_casted, 1.0
  %val_incr_casted = bitcast float %val_incr to i32
  br label %loop_header
end:
  store volatile i32 %val, i32* @global
  ret void
}

; Use %val with a store where it's actually the address.
define void @store_address(i32 %x) {
; CHECK-LABEL: @store_address(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop_header:
; CHECK-NEXT:    [[TMP0:%.*]] = phi float* [ bitcast (i32* @global to float*), [[ENTRY:%.*]] ], [ [[VAL_INCR:%.*]], [[LOOP:%.*]] ]
; CHECK-NEXT:    [[VAL:%.*]] = phi i32* [ @global, [[ENTRY]] ], [ [[VAL_INCR_CASTED:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[X:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[LOOP]]
; CHECK:       loop:
; CHECK-NEXT:    [[VAL_INCR]] = getelementptr float, float* [[TMP0]], i64 1
; CHECK-NEXT:    [[VAL_INCR_CASTED]] = bitcast float* [[VAL_INCR]] to i32*
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       end:
; CHECK-NEXT:    store i32 0, i32* [[VAL]], align 4
; CHECK-NEXT:    ret void
;
entry:
  br label %loop_header
loop_header:
  %val = phi i32* [ @global, %entry ], [ %val_incr_casted, %loop ]
  %i = phi i32 [ 0, %entry ], [ %i_incr, %loop ]
  %val_casted = bitcast i32* %val to float*
  %cmp = icmp sgt i32 %i, %x
  br i1 %cmp, label %end, label %loop
loop:
  %i_incr = add i32 %i, 0
  %val_incr = getelementptr float, float* %val_casted, i32 1
  %val_incr_casted = bitcast float* %val_incr to i32*
  br label %loop_header
end:
  store i32 0, i32* %val
  ret void
}

; Test where a phi (%val2) other than the original one (%val) has an
; incompatible use.
define i32 @multiple_phis(float %x) {
; CHECK-LABEL: @multiple_phis(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop_header:
; CHECK-NEXT:    [[TMP0:%.*]] = phi float [ 0.000000e+00, [[ENTRY:%.*]] ], [ [[TMP1:%.*]], [[LOOP_END:%.*]] ]
; CHECK-NEXT:    [[VAL:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[VAL2:%.*]], [[LOOP_END]] ]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt float [[TMP0]], [[X:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[CMP2:%.*]] = fcmp ogt float [[TMP0]], 2.000000e+00
; CHECK-NEXT:    br i1 [[CMP2]], label [[IF:%.*]], label [[LOOP_END]]
; CHECK:       if:
; CHECK-NEXT:    [[VAL_INCR:%.*]] = fadd float [[TMP0]], 1.000000e+00
; CHECK-NEXT:    [[VAL_INCR_CASTED:%.*]] = bitcast float [[VAL_INCR]] to i32
; CHECK-NEXT:    br label [[LOOP_END]]
; CHECK:       loop_end:
; CHECK-NEXT:    [[TMP1]] = phi float [ [[TMP0]], [[LOOP]] ], [ [[VAL_INCR]], [[IF]] ]
; CHECK-NEXT:    [[VAL2]] = phi i32 [ [[VAL]], [[LOOP]] ], [ [[VAL_INCR_CASTED]], [[IF]] ]
; CHECK-NEXT:    store volatile i32 [[VAL2]], i32* @global, align 4
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       end:
; CHECK-NEXT:    ret i32 [[VAL]]
;
entry:
  br label %loop_header
loop_header:
  %val = phi i32 [ 0, %entry ], [ %val2, %loop_end ]
  %val_casted = bitcast i32 %val to float
  %cmp = fcmp ogt float %val_casted, %x
  br i1 %cmp, label %end, label %loop
loop:
  %cmp2 = fcmp ogt float %val_casted, 2.0
  br i1 %cmp2, label %if, label %loop_end
if:
  %val_incr = fadd float %val_casted, 1.0
  %val_incr_casted = bitcast float %val_incr to i32
  br label %loop_end
loop_end:
  %val2 = phi i32 [ %val, %loop ], [ %val_incr_casted, %if ]
  store volatile i32 %val2, i32* @global ; the incompatible use
  br label %loop_header
end:
  ret i32 %val
}
