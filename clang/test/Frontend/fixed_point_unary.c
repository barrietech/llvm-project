// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple x86_64-unknown-linux-gnu -ffixed-point -S -emit-llvm %s -o - | FileCheck %s --check-prefixes=CHECK,SIGNED
// RUN: %clang_cc1 -triple x86_64-unknown-linux-gnu -ffixed-point -fpadding-on-unsigned-fixed-point -S -emit-llvm %s -o - | FileCheck %s --check-prefixes=CHECK,UNSIGNED

_Accum a;
_Fract f;
long _Fract lf;
unsigned _Accum ua;
short unsigned _Accum usa;
unsigned _Fract uf;

_Sat _Accum sa;
_Sat _Fract sf;
_Sat long _Fract slf;
_Sat unsigned _Accum sua;
_Sat short unsigned _Accum susa;
_Sat unsigned _Fract suf;

int i;

// CHECK-LABEL: @inc_a(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @a, align 4
// CHECK-NEXT:    [[TMP1:%.*]] = sub i32 [[TMP0]], -32768
// CHECK-NEXT:    store i32 [[TMP1]], i32* @a, align 4
// CHECK-NEXT:    ret void
//
void inc_a() {
  a++;
}

// CHECK-LABEL: @inc_f(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* @f, align 2
// CHECK-NEXT:    [[TMP1:%.*]] = sub i16 [[TMP0]], -32768
// CHECK-NEXT:    store i16 [[TMP1]], i16* @f, align 2
// CHECK-NEXT:    ret void
//
void inc_f() {
  f++;
}

// CHECK-LABEL: @inc_lf(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @lf, align 4
// CHECK-NEXT:    [[TMP1:%.*]] = sub i32 [[TMP0]], -2147483648
// CHECK-NEXT:    store i32 [[TMP1]], i32* @lf, align 4
// CHECK-NEXT:    ret void
//
void inc_lf() {
  lf++;
}

