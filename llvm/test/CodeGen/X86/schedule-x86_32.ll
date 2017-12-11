; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -print-schedule -mcpu=i686 | FileCheck %s --check-prefix=CHECK --check-prefix=GENERIC
; RUN: llc < %s -mtriple=i686-unknown-unknown -print-schedule -mcpu=atom | FileCheck %s --check-prefix=CHECK --check-prefix=ATOM
; RUN: llc < %s -mtriple=i686-unknown-unknown -print-schedule -mcpu=slm | FileCheck %s --check-prefix=CHECK --check-prefix=SLM
; RUN: llc < %s -mtriple=i686-unknown-unknown -print-schedule -mcpu=sandybridge | FileCheck %s --check-prefix=CHECK --check-prefix=SANDY
; RUN: llc < %s -mtriple=i686-unknown-unknown -print-schedule -mcpu=ivybridge | FileCheck %s --check-prefix=CHECK --check-prefix=SANDY
; RUN: llc < %s -mtriple=i686-unknown-unknown -print-schedule -mcpu=haswell | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=i686-unknown-unknown -print-schedule -mcpu=broadwell | FileCheck %s --check-prefix=CHECK --check-prefix=BROADWELL
; RUN: llc < %s -mtriple=i686-unknown-unknown -print-schedule -mcpu=skylake | FileCheck %s --check-prefix=CHECK --check-prefix=SKYLAKE
; RUN: llc < %s -mtriple=i686-unknown-unknown -print-schedule -mcpu=skx | FileCheck %s --check-prefix=CHECK --check-prefix=SKX
; RUN: llc < %s -mtriple=i686-unknown-unknown -print-schedule -mcpu=btver2 | FileCheck %s --check-prefix=CHECK --check-prefix=BTVER2
; RUN: llc < %s -mtriple=i686-unknown-unknown -print-schedule -mcpu=znver1 | FileCheck %s --check-prefix=CHECK --check-prefix=ZNVER1

define i8 @test_aaa(i8 %a0) optsize {
; GENERIC-LABEL: test_aaa:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movb {{[0-9]+}}(%esp), %al
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    aaa
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retl
;
; ATOM-LABEL: test_aaa:
; ATOM:       # %bb.0:
; ATOM-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [1:1.00]
; ATOM-NEXT:    #APP
; ATOM-NEXT:    aaa # sched: [13:6.50]
; ATOM-NEXT:    #NO_APP
; ATOM-NEXT:    retl # sched: [79:39.50]
;
; SLM-LABEL: test_aaa:
; SLM:       # %bb.0:
; SLM-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [3:1.00]
; SLM-NEXT:    #APP
; SLM-NEXT:    aaa # sched: [100:1.00]
; SLM-NEXT:    #NO_APP
; SLM-NEXT:    retl # sched: [4:1.00]
;
; SANDY-LABEL: test_aaa:
; SANDY:       # %bb.0:
; SANDY-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SANDY-NEXT:    #APP
; SANDY-NEXT:    aaa # sched: [100:0.33]
; SANDY-NEXT:    #NO_APP
; SANDY-NEXT:    retl # sched: [5:1.00]
;
; HASWELL-LABEL: test_aaa:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; HASWELL-NEXT:    #APP
; HASWELL-NEXT:    aaa # sched: [100:0.25]
; HASWELL-NEXT:    #NO_APP
; HASWELL-NEXT:    retl # sched: [7:1.00]
;
; BROADWELL-LABEL: test_aaa:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; BROADWELL-NEXT:    #APP
; BROADWELL-NEXT:    aaa # sched: [100:0.25]
; BROADWELL-NEXT:    #NO_APP
; BROADWELL-NEXT:    retl # sched: [6:0.50]
;
; SKYLAKE-LABEL: test_aaa:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SKYLAKE-NEXT:    #APP
; SKYLAKE-NEXT:    aaa # sched: [100:0.25]
; SKYLAKE-NEXT:    #NO_APP
; SKYLAKE-NEXT:    retl # sched: [6:0.50]
;
; SKX-LABEL: test_aaa:
; SKX:       # %bb.0:
; SKX-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SKX-NEXT:    #APP
; SKX-NEXT:    aaa # sched: [100:0.25]
; SKX-NEXT:    #NO_APP
; SKX-NEXT:    retl # sched: [6:0.50]
;
; BTVER2-LABEL: test_aaa:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:1.00]
; BTVER2-NEXT:    #APP
; BTVER2-NEXT:    aaa # sched: [100:0.17]
; BTVER2-NEXT:    #NO_APP
; BTVER2-NEXT:    retl # sched: [4:1.00]
;
; ZNVER1-LABEL: test_aaa:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [8:0.50]
; ZNVER1-NEXT:    #APP
; ZNVER1-NEXT:    aaa # sched: [100:?]
; ZNVER1-NEXT:    #NO_APP
; ZNVER1-NEXT:    retl # sched: [1:0.50]
  %1 = tail call i8 asm "aaa", "=r,r"(i8 %a0) nounwind
  ret i8 %1
}

