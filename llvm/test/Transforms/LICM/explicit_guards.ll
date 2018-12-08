; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -make-guards-explicit -basicaa -licm < %s        | FileCheck %s
; RUN: opt -S -aa-pipeline=basic-aa -passes='require<opt-remark-emit>,make-guards-explicit,loop(licm)' < %s | FileCheck %s

; Test interaction between explicit guards and LICM: make sure that we do not
; hoist explicit conditions while we can hoist invariant loads in presence of
; explicit guards.

declare void @llvm.experimental.guard(i1,...)

; Make sure that we do not hoist widenable_cond out of loop.
define void @do_not_hoist_widenable_cond(i1 %cond, i32 %N, i32 %M) {
; CHECK-LABEL: @do_not_hoist_widenable_cond(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[GUARDED:%.*]] ]
; CHECK-NEXT:    [[GUARD_COND:%.*]] = icmp slt i32 [[IV]], [[N:%.*]]
; CHECK-NEXT:    [[WIDENABLE_COND:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND:%.*]] = and i1 [[GUARD_COND]], [[WIDENABLE_COND]]
; CHECK-NEXT:    br i1 [[EXIPLICIT_GUARD_COND]], label [[GUARDED]], label [[DEOPT:%.*]], !prof !0
; CHECK:       deopt:
; CHECK-NEXT:    call void (...) @llvm.experimental.deoptimize.isVoid() [ "deopt"() ]
; CHECK-NEXT:    ret void
; CHECK:       guarded:
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp slt i32 [[IV]], [[M:%.*]]
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %loop ]
  %guard_cond = icmp slt i32 %iv, %N
  call void(i1, ...) @llvm.experimental.guard(i1 %guard_cond) [ "deopt"() ]
  %loop_cond = icmp slt i32 %iv, %M
  %iv.next = add i32 %iv, 1
  br i1 %loop_cond, label %loop, label %exit

exit:
  ret void
}

define void @hoist_invariant_load(i1 %cond, i32* %np, i32 %M) {
; CHECK-LABEL: @hoist_invariant_load(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[N:%.*]] = load i32, i32* [[NP:%.*]]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[GUARDED:%.*]] ]
; CHECK-NEXT:    [[GUARD_COND:%.*]] = icmp slt i32 [[IV]], [[N]]
; CHECK-NEXT:    [[WIDENABLE_COND:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXIPLICIT_GUARD_COND:%.*]] = and i1 [[GUARD_COND]], [[WIDENABLE_COND]]
; CHECK-NEXT:    br i1 [[EXIPLICIT_GUARD_COND]], label [[GUARDED]], label [[DEOPT:%.*]], !prof !0
; CHECK:       deopt:
; CHECK-NEXT:    call void (...) @llvm.experimental.deoptimize.isVoid() [ "deopt"() ]
; CHECK-NEXT:    ret void
; CHECK:       guarded:
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp slt i32 [[IV]], [[M:%.*]]
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %loop ]
  %N = load i32, i32* %np
  %guard_cond = icmp slt i32 %iv, %N
  call void(i1, ...) @llvm.experimental.guard(i1 %guard_cond) [ "deopt"() ]
  %loop_cond = icmp slt i32 %iv, %M
  %iv.next = add i32 %iv, 1
  br i1 %loop_cond, label %loop, label %exit

exit:
  ret void
}
