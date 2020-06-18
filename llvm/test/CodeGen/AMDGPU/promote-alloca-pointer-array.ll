; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -mtriple=amdgcn-- -mcpu=fiji -data-layout=A5 -amdgpu-promote-alloca < %s | FileCheck -check-prefix=OPT %s

define i64 @test_pointer_array(i64 %v) {
; OPT-LABEL: @test_pointer_array(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[A:%.*]] = alloca [3 x i8*], align 16, addrspace(5)
; OPT-NEXT:    [[GEP:%.*]] = getelementptr inbounds [3 x i8*], [3 x i8*] addrspace(5)* [[A]], i32 0, i32 0
; OPT-NEXT:    [[CAST:%.*]] = bitcast i8* addrspace(5)* [[GEP]] to i64 addrspace(5)*
; OPT-NEXT:    [[TMP0:%.*]] = bitcast [3 x i8*] addrspace(5)* [[A]] to <3 x i8*> addrspace(5)*
; OPT-NEXT:    [[TMP1:%.*]] = load <3 x i8*>, <3 x i8*> addrspace(5)* [[TMP0]], align 32
; OPT-NEXT:    [[TMP2:%.*]] = inttoptr i64 [[V:%.*]] to i8*
; OPT-NEXT:    [[TMP3:%.*]] = insertelement <3 x i8*> [[TMP1]], i8* [[TMP2]], i32 0
; OPT-NEXT:    store <3 x i8*> [[TMP3]], <3 x i8*> addrspace(5)* [[TMP0]], align 32
; OPT-NEXT:    [[TMP4:%.*]] = bitcast [3 x i8*] addrspace(5)* [[A]] to <3 x i8*> addrspace(5)*
; OPT-NEXT:    [[TMP5:%.*]] = load <3 x i8*>, <3 x i8*> addrspace(5)* [[TMP4]], align 32
; OPT-NEXT:    [[TMP6:%.*]] = extractelement <3 x i8*> [[TMP5]], i32 0
; OPT-NEXT:    [[TMP7:%.*]] = ptrtoint i8* [[TMP6]] to i64
; OPT-NEXT:    ret i64 [[TMP7]]
;
entry:
  %a = alloca [3 x i8*], align 16, addrspace(5)
  %gep = getelementptr inbounds [3 x i8*], [3 x i8*] addrspace(5)* %a, i32 0, i32 0
  %cast = bitcast i8* addrspace(5)* %gep to i64 addrspace(5)*
  store i64 %v, i64 addrspace(5)* %cast, align 16
  %ld = load i64, i64 addrspace(5)* %cast, align 16
  ret i64 %ld
}
