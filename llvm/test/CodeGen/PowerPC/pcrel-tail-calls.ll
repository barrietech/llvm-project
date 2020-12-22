; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s
; RUN: llc -verify-machineinstrs -target-abi=elfv2 -mtriple=powerpc64-- \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s


; The tests check the behaviour of PC Relative tail calls. When using
; PC Relative we are able to do more tail calling than we have done in
; the past as we no longer need to restore the TOC pointer into R2 after
; most calls.

@Func = external local_unnamed_addr global i32 (...)*, align 8
@FuncLocal = common dso_local local_unnamed_addr global i32 (...)* null, align 8

; No calls in this function but we assign the function pointers.
define dso_local void @AssignFuncPtr() local_unnamed_addr {
; CHECK-LABEL: AssignFuncPtr:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, Func@got@pcrel(0), 1
; CHECK-NEXT:    pld r4, Function@got@pcrel(0), 1
; CHECK-NEXT:    std r4, 0(r3)
; CHECK-NEXT:    pstd r4, FuncLocal@PCREL(0), 1
; CHECK-NEXT:    blr
entry:
  store i32 (...)* @Function, i32 (...)** @Func, align 8
  store i32 (...)* @Function, i32 (...)** @FuncLocal, align 8
  ret void
}

declare signext i32 @Function(...)

define dso_local void @TailCallLocalFuncPtr() local_unnamed_addr {
; CHECK-LABEL: TailCallLocalFuncPtr:
; CHECK:         .localentry TailCallLocalFuncPtr, 1
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    pld r12, FuncLocal@PCREL(0), 1
; CHECK-NEXT:    mtctr r12
; CHECK-NEXT:    bctr
; CHECK-NEXT:    #TC_RETURNr8 ctr 0
entry:
  %0 = load i32 ()*, i32 ()** bitcast (i32 (...)** @FuncLocal to i32 ()**), align 8
  %call = tail call signext i32 %0()
  ret void
}

define dso_local void @TailCallExtrnFuncPtr() local_unnamed_addr {
; CHECK-LABEL: TailCallExtrnFuncPtr:
; CHECK:         .localentry TailCallExtrnFuncPtr, 1
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    pld r3, Func@got@pcrel(0), 1
; CHECK-NEXT:  .Lpcrel0:
; CHECK-NEXT:    .reloc .Lpcrel0-8,R_PPC64_PCREL_OPT,.-(.Lpcrel0-8)
; CHECK-NEXT:    ld r12, 0(r3)
; CHECK-NEXT:    mtctr r12
; CHECK-NEXT:    bctr
; CHECK-NEXT:    #TC_RETURNr8 ctr 0
entry:
  %0 = load i32 ()*, i32 ()** bitcast (i32 (...)** @Func to i32 ()**), align 8
  %call = tail call signext i32 %0()
  ret void
}

define dso_local signext i32 @TailCallParamFuncPtr(i32 (...)* nocapture %passedfunc) local_unnamed_addr {
; CHECK-LABEL: TailCallParamFuncPtr:
; CHECK:         .localentry TailCallParamFuncPtr, 1
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    mtctr r3
; CHECK-NEXT:    mr r12, r3
; CHECK-NEXT:    bctr
; CHECK-NEXT:    #TC_RETURNr8 ctr 0
entry:
  %callee.knr.cast = bitcast i32 (...)* %passedfunc to i32 ()*
  %call = tail call signext i32 %callee.knr.cast()
  ret i32 %call
}

define dso_local signext i32 @NoTailIndirectCall(i32 (...)* nocapture %passedfunc, i32 signext %a) local_unnamed_addr {
; CHECK-LABEL: NoTailIndirectCall:
; CHECK:         .localentry NoTailIndirectCall, 1
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    mflr r0
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    .cfi_offset r30, -16
; CHECK-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-NEXT:    std r0, 16(r1)
; CHECK-NEXT:    stdu r1, -48(r1)
; CHECK-NEXT:    mtctr r3
; CHECK-NEXT:    mr r12, r3
; CHECK-NEXT:    mr r30, r4
; CHECK-NEXT:    bctrl
; CHECK-NEXT:    add r3, r3, r30
; CHECK-NEXT:    extsw r3, r3
; CHECK-NEXT:    addi r1, r1, 48
; CHECK-NEXT:    ld r0, 16(r1)
; CHECK-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-NEXT:    mtlr r0
; CHECK-NEXT:    blr
entry:
  %callee.knr.cast = bitcast i32 (...)* %passedfunc to i32 ()*
  %call = tail call signext i32 %callee.knr.cast()
  %add = add nsw i32 %call, %a
  ret i32 %add
}

