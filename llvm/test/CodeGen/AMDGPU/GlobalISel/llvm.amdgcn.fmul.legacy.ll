; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=tahiti  -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX6 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=tonga   -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX8 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx900  -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX9 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX101 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1030 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX103 %s

define float @v_mul_legacy_f32(float %a, float %b) {
; GFX6-LABEL: v_mul_legacy_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mul_legacy_f32_e32 v0, v0, v1
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_legacy_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_legacy_f32_e32 v0, v0, v1
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_mul_legacy_f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_legacy_f32_e32 v0, v0, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX101-LABEL: v_mul_legacy_f32:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX101-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX101-NEXT:    v_mul_legacy_f32_e32 v0, v0, v1
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    s_setpc_b64 s[30:31]
;
; GFX103-LABEL: v_mul_legacy_f32:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX103-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX103-NEXT:    v_mul_legacy_f32_e32 v0, v0, v1
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    s_setpc_b64 s[30:31]
  %result = call float @llvm.amdgcn.fmul.legacy(float %a, float %b)
  ret float %result
}

define float @v_mul_legacy_undef0_f32(float %a) {
; GFX6-LABEL: v_mul_legacy_undef0_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mul_legacy_f32_e32 v0, s4, v0
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_legacy_undef0_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_legacy_f32_e32 v0, s4, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_mul_legacy_undef0_f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_legacy_f32_e32 v0, s4, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX101-LABEL: v_mul_legacy_undef0_f32:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX101-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX101-NEXT:    v_mul_legacy_f32_e32 v0, s4, v0
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    s_setpc_b64 s[30:31]
;
; GFX103-LABEL: v_mul_legacy_undef0_f32:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX103-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX103-NEXT:    v_mul_legacy_f32_e32 v0, s4, v0
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    s_setpc_b64 s[30:31]
  %result = call float @llvm.amdgcn.fmul.legacy(float undef, float %a)
  ret float %result
}

define float @v_mul_legacy_undef1_f32(float %a) {
; GFX6-LABEL: v_mul_legacy_undef1_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mul_legacy_f32_e32 v0, s4, v0
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_legacy_undef1_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_legacy_f32_e32 v0, s4, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_mul_legacy_undef1_f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_legacy_f32_e32 v0, s4, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX101-LABEL: v_mul_legacy_undef1_f32:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX101-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX101-NEXT:    v_mul_legacy_f32_e32 v0, s4, v0
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    s_setpc_b64 s[30:31]
;
; GFX103-LABEL: v_mul_legacy_undef1_f32:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX103-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX103-NEXT:    v_mul_legacy_f32_e32 v0, s4, v0
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    s_setpc_b64 s[30:31]
  %result = call float @llvm.amdgcn.fmul.legacy(float %a, float undef)
  ret float %result
}

define float @v_mul_legacy_undef_f32() {
; GFX6-LABEL: v_mul_legacy_undef_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mul_legacy_f32_e64 v0, s4, s4
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_legacy_undef_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_legacy_f32_e64 v0, s4, s4
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_mul_legacy_undef_f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_legacy_f32_e64 v0, s4, s4
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX101-LABEL: v_mul_legacy_undef_f32:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX101-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX101-NEXT:    v_mul_legacy_f32_e64 v0, s4, s4
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    s_setpc_b64 s[30:31]
;
; GFX103-LABEL: v_mul_legacy_undef_f32:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX103-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX103-NEXT:    v_mul_legacy_f32_e64 v0, s4, s4
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    s_setpc_b64 s[30:31]
  %result = call float @llvm.amdgcn.fmul.legacy(float undef, float undef)
  ret float %result
}

define float @v_mul_legacy_fabs_f32(float %a, float %b) {
; GFX6-LABEL: v_mul_legacy_fabs_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mul_legacy_f32_e64 v0, |v0|, |v1|
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_legacy_fabs_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_legacy_f32_e64 v0, |v0|, |v1|
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_mul_legacy_fabs_f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_legacy_f32_e64 v0, |v0|, |v1|
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX101-LABEL: v_mul_legacy_fabs_f32:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX101-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX101-NEXT:    v_mul_legacy_f32_e64 v0, |v0|, |v1|
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    s_setpc_b64 s[30:31]
;
; GFX103-LABEL: v_mul_legacy_fabs_f32:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX103-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX103-NEXT:    v_mul_legacy_f32_e64 v0, |v0|, |v1|
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    s_setpc_b64 s[30:31]
  %a.fabs = call float @llvm.fabs.f32(float %a)
  %b.fabs = call float @llvm.fabs.f32(float %b)
  %result = call float @llvm.amdgcn.fmul.legacy(float %a.fabs, float %b.fabs)
  ret float %result
}

