; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

;
; UNDEF Elts
;

define <8 x i16> @undef_packssdw_128() {
; CHECK-LABEL: @undef_packssdw_128(
; CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> undef, <4 x i32> undef)
; CHECK-NEXT:    ret <8 x i16> [[TMP1]]
;
  %1 = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> undef, <4 x i32> undef)
  ret <8 x i16> %1
}

define <8 x i16> @undef_packusdw_128() {
; CHECK-LABEL: @undef_packusdw_128(
; CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> undef, <4 x i32> undef)
; CHECK-NEXT:    ret <8 x i16> [[TMP1]]
;
  %1 = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> undef, <4 x i32> undef)
  ret <8 x i16> %1
}

define <16 x i8> @undef_packsswb_128() {
; CHECK-LABEL: @undef_packsswb_128(
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> undef, <8 x i16> undef)
; CHECK-NEXT:    ret <16 x i8> [[TMP1]]
;
  %1 = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> undef, <8 x i16> undef)
  ret <16 x i8> %1
}

define <16 x i8> @undef_packuswb_128() {
; CHECK-LABEL: @undef_packuswb_128(
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16> undef, <8 x i16> undef)
; CHECK-NEXT:    ret <16 x i8> [[TMP1]]
;
  %1 = call <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16> undef, <8 x i16> undef)
  ret <16 x i8> %1
}

define <16 x i16> @undef_packssdw_256() {
; CHECK-LABEL: @undef_packssdw_256(
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> undef, <8 x i32> undef)
; CHECK-NEXT:    ret <16 x i16> [[TMP1]]
;
  %1 = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> undef, <8 x i32> undef)
  ret <16 x i16> %1
}

define <16 x i16> @undef_packusdw_256() {
; CHECK-LABEL: @undef_packusdw_256(
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32> undef, <8 x i32> undef)
; CHECK-NEXT:    ret <16 x i16> [[TMP1]]
;
  %1 = call <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32> undef, <8 x i32> undef)
  ret <16 x i16> %1
}

define <32 x i8> @undef_packsswb_256() {
; CHECK-LABEL: @undef_packsswb_256(
; CHECK-NEXT:    [[TMP1:%.*]] = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> undef, <16 x i16> undef)
; CHECK-NEXT:    ret <32 x i8> [[TMP1]]
;
  %1 = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> undef, <16 x i16> undef)
  ret <32 x i8> %1
}

define <32 x i8> @undef_packuswb_256() {
; CHECK-LABEL: @undef_packuswb_256(
; CHECK-NEXT:    [[TMP1:%.*]] = call <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16> undef, <16 x i16> undef)
; CHECK-NEXT:    ret <32 x i8> [[TMP1]]
;
  %1 = call <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16> undef, <16 x i16> undef)
  ret <32 x i8> %1
}

;
; Constant Folding
;

define <8 x i16> @fold_packssdw_128() {
; CHECK-LABEL: @fold_packssdw_128(
; CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> <i32 0, i32 -1, i32 65536, i32 -131072>, <4 x i32> zeroinitializer)
; CHECK-NEXT:    ret <8 x i16> [[TMP1]]
;
  %1 = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> <i32 0, i32 -1, i32 65536, i32 -131072>, <4 x i32> zeroinitializer)
  ret <8 x i16> %1
}

define <8 x i16> @fold_packusdw_128() {
; CHECK-LABEL: @fold_packusdw_128(
; CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> undef, <4 x i32> <i32 0, i32 -1, i32 32768, i32 65537>)
; CHECK-NEXT:    ret <8 x i16> [[TMP1]]
;
  %1 = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> undef, <4 x i32> <i32 0, i32 -1, i32 32768, i32 65537>)
  ret <8 x i16> %1
}

define <16 x i8> @fold_packsswb_128() {
; CHECK-LABEL: @fold_packsswb_128(
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> zeroinitializer, <8 x i16> undef)
; CHECK-NEXT:    ret <16 x i8> [[TMP1]]
;
  %1 = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> zeroinitializer, <8 x i16> undef)
  ret <16 x i8> %1
}

define <16 x i8> @fold_packuswb_128() {
; CHECK-LABEL: @fold_packuswb_128(
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16> <i16 0, i16 1, i16 -1, i16 255, i16 -1, i16 -32768, i16 -127, i16 15>, <8 x i16> <i16 -15, i16 127, i16 -32768, i16 1, i16 -255, i16 1, i16 -1, i16 0>)
; CHECK-NEXT:    ret <16 x i8> [[TMP1]]
;
  %1 = call <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16> <i16 0, i16 1, i16 -1, i16 255, i16 65535, i16 -32768, i16 -127, i16 15>, <8 x i16> <i16 -15, i16 127, i16 32768, i16 -65535, i16 -255, i16 1, i16 -1, i16 0>)
  ret <16 x i8> %1
}

