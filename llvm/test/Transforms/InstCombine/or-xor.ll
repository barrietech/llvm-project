; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

; X | ~(X | Y) --> X | ~Y

define i32 @test1(i32 %x, i32 %y) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[Y_NOT:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[Y_NOT]], [[X:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %or = or i32 %x, %y
  %not = xor i32 %or, -1
  %z = or i32 %x, %not
  ret i32 %z
}

; Commute (rename) the inner 'or' operands:
; Y | ~(X | Y) --> ~X | Y

define i32 @test2(i32 %x, i32 %y) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[X_NOT:%.*]] = xor i32 [[X:%.*]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[X_NOT]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %or = or i32 %x, %y
  %not = xor i32 %or, -1
  %z = or i32 %y, %not
  ret i32 %z
}

; X | ~(X ^ Y) --> X | ~Y

define i32 @test3(i32 %x, i32 %y) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[Y_NOT:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[Y_NOT]], [[X:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %xor = xor i32 %x, %y
  %not = xor i32 %xor, -1
  %z = or i32 %x, %not
  ret i32 %z
}

; Commute (rename) the 'xor' operands:
; Y | ~(X ^ Y) --> ~X | Y

define i32 @test4(i32 %x, i32 %y) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[X_NOT:%.*]] = xor i32 [[X:%.*]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[X_NOT]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %xor = xor i32 %x, %y
  %not = xor i32 %xor, -1
  %z = or i32 %y, %not
  ret i32 %z
}

define i32 @test7(i32 %x, i32 %y) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %xor = xor i32 %x, %y
  %z = or i32 %y, %xor
  ret i32 %z
}

define i32 @test8(i32 %x, i32 %y) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[X_NOT:%.*]] = xor i32 [[X:%.*]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[X_NOT]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %not = xor i32 %y, -1
  %xor = xor i32 %x, %not
  %z = or i32 %y, %xor
  ret i32 %z
}

define i32 @test9(i32 %x, i32 %y) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[Y_NOT:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[Z:%.*]] = or i32 [[Y_NOT]], [[X:%.*]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %not = xor i32 %x, -1
  %xor = xor i32 %not, %y
  %z = or i32 %x, %xor
  ret i32 %z
}

define i32 @test10(i32 %A, i32 %B) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    ret i32 -1
;
  %xor1 = xor i32 %B, %A
  %not = xor i32 %A, -1
  %xor2 = xor i32 %not, %B
  %or = or i32 %xor1, %xor2
  ret i32 %or
}

define i32 @test10_commuted(i32 %A, i32 %B) {
; CHECK-LABEL: @test10_commuted(
; CHECK-NEXT:    ret i32 -1
;
  %xor1 = xor i32 %B, %A
  %not = xor i32 %A, -1
  %xor2 = xor i32 %not, %B
  %or = or i32 %xor2, %xor1
  ret i32 %or
}

; (x | y) & ((~x) ^ y) -> (x & y)
define i32 @test11(i32 %x, i32 %y) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[AND]]
;
  %or = or i32 %x, %y
  %neg = xor i32 %x, -1
  %xor = xor i32 %neg, %y
  %and = and i32 %or, %xor
  ret i32 %and
}

; ((~x) ^ y) & (x | y) -> (x & y)
define i32 @test12(i32 %x, i32 %y) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[AND]]
;
  %neg = xor i32 %x, -1
  %xor = xor i32 %neg, %y
  %or = or i32 %x, %y
  %and = and i32 %xor, %or
  ret i32 %and
}

define i32 @test12_commuted(i32 %x, i32 %y) {
; CHECK-LABEL: @test12_commuted(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[AND]]
;
  %neg = xor i32 %x, -1
  %xor = xor i32 %neg, %y
  %or = or i32 %y, %x
  %and = and i32 %xor, %or
  ret i32 %and
}

; ((x | y) ^ (x ^ y)) -> (x & y)
define i32 @test13(i32 %x, i32 %y) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = xor i32 %y, %x
  %2 = or i32 %y, %x
  %3 = xor i32 %2, %1
  ret i32 %3
}

; ((x | ~y) ^ (~x | y)) -> x ^ y
define i32 @test14(i32 %x, i32 %y) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %or1 = or i32 %x, %noty
  %or2 = or i32 %notx, %y
  %xor = xor i32 %or1, %or2
  ret i32 %xor
}

define i32 @test14_commuted(i32 %x, i32 %y) {
; CHECK-LABEL: @test14_commuted(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %or1 = or i32 %noty, %x
  %or2 = or i32 %notx, %y
  %xor = xor i32 %or1, %or2
  ret i32 %xor
}

; ((x & ~y) ^ (~x & y)) -> x ^ y
define i32 @test15(i32 %x, i32 %y) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %and1 = and i32 %x, %noty
  %and2 = and i32 %notx, %y
  %xor = xor i32 %and1, %and2
  ret i32 %xor
}

define i32 @test15_commuted(i32 %x, i32 %y) {
; CHECK-LABEL: @test15_commuted(
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %and1 = and i32 %noty, %x
  %and2 = and i32 %notx, %y
  %xor = xor i32 %and1, %and2
  ret i32 %xor
}

define i32 @test16(i32 %a, i32 %b) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], 1
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %or = xor i32 %a, %b
  %and1 = and i32 %or, 1
  %and2 = and i32 %b, -2
  %xor = or i32 %and1, %and2
  ret i32 %xor
}

define i8 @not_or(i8 %x) {
; CHECK-LABEL: @not_or(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[NOTX]], 7
; CHECK-NEXT:    ret i8 [[OR]]
;
  %notx = xor i8 %x, -1
  %or = or i8 %notx, 7
  ret i8 %or
}

