; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
; PR2498

; This test tries to convince CHECK about promoting the load from %A + 2,
; because there is a load of %A in the entry block
define internal i32 @callee(i1 %C, i32* %A) {
;
; IS__TUNIT____: Function Attrs: argmemonly nofree nosync nounwind readonly willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@callee
; IS__TUNIT____-SAME: (i32* nocapture nofree nonnull readonly align 4 dereferenceable(4) [[A:%.*]])
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[A_0:%.*]] = load i32, i32* [[A]], align 4
; IS__TUNIT____-NEXT:    br label [[F:%.*]]
; IS__TUNIT____:       T:
; IS__TUNIT____-NEXT:    unreachable
; IS__TUNIT____:       F:
; IS__TUNIT____-NEXT:    [[A_2:%.*]] = getelementptr i32, i32* [[A]], i32 2
; IS__TUNIT____-NEXT:    [[R:%.*]] = load i32, i32* [[A_2]], align 4
; IS__TUNIT____-NEXT:    ret i32 [[R]]
;
; IS__CGSCC____: Function Attrs: argmemonly nofree norecurse nosync nounwind readonly willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@callee
; IS__CGSCC____-SAME: (i32* nocapture nofree nonnull readonly align 4 dereferenceable(4) [[A:%.*]])
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[A_0:%.*]] = load i32, i32* [[A]], align 4
; IS__CGSCC____-NEXT:    br label [[F:%.*]]
; IS__CGSCC____:       T:
; IS__CGSCC____-NEXT:    unreachable
; IS__CGSCC____:       F:
; IS__CGSCC____-NEXT:    [[A_2:%.*]] = getelementptr i32, i32* [[A]], i32 2
; IS__CGSCC____-NEXT:    [[R:%.*]] = load i32, i32* [[A_2]], align 4
; IS__CGSCC____-NEXT:    ret i32 [[R]]
;
entry:
  ; Unconditonally load the element at %A
  %A.0 = load i32, i32* %A
  br i1 %C, label %T, label %F

T:
  ret i32 %A.0

F:
  ; Load the element at offset two from %A. This should not be promoted!
  %A.2 = getelementptr i32, i32* %A, i32 2
  %R = load i32, i32* %A.2
  ret i32 %R
}

define i32 @foo(i32* %A) {
; IS__TUNIT____: Function Attrs: argmemonly nofree nosync nounwind readonly willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@foo
; IS__TUNIT____-SAME: (i32* nocapture nofree readonly [[A:%.*]])
; IS__TUNIT____-NEXT:    [[X:%.*]] = call i32 @callee(i32* nocapture nofree readonly align 4 [[A]])
; IS__TUNIT____-NEXT:    ret i32 [[X]]
;
; IS__CGSCC____: Function Attrs: argmemonly nofree norecurse nosync nounwind readonly willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@foo
; IS__CGSCC____-SAME: (i32* nocapture nofree nonnull readonly align 4 dereferenceable(4) [[A:%.*]])
; IS__CGSCC____-NEXT:    [[X:%.*]] = call i32 @callee(i32* nocapture nofree nonnull readonly align 4 dereferenceable(4) [[A]])
; IS__CGSCC____-NEXT:    ret i32 [[X]]
;
  %X = call i32 @callee(i1 false, i32* %A)             ; <i32> [#uses=1]
  ret i32 %X
}

