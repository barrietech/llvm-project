; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=aarch64 -global-isel %s -o - -stop-after=irtranslator | FileCheck %s

define i8* @test_simple_alloca(i32 %numelts) {
  ; CHECK-LABEL: name: test_simple_alloca
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w0
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 1
  ; CHECK:   [[ZEXT:%[0-9]+]]:_(s64) = G_ZEXT [[COPY]](s32)
  ; CHECK:   [[MUL:%[0-9]+]]:_(s64) = G_MUL [[ZEXT]], [[C]]
  ; CHECK:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 15
  ; CHECK:   [[ADD:%[0-9]+]]:_(s64) = nuw G_ADD [[MUL]], [[C1]]
  ; CHECK:   [[C2:%[0-9]+]]:_(s64) = G_CONSTANT i64 -16
  ; CHECK:   [[AND:%[0-9]+]]:_(s64) = G_AND [[ADD]], [[C2]]
  ; CHECK:   [[DYN_STACKALLOC:%[0-9]+]]:_(p0) = G_DYN_STACKALLOC [[AND]](s64), 0
  ; CHECK:   $x0 = COPY [[DYN_STACKALLOC]](p0)
  ; CHECK:   RET_ReallyLR implicit $x0
  %addr = alloca i8, i32 %numelts
  ret i8* %addr
}

define i8* @test_aligned_alloca(i32 %numelts) {
  ; CHECK-LABEL: name: test_aligned_alloca
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w0
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 1
  ; CHECK:   [[ZEXT:%[0-9]+]]:_(s64) = G_ZEXT [[COPY]](s32)
  ; CHECK:   [[MUL:%[0-9]+]]:_(s64) = G_MUL [[ZEXT]], [[C]]
  ; CHECK:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 15
  ; CHECK:   [[ADD:%[0-9]+]]:_(s64) = nuw G_ADD [[MUL]], [[C1]]
  ; CHECK:   [[C2:%[0-9]+]]:_(s64) = G_CONSTANT i64 -16
  ; CHECK:   [[AND:%[0-9]+]]:_(s64) = G_AND [[ADD]], [[C2]]
  ; CHECK:   [[DYN_STACKALLOC:%[0-9]+]]:_(p0) = G_DYN_STACKALLOC [[AND]](s64), 32
  ; CHECK:   $x0 = COPY [[DYN_STACKALLOC]](p0)
  ; CHECK:   RET_ReallyLR implicit $x0
  %addr = alloca i8, i32 %numelts, align 32
  ret i8* %addr
}

define i128* @test_natural_alloca(i32 %numelts) {
  ; CHECK-LABEL: name: test_natural_alloca
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w0
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 16
  ; CHECK:   [[ZEXT:%[0-9]+]]:_(s64) = G_ZEXT [[COPY]](s32)
  ; CHECK:   [[MUL:%[0-9]+]]:_(s64) = G_MUL [[ZEXT]], [[C]]
  ; CHECK:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 15
  ; CHECK:   [[ADD:%[0-9]+]]:_(s64) = nuw G_ADD [[MUL]], [[C1]]
  ; CHECK:   [[C2:%[0-9]+]]:_(s64) = G_CONSTANT i64 -16
  ; CHECK:   [[AND:%[0-9]+]]:_(s64) = G_AND [[ADD]], [[C2]]
  ; CHECK:   [[DYN_STACKALLOC:%[0-9]+]]:_(p0) = G_DYN_STACKALLOC [[AND]](s64), 0
  ; CHECK:   $x0 = COPY [[DYN_STACKALLOC]](p0)
  ; CHECK:   RET_ReallyLR implicit $x0
  %addr = alloca i128, i32 %numelts
  ret i128* %addr
}