define i8 @test_aad(i16 %a0) optsize {
; GENERIC-LABEL: test_aad:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    aad
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retl
;
; ATOM-LABEL: test_aad:
; ATOM:       # %bb.0:
; ATOM-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [1:1.00]
; ATOM-NEXT:    #APP
; ATOM-NEXT:    aad # sched: [7:3.50]
; ATOM-NEXT:    #NO_APP
; ATOM-NEXT:    retl # sched: [79:39.50]
;
; SLM-LABEL: test_aad:
; SLM:       # %bb.0:
; SLM-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [4:1.00]
; SLM-NEXT:    #APP
; SLM-NEXT:    aad # sched: [100:1.00]
; SLM-NEXT:    #NO_APP
; SLM-NEXT:    retl # sched: [4:1.00]
;
; SANDY-LABEL: test_aad:
; SANDY:       # %bb.0:
; SANDY-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SANDY-NEXT:    #APP
; SANDY-NEXT:    aad # sched: [100:0.33]
; SANDY-NEXT:    #NO_APP
; SANDY-NEXT:    retl # sched: [5:1.00]
;
; HASWELL-LABEL: test_aad:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; HASWELL-NEXT:    #APP
; HASWELL-NEXT:    aad # sched: [100:0.25]
; HASWELL-NEXT:    #NO_APP
; HASWELL-NEXT:    retl # sched: [7:1.00]
;
; BROADWELL-LABEL: test_aad:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; BROADWELL-NEXT:    #APP
; BROADWELL-NEXT:    aad # sched: [100:0.25]
; BROADWELL-NEXT:    #NO_APP
; BROADWELL-NEXT:    retl # sched: [6:0.50]
;
; SKYLAKE-LABEL: test_aad:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SKYLAKE-NEXT:    #APP
; SKYLAKE-NEXT:    aad # sched: [100:0.25]
; SKYLAKE-NEXT:    #NO_APP
; SKYLAKE-NEXT:    retl # sched: [6:0.50]
;
; SKX-LABEL: test_aad:
; SKX:       # %bb.0:
; SKX-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SKX-NEXT:    #APP
; SKX-NEXT:    aad # sched: [100:0.25]
; SKX-NEXT:    #NO_APP
; SKX-NEXT:    retl # sched: [6:0.50]
;
; BTVER2-LABEL: test_aad:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [4:1.00]
; BTVER2-NEXT:    #APP
; BTVER2-NEXT:    aad # sched: [100:0.17]
; BTVER2-NEXT:    #NO_APP
; BTVER2-NEXT:    retl # sched: [4:1.00]
;
; ZNVER1-LABEL: test_aad:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [8:0.50]
; ZNVER1-NEXT:    #APP
; ZNVER1-NEXT:    aad # sched: [100:?]
; ZNVER1-NEXT:    #NO_APP
; ZNVER1-NEXT:    retl # sched: [1:0.50]
  %1 = tail call i8 asm "aad", "=r,r"(i16 %a0) nounwind
  ret i8 %1
}

define i16 @test_aam(i8 %a0) optsize {
; GENERIC-LABEL: test_aam:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movb {{[0-9]+}}(%esp), %al
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    aam
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retl
;
; ATOM-LABEL: test_aam:
; ATOM:       # %bb.0:
; ATOM-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [1:1.00]
; ATOM-NEXT:    #APP
; ATOM-NEXT:    aam # sched: [21:10.50]
; ATOM-NEXT:    #NO_APP
; ATOM-NEXT:    retl # sched: [79:39.50]
;
; SLM-LABEL: test_aam:
; SLM:       # %bb.0:
; SLM-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [3:1.00]
; SLM-NEXT:    #APP
; SLM-NEXT:    aam # sched: [100:1.00]
; SLM-NEXT:    #NO_APP
; SLM-NEXT:    retl # sched: [4:1.00]
;
; SANDY-LABEL: test_aam:
; SANDY:       # %bb.0:
; SANDY-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SANDY-NEXT:    #APP
; SANDY-NEXT:    aam # sched: [100:0.33]
; SANDY-NEXT:    #NO_APP
; SANDY-NEXT:    retl # sched: [5:1.00]
;
; HASWELL-LABEL: test_aam:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; HASWELL-NEXT:    #APP
; HASWELL-NEXT:    aam # sched: [100:0.25]
; HASWELL-NEXT:    #NO_APP
; HASWELL-NEXT:    retl # sched: [7:1.00]
;
; BROADWELL-LABEL: test_aam:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; BROADWELL-NEXT:    #APP
; BROADWELL-NEXT:    aam # sched: [100:0.25]
; BROADWELL-NEXT:    #NO_APP
; BROADWELL-NEXT:    retl # sched: [6:0.50]
;
; SKYLAKE-LABEL: test_aam:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SKYLAKE-NEXT:    #APP
; SKYLAKE-NEXT:    aam # sched: [100:0.25]
; SKYLAKE-NEXT:    #NO_APP
; SKYLAKE-NEXT:    retl # sched: [6:0.50]
;
; SKX-LABEL: test_aam:
; SKX:       # %bb.0:
; SKX-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SKX-NEXT:    #APP
; SKX-NEXT:    aam # sched: [100:0.25]
; SKX-NEXT:    #NO_APP
; SKX-NEXT:    retl # sched: [6:0.50]
;
; BTVER2-LABEL: test_aam:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:1.00]
; BTVER2-NEXT:    #APP
; BTVER2-NEXT:    aam # sched: [100:0.17]
; BTVER2-NEXT:    #NO_APP
; BTVER2-NEXT:    retl # sched: [4:1.00]
;
; ZNVER1-LABEL: test_aam:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [8:0.50]
; ZNVER1-NEXT:    #APP
; ZNVER1-NEXT:    aam # sched: [100:?]
; ZNVER1-NEXT:    #NO_APP
; ZNVER1-NEXT:    retl # sched: [1:0.50]
  %1 = tail call i16 asm "aam", "=r,r"(i8 %a0) nounwind
  ret i16 %1
}