define i8 @not_or_xor(i8 %x) {
; CHECK-LABEL: @not_or_xor(
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[X:%.*]], -8
; CHECK-NEXT:    [[XOR:%.*]] = xor i8 [[TMP1]], -13
; CHECK-NEXT:    ret i8 [[XOR]]
;
  %notx = xor i8 %x, -1
  %or = or i8 %notx, 7
  %xor = xor i8 %or, 12
  ret i8 %xor
}

define i8 @xor_or(i8 %x) {
; CHECK-LABEL: @xor_or(
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[X:%.*]], 7
; CHECK-NEXT:    [[OR:%.*]] = xor i8 [[TMP1]], 32
; CHECK-NEXT:    ret i8 [[OR]]
;
  %xor = xor i8 %x, 32
  %or = or i8 %xor, 7
  ret i8 %or
}

define i8 @xor_or2(i8 %x) {
; CHECK-LABEL: @xor_or2(
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[X:%.*]], 7
; CHECK-NEXT:    [[OR:%.*]] = xor i8 [[TMP1]], 32
; CHECK-NEXT:    ret i8 [[OR]]
;
  %xor = xor i8 %x, 33
  %or = or i8 %xor, 7
  ret i8 %or
}

define i8 @xor_or_xor(i8 %x) {
; CHECK-LABEL: @xor_or_xor(
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[X:%.*]], 7
; CHECK-NEXT:    [[XOR2:%.*]] = xor i8 [[TMP1]], 44
; CHECK-NEXT:    ret i8 [[XOR2]]
;
  %xor1 = xor i8 %x, 33
  %or = or i8 %xor1, 7
  %xor2 = xor i8 %or, 12
  ret i8 %xor2
}

define i8 @or_xor_or(i8 %x) {
; CHECK-LABEL: @or_xor_or(
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[X:%.*]], 39
; CHECK-NEXT:    [[OR2:%.*]] = xor i8 [[TMP1]], 8
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %or1 = or i8 %x, 33
  %xor = xor i8 %or1, 12
  %or2 = or i8 %xor, 7
  ret i8 %or2
}

define i8 @test17(i8 %A, i8 %B) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[XOR1:%.*]] = xor i8 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i8 [[A]], 33
; CHECK-NEXT:    [[XOR2:%.*]] = xor i8 [[NOT]], [[B]]
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[XOR1]], 33
; CHECK-NEXT:    [[RES:%.*]] = mul i8 [[OR]], [[XOR2]]
; CHECK-NEXT:    ret i8 [[RES]]
;
  %xor1 = xor i8 %B, %A
  %not = xor i8 %A, 33
  %xor2 = xor i8 %not, %B
  %or = or i8 %xor1, %xor2
  %res = mul i8 %or, %xor2 ; to increase the use count for the xor
  ret i8 %res
}

define i8 @test18(i8 %A, i8 %B) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[XOR1:%.*]] = xor i8 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[NOT:%.*]] = xor i8 [[A]], 33
; CHECK-NEXT:    [[XOR2:%.*]] = xor i8 [[NOT]], [[B]]
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[XOR1]], 33
; CHECK-NEXT:    [[RES:%.*]] = mul i8 [[OR]], [[XOR2]]
; CHECK-NEXT:    ret i8 [[RES]]
;
  %xor1 = xor i8 %B, %A
  %not = xor i8 %A, 33
  %xor2 = xor i8 %not, %B
  %or = or i8 %xor2, %xor1
  %res = mul i8 %or, %xor2 ; to increase the use count for the xor
  ret i8 %res
}

; ((x | y) ^ (~x | ~y)) -> ~(x ^ y)
define i32 @test19(i32 %x, i32 %y) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %or1 = or i32 %x, %y
  %or2 = or i32 %notx, %noty
  %xor = xor i32 %or1, %or2
  ret i32 %xor
}

; ((x | y) ^ (~y | ~x)) -> ~(x ^ y)
define i32 @test20(i32 %x, i32 %y) {
; CHECK-LABEL: @test20(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %or1 = or i32 %x, %y
  %or2 = or i32 %noty, %notx
  %xor = xor i32 %or1, %or2
  ret i32 %xor
}

; ((~x | ~y) ^ (x | y)) -> ~(x ^ y)
define i32 @test21(i32 %x, i32 %y) {
; CHECK-LABEL: @test21(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %or1 = or i32 %notx, %noty
  %or2 = or i32 %x, %y
  %xor = xor i32 %or1, %or2
  ret i32 %xor
}

; ((~x | ~y) ^ (y | x)) -> ~(x ^ y)
define i32 @test22(i32 %x, i32 %y) {
; CHECK-LABEL: @test22(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[TMP1]], -1
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %noty = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %or1 = or i32 %notx, %noty
  %or2 = or i32 %y, %x
  %xor = xor i32 %or1, %or2
  ret i32 %xor
}

; (X ^ C1) | C2 --> (X | C2) ^ (C1&~C2)
define i8 @test23(i8 %A) {
; CHECK-LABEL: @test23(
; CHECK-NEXT:    ret i8 -1
;
  %B = or i8 %A, -2
  %C = xor i8 %B, 13
  %D = or i8 %C, 1
  %E = xor i8 %D, 12
  ret i8 %E
}

define i8 @test23v(<2 x i8> %A) {
; CHECK-LABEL: @test23v(
; CHECK-NEXT:    ret i8 -1
;
  %B = or <2 x i8> %A, <i8 -2, i8 0>
  %CV = xor <2 x i8> %B, <i8 13, i8 13>
  %C = extractelement <2 x i8> %CV, i32 0
  %D = or i8 %C, 1
  %E = xor i8 %D, 12
  ret i8 %E
}
