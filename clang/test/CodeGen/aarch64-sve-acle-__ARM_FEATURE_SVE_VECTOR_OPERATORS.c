// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve -fallow-half-arguments-and-returns -S -O1 -Werror -Wall -emit-llvm -o - %s -msve-vector-bits=128  | FileCheck %s -D#VBITS=128  --check-prefixes=CHECK128
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve -fallow-half-arguments-and-returns -S -O1 -Werror -Wall -emit-llvm -o - %s -msve-vector-bits=256  | FileCheck %s -D#VBITS=256  --check-prefixes=CHECK,CHECK256
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve -fallow-half-arguments-and-returns -S -O1 -Werror -Wall -emit-llvm -o - %s -msve-vector-bits=512  | FileCheck %s -D#VBITS=512  --check-prefixes=CHECK,CHECK512
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve -fallow-half-arguments-and-returns -S -O1 -Werror -Wall -emit-llvm -o - %s -msve-vector-bits=1024 | FileCheck %s -D#VBITS=1024 --check-prefixes=CHECK,CHECK1024
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +sve -fallow-half-arguments-and-returns -S -O1 -Werror -Wall -emit-llvm -o - %s -msve-vector-bits=2048 | FileCheck %s -D#VBITS=2048 --check-prefixes=CHECK,CHECK2048
// REQUIRES: aarch64-registered-target

// Examples taken from section "3.7.3.3 Behavior specific to SVE
// vectors" of the SVE ACLE (Version 00bet6) that can be found at
// https://developer.arm.com/documentation/100987/latest
//
// Example has been expanded to work with mutiple values of
// -msve-vector-bits.

#include <arm_sve.h>

// Page 27, item 1
#if __ARM_FEATURE_SVE_BITS == 256 && __ARM_FEATURE_SVE_VECTOR_OPERATORS
// CHECK256-LABEL: @x256 = local_unnamed_addr global <4 x i64> <i64 0, i64 1, i64 2, i64 3>, align 16
typedef svint64_t vec256 __attribute__((arm_sve_vector_bits(256)));
vec256 x256 = {0, 1, 2, 3};
#endif

#if __ARM_FEATURE_SVE_BITS == 512 && __ARM_FEATURE_SVE_VECTOR_OPERATORS
// CHECK512-LABEL: @x512 = local_unnamed_addr global <8 x i64> <i64 0, i64 1, i64 2, i64 3, i64 3, i64 2, i64 1, i64 0>, align 16
typedef svint64_t vec512 __attribute__((arm_sve_vector_bits(512)));
vec512 x512 = {0, 1, 2, 3, 3 , 2 , 1, 0};
#endif

#if __ARM_FEATURE_SVE_BITS == 1024 && __ARM_FEATURE_SVE_VECTOR_OPERATORS
// CHECK1024-LABEL: @x1024 = local_unnamed_addr global <16 x i64> <i64 0, i64 1, i64 2, i64 3, i64 3, i64 2, i64 1, i64 0, i64 0, i64 1, i64 2, i64 3, i64 3, i64 2, i64 1, i64 0>, align 16
typedef svint64_t vec1024 __attribute__((arm_sve_vector_bits(1024)));
vec1024 x1024 = {0, 1, 2, 3, 3 , 2 , 1, 0, 0, 1, 2, 3, 3 , 2 , 1, 0};
#endif

#if __ARM_FEATURE_SVE_BITS == 2048 && __ARM_FEATURE_SVE_VECTOR_OPERATORS
// CHECK2048-LABEL: @x2048 = local_unnamed_addr global <32 x i64> <i64 0, i64 1, i64 2, i64 3, i64 3, i64 2, i64 1, i64 0, i64 0, i64 1, i64 2, i64 3, i64 3, i64 2, i64 1, i64 0, i64 0, i64 1, i64 2, i64 3, i64 3, i64 2, i64 1, i64 0, i64 0, i64 1, i64 2, i64 3, i64 3, i64 2, i64 1, i64 0>, align 16
typedef svint64_t vec2048 __attribute__((arm_sve_vector_bits(2048)));
vec2048 x2048 = {0, 1, 2, 3, 3 , 2 , 1, 0, 0, 1, 2, 3, 3 , 2 , 1, 0,
                 0, 1, 2, 3, 3 , 2 , 1, 0, 0, 1, 2, 3, 3 , 2 , 1, 0};
#endif

// Page 27, item 2. We can not change the ABI of existing vector
// types, including vec_int8.  That's why in the SVE ACLE, VLST is
// distinct from, but mostly interchangeable with, the corresponding
// GNUT. VLST is treated for ABI purposes like an SVE type but GNUT
// continues to be a normal GNU vector type, with base Armv8-A PCS
// rules.
#if __ARM_FEATURE_SVE_BITS && __ARM_FEATURE_SVE_VECTOR_OPERATORS
#define N __ARM_FEATURE_SVE_BITS
typedef int8_t vec_int8 __attribute__((vector_size(N / 8)));
// CHECK128-LABEL: define <16 x i8> @f2(<16 x i8> %x)
// CHECK128-NEXT:  entry:
// CHECK128-NEXT:    %x.addr = alloca <16 x i8>, align 16
// CHECK128-NEXT:    %saved-call-rvalue = alloca <vscale x 16 x i8>, align 16
// CHECK128-NEXT:    store <16 x i8> %x, <16 x i8>* %x.addr, align 16
// CHECK128-NEXT:    %0 = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 31)
// CHECK128-NEXT:    %1 = bitcast <16 x i8>* %x.addr to <vscale x 16 x i8>*
// CHECK128-NEXT:    %2 = load <vscale x 16 x i8>, <vscale x 16 x i8>* %1, align 16
// CHECK128-NEXT:    %3 = call <vscale x 16 x i8> @llvm.aarch64.sve.asrd.nxv16i8(<vscale x 16 x i1> %0, <vscale x 16 x i8> %2, i32 1)
// CHECK128-NEXT:    store <vscale x 16 x i8> %3, <vscale x 16 x i8>* %saved-call-rvalue, align 16
// CHECK128-NEXT:    %castFixedSve = bitcast <vscale x 16 x i8>* %saved-call-rvalue to <16 x i8>*
// CHECK128-NEXT:    %4 = load <16 x i8>, <16 x i8>* %castFixedSve, align 16
// CHECK128-NEXT:    ret <16 x i8> %4

