; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -loop-interchange -verify-dom-info -verify-loop-info -verify-scev -verify-loop-lcssa -S | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@A = common global [100 x [100 x i64]] zeroinitializer
@B = common global [100 x i64] zeroinitializer

;;  for(int i=0;i<100;i++)
;;    for(int j=0;j<100;j++)
;;      A[j][i] = A[j][i]+k;

define void @interchange_01(i64 %k, i64 %N) {
; CHECK-LABEL: @interchange_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR2_PREHEADER:%.*]]
; CHECK:       for1.header.preheader:
; CHECK-NEXT:    br label [[FOR1_HEADER:%.*]]
; CHECK:       for1.header:
; CHECK-NEXT:    [[J23:%.*]] = phi i64 [ [[J_NEXT24:%.*]], [[FOR1_INC10:%.*]] ], [ 0, [[FOR1_HEADER_PREHEADER:%.*]] ]
; CHECK-NEXT:    br label [[FOR2_SPLIT1:%.*]]
; CHECK:       for2.preheader:
; CHECK-NEXT:    br label [[FOR2:%.*]]
; CHECK:       for2:
; CHECK-NEXT:    [[J:%.*]] = phi i64 [ [[TMP0:%.*]], [[FOR2_SPLIT:%.*]] ], [ 0, [[FOR2_PREHEADER]] ]
; CHECK-NEXT:    br label [[FOR1_HEADER_PREHEADER]]
; CHECK:       for2.split1:
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds [100 x [100 x i64]], [100 x [100 x i64]]* @A, i64 0, i64 [[J]], i64 [[J23]]
; CHECK-NEXT:    [[LV:%.*]] = load i64, i64* [[ARRAYIDX5]]
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[LV]], [[K:%.*]]
; CHECK-NEXT:    store i64 [[ADD]], i64* [[ARRAYIDX5]]
; CHECK-NEXT:    [[J_NEXT:%.*]] = add nuw nsw i64 [[J]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[J]], 99
; CHECK-NEXT:    br label [[FOR1_INC10]]
; CHECK:       for2.split:
; CHECK-NEXT:    [[TMP0]] = add nuw nsw i64 [[J]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i64 [[J]], 99
; CHECK-NEXT:    br i1 [[TMP1]], label [[FOR_END12:%.*]], label [[FOR2]]
; CHECK:       for1.inc10:
; CHECK-NEXT:    [[J_NEXT24]] = add nuw nsw i64 [[J23]], 1
; CHECK-NEXT:    [[EXITCOND26:%.*]] = icmp eq i64 [[J23]], 99
; CHECK-NEXT:    br i1 [[EXITCOND26]], label [[FOR2_SPLIT]], label [[FOR1_HEADER]]
; CHECK:       for.end12:
; CHECK-NEXT:    ret void
;
entry:
  br label %for1.header

for1.header:
  %j23 = phi i64 [ 0, %entry ], [ %j.next24, %for1.inc10 ]
  br label %for2

for2:
  %j = phi i64 [ %j.next, %for2 ], [ 0, %for1.header ]
  %arrayidx5 = getelementptr inbounds [100 x [100 x i64]], [100 x [100 x i64]]* @A, i64 0, i64 %j, i64 %j23
  %lv = load i64, i64* %arrayidx5
  %add = add nsw i64 %lv, %k
  store i64 %add, i64* %arrayidx5
  %j.next = add nuw nsw i64 %j, 1
  %exitcond = icmp eq i64 %j, 99
  br i1 %exitcond, label %for1.inc10, label %for2

for1.inc10:
  %j.next24 = add nuw nsw i64 %j23, 1
  %exitcond26 = icmp eq i64 %j23, 99
  br i1 %exitcond26, label %for.end12, label %for1.header

for.end12:
  ret void
}

;; for(int i=0;i<100;i++)
;;   for(int j=100;j>=0;j--)
;;     A[j][i] = A[j][i]+k;

define void @interchange_02(i64 %k) {
; CHECK-LABEL: @interchange_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR3_PREHEADER:%.*]]
; CHECK:       for1.header.preheader:
; CHECK-NEXT:    br label [[FOR1_HEADER:%.*]]
; CHECK:       for1.header:
; CHECK-NEXT:    [[J19:%.*]] = phi i64 [ [[J_NEXT20:%.*]], [[FOR1_INC10:%.*]] ], [ 0, [[FOR1_HEADER_PREHEADER:%.*]] ]
; CHECK-NEXT:    br label [[FOR3_SPLIT1:%.*]]
; CHECK:       for3.preheader:
; CHECK-NEXT:    br label [[FOR3:%.*]]
; CHECK:       for3:
; CHECK-NEXT:    [[J:%.*]] = phi i64 [ [[TMP1:%.*]], [[FOR3_SPLIT:%.*]] ], [ 100, [[FOR3_PREHEADER]] ]
; CHECK-NEXT:    br label [[FOR1_HEADER_PREHEADER]]
; CHECK:       for3.split1:
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds [100 x [100 x i64]], [100 x [100 x i64]]* @A, i64 0, i64 [[J]], i64 [[J19]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i64, i64* [[ARRAYIDX5]]
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[TMP0]], [[K:%.*]]
; CHECK-NEXT:    store i64 [[ADD]], i64* [[ARRAYIDX5]]
; CHECK-NEXT:    [[J_NEXT:%.*]] = add nsw i64 [[J]], -1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i64 [[J]], 0
; CHECK-NEXT:    br label [[FOR1_INC10]]
; CHECK:       for3.split:
; CHECK-NEXT:    [[TMP1]] = add nsw i64 [[J]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp sgt i64 [[J]], 0
; CHECK-NEXT:    br i1 [[TMP2]], label [[FOR3]], label [[FOR_END11:%.*]]
; CHECK:       for1.inc10:
; CHECK-NEXT:    [[J_NEXT20]] = add nuw nsw i64 [[J19]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[J_NEXT20]], 100
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR3_SPLIT]], label [[FOR1_HEADER]]
; CHECK:       for.end11:
; CHECK-NEXT:    ret void
;
entry:
  br label %for1.header

