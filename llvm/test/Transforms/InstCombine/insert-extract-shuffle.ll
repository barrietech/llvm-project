; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine %s | FileCheck %s

define <1 x i8> @test1(<8 x i8> %in) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[VEC:%.*]] = shufflevector <8 x i8> [[IN:%.*]], <8 x i8> undef, <1 x i32> <i32 5>
; CHECK-NEXT:    ret <1 x i8> [[VEC]]
;
  %val = extractelement <8 x i8> %in, i32 5
  %vec = insertelement <1 x i8> undef, i8 %val, i32 0
  ret <1 x i8> %vec
}

define <4 x i16> @test2(<8 x i16> %in, <8 x i16> %in2) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[VEC_3:%.*]] = shufflevector <8 x i16> [[IN2:%.*]], <8 x i16> [[IN:%.*]], <4 x i32> <i32 11, i32 9, i32 0, i32 10>
; CHECK-NEXT:    ret <4 x i16> [[VEC_3]]
;
  %elt0 = extractelement <8 x i16> %in, i32 3
  %elt1 = extractelement <8 x i16> %in, i32 1
  %elt2 = extractelement <8 x i16> %in2, i32 0
  %elt3 = extractelement <8 x i16> %in, i32 2

  %vec.0 = insertelement <4 x i16> undef, i16 %elt0, i32 0
  %vec.1 = insertelement <4 x i16> %vec.0, i16 %elt1, i32 1
  %vec.2 = insertelement <4 x i16> %vec.1, i16 %elt2, i32 2
  %vec.3 = insertelement <4 x i16> %vec.2, i16 %elt3, i32 3

  ret <4 x i16> %vec.3
}