define i8 @test_aas(i8 %a0) optsize {
; GENERIC-LABEL: test_aas:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movb {{[0-9]+}}(%esp), %al
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    aas
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retl
;
; ATOM-LABEL: test_aas:
; ATOM:       # %bb.0:
; ATOM-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [1:1.00]
; ATOM-NEXT:    #APP
; ATOM-NEXT:    aas # sched: [13:6.50]
; ATOM-NEXT:    #NO_APP
; ATOM-NEXT:    retl # sched: [79:39.50]
;
; SLM-LABEL: test_aas:
; SLM:       # %bb.0:
; SLM-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [3:1.00]
; SLM-NEXT:    #APP
; SLM-NEXT:    aas # sched: [100:1.00]
; SLM-NEXT:    #NO_APP
; SLM-NEXT:    retl # sched: [4:1.00]
;
; SANDY-LABEL: test_aas:
; SANDY:       # %bb.0:
; SANDY-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SANDY-NEXT:    #APP
; SANDY-NEXT:    aas # sched: [100:0.33]
; SANDY-NEXT:    #NO_APP
; SANDY-NEXT:    retl # sched: [5:1.00]
;
; HASWELL-LABEL: test_aas:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; HASWELL-NEXT:    #APP
; HASWELL-NEXT:    aas # sched: [100:0.25]
; HASWELL-NEXT:    #NO_APP
; HASWELL-NEXT:    retl # sched: [7:1.00]
;
; BROADWELL-LABEL: test_aas:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; BROADWELL-NEXT:    #APP
; BROADWELL-NEXT:    aas # sched: [100:0.25]
; BROADWELL-NEXT:    #NO_APP
; BROADWELL-NEXT:    retl # sched: [6:0.50]
;
; SKYLAKE-LABEL: test_aas:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SKYLAKE-NEXT:    #APP
; SKYLAKE-NEXT:    aas # sched: [100:0.25]
; SKYLAKE-NEXT:    #NO_APP
; SKYLAKE-NEXT:    retl # sched: [6:0.50]
;
; SKX-LABEL: test_aas:
; SKX:       # %bb.0:
; SKX-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SKX-NEXT:    #APP
; SKX-NEXT:    aas # sched: [100:0.25]
; SKX-NEXT:    #NO_APP
; SKX-NEXT:    retl # sched: [6:0.50]
;
; BTVER2-LABEL: test_aas:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:1.00]
; BTVER2-NEXT:    #APP
; BTVER2-NEXT:    aas # sched: [100:0.17]
; BTVER2-NEXT:    #NO_APP
; BTVER2-NEXT:    retl # sched: [4:1.00]
;
; ZNVER1-LABEL: test_aas:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [8:0.50]
; ZNVER1-NEXT:    #APP
; ZNVER1-NEXT:    aas # sched: [100:?]
; ZNVER1-NEXT:    #NO_APP
; ZNVER1-NEXT:    retl # sched: [1:0.50]
  %1 = tail call i8 asm "aas", "=r,r"(i8 %a0) nounwind
  ret i8 %1
}

; TODO - test_bound

