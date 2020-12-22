; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=ppc64 < %s | FileCheck %s
target datalayout = "E-m:e-i64:64-n32:64"
target triple = "powerpc64-unknown-linux-gnu"

; Function Attrs: nounwind readnone
define i64 @cn1() #0 {
; CHECK-LABEL: cn1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -1
; CHECK-NEXT:    rldic 3, 3, 0, 16
; CHECK-NEXT:    blr
entry:
  ret i64 281474976710655

}

; Function Attrs: nounwind readnone
define i64 @cnb() #0 {
; CHECK-LABEL: cnb:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -81
; CHECK-NEXT:    rldic 3, 3, 0, 16
; CHECK-NEXT:    blr
entry:
  ret i64 281474976710575

}

; Function Attrs: nounwind readnone
define i64 @f2(i64 %x) #0 {
; CHECK-LABEL: f2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -1
; CHECK-NEXT:    rldic 3, 3, 36, 0
; CHECK-NEXT:    blr
entry:
  ret i64 -68719476736

}

; Function Attrs: nounwind readnone
define i64 @f2a(i64 %x) #0 {
; CHECK-LABEL: f2a:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -337
; CHECK-NEXT:    rldic 3, 3, 30, 0
; CHECK-NEXT:    blr
entry:
  ret i64 -361850994688

}

; Function Attrs: nounwind readnone
define i64 @f2n(i64 %x) #0 {
; CHECK-LABEL: f2n:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -1
; CHECK-NEXT:    rldic 3, 3, 0, 28
; CHECK-NEXT:    blr
entry:
  ret i64 68719476735

}

; Function Attrs: nounwind readnone
define i64 @f3(i64 %x) #0 {
; CHECK-LABEL: f3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -1
; CHECK-NEXT:    rldic 3, 3, 0, 31
; CHECK-NEXT:    blr
entry:
  ret i64 8589934591

}

; Function Attrs: nounwind readnone
define i64 @cn2n() #0 {
; CHECK-LABEL: cn2n:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lis 3, -5121
; CHECK-NEXT:    ori 3, 3, 65534
; CHECK-NEXT:    rotldi 3, 3, 22
; CHECK-NEXT:    blr
entry:
  ret i64 -1407374887747585

}

define i64 @uint32_1() #0 {
; CHECK-LABEL: uint32_1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, 18176
; CHECK-NEXT:    oris 3, 3, 59509
; CHECK-NEXT:    blr
entry:
  ret i64 3900000000

}

define i32 @uint32_1_i32() #0 {
; CHECK-LABEL: uint32_1_i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, 18176
; CHECK-NEXT:    oris 3, 3, 59509
; CHECK-NEXT:    blr
entry:
  ret i32 -394967296

}

define i64 @uint32_2() #0 {
; CHECK-LABEL: uint32_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -1
; CHECK-NEXT:    rldic 3, 3, 0, 32
; CHECK-NEXT:    blr
entry:
  ret i64 4294967295

}

define i32 @uint32_2_i32() #0 {
; CHECK-LABEL: uint32_2_i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -1
; CHECK-NEXT:    rldic 3, 3, 0, 32
; CHECK-NEXT:    blr
entry:
  ret i32 -1

}

define i64 @uint32_3() #0 {
; CHECK-LABEL: uint32_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, 1
; CHECK-NEXT:    rldic 3, 3, 31, 32
; CHECK-NEXT:    blr
entry:
  ret i64 2147483648

}

define i64 @uint32_4() #0 {
; CHECK-LABEL: uint32_4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lis 3, -6027
; CHECK-NEXT:    ori 3, 3, 18177
; CHECK-NEXT:    rldic 3, 3, 5, 27
; CHECK-NEXT:    blr
entry:
  ret i64 124800000032

}

define i64 @cn_ones_1() #0 {
; CHECK-LABEL: cn_ones_1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -25633
; CHECK-NEXT:    rldicl 3, 3, 18, 30
; CHECK-NEXT:    blr
entry:
  ret i64 10460594175

}

define i64 @cn_ones_2() #0 {
; CHECK-LABEL: cn_ones_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lis 3, -25638
; CHECK-NEXT:    ori 3, 3, 24575
; CHECK-NEXT:    rldicl 3, 3, 2, 30
; CHECK-NEXT:    blr
entry:
  ret i64 10459119615

}

define i64 @imm1() #0 {
; CHECK-LABEL: imm1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, 8465
; CHECK-NEXT:    rldic 3, 3, 28, 22
; CHECK-NEXT:    blr
entry:
  ret i64 2272306135040 ;0x21110000000
}

define i64 @imm2() #0 {
; CHECK-LABEL: imm2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -28536
; CHECK-NEXT:    rldicl 3, 3, 1, 32
; CHECK-NEXT:    blr
entry:
  ret i64 4294910225 ;0xFFFF2111
}

