; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O0 \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s --check-prefix=CHECK-O0

; These test cases aims to test the builtins for the Power10 VSX vector
; instructions introduced in ISA 3.1.

declare i32 @llvm.ppc.vsx.xvtlsbb(<16 x i8>, i32)

define signext i32 @test_vec_test_lsbb_all_ones(<16 x i8> %vuca) {
; CHECK-LABEL: test_vec_test_lsbb_all_ones:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvtlsbb cr0, v2
; CHECK-NEXT:    mfocrf r3, 128
; CHECK-NEXT:    srwi r3, r3, 31
; CHECK-NEXT:    extsw r3, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: test_vec_test_lsbb_all_ones:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    xvtlsbb cr0, v2
; CHECK-O0-NEXT:    mfocrf r3, 128
; CHECK-O0-NEXT:    srwi r3, r3, 31
; CHECK-O0-NEXT:    extsw r3, r3
; CHECK-O0-NEXT:    blr
entry:
  %0 = tail call i32 @llvm.ppc.vsx.xvtlsbb(<16 x i8> %vuca, i32 1)
  ret i32 %0
}

define signext i32 @test_vec_test_lsbb_all_zeros(<16 x i8> %vuca) {
; CHECK-LABEL: test_vec_test_lsbb_all_zeros:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvtlsbb cr0, v2
; CHECK-NEXT:    mfocrf r3, 128
; CHECK-NEXT:    rlwinm r3, r3, 3, 31, 31
; CHECK-NEXT:    extsw r3, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: test_vec_test_lsbb_all_zeros:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    xvtlsbb cr0, v2
; CHECK-O0-NEXT:    mfocrf r3, 128
; CHECK-O0-NEXT:    rlwinm r3, r3, 3, 31, 31
; CHECK-O0-NEXT:    extsw r3, r3
; CHECK-O0-NEXT:    blr
entry:
  %0 = tail call i32 @llvm.ppc.vsx.xvtlsbb(<16 x i8> %vuca, i32 0)
  ret i32 %0
}

define void @vec_xst_trunc_sc(<1 x i128> %__vec, i64 %__offset, i8* nocapture %__ptr) {
; CHECK-LABEL: vec_xst_trunc_sc:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    stxvrbx v2, r6, r5
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xst_trunc_sc:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    li r3, 0
; CHECK-O0-NEXT:    vextubrx r3, r3, v2
; CHECK-O0-NEXT:    # kill: def $r3 killed $r3 killed $x3
; CHECK-O0-NEXT:    add r4, r6, r5
; CHECK-O0-NEXT:    stb r3, 0(r4)
; CHECK-O0-NEXT:    blr
entry:
  %0 = bitcast <1 x i128> %__vec to <16 x i8>
  %conv = extractelement <16 x i8> %0, i32 0
  %add.ptr = getelementptr inbounds i8, i8* %__ptr, i64 %__offset
  store i8 %conv, i8* %add.ptr, align 1
  ret void
}

define void @vec_xst_trunc_uc(<1 x i128> %__vec, i64 %__offset, i8* nocapture %__ptr) {
; CHECK-LABEL: vec_xst_trunc_uc:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    stxvrbx v2, r6, r5
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xst_trunc_uc:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    li r3, 0
; CHECK-O0-NEXT:    vextubrx r3, r3, v2
; CHECK-O0-NEXT:    # kill: def $r3 killed $r3 killed $x3
; CHECK-O0-NEXT:    add r4, r6, r5
; CHECK-O0-NEXT:    stb r3, 0(r4)
; CHECK-O0-NEXT:    blr
entry:
  %0 = bitcast <1 x i128> %__vec to <16 x i8>
  %conv = extractelement <16 x i8> %0, i32 0
  %add.ptr = getelementptr inbounds i8, i8* %__ptr, i64 %__offset
  store i8 %conv, i8* %add.ptr, align 1
  ret void
}