define i8 @test_daa(i8 %a0) optsize {
; GENERIC-LABEL: test_daa:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movb {{[0-9]+}}(%esp), %al
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    daa
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retl
;
; ATOM-LABEL: test_daa:
; ATOM:       # %bb.0:
; ATOM-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [1:1.00]
; ATOM-NEXT:    #APP
; ATOM-NEXT:    daa # sched: [18:9.00]
; ATOM-NEXT:    #NO_APP
; ATOM-NEXT:    retl # sched: [79:39.50]
;
; SLM-LABEL: test_daa:
; SLM:       # %bb.0:
; SLM-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [3:1.00]
; SLM-NEXT:    #APP
; SLM-NEXT:    daa # sched: [100:1.00]
; SLM-NEXT:    #NO_APP
; SLM-NEXT:    retl # sched: [4:1.00]
;
; SANDY-LABEL: test_daa:
; SANDY:       # %bb.0:
; SANDY-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SANDY-NEXT:    #APP
; SANDY-NEXT:    daa # sched: [100:0.33]
; SANDY-NEXT:    #NO_APP
; SANDY-NEXT:    retl # sched: [5:1.00]
;
; HASWELL-LABEL: test_daa:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; HASWELL-NEXT:    #APP
; HASWELL-NEXT:    daa # sched: [100:0.25]
; HASWELL-NEXT:    #NO_APP
; HASWELL-NEXT:    retl # sched: [7:1.00]
;
; BROADWELL-LABEL: test_daa:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; BROADWELL-NEXT:    #APP
; BROADWELL-NEXT:    daa # sched: [100:0.25]
; BROADWELL-NEXT:    #NO_APP
; BROADWELL-NEXT:    retl # sched: [6:0.50]
;
; SKYLAKE-LABEL: test_daa:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SKYLAKE-NEXT:    #APP
; SKYLAKE-NEXT:    daa # sched: [100:0.25]
; SKYLAKE-NEXT:    #NO_APP
; SKYLAKE-NEXT:    retl # sched: [6:0.50]
;
; SKX-LABEL: test_daa:
; SKX:       # %bb.0:
; SKX-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SKX-NEXT:    #APP
; SKX-NEXT:    daa # sched: [100:0.25]
; SKX-NEXT:    #NO_APP
; SKX-NEXT:    retl # sched: [6:0.50]
;
; BTVER2-LABEL: test_daa:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:1.00]
; BTVER2-NEXT:    #APP
; BTVER2-NEXT:    daa # sched: [100:0.17]
; BTVER2-NEXT:    #NO_APP
; BTVER2-NEXT:    retl # sched: [4:1.00]
;
; ZNVER1-LABEL: test_daa:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [8:0.50]
; ZNVER1-NEXT:    #APP
; ZNVER1-NEXT:    daa # sched: [100:?]
; ZNVER1-NEXT:    #NO_APP
; ZNVER1-NEXT:    retl # sched: [1:0.50]
  %1 = tail call i8 asm "daa", "=r,r"(i8 %a0) nounwind
  ret i8 %1
}

define i8 @test_das(i8 %a0) optsize {
; GENERIC-LABEL: test_das:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movb {{[0-9]+}}(%esp), %al
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    das
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retl
;
; ATOM-LABEL: test_das:
; ATOM:       # %bb.0:
; ATOM-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [1:1.00]
; ATOM-NEXT:    #APP
; ATOM-NEXT:    das # sched: [20:10.00]
; ATOM-NEXT:    #NO_APP
; ATOM-NEXT:    retl # sched: [79:39.50]
;
; SLM-LABEL: test_das:
; SLM:       # %bb.0:
; SLM-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [3:1.00]
; SLM-NEXT:    #APP
; SLM-NEXT:    das # sched: [100:1.00]
; SLM-NEXT:    #NO_APP
; SLM-NEXT:    retl # sched: [4:1.00]
;
; SANDY-LABEL: test_das:
; SANDY:       # %bb.0:
; SANDY-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SANDY-NEXT:    #APP
; SANDY-NEXT:    das # sched: [100:0.33]
; SANDY-NEXT:    #NO_APP
; SANDY-NEXT:    retl # sched: [5:1.00]
;
; HASWELL-LABEL: test_das:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; HASWELL-NEXT:    #APP
; HASWELL-NEXT:    das # sched: [100:0.25]
; HASWELL-NEXT:    #NO_APP
; HASWELL-NEXT:    retl # sched: [7:1.00]
;
; BROADWELL-LABEL: test_das:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; BROADWELL-NEXT:    #APP
; BROADWELL-NEXT:    das # sched: [100:0.25]
; BROADWELL-NEXT:    #NO_APP
; BROADWELL-NEXT:    retl # sched: [6:0.50]
;
; SKYLAKE-LABEL: test_das:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SKYLAKE-NEXT:    #APP
; SKYLAKE-NEXT:    das # sched: [100:0.25]
; SKYLAKE-NEXT:    #NO_APP
; SKYLAKE-NEXT:    retl # sched: [6:0.50]
;
; SKX-LABEL: test_das:
; SKX:       # %bb.0:
; SKX-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:0.50]
; SKX-NEXT:    #APP
; SKX-NEXT:    das # sched: [100:0.25]
; SKX-NEXT:    #NO_APP
; SKX-NEXT:    retl # sched: [6:0.50]
;
; BTVER2-LABEL: test_das:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [5:1.00]
; BTVER2-NEXT:    #APP
; BTVER2-NEXT:    das # sched: [100:0.17]
; BTVER2-NEXT:    #NO_APP
; BTVER2-NEXT:    retl # sched: [4:1.00]
;
; ZNVER1-LABEL: test_das:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movb {{[0-9]+}}(%esp), %al # sched: [8:0.50]
; ZNVER1-NEXT:    #APP
; ZNVER1-NEXT:    das # sched: [100:?]
; ZNVER1-NEXT:    #NO_APP
; ZNVER1-NEXT:    retl # sched: [1:0.50]
  %1 = tail call i8 asm "das", "=r,r"(i8 %a0) nounwind
  ret i8 %1
}