define dso_local signext i32 @TailCallDirect() local_unnamed_addr {
; CHECK-LABEL: TailCallDirect:
; CHECK:         .localentry TailCallDirect, 1
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    b Function@notoc
; CHECK-NEXT:    #TC_RETURNd8 Function@notoc 0
entry:
  %call = tail call signext i32 bitcast (i32 (...)* @Function to i32 ()*)()
  ret i32 %call
}

define dso_local signext i32 @NoTailCallDirect(i32 signext %a) local_unnamed_addr {
; CHECK-LABEL: NoTailCallDirect:
; CHECK:         .localentry NoTailCallDirect, 1
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    mflr r0
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    .cfi_offset r30, -16
; CHECK-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-NEXT:    std r0, 16(r1)
; CHECK-NEXT:    stdu r1, -48(r1)
; CHECK-NEXT:    mr r30, r3
; CHECK-NEXT:    bl Function@notoc
; CHECK-NEXT:    add r3, r3, r30
; CHECK-NEXT:    extsw r3, r3
; CHECK-NEXT:    addi r1, r1, 48
; CHECK-NEXT:    ld r0, 16(r1)
; CHECK-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-NEXT:    mtlr r0
; CHECK-NEXT:    blr
entry:
  %call = tail call signext i32 bitcast (i32 (...)* @Function to i32 ()*)()
  %add = add nsw i32 %call, %a
  ret i32 %add
}

define dso_local signext i32 @TailCallDirectLocal() local_unnamed_addr {
; CHECK-LABEL: TailCallDirectLocal:
; CHECK:         .localentry TailCallDirectLocal, 1
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    b LocalFunction@notoc
; CHECK-NEXT:    #TC_RETURNd8 LocalFunction@notoc 0
entry:
  %call = tail call fastcc signext i32 @LocalFunction()
  ret i32 %call
}

define dso_local signext i32 @NoTailCallDirectLocal(i32 signext %a) local_unnamed_addr {
; CHECK-LABEL: NoTailCallDirectLocal:
; CHECK:         .localentry NoTailCallDirectLocal, 1
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    mflr r0
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    .cfi_offset r30, -16
; CHECK-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-NEXT:    std r0, 16(r1)
; CHECK-NEXT:    stdu r1, -48(r1)
; CHECK-NEXT:    mr r30, r3
; CHECK-NEXT:    bl LocalFunction@notoc
; CHECK-NEXT:    add r3, r3, r30
; CHECK-NEXT:    extsw r3, r3
; CHECK-NEXT:    addi r1, r1, 48
; CHECK-NEXT:    ld r0, 16(r1)
; CHECK-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-NEXT:    mtlr r0
; CHECK-NEXT:    blr
entry:
  %call = tail call fastcc signext i32 @LocalFunction()
  %add = add nsw i32 %call, %a
  ret i32 %add
}

define dso_local signext i32 @TailCallAbs() local_unnamed_addr {
; CHECK-LABEL: TailCallAbs:
; CHECK:         .localentry TailCallAbs, 1
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    li r3, 400
; CHECK-NEXT:    li r12, 400
; CHECK-NEXT:    mtctr r3
; CHECK-NEXT:    bctr
; CHECK-NEXT:    #TC_RETURNr8 ctr 0
entry:
  %call = tail call signext i32 inttoptr (i64 400 to i32 ()*)()
  ret i32 %call
}

define dso_local signext i32 @NoTailCallAbs(i32 signext %a) local_unnamed_addr {
; CHECK-LABEL: NoTailCallAbs:
; CHECK:         .localentry NoTailCallAbs, 1
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    mflr r0
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    .cfi_offset r30, -16
; CHECK-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-NEXT:    std r0, 16(r1)
; CHECK-NEXT:    stdu r1, -48(r1)
; CHECK-NEXT:    mr r30, r3
; CHECK-NEXT:    li r3, 400
; CHECK-NEXT:    li r12, 400
; CHECK-NEXT:    mtctr r3
; CHECK-NEXT:    bctrl
; CHECK-NEXT:    add r3, r3, r30
; CHECK-NEXT:    extsw r3, r3
; CHECK-NEXT:    addi r1, r1, 48
; CHECK-NEXT:    ld r0, 16(r1)
; CHECK-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-NEXT:    mtlr r0
; CHECK-NEXT:    blr
entry:
  %call = tail call signext i32 inttoptr (i64 400 to i32 ()*)()
  %add = add nsw i32 %call, %a
  ret i32 %add
}

; Function Attrs: noinline
; This function should be tail called and not inlined.
define internal fastcc signext i32 @LocalFunction() unnamed_addr #0 {
; CHECK-LABEL: LocalFunction:
; CHECK:         .localentry LocalFunction, 1
; CHECK-NEXT:  # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    li r3, 42
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    extsw r3, r3
; CHECK-NEXT:    blr
entry:
  %0 = tail call i32 asm "li $0, 42", "=&r"()
  ret i32 %0
}

attributes #0 = { noinline }