define <16 x i16> @fold_packssdw_256() {
; CHECK-LABEL: @fold_packssdw_256(
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> <i32 0, i32 256, i32 65535, i32 -65536, i32 -127, i32 -32768, i32 -32767, i32 32767>, <8 x i32> undef)
; CHECK-NEXT:    ret <16 x i16> [[TMP1]]
;
  %1 = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> <i32 0, i32 256, i32 65535, i32 -65536, i32 -127, i32 -32768, i32 -32767, i32 32767>, <8 x i32> undef)
  ret <16 x i16> %1
}

define <16 x i16> @fold_packusdw_256() {
; CHECK-LABEL: @fold_packusdw_256(
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32> <i32 0, i32 -256, i32 -65535, i32 65536, i32 127, i32 32768, i32 32767, i32 -32767>, <8 x i32> <i32 0, i32 256, i32 65535, i32 -65536, i32 -127, i32 -32768, i32 -32767, i32 32767>)
; CHECK-NEXT:    ret <16 x i16> [[TMP1]]
;
  %1 = call <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32> <i32 0, i32 -256, i32 -65535, i32 65536, i32 127, i32 32768, i32 32767, i32 -32767>, <8 x i32> <i32 0, i32 256, i32 65535, i32 -65536, i32 -127, i32 -32768, i32 -32767, i32 32767>)
  ret <16 x i16> %1
}

define <32 x i8> @fold_packsswb_256() {
; CHECK-LABEL: @fold_packsswb_256(
; CHECK-NEXT:    [[TMP1:%.*]] = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> undef, <16 x i16> zeroinitializer)
; CHECK-NEXT:    ret <32 x i8> [[TMP1]]
;
  %1 = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> undef, <16 x i16> zeroinitializer)
  ret <32 x i8> %1
}

define <32 x i8> @fold_packuswb_256() {
; CHECK-LABEL: @fold_packuswb_256(
; CHECK-NEXT:    [[TMP1:%.*]] = call <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16> zeroinitializer, <16 x i16> <i16 0, i16 -127, i16 -128, i16 -32768, i16 0, i16 255, i16 256, i16 512, i16 -1, i16 1, i16 2, i16 4, i16 8, i16 16, i16 32, i16 64>)
; CHECK-NEXT:    ret <32 x i8> [[TMP1]]
;
  %1 = call <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16> zeroinitializer, <16 x i16> <i16 0, i16 -127, i16 -128, i16 -32768, i16 65536, i16 255, i16 256, i16 512, i16 -1, i16 1, i16 2, i16 4, i16 8, i16 16, i16 32, i16 64>)
  ret <32 x i8> %1
}

;
; Demanded Elts
;

define <8 x i16> @elts_packssdw_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @elts_packssdw_128(
; CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> %a0, <4 x i32> undef)
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i16> [[TMP1]], <8 x i16> undef, <8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <8 x i16> [[TMP2]]
;
  %1 = shufflevector <4 x i32> %a0, <4 x i32> undef, <4 x i32> <i32 3, i32 1, i32 undef, i32 undef>
  %2 = shufflevector <4 x i32> %a1, <4 x i32> undef, <4 x i32> <i32 undef, i32 2, i32 1, i32 undef>
  %3 = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> %1, <4 x i32> %2)
  %4 = shufflevector <8 x i16> %3, <8 x i16> undef, <8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 7, i32 7, i32 7, i32 7>
  ret <8 x i16> %4
}

define <8 x i16> @elts_packusdw_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @elts_packusdw_128(
; CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> %a0, <4 x i32> %a1)
; CHECK-NEXT:    ret <8 x i16> [[TMP1]]
;
  %1 = insertelement <4 x i32> %a0, i32 0, i32 0
  %2 = insertelement <4 x i32> %a1, i32 0, i32 3
  %3 = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> %1, <4 x i32> %2)
  %4 = shufflevector <8 x i16> %3, <8 x i16> undef, <8 x i32> <i32 undef, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 undef>
  ret <8 x i16> %4
}

