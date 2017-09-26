; XFAIL: *
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl
; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py

@glob = common local_unnamed_addr global i64 0, align 8

define i64 @test_llneull(i64 %a, i64 %b) {
; CHECK-LABEL: test_llneull:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    xor r3, r3, r4
; CHECK-NEXT:    addic r4, r3, -1
; CHECK-NEXT:    subfe r3, r4, r3
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i64 %a, %b
  %conv1 = zext i1 %cmp to i64
  ret i64 %conv1
}

define i64 @test_llneull_sext(i64 %a, i64 %b) {
; CHECK-LABEL: test_llneull_sext:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    xor r3, r3, r4
; CHECK-NEXT:    subfic r3, r3, 0
; CHECK-NEXT:    subfe r3, r3, r3
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

define i64 @test_llneull_z(i64 %a) {
; CHECK-LABEL: test_llneull_z:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    addic r4, r3, -1
; CHECK-NEXT:    subfe r3, r4, r3
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i64 %a, 0
  %conv1 = zext i1 %cmp to i64
  ret i64 %conv1
}

define i64 @test_llneull_sext_z(i64 %a) {
; CHECK-LABEL: test_llneull_sext_z:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    subfic r3, r3, 0
; CHECK-NEXT:    subfe r3, r3, r3
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i64 %a, 0
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

define void @test_llneull_store(i64 %a, i64 %b) {
; CHECK-LABEL: test_llneull_store:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    addis r5, r2, .LC0@toc@ha
; CHECK-NEXT:    xor r3, r3, r4
; CHECK-NEXT:    ld r12, .LC0@toc@l(r5)
; CHECK-NEXT:    addic r5, r3, -1
; CHECK-NEXT:    subfe r3, r5, r3
; CHECK-NEXT:    std r3, 0(r12)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i64 %a, %b
  %conv1 = zext i1 %cmp to i64
  store i64 %conv1, i64* @glob, align 8
  ret void
}

define void @test_llneull_sext_store(i64 %a, i64 %b) {
; CHECK-LABEL: test_llneull_sext_store:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    addis r5, r2, .LC0@toc@ha
; CHECK-NEXT:    xor r3, r3, r4
; CHECK-NEXT:    ld r12, .LC0@toc@l(r5)
; CHECK-NEXT:    subfic r3, r3, 0
; CHECK-NEXT:    subfe r3, r3, r3
; CHECK-NEXT:    std r3, 0(r12)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @glob, align 8
  ret void
}

define void @test_llneull_z_store(i64 %a) {
; CHECK-LABEL: test_llneull_z_store:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    addis r4, r2, .LC0@toc@ha
; CHECK-NEXT:    addic r5, r3, -1
; CHECK-NEXT:    ld r4, .LC0@toc@l(r4)
; CHECK-NEXT:    subfe r3, r5, r3
; CHECK-NEXT:    std r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i64 %a, 0
  %conv1 = zext i1 %cmp to i64
  store i64 %conv1, i64* @glob, align 8
  ret void
}

define void @test_llneull_sext_z_store(i64 %a) {
; CHECK-LABEL: test_llneull_sext_z_store:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    addis r4, r2, .LC0@toc@ha
; CHECK-NEXT:    subfic r3, r3, 0
; CHECK-NEXT:    ld r4, .LC0@toc@l(r4)
; CHECK-NEXT:    subfe r3, r3, r3
; CHECK-NEXT:    std r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i64 %a, 0
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @glob, align 8
  ret void
}
