// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple thumbv8.1m.main-none-none-eabi -target-feature +mve -mfloat-abi hard -fallow-half-arguments-and-returns -O0 -disable-O0-optnone -S -emit-llvm -o - %s | opt -S -mem2reg | FileCheck %s
// RUN: %clang_cc1 -triple thumbv8.1m.main-none-none-eabi -target-feature +mve -mfloat-abi hard -fallow-half-arguments-and-returns -O0 -disable-O0-optnone -DPOLYMORPHIC -S -emit-llvm -o - %s | opt -S -mem2reg | FileCheck %s

#include <arm_mve.h>

// CHECK-LABEL: @test_vclzq_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <16 x i8> @llvm.ctlz.v16i8(<16 x i8> [[A:%.*]], i1 false)
// CHECK-NEXT:    ret <16 x i8> [[TMP0]]
//
int8x16_t test_vclzq_s8(int8x16_t a)
{
#ifdef POLYMORPHIC
    return vclzq(a);
#else /* POLYMORPHIC */
    return vclzq_s8(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <8 x i16> @llvm.ctlz.v8i16(<8 x i16> [[A:%.*]], i1 false)
// CHECK-NEXT:    ret <8 x i16> [[TMP0]]
//
int16x8_t test_vclzq_s16(int16x8_t a)
{
#ifdef POLYMORPHIC
    return vclzq(a);
#else /* POLYMORPHIC */
    return vclzq_s16(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <4 x i32> @llvm.ctlz.v4i32(<4 x i32> [[A:%.*]], i1 false)
// CHECK-NEXT:    ret <4 x i32> [[TMP0]]
//
int32x4_t test_vclzq_s32(int32x4_t a)
{
#ifdef POLYMORPHIC
    return vclzq(a);
#else /* POLYMORPHIC */
    return vclzq_s32(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_u8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <16 x i8> @llvm.ctlz.v16i8(<16 x i8> [[A:%.*]], i1 false)
// CHECK-NEXT:    ret <16 x i8> [[TMP0]]
//
uint8x16_t test_vclzq_u8(uint8x16_t a)
{
#ifdef POLYMORPHIC
    return vclzq(a);
#else /* POLYMORPHIC */
    return vclzq_u8(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_u16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <8 x i16> @llvm.ctlz.v8i16(<8 x i16> [[A:%.*]], i1 false)
// CHECK-NEXT:    ret <8 x i16> [[TMP0]]
//
uint16x8_t test_vclzq_u16(uint16x8_t a)
{
#ifdef POLYMORPHIC
    return vclzq(a);
#else /* POLYMORPHIC */
    return vclzq_u16(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <4 x i32> @llvm.ctlz.v4i32(<4 x i32> [[A:%.*]], i1 false)
// CHECK-NEXT:    ret <4 x i32> [[TMP0]]
//
uint32x4_t test_vclzq_u32(uint32x4_t a)
{
#ifdef POLYMORPHIC
    return vclzq(a);
#else /* POLYMORPHIC */
    return vclzq_u32(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclsq_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <16 x i8> @llvm.arm.mve.vcls.v16i8(<16 x i8> [[A:%.*]])
// CHECK-NEXT:    ret <16 x i8> [[TMP0]]
//
int8x16_t test_vclsq_s8(int8x16_t a)
{
#ifdef POLYMORPHIC
    return vclsq(a);
#else /* POLYMORPHIC */
    return vclsq_s8(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclsq_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <8 x i16> @llvm.arm.mve.vcls.v8i16(<8 x i16> [[A:%.*]])
// CHECK-NEXT:    ret <8 x i16> [[TMP0]]
//
int16x8_t test_vclsq_s16(int16x8_t a)
{
#ifdef POLYMORPHIC
    return vclsq(a);
#else /* POLYMORPHIC */
    return vclsq_s16(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclsq_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = call <4 x i32> @llvm.arm.mve.vcls.v4i32(<4 x i32> [[A:%.*]])
// CHECK-NEXT:    ret <4 x i32> [[TMP0]]
//
int32x4_t test_vclsq_s32(int32x4_t a)
{
#ifdef POLYMORPHIC
    return vclsq(a);
#else /* POLYMORPHIC */
    return vclsq_s32(a);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclsq_m_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.cls.predicated.v16i8.v16i1(<16 x i8> [[A:%.*]], <16 x i1> [[TMP1]], <16 x i8> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <16 x i8> [[TMP2]]
//
int8x16_t test_vclsq_m_s8(int8x16_t inactive, int8x16_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclsq_m(inactive, a, p);
#else /* POLYMORPHIC */
    return vclsq_m_s8(inactive, a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclsq_m_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.cls.predicated.v8i16.v8i1(<8 x i16> [[A:%.*]], <8 x i1> [[TMP1]], <8 x i16> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <8 x i16> [[TMP2]]
//
int16x8_t test_vclsq_m_s16(int16x8_t inactive, int16x8_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclsq_m(inactive, a, p);
#else /* POLYMORPHIC */
    return vclsq_m_s16(inactive, a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclsq_m_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <4 x i32> @llvm.arm.mve.cls.predicated.v4i32.v4i1(<4 x i32> [[A:%.*]], <4 x i1> [[TMP1]], <4 x i32> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <4 x i32> [[TMP2]]
//
int32x4_t test_vclsq_m_s32(int32x4_t inactive, int32x4_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclsq_m(inactive, a, p);
#else /* POLYMORPHIC */
    return vclsq_m_s32(inactive, a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_m_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.clz.predicated.v16i8.v16i1(<16 x i8> [[A:%.*]], <16 x i1> [[TMP1]], <16 x i8> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <16 x i8> [[TMP2]]
//
int8x16_t test_vclzq_m_s8(int8x16_t inactive, int8x16_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclzq_m(inactive, a, p);
#else /* POLYMORPHIC */
    return vclzq_m_s8(inactive, a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_m_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.clz.predicated.v8i16.v8i1(<8 x i16> [[A:%.*]], <8 x i1> [[TMP1]], <8 x i16> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <8 x i16> [[TMP2]]
//
int16x8_t test_vclzq_m_s16(int16x8_t inactive, int16x8_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclzq_m(inactive, a, p);
#else /* POLYMORPHIC */
    return vclzq_m_s16(inactive, a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_m_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <4 x i32> @llvm.arm.mve.clz.predicated.v4i32.v4i1(<4 x i32> [[A:%.*]], <4 x i1> [[TMP1]], <4 x i32> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <4 x i32> [[TMP2]]
//
int32x4_t test_vclzq_m_s32(int32x4_t inactive, int32x4_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclzq_m(inactive, a, p);
#else /* POLYMORPHIC */
    return vclzq_m_s32(inactive, a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_m_u8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.clz.predicated.v16i8.v16i1(<16 x i8> [[A:%.*]], <16 x i1> [[TMP1]], <16 x i8> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <16 x i8> [[TMP2]]
//
uint8x16_t test_vclzq_m_u8(uint8x16_t inactive, uint8x16_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclzq_m(inactive, a, p);
#else /* POLYMORPHIC */
    return vclzq_m_u8(inactive, a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_m_u16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.clz.predicated.v8i16.v8i1(<8 x i16> [[A:%.*]], <8 x i1> [[TMP1]], <8 x i16> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <8 x i16> [[TMP2]]
//
uint16x8_t test_vclzq_m_u16(uint16x8_t inactive, uint16x8_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclzq_m(inactive, a, p);
#else /* POLYMORPHIC */
    return vclzq_m_u16(inactive, a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_m_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <4 x i32> @llvm.arm.mve.clz.predicated.v4i32.v4i1(<4 x i32> [[A:%.*]], <4 x i1> [[TMP1]], <4 x i32> [[INACTIVE:%.*]])
// CHECK-NEXT:    ret <4 x i32> [[TMP2]]
//
uint32x4_t test_vclzq_m_u32(uint32x4_t inactive, uint32x4_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclzq_m(inactive, a, p);
#else /* POLYMORPHIC */
    return vclzq_m_u32(inactive, a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclsq_x_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.cls.predicated.v16i8.v16i1(<16 x i8> [[A:%.*]], <16 x i1> [[TMP1]], <16 x i8> undef)
// CHECK-NEXT:    ret <16 x i8> [[TMP2]]
//
int8x16_t test_vclsq_x_s8(int8x16_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclsq_x(a, p);
#else /* POLYMORPHIC */
    return vclsq_x_s8(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclsq_x_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.cls.predicated.v8i16.v8i1(<8 x i16> [[A:%.*]], <8 x i1> [[TMP1]], <8 x i16> undef)
// CHECK-NEXT:    ret <8 x i16> [[TMP2]]
//
int16x8_t test_vclsq_x_s16(int16x8_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclsq_x(a, p);
#else /* POLYMORPHIC */
    return vclsq_x_s16(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclsq_x_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <4 x i32> @llvm.arm.mve.cls.predicated.v4i32.v4i1(<4 x i32> [[A:%.*]], <4 x i1> [[TMP1]], <4 x i32> undef)
// CHECK-NEXT:    ret <4 x i32> [[TMP2]]
//
int32x4_t test_vclsq_x_s32(int32x4_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclsq_x(a, p);
#else /* POLYMORPHIC */
    return vclsq_x_s32(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_x_s8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.clz.predicated.v16i8.v16i1(<16 x i8> [[A:%.*]], <16 x i1> [[TMP1]], <16 x i8> undef)
// CHECK-NEXT:    ret <16 x i8> [[TMP2]]
//
int8x16_t test_vclzq_x_s8(int8x16_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclzq_x(a, p);
#else /* POLYMORPHIC */
    return vclzq_x_s8(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_x_s16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.clz.predicated.v8i16.v8i1(<8 x i16> [[A:%.*]], <8 x i1> [[TMP1]], <8 x i16> undef)
// CHECK-NEXT:    ret <8 x i16> [[TMP2]]
//
int16x8_t test_vclzq_x_s16(int16x8_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclzq_x(a, p);
#else /* POLYMORPHIC */
    return vclzq_x_s16(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_x_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <4 x i32> @llvm.arm.mve.clz.predicated.v4i32.v4i1(<4 x i32> [[A:%.*]], <4 x i1> [[TMP1]], <4 x i32> undef)
// CHECK-NEXT:    ret <4 x i32> [[TMP2]]
//
int32x4_t test_vclzq_x_s32(int32x4_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclzq_x(a, p);
#else /* POLYMORPHIC */
    return vclzq_x_s32(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_x_u8(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i1> @llvm.arm.mve.pred.i2v.v16i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.clz.predicated.v16i8.v16i1(<16 x i8> [[A:%.*]], <16 x i1> [[TMP1]], <16 x i8> undef)
// CHECK-NEXT:    ret <16 x i8> [[TMP2]]
//
uint8x16_t test_vclzq_x_u8(uint8x16_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclzq_x(a, p);
#else /* POLYMORPHIC */
    return vclzq_x_u8(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_x_u16(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.clz.predicated.v8i16.v8i1(<8 x i16> [[A:%.*]], <8 x i1> [[TMP1]], <8 x i16> undef)
// CHECK-NEXT:    ret <8 x i16> [[TMP2]]
//
uint16x8_t test_vclzq_x_u16(uint16x8_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclzq_x(a, p);
#else /* POLYMORPHIC */
    return vclzq_x_u16(a, p);
#endif /* POLYMORPHIC */
}

// CHECK-LABEL: @test_vclzq_x_u32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// CHECK-NEXT:    [[TMP2:%.*]] = call <4 x i32> @llvm.arm.mve.clz.predicated.v4i32.v4i1(<4 x i32> [[A:%.*]], <4 x i1> [[TMP1]], <4 x i32> undef)
// CHECK-NEXT:    ret <4 x i32> [[TMP2]]
//
uint32x4_t test_vclzq_x_u32(uint32x4_t a, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vclzq_x(a, p);
#else /* POLYMORPHIC */
    return vclzq_x_u32(a, p);
#endif /* POLYMORPHIC */
}