// SIGNED-LABEL: @inc_ua(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i32, i32* @ua, align 4
// SIGNED-NEXT:    [[TMP1:%.*]] = add i32 [[TMP0]], 65536
// SIGNED-NEXT:    store i32 [[TMP1]], i32* @ua, align 4
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @inc_ua(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i32, i32* @ua, align 4
// UNSIGNED-NEXT:    [[TMP1:%.*]] = add i32 [[TMP0]], 32768
// UNSIGNED-NEXT:    store i32 [[TMP1]], i32* @ua, align 4
// UNSIGNED-NEXT:    ret void
//
void inc_ua() {
  ua++;
}

// SIGNED-LABEL: @inc_usa(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @usa, align 2
// SIGNED-NEXT:    [[TMP1:%.*]] = add i16 [[TMP0]], 256
// SIGNED-NEXT:    store i16 [[TMP1]], i16* @usa, align 2
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @inc_usa(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @usa, align 2
// UNSIGNED-NEXT:    [[TMP1:%.*]] = add i16 [[TMP0]], 128
// UNSIGNED-NEXT:    store i16 [[TMP1]], i16* @usa, align 2
// UNSIGNED-NEXT:    ret void
//
void inc_usa() {
  usa++;
}

// SIGNED-LABEL: @inc_uf(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @uf, align 2
// SIGNED-NEXT:    [[TMP1:%.*]] = add i16 [[TMP0]], undef
// SIGNED-NEXT:    store i16 [[TMP1]], i16* @uf, align 2
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @inc_uf(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @uf, align 2
// UNSIGNED-NEXT:    [[TMP1:%.*]] = add i16 [[TMP0]], -32768
// UNSIGNED-NEXT:    store i16 [[TMP1]], i16* @uf, align 2
// UNSIGNED-NEXT:    ret void
//
void inc_uf() {
  uf++;
}

// CHECK-LABEL: @inc_sa(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @sa, align 4
// CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.ssub.sat.i32(i32 [[TMP0]], i32 -32768)
// CHECK-NEXT:    store i32 [[TMP1]], i32* @sa, align 4
// CHECK-NEXT:    ret void
//
void inc_sa() {
  sa++;
}

// CHECK-LABEL: @inc_sf(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* @sf, align 2
// CHECK-NEXT:    [[TMP1:%.*]] = call i16 @llvm.ssub.sat.i16(i16 [[TMP0]], i16 -32768)
// CHECK-NEXT:    store i16 [[TMP1]], i16* @sf, align 2
// CHECK-NEXT:    ret void
//
void inc_sf() {
  sf++;
}

// CHECK-LABEL: @inc_slf(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @slf, align 4
// CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.ssub.sat.i32(i32 [[TMP0]], i32 -2147483648)
// CHECK-NEXT:    store i32 [[TMP1]], i32* @slf, align 4
// CHECK-NEXT:    ret void
//
void inc_slf() {
  slf++;
}

// SIGNED-LABEL: @inc_sua(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i32, i32* @sua, align 4
// SIGNED-NEXT:    [[TMP1:%.*]] = call i32 @llvm.uadd.sat.i32(i32 [[TMP0]], i32 65536)
// SIGNED-NEXT:    store i32 [[TMP1]], i32* @sua, align 4
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @inc_sua(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i32, i32* @sua, align 4
// UNSIGNED-NEXT:    [[RESIZE:%.*]] = trunc i32 [[TMP0]] to i31
// UNSIGNED-NEXT:    [[TMP1:%.*]] = call i31 @llvm.uadd.sat.i31(i31 [[RESIZE]], i31 32768)
// UNSIGNED-NEXT:    [[RESIZE1:%.*]] = zext i31 [[TMP1]] to i32
// UNSIGNED-NEXT:    store i32 [[RESIZE1]], i32* @sua, align 4
// UNSIGNED-NEXT:    ret void
//
void inc_sua() {
  sua++;
}

// SIGNED-LABEL: @inc_susa(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @susa, align 2
// SIGNED-NEXT:    [[TMP1:%.*]] = call i16 @llvm.uadd.sat.i16(i16 [[TMP0]], i16 256)
// SIGNED-NEXT:    store i16 [[TMP1]], i16* @susa, align 2
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @inc_susa(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @susa, align 2
// UNSIGNED-NEXT:    [[RESIZE:%.*]] = trunc i16 [[TMP0]] to i15
// UNSIGNED-NEXT:    [[TMP1:%.*]] = call i15 @llvm.uadd.sat.i15(i15 [[RESIZE]], i15 128)
// UNSIGNED-NEXT:    [[RESIZE1:%.*]] = zext i15 [[TMP1]] to i16
// UNSIGNED-NEXT:    store i16 [[RESIZE1]], i16* @susa, align 2
// UNSIGNED-NEXT:    ret void
//
void inc_susa() {
  susa++;
}

// SIGNED-LABEL: @inc_suf(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @suf, align 2
// SIGNED-NEXT:    [[TMP1:%.*]] = call i16 @llvm.uadd.sat.i16(i16 [[TMP0]], i16 -1)
// SIGNED-NEXT:    store i16 [[TMP1]], i16* @suf, align 2
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @inc_suf(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @suf, align 2
// UNSIGNED-NEXT:    [[RESIZE:%.*]] = trunc i16 [[TMP0]] to i15
// UNSIGNED-NEXT:    [[TMP1:%.*]] = call i15 @llvm.uadd.sat.i15(i15 [[RESIZE]], i15 -1)
// UNSIGNED-NEXT:    [[RESIZE1:%.*]] = zext i15 [[TMP1]] to i16
// UNSIGNED-NEXT:    store i16 [[RESIZE1]], i16* @suf, align 2
// UNSIGNED-NEXT:    ret void
//
void inc_suf() {
  suf++;
}


// CHECK-LABEL: @dec_a(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @a, align 4
// CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[TMP0]], -32768
// CHECK-NEXT:    store i32 [[TMP1]], i32* @a, align 4
// CHECK-NEXT:    ret void
//
void dec_a() {
  a--;
}

// CHECK-LABEL: @dec_f(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* @f, align 2
// CHECK-NEXT:    [[TMP1:%.*]] = add i16 [[TMP0]], -32768
// CHECK-NEXT:    store i16 [[TMP1]], i16* @f, align 2
// CHECK-NEXT:    ret void
//
void dec_f() {
  f--;
}

// CHECK-LABEL: @dec_lf(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @lf, align 4
// CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[TMP0]], -2147483648
// CHECK-NEXT:    store i32 [[TMP1]], i32* @lf, align 4
// CHECK-NEXT:    ret void
//
void dec_lf() {
  lf--;
}

// SIGNED-LABEL: @dec_ua(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i32, i32* @ua, align 4
// SIGNED-NEXT:    [[TMP1:%.*]] = sub i32 [[TMP0]], 65536
// SIGNED-NEXT:    store i32 [[TMP1]], i32* @ua, align 4
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @dec_ua(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i32, i32* @ua, align 4
// UNSIGNED-NEXT:    [[TMP1:%.*]] = sub i32 [[TMP0]], 32768
// UNSIGNED-NEXT:    store i32 [[TMP1]], i32* @ua, align 4
// UNSIGNED-NEXT:    ret void
//
void dec_ua() {
  ua--;
}

// SIGNED-LABEL: @dec_usa(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @usa, align 2
// SIGNED-NEXT:    [[TMP1:%.*]] = sub i16 [[TMP0]], 256
// SIGNED-NEXT:    store i16 [[TMP1]], i16* @usa, align 2
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @dec_usa(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @usa, align 2
// UNSIGNED-NEXT:    [[TMP1:%.*]] = sub i16 [[TMP0]], 128
// UNSIGNED-NEXT:    store i16 [[TMP1]], i16* @usa, align 2
// UNSIGNED-NEXT:    ret void
//
void dec_usa() {
  usa--;
}

// SIGNED-LABEL: @dec_uf(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @uf, align 2
// SIGNED-NEXT:    [[TMP1:%.*]] = sub i16 [[TMP0]], undef
// SIGNED-NEXT:    store i16 [[TMP1]], i16* @uf, align 2
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @dec_uf(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @uf, align 2
// UNSIGNED-NEXT:    [[TMP1:%.*]] = sub i16 [[TMP0]], -32768
// UNSIGNED-NEXT:    store i16 [[TMP1]], i16* @uf, align 2
// UNSIGNED-NEXT:    ret void
//
void dec_uf() {
  uf--;
}

// CHECK-LABEL: @dec_sa(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @sa, align 4
// CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.sadd.sat.i32(i32 [[TMP0]], i32 -32768)
// CHECK-NEXT:    store i32 [[TMP1]], i32* @sa, align 4
// CHECK-NEXT:    ret void
//
void dec_sa() {
  sa--;
}

// CHECK-LABEL: @dec_sf(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* @sf, align 2
// CHECK-NEXT:    [[TMP1:%.*]] = call i16 @llvm.sadd.sat.i16(i16 [[TMP0]], i16 -32768)
// CHECK-NEXT:    store i16 [[TMP1]], i16* @sf, align 2
// CHECK-NEXT:    ret void
//
void dec_sf() {
  sf--;
}

// CHECK-LABEL: @dec_slf(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @slf, align 4
// CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.sadd.sat.i32(i32 [[TMP0]], i32 -2147483648)
// CHECK-NEXT:    store i32 [[TMP1]], i32* @slf, align 4
// CHECK-NEXT:    ret void
//
void dec_slf() {
  slf--;
}

// SIGNED-LABEL: @dec_sua(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i32, i32* @sua, align 4
// SIGNED-NEXT:    [[TMP1:%.*]] = call i32 @llvm.usub.sat.i32(i32 [[TMP0]], i32 65536)
// SIGNED-NEXT:    store i32 [[TMP1]], i32* @sua, align 4
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @dec_sua(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i32, i32* @sua, align 4
// UNSIGNED-NEXT:    [[RESIZE:%.*]] = trunc i32 [[TMP0]] to i31
// UNSIGNED-NEXT:    [[TMP1:%.*]] = call i31 @llvm.usub.sat.i31(i31 [[RESIZE]], i31 32768)
// UNSIGNED-NEXT:    [[RESIZE1:%.*]] = zext i31 [[TMP1]] to i32
// UNSIGNED-NEXT:    store i32 [[RESIZE1]], i32* @sua, align 4
// UNSIGNED-NEXT:    ret void
//
void dec_sua() {
  sua--;
}

// SIGNED-LABEL: @dec_susa(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @susa, align 2
// SIGNED-NEXT:    [[TMP1:%.*]] = call i16 @llvm.usub.sat.i16(i16 [[TMP0]], i16 256)
// SIGNED-NEXT:    store i16 [[TMP1]], i16* @susa, align 2
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @dec_susa(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @susa, align 2
// UNSIGNED-NEXT:    [[RESIZE:%.*]] = trunc i16 [[TMP0]] to i15
// UNSIGNED-NEXT:    [[TMP1:%.*]] = call i15 @llvm.usub.sat.i15(i15 [[RESIZE]], i15 128)
// UNSIGNED-NEXT:    [[RESIZE1:%.*]] = zext i15 [[TMP1]] to i16
// UNSIGNED-NEXT:    store i16 [[RESIZE1]], i16* @susa, align 2
// UNSIGNED-NEXT:    ret void
//
void dec_susa() {
  susa--;
}

// SIGNED-LABEL: @dec_suf(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @suf, align 2
// SIGNED-NEXT:    [[TMP1:%.*]] = call i16 @llvm.usub.sat.i16(i16 [[TMP0]], i16 -1)
// SIGNED-NEXT:    store i16 [[TMP1]], i16* @suf, align 2
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @dec_suf(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @suf, align 2
// UNSIGNED-NEXT:    [[RESIZE:%.*]] = trunc i16 [[TMP0]] to i15
// UNSIGNED-NEXT:    [[TMP1:%.*]] = call i15 @llvm.usub.sat.i15(i15 [[RESIZE]], i15 -1)
// UNSIGNED-NEXT:    [[RESIZE1:%.*]] = zext i15 [[TMP1]] to i16
// UNSIGNED-NEXT:    store i16 [[RESIZE1]], i16* @suf, align 2
// UNSIGNED-NEXT:    ret void
//
void dec_suf() {
  suf--;
}


// CHECK-LABEL: @neg_a(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @a, align 4
// CHECK-NEXT:    [[TMP1:%.*]] = sub i32 0, [[TMP0]]
// CHECK-NEXT:    store i32 [[TMP1]], i32* @a, align 4
// CHECK-NEXT:    ret void
//
void neg_a() {
  a = -a;
}

// CHECK-LABEL: @neg_f(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* @f, align 2
// CHECK-NEXT:    [[TMP1:%.*]] = sub i16 0, [[TMP0]]
// CHECK-NEXT:    store i16 [[TMP1]], i16* @f, align 2
// CHECK-NEXT:    ret void
//
void neg_f() {
  f = -f;
}

// CHECK-LABEL: @neg_usa(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* @usa, align 2
// CHECK-NEXT:    [[TMP1:%.*]] = sub i16 0, [[TMP0]]
// CHECK-NEXT:    store i16 [[TMP1]], i16* @usa, align 2
// CHECK-NEXT:    ret void
//
void neg_usa() {
  usa = -usa;
}

// CHECK-LABEL: @neg_uf(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* @uf, align 2
// CHECK-NEXT:    [[TMP1:%.*]] = sub i16 0, [[TMP0]]
// CHECK-NEXT:    store i16 [[TMP1]], i16* @uf, align 2
// CHECK-NEXT:    ret void
//
void neg_uf() {
  uf = -uf;
}

// CHECK-LABEL: @neg_sa(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @sa, align 4
// CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.ssub.sat.i32(i32 0, i32 [[TMP0]])
// CHECK-NEXT:    store i32 [[TMP1]], i32* @sa, align 4
// CHECK-NEXT:    ret void
//
void neg_sa() {
  sa = -sa;
}

// CHECK-LABEL: @neg_sf(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* @sf, align 2
// CHECK-NEXT:    [[TMP1:%.*]] = call i16 @llvm.ssub.sat.i16(i16 0, i16 [[TMP0]])
// CHECK-NEXT:    store i16 [[TMP1]], i16* @sf, align 2
// CHECK-NEXT:    ret void
//
void neg_sf() {
  sf = -sf;
}

// SIGNED-LABEL: @neg_susa(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @susa, align 2
// SIGNED-NEXT:    [[TMP1:%.*]] = call i16 @llvm.usub.sat.i16(i16 0, i16 [[TMP0]])
// SIGNED-NEXT:    store i16 [[TMP1]], i16* @susa, align 2
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @neg_susa(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @susa, align 2
// UNSIGNED-NEXT:    [[RESIZE:%.*]] = trunc i16 [[TMP0]] to i15
// UNSIGNED-NEXT:    [[TMP1:%.*]] = call i15 @llvm.usub.sat.i15(i15 0, i15 [[RESIZE]])
// UNSIGNED-NEXT:    [[RESIZE1:%.*]] = zext i15 [[TMP1]] to i16
// UNSIGNED-NEXT:    store i16 [[RESIZE1]], i16* @susa, align 2
// UNSIGNED-NEXT:    ret void
//
void neg_susa() {
  susa = -susa;
}

// SIGNED-LABEL: @neg_suf(
// SIGNED-NEXT:  entry:
// SIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @suf, align 2
// SIGNED-NEXT:    [[TMP1:%.*]] = call i16 @llvm.usub.sat.i16(i16 0, i16 [[TMP0]])
// SIGNED-NEXT:    store i16 [[TMP1]], i16* @suf, align 2
// SIGNED-NEXT:    ret void
//
// UNSIGNED-LABEL: @neg_suf(
// UNSIGNED-NEXT:  entry:
// UNSIGNED-NEXT:    [[TMP0:%.*]] = load i16, i16* @suf, align 2
// UNSIGNED-NEXT:    [[RESIZE:%.*]] = trunc i16 [[TMP0]] to i15
// UNSIGNED-NEXT:    [[TMP1:%.*]] = call i15 @llvm.usub.sat.i15(i15 0, i15 [[RESIZE]])
// UNSIGNED-NEXT:    [[RESIZE1:%.*]] = zext i15 [[TMP1]] to i16
// UNSIGNED-NEXT:    store i16 [[RESIZE1]], i16* @suf, align 2
// UNSIGNED-NEXT:    ret void
//
void neg_suf() {
  suf = -suf;
}


// CHECK-LABEL: @plus_a(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @a, align 4
// CHECK-NEXT:    store i32 [[TMP0]], i32* @a, align 4
// CHECK-NEXT:    ret void
//
void plus_a() {
  a = +a;
}

// CHECK-LABEL: @plus_uf(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* @uf, align 2
// CHECK-NEXT:    store i16 [[TMP0]], i16* @uf, align 2
// CHECK-NEXT:    ret void
//
void plus_uf() {
  uf = +uf;
}

// CHECK-LABEL: @plus_sa(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @sa, align 4
// CHECK-NEXT:    store i32 [[TMP0]], i32* @sa, align 4
// CHECK-NEXT:    ret void
//
void plus_sa() {
  sa = +sa;
}


// CHECK-LABEL: @not_a(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @a, align 4
// CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i32 [[TMP0]], 0
// CHECK-NEXT:    [[LNOT:%.*]] = xor i1 [[TOBOOL]], true
// CHECK-NEXT:    [[LNOT_EXT:%.*]] = zext i1 [[LNOT]] to i32
// CHECK-NEXT:    store i32 [[LNOT_EXT]], i32* @i, align 4
// CHECK-NEXT:    ret void
//
void not_a() {
  i = !a;
}

// CHECK-LABEL: @not_uf(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* @uf, align 2
// CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i16 [[TMP0]], 0
// CHECK-NEXT:    [[LNOT:%.*]] = xor i1 [[TOBOOL]], true
// CHECK-NEXT:    [[LNOT_EXT:%.*]] = zext i1 [[LNOT]] to i32
// CHECK-NEXT:    store i32 [[LNOT_EXT]], i32* @i, align 4
// CHECK-NEXT:    ret void
//
void not_uf() {
  i = !uf;
}

// CHECK-LABEL: @not_susa(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load i16, i16* @susa, align 2
// CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i16 [[TMP0]], 0
// CHECK-NEXT:    [[LNOT:%.*]] = xor i1 [[TOBOOL]], true
// CHECK-NEXT:    [[LNOT_EXT:%.*]] = zext i1 [[LNOT]] to i32
// CHECK-NEXT:    store i32 [[LNOT_EXT]], i32* @i, align 4
// CHECK-NEXT:    ret void
//
void not_susa() {
  i = !susa;
}
