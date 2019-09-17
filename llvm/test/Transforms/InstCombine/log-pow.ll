; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define double @log_pow(double %x, double %y) {
; CHECK-LABEL: @log_pow(
; CHECK-NEXT:    [[LOG1:%.*]] = call fast double @log(double [[X:%.*]]) #0
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast double [[LOG1]], [[Y:%.*]]
; CHECK-NEXT:    ret double [[MUL]]
;
  %pow = call fast double @pow(double %x, double %y)
  %log = call fast double @log(double %pow)
  ret double %log
}

; FIXME: log10f() should also be simplified.
define float @log10f_powf(float %x, float %y) {
; CHECK-LABEL: @log10f_powf(
; CHECK-NEXT:    [[POW:%.*]] = call fast float @powf(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[LOG:%.*]] = call fast float @log10f(float [[POW]])
; CHECK-NEXT:    ret float [[LOG]]
;
  %pow = call fast float @powf(float %x, float %y)
  %log = call fast float @log10f(float %pow)
  ret float %log
}

; FIXME: Intrinsic log2() should also be simplified.
define <2 x double> @log2v_powv(<2 x double> %x, <2 x double> %y) {
; CHECK-LABEL: @log2v_powv(
; CHECK-NEXT:    [[POW:%.*]] = call fast <2 x double> @llvm.pow.v2f64(<2 x double> [[X:%.*]], <2 x double> [[Y:%.*]])
; CHECK-NEXT:    [[LOG:%.*]] = call fast <2 x double> @llvm.log2.v2f64(<2 x double> [[POW]])
; CHECK-NEXT:    ret <2 x double> [[LOG]]
;
  %pow = call fast <2 x double> @llvm.pow.v2f64(<2 x double> %x, <2 x double> %y)
  %log = call fast <2 x double> @llvm.log2.v2f64(<2 x double> %pow)
  ret <2 x double> %log
}

define double @log_pow_not_fast(double %x, double %y) {
; CHECK-LABEL: @log_pow_not_fast(
; CHECK-NEXT:    [[POW:%.*]] = call double @pow(double [[X:%.*]], double [[Y:%.*]])
; CHECK-NEXT:    [[LOG:%.*]] = call fast double @log(double [[POW]])
; CHECK-NEXT:    ret double [[LOG]]
;
  %pow = call double @pow(double %x, double %y)
  %log = call fast double @log(double %pow)
  ret double %log
}

define float @function_pointer(float ()* %fptr, float %p1) {
; CHECK-LABEL: @function_pointer(
; CHECK-NEXT:    [[PTR:%.*]] = call float [[FPTR:%.*]]()
; CHECK-NEXT:    [[LOG:%.*]] = call float @logf(float [[PTR]])
; CHECK-NEXT:    ret float [[LOG]]
;
  %ptr = call float %fptr()
  %log = call float @logf(float %ptr)
  ret float %log
}

; FIXME: The call to exp2() should be removed.
define double @log_exp2(double %x) {
; CHECK-LABEL: @log_exp2(
; CHECK-NEXT:    [[EXP:%.*]] = call fast double @exp2(double [[X:%.*]])
; CHECK-NEXT:    [[LOGMUL:%.*]] = fmul fast double [[X]], 0x3FE62E42FEFA39EF
; CHECK-NEXT:    ret double [[LOGMUL]]
;
  %exp = call fast double @exp2(double %x)
  %log = call fast double @log(double %exp)
  ret double %log
}

; FIXME: Intrinsic logf() should also be simplified.
define <2 x float> @logv_exp2v(<2 x float> %x) {
; CHECK-LABEL: @logv_exp2v(
; CHECK-NEXT:    [[EXP:%.*]] = call fast <2 x float> @llvm.exp2.v2f32(<2 x float> [[X:%.*]])
; CHECK-NEXT:    [[LOG:%.*]] = call fast <2 x float> @llvm.log.v2f32(<2 x float> [[EXP]])
; CHECK-NEXT:    ret <2 x float> [[LOG]]
;
  %exp = call fast <2 x float> @llvm.exp2.v2f32(<2 x float> %x)
  %log = call fast <2 x float> @llvm.log.v2f32(<2 x float> %exp)
  ret <2 x float> %log
}

; FIXME: log10f() should also be simplified.
define float @log10f_exp2f(float %x) {
; CHECK-LABEL: @log10f_exp2f(
; CHECK-NEXT:    [[EXP:%.*]] = call fast float @exp2f(float [[X:%.*]])
; CHECK-NEXT:    [[LOG:%.*]] = call fast float @log10f(float [[EXP]])
; CHECK-NEXT:    ret float [[LOG]]
;
  %exp = call fast float @exp2f(float %x)
  %log = call fast float @log10f(float %exp)
  ret float %log
}

define double @log_exp2_not_fast(double %x) {
; CHECK-LABEL: @log_exp2_not_fast(
; CHECK-NEXT:    [[EXP:%.*]] = call double @exp2(double [[X:%.*]])
; CHECK-NEXT:    [[LOG:%.*]] = call fast double @log(double [[EXP]])
; CHECK-NEXT:    ret double [[LOG]]
;
  %exp = call double @exp2(double %x)
  %log = call fast double @log(double %exp)
  ret double %log
}

declare double @log(double) #0
declare float @logf(float) #0
declare <2 x float> @llvm.log.v2f32(<2 x float>)
declare double @log2(double) #0
declare <2 x double> @llvm.log2.v2f64(<2 x double>)
declare float @log10f(float) #0
declare double @exp2(double)
declare float @exp2f(float)
declare <2 x float> @llvm.exp2.v2f32(<2 x float>)
declare double @pow(double, double) #0
declare float @powf(float, float) #0
declare <2 x double> @llvm.pow.v2f64(<2 x double>, <2 x double>)

attributes #0 = { nounwind readnone }
