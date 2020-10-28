; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc %s -mtriple=thumbv6m-arm-none-eabi -o - -asm-verbose=false | FileCheck %s --check-prefix=CHECK-V6M
; RUN: llc %s -mtriple=thumbv7m-arm-none-eabi -o - -asm-verbose=false | FileCheck %s --check-prefix=CHECK-V7M

define i32 @test_values(i32 %a, i32 %b) minsize optsize {
; CHECK-V6M-LABEL: test_values:
; CHECK-V6M:         mov r2, r0
; CHECK-V6M-NEXT:    ldr r0, .LCPI0_0
; CHECK-V6M-NEXT:    cmp r2, #50
; CHECK-V6M-NEXT:    beq .LBB0_5
; CHECK-V6M-NEXT:    cmp r2, #1
; CHECK-V6M-NEXT:    beq .LBB0_7
; CHECK-V6M-NEXT:    cmp r2, #30
; CHECK-V6M-NEXT:    beq .LBB0_8
; CHECK-V6M-NEXT:    cmp r2, #0
; CHECK-V6M-NEXT:    bne .LBB0_6
; CHECK-V6M-NEXT:    adds r0, r1, r0
; CHECK-V6M-NEXT:    bx lr
; CHECK-V6M-NEXT:  .LBB0_5:
; CHECK-V6M-NEXT:    adds r0, r0, r1
; CHECK-V6M-NEXT:    adds r0, r0, #4
; CHECK-V6M-NEXT:  .LBB0_6:
; CHECK-V6M-NEXT:    bx lr
; CHECK-V6M-NEXT:  .LBB0_7:
; CHECK-V6M-NEXT:    adds r0, r0, r1
; CHECK-V6M-NEXT:    adds r0, r0, #1
; CHECK-V6M-NEXT:    bx lr
; CHECK-V6M-NEXT:  .LBB0_8:
; CHECK-V6M-NEXT:    adds r0, r0, r1
; CHECK-V6M-NEXT:    adds r0, r0, #2
; CHECK-V6M-NEXT:    bx lr
; CHECK-V6M-NEXT:    .p2align 2
; CHECK-V6M-NEXT:  .LCPI0_0:
; CHECK-V6M-NEXT:    .long 537923600
;
; CHECK-V7M-LABEL: test_values:
; CHECK-V7M:         mov r2, r0
; CHECK-V7M-NEXT:    ldr r0, .LCPI0_0
; CHECK-V7M-NEXT:    cmp r2, #50
; CHECK-V7M-NEXT:    beq .LBB0_5
; CHECK-V7M-NEXT:    cmp r2, #1
; CHECK-V7M-NEXT:    beq .LBB0_7
; CHECK-V7M-NEXT:    cmp r2, #30
; CHECK-V7M-NEXT:    beq .LBB0_8
; CHECK-V7M-NEXT:    cbnz r2, .LBB0_6
; CHECK-V7M-NEXT:    add r0, r1
; CHECK-V7M-NEXT:    bx lr
; CHECK-V7M-NEXT:  .LBB0_5:
; CHECK-V7M-NEXT:    add r0, r1
; CHECK-V7M-NEXT:    adds r0, #4
; CHECK-V7M-NEXT:  .LBB0_6:
; CHECK-V7M-NEXT:    bx lr
; CHECK-V7M-NEXT:  .LBB0_7:
; CHECK-V7M-NEXT:    add r0, r1
; CHECK-V7M-NEXT:    adds r0, #1
; CHECK-V7M-NEXT:    bx lr
; CHECK-V7M-NEXT:  .LBB0_8:
; CHECK-V7M-NEXT:    add r0, r1
; CHECK-V7M-NEXT:    adds r0, #2
; CHECK-V7M-NEXT:    bx lr
; CHECK-V7M-NEXT:    .p2align 2
; CHECK-V7M-NEXT:  .LCPI0_0:
; CHECK-V7M-NEXT:    .long 537923600
entry:
  switch i32 %a, label %return [
    i32 0, label %sw.bb
    i32 1, label %sw.bb1
    i32 30, label %sw.bb3
    i32 50, label %sw.bb5
  ]

sw.bb:                                            ; preds = %entry
  %add = add nsw i32 %b, 537923600
  br label %return

sw.bb1:                                           ; preds = %entry
  %add2 = add nsw i32 %b, 537923601
  br label %return

sw.bb3:                                           ; preds = %entry
  %add4 = add nsw i32 %b, 537923602
  br label %return

sw.bb5:                                           ; preds = %entry
  %add6 = add nsw i32 %b, 537923604
  br label %return

return:                                           ; preds = %entry, %sw.bb5, %sw.bb3, %sw.bb1, %sw.bb
  %retval.0 = phi i32 [ %add6, %sw.bb5 ], [ %add4, %sw.bb3 ], [ %add2, %sw.bb1 ], [ %add, %sw.bb ], [ 537923600, %entry ]
  ret i32 %retval.0
}