define float @v_mul_legacy_fneg_f32(float %a, float %b) {
; GFX6-LABEL: v_mul_legacy_fneg_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mul_legacy_f32_e64 v0, -v0, -v1
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_legacy_fneg_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_legacy_f32_e64 v0, -v0, -v1
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_mul_legacy_fneg_f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_legacy_f32_e64 v0, -v0, -v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX101-LABEL: v_mul_legacy_fneg_f32:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX101-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX101-NEXT:    v_mul_legacy_f32_e64 v0, -v0, -v1
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    s_setpc_b64 s[30:31]
;
; GFX103-LABEL: v_mul_legacy_fneg_f32:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX103-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX103-NEXT:    v_mul_legacy_f32_e64 v0, -v0, -v1
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    s_setpc_b64 s[30:31]
  %a.fneg = fneg float %a
  %b.fneg = fneg float %b
  %result = call float @llvm.amdgcn.fmul.legacy(float %a.fneg, float %b.fneg)
  ret float %result
}

; Don't form mad/mac instructions because they don't support denormals.
define float @v_add_mul_legacy_f32(float %a, float %b, float %c) {
; GFX6-LABEL: v_add_mul_legacy_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mul_legacy_f32_e32 v0, v0, v1
; GFX6-NEXT:    v_add_f32_e32 v0, v0, v2
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_add_mul_legacy_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_legacy_f32_e32 v0, v0, v1
; GFX8-NEXT:    v_add_f32_e32 v0, v0, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_add_mul_legacy_f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_legacy_f32_e32 v0, v0, v1
; GFX9-NEXT:    v_add_f32_e32 v0, v0, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX101-LABEL: v_add_mul_legacy_f32:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX101-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX101-NEXT:    v_mul_legacy_f32_e32 v0, v0, v1
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    v_add_f32_e32 v0, v0, v2
; GFX101-NEXT:    s_setpc_b64 s[30:31]
;
; GFX103-LABEL: v_add_mul_legacy_f32:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX103-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX103-NEXT:    v_mul_legacy_f32_e32 v0, v0, v1
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    v_add_f32_e32 v0, v0, v2
; GFX103-NEXT:    s_setpc_b64 s[30:31]
  %mul = call float @llvm.amdgcn.fmul.legacy(float %a, float %b)
  %add = fadd float %mul, %c
  ret float %add
}

define float @v_mad_legacy_f32(float %a, float %b, float %c) #2 {
; GFX6-LABEL: v_mad_legacy_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mac_legacy_f32_e64 v2, v0, v1
; GFX6-NEXT:    v_mov_b32_e32 v0, v2
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mad_legacy_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mad_legacy_f32 v0, v0, v1, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_mad_legacy_f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_legacy_f32 v0, v0, v1, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX101-LABEL: v_mad_legacy_f32:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX101-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX101-NEXT:    v_mac_legacy_f32_e64 v2, v0, v1
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    v_mov_b32_e32 v0, v2
; GFX101-NEXT:    s_setpc_b64 s[30:31]
;
; GFX103-LABEL: v_mad_legacy_f32:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX103-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX103-NEXT:    v_mul_legacy_f32_e32 v0, v0, v1
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    v_add_f32_e32 v0, v0, v2
; GFX103-NEXT:    s_setpc_b64 s[30:31]
  %mul = call float @llvm.amdgcn.fmul.legacy(float %a, float %b)
  %add = fadd float %mul, %c
  ret float %add
}

define float @v_mad_legacy_fneg_f32(float %a, float %b, float %c) #2 {
; GFX6-LABEL: v_mad_legacy_fneg_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mad_legacy_f32 v0, -v0, -v1, v2
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mad_legacy_fneg_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mad_legacy_f32 v0, -v0, -v1, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_mad_legacy_fneg_f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mad_legacy_f32 v0, -v0, -v1, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX101-LABEL: v_mad_legacy_fneg_f32:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX101-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX101-NEXT:    v_mad_legacy_f32 v0, -v0, -v1, v2
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    s_setpc_b64 s[30:31]
;
; GFX103-LABEL: v_mad_legacy_fneg_f32:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX103-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX103-NEXT:    v_mul_legacy_f32_e64 v0, -v0, -v1
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    v_add_f32_e32 v0, v0, v2
; GFX103-NEXT:    s_setpc_b64 s[30:31]
  %a.fneg = fneg float %a
  %b.fneg = fneg float %b
  %mul = call float @llvm.amdgcn.fmul.legacy(float %a.fneg, float %b.fneg)
  %add = fadd float %mul, %c
  ret float %add
}

