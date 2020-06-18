; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -dce -S --enable-knowledge-retention < %s | FileCheck %s

define void @test(i32* %P) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(i32* [[P:%.*]], i64 4), "nonnull"(i32* [[P]]), "align"(i32* [[P]], i64 4) ]
; CHECK-NEXT:    ret void
;
  %a = load i32, i32* %P
  ret void
}