// CHECK-LABEL: define void @f2(
// CHECK-SAME:   <[[#div(VBITS,8)]] x i8>* noalias nocapture sret(<[[#div(VBITS,8)]] x i8>) align 16 %agg.result, <[[#div(VBITS,8)]] x i8>* nocapture readonly %0)
// CHECK-NEXT: entry:
// CHECK-NEXT:   %x.addr = alloca <[[#div(VBITS,8)]] x i8>, align 16
// CHECK-NEXT:   %saved-call-rvalue = alloca <vscale x 16 x i8>, align 16
// CHECK-NEXT:   %x = load <[[#div(VBITS,8)]] x i8>, <[[#div(VBITS,8)]] x i8>* %0, align 16
// CHECK-NEXT:   store <[[#div(VBITS,8)]] x i8> %x, <[[#div(VBITS,8)]] x i8>* %x.addr, align 16
// CHECK-NEXT:   %1 = call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 31)
// CHECK-NEXT:   %2 = bitcast <[[#div(VBITS,8)]] x i8>* %x.addr to <vscale x 16 x i8>*
// CHECK-NEXT:   %3 = load <vscale x 16 x i8>, <vscale x 16 x i8>* %2, align 16
// CHECK-NEXT:   %4 = call <vscale x 16 x i8> @llvm.aarch64.sve.asrd.nxv16i8(<vscale x 16 x i1> %1, <vscale x 16 x i8> %3, i32 1)
// CHECK-NEXT:   store <vscale x 16 x i8> %4, <vscale x 16 x i8>* %saved-call-rvalue, align 16
// CHECK-NEXT:   %castFixedSve = bitcast <vscale x 16 x i8>* %saved-call-rvalue to <[[#div(VBITS,8)]] x i8>*
// CHECK-NEXT:   %5 = load <[[#div(VBITS,8)]] x i8>, <[[#div(VBITS,8)]] x i8>* %castFixedSve, align 16
// CHECK-NEXT:   store <[[#div(VBITS,8)]] x i8> %5, <[[#div(VBITS,8)]] x i8>* %agg.result, align 16
// CHECK-NEXT:   ret void
vec_int8 f2(vec_int8 x) { return svasrd_x(svptrue_b8(), x, 1); }
#endif

// Page 27, item 3.
#if __ARM_FEATURE_SVE_BITS && __ARM_FEATURE_SVE_VECTOR_OPERATORS
#define N __ARM_FEATURE_SVE_BITS
typedef int8_t vec1 __attribute__((vector_size(N / 8)));
void f3(vec1);
typedef svint8_t vec2 __attribute__((arm_sve_vector_bits(N)));

// CHECK128-LABEL: define void @g(<vscale x 16 x i8> %x.coerce)
// CHECK128-NEXT: entry:
// CHECK128-NEXT:  %x = alloca <16 x i8>, align 16
// CHECK128-NEXT:      %0 = bitcast <16 x i8>* %x to <vscale x 16 x i8>*
// CHECK128-NEXT:    store <vscale x 16 x i8> %x.coerce, <vscale x 16 x i8>* %0, align 16
// CHECK128-NEXT:    %x1 = load <16 x i8>, <16 x i8>* %x, align 16,
// CHECK128-NEXT:    call void @f3(<16 x i8> %x1) #4
// CHECK128-NEXT:      ret void

// CHECK-LABEL: define void @g(<vscale x 16 x i8> %x.coerce)
// CHECK-NEXT: entry:
// CHECK-NEXT:   %x = alloca <[[#div(VBITS,8)]] x i8>, align 16
// CHECK-NEXT:   %indirect-arg-temp = alloca <[[#div(VBITS,8)]] x i8>, align 16
// CHECK-NEXT:   %0 = bitcast <[[#div(VBITS,8)]] x i8>* %x to <vscale x 16 x i8>*
// CHECK-NEXT:   store <vscale x 16 x i8> %x.coerce, <vscale x 16 x i8>* %0
// CHECK-NEXT:   %x1 = load <[[#div(VBITS,8)]] x i8>, <[[#div(VBITS,8)]] x i8>* %x, align 16
// CHECK-NEXT:   store <[[#div(VBITS,8)]] x i8> %x1, <[[#div(VBITS,8)]] x i8>* %indirect-arg-temp
// CHECK-NEXT:   call void @f3(<[[#div(VBITS,8)]] x i8>* nonnull %indirect-arg-temp)
// CHECK-NEXT:   ret void

// CHECK128-LABEL: declare void @f3(<16 x i8>)

// CHECK-LABEL: declare void @f3(
// CHECK-SAME:   <[[#div(VBITS,8)]] x i8>*)
void g(vec2 x) { f3(x); } // OK
#endif