for1.header:
  %j19 = phi i64 [ 0, %entry ], [ %j.next20, %for1.inc10 ]
  br label %for3

for3:
  %j = phi i64 [ 100, %for1.header ], [ %j.next, %for3 ]
  %arrayidx5 = getelementptr inbounds [100 x [100 x i64]], [100 x [100 x i64]]* @A, i64 0, i64 %j, i64 %j19
  %0 = load i64, i64* %arrayidx5
  %add = add nsw i64 %0, %k
  store i64 %add, i64* %arrayidx5
  %j.next = add nsw i64 %j, -1
  %cmp2 = icmp sgt i64 %j, 0
  br i1 %cmp2, label %for3, label %for1.inc10

for1.inc10:
  %j.next20 = add nuw nsw i64 %j19, 1
  %exitcond = icmp eq i64 %j.next20, 100
  br i1 %exitcond, label %for.end11, label %for1.header

for.end11:
  ret void
}

;; Test to make sure we can handle output dependencies.
;;
;;  for (int i = 1; i < 100; ++i)
;;    for(int j = 1; j < 99; ++j) {
;;      A[j][i] = i;
;;      A[j][i+1] = j;
;;    }
;; FIXME: DA misses this case after D35430

define void @interchange_10() {
; CHECK-LABEL: @interchange_10(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR1_HEADER:%.*]]
; CHECK:       for1.header:
; CHECK-NEXT:    [[J23:%.*]] = phi i64 [ 1, [[ENTRY:%.*]] ], [ [[J_NEXT24:%.*]], [[FOR1_INC10:%.*]] ]
; CHECK-NEXT:    [[J_NEXT24]] = add nuw nsw i64 [[J23]], 1
; CHECK-NEXT:    br label [[FOR2:%.*]]
; CHECK:       for2:
; CHECK-NEXT:    [[J:%.*]] = phi i64 [ [[J_NEXT:%.*]], [[FOR2]] ], [ 1, [[FOR1_HEADER]] ]
; CHECK-NEXT:    [[J_NEXT]] = add nuw nsw i64 [[J]], 1
; CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds [100 x [100 x i64]], [100 x [100 x i64]]* @A, i64 0, i64 [[J]], i64 [[J23]]
; CHECK-NEXT:    store i64 [[J]], i64* [[ARRAYIDX5]]
; CHECK-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds [100 x [100 x i64]], [100 x [100 x i64]]* @A, i64 0, i64 [[J]], i64 [[J_NEXT24]]
; CHECK-NEXT:    store i64 [[J23]], i64* [[ARRAYIDX10]]
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[J]], 99
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR1_INC10]], label [[FOR2]]
; CHECK:       for1.inc10:
; CHECK-NEXT:    [[EXITCOND26:%.*]] = icmp eq i64 [[J23]], 98
; CHECK-NEXT:    br i1 [[EXITCOND26]], label [[FOR_END12:%.*]], label [[FOR1_HEADER]]
; CHECK:       for.end12:
; CHECK-NEXT:    ret void
;
entry:
  br label %for1.header

for1.header:
  %j23 = phi i64 [ 1, %entry ], [ %j.next24, %for1.inc10 ]
  %j.next24 = add nuw nsw i64 %j23, 1
  br label %for2

for2:
  %j = phi i64 [ %j.next, %for2 ], [ 1, %for1.header ]
  %j.next = add nuw nsw i64 %j, 1
  %arrayidx5 = getelementptr inbounds [100 x [100 x i64]], [100 x [100 x i64]]* @A, i64 0, i64 %j, i64 %j23
  store i64 %j, i64* %arrayidx5
  %arrayidx10 = getelementptr inbounds [100 x [100 x i64]], [100 x [100 x i64]]* @A, i64 0, i64 %j, i64 %j.next24
  store i64 %j23, i64* %arrayidx10
  %exitcond = icmp eq i64 %j, 99
  br i1 %exitcond, label %for1.inc10, label %for2

for1.inc10:
  %exitcond26 = icmp eq i64 %j23, 98
  br i1 %exitcond26, label %for.end12, label %for1.header

for.end12:
  ret void

}
