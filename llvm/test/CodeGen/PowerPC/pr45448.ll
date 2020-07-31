; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s
define hidden void @julia_tryparse_internal_45896() #0 {
; CHECK-LABEL: julia_tryparse_internal_45896:
; CHECK:       # %bb.0: # %top
; CHECK-NEXT:    ld r3, 0(r3)
; CHECK-NEXT:    cmpldi r3, 0
; CHECK-NEXT:    beq cr0, .LBB0_3
; CHECK-NEXT:  # %bb.1: # %top
; CHECK-NEXT:    cmpldi r3, 10
; CHECK-NEXT:    beq cr0, .LBB0_4
; CHECK-NEXT:  # %bb.2: # %top
; CHECK-NEXT:  .LBB0_3: # %fail194
; CHECK-NEXT:  .LBB0_4: # %L294
; CHECK-NEXT:    bc 12, 4*cr5+lt, .LBB0_6
; CHECK-NEXT:  # %bb.5: # %L294
; CHECK-NEXT:    bc 4, 4*cr5+lt, .LBB0_7
; CHECK-NEXT:  .LBB0_6: # %L1057.preheader
; CHECK-NEXT:  .LBB0_7: # %L670
; CHECK-NEXT:    lis r5, 4095
; CHECK-NEXT:    cmpdi r3, 0
; CHECK-NEXT:    sradi r4, r3, 63
; CHECK-NEXT:    ori r5, r5, 65533
; CHECK-NEXT:    crnot 4*cr5+gt, eq
; CHECK-NEXT:    sldi r5, r5, 4
; CHECK-NEXT:    mulhdu r3, r3, r5
; CHECK-NEXT:    maddld r6, r4, r5, r3
; CHECK-NEXT:    cmpld r6, r3
; CHECK-NEXT:    mulld r3, r4, r5
; CHECK-NEXT:    cmpldi cr1, r3, 0
; CHECK-NEXT:    crandc 4*cr5+lt, lt, 4*cr1+eq
; CHECK-NEXT:    mulhdu. r3, r4, r5
; CHECK-NEXT:    bc 4, 4*cr5+gt, .LBB0_10
; CHECK-NEXT:  # %bb.8: # %L670
; CHECK-NEXT:    crorc 4*cr5+lt, 4*cr5+lt, eq
; CHECK-NEXT:    bc 4, 4*cr5+lt, .LBB0_10
; CHECK-NEXT:  # %bb.9: # %L917
; CHECK-NEXT:  .LBB0_10: # %L994
top:
  %0 = load i64, i64* undef, align 8
  %1 = icmp ne i64 %0, 0
  %2 = sext i64 %0 to i128
  switch i64 %0, label %pass195 [
    i64 10, label %L294
    i64 16, label %L294.fold.split
    i64 0, label %fail194
  ]

L294.fold.split:                                  ; preds = %top
  unreachable

L294:                                             ; preds = %top
  %3 = add nsw i32 0, -48
  %4 = zext i32 %3 to i128
  %5 = add i128 %4, 0
  switch i32 undef, label %L670 [
    i32 -1031471104, label %L1057.preheader
    i32 536870912, label %L1057.preheader
  ]

L670:                                             ; preds = %L294
  br label %L898

L1057.preheader:                                  ; preds = %L294, %L294
  unreachable

L898:                                             ; preds = %L670
  %umul = call { i128, i1 } @llvm.umul.with.overflow.i128(i128 %2, i128 %5)
  %umul.ov = extractvalue { i128, i1 } %umul, 1
  %value_phi102 = and i1 %1, %umul.ov
  %6 = or i1 %value_phi102, false
  br i1 %6, label %L917, label %L994

L917:                                             ; preds = %L898
  unreachable

L994:                                             ; preds = %L898
  unreachable

fail194:                                          ; preds = %top
  unreachable

pass195:                                          ; preds = %top
  unreachable
}

; Function Attrs: nounwind readnone speculatable willreturn
declare { i128, i1 } @llvm.umul.with.overflow.i128(i128, i128) #1