define void @vec_xst_trunc_ss(<1 x i128> %__vec, i64 %__offset, i16* nocapture %__ptr) {
; CHECK-LABEL: vec_xst_trunc_ss:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r3, r5, 1
; CHECK-NEXT:    stxvrhx v2, r6, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xst_trunc_ss:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    li r3, 0
; CHECK-O0-NEXT:    vextuhrx r3, r3, v2
; CHECK-O0-NEXT:    # kill: def $r3 killed $r3 killed $x3
; CHECK-O0-NEXT:    sldi r4, r5, 1
; CHECK-O0-NEXT:    add r4, r6, r4
; CHECK-O0-NEXT:    sth r3, 0(r4)
; CHECK-O0-NEXT:    blr
entry:
  %0 = bitcast <1 x i128> %__vec to <8 x i16>
  %conv = extractelement <8 x i16> %0, i32 0
  %add.ptr = getelementptr inbounds i16, i16* %__ptr, i64 %__offset
  store i16 %conv, i16* %add.ptr, align 2
  ret void
}

define void @vec_xst_trunc_us(<1 x i128> %__vec, i64 %__offset, i16* nocapture %__ptr) {
; CHECK-LABEL: vec_xst_trunc_us:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r3, r5, 1
; CHECK-NEXT:    stxvrhx v2, r6, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xst_trunc_us:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    li r3, 0
; CHECK-O0-NEXT:    vextuhrx r3, r3, v2
; CHECK-O0-NEXT:    # kill: def $r3 killed $r3 killed $x3
; CHECK-O0-NEXT:    sldi r4, r5, 1
; CHECK-O0-NEXT:    add r4, r6, r4
; CHECK-O0-NEXT:    sth r3, 0(r4)
; CHECK-O0-NEXT:    blr
entry:
  %0 = bitcast <1 x i128> %__vec to <8 x i16>
  %conv = extractelement <8 x i16> %0, i32 0
  %add.ptr = getelementptr inbounds i16, i16* %__ptr, i64 %__offset
  store i16 %conv, i16* %add.ptr, align 2
  ret void
}

define void @vec_xst_trunc_si(<1 x i128> %__vec, i64 %__offset, i32* nocapture %__ptr) {
; CHECK-LABEL: vec_xst_trunc_si:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r3, r5, 2
; CHECK-NEXT:    stxvrwx v2, r6, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xst_trunc_si:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    li r3, 0
; CHECK-O0-NEXT:    vextuwrx r3, r3, v2
; CHECK-O0-NEXT:    # kill: def $r3 killed $r3 killed $x3
; CHECK-O0-NEXT:    sldi r4, r5, 2
; CHECK-O0-NEXT:    add r4, r6, r4
; CHECK-O0-NEXT:    stw r3, 0(r4)
; CHECK-O0-NEXT:    blr
entry:
  %0 = bitcast <1 x i128> %__vec to <4 x i32>
  %conv = extractelement <4 x i32> %0, i32 0
  %add.ptr = getelementptr inbounds i32, i32* %__ptr, i64 %__offset
  store i32 %conv, i32* %add.ptr, align 4
  ret void
}

define void @vec_xst_trunc_ui(<1 x i128> %__vec, i64 %__offset, i32* nocapture %__ptr) {
; CHECK-LABEL: vec_xst_trunc_ui:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r3, r5, 2
; CHECK-NEXT:    stxvrwx v2, r6, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xst_trunc_ui:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    li r3, 0
; CHECK-O0-NEXT:    vextuwrx r3, r3, v2
; CHECK-O0-NEXT:    # kill: def $r3 killed $r3 killed $x3
; CHECK-O0-NEXT:    sldi r4, r5, 2
; CHECK-O0-NEXT:    add r4, r6, r4
; CHECK-O0-NEXT:    stw r3, 0(r4)
; CHECK-O0-NEXT:    blr
entry:
  %0 = bitcast <1 x i128> %__vec to <4 x i32>
  %conv = extractelement <4 x i32> %0, i32 0
  %add.ptr = getelementptr inbounds i32, i32* %__ptr, i64 %__offset
  store i32 %conv, i32* %add.ptr, align 4
  ret void
}

