; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=thumbv8m.main %s -simplifycfg -S | FileCheck %s
; RUN: opt -mtriple=thumbv8a %s -simplifycfg -S | FileCheck %s

define i32 @foo(i32 %a, i32 %b, i32 %c, i32 %d, i32* %input) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[D:%.*]], 3
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[C:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[ADD]], [[B:%.*]]
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[CMP]], [[CMP1]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[COND_FALSE:%.*]], label [[COND_END:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[INPUT:%.*]], align 4
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[TMP0]], [[COND_FALSE]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i32 [[COND]]
;
entry:
  %cmp = icmp sgt i32 %d, 3
  br i1 %cmp, label %cond.end, label %lor.lhs.false

lor.lhs.false:
  %add = add nsw i32 %c, %a
  %cmp1 = icmp slt i32 %add, %b
  br i1 %cmp1, label %cond.false, label %cond.end

cond.false:
  %0 = load i32, i32* %input, align 4
  br label %cond.end

cond.end:
  %cond = phi i32 [ %0, %cond.false ], [ 0, %lor.lhs.false ], [ 0, %entry ]
  ret i32 %cond
}

define i32 @foo_minsize(i32 %a, i32 %b, i32 %c, i32 %d, i32* %input) #0 {
; CHECK-LABEL: @foo_minsize(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[D:%.*]], 3
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[C:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[ADD]], [[B:%.*]]
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[CMP]], [[CMP1]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[COND_FALSE:%.*]], label [[COND_END:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[INPUT:%.*]], align 4
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[TMP0]], [[COND_FALSE]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i32 [[COND]]
;
entry:
  %cmp = icmp sgt i32 %d, 3
  br i1 %cmp, label %cond.end, label %lor.lhs.false

lor.lhs.false:
  %add = add nsw i32 %c, %a
  %cmp1 = icmp slt i32 %add, %b
  br i1 %cmp1, label %cond.false, label %cond.end

cond.false:
  %0 = load i32, i32* %input, align 4
  br label %cond.end

cond.end:
  %cond = phi i32 [ %0, %cond.false ], [ 0, %lor.lhs.false ], [ 0, %entry ]
  ret i32 %cond
}

define i32 @foo_minsize_i64(i64 %a, i64 %b, i64 %c, i64 %d, i32* %input) #0 {
; CHECK-LABEL: @foo_minsize_i64(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i64 [[D:%.*]], 3
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[C:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i64 [[ADD]], [[B:%.*]]
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[CMP]], [[CMP1]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[COND_FALSE:%.*]], label [[COND_END:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[INPUT:%.*]], align 4
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[TMP0]], [[COND_FALSE]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i32 [[COND]]
;
entry:
  %cmp = icmp sgt i64 %d, 3
  br i1 %cmp, label %cond.end, label %lor.lhs.false

lor.lhs.false:
  %add = add nsw i64 %c, %a
  %cmp1 = icmp slt i64 %add, %b
  br i1 %cmp1, label %cond.false, label %cond.end

cond.false:
  %0 = load i32, i32* %input, align 4
  br label %cond.end

cond.end:
  %cond = phi i32 [ %0, %cond.false ], [ 0, %lor.lhs.false ], [ 0, %entry ]
  ret i32 %cond
}

attributes #0 = { minsize optsize }