define void @test_dec16(i16 %a0, i16* %a1) optsize {
; GENERIC-LABEL: test_dec16:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; GENERIC-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    decw %ax
; GENERIC-NEXT:    decw (%ecx)
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retl
;
; ATOM-LABEL: test_dec16:
; ATOM:       # %bb.0:
; ATOM-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [1:1.00]
; ATOM-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [1:1.00]
; ATOM-NEXT:    #APP
; ATOM-NEXT:    decw %ax # sched: [1:0.50]
; ATOM-NEXT:    decw (%ecx) # sched: [1:1.00]
; ATOM-NEXT:    #NO_APP
; ATOM-NEXT:    retl # sched: [79:39.50]
;
; SLM-LABEL: test_dec16:
; SLM:       # %bb.0:
; SLM-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [4:1.00]
; SLM-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [3:1.00]
; SLM-NEXT:    #APP
; SLM-NEXT:    decw %ax # sched: [1:0.50]
; SLM-NEXT:    decw (%ecx) # sched: [4:2.00]
; SLM-NEXT:    #NO_APP
; SLM-NEXT:    retl # sched: [4:1.00]
;
; SANDY-LABEL: test_dec16:
; SANDY:       # %bb.0:
; SANDY-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SANDY-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; SANDY-NEXT:    #APP
; SANDY-NEXT:    decw %ax # sched: [1:0.33]
; SANDY-NEXT:    decw (%ecx) # sched: [7:1.00]
; SANDY-NEXT:    #NO_APP
; SANDY-NEXT:    retl # sched: [5:1.00]
;
; HASWELL-LABEL: test_dec16:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; HASWELL-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; HASWELL-NEXT:    #APP
; HASWELL-NEXT:    decw %ax # sched: [1:0.25]
; HASWELL-NEXT:    decw (%ecx) # sched: [7:1.00]
; HASWELL-NEXT:    #NO_APP
; HASWELL-NEXT:    retl # sched: [7:1.00]
;
; BROADWELL-LABEL: test_dec16:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; BROADWELL-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; BROADWELL-NEXT:    #APP
; BROADWELL-NEXT:    decw %ax # sched: [1:0.25]
; BROADWELL-NEXT:    decw (%ecx) # sched: [6:1.00]
; BROADWELL-NEXT:    #NO_APP
; BROADWELL-NEXT:    retl # sched: [6:0.50]
;
; SKYLAKE-LABEL: test_dec16:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SKYLAKE-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; SKYLAKE-NEXT:    #APP
; SKYLAKE-NEXT:    decw %ax # sched: [1:0.25]
; SKYLAKE-NEXT:    decw (%ecx) # sched: [6:1.00]
; SKYLAKE-NEXT:    #NO_APP
; SKYLAKE-NEXT:    retl # sched: [6:0.50]
;
; SKX-LABEL: test_dec16:
; SKX:       # %bb.0:
; SKX-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SKX-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; SKX-NEXT:    #APP
; SKX-NEXT:    decw %ax # sched: [1:0.25]
; SKX-NEXT:    decw (%ecx) # sched: [6:1.00]
; SKX-NEXT:    #NO_APP
; SKX-NEXT:    retl # sched: [6:0.50]
;
; BTVER2-LABEL: test_dec16:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [4:1.00]
; BTVER2-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:1.00]
; BTVER2-NEXT:    #APP
; BTVER2-NEXT:    decw %ax # sched: [1:0.50]
; BTVER2-NEXT:    decw (%ecx) # sched: [4:1.00]
; BTVER2-NEXT:    #NO_APP
; BTVER2-NEXT:    retl # sched: [4:1.00]
;
; ZNVER1-LABEL: test_dec16:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [8:0.50]
; ZNVER1-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [8:0.50]
; ZNVER1-NEXT:    #APP
; ZNVER1-NEXT:    decw %ax # sched: [1:0.25]
; ZNVER1-NEXT:    decw (%ecx) # sched: [5:0.50]
; ZNVER1-NEXT:    #NO_APP
; ZNVER1-NEXT:    retl # sched: [1:0.50]
  tail call void asm "decw $0 \0A\09 decw $1", "r,*m"(i16 %a0, i16* %a1) nounwind
  ret void
}
define void @test_dec32(i32 %a0, i32* %a1) optsize {
; GENERIC-LABEL: test_dec32:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movl {{[0-9]+}}(%esp), %eax
; GENERIC-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    decl %eax
; GENERIC-NEXT:    decl (%ecx)
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retl
;
; ATOM-LABEL: test_dec32:
; ATOM:       # %bb.0:
; ATOM-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [1:1.00]
; ATOM-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [1:1.00]
; ATOM-NEXT:    #APP
; ATOM-NEXT:    decl %eax # sched: [1:0.50]
; ATOM-NEXT:    decl (%ecx) # sched: [1:1.00]
; ATOM-NEXT:    #NO_APP
; ATOM-NEXT:    retl # sched: [79:39.50]
;
; SLM-LABEL: test_dec32:
; SLM:       # %bb.0:
; SLM-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [3:1.00]
; SLM-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [3:1.00]
; SLM-NEXT:    #APP
; SLM-NEXT:    decl %eax # sched: [1:0.50]
; SLM-NEXT:    decl (%ecx) # sched: [4:2.00]
; SLM-NEXT:    #NO_APP
; SLM-NEXT:    retl # sched: [4:1.00]
;
; SANDY-LABEL: test_dec32:
; SANDY:       # %bb.0:
; SANDY-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SANDY-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; SANDY-NEXT:    #APP
; SANDY-NEXT:    decl %eax # sched: [1:0.33]
; SANDY-NEXT:    decl (%ecx) # sched: [7:1.00]
; SANDY-NEXT:    #NO_APP
; SANDY-NEXT:    retl # sched: [5:1.00]
;
; HASWELL-LABEL: test_dec32:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; HASWELL-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; HASWELL-NEXT:    #APP
; HASWELL-NEXT:    decl %eax # sched: [1:0.25]
; HASWELL-NEXT:    decl (%ecx) # sched: [7:1.00]
; HASWELL-NEXT:    #NO_APP
; HASWELL-NEXT:    retl # sched: [7:1.00]
;
; BROADWELL-LABEL: test_dec32:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; BROADWELL-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; BROADWELL-NEXT:    #APP
; BROADWELL-NEXT:    decl %eax # sched: [1:0.25]
; BROADWELL-NEXT:    decl (%ecx) # sched: [6:1.00]
; BROADWELL-NEXT:    #NO_APP
; BROADWELL-NEXT:    retl # sched: [6:0.50]
;
; SKYLAKE-LABEL: test_dec32:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SKYLAKE-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; SKYLAKE-NEXT:    #APP
; SKYLAKE-NEXT:    decl %eax # sched: [1:0.25]
; SKYLAKE-NEXT:    decl (%ecx) # sched: [6:1.00]
; SKYLAKE-NEXT:    #NO_APP
; SKYLAKE-NEXT:    retl # sched: [6:0.50]
;
; SKX-LABEL: test_dec32:
; SKX:       # %bb.0:
; SKX-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SKX-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; SKX-NEXT:    #APP
; SKX-NEXT:    decl %eax # sched: [1:0.25]
; SKX-NEXT:    decl (%ecx) # sched: [6:1.00]
; SKX-NEXT:    #NO_APP
; SKX-NEXT:    retl # sched: [6:0.50]
;
; BTVER2-LABEL: test_dec32:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [5:1.00]
; BTVER2-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:1.00]
; BTVER2-NEXT:    #APP
; BTVER2-NEXT:    decl %eax # sched: [1:0.50]
; BTVER2-NEXT:    decl (%ecx) # sched: [4:1.00]
; BTVER2-NEXT:    #NO_APP
; BTVER2-NEXT:    retl # sched: [4:1.00]
;
; ZNVER1-LABEL: test_dec32:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [8:0.50]
; ZNVER1-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [8:0.50]
; ZNVER1-NEXT:    #APP
; ZNVER1-NEXT:    decl %eax # sched: [1:0.25]
; ZNVER1-NEXT:    decl (%ecx) # sched: [5:0.50]
; ZNVER1-NEXT:    #NO_APP
; ZNVER1-NEXT:    retl # sched: [1:0.50]
  tail call void asm "decl $0 \0A\09 decl $1", "r,*m"(i32 %a0, i32* %a1) nounwind
  ret void
}

