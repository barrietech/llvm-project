; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,X64

; Verify that we correctly fold target specific packed vector shifts by
; immediate count into a simple build_vector when the elements of the vector
; in input to the packed shift are all constants or undef.

define <8 x i16> @test1() {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [8,16,32,64,8,16,32,64]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x i16> @llvm.x86.sse2.pslli.w(<8 x i16> <i16 1, i16 2, i16 4, i16 8, i16 1, i16 2, i16 4, i16 8>, i32 3)
  ret <8 x i16> %1
}

define <8 x i16> @test2() {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [0,1,2,4,0,1,2,4]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x i16> @llvm.x86.sse2.psrli.w(<8 x i16> <i16 4, i16 8, i16 16, i16 32, i16 4, i16 8, i16 16, i16 32>, i32 3)
  ret <8 x i16> %1
}

define <8 x i16> @test3() {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [0,1,2,4,0,1,2,4]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x i16> @llvm.x86.sse2.psrai.w(<8 x i16> <i16 4, i16 8, i16 16, i16 32, i16 4, i16 8, i16 16, i16 32>, i32 3)
  ret <8 x i16> %1
}

define <4 x i32> @test4() {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [8,16,32,64]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x i32> @llvm.x86.sse2.pslli.d(<4 x i32> <i32 1, i32 2, i32 4, i32 8>, i32 3)
  ret <4 x i32> %1
}

define <4 x i32> @test5() {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [0,1,2,4]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x i32> @llvm.x86.sse2.psrli.d(<4 x i32> <i32 4, i32 8, i32 16, i32 32>, i32 3)
  ret <4 x i32> %1
}

define <4 x i32> @test6() {
; CHECK-LABEL: test6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [0,1,2,4]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x i32> @llvm.x86.sse2.psrai.d(<4 x i32> <i32 4, i32 8, i32 16, i32 32>, i32 3)
  ret <4 x i32> %1
}

define <2 x i64> @test7() {
; X86-LABEL: test7:
; X86:       # %bb.0:
; X86-NEXT:    movaps {{.*#+}} xmm0 = [8,0,16,0]
; X86-NEXT:    retl
;
; X64-LABEL: test7:
; X64:       # %bb.0:
; X64-NEXT:    movaps {{.*#+}} xmm0 = [8,16]
; X64-NEXT:    retq
  %1 = tail call <2 x i64> @llvm.x86.sse2.pslli.q(<2 x i64> <i64 1, i64 2>, i32 3)
  ret <2 x i64> %1
}

define <2 x i64> @test8() {
; X86-LABEL: test8:
; X86:       # %bb.0:
; X86-NEXT:    movaps {{.*#+}} xmm0 = [1,0,2,0]
; X86-NEXT:    retl
;
; X64-LABEL: test8:
; X64:       # %bb.0:
; X64-NEXT:    movaps {{.*#+}} xmm0 = [1,2]
; X64-NEXT:    retq
  %1 = tail call <2 x i64> @llvm.x86.sse2.psrli.q(<2 x i64> <i64 8, i64 16>, i32 3)
  ret <2 x i64> %1
}

define <8 x i16> @test9() {
; CHECK-LABEL: test9:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [1,1,0,0,3,0,8,16]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x i16> @llvm.x86.sse2.psrai.w(<8 x i16> <i16 15, i16 8, i16 undef, i16 undef, i16 31, i16 undef, i16 64, i16 128>, i32 3)
  ret <8 x i16> %1
}

define <4 x i32> @test10() {
; CHECK-LABEL: test10:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [0,1,0,4]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x i32> @llvm.x86.sse2.psrai.d(<4 x i32> <i32 undef, i32 8, i32 undef, i32 32>, i32 3)
  ret <4 x i32> %1
}

define <2 x i64> @test11() {
; X86-LABEL: test11:
; X86:       # %bb.0:
; X86-NEXT:    movaps {{.*#+}} xmm0 = [0,0,3,0]
; X86-NEXT:    retl
;
; X64-LABEL: test11:
; X64:       # %bb.0:
; X64-NEXT:    movaps {{.*#+}} xmm0 = [0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0]
; X64-NEXT:    retq
  %1 = tail call <2 x i64> @llvm.x86.sse2.psrli.q(<2 x i64> <i64 undef, i64 31>, i32 3)
  ret <2 x i64> %1
}

define <8 x i16> @test12() {
; CHECK-LABEL: test12:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [1,1,0,0,3,0,8,16]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x i16> @llvm.x86.sse2.psrai.w(<8 x i16> <i16 15, i16 8, i16 undef, i16 undef, i16 31, i16 undef, i16 64, i16 128>, i32 3)
  ret <8 x i16> %1
}

define <4 x i32> @test13() {
; CHECK-LABEL: test13:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [0,1,0,4]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x i32> @llvm.x86.sse2.psrli.d(<4 x i32> <i32 undef, i32 8, i32 undef, i32 32>, i32 3)
  ret <4 x i32> %1
}

define <8 x i16> @test14() {
; CHECK-LABEL: test14:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [1,1,0,0,3,0,8,16]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <8 x i16> @llvm.x86.sse2.psrli.w(<8 x i16> <i16 15, i16 8, i16 undef, i16 undef, i16 31, i16 undef, i16 64, i16 128>, i32 3)
  ret <8 x i16> %1
}

define <4 x i32> @test15() {
; CHECK-LABEL: test15:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [0,64,0,256]
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = tail call <4 x i32> @llvm.x86.sse2.pslli.d(<4 x i32> <i32 undef, i32 8, i32 undef, i32 32>, i32 3)
  ret <4 x i32> %1
}

define <2 x i64> @test16() {
; X86-LABEL: test16:
; X86:       # %bb.0:
; X86-NEXT:    movaps {{.*#+}} xmm0 = [0,0,248,0]
; X86-NEXT:    retl
;
; X64-LABEL: test16:
; X64:       # %bb.0:
; X64-NEXT:    movaps {{.*#+}} xmm0 = [0,0,0,0,0,0,0,0,248,0,0,0,0,0,0,0]
; X64-NEXT:    retq
  %1 = tail call <2 x i64> @llvm.x86.sse2.pslli.q(<2 x i64> <i64 undef, i64 31>, i32 3)
  ret <2 x i64> %1
}

declare <8 x i16> @llvm.x86.sse2.pslli.w(<8 x i16>, i32)
declare <8 x i16> @llvm.x86.sse2.psrli.w(<8 x i16>, i32)
declare <8 x i16> @llvm.x86.sse2.psrai.w(<8 x i16>, i32)
declare <4 x i32> @llvm.x86.sse2.pslli.d(<4 x i32>, i32)
declare <4 x i32> @llvm.x86.sse2.psrli.d(<4 x i32>, i32)
declare <4 x i32> @llvm.x86.sse2.psrai.d(<4 x i32>, i32)
declare <2 x i64> @llvm.x86.sse2.pslli.q(<2 x i64>, i32)
declare <2 x i64> @llvm.x86.sse2.psrli.q(<2 x i64>, i32)

