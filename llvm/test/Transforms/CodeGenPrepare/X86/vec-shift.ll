; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -codegenprepare -mtriple=x86_64-- -mattr=+avx -S < %s | FileCheck %s --check-prefixes=ALL,AVX,AVX1
; RUN: opt -codegenprepare -mtriple=x86_64-- -mattr=+avx2 -S < %s | FileCheck %s --check-prefixes=ALL,AVX,AVX2
; RUN: opt -codegenprepare -mtriple=x86_64-- -mattr=+avx512bw -S < %s | FileCheck %s --check-prefixes=ALL,AVX,AVX512BW
; RUN: opt -codegenprepare -mtriple=x86_64-- -mattr=+avx,+xop -S < %s | FileCheck %s --check-prefixes=ALL,XOP,XOPAVX1
; RUN: opt -codegenprepare -mtriple=x86_64-- -mattr=+avx2,+xop -S < %s | FileCheck %s --check-prefixes=ALL,XOP,XOPAVX2
; RUN: opt -codegenprepare -mtriple=x86_64-- -mattr=+avx -S -enable-debugify < %s 2>&1 | FileCheck %s -check-prefix=DEBUG

define <4 x i32> @vector_variable_shift_right_v4i32(<4 x i1> %cond, <4 x i32> %x, <4 x i32> %y, <4 x i32> %z) {
; AVX1-LABEL: @vector_variable_shift_right_v4i32(
; AVX1-NEXT:    [[SPLAT1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX1-NEXT:    [[SPLAT2:%.*]] = shufflevector <4 x i32> [[Y:%.*]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX1-NEXT:    [[SEL:%.*]] = select <4 x i1> [[COND:%.*]], <4 x i32> [[SPLAT1]], <4 x i32> [[SPLAT2]]
; AVX1-NEXT:    [[TMP1:%.*]] = lshr <4 x i32> [[Z:%.*]], [[SPLAT1]]
; AVX1-NEXT:    [[TMP2:%.*]] = lshr <4 x i32> [[Z]], [[SPLAT2]]
; AVX1-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[COND]], <4 x i32> [[TMP1]], <4 x i32> [[TMP2]]
; AVX1-NEXT:    ret <4 x i32> [[TMP3]]
;
; AVX2-LABEL: @vector_variable_shift_right_v4i32(
; AVX2-NEXT:    [[SPLAT1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX2-NEXT:    [[SPLAT2:%.*]] = shufflevector <4 x i32> [[Y:%.*]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX2-NEXT:    [[SEL:%.*]] = select <4 x i1> [[COND:%.*]], <4 x i32> [[SPLAT1]], <4 x i32> [[SPLAT2]]
; AVX2-NEXT:    [[SH:%.*]] = lshr <4 x i32> [[Z:%.*]], [[SEL]]
; AVX2-NEXT:    ret <4 x i32> [[SH]]
;
; AVX512BW-LABEL: @vector_variable_shift_right_v4i32(
; AVX512BW-NEXT:    [[SPLAT1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX512BW-NEXT:    [[SPLAT2:%.*]] = shufflevector <4 x i32> [[Y:%.*]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX512BW-NEXT:    [[SEL:%.*]] = select <4 x i1> [[COND:%.*]], <4 x i32> [[SPLAT1]], <4 x i32> [[SPLAT2]]
; AVX512BW-NEXT:    [[SH:%.*]] = lshr <4 x i32> [[Z:%.*]], [[SEL]]
; AVX512BW-NEXT:    ret <4 x i32> [[SH]]
;
; XOP-LABEL: @vector_variable_shift_right_v4i32(
; XOP-NEXT:    [[SPLAT1:%.*]] = shufflevector <4 x i32> [[X:%.*]], <4 x i32> undef, <4 x i32> zeroinitializer
; XOP-NEXT:    [[SPLAT2:%.*]] = shufflevector <4 x i32> [[Y:%.*]], <4 x i32> undef, <4 x i32> zeroinitializer
; XOP-NEXT:    [[SEL:%.*]] = select <4 x i1> [[COND:%.*]], <4 x i32> [[SPLAT1]], <4 x i32> [[SPLAT2]]
; XOP-NEXT:    [[SH:%.*]] = lshr <4 x i32> [[Z:%.*]], [[SEL]]
; XOP-NEXT:    ret <4 x i32> [[SH]]
;
  %splat1 = shufflevector <4 x i32> %x, <4 x i32> undef, <4 x i32> zeroinitializer
  %splat2 = shufflevector <4 x i32> %y, <4 x i32> undef, <4 x i32> zeroinitializer
  %sel = select <4 x i1> %cond, <4 x i32> %splat1, <4 x i32> %splat2
  %sh = lshr <4 x i32> %z, %sel
  ret <4 x i32> %sh
}

define <16 x i16> @vector_variable_shift_right_v16i16(<16 x i1> %cond, <16 x i16> %x, <16 x i16> %y, <16 x i16> %z) {
; AVX1-LABEL: @vector_variable_shift_right_v16i16(
; AVX1-NEXT:    [[SPLAT1:%.*]] = shufflevector <16 x i16> [[X:%.*]], <16 x i16> undef, <16 x i32> zeroinitializer
; AVX1-NEXT:    [[SPLAT2:%.*]] = shufflevector <16 x i16> [[Y:%.*]], <16 x i16> undef, <16 x i32> zeroinitializer
; AVX1-NEXT:    [[SEL:%.*]] = select <16 x i1> [[COND:%.*]], <16 x i16> [[SPLAT1]], <16 x i16> [[SPLAT2]]
; AVX1-NEXT:    [[TMP1:%.*]] = lshr <16 x i16> [[Z:%.*]], [[SPLAT1]]
; AVX1-NEXT:    [[TMP2:%.*]] = lshr <16 x i16> [[Z]], [[SPLAT2]]
; AVX1-NEXT:    [[TMP3:%.*]] = select <16 x i1> [[COND]], <16 x i16> [[TMP1]], <16 x i16> [[TMP2]]
; AVX1-NEXT:    ret <16 x i16> [[TMP3]]
;
; AVX2-LABEL: @vector_variable_shift_right_v16i16(
; AVX2-NEXT:    [[SPLAT1:%.*]] = shufflevector <16 x i16> [[X:%.*]], <16 x i16> undef, <16 x i32> zeroinitializer
; AVX2-NEXT:    [[SPLAT2:%.*]] = shufflevector <16 x i16> [[Y:%.*]], <16 x i16> undef, <16 x i32> zeroinitializer
; AVX2-NEXT:    [[SEL:%.*]] = select <16 x i1> [[COND:%.*]], <16 x i16> [[SPLAT1]], <16 x i16> [[SPLAT2]]
; AVX2-NEXT:    [[TMP1:%.*]] = lshr <16 x i16> [[Z:%.*]], [[SPLAT1]]
; AVX2-NEXT:    [[TMP2:%.*]] = lshr <16 x i16> [[Z]], [[SPLAT2]]
; AVX2-NEXT:    [[TMP3:%.*]] = select <16 x i1> [[COND]], <16 x i16> [[TMP1]], <16 x i16> [[TMP2]]
; AVX2-NEXT:    ret <16 x i16> [[TMP3]]
;
; AVX512BW-LABEL: @vector_variable_shift_right_v16i16(
; AVX512BW-NEXT:    [[SPLAT1:%.*]] = shufflevector <16 x i16> [[X:%.*]], <16 x i16> undef, <16 x i32> zeroinitializer
; AVX512BW-NEXT:    [[SPLAT2:%.*]] = shufflevector <16 x i16> [[Y:%.*]], <16 x i16> undef, <16 x i32> zeroinitializer
; AVX512BW-NEXT:    [[SEL:%.*]] = select <16 x i1> [[COND:%.*]], <16 x i16> [[SPLAT1]], <16 x i16> [[SPLAT2]]
; AVX512BW-NEXT:    [[SH:%.*]] = lshr <16 x i16> [[Z:%.*]], [[SEL]]
; AVX512BW-NEXT:    ret <16 x i16> [[SH]]
;
; XOP-LABEL: @vector_variable_shift_right_v16i16(
; XOP-NEXT:    [[SPLAT1:%.*]] = shufflevector <16 x i16> [[X:%.*]], <16 x i16> undef, <16 x i32> zeroinitializer
; XOP-NEXT:    [[SPLAT2:%.*]] = shufflevector <16 x i16> [[Y:%.*]], <16 x i16> undef, <16 x i32> zeroinitializer
; XOP-NEXT:    [[SEL:%.*]] = select <16 x i1> [[COND:%.*]], <16 x i16> [[SPLAT1]], <16 x i16> [[SPLAT2]]
; XOP-NEXT:    [[SH:%.*]] = lshr <16 x i16> [[Z:%.*]], [[SEL]]
; XOP-NEXT:    ret <16 x i16> [[SH]]
;
  %splat1 = shufflevector <16 x i16> %x, <16 x i16> undef, <16 x i32> zeroinitializer
  %splat2 = shufflevector <16 x i16> %y, <16 x i16> undef, <16 x i32> zeroinitializer
  %sel = select <16 x i1> %cond, <16 x i16> %splat1, <16 x i16> %splat2
  %sh = lshr <16 x i16> %z, %sel
  ret <16 x i16> %sh
}

define <32 x i8> @vector_variable_shift_right_v32i8(<32 x i1> %cond, <32 x i8> %x, <32 x i8> %y, <32 x i8> %z) {
; ALL-LABEL: @vector_variable_shift_right_v32i8(
; ALL-NEXT:    [[SPLAT1:%.*]] = shufflevector <32 x i8> [[X:%.*]], <32 x i8> undef, <32 x i32> zeroinitializer
; ALL-NEXT:    [[SPLAT2:%.*]] = shufflevector <32 x i8> [[Y:%.*]], <32 x i8> undef, <32 x i32> zeroinitializer
; ALL-NEXT:    [[SEL:%.*]] = select <32 x i1> [[COND:%.*]], <32 x i8> [[SPLAT1]], <32 x i8> [[SPLAT2]]
; ALL-NEXT:    [[SH:%.*]] = lshr <32 x i8> [[Z:%.*]], [[SEL]]
; ALL-NEXT:    ret <32 x i8> [[SH]]
;
  %splat1 = shufflevector <32 x i8> %x, <32 x i8> undef, <32 x i32> zeroinitializer
  %splat2 = shufflevector <32 x i8> %y, <32 x i8> undef, <32 x i32> zeroinitializer
  %sel = select <32 x i1> %cond, <32 x i8> %splat1, <32 x i8> %splat2
  %sh = lshr <32 x i8> %z, %sel
  ret <32 x i8> %sh
}

; PR37428 - https://bugs.llvm.org/show_bug.cgi?id=37428

define void @vector_variable_shift_left_loop(i32* nocapture %arr, i8* nocapture readonly %control, i32 %count, i32 %amt0, i32 %amt1, i32 %x) {
; AVX1-LABEL: @vector_variable_shift_left_loop(
; AVX1-NEXT:  entry:
; AVX1-NEXT:    [[CMP16:%.*]] = icmp sgt i32 [[COUNT:%.*]], 0
; AVX1-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[COUNT]] to i64
; AVX1-NEXT:    br i1 [[CMP16]], label [[VECTOR_PH:%.*]], label [[EXIT:%.*]]
; AVX1:       vector.ph:
; AVX1-NEXT:    [[N_VEC:%.*]] = and i64 [[WIDE_TRIP_COUNT]], 4294967292
; AVX1-NEXT:    [[SPLATINSERT18:%.*]] = insertelement <4 x i32> undef, i32 [[AMT0:%.*]], i32 0
; AVX1-NEXT:    [[SPLAT1:%.*]] = shufflevector <4 x i32> [[SPLATINSERT18]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX1-NEXT:    [[SPLATINSERT20:%.*]] = insertelement <4 x i32> undef, i32 [[AMT1:%.*]], i32 0
; AVX1-NEXT:    [[SPLAT2:%.*]] = shufflevector <4 x i32> [[SPLATINSERT20]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX1-NEXT:    [[SPLATINSERT22:%.*]] = insertelement <4 x i32> undef, i32 [[X:%.*]], i32 0
; AVX1-NEXT:    [[SPLAT3:%.*]] = shufflevector <4 x i32> [[SPLATINSERT22]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX1-NEXT:    br label [[VECTOR_BODY:%.*]]
; AVX1:       vector.body:
; AVX1-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; AVX1-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i8, i8* [[CONTROL:%.*]], i64 [[INDEX]]
; AVX1-NEXT:    [[TMP1:%.*]] = bitcast i8* [[TMP0]] to <4 x i8>*
; AVX1-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i8>, <4 x i8>* [[TMP1]], align 1
; AVX1-NEXT:    [[TMP2:%.*]] = icmp eq <4 x i8> [[WIDE_LOAD]], zeroinitializer
; AVX1-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[TMP2]], <4 x i32> [[SPLAT1]], <4 x i32> [[SPLAT2]]
; AVX1-NEXT:    [[TMP4:%.*]] = shufflevector <4 x i32> [[SPLATINSERT18]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX1-NEXT:    [[TMP5:%.*]] = shl <4 x i32> [[SPLAT3]], [[TMP4]]
; AVX1-NEXT:    [[TMP6:%.*]] = shufflevector <4 x i32> [[SPLATINSERT20]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX1-NEXT:    [[TMP7:%.*]] = shl <4 x i32> [[SPLAT3]], [[TMP6]]
; AVX1-NEXT:    [[TMP8:%.*]] = select <4 x i1> [[TMP2]], <4 x i32> [[TMP5]], <4 x i32> [[TMP7]]
; AVX1-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i32, i32* [[ARR:%.*]], i64 [[INDEX]]
; AVX1-NEXT:    [[TMP10:%.*]] = bitcast i32* [[TMP9]] to <4 x i32>*
; AVX1-NEXT:    store <4 x i32> [[TMP8]], <4 x i32>* [[TMP10]], align 4
; AVX1-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; AVX1-NEXT:    [[TMP11:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; AVX1-NEXT:    br i1 [[TMP11]], label [[EXIT]], label [[VECTOR_BODY]]
; AVX1:       exit:
; AVX1-NEXT:    ret void
;
; AVX2-LABEL: @vector_variable_shift_left_loop(
; AVX2-NEXT:  entry:
; AVX2-NEXT:    [[CMP16:%.*]] = icmp sgt i32 [[COUNT:%.*]], 0
; AVX2-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[COUNT]] to i64
; AVX2-NEXT:    br i1 [[CMP16]], label [[VECTOR_PH:%.*]], label [[EXIT:%.*]]
; AVX2:       vector.ph:
; AVX2-NEXT:    [[N_VEC:%.*]] = and i64 [[WIDE_TRIP_COUNT]], 4294967292
; AVX2-NEXT:    [[SPLATINSERT18:%.*]] = insertelement <4 x i32> undef, i32 [[AMT0:%.*]], i32 0
; AVX2-NEXT:    [[SPLAT1:%.*]] = shufflevector <4 x i32> [[SPLATINSERT18]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX2-NEXT:    [[SPLATINSERT20:%.*]] = insertelement <4 x i32> undef, i32 [[AMT1:%.*]], i32 0
; AVX2-NEXT:    [[SPLAT2:%.*]] = shufflevector <4 x i32> [[SPLATINSERT20]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX2-NEXT:    [[SPLATINSERT22:%.*]] = insertelement <4 x i32> undef, i32 [[X:%.*]], i32 0
; AVX2-NEXT:    [[SPLAT3:%.*]] = shufflevector <4 x i32> [[SPLATINSERT22]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX2-NEXT:    br label [[VECTOR_BODY:%.*]]
; AVX2:       vector.body:
; AVX2-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; AVX2-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i8, i8* [[CONTROL:%.*]], i64 [[INDEX]]
; AVX2-NEXT:    [[TMP1:%.*]] = bitcast i8* [[TMP0]] to <4 x i8>*
; AVX2-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i8>, <4 x i8>* [[TMP1]], align 1
; AVX2-NEXT:    [[TMP2:%.*]] = icmp eq <4 x i8> [[WIDE_LOAD]], zeroinitializer
; AVX2-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[TMP2]], <4 x i32> [[SPLAT1]], <4 x i32> [[SPLAT2]]
; AVX2-NEXT:    [[TMP4:%.*]] = shl <4 x i32> [[SPLAT3]], [[TMP3]]
; AVX2-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[ARR:%.*]], i64 [[INDEX]]
; AVX2-NEXT:    [[TMP6:%.*]] = bitcast i32* [[TMP5]] to <4 x i32>*
; AVX2-NEXT:    store <4 x i32> [[TMP4]], <4 x i32>* [[TMP6]], align 4
; AVX2-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; AVX2-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; AVX2-NEXT:    br i1 [[TMP7]], label [[EXIT]], label [[VECTOR_BODY]]
; AVX2:       exit:
; AVX2-NEXT:    ret void
;
; AVX512BW-LABEL: @vector_variable_shift_left_loop(
; AVX512BW-NEXT:  entry:
; AVX512BW-NEXT:    [[CMP16:%.*]] = icmp sgt i32 [[COUNT:%.*]], 0
; AVX512BW-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[COUNT]] to i64
; AVX512BW-NEXT:    br i1 [[CMP16]], label [[VECTOR_PH:%.*]], label [[EXIT:%.*]]
; AVX512BW:       vector.ph:
; AVX512BW-NEXT:    [[N_VEC:%.*]] = and i64 [[WIDE_TRIP_COUNT]], 4294967292
; AVX512BW-NEXT:    [[SPLATINSERT18:%.*]] = insertelement <4 x i32> undef, i32 [[AMT0:%.*]], i32 0
; AVX512BW-NEXT:    [[SPLAT1:%.*]] = shufflevector <4 x i32> [[SPLATINSERT18]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX512BW-NEXT:    [[SPLATINSERT20:%.*]] = insertelement <4 x i32> undef, i32 [[AMT1:%.*]], i32 0
; AVX512BW-NEXT:    [[SPLAT2:%.*]] = shufflevector <4 x i32> [[SPLATINSERT20]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX512BW-NEXT:    [[SPLATINSERT22:%.*]] = insertelement <4 x i32> undef, i32 [[X:%.*]], i32 0
; AVX512BW-NEXT:    [[SPLAT3:%.*]] = shufflevector <4 x i32> [[SPLATINSERT22]], <4 x i32> undef, <4 x i32> zeroinitializer
; AVX512BW-NEXT:    br label [[VECTOR_BODY:%.*]]
; AVX512BW:       vector.body:
; AVX512BW-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; AVX512BW-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i8, i8* [[CONTROL:%.*]], i64 [[INDEX]]
; AVX512BW-NEXT:    [[TMP1:%.*]] = bitcast i8* [[TMP0]] to <4 x i8>*
; AVX512BW-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i8>, <4 x i8>* [[TMP1]], align 1
; AVX512BW-NEXT:    [[TMP2:%.*]] = icmp eq <4 x i8> [[WIDE_LOAD]], zeroinitializer
; AVX512BW-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[TMP2]], <4 x i32> [[SPLAT1]], <4 x i32> [[SPLAT2]]
; AVX512BW-NEXT:    [[TMP4:%.*]] = shl <4 x i32> [[SPLAT3]], [[TMP3]]
; AVX512BW-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[ARR:%.*]], i64 [[INDEX]]
; AVX512BW-NEXT:    [[TMP6:%.*]] = bitcast i32* [[TMP5]] to <4 x i32>*
; AVX512BW-NEXT:    store <4 x i32> [[TMP4]], <4 x i32>* [[TMP6]], align 4
; AVX512BW-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; AVX512BW-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; AVX512BW-NEXT:    br i1 [[TMP7]], label [[EXIT]], label [[VECTOR_BODY]]
; AVX512BW:       exit:
; AVX512BW-NEXT:    ret void
;
; XOP-LABEL: @vector_variable_shift_left_loop(
; XOP-NEXT:  entry:
; XOP-NEXT:    [[CMP16:%.*]] = icmp sgt i32 [[COUNT:%.*]], 0
; XOP-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[COUNT]] to i64
; XOP-NEXT:    br i1 [[CMP16]], label [[VECTOR_PH:%.*]], label [[EXIT:%.*]]
; XOP:       vector.ph:
; XOP-NEXT:    [[N_VEC:%.*]] = and i64 [[WIDE_TRIP_COUNT]], 4294967292
; XOP-NEXT:    [[SPLATINSERT18:%.*]] = insertelement <4 x i32> undef, i32 [[AMT0:%.*]], i32 0
; XOP-NEXT:    [[SPLAT1:%.*]] = shufflevector <4 x i32> [[SPLATINSERT18]], <4 x i32> undef, <4 x i32> zeroinitializer
; XOP-NEXT:    [[SPLATINSERT20:%.*]] = insertelement <4 x i32> undef, i32 [[AMT1:%.*]], i32 0
; XOP-NEXT:    [[SPLAT2:%.*]] = shufflevector <4 x i32> [[SPLATINSERT20]], <4 x i32> undef, <4 x i32> zeroinitializer
; XOP-NEXT:    [[SPLATINSERT22:%.*]] = insertelement <4 x i32> undef, i32 [[X:%.*]], i32 0
; XOP-NEXT:    [[SPLAT3:%.*]] = shufflevector <4 x i32> [[SPLATINSERT22]], <4 x i32> undef, <4 x i32> zeroinitializer
; XOP-NEXT:    br label [[VECTOR_BODY:%.*]]
; XOP:       vector.body:
; XOP-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; XOP-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i8, i8* [[CONTROL:%.*]], i64 [[INDEX]]
; XOP-NEXT:    [[TMP1:%.*]] = bitcast i8* [[TMP0]] to <4 x i8>*
; XOP-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i8>, <4 x i8>* [[TMP1]], align 1
; XOP-NEXT:    [[TMP2:%.*]] = icmp eq <4 x i8> [[WIDE_LOAD]], zeroinitializer
; XOP-NEXT:    [[TMP3:%.*]] = select <4 x i1> [[TMP2]], <4 x i32> [[SPLAT1]], <4 x i32> [[SPLAT2]]
; XOP-NEXT:    [[TMP4:%.*]] = shl <4 x i32> [[SPLAT3]], [[TMP3]]
; XOP-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[ARR:%.*]], i64 [[INDEX]]
; XOP-NEXT:    [[TMP6:%.*]] = bitcast i32* [[TMP5]] to <4 x i32>*
; XOP-NEXT:    store <4 x i32> [[TMP4]], <4 x i32>* [[TMP6]], align 4
; XOP-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; XOP-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; XOP-NEXT:    br i1 [[TMP7]], label [[EXIT]], label [[VECTOR_BODY]]
; XOP:       exit:
; XOP-NEXT:    ret void
;
entry:
  %cmp16 = icmp sgt i32 %count, 0
  %wide.trip.count = zext i32 %count to i64
  br i1 %cmp16, label %vector.ph, label %exit

vector.ph:
  %n.vec = and i64 %wide.trip.count, 4294967292
  %splatinsert18 = insertelement <4 x i32> undef, i32 %amt0, i32 0
  %splat1 = shufflevector <4 x i32> %splatinsert18, <4 x i32> undef, <4 x i32> zeroinitializer
  %splatinsert20 = insertelement <4 x i32> undef, i32 %amt1, i32 0
  %splat2 = shufflevector <4 x i32> %splatinsert20, <4 x i32> undef, <4 x i32> zeroinitializer
  %splatinsert22 = insertelement <4 x i32> undef, i32 %x, i32 0
  %splat3 = shufflevector <4 x i32> %splatinsert22, <4 x i32> undef, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i8, i8* %control, i64 %index
  %1 = bitcast i8* %0 to <4 x i8>*
  %wide.load = load <4 x i8>, <4 x i8>* %1, align 1
  %2 = icmp eq <4 x i8> %wide.load, zeroinitializer
  %3 = select <4 x i1> %2, <4 x i32> %splat1, <4 x i32> %splat2
  %4 = shl <4 x i32> %splat3, %3
  %5 = getelementptr inbounds i32, i32* %arr, i64 %index
  %6 = bitcast i32* %5 to <4 x i32>*
  store <4 x i32> %4, <4 x i32>* %6, align 4
  %index.next = add i64 %index, 4
  %7 = icmp eq i64 %index.next, %n.vec
  br i1 %7, label %exit, label %vector.body

exit:
  ret void
}

; PR37426 - https://bugs.llvm.org/show_bug.cgi?id=37426
; If we don't have real vector shift instructions (AVX1), convert the funnel
; shift into 2 funnel shifts and sink the splat shuffles into the loop.

define void @fancierRotate2(i32* %arr, i8* %control, i32 %rot0, i32 %rot1) {
; AVX1-LABEL: @fancierRotate2(
; AVX1-NEXT:  entry:
; AVX1-NEXT:    [[I0:%.*]] = insertelement <8 x i32> undef, i32 [[ROT0:%.*]], i32 0
; AVX1-NEXT:    [[S0:%.*]] = shufflevector <8 x i32> [[I0]], <8 x i32> undef, <8 x i32> zeroinitializer
; AVX1-NEXT:    [[I1:%.*]] = insertelement <8 x i32> undef, i32 [[ROT1:%.*]], i32 0
; AVX1-NEXT:    [[S1:%.*]] = shufflevector <8 x i32> [[I1]], <8 x i32> undef, <8 x i32> zeroinitializer
; AVX1-NEXT:    br label [[LOOP:%.*]]
; AVX1:       loop:
; AVX1-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDEX_NEXT:%.*]], [[LOOP]] ]
; AVX1-NEXT:    [[T0:%.*]] = getelementptr inbounds i8, i8* [[CONTROL:%.*]], i64 [[INDEX]]
; AVX1-NEXT:    [[T1:%.*]] = bitcast i8* [[T0]] to <8 x i8>*
; AVX1-NEXT:    [[WIDE_LOAD:%.*]] = load <8 x i8>, <8 x i8>* [[T1]], align 1
; AVX1-NEXT:    [[T2:%.*]] = icmp eq <8 x i8> [[WIDE_LOAD]], zeroinitializer
; AVX1-NEXT:    [[SHAMT:%.*]] = select <8 x i1> [[T2]], <8 x i32> [[S0]], <8 x i32> [[S1]]
; AVX1-NEXT:    [[T4:%.*]] = getelementptr inbounds i32, i32* [[ARR:%.*]], i64 [[INDEX]]
; AVX1-NEXT:    [[T5:%.*]] = bitcast i32* [[T4]] to <8 x i32>*
; AVX1-NEXT:    [[WIDE_LOAD21:%.*]] = load <8 x i32>, <8 x i32>* [[T5]], align 4
; AVX1-NEXT:    [[TMP0:%.*]] = shufflevector <8 x i32> [[I0]], <8 x i32> undef, <8 x i32> zeroinitializer
; AVX1-NEXT:    [[TMP1:%.*]] = call <8 x i32> @llvm.fshl.v8i32(<8 x i32> [[WIDE_LOAD21]], <8 x i32> [[WIDE_LOAD21]], <8 x i32> [[TMP0]])
; AVX1-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[I1]], <8 x i32> undef, <8 x i32> zeroinitializer
; AVX1-NEXT:    [[TMP3:%.*]] = call <8 x i32> @llvm.fshl.v8i32(<8 x i32> [[WIDE_LOAD21]], <8 x i32> [[WIDE_LOAD21]], <8 x i32> [[TMP2]])
; AVX1-NEXT:    [[TMP4:%.*]] = select <8 x i1> [[T2]], <8 x i32> [[TMP1]], <8 x i32> [[TMP3]]
; AVX1-NEXT:    store <8 x i32> [[TMP4]], <8 x i32>* [[T5]], align 4
; AVX1-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 8
; AVX1-NEXT:    [[T7:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1024
; AVX1-NEXT:    br i1 [[T7]], label [[EXIT:%.*]], label [[LOOP]]
; AVX1:       exit:
; AVX1-NEXT:    ret void
;
; AVX2-LABEL: @fancierRotate2(
; AVX2-NEXT:  entry:
; AVX2-NEXT:    [[I0:%.*]] = insertelement <8 x i32> undef, i32 [[ROT0:%.*]], i32 0
; AVX2-NEXT:    [[S0:%.*]] = shufflevector <8 x i32> [[I0]], <8 x i32> undef, <8 x i32> zeroinitializer
; AVX2-NEXT:    [[I1:%.*]] = insertelement <8 x i32> undef, i32 [[ROT1:%.*]], i32 0
; AVX2-NEXT:    [[S1:%.*]] = shufflevector <8 x i32> [[I1]], <8 x i32> undef, <8 x i32> zeroinitializer
; AVX2-NEXT:    br label [[LOOP:%.*]]
; AVX2:       loop:
; AVX2-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDEX_NEXT:%.*]], [[LOOP]] ]
; AVX2-NEXT:    [[T0:%.*]] = getelementptr inbounds i8, i8* [[CONTROL:%.*]], i64 [[INDEX]]
; AVX2-NEXT:    [[T1:%.*]] = bitcast i8* [[T0]] to <8 x i8>*
; AVX2-NEXT:    [[WIDE_LOAD:%.*]] = load <8 x i8>, <8 x i8>* [[T1]], align 1
; AVX2-NEXT:    [[T2:%.*]] = icmp eq <8 x i8> [[WIDE_LOAD]], zeroinitializer
; AVX2-NEXT:    [[SHAMT:%.*]] = select <8 x i1> [[T2]], <8 x i32> [[S0]], <8 x i32> [[S1]]
; AVX2-NEXT:    [[T4:%.*]] = getelementptr inbounds i32, i32* [[ARR:%.*]], i64 [[INDEX]]
; AVX2-NEXT:    [[T5:%.*]] = bitcast i32* [[T4]] to <8 x i32>*
; AVX2-NEXT:    [[WIDE_LOAD21:%.*]] = load <8 x i32>, <8 x i32>* [[T5]], align 4
; AVX2-NEXT:    [[ROT:%.*]] = call <8 x i32> @llvm.fshl.v8i32(<8 x i32> [[WIDE_LOAD21]], <8 x i32> [[WIDE_LOAD21]], <8 x i32> [[SHAMT]])
; AVX2-NEXT:    store <8 x i32> [[ROT]], <8 x i32>* [[T5]], align 4
; AVX2-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 8
; AVX2-NEXT:    [[T7:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1024
; AVX2-NEXT:    br i1 [[T7]], label [[EXIT:%.*]], label [[LOOP]]
; AVX2:       exit:
; AVX2-NEXT:    ret void
;
; AVX512BW-LABEL: @fancierRotate2(
; AVX512BW-NEXT:  entry:
; AVX512BW-NEXT:    [[I0:%.*]] = insertelement <8 x i32> undef, i32 [[ROT0:%.*]], i32 0
; AVX512BW-NEXT:    [[S0:%.*]] = shufflevector <8 x i32> [[I0]], <8 x i32> undef, <8 x i32> zeroinitializer
; AVX512BW-NEXT:    [[I1:%.*]] = insertelement <8 x i32> undef, i32 [[ROT1:%.*]], i32 0
; AVX512BW-NEXT:    [[S1:%.*]] = shufflevector <8 x i32> [[I1]], <8 x i32> undef, <8 x i32> zeroinitializer
; AVX512BW-NEXT:    br label [[LOOP:%.*]]
; AVX512BW:       loop:
; AVX512BW-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDEX_NEXT:%.*]], [[LOOP]] ]
; AVX512BW-NEXT:    [[T0:%.*]] = getelementptr inbounds i8, i8* [[CONTROL:%.*]], i64 [[INDEX]]
; AVX512BW-NEXT:    [[T1:%.*]] = bitcast i8* [[T0]] to <8 x i8>*
; AVX512BW-NEXT:    [[WIDE_LOAD:%.*]] = load <8 x i8>, <8 x i8>* [[T1]], align 1
; AVX512BW-NEXT:    [[T2:%.*]] = icmp eq <8 x i8> [[WIDE_LOAD]], zeroinitializer
; AVX512BW-NEXT:    [[SHAMT:%.*]] = select <8 x i1> [[T2]], <8 x i32> [[S0]], <8 x i32> [[S1]]
; AVX512BW-NEXT:    [[T4:%.*]] = getelementptr inbounds i32, i32* [[ARR:%.*]], i64 [[INDEX]]
; AVX512BW-NEXT:    [[T5:%.*]] = bitcast i32* [[T4]] to <8 x i32>*
; AVX512BW-NEXT:    [[WIDE_LOAD21:%.*]] = load <8 x i32>, <8 x i32>* [[T5]], align 4
; AVX512BW-NEXT:    [[ROT:%.*]] = call <8 x i32> @llvm.fshl.v8i32(<8 x i32> [[WIDE_LOAD21]], <8 x i32> [[WIDE_LOAD21]], <8 x i32> [[SHAMT]])
; AVX512BW-NEXT:    store <8 x i32> [[ROT]], <8 x i32>* [[T5]], align 4
; AVX512BW-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 8
; AVX512BW-NEXT:    [[T7:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1024
; AVX512BW-NEXT:    br i1 [[T7]], label [[EXIT:%.*]], label [[LOOP]]
; AVX512BW:       exit:
; AVX512BW-NEXT:    ret void
;
; XOP-LABEL: @fancierRotate2(
; XOP-NEXT:  entry:
; XOP-NEXT:    [[I0:%.*]] = insertelement <8 x i32> undef, i32 [[ROT0:%.*]], i32 0
; XOP-NEXT:    [[S0:%.*]] = shufflevector <8 x i32> [[I0]], <8 x i32> undef, <8 x i32> zeroinitializer
; XOP-NEXT:    [[I1:%.*]] = insertelement <8 x i32> undef, i32 [[ROT1:%.*]], i32 0
; XOP-NEXT:    [[S1:%.*]] = shufflevector <8 x i32> [[I1]], <8 x i32> undef, <8 x i32> zeroinitializer
; XOP-NEXT:    br label [[LOOP:%.*]]
; XOP:       loop:
; XOP-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDEX_NEXT:%.*]], [[LOOP]] ]
; XOP-NEXT:    [[T0:%.*]] = getelementptr inbounds i8, i8* [[CONTROL:%.*]], i64 [[INDEX]]
; XOP-NEXT:    [[T1:%.*]] = bitcast i8* [[T0]] to <8 x i8>*
; XOP-NEXT:    [[WIDE_LOAD:%.*]] = load <8 x i8>, <8 x i8>* [[T1]], align 1
; XOP-NEXT:    [[T2:%.*]] = icmp eq <8 x i8> [[WIDE_LOAD]], zeroinitializer
; XOP-NEXT:    [[SHAMT:%.*]] = select <8 x i1> [[T2]], <8 x i32> [[S0]], <8 x i32> [[S1]]
; XOP-NEXT:    [[T4:%.*]] = getelementptr inbounds i32, i32* [[ARR:%.*]], i64 [[INDEX]]
; XOP-NEXT:    [[T5:%.*]] = bitcast i32* [[T4]] to <8 x i32>*
; XOP-NEXT:    [[WIDE_LOAD21:%.*]] = load <8 x i32>, <8 x i32>* [[T5]], align 4
; XOP-NEXT:    [[ROT:%.*]] = call <8 x i32> @llvm.fshl.v8i32(<8 x i32> [[WIDE_LOAD21]], <8 x i32> [[WIDE_LOAD21]], <8 x i32> [[SHAMT]])
; XOP-NEXT:    store <8 x i32> [[ROT]], <8 x i32>* [[T5]], align 4
; XOP-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 8
; XOP-NEXT:    [[T7:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1024
; XOP-NEXT:    br i1 [[T7]], label [[EXIT:%.*]], label [[LOOP]]
; XOP:       exit:
; XOP-NEXT:    ret void
;
entry:
  %i0 = insertelement <8 x i32> undef, i32 %rot0, i32 0
  %s0 = shufflevector <8 x i32> %i0, <8 x i32> undef, <8 x i32> zeroinitializer
  %i1 = insertelement <8 x i32> undef, i32 %rot1, i32 0
  %s1 = shufflevector <8 x i32> %i1, <8 x i32> undef, <8 x i32> zeroinitializer
  br label %loop

loop:
  %index = phi i64 [ 0, %entry ], [ %index.next, %loop ]
  %t0 = getelementptr inbounds i8, i8* %control, i64 %index
  %t1 = bitcast i8* %t0 to <8 x i8>*
  %wide.load = load <8 x i8>, <8 x i8>* %t1, align 1
  %t2 = icmp eq <8 x i8> %wide.load, zeroinitializer
  %shamt = select <8 x i1> %t2, <8 x i32> %s0, <8 x i32> %s1
  %t4 = getelementptr inbounds i32, i32* %arr, i64 %index
  %t5 = bitcast i32* %t4 to <8 x i32>*
  %wide.load21 = load <8 x i32>, <8 x i32>* %t5, align 4
  %rot = call <8 x i32> @llvm.fshl.v8i32(<8 x i32> %wide.load21, <8 x i32> %wide.load21, <8 x i32> %shamt)
  store <8 x i32> %rot, <8 x i32>* %t5, align 4
  %index.next = add i64 %index, 8
  %t7 = icmp eq i64 %index.next, 1024
  br i1 %t7, label %exit, label %loop

exit:
  ret void
}

declare <8 x i32> @llvm.fshl.v8i32(<8 x i32>, <8 x i32>, <8 x i32>) #1

; Check that every instruction inserted by -codegenprepare has a debug location.
; DEBUG: CheckModuleDebugify: PASS