define void @test_inc16(i16 %a0, i16* %a1) optsize {
; GENERIC-LABEL: test_inc16:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; GENERIC-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    incw %ax
; GENERIC-NEXT:    incw (%ecx)
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retl
;
; ATOM-LABEL: test_inc16:
; ATOM:       # %bb.0:
; ATOM-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [1:1.00]
; ATOM-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [1:1.00]
; ATOM-NEXT:    #APP
; ATOM-NEXT:    incw %ax # sched: [1:0.50]
; ATOM-NEXT:    incw (%ecx) # sched: [1:1.00]
; ATOM-NEXT:    #NO_APP
; ATOM-NEXT:    retl # sched: [79:39.50]
;
; SLM-LABEL: test_inc16:
; SLM:       # %bb.0:
; SLM-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [4:1.00]
; SLM-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [3:1.00]
; SLM-NEXT:    #APP
; SLM-NEXT:    incw %ax # sched: [1:0.50]
; SLM-NEXT:    incw (%ecx) # sched: [4:2.00]
; SLM-NEXT:    #NO_APP
; SLM-NEXT:    retl # sched: [4:1.00]
;
; SANDY-LABEL: test_inc16:
; SANDY:       # %bb.0:
; SANDY-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SANDY-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; SANDY-NEXT:    #APP
; SANDY-NEXT:    incw %ax # sched: [1:0.33]
; SANDY-NEXT:    incw (%ecx) # sched: [7:1.00]
; SANDY-NEXT:    #NO_APP
; SANDY-NEXT:    retl # sched: [5:1.00]
;
; HASWELL-LABEL: test_inc16:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; HASWELL-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; HASWELL-NEXT:    #APP
; HASWELL-NEXT:    incw %ax # sched: [1:0.25]
; HASWELL-NEXT:    incw (%ecx) # sched: [7:1.00]
; HASWELL-NEXT:    #NO_APP
; HASWELL-NEXT:    retl # sched: [7:1.00]
;
; BROADWELL-LABEL: test_inc16:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; BROADWELL-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; BROADWELL-NEXT:    #APP
; BROADWELL-NEXT:    incw %ax # sched: [1:0.25]
; BROADWELL-NEXT:    incw (%ecx) # sched: [6:1.00]
; BROADWELL-NEXT:    #NO_APP
; BROADWELL-NEXT:    retl # sched: [6:0.50]
;
; SKYLAKE-LABEL: test_inc16:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SKYLAKE-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; SKYLAKE-NEXT:    #APP
; SKYLAKE-NEXT:    incw %ax # sched: [1:0.25]
; SKYLAKE-NEXT:    incw (%ecx) # sched: [6:1.00]
; SKYLAKE-NEXT:    #NO_APP
; SKYLAKE-NEXT:    retl # sched: [6:0.50]
;
; SKX-LABEL: test_inc16:
; SKX:       # %bb.0:
; SKX-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SKX-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; SKX-NEXT:    #APP
; SKX-NEXT:    incw %ax # sched: [1:0.25]
; SKX-NEXT:    incw (%ecx) # sched: [6:1.00]
; SKX-NEXT:    #NO_APP
; SKX-NEXT:    retl # sched: [6:0.50]
;
; BTVER2-LABEL: test_inc16:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [4:1.00]
; BTVER2-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:1.00]
; BTVER2-NEXT:    #APP
; BTVER2-NEXT:    incw %ax # sched: [1:0.50]
; BTVER2-NEXT:    incw (%ecx) # sched: [4:1.00]
; BTVER2-NEXT:    #NO_APP
; BTVER2-NEXT:    retl # sched: [4:1.00]
;
; ZNVER1-LABEL: test_inc16:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [8:0.50]
; ZNVER1-NEXT:    movzwl {{[0-9]+}}(%esp), %eax # sched: [8:0.50]
; ZNVER1-NEXT:    #APP
; ZNVER1-NEXT:    incw %ax # sched: [1:0.25]
; ZNVER1-NEXT:    incw (%ecx) # sched: [5:0.50]
; ZNVER1-NEXT:    #NO_APP
; ZNVER1-NEXT:    retl # sched: [1:0.50]
  tail call void asm "incw $0 \0A\09 incw $1", "r,*m"(i16 %a0, i16* %a1) nounwind
  ret void
}
define void @test_inc32(i32 %a0, i32* %a1) optsize {
; GENERIC-LABEL: test_inc32:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movl {{[0-9]+}}(%esp), %eax
; GENERIC-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    incl %eax
; GENERIC-NEXT:    incl (%ecx)
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retl
;
; ATOM-LABEL: test_inc32:
; ATOM:       # %bb.0:
; ATOM-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [1:1.00]
; ATOM-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [1:1.00]
; ATOM-NEXT:    #APP
; ATOM-NEXT:    incl %eax # sched: [1:0.50]
; ATOM-NEXT:    incl (%ecx) # sched: [1:1.00]
; ATOM-NEXT:    #NO_APP
; ATOM-NEXT:    retl # sched: [79:39.50]
;
; SLM-LABEL: test_inc32:
; SLM:       # %bb.0:
; SLM-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [3:1.00]
; SLM-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [3:1.00]
; SLM-NEXT:    #APP
; SLM-NEXT:    incl %eax # sched: [1:0.50]
; SLM-NEXT:    incl (%ecx) # sched: [4:2.00]
; SLM-NEXT:    #NO_APP
; SLM-NEXT:    retl # sched: [4:1.00]
;
; SANDY-LABEL: test_inc32:
; SANDY:       # %bb.0:
; SANDY-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SANDY-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; SANDY-NEXT:    #APP
; SANDY-NEXT:    incl %eax # sched: [1:0.33]
; SANDY-NEXT:    incl (%ecx) # sched: [7:1.00]
; SANDY-NEXT:    #NO_APP
; SANDY-NEXT:    retl # sched: [5:1.00]
;
; HASWELL-LABEL: test_inc32:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; HASWELL-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; HASWELL-NEXT:    #APP
; HASWELL-NEXT:    incl %eax # sched: [1:0.25]
; HASWELL-NEXT:    incl (%ecx) # sched: [7:1.00]
; HASWELL-NEXT:    #NO_APP
; HASWELL-NEXT:    retl # sched: [7:1.00]
;
; BROADWELL-LABEL: test_inc32:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; BROADWELL-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; BROADWELL-NEXT:    #APP
; BROADWELL-NEXT:    incl %eax # sched: [1:0.25]
; BROADWELL-NEXT:    incl (%ecx) # sched: [6:1.00]
; BROADWELL-NEXT:    #NO_APP
; BROADWELL-NEXT:    retl # sched: [6:0.50]
;
; SKYLAKE-LABEL: test_inc32:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SKYLAKE-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; SKYLAKE-NEXT:    #APP
; SKYLAKE-NEXT:    incl %eax # sched: [1:0.25]
; SKYLAKE-NEXT:    incl (%ecx) # sched: [6:1.00]
; SKYLAKE-NEXT:    #NO_APP
; SKYLAKE-NEXT:    retl # sched: [6:0.50]
;
; SKX-LABEL: test_inc32:
; SKX:       # %bb.0:
; SKX-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [5:0.50]
; SKX-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:0.50]
; SKX-NEXT:    #APP
; SKX-NEXT:    incl %eax # sched: [1:0.25]
; SKX-NEXT:    incl (%ecx) # sched: [6:1.00]
; SKX-NEXT:    #NO_APP
; SKX-NEXT:    retl # sched: [6:0.50]
;
; BTVER2-LABEL: test_inc32:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [5:1.00]
; BTVER2-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [5:1.00]
; BTVER2-NEXT:    #APP
; BTVER2-NEXT:    incl %eax # sched: [1:0.50]
; BTVER2-NEXT:    incl (%ecx) # sched: [4:1.00]
; BTVER2-NEXT:    #NO_APP
; BTVER2-NEXT:    retl # sched: [4:1.00]
;
; ZNVER1-LABEL: test_inc32:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movl {{[0-9]+}}(%esp), %eax # sched: [8:0.50]
; ZNVER1-NEXT:    movl {{[0-9]+}}(%esp), %ecx # sched: [8:0.50]
; ZNVER1-NEXT:    #APP
; ZNVER1-NEXT:    incl %eax # sched: [1:0.25]
; ZNVER1-NEXT:    incl (%ecx) # sched: [5:0.50]
; ZNVER1-NEXT:    #NO_APP
; ZNVER1-NEXT:    retl # sched: [1:0.50]
  tail call void asm "incl $0 \0A\09 incl $1", "r,*m"(i32 %a0, i32* %a1) nounwind
  ret void
}

