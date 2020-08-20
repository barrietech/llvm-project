; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=8 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=8 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

define internal i32 @callee(i1 %C, i32* %P) {
; IS__TUNIT_OPM: Function Attrs: argmemonly nofree nosync nounwind readonly willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@callee
; IS__TUNIT_OPM-SAME: (i1 [[C:%.*]], i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[P:%.*]])
; IS__TUNIT_OPM-NEXT:    br label [[F:%.*]]
; IS__TUNIT_OPM:       T:
; IS__TUNIT_OPM-NEXT:    unreachable
; IS__TUNIT_OPM:       F:
; IS__TUNIT_OPM-NEXT:    [[X:%.*]] = load i32, i32* [[P]], align 4
; IS__TUNIT_OPM-NEXT:    ret i32 [[X]]
;
; IS__TUNIT_NPM: Function Attrs: argmemonly nofree nosync nounwind readonly willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@callee
; IS__TUNIT_NPM-SAME: (i1 [[C:%.*]], i32 [[TMP0:%.*]])
; IS__TUNIT_NPM-NEXT:    [[P_PRIV:%.*]] = alloca i32, align 4
; IS__TUNIT_NPM-NEXT:    store i32 [[TMP0]], i32* [[P_PRIV]], align 4
; IS__TUNIT_NPM-NEXT:    br label [[F:%.*]]
; IS__TUNIT_NPM:       T:
; IS__TUNIT_NPM-NEXT:    unreachable
; IS__TUNIT_NPM:       F:
; IS__TUNIT_NPM-NEXT:    [[X:%.*]] = load i32, i32* [[P_PRIV]], align 4
; IS__TUNIT_NPM-NEXT:    ret i32 [[X]]
;
; IS__CGSCC____: Function Attrs: argmemonly nofree norecurse nosync nounwind readonly willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@callee
; IS__CGSCC____-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[P:%.*]])
; IS__CGSCC____-NEXT:    br label [[F:%.*]]
; IS__CGSCC____:       T:
; IS__CGSCC____-NEXT:    unreachable
; IS__CGSCC____:       F:
; IS__CGSCC____-NEXT:    [[X:%.*]] = load i32, i32* [[P]], align 4
; IS__CGSCC____-NEXT:    ret i32 [[X]]
;
  br i1 %C, label %T, label %F

T:              ; preds = %0
  ret i32 17

F:              ; preds = %0
  %X = load i32, i32* %P               ; <i32> [#uses=1]
  ret i32 %X
}

define i32 @foo() {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@foo()
; IS__TUNIT_OPM-NEXT:    [[A:%.*]] = alloca i32, align 4
; IS__TUNIT_OPM-NEXT:    store i32 17, i32* [[A]], align 4
; IS__TUNIT_OPM-NEXT:    [[X:%.*]] = call i32 @callee(i1 false, i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]])
; IS__TUNIT_OPM-NEXT:    ret i32 [[X]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@foo()
; IS__TUNIT_NPM-NEXT:    [[A:%.*]] = alloca i32, align 4
; IS__TUNIT_NPM-NEXT:    store i32 17, i32* [[A]], align 4
; IS__TUNIT_NPM-NEXT:    [[TMP1:%.*]] = load i32, i32* [[A]], align 4
; IS__TUNIT_NPM-NEXT:    [[X:%.*]] = call i32 @callee(i1 false, i32 [[TMP1]])
; IS__TUNIT_NPM-NEXT:    ret i32 [[X]]
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@foo()
; IS__CGSCC____-NEXT:    [[A:%.*]] = alloca i32, align 4
; IS__CGSCC____-NEXT:    store i32 17, i32* [[A]], align 4
; IS__CGSCC____-NEXT:    [[X:%.*]] = call i32 @callee(i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[A]])
; IS__CGSCC____-NEXT:    ret i32 [[X]]
;
  %A = alloca i32         ; <i32*> [#uses=2]
  store i32 17, i32* %A
  %X = call i32 @callee( i1 false, i32* %A )              ; <i32> [#uses=1]
  ret i32 %X
}