define i64 @imm3() #0 {
; CHECK-LABEL: imm3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -32495
; CHECK-NEXT:    rldic 3, 3, 0, 32
; CHECK-NEXT:    blr
entry:
  ret i64 4294934801 ;0xFFFF8111
}

define i64 @imm4() #0 {
; CHECK-LABEL: imm4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lis 3, 33
; CHECK-NEXT:    ori 3, 3, 4352
; CHECK-NEXT:    rldimi 3, 3, 32, 0
; CHECK-NEXT:    blr
entry:
  ret i64 9307365931290880 ;0x21110000211100
}

define i64 @imm5() #0 {
; CHECK-LABEL: imm5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, 28685
; CHECK-NEXT:    rotldi 3, 3, 52
; CHECK-NEXT:    blr
entry:
  ret i64 58546795155816455 ;0xd0000000000007
}

define i64 @imm6() #0 {
; CHECK-LABEL: imm6:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lis 3, -1
; CHECK-NEXT:    ori 3, 3, 28674
; CHECK-NEXT:    rotldi 3, 3, 52
; CHECK-NEXT:    blr
entry:
  ret i64 13510798882111479 ;0x2ffffffffffff7
}

define i64 @imm7() #0 {
; CHECK-LABEL: imm7:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -3823
; CHECK-NEXT:    rldic 3, 3, 28, 20
; CHECK-NEXT:    blr
entry:
  ret i64 16565957296128 ;0xf1110000000
}

define i64 @imm8() #0 {
; CHECK-LABEL: imm8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -7919
; CHECK-NEXT:    rldic 3, 3, 22, 22
; CHECK-NEXT:    blr
entry:
  ret i64 4364831817728 ;0x3f844400000
}

define i64 @imm9() #0 {
; CHECK-LABEL: imm9:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lis 3, -1
; CHECK-NEXT:    ori 3, 3, 28674
; CHECK-NEXT:    rotldi 3, 3, 52
; CHECK-NEXT:    blr
entry:
  ret i64 13510798882111479 ;0x2ffffffffffff7
}

define i64 @imm10() #0 {
; CHECK-LABEL: imm10:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -3823
; CHECK-NEXT:    rldic 3, 3, 28, 20
; CHECK-NEXT:    blr
entry:
  ret i64 16565957296128 ;0xf1110000000
}

define i64 @imm11() #0 {
; CHECK-LABEL: imm11:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -7919
; CHECK-NEXT:    rldic 3, 3, 22, 22
; CHECK-NEXT:    blr
entry:
  ret i64 4364831817728 ;0x3f844400000
}

define i64 @imm12() #0 {
; CHECK-LABEL: imm12:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lis 3, -29
; CHECK-NEXT:    ori 3, 3, 64577
; CHECK-NEXT:    rldic 3, 3, 12, 20
; CHECK-NEXT:    blr
entry:
  ret i64 17584665923584 ;0xffe3fc41000
}

define i64 @imm13() #0 {
; CHECK-LABEL: imm13:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -24847
; CHECK-NEXT:    rldicl 3, 3, 21, 27
; CHECK-NEXT:    blr
entry:
  ret i64 85333114879 ;0x13de3fffff
}

define i64 @imm13_2() #0 {
; CHECK-LABEL: imm13_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -12424
; CHECK-NEXT:    rldicl 3, 3, 22, 26
; CHECK-NEXT:    blr
entry:
  ret i64 222772068351 ;0x33de3fffff
}

define i64 @imm14() #0 {
; CHECK-LABEL: imm14:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -3960
; CHECK-NEXT:    rldicl 3, 3, 21, 24
; CHECK-NEXT:    blr
entry:
  ret i64 1091209003007 ;0xfe111fffff
}

define i64 @imm15() #0 {
; CHECK-LABEL: imm15:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -8065
; CHECK-NEXT:    rldic 3, 3, 24, 0
; CHECK-NEXT:    blr
entry:
  ret i64 -135308247040
}

define i64 @imm16() #0 {
; CHECK-LABEL: imm16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lis 3, -16392
; CHECK-NEXT:    ori 3, 3, 57217
; CHECK-NEXT:    rldic 3, 3, 16, 0
; CHECK-NEXT:    blr
entry:
  ret i64 -70399354142720
}

define i64 @imm17() #0 {
; CHECK-LABEL: imm17:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lis 3, 20344
; CHECK-NEXT:    ori 3, 3, 32847
; CHECK-NEXT:    rotldi 3, 3, 49
; CHECK-NEXT:    blr
entry:
  ret i64 44473046320324337 ;0x9e000000009ef1
}

define i64 @imm18() #0 {
; CHECK-LABEL: imm18:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, 1
; CHECK-NEXT:    rldic 3, 3, 33, 30
; CHECK-NEXT:    oris 3, 3, 39436
; CHECK-NEXT:    ori 3, 3, 61633
; CHECK-NEXT:    blr
entry:
  ret i64 11174473921
}

attributes #0 = { nounwind readnone }