define <16 x i8> @elts_packsswb_128(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: @elts_packsswb_128(
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> <i16 0, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef>, <8 x i16> <i16 0, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef>)
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <16 x i8> [[TMP1]], <16 x i8> undef, <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8>
; CHECK-NEXT:    ret <16 x i8> [[TMP2]]
;
  %1 = insertelement <8 x i16> %a0, i16 0, i32 0
  %2 = insertelement <8 x i16> %a1, i16 0, i32 0
  %3 = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> %1, <8 x i16> %2)
  %4 = shufflevector <16 x i8> %3, <16 x i8> undef, <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8>
  ret <16 x i8> %4
}

define <16 x i8> @elts_packuswb_128(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: @elts_packuswb_128(
; CHECK-NEXT:    ret <16 x i8> undef
;
  %1 = insertelement <8 x i16> undef, i16 0, i32 0
  %2 = insertelement <8 x i16> undef, i16 0, i32 0
  %3 = call <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16> %1, <8 x i16> %2)
  %4 = shufflevector <16 x i8> %3, <16 x i8> undef, <16 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15>
  ret <16 x i8> %4
}

define <16 x i16> @elts_packssdw_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @elts_packssdw_256(
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> %a0, <8 x i32> undef)
; CHECK-NEXT:    ret <16 x i16> [[TMP1]]
;
  %1 = shufflevector <8 x i32> %a0, <8 x i32> undef, <8 x i32> <i32 1, i32 0, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %2 = shufflevector <8 x i32> %a1, <8 x i32> undef, <8 x i32> <i32 undef, i32 2, i32 1, i32 undef, i32 undef, i32 6, i32 5, i32 undef>
  %3 = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> %1, <8 x i32> %2)
  %4 = shufflevector <16 x i16> %3, <16 x i16> undef, <16 x i32> <i32 undef, i32 undef, i32 2, i32 3, i32 4, i32 undef, i32 undef, i32 7, i32 8, i32 undef, i32 undef, i32 11, i32 12, i32 undef, i32 undef, i32 15>
  ret <16 x i16> %4
}

define <16 x i16> @elts_packusdw_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @elts_packusdw_256(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> %a1, <8 x i32> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    [[TMP2:%.*]] = call <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32> undef, <8 x i32> [[TMP1]])
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <16 x i16> [[TMP2]], <16 x i16> undef, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <16 x i16> [[TMP3]]
;
  %1 = shufflevector <8 x i32> %a0, <8 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %2 = shufflevector <8 x i32> %a1, <8 x i32> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %3 = call <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32> %1, <8 x i32> %2)
  %4 = shufflevector <16 x i16> %3, <16 x i16> undef, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef>
  ret <16 x i16> %4
}

define <32 x i8> @elts_packsswb_256(<16 x i16> %a0, <16 x i16> %a1) {
; CHECK-LABEL: @elts_packsswb_256(
; CHECK-NEXT:    [[TMP1:%.*]] = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> <i16 0, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef>, <16 x i16> <i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 0, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef, i16 undef>)
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <32 x i8> [[TMP1]], <32 x i8> undef, <32 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24>
; CHECK-NEXT:    ret <32 x i8> [[TMP2]]
;
  %1 = insertelement <16 x i16> %a0, i16 0, i32 0
  %2 = insertelement <16 x i16> %a1, i16 0, i32 8
  %3 = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> %1, <16 x i16> %2)
  %4 = shufflevector <32 x i8> %3, <32 x i8> undef, <32 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24>
  ret <32 x i8> %4
}

define <32 x i8> @elts_packuswb_256(<16 x i16> %a0, <16 x i16> %a1) {
; CHECK-LABEL: @elts_packuswb_256(
; CHECK-NEXT:    ret <32 x i8> undef
;
  %1 = insertelement <16 x i16> undef, i16 0, i32 1
  %2 = insertelement <16 x i16> undef, i16 0, i32 0
  %3 = call <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16> %1, <16 x i16> %2)
  %4 = shufflevector <32 x i8> %3, <32 x i8> undef, <32 x i32> zeroinitializer
  ret <32 x i8> %4
}

declare <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32>, <4 x i32>) nounwind readnone
declare <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16>, <8 x i16>) nounwind readnone
declare <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16>, <8 x i16>) nounwind readnone
declare <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32>, <4 x i32>) nounwind readnone

declare <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32>, <8 x i32>) nounwind readnone
declare <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32>, <8 x i32>) nounwind readnone
declare <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16>, <16 x i16>) nounwind readnone
declare <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16>, <16 x i16>) nounwind readnone