define amdgpu_ps float @s_mul_legacy_f32(float inreg %a, float inreg %b) {
; GFX6-LABEL: s_mul_legacy_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_mov_b32_e32 v0, s1
; GFX6-NEXT:    v_mul_legacy_f32_e32 v0, s0, v0
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_mul_legacy_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v0, s1
; GFX8-NEXT:    v_mul_legacy_f32_e32 v0, s0, v0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_mul_legacy_f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    v_mul_legacy_f32_e32 v0, s0, v0
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX101-LABEL: s_mul_legacy_f32:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    v_mul_legacy_f32_e64 v0, s0, s1
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    ; return to shader part epilog
;
; GFX103-LABEL: s_mul_legacy_f32:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    v_mul_legacy_f32_e64 v0, s0, s1
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    ; return to shader part epilog
  %result = call float @llvm.amdgcn.fmul.legacy(float %a, float %b)
  ret float %result
}

define float @v_mul_legacy_f32_1.0(float %a) {
; GFX6-LABEL: v_mul_legacy_f32_1.0:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mul_legacy_f32_e32 v0, 1.0, v0
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_legacy_f32_1.0:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_legacy_f32_e32 v0, 1.0, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_mul_legacy_f32_1.0:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_legacy_f32_e32 v0, 1.0, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX101-LABEL: v_mul_legacy_f32_1.0:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX101-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX101-NEXT:    v_mul_legacy_f32_e32 v0, 1.0, v0
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    s_setpc_b64 s[30:31]
;
; GFX103-LABEL: v_mul_legacy_f32_1.0:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX103-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX103-NEXT:    v_mul_legacy_f32_e32 v0, 1.0, v0
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    s_setpc_b64 s[30:31]
  %result = call float @llvm.amdgcn.fmul.legacy(float %a, float 1.0)
  ret float %result
}

define float @v_mul_legacy_f32_1.0_swap(float %b) {
; GFX6-LABEL: v_mul_legacy_f32_1.0_swap:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mul_legacy_f32_e32 v0, 1.0, v0
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_legacy_f32_1.0_swap:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_legacy_f32_e32 v0, 1.0, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_mul_legacy_f32_1.0_swap:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_legacy_f32_e32 v0, 1.0, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX101-LABEL: v_mul_legacy_f32_1.0_swap:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX101-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX101-NEXT:    v_mul_legacy_f32_e32 v0, 1.0, v0
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    s_setpc_b64 s[30:31]
;
; GFX103-LABEL: v_mul_legacy_f32_1.0_swap:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX103-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX103-NEXT:    v_mul_legacy_f32_e32 v0, 1.0, v0
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    s_setpc_b64 s[30:31]
  %result = call float @llvm.amdgcn.fmul.legacy(float 1.0, float %b)
  ret float %result
}

define float @v_mul_legacy_f32_2.0(float %a) {
; GFX6-LABEL: v_mul_legacy_f32_2.0:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mul_legacy_f32_e32 v0, 2.0, v0
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_legacy_f32_2.0:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_legacy_f32_e32 v0, 2.0, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_mul_legacy_f32_2.0:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_legacy_f32_e32 v0, 2.0, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX101-LABEL: v_mul_legacy_f32_2.0:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX101-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX101-NEXT:    v_mul_legacy_f32_e32 v0, 2.0, v0
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    s_setpc_b64 s[30:31]
;
; GFX103-LABEL: v_mul_legacy_f32_2.0:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX103-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX103-NEXT:    v_mul_legacy_f32_e32 v0, 2.0, v0
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    s_setpc_b64 s[30:31]
  %result = call float @llvm.amdgcn.fmul.legacy(float %a, float 2.0)
  ret float %result
}

define float @v_mul_legacy_f32_2.0_swap(float %b) {
; GFX6-LABEL: v_mul_legacy_f32_2.0_swap:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mul_legacy_f32_e32 v0, 2.0, v0
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_legacy_f32_2.0_swap:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_legacy_f32_e32 v0, 2.0, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_mul_legacy_f32_2.0_swap:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_legacy_f32_e32 v0, 2.0, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX101-LABEL: v_mul_legacy_f32_2.0_swap:
; GFX101:       ; %bb.0:
; GFX101-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX101-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX101-NEXT:    v_mul_legacy_f32_e32 v0, 2.0, v0
; GFX101-NEXT:    ; implicit-def: $vcc_hi
; GFX101-NEXT:    s_setpc_b64 s[30:31]
;
; GFX103-LABEL: v_mul_legacy_f32_2.0_swap:
; GFX103:       ; %bb.0:
; GFX103-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX103-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX103-NEXT:    v_mul_legacy_f32_e32 v0, 2.0, v0
; GFX103-NEXT:    ; implicit-def: $vcc_hi
; GFX103-NEXT:    s_setpc_b64 s[30:31]
  %result = call float @llvm.amdgcn.fmul.legacy(float 2.0, float %b)
  ret float %result
}

declare float @llvm.fabs.f32(float) #0
declare float @llvm.amdgcn.fmul.legacy(float, float) #1

attributes #0 = { nounwind readnone speculatable willreturn }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { "denormal-fp-math-f32"="preserve-sign" }