define void @vec_xst_trunc_sll(<1 x i128> %__vec, i64 %__offset, i64* nocapture %__ptr)  {
; CHECK-LABEL: vec_xst_trunc_sll:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r3, r5, 3
; CHECK-NEXT:    stxvrdx v2, r6, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xst_trunc_sll:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    mfvsrld r3, v2
; CHECK-O0-NEXT:    sldi r4, r5, 3
; CHECK-O0-NEXT:    add r4, r6, r4
; CHECK-O0-NEXT:    std r3, 0(r4)
; CHECK-O0-NEXT:    blr
entry:
  %0 = bitcast <1 x i128> %__vec to <2 x i64>
  %conv = extractelement <2 x i64> %0, i32 0
  %add.ptr = getelementptr inbounds i64, i64* %__ptr, i64 %__offset
  store i64 %conv, i64* %add.ptr, align 8
  ret void
}

define void @vec_xst_trunc_ull(<1 x i128> %__vec, i64 %__offset, i64* nocapture %__ptr)  {
; CHECK-LABEL: vec_xst_trunc_ull:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r3, r5, 3
; CHECK-NEXT:    stxvrdx v2, r6, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xst_trunc_ull:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    mfvsrld r3, v2
; CHECK-O0-NEXT:    sldi r4, r5, 3
; CHECK-O0-NEXT:    add r4, r6, r4
; CHECK-O0-NEXT:    std r3, 0(r4)
; CHECK-O0-NEXT:    blr
entry:
  %0 = bitcast <1 x i128> %__vec to <2 x i64>
  %conv = extractelement <2 x i64> %0, i32 0
  %add.ptr = getelementptr inbounds i64, i64* %__ptr, i64 %__offset
  store i64 %conv, i64* %add.ptr, align 8
  ret void
}

define dso_local <1 x i128> @vec_xl_zext(i64 %__offset, i8* nocapture readonly %__pointer) {
; CHECK-LABEL: vec_xl_zext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxvrbx v2, r4, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xl_zext:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    lxvrbx vs0, r4, r3
; CHECK-O0-NEXT:    xxlor v2, vs0, vs0
; CHECK-O0-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i8, i8* %__pointer, i64 %__offset
  %0 = load i8, i8* %add.ptr, align 1
  %conv = zext i8 %0 to i128
  %splat.splatinsert = insertelement <1 x i128> undef, i128 %conv, i32 0
  ret <1 x i128> %splat.splatinsert
}

define dso_local <1 x i128> @vec_xl_zext_short(i64 %__offset, i16* nocapture readonly %__pointer) {
; CHECK-LABEL: vec_xl_zext_short:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r3, r3, 1
; CHECK-NEXT:    lxvrhx v2, r4, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xl_zext_short:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    sldi r3, r3, 1
; CHECK-O0-NEXT:    lxvrhx vs0, r4, r3
; CHECK-O0-NEXT:    xxlor v2, vs0, vs0
; CHECK-O0-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i16, i16* %__pointer, i64 %__offset
  %0 = load i16, i16* %add.ptr, align 2
  %conv = zext i16 %0 to i128
  %splat.splatinsert = insertelement <1 x i128> undef, i128 %conv, i32 0
  ret <1 x i128> %splat.splatinsert
}

define dso_local <1 x i128> @vec_xl_zext_word(i64 %__offset, i32* nocapture readonly %__pointer) {
; CHECK-LABEL: vec_xl_zext_word:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r3, r3, 2
; CHECK-NEXT:    lxvrwx v2, r4, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xl_zext_word:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    sldi r3, r3, 2
; CHECK-O0-NEXT:    lxvrwx vs0, r4, r3
; CHECK-O0-NEXT:    xxlor v2, vs0, vs0
; CHECK-O0-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i32, i32* %__pointer, i64 %__offset
  %0 = load i32, i32* %add.ptr, align 4
  %conv = zext i32 %0 to i128
  %splat.splatinsert = insertelement <1 x i128> undef, i128 %conv, i32 0
  ret <1 x i128> %splat.splatinsert
}

define dso_local <1 x i128> @vec_xl_zext_dw(i64 %__offset, i64* nocapture readonly %__pointer) {
; CHECK-LABEL: vec_xl_zext_dw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r3, r3, 3
; CHECK-NEXT:    lxvrdx v2, r4, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xl_zext_dw:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    sldi r3, r3, 3
; CHECK-O0-NEXT:    lxvrdx vs0, r4, r3
; CHECK-O0-NEXT:    xxlor v2, vs0, vs0
; CHECK-O0-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i64, i64* %__pointer, i64 %__offset
  %0 = load i64, i64* %add.ptr, align 8
  %conv = zext i64 %0 to i128
  %splat.splatinsert = insertelement <1 x i128> undef, i128 %conv, i32 0
  ret <1 x i128> %splat.splatinsert
}