define i32 @test_addr(i32 %a, i8* nocapture readonly %b) {
; CHECK-V6M-LABEL: test_addr:
; CHECK-V6M:         mov r2, r0
; CHECK-V6M-NEXT:    movs r0, #19
; CHECK-V6M-NEXT:    lsls r3, r0, #4
; CHECK-V6M-NEXT:    movs r0, #0
; CHECK-V6M-NEXT:    cmp r2, #29
; CHECK-V6M-NEXT:    bgt .LBB1_4
; CHECK-V6M-NEXT:    cmp r2, #0
; CHECK-V6M-NEXT:    beq .LBB1_8
; CHECK-V6M-NEXT:    cmp r2, #1
; CHECK-V6M-NEXT:    bne .LBB1_9
; CHECK-V6M-NEXT:    adds r3, r3, #1
; CHECK-V6M-NEXT:    b .LBB1_8
; CHECK-V6M-NEXT:  .LBB1_4:
; CHECK-V6M-NEXT:    cmp r2, #30
; CHECK-V6M-NEXT:    beq .LBB1_7
; CHECK-V6M-NEXT:    cmp r2, #50
; CHECK-V6M-NEXT:    bne .LBB1_9
; CHECK-V6M-NEXT:    adds r3, r3, #3
; CHECK-V6M-NEXT:    b .LBB1_8
; CHECK-V6M-NEXT:  .LBB1_7:
; CHECK-V6M-NEXT:    adds r3, r3, #2
; CHECK-V6M-NEXT:  .LBB1_8:
; CHECK-V6M-NEXT:    ldrb r0, [r1, r3]
; CHECK-V6M-NEXT:  .LBB1_9:
; CHECK-V6M-NEXT:    bx lr
;
; CHECK-V7M-LABEL: test_addr:
; CHECK-V7M:         mov r2, r0
; CHECK-V7M-NEXT:    movs r0, #0
; CHECK-V7M-NEXT:    cmp r2, #29
; CHECK-V7M-NEXT:    bgt .LBB1_4
; CHECK-V7M-NEXT:    cbz r2, .LBB1_7
; CHECK-V7M-NEXT:    cmp r2, #1
; CHECK-V7M-NEXT:    it ne
; CHECK-V7M-NEXT:    bxne lr
; CHECK-V7M-NEXT:  .LBB1_3:
; CHECK-V7M-NEXT:    movw r0, #305
; CHECK-V7M-NEXT:    b .LBB1_9
; CHECK-V7M-NEXT:  .LBB1_4:
; CHECK-V7M-NEXT:    cmp r2, #30
; CHECK-V7M-NEXT:    beq .LBB1_8
; CHECK-V7M-NEXT:    cmp r2, #50
; CHECK-V7M-NEXT:    bne .LBB1_10
; CHECK-V7M-NEXT:    movw r0, #307
; CHECK-V7M-NEXT:    b .LBB1_9
; CHECK-V7M-NEXT:  .LBB1_7:
; CHECK-V7M-NEXT:    mov.w r0, #304
; CHECK-V7M-NEXT:    b .LBB1_9
; CHECK-V7M-NEXT:  .LBB1_8:
; CHECK-V7M-NEXT:    mov.w r0, #306
; CHECK-V7M-NEXT:  .LBB1_9:
; CHECK-V7M-NEXT:    ldrb r0, [r1, r0]
; CHECK-V7M-NEXT:  .LBB1_10:
; CHECK-V7M-NEXT:    bx lr
entry:
  switch i32 %a, label %return [
    i32 0, label %return.sink.split
    i32 1, label %sw.bb1
    i32 30, label %sw.bb4
    i32 50, label %sw.bb7
  ]

sw.bb1:                                           ; preds = %entry
  br label %return.sink.split

sw.bb4:                                           ; preds = %entry
  br label %return.sink.split

sw.bb7:                                           ; preds = %entry
  br label %return.sink.split

return.sink.split:                                ; preds = %entry, %sw.bb1, %sw.bb4, %sw.bb7
  %.sink = phi i32 [ 307, %sw.bb7 ], [ 306, %sw.bb4 ], [ 305, %sw.bb1 ], [ 304, %entry ]
  %arrayidx8 = getelementptr inbounds i8, i8* %b, i32 %.sink
  %0 = load i8, i8* %arrayidx8, align 1
  %phitmp = zext i8 %0 to i32
  br label %return

return:                                           ; preds = %return.sink.split, %entry
  %retval.0.shrunk = phi i32 [ 0, %entry ], [ %phitmp, %return.sink.split ]
  ret i32 %retval.0.shrunk
}