define i8 @test_salc() optsize {
; GENERIC-LABEL: test_salc:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    salc
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retl
;
; ATOM-LABEL: test_salc:
; ATOM:       # %bb.0:
; ATOM-NEXT:    #APP
; ATOM-NEXT:    salc # sched: [1:0.50]
; ATOM-NEXT:    #NO_APP
; ATOM-NEXT:    retl # sched: [79:39.50]
;
; SLM-LABEL: test_salc:
; SLM:       # %bb.0:
; SLM-NEXT:    #APP
; SLM-NEXT:    salc # sched: [1:0.50]
; SLM-NEXT:    #NO_APP
; SLM-NEXT:    retl # sched: [4:1.00]
;
; SANDY-LABEL: test_salc:
; SANDY:       # %bb.0:
; SANDY-NEXT:    #APP
; SANDY-NEXT:    salc # sched: [1:0.33]
; SANDY-NEXT:    #NO_APP
; SANDY-NEXT:    retl # sched: [5:1.00]
;
; HASWELL-LABEL: test_salc:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    #APP
; HASWELL-NEXT:    salc # sched: [1:0.25]
; HASWELL-NEXT:    #NO_APP
; HASWELL-NEXT:    retl # sched: [7:1.00]
;
; BROADWELL-LABEL: test_salc:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    #APP
; BROADWELL-NEXT:    salc # sched: [1:0.25]
; BROADWELL-NEXT:    #NO_APP
; BROADWELL-NEXT:    retl # sched: [6:0.50]
;
; SKYLAKE-LABEL: test_salc:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    #APP
; SKYLAKE-NEXT:    salc # sched: [1:0.25]
; SKYLAKE-NEXT:    #NO_APP
; SKYLAKE-NEXT:    retl # sched: [6:0.50]
;
; SKX-LABEL: test_salc:
; SKX:       # %bb.0:
; SKX-NEXT:    #APP
; SKX-NEXT:    salc # sched: [1:0.25]
; SKX-NEXT:    #NO_APP
; SKX-NEXT:    retl # sched: [6:0.50]
;
; BTVER2-LABEL: test_salc:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    #APP
; BTVER2-NEXT:    salc # sched: [1:0.50]
; BTVER2-NEXT:    #NO_APP
; BTVER2-NEXT:    retl # sched: [4:1.00]
;
; ZNVER1-LABEL: test_salc:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    #APP
; ZNVER1-NEXT:    salc # sched: [1:0.25]
; ZNVER1-NEXT:    #NO_APP
; ZNVER1-NEXT:    retl # sched: [1:0.50]
  %1 = tail call i8 asm "salc", "=r"() nounwind
  ret i8 %1
}