define dso_local <1 x i128> @vec_xl_sext_b(i64 %offset, i8* %p) {
; CHECK-LABEL: vec_xl_sext_b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lbzx r3, r4, r3
; CHECK-NEXT:    extsb r3, r3
; CHECK-NEXT:    sradi r4, r3, 63
; CHECK-NEXT:    mtvsrdd v2, r4, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xl_sext_b:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    lbzx r3, r4, r3
; CHECK-O0-NEXT:    extsb r3, r3
; CHECK-O0-NEXT:    sradi r4, r3, 63
; CHECK-O0-NEXT:    mtvsrdd v2, r4, r3
; CHECK-O0-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i8, i8* %p, i64 %offset
  %0 = load i8, i8* %add.ptr, align 1
  %conv = sext i8 %0 to i128
  %splat.splatinsert = insertelement <1 x i128> undef, i128 %conv, i32 0
  ret <1 x i128> %splat.splatinsert
}

define dso_local <1 x i128> @vec_xl_sext_h(i64 %offset, i16* %p) {
; CHECK-LABEL: vec_xl_sext_h:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r3, r3, 1
; CHECK-NEXT:    lhax r3, r4, r3
; CHECK-NEXT:    sradi r4, r3, 63
; CHECK-NEXT:    mtvsrdd v2, r4, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xl_sext_h:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    sldi r3, r3, 1
; CHECK-O0-NEXT:    lhax r3, r4, r3
; CHECK-O0-NEXT:    sradi r4, r3, 63
; CHECK-O0-NEXT:    mtvsrdd v2, r4, r3
; CHECK-O0-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i16, i16* %p, i64 %offset
  %0 = load i16, i16* %add.ptr, align 2
  %conv = sext i16 %0 to i128
  %splat.splatinsert = insertelement <1 x i128> undef, i128 %conv, i32 0
  ret <1 x i128> %splat.splatinsert
}

define dso_local <1 x i128> @vec_xl_sext_w(i64 %offset, i32* %p) {
; CHECK-LABEL: vec_xl_sext_w:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r3, r3, 2
; CHECK-NEXT:    lwax r3, r4, r3
; CHECK-NEXT:    sradi r4, r3, 63
; CHECK-NEXT:    mtvsrdd v2, r4, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xl_sext_w:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    sldi r3, r3, 2
; CHECK-O0-NEXT:    lwax r3, r4, r3
; CHECK-O0-NEXT:    sradi r4, r3, 63
; CHECK-O0-NEXT:    mtvsrdd v2, r4, r3
; CHECK-O0-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i32, i32* %p, i64 %offset
  %0 = load i32, i32* %add.ptr, align 4
  %conv = sext i32 %0 to i128
  %splat.splatinsert = insertelement <1 x i128> undef, i128 %conv, i32 0
  ret <1 x i128> %splat.splatinsert
}

define dso_local <1 x i128> @vec_xl_sext_d(i64 %offset, i64* %p) {
; CHECK-LABEL: vec_xl_sext_d:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sldi r3, r3, 3
; CHECK-NEXT:    ldx r3, r4, r3
; CHECK-NEXT:    sradi r4, r3, 63
; CHECK-NEXT:    mtvsrdd v2, r4, r3
; CHECK-NEXT:    blr
;
; CHECK-O0-LABEL: vec_xl_sext_d:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    sldi r3, r3, 3
; CHECK-O0-NEXT:    ldx r3, r4, r3
; CHECK-O0-NEXT:    sradi r4, r3, 63
; CHECK-O0-NEXT:    mtvsrdd v2, r4, r3
; CHECK-O0-NEXT:    blr
entry:
  %add.ptr = getelementptr inbounds i64, i64* %p, i64 %offset
  %0 = load i64, i64* %add.ptr, align 8
  %conv = sext i64 %0 to i128
  %splat.splatinsert = insertelement <1 x i128> undef, i128 %conv, i32 0
  ret <1 x i128> %splat.splatinsert
}
