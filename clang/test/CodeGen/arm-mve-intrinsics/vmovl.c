// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple thumbv8.1m.main-arm-none-eabi -target-feature +mve -mfloat-abi hard -fallow-half-arguments-and-returns -O0 -disable-O0-optnone -S -emit-llvm -o - %s | opt -S -mem2reg | FileCheck %s
// RUN: %clang_cc1 -triple thumbv8.1m.main-arm-none-eabi -target-feature +mve -mfloat-abi hard -fallow-half-arguments-and-returns -O0 -disable-O0-optnone -DPOLYMORPHIC -S -emit-llvm -o - %s | opt -S -mem2reg | FileCheck %s

#include <arm_mve.h>

// CHECK-LABEL: @test_vmovlbq_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <16 x i8> [[A:%.*]], <16 x i8> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
// CHECK-NEXT:    [[TMP1:%.*]] = sext <8 x i8> [[TMP0]] to <8 x i16>
// CHECK-NEXT:    ret <8 x i16> [[TMP1]]
//
int16x8_t test_vmovlbq_s8(int8x16_t a)
{
#ifdef POLYMORPHIC
    return vmovlbq(a);
#else /* POLYMORPHIC */
    return vmovlbq_s8(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vmovlbq_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <8 x i16> [[A:%.*]], <8 x i16> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
// CHECK-NEXT:    [[TMP1:%.*]] = sext <4 x i16> [[TMP0]] to <4 x i32>
// CHECK-NEXT:    ret <4 x i32> [[TMP1]]
//
int32x4_t test_vmovlbq_s16(int16x8_t a)
{
#ifdef POLYMORPHIC
    return vmovlbq(a);
#else /* POLYMORPHIC */
    return vmovlbq_s16(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vmovlbq_u8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <16 x i8> [[A:%.*]], <16 x i8> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
// CHECK-NEXT:    [[TMP1:%.*]] = zext <8 x i8> [[TMP0]] to <8 x i16>
// CHECK-NEXT:    ret <8 x i16> [[TMP1]]
//
uint16x8_t test_vmovlbq_u8(uint8x16_t a)
{
#ifdef POLYMORPHIC
    return vmovlbq(a);
#else /* POLYMORPHIC */
    return vmovlbq_u8(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vmovlbq_u16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <8 x i16> [[A:%.*]], <8 x i16> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
// CHECK-NEXT:    [[TMP1:%.*]] = zext <4 x i16> [[TMP0]] to <4 x i32>
// CHECK-NEXT:    ret <4 x i32> [[TMP1]]
//
uint32x4_t test_vmovlbq_u16(uint16x8_t a)
{
#ifdef POLYMORPHIC
    return vmovlbq(a);
#else /* POLYMORPHIC */
    return vmovlbq_u16(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vmovltq_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <16 x i8> [[A:%.*]], <16 x i8> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
// CHECK-NEXT:    [[TMP1:%.*]] = sext <8 x i8> [[TMP0]] to <8 x i16>
// CHECK-NEXT:    ret <8 x i16> [[TMP1]]
//
int16x8_t test_vmovltq_s8(int8x16_t a)
{
#ifdef POLYMORPHIC
    return vmovltq(a);
#else /* POLYMORPHIC */
    return vmovltq_s8(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vmovltq_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <8 x i16> [[A:%.*]], <8 x i16> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
// CHECK-NEXT:    [[TMP1:%.*]] = sext <4 x i16> [[TMP0]] to <4 x i32>
// CHECK-NEXT:    ret <4 x i32> [[TMP1]]
//
int32x4_t test_vmovltq_s16(int16x8_t a)
{
#ifdef POLYMORPHIC
    return vmovltq(a);
#else /* POLYMORPHIC */
    return vmovltq_s16(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vmovltq_u8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <16 x i8> [[A:%.*]], <16 x i8> undef, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
// CHECK-NEXT:    [[TMP1:%.*]] = zext <8 x i8> [[TMP0]] to <8 x i16>
// CHECK-NEXT:    ret <8 x i16> [[TMP1]]
//
uint16x8_t test_vmovltq_u8(uint8x16_t a)
{
#ifdef POLYMORPHIC
    return vmovltq(a);
#else /* POLYMORPHIC */
    return vmovltq_u8(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vmovltq_u16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <8 x i16> [[A:%.*]], <8 x i16> undef, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
// CHECK-NEXT:    [[TMP1:%.*]] = zext <4 x i16> [[TMP0]] to <4 x i32>
// CHECK-NEXT:    ret <4 x i32> [[TMP1]]
//
uint32x4_t test_vmovltq_u16(uint16x8_t a)
{
#ifdef POLYMORPHIC
    return vmovltq(a);
#else /* POLYMORPHIC */
    return vmovltq_u16(a);
#endif /* POLYMORPHIC */
}

