; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S -data-layout="e-m:e-i64:64-f80:128-n8:16:32:64-S128" | FileCheck %s

@a = global [1000 x float] zeroinitializer, align 16
@b = global [1000 x float] zeroinitializer, align 16

define void @_Z3foov() {
; CHECK-LABEL: @_Z3foov(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[I_0]], 1000
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_COND_CLEANUP:%.*]]
; CHECK:       for.cond.cleanup:
; CHECK-NEXT:    ret void
; CHECK:       for.body:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[I_0]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [1000 x float], [1000 x float]* @a, i64 0, i64 [[TMP0]]
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds [1000 x float], [1000 x float]* @b, i64 0, i64 [[TMP0]]
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load float, float* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[CMP_I:%.*]] = fcmp fast olt float [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[__B___A_I:%.*]] = select i1 [[CMP_I]], float* [[ARRAYIDX2]], float* [[ARRAYIDX]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast float* [[__B___A_I]] to i32*
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, i32* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast float* [[ARRAYIDX]] to i32*
; CHECK-NEXT:    store i32 [[TMP4]], i32* [[TMP5]], align 4
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_0]], 1
; CHECK-NEXT:    br label [[FOR_COND]]
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp ult i32 %i.0, 1000
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  ret void

for.body:                                         ; preds = %for.cond
  %0 = zext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds [1000 x float], [1000 x float]* @a, i64 0, i64 %0
  %arrayidx2 = getelementptr inbounds [1000 x float], [1000 x float]* @b, i64 0, i64 %0
  %1 = load float, float* %arrayidx, align 4
  %2 = load float, float* %arrayidx2, align 4
  %cmp.i = fcmp fast olt float %1, %2
  %__b.__a.i = select i1 %cmp.i, float* %arrayidx2, float* %arrayidx
  %3 = bitcast float* %__b.__a.i to i32*
  %4 = load i32, i32* %3, align 4
  %5 = bitcast float* %arrayidx to i32*
  store i32 %4, i32* %5, align 4
  %inc = add nuw nsw i32 %i.0, 1
  br label %for.cond
}
