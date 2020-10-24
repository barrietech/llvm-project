; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
; Test that we only promote arguments when the caller/callee have compatible
; function attrubtes.

target triple = "x86_64-unknown-linux-gnu"

define internal fastcc void @no_promote_avx2(<4 x i64>* %arg, <4 x i64>* readonly %arg1) #0 {
; IS________OPM: Function Attrs: argmemonly inlinehint nofree norecurse nosync nounwind uwtable willreturn
; IS________OPM-LABEL: define {{[^@]+}}@no_promote_avx2
; IS________OPM-SAME: (<4 x i64>* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[ARG:%.*]], <4 x i64>* nocapture nofree noundef nonnull readonly align 32 dereferenceable(32) [[ARG1:%.*]]) [[ATTR0:#.*]] {
; IS________OPM-NEXT:  bb:
; IS________OPM-NEXT:    [[TMP:%.*]] = load <4 x i64>, <4 x i64>* [[ARG1]], align 32
; IS________OPM-NEXT:    store <4 x i64> [[TMP]], <4 x i64>* [[ARG]], align 32
; IS________OPM-NEXT:    ret void
;
; IS________NPM: Function Attrs: argmemonly inlinehint nofree norecurse nosync nounwind uwtable willreturn
; IS________NPM-LABEL: define {{[^@]+}}@no_promote_avx2
; IS________NPM-SAME: (<4 x i64>* noalias nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[ARG:%.*]], <4 x i64>* noalias nocapture nofree noundef nonnull readonly align 32 dereferenceable(32) [[ARG1:%.*]]) [[ATTR0:#.*]] {
; IS________NPM-NEXT:  bb:
; IS________NPM-NEXT:    [[TMP:%.*]] = load <4 x i64>, <4 x i64>* [[ARG1]], align 32
; IS________NPM-NEXT:    store <4 x i64> [[TMP]], <4 x i64>* [[ARG]], align 32
; IS________NPM-NEXT:    ret void
;
bb:
  %tmp = load <4 x i64>, <4 x i64>* %arg1
  store <4 x i64> %tmp, <4 x i64>* %arg
  ret void
}

define void @no_promote(<4 x i64>* %arg) #1 {
; IS__TUNIT_OPM: Function Attrs: argmemonly nofree nosync nounwind uwtable willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@no_promote
; IS__TUNIT_OPM-SAME: (<4 x i64>* nocapture nofree writeonly [[ARG:%.*]]) [[ATTR1:#.*]] {
; IS__TUNIT_OPM-NEXT:  bb:
; IS__TUNIT_OPM-NEXT:    [[TMP:%.*]] = alloca <4 x i64>, align 32
; IS__TUNIT_OPM-NEXT:    [[TMP2:%.*]] = alloca <4 x i64>, align 32
; IS__TUNIT_OPM-NEXT:    [[TMP3:%.*]] = bitcast <4 x i64>* [[TMP]] to i8*
; IS__TUNIT_OPM-NEXT:    call void @llvm.memset.p0i8.i64(i8* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP3]], i8 noundef 0, i64 noundef 32, i1 noundef false) [[ATTR3:#.*]]
; IS__TUNIT_OPM-NEXT:    call fastcc void @no_promote_avx2(<4 x i64>* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP2]], <4 x i64>* nocapture nofree noundef nonnull readonly align 32 dereferenceable(32) [[TMP]]) [[ATTR4:#.*]]
; IS__TUNIT_OPM-NEXT:    [[TMP4:%.*]] = load <4 x i64>, <4 x i64>* [[TMP2]], align 32
; IS__TUNIT_OPM-NEXT:    store <4 x i64> [[TMP4]], <4 x i64>* [[ARG]], align 2
; IS__TUNIT_OPM-NEXT:    ret void
;
; IS__TUNIT_NPM: Function Attrs: argmemonly nofree nosync nounwind uwtable willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@no_promote
; IS__TUNIT_NPM-SAME: (<4 x i64>* nocapture nofree writeonly [[ARG:%.*]]) [[ATTR1:#.*]] {
; IS__TUNIT_NPM-NEXT:  bb:
; IS__TUNIT_NPM-NEXT:    [[TMP:%.*]] = alloca <4 x i64>, align 32
; IS__TUNIT_NPM-NEXT:    [[TMP2:%.*]] = alloca <4 x i64>, align 32
; IS__TUNIT_NPM-NEXT:    [[TMP3:%.*]] = bitcast <4 x i64>* [[TMP]] to i8*
; IS__TUNIT_NPM-NEXT:    call void @llvm.memset.p0i8.i64(i8* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP3]], i8 noundef 0, i64 noundef 32, i1 noundef false) [[ATTR3:#.*]]
; IS__TUNIT_NPM-NEXT:    call fastcc void @no_promote_avx2(<4 x i64>* noalias nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP2]], <4 x i64>* noalias nocapture nofree noundef nonnull readonly align 32 dereferenceable(32) [[TMP]]) [[ATTR4:#.*]]
; IS__TUNIT_NPM-NEXT:    [[TMP4:%.*]] = load <4 x i64>, <4 x i64>* [[TMP2]], align 32
; IS__TUNIT_NPM-NEXT:    store <4 x i64> [[TMP4]], <4 x i64>* [[ARG]], align 2
; IS__TUNIT_NPM-NEXT:    ret void
;
; IS__CGSCC_OPM: Function Attrs: argmemonly nofree nosync nounwind uwtable willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@no_promote
; IS__CGSCC_OPM-SAME: (<4 x i64>* nocapture nofree nonnull writeonly align 2 dereferenceable(32) [[ARG:%.*]]) [[ATTR1:#.*]] {
; IS__CGSCC_OPM-NEXT:  bb:
; IS__CGSCC_OPM-NEXT:    [[TMP:%.*]] = alloca <4 x i64>, align 32
; IS__CGSCC_OPM-NEXT:    [[TMP2:%.*]] = alloca <4 x i64>, align 32
; IS__CGSCC_OPM-NEXT:    [[TMP3:%.*]] = bitcast <4 x i64>* [[TMP]] to i8*
; IS__CGSCC_OPM-NEXT:    call void @llvm.memset.p0i8.i64(i8* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP3]], i8 noundef 0, i64 noundef 32, i1 noundef false) [[ATTR3:#.*]]
; IS__CGSCC_OPM-NEXT:    call fastcc void @no_promote_avx2(<4 x i64>* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP2]], <4 x i64>* nocapture nofree noundef nonnull readonly align 32 dereferenceable(32) [[TMP]]) [[ATTR4:#.*]]
; IS__CGSCC_OPM-NEXT:    [[TMP4:%.*]] = load <4 x i64>, <4 x i64>* [[TMP2]], align 32
; IS__CGSCC_OPM-NEXT:    store <4 x i64> [[TMP4]], <4 x i64>* [[ARG]], align 2
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM: Function Attrs: argmemonly nofree nosync nounwind uwtable willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@no_promote
; IS__CGSCC_NPM-SAME: (<4 x i64>* nocapture nofree nonnull writeonly align 2 dereferenceable(32) [[ARG:%.*]]) [[ATTR1:#.*]] {
; IS__CGSCC_NPM-NEXT:  bb:
; IS__CGSCC_NPM-NEXT:    [[TMP:%.*]] = alloca <4 x i64>, align 32
; IS__CGSCC_NPM-NEXT:    [[TMP2:%.*]] = alloca <4 x i64>, align 32
; IS__CGSCC_NPM-NEXT:    [[TMP3:%.*]] = bitcast <4 x i64>* [[TMP]] to i8*
; IS__CGSCC_NPM-NEXT:    call void @llvm.memset.p0i8.i64(i8* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP3]], i8 noundef 0, i64 noundef 32, i1 noundef false) [[ATTR3:#.*]]
; IS__CGSCC_NPM-NEXT:    call fastcc void @no_promote_avx2(<4 x i64>* noalias nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP2]], <4 x i64>* noalias nocapture nofree noundef nonnull readonly align 32 dereferenceable(32) [[TMP]]) [[ATTR4:#.*]]
; IS__CGSCC_NPM-NEXT:    [[TMP4:%.*]] = load <4 x i64>, <4 x i64>* [[TMP2]], align 32
; IS__CGSCC_NPM-NEXT:    store <4 x i64> [[TMP4]], <4 x i64>* [[ARG]], align 2
; IS__CGSCC_NPM-NEXT:    ret void
;
bb:
  %tmp = alloca <4 x i64>, align 32
  %tmp2 = alloca <4 x i64>, align 32
  %tmp3 = bitcast <4 x i64>* %tmp to i8*
  call void @llvm.memset.p0i8.i64(i8* align 32 %tmp3, i8 0, i64 32, i1 false)
  call fastcc void @no_promote_avx2(<4 x i64>* %tmp2, <4 x i64>* %tmp)
  %tmp4 = load <4 x i64>, <4 x i64>* %tmp2, align 32
  store <4 x i64> %tmp4, <4 x i64>* %arg, align 2
  ret void
}

define internal fastcc void @promote_avx2(<4 x i64>* %arg, <4 x i64>* readonly %arg1) #0 {
; IS________OPM: Function Attrs: argmemonly inlinehint nofree norecurse nosync nounwind uwtable willreturn
; IS________OPM-LABEL: define {{[^@]+}}@promote_avx2
; IS________OPM-SAME: (<4 x i64>* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[ARG:%.*]], <4 x i64>* nocapture nofree noundef nonnull readonly align 32 dereferenceable(32) [[ARG1:%.*]]) [[ATTR0]] {
; IS________OPM-NEXT:  bb:
; IS________OPM-NEXT:    [[TMP:%.*]] = load <4 x i64>, <4 x i64>* [[ARG1]], align 32
; IS________OPM-NEXT:    store <4 x i64> [[TMP]], <4 x i64>* [[ARG]], align 32
; IS________OPM-NEXT:    ret void
;
; IS________NPM: Function Attrs: argmemonly inlinehint nofree norecurse nosync nounwind uwtable willreturn
; IS________NPM-LABEL: define {{[^@]+}}@promote_avx2
; IS________NPM-SAME: (<4 x i64>* noalias nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[ARG:%.*]], <4 x i64> [[TMP0:%.*]]) [[ATTR0]] {
; IS________NPM-NEXT:  bb:
; IS________NPM-NEXT:    [[ARG1_PRIV:%.*]] = alloca <4 x i64>, align 32
; IS________NPM-NEXT:    store <4 x i64> [[TMP0]], <4 x i64>* [[ARG1_PRIV]], align 32
; IS________NPM-NEXT:    [[TMP:%.*]] = load <4 x i64>, <4 x i64>* [[ARG1_PRIV]], align 32
; IS________NPM-NEXT:    store <4 x i64> [[TMP]], <4 x i64>* [[ARG]], align 32
; IS________NPM-NEXT:    ret void
;
bb:
  %tmp = load <4 x i64>, <4 x i64>* %arg1
  store <4 x i64> %tmp, <4 x i64>* %arg
  ret void
}

define void @promote(<4 x i64>* %arg) #0 {
; IS__TUNIT_OPM: Function Attrs: argmemonly inlinehint nofree norecurse nosync nounwind uwtable willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@promote
; IS__TUNIT_OPM-SAME: (<4 x i64>* nocapture nofree writeonly [[ARG:%.*]]) [[ATTR0:#.*]] {
; IS__TUNIT_OPM-NEXT:  bb:
; IS__TUNIT_OPM-NEXT:    [[TMP:%.*]] = alloca <4 x i64>, align 32
; IS__TUNIT_OPM-NEXT:    [[TMP2:%.*]] = alloca <4 x i64>, align 32
; IS__TUNIT_OPM-NEXT:    [[TMP3:%.*]] = bitcast <4 x i64>* [[TMP]] to i8*
; IS__TUNIT_OPM-NEXT:    call void @llvm.memset.p0i8.i64(i8* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP3]], i8 noundef 0, i64 noundef 32, i1 noundef false) [[ATTR3]]
; IS__TUNIT_OPM-NEXT:    call fastcc void @promote_avx2(<4 x i64>* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP2]], <4 x i64>* nocapture nofree noundef nonnull readonly align 32 dereferenceable(32) [[TMP]]) [[ATTR4]]
; IS__TUNIT_OPM-NEXT:    [[TMP4:%.*]] = load <4 x i64>, <4 x i64>* [[TMP2]], align 32
; IS__TUNIT_OPM-NEXT:    store <4 x i64> [[TMP4]], <4 x i64>* [[ARG]], align 2
; IS__TUNIT_OPM-NEXT:    ret void
;
; IS__TUNIT_NPM: Function Attrs: argmemonly inlinehint nofree norecurse nosync nounwind uwtable willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@promote
; IS__TUNIT_NPM-SAME: (<4 x i64>* nocapture nofree writeonly [[ARG:%.*]]) [[ATTR0:#.*]] {
; IS__TUNIT_NPM-NEXT:  bb:
; IS__TUNIT_NPM-NEXT:    [[TMP:%.*]] = alloca <4 x i64>, align 32
; IS__TUNIT_NPM-NEXT:    [[TMP2:%.*]] = alloca <4 x i64>, align 32
; IS__TUNIT_NPM-NEXT:    [[TMP3:%.*]] = bitcast <4 x i64>* [[TMP]] to i8*
; IS__TUNIT_NPM-NEXT:    call void @llvm.memset.p0i8.i64(i8* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP3]], i8 noundef 0, i64 noundef 32, i1 noundef false) [[ATTR3]]
; IS__TUNIT_NPM-NEXT:    [[TMP0:%.*]] = load <4 x i64>, <4 x i64>* [[TMP]], align 32
; IS__TUNIT_NPM-NEXT:    call fastcc void @promote_avx2(<4 x i64>* noalias nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP2]], <4 x i64> [[TMP0]]) [[ATTR4]]
; IS__TUNIT_NPM-NEXT:    [[TMP4:%.*]] = load <4 x i64>, <4 x i64>* [[TMP2]], align 32
; IS__TUNIT_NPM-NEXT:    store <4 x i64> [[TMP4]], <4 x i64>* [[ARG]], align 2
; IS__TUNIT_NPM-NEXT:    ret void
;
; IS__CGSCC_OPM: Function Attrs: argmemonly inlinehint nofree norecurse nosync nounwind uwtable willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@promote
; IS__CGSCC_OPM-SAME: (<4 x i64>* nocapture nofree nonnull writeonly align 2 dereferenceable(32) [[ARG:%.*]]) [[ATTR0:#.*]] {
; IS__CGSCC_OPM-NEXT:  bb:
; IS__CGSCC_OPM-NEXT:    [[TMP:%.*]] = alloca <4 x i64>, align 32
; IS__CGSCC_OPM-NEXT:    [[TMP2:%.*]] = alloca <4 x i64>, align 32
; IS__CGSCC_OPM-NEXT:    [[TMP3:%.*]] = bitcast <4 x i64>* [[TMP]] to i8*
; IS__CGSCC_OPM-NEXT:    call void @llvm.memset.p0i8.i64(i8* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP3]], i8 noundef 0, i64 noundef 32, i1 noundef false) [[ATTR3]]
; IS__CGSCC_OPM-NEXT:    call fastcc void @promote_avx2(<4 x i64>* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP2]], <4 x i64>* nocapture nofree noundef nonnull readonly align 32 dereferenceable(32) [[TMP]]) [[ATTR4]]
; IS__CGSCC_OPM-NEXT:    [[TMP4:%.*]] = load <4 x i64>, <4 x i64>* [[TMP2]], align 32
; IS__CGSCC_OPM-NEXT:    store <4 x i64> [[TMP4]], <4 x i64>* [[ARG]], align 2
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM: Function Attrs: argmemonly inlinehint nofree norecurse nosync nounwind uwtable willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@promote
; IS__CGSCC_NPM-SAME: (<4 x i64>* nocapture nofree nonnull writeonly align 2 dereferenceable(32) [[ARG:%.*]]) [[ATTR0:#.*]] {
; IS__CGSCC_NPM-NEXT:  bb:
; IS__CGSCC_NPM-NEXT:    [[TMP:%.*]] = alloca <4 x i64>, align 32
; IS__CGSCC_NPM-NEXT:    [[TMP2:%.*]] = alloca <4 x i64>, align 32
; IS__CGSCC_NPM-NEXT:    [[TMP3:%.*]] = bitcast <4 x i64>* [[TMP]] to i8*
; IS__CGSCC_NPM-NEXT:    call void @llvm.memset.p0i8.i64(i8* nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP3]], i8 noundef 0, i64 noundef 32, i1 noundef false) [[ATTR3]]
; IS__CGSCC_NPM-NEXT:    [[TMP0:%.*]] = load <4 x i64>, <4 x i64>* [[TMP]], align 32
; IS__CGSCC_NPM-NEXT:    call fastcc void @promote_avx2(<4 x i64>* noalias nocapture nofree noundef nonnull writeonly align 32 dereferenceable(32) [[TMP2]], <4 x i64> [[TMP0]]) [[ATTR4]]
; IS__CGSCC_NPM-NEXT:    [[TMP4:%.*]] = load <4 x i64>, <4 x i64>* [[TMP2]], align 32
; IS__CGSCC_NPM-NEXT:    store <4 x i64> [[TMP4]], <4 x i64>* [[ARG]], align 2
; IS__CGSCC_NPM-NEXT:    ret void
;
bb:
  %tmp = alloca <4 x i64>, align 32
  %tmp2 = alloca <4 x i64>, align 32
  %tmp3 = bitcast <4 x i64>* %tmp to i8*
  call void @llvm.memset.p0i8.i64(i8* align 32 %tmp3, i8 0, i64 32, i1 false)
  call fastcc void @promote_avx2(<4 x i64>* %tmp2, <4 x i64>* %tmp)
  %tmp4 = load <4 x i64>, <4 x i64>* %tmp2, align 32
  store <4 x i64> %tmp4, <4 x i64>* %arg, align 2
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) #2

attributes #0 = { inlinehint norecurse nounwind uwtable "target-features"="+avx2" }
attributes #1 = { nounwind uwtable }
attributes #2 = { argmemonly nounwind }