define <2 x i64> @test_vcopyq_lane_p64(<2 x i64> %a, <1 x i64> %b) {
; CHECK-LABEL: @test_vcopyq_lane_p64(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <1 x i64> [[B:%.*]], <1 x i64> undef, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[RES:%.*]] = shufflevector <2 x i64> [[A:%.*]], <2 x i64> [[TMP1]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    ret <2 x i64> [[RES]]
;
  %elt = extractelement <1 x i64> %b, i32 0
  %res = insertelement <2 x i64> %a, i64 %elt, i32 1
  ret <2 x i64> %res
}

; PR2109: https://llvm.org/bugs/show_bug.cgi?id=2109

define <4 x float> @widen_extract2(<4 x float> %ins, <2 x float> %ext) {
; CHECK-LABEL: @widen_extract2(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x float> [[EXT:%.*]], <2 x float> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    [[I2:%.*]] = shufflevector <4 x float> [[INS:%.*]], <4 x float> [[TMP1]], <4 x i32> <i32 0, i32 4, i32 2, i32 5>
; CHECK-NEXT:    ret <4 x float> [[I2]]
;
  %e1 = extractelement <2 x float> %ext, i32 0
  %e2 = extractelement <2 x float> %ext, i32 1
  %i1 = insertelement <4 x float> %ins, float %e1, i32 1
  %i2 = insertelement <4 x float> %i1, float %e2, i32 3
  ret <4 x float> %i2
}

define <4 x float> @widen_extract3(<4 x float> %ins, <3 x float> %ext) {
; CHECK-LABEL: @widen_extract3(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <3 x float> [[EXT:%.*]], <3 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 undef>
; CHECK-NEXT:    [[I3:%.*]] = shufflevector <4 x float> [[INS:%.*]], <4 x float> [[TMP1]], <4 x i32> <i32 6, i32 5, i32 4, i32 3>
; CHECK-NEXT:    ret <4 x float> [[I3]]
;
  %e1 = extractelement <3 x float> %ext, i32 0
  %e2 = extractelement <3 x float> %ext, i32 1
  %e3 = extractelement <3 x float> %ext, i32 2
  %i1 = insertelement <4 x float> %ins, float %e1, i32 2
  %i2 = insertelement <4 x float> %i1, float %e2, i32 1
  %i3 = insertelement <4 x float> %i2, float %e3, i32 0
  ret <4 x float> %i3
}

define <8 x float> @widen_extract4(<8 x float> %ins, <2 x float> %ext) {
; CHECK-LABEL: @widen_extract4(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x float> [[EXT:%.*]], <2 x float> undef, <8 x i32> <i32 0, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[I1:%.*]] = shufflevector <8 x float> [[INS:%.*]], <8 x float> [[TMP1]], <8 x i32> <i32 0, i32 1, i32 8, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    ret <8 x float> [[I1]]
;
  %e1 = extractelement <2 x float> %ext, i32 0
  %i1 = insertelement <8 x float> %ins, float %e1, i32 2
  ret <8 x float> %i1
}

; PR26015: https://llvm.org/bugs/show_bug.cgi?id=26015
; The widening shuffle must be inserted before any uses.

define <8 x i16> @pr26015(<4 x i16> %t0) {
; CHECK-LABEL: @pr26015(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i16> [[T0:%.*]], <4 x i16> undef, <8 x i32> <i32 undef, i32 undef, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[T5:%.*]] = shufflevector <8 x i16> <i16 0, i16 0, i16 0, i16 undef, i16 0, i16 0, i16 0, i16 undef>, <8 x i16> [[TMP1]], <8 x i32> <i32 0, i32 1, i32 2, i32 10, i32 4, i32 5, i32 6, i32 11>
; CHECK-NEXT:    ret <8 x i16> [[T5]]
;
  %t1 = extractelement <4 x i16> %t0, i32 2
  %t2 = insertelement <8 x i16> zeroinitializer, i16 %t1, i32 3
  %t3 = insertelement <8 x i16> %t2, i16 0, i32 6
  %t4 = extractelement <4 x i16> %t0, i32 3
  %t5 = insertelement <8 x i16> %t3, i16 %t4, i32 7
  ret <8 x i16> %t5
}

; PR25999: https://llvm.org/bugs/show_bug.cgi?id=25999
; TODO: The widening shuffle could be inserted at the start of the function to allow the first extract to use it.

define <8 x i16> @pr25999(<4 x i16> %t0, i1 %b) {
; CHECK-LABEL: @pr25999(
; CHECK-NEXT:    [[T1:%.*]] = extractelement <4 x i16> [[T0:%.*]], i32 2
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[END:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i16> [[T0]], <4 x i16> undef, <8 x i32> <i32 undef, i32 undef, i32 undef, i32 3, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[T3:%.*]] = insertelement <8 x i16> <i16 0, i16 0, i16 0, i16 undef, i16 0, i16 0, i16 0, i16 undef>, i16 [[T1]], i32 3
; CHECK-NEXT:    [[T5:%.*]] = shufflevector <8 x i16> [[T3]], <8 x i16> [[TMP1]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 11>
; CHECK-NEXT:    ret <8 x i16> [[T5]]
; CHECK:       end:
; CHECK-NEXT:    [[A1:%.*]] = add i16 [[T1]], 4
; CHECK-NEXT:    [[T6:%.*]] = insertelement <8 x i16> <i16 undef, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0, i16 0>, i16 [[A1]], i32 0
; CHECK-NEXT:    ret <8 x i16> [[T6]]
;

  %t1 = extractelement <4 x i16> %t0, i32 2
  br i1 %b, label %if, label %end

if:
  %t2 = insertelement <8 x i16> zeroinitializer, i16 %t1, i32 3
  %t3 = insertelement <8 x i16> %t2, i16 0, i32 6
  %t4 = extractelement <4 x i16> %t0, i32 3
  %t5 = insertelement <8 x i16> %t3, i16 %t4, i32 7
  ret <8 x i16> %t5

end:
  %a1 = add i16 %t1, 4
  %t6 = insertelement <8 x i16> zeroinitializer, i16 %a1, i32 0
  ret <8 x i16> %t6
}

; The widening shuffle must be inserted at a valid point (after the PHIs).

define <4 x double> @pr25999_phis1(i1 %c, <2 x double> %a, <4 x double> %b) {
; CHECK-LABEL: @pr25999_phis1(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[R:%.*]] = call <2 x double> @dummy(<2 x double> [[A:%.*]])
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[TMP1:%.*]] = phi <2 x double> [ [[A]], [[BB1:%.*]] ], [ [[R]], [[BB2]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = phi <4 x double> [ [[B:%.*]], [[BB1]] ], [ zeroinitializer, [[BB2]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <2 x double> [[TMP1]], <2 x double> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x double> [[TMP2]], <4 x double> [[TMP0]], <4 x i32> <i32 0, i32 1, i32 4, i32 3>
; CHECK-NEXT:    ret <4 x double> [[TMP4]]
;
bb1:
  br i1 %c, label %bb2, label %bb3

bb2:
  %r = call <2 x double> @dummy(<2 x double> %a)
  br label %bb3

bb3:
  %tmp1 = phi <2 x double> [ %a, %bb1 ], [ %r, %bb2 ]
  %tmp2 = phi <4 x double> [ %b, %bb1 ], [ zeroinitializer, %bb2 ]
  %tmp3 = extractelement <2 x double> %tmp1, i32 0
  %tmp4 = insertelement <4 x double> %tmp2, double %tmp3, i32 2
  ret <4 x double> %tmp4
}

declare <2 x double> @dummy(<2 x double>)

define <4 x double> @pr25999_phis2(i1 %c, <2 x double> %a, <4 x double> %b) {
; CHECK-LABEL: @pr25999_phis2(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[R:%.*]] = call <2 x double> @dummy(<2 x double> [[A:%.*]])
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[TMP1:%.*]] = phi <2 x double> [ [[A]], [[BB1:%.*]] ], [ [[R]], [[BB2]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = phi <4 x double> [ [[B:%.*]], [[BB1]] ], [ zeroinitializer, [[BB2]] ]
; CHECK-NEXT:    [[D:%.*]] = fadd <2 x double> [[TMP1]], [[TMP1]]
; CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <2 x double> [[D]], <2 x double> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x double> [[TMP2]], <4 x double> [[TMP0]], <4 x i32> <i32 0, i32 1, i32 4, i32 3>
; CHECK-NEXT:    ret <4 x double> [[TMP4]]
;
bb1:
  br i1 %c, label %bb2, label %bb3

bb2:
  %r = call <2 x double> @dummy(<2 x double> %a)
  br label %bb3

bb3:
  %tmp1 = phi <2 x double> [ %a, %bb1 ], [ %r, %bb2 ]
  %tmp2 = phi <4 x double> [ %b, %bb1 ], [ zeroinitializer, %bb2 ]
  %d = fadd <2 x double> %tmp1, %tmp1
  %tmp3 = extractelement <2 x double> %d, i32 0
  %tmp4 = insertelement <4 x double> %tmp2, double %tmp3, i32 2
  ret <4 x double> %tmp4
}

; PR26354: https://llvm.org/bugs/show_bug.cgi?id=26354
; Don't create a shufflevector if we know that we're not going to replace the insertelement.

define double @pr26354(<2 x double>* %tmp, i1 %B) {
; CHECK-LABEL: @pr26354(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LD:%.*]] = load <2 x double>, <2 x double>* [[TMP:%.*]], align 16
; CHECK-NEXT:    [[E1:%.*]] = extractelement <2 x double> [[LD]], i32 0
; CHECK-NEXT:    br i1 [[B:%.*]], label [[IF:%.*]], label [[END:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[E2:%.*]] = extractelement <2 x double> [[LD]], i32 1
; CHECK-NEXT:    [[I1:%.*]] = insertelement <4 x double> <double 0.000000e+00, double 0.000000e+00, double 0.000000e+00, double undef>, double [[E2]], i32 3
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PH:%.*]] = phi <4 x double> [ undef, [[ENTRY:%.*]] ], [ [[I1]], [[IF]] ]
; CHECK-NEXT:    [[E3:%.*]] = extractelement <4 x double> [[PH]], i32 1
; CHECK-NEXT:    [[MU:%.*]] = fmul double [[E1]], [[E3]]
; CHECK-NEXT:    ret double [[MU]]
;

entry:
  %ld = load <2 x double>, <2 x double>* %tmp
  %e1 = extractelement <2 x double> %ld, i32 0
  %e2 = extractelement <2 x double> %ld, i32 1
  br i1 %B, label %if, label %end

if:
  %i1 = insertelement <4 x double> zeroinitializer, double %e2, i32 3
  br label %end

end:
  %ph = phi <4 x double> [ undef, %entry ], [ %i1, %if ]
  %e3 = extractelement <4 x double> %ph, i32 1
  %mu = fmul double %e1, %e3
  ret double %mu
}

; https://llvm.org/bugs/show_bug.cgi?id=30923
; Delete the widening shuffle if we're not going to reduce the extract/insert to a shuffle.

define <4 x float> @PR30923(<2 x float> %x) {
; CHECK-LABEL: @PR30923(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    [[EXT1:%.*]] = extractelement <2 x float> [[X:%.*]], i32 1
; CHECK-NEXT:    store float [[EXT1]], float* undef, align 4
; CHECK-NEXT:    br label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[EXT2:%.*]] = extractelement <2 x float> [[X]], i32 0
; CHECK-NEXT:    [[INS1:%.*]] = insertelement <4 x float> <float 0.000000e+00, float 0.000000e+00, float undef, float undef>, float [[EXT2]], i32 2
; CHECK-NEXT:    [[INS2:%.*]] = insertelement <4 x float> [[INS1]], float [[EXT1]], i32 3
; CHECK-NEXT:    ret <4 x float> [[INS2]]
;
bb1:
  %ext1 = extractelement <2 x float> %x, i32 1
  store float %ext1, float* undef, align 4
  br label %bb2

bb2:
  %widen = shufflevector <2 x float> %x, <2 x float> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %ext2 = extractelement <4 x float> %widen, i32 0
  %ins1 = insertelement <4 x float> <float 0.0, float 0.0, float undef, float undef>, float %ext2, i32 2
  %ins2 = insertelement <4 x float> %ins1, float %ext1, i32 3
  ret <4 x float> %ins2
}

; Don't insert extractelements from the wider vector before the def of the index operand.

define <4 x i32> @extractelt_insertion(<2 x i32> %x, i32 %y) {
; CHECK-LABEL: @extractelt_insertion(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <2 x i32> [[X:%.*]], <2 x i32> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    [[B:%.*]] = shufflevector <4 x i32> <i32 0, i32 0, i32 0, i32 undef>, <4 x i32> [[TMP0]], <4 x i32> <i32 0, i32 1, i32 2, i32 5>
; CHECK-NEXT:    [[C:%.*]] = add i32 [[Y:%.*]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <4 x i32> [[TMP0]], i32 [[C]]
; CHECK-NEXT:    [[E:%.*]] = icmp eq i32 [[TMP1]], 0
; CHECK-NEXT:    [[RET:%.*]] = select i1 [[E]], <4 x i32> [[B]], <4 x i32> zeroinitializer
; CHECK-NEXT:    ret <4 x i32> [[RET]]
;
entry:
  %a = extractelement <2 x i32> %x, i32 1
  %b = insertelement <4 x i32> zeroinitializer, i32 %a, i64 3
  %c = add i32 %y, 3
  %d = extractelement <2 x i32> %x, i32 %c
  %e = icmp eq i32 %d, 0
  %ret = select i1 %e, <4 x i32> %b, <4 x i32> zeroinitializer
  ret <4 x i32> %ret
}

; PR34724: https://bugs.llvm.org/show_bug.cgi?id=34724

define <4 x float> @collectShuffleElts(<2 x float> %x, float %y) {
; CHECK-LABEL: @collectShuffleElts(
; CHECK-NEXT:    [[X0:%.*]] = extractelement <2 x float> [[X:%.*]], i32 0
; CHECK-NEXT:    [[X1:%.*]] = extractelement <2 x float> [[X]], i32 1
; CHECK-NEXT:    [[V1:%.*]] = insertelement <4 x float> undef, float [[X0]], i32 1
; CHECK-NEXT:    [[V2:%.*]] = insertelement <4 x float> [[V1]], float [[X1]], i32 2
; CHECK-NEXT:    [[V3:%.*]] = insertelement <4 x float> [[V2]], float [[Y:%.*]], i32 3
; CHECK-NEXT:    ret <4 x float> [[V3]]
;
  %x0 = extractelement <2 x float> %x, i32 0
  %x1 = extractelement <2 x float> %x, i32 1
  %v1 = insertelement <4 x float> undef, float %x0, i32 1
  %v2 = insertelement <4 x float> %v1, float %x1, i32 2
  %v3 = insertelement <4 x float> %v2, float %y, i32 3
  ret <4 x float> %v3
}

; Simplest case - insert scalar into undef, then shuffle that value in place into another vector.

define <4 x float> @insert_shuffle(float %x, <4 x float> %y) {
; CHECK-LABEL: @insert_shuffle(
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> [[Y:%.*]], float [[X:%.*]], i32 0
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xv = insertelement <4 x float> undef, float %x, i32 0
  %r = shufflevector <4 x float> %xv, <4 x float> %y, <4 x i32> <i32 0, i32 5, i32 6, i32 7>
  ret <4 x float> %r
}

; Insert scalar into some element of a dummy vector, then move it to a different element in another vector.

define <4 x float> @insert_shuffle_translate(float %x, <4 x float> %y) {
; CHECK-LABEL: @insert_shuffle_translate(
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> [[Y:%.*]], float [[X:%.*]], i32 1
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xv = insertelement <4 x float> undef, float %x, i32 0
  %r = shufflevector <4 x float> %xv, <4 x float> %y, <4 x i32> <i32 4, i32 0, i32 6, i32 7>
  ret <4 x float> %r
}

; The vector operand of the insert is irrelevant.

define <4 x float> @insert_not_undef_shuffle_translate(float %x, <4 x float> %y, <4 x float> %q) {
; CHECK-LABEL: @insert_not_undef_shuffle_translate(
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> [[Y:%.*]], float [[X:%.*]], i32 2
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xv = insertelement <4 x float> %q, float %x, i32 3
  %r = shufflevector <4 x float> %xv, <4 x float> %y, <4 x i32> <i32 4, i32 5, i32 3, i32 7>
  ret <4 x float> %r
}

; The insert may be the 2nd operand of the shuffle. The shuffle mask can include undef elements.

define <4 x float> @insert_not_undef_shuffle_translate_commute(float %x, <4 x float> %y, <4 x float> %q) {
; CHECK-LABEL: @insert_not_undef_shuffle_translate_commute(
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> [[Y:%.*]], float [[X:%.*]], i32 1
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xv = insertelement <4 x float> %q, float %x, i32 2
  %r = shufflevector <4 x float> %y, <4 x float> %xv, <4 x i32> <i32 0, i32 6, i32 2, i32 undef>
  ret <4 x float> %r
}

; Both shuffle operands may be inserts - choose the correct side.

define <4 x float> @insert_insert_shuffle_translate(float %x1, float %x2, <4 x float> %q) {
; CHECK-LABEL: @insert_insert_shuffle_translate(
; CHECK-NEXT:    [[XV2:%.*]] = insertelement <4 x float> [[Q:%.*]], float [[X2:%.*]], i32 2
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> [[XV2]], float [[X1:%.*]], i32 1
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xv1 = insertelement <4 x float> %q, float %x1, i32 0
  %xv2 = insertelement <4 x float> %q, float %x2, i32 2
  %r = shufflevector <4 x float> %xv1, <4 x float> %xv2, <4 x i32> <i32 4, i32 0, i32 6, i32 7>
  ret <4 x float> %r
}

; Both shuffle operands may be inserts - choose the correct side.

define <4 x float> @insert_insert_shuffle_translate_commute(float %x1, float %x2, <4 x float> %q) {
; CHECK-LABEL: @insert_insert_shuffle_translate_commute(
; CHECK-NEXT:    [[XV1:%.*]] = insertelement <4 x float> [[Q:%.*]], float [[X1:%.*]], i32 0
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> [[XV1]], float [[X2:%.*]], i32 1
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xv1 = insertelement <4 x float> %q, float %x1, i32 0
  %xv2 = insertelement <4 x float> %q, float %x2, i32 2
  %r = shufflevector <4 x float> %xv1, <4 x float> %xv2, <4 x i32> <i32 0, i32 6, i32 2, i32 3>
  ret <4 x float> %r
}

; Negative test - this only works if the shuffle is choosing exactly 1 element from 1 of the inputs.
; TODO: But this could be a special-case because we're inserting into the same base vector.

define <4 x float> @insert_insert_shuffle_translate_wrong_mask(float %x1, float %x2, <4 x float> %q) {
; CHECK-LABEL: @insert_insert_shuffle_translate_wrong_mask(
; CHECK-NEXT:    [[XV1:%.*]] = insertelement <4 x float> [[Q:%.*]], float [[X1:%.*]], i32 0
; CHECK-NEXT:    [[XV2:%.*]] = insertelement <4 x float> [[Q]], float [[X2:%.*]], i32 2
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[XV1]], <4 x float> [[XV2]], <4 x i32> <i32 0, i32 6, i32 2, i32 7>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xv1 = insertelement <4 x float> %q, float %x1, i32 0
  %xv2 = insertelement <4 x float> %q, float %x2, i32 2
  %r = shufflevector <4 x float> %xv1, <4 x float> %xv2, <4 x i32> <i32 0, i32 6, i32 2, i32 7>
  ret <4 x float> %r
}

; The insert may have other uses.

declare void @use(<4 x float>)

define <4 x float> @insert_not_undef_shuffle_translate_commute_uses(float %x, <4 x float> %y, <4 x float> %q) {
; CHECK-LABEL: @insert_not_undef_shuffle_translate_commute_uses(
; CHECK-NEXT:    [[XV:%.*]] = insertelement <4 x float> [[Q:%.*]], float [[X:%.*]], i32 2
; CHECK-NEXT:    call void @use(<4 x float> [[XV]])
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> [[Y:%.*]], float [[X]], i32 0
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xv = insertelement <4 x float> %q, float %x, i32 2
  call void @use(<4 x float> %xv)
  %r = shufflevector <4 x float> %y, <4 x float> %xv, <4 x i32> <i32 6, i32 undef, i32 2, i32 3>
  ret <4 x float> %r
}

; Negative test - size-changing shuffle.

define <5 x float> @insert_not_undef_shuffle_translate_commute_lengthen(float %x, <4 x float> %y, <4 x float> %q) {
; CHECK-LABEL: @insert_not_undef_shuffle_translate_commute_lengthen(
; CHECK-NEXT:    [[XV:%.*]] = insertelement <4 x float> undef, float [[X:%.*]], i32 2
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[Y:%.*]], <4 x float> [[XV]], <5 x i32> <i32 0, i32 6, i32 2, i32 undef, i32 undef>
; CHECK-NEXT:    ret <5 x float> [[R]]
;
  %xv = insertelement <4 x float> %q, float %x, i32 2
  %r = shufflevector <4 x float> %y, <4 x float> %xv, <5 x i32> <i32 0, i32 6, i32 2, i32 undef, i32 undef>
  ret <5 x float> %r
}

define <4 x float> @insert_nonzero_index_splat(float %x) {
; CHECK-LABEL: @insert_nonzero_index_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x float> undef, float [[X:%.*]], i32 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <4 x float> [[TMP1]], <4 x float> undef, <4 x i32> <i32 undef, i32 0, i32 0, i32 undef>
; CHECK-NEXT:    ret <4 x float> [[SPLAT]]
;
  %xv = insertelement <4 x float> undef, float %x, i32 2
  %splat = shufflevector <4 x float> %xv, <4 x float> undef, <4 x i32> <i32 undef, i32 2, i32 2, i32 undef>
  ret <4 x float> %splat
}

define <3 x double> @insert_nonzero_index_splat_narrow(double %x) {
; CHECK-LABEL: @insert_nonzero_index_splat_narrow(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <3 x double> undef, double [[X:%.*]], i32 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <3 x double> [[TMP1]], <3 x double> undef, <3 x i32> <i32 0, i32 undef, i32 0>
; CHECK-NEXT:    ret <3 x double> [[SPLAT]]
;
  %xv = insertelement <4 x double> undef, double %x, i32 3
  %splat = shufflevector <4 x double> %xv, <4 x double> undef, <3 x i32> <i32 3, i32 undef, i32 3>
  ret <3 x double> %splat
}

define <5 x i7> @insert_nonzero_index_splat_widen(i7 %x) {
; CHECK-LABEL: @insert_nonzero_index_splat_widen(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <5 x i7> undef, i7 [[X:%.*]], i32 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <5 x i7> [[TMP1]], <5 x i7> undef, <5 x i32> <i32 undef, i32 0, i32 0, i32 undef, i32 0>
; CHECK-NEXT:    ret <5 x i7> [[SPLAT]]
;
  %xv = insertelement <4 x i7> undef, i7 %x, i32 1
  %splat = shufflevector <4 x i7> %xv, <4 x i7> undef, <5 x i32> <i32 undef, i32 1, i32 1, i32 undef, i32 1>
  ret <5 x i7> %splat
}

; Negative test - don't increase instruction count

define <4 x float> @insert_nonzero_index_splat_extra_use(float %x) {
; CHECK-LABEL: @insert_nonzero_index_splat_extra_use(
; CHECK-NEXT:    [[XV:%.*]] = insertelement <4 x float> undef, float [[X:%.*]], i32 2
; CHECK-NEXT:    call void @use(<4 x float> [[XV]])
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <4 x float> [[XV]], <4 x float> undef, <4 x i32> <i32 undef, i32 2, i32 2, i32 undef>
; CHECK-NEXT:    ret <4 x float> [[SPLAT]]
;
  %xv = insertelement <4 x float> undef, float %x, i32 2
  call void @use(<4 x float> %xv)
  %splat = shufflevector <4 x float> %xv, <4 x float> undef, <4 x i32> <i32 undef, i32 2, i32 2, i32 undef>
  ret <4 x float> %splat
}

; Negative test - non-undef base vector

define <4 x float> @insert_nonzero_index_splat_wrong_base(float %x, <4 x float> %y) {
; CHECK-LABEL: @insert_nonzero_index_splat_wrong_base(
; CHECK-NEXT:    [[XV:%.*]] = insertelement <4 x float> [[Y:%.*]], float [[X:%.*]], i32 2
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <4 x float> [[XV]], <4 x float> undef, <4 x i32> <i32 undef, i32 2, i32 3, i32 undef>
; CHECK-NEXT:    ret <4 x float> [[SPLAT]]
;
  %xv = insertelement <4 x float> %y, float %x, i32 2
  %splat = shufflevector <4 x float> %xv, <4 x float> undef, <4 x i32> <i32 undef, i32 2, i32 3, i32 undef>
  ret <4 x float> %splat
}

; Negative test - non-constant insert index

define <4 x float> @insert_nonzero_index_splat_wrong_index(float %x, i32 %index) {
; CHECK-LABEL: @insert_nonzero_index_splat_wrong_index(
; CHECK-NEXT:    [[XV:%.*]] = insertelement <4 x float> undef, float [[X:%.*]], i32 [[INDEX:%.*]]
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <4 x float> [[XV]], <4 x float> undef, <4 x i32> <i32 undef, i32 1, i32 1, i32 undef>
; CHECK-NEXT:    ret <4 x float> [[SPLAT]]
;
  %xv = insertelement <4 x float> undef, float %x, i32 %index
  %splat = shufflevector <4 x float> %xv, <4 x float> undef, <4 x i32> <i32 undef, i32 1, i32 1, i32 undef>
  ret <4 x float> %splat
}

define <4 x float> @insert_in_splat(float %x) {
; CHECK-LABEL: @insert_in_splat(
; CHECK-NEXT:    [[XV:%.*]] = insertelement <4 x float> undef, float [[X:%.*]], i32 0
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[XV]], <4 x float> undef, <4 x i32> <i32 undef, i32 0, i32 0, i32 0>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xv = insertelement <4 x float> undef, float %x, i32 0
  %splat = shufflevector <4 x float> %xv, <4 x float> undef, <4 x i32> <i32 undef, i32 0, i32 0, i32 undef>
  %r = insertelement <4 x float> %splat, float %x, i32 3
  ret <4 x float> %r
}

define <4 x float> @insert_in_splat_extra_uses(float %x) {
; CHECK-LABEL: @insert_in_splat_extra_uses(
; CHECK-NEXT:    [[XV:%.*]] = insertelement <4 x float> undef, float [[X:%.*]], i32 0
; CHECK-NEXT:    call void @use(<4 x float> [[XV]])
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <4 x float> [[XV]], <4 x float> undef, <4 x i32> <i32 undef, i32 0, i32 0, i32 undef>
; CHECK-NEXT:    call void @use(<4 x float> [[SPLAT]])
; CHECK-NEXT:    [[R:%.*]] = shufflevector <4 x float> [[XV]], <4 x float> undef, <4 x i32> <i32 undef, i32 0, i32 0, i32 0>
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xv = insertelement <4 x float> undef, float %x, i32 0
  call void @use(<4 x float> %xv)
  %splat = shufflevector <4 x float> %xv, <4 x float> undef, <4 x i32> <i32 undef, i32 0, i32 0, i32 undef>
  call void @use(<4 x float> %splat)
  %r = insertelement <4 x float> %splat, float %x, i32 3
  ret <4 x float> %r
}

; Negative test - not a constant index insert

define <4 x float> @insert_in_splat_variable_index(float %x, i32 %y) {
; CHECK-LABEL: @insert_in_splat_variable_index(
; CHECK-NEXT:    [[XV:%.*]] = insertelement <4 x float> undef, float [[X:%.*]], i32 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <4 x float> [[XV]], <4 x float> undef, <4 x i32> <i32 undef, i32 0, i32 0, i32 undef>
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> [[SPLAT]], float [[X]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xv = insertelement <4 x float> undef, float %x, i32 0
  %splat = shufflevector <4 x float> %xv, <4 x float> undef, <4 x i32> <i32 undef, i32 0, i32 0, i32 undef>
  %r = insertelement <4 x float> %splat, float %x, i32 %y
  ret <4 x float> %r
}

; Negative test - not a splat shuffle

define <4 x float> @insert_in_nonsplat(float %x, <4 x float> %y) {
; CHECK-LABEL: @insert_in_nonsplat(
; CHECK-NEXT:    [[XV:%.*]] = insertelement <4 x float> undef, float [[X:%.*]], i32 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <4 x float> [[XV]], <4 x float> [[Y:%.*]], <4 x i32> <i32 undef, i32 0, i32 4, i32 undef>
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> [[SPLAT]], float [[X]], i32 3
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xv = insertelement <4 x float> undef, float %x, i32 0
  %splat = shufflevector <4 x float> %xv, <4 x float> %y, <4 x i32> <i32 undef, i32 0, i32 4, i32 undef>
  %r = insertelement <4 x float> %splat, float %x, i32 3
  ret <4 x float> %r
}

; Negative test - not a splat shuffle

define <4 x float> @insert_in_nonsplat2(float %x, <4 x float> %y) {
; CHECK-LABEL: @insert_in_nonsplat2(
; CHECK-NEXT:    [[XV:%.*]] = insertelement <4 x float> [[Y:%.*]], float [[X:%.*]], i32 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <4 x float> [[XV]], <4 x float> undef, <4 x i32> <i32 undef, i32 0, i32 1, i32 undef>
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> [[SPLAT]], float [[X]], i32 3
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %xv = insertelement <4 x float> %y, float %x, i32 0
  %splat = shufflevector <4 x float> %xv, <4 x float> undef, <4 x i32> <i32 undef, i32 0, i32 1, i32 undef>
  %r = insertelement <4 x float> %splat, float %x, i32 3
  ret <4 x float> %r
}

define <4 x i8> @shuf_identity_padding(<2 x i8> %x, i8 %y) {
; CHECK-LABEL: @shuf_identity_padding(
; CHECK-NEXT:    [[V1:%.*]] = shufflevector <2 x i8> [[X:%.*]], <2 x i8> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    [[V2:%.*]] = insertelement <4 x i8> [[V1]], i8 [[Y:%.*]], i32 2
; CHECK-NEXT:    ret <4 x i8> [[V2]]
;
  %v0 = shufflevector <2 x i8> %x, <2 x i8> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %x1 = extractelement <2 x i8> %x, i32 1
  %v1 = insertelement <4 x i8> %v0, i8 %x1, i32 1
  %v2 = insertelement <4 x i8> %v1, i8 %y, i32 2
  ret <4 x i8> %v2
}

define <3 x i8> @shuf_identity_extract(<4 x i8> %x, i8 %y) {
; CHECK-LABEL: @shuf_identity_extract(
; CHECK-NEXT:    [[V1:%.*]] = shufflevector <4 x i8> [[X:%.*]], <4 x i8> undef, <3 x i32> <i32 0, i32 1, i32 undef>
; CHECK-NEXT:    [[V2:%.*]] = insertelement <3 x i8> [[V1]], i8 [[Y:%.*]], i32 2
; CHECK-NEXT:    ret <3 x i8> [[V2]]
;
  %v0 = shufflevector <4 x i8> %x, <4 x i8> undef, <3 x i32> <i32 0, i32 undef, i32 undef>
  %x1 = extractelement <4 x i8> %x, i32 1
  %v1 = insertelement <3 x i8> %v0, i8 %x1, i32 1
  %v2 = insertelement <3 x i8> %v1, i8 %y, i32 2
  ret <3 x i8> %v2
}

define <4 x float> @shuf_identity_extract_extra_use(<6 x float> %x, float %y) {
; CHECK-LABEL: @shuf_identity_extract_extra_use(
; CHECK-NEXT:    [[V0:%.*]] = shufflevector <6 x float> [[X:%.*]], <6 x float> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 3>
; CHECK-NEXT:    call void @use(<4 x float> [[V0]])
; CHECK-NEXT:    [[V1:%.*]] = shufflevector <6 x float> [[X]], <6 x float> undef, <4 x i32> <i32 0, i32 undef, i32 2, i32 3>
; CHECK-NEXT:    [[V2:%.*]] = insertelement <4 x float> [[V1]], float [[Y:%.*]], i32 1
; CHECK-NEXT:    ret <4 x float> [[V2]]
;
  %v0 = shufflevector <6 x float> %x, <6 x float> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 3>
  call void @use(<4 x float> %v0)
  %x1 = extractelement <6 x float> %x, i32 2
  %v1 = insertelement <4 x float> %v0, float %x1, i32 2
  %v2 = insertelement <4 x float> %v1, float %y, i32 1
  ret <4 x float> %v2
}

; Negative test - can't map variable index to shuffle mask.

define <4 x i8> @shuf_identity_padding_variable_index(<2 x i8> %x, i8 %y, i32 %index) {
; CHECK-LABEL: @shuf_identity_padding_variable_index(
; CHECK-NEXT:    [[V0:%.*]] = shufflevector <2 x i8> [[X:%.*]], <2 x i8> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    [[X1:%.*]] = extractelement <2 x i8> [[X]], i32 [[INDEX:%.*]]
; CHECK-NEXT:    [[V1:%.*]] = insertelement <4 x i8> [[V0]], i8 [[X1]], i32 [[INDEX]]
; CHECK-NEXT:    [[V2:%.*]] = insertelement <4 x i8> [[V1]], i8 [[Y:%.*]], i32 2
; CHECK-NEXT:    ret <4 x i8> [[V2]]
;
  %v0 = shufflevector <2 x i8> %x, <2 x i8> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %x1 = extractelement <2 x i8> %x, i32 %index
  %v1 = insertelement <4 x i8> %v0, i8 %x1, i32 %index
  %v2 = insertelement <4 x i8> %v1, i8 %y, i32 2
  ret <4 x i8> %v2
}

; Negative test - don't create arbitrary shuffle masks.

define <4 x i8> @shuf_identity_padding_wrong_source_vec(<2 x i8> %x, i8 %y, <2 x i8> %other) {
; CHECK-LABEL: @shuf_identity_padding_wrong_source_vec(
; CHECK-NEXT:    [[V0:%.*]] = shufflevector <2 x i8> [[X:%.*]], <2 x i8> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[X1:%.*]] = extractelement <2 x i8> [[OTHER:%.*]], i32 1
; CHECK-NEXT:    [[V1:%.*]] = insertelement <4 x i8> [[V0]], i8 [[X1]], i32 1
; CHECK-NEXT:    [[V2:%.*]] = insertelement <4 x i8> [[V1]], i8 [[Y:%.*]], i32 2
; CHECK-NEXT:    ret <4 x i8> [[V2]]
;
  %v0 = shufflevector <2 x i8> %x, <2 x i8> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %x1 = extractelement <2 x i8> %other, i32 1
  %v1 = insertelement <4 x i8> %v0, i8 %x1, i32 1
  %v2 = insertelement <4 x i8> %v1, i8 %y, i32 2
  ret <4 x i8> %v2
}

; Negative test - don't create arbitrary shuffle masks.

define <4 x i8> @shuf_identity_padding_wrong_index(<2 x i8> %x, i8 %y) {
; CHECK-LABEL: @shuf_identity_padding_wrong_index(
; CHECK-NEXT:    [[V0:%.*]] = shufflevector <2 x i8> [[X:%.*]], <2 x i8> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    [[X1:%.*]] = extractelement <2 x i8> [[X]], i32 1
; CHECK-NEXT:    [[V1:%.*]] = insertelement <4 x i8> [[V0]], i8 [[X1]], i32 2
; CHECK-NEXT:    [[V2:%.*]] = insertelement <4 x i8> [[V1]], i8 [[Y:%.*]], i32 3
; CHECK-NEXT:    ret <4 x i8> [[V2]]
;
  %v0 = shufflevector <2 x i8> %x, <2 x i8> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  %x1 = extractelement <2 x i8> %x, i32 1
  %v1 = insertelement <4 x i8> %v0, i8 %x1, i32 2
  %v2 = insertelement <4 x i8> %v1, i8 %y, i32 3
  ret <4 x i8> %v2
}
