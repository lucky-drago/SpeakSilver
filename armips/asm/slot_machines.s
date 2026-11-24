; Slot machines for English HeartGold / hg-engine.
; Adapted from the user-provided SlotMachines_HG_SS.asm (Japanese slot code).
; Build through armips/global.s after scripts/make.py.
; Overlay 77 replaces the unused English slot-machine stub. The normal
; application manager loads it on entry and unloads it after the exit callback.
; No synthetic NARC, fixed high-RAM injection, or .pass file is used.
; Graphics a/1/2/7 and message bank 436 must be restored separately.

.nds
.thumb

Slots_OverlayId equ 77
Slots_OverlayBase equ 0x021E5900

; Restore the native Voltorb Flip template before installing slots separately.
.open "base/arm9.bin", 0x02000000
.org 0x020FA234
.word 0x021E82A9 ; VoltorbFlip_Init (Thumb)
.word 0x021E8361 ; VoltorbFlip_Main (Thumb)
.word 0x021E8309 ; VoltorbFlip_Exit (Thumb)
.word 122        ; native Voltorb Flip overlay
.close

; ndstool names overlay files by file ID. Refuse an unexpected base table.
.if readu32("base/overarm9.bin", 77 * 0x20) != Slots_OverlayId
    .error "Slot machines: expected overlay 77 in the ARM9 overlay table."
.endif
.if readu32("base/overarm9.bin", 77 * 0x20 + 0x18) != 77
    .error "Slot machines: overlay 77 has an unexpected file ID."
.endif

.definelabel Slots_FontID_Alloc, 0x02002CEC
.definelabel Slots_FontID_Release, 0x02002DB4
.definelabel Slots_LoadFontPal1, 0x0200304C
.definelabel Slots_PaletteData_Init, 0x020030E8
.definelabel Slots_PaletteData_Free, 0x02003104
.definelabel Slots_PaletteData_AllocBuffers, 0x02003120
.definelabel Slots_PaletteData_FreeBuffers, 0x02003150
.definelabel Slots_PaletteData_LoadPalette, 0x0200316C
.definelabel Slots_PaletteData_LoadFromOpenNarc, 0x02003220
.definelabel Slots_PaletteData_PushTransparentBuffers, 0x0200398C
.definelabel Slots_PaletteData_SetAutoTransparent, 0x02003B50
.definelabel Slots_PaletteData_BlendPalette, 0x02003E5C
.definelabel Slots_SndRadio_StopSeq, 0x02004A08
.definelabel Slots_SndRadio_GetSeqNo, 0x02004A20
.definelabel Slots_GF_GetCurrentPlayingBGM, 0x02004A90
.definelabel Slots_Sound_SetSceneAndPlayBGM, 0x02004EC4
.definelabel Slots_PlayBGM, 0x02005D48
.definelabel Slots_StopBGM, 0x02005EB4
.definelabel Slots_PlaySE, 0x0200604C
.definelabel Slots_OverlayManager_CreateAndGetData, 0x02007280
.definelabel Slots_OverlayManager_GetData, 0x02007290
.definelabel Slots_OverlayManager_FreeData, 0x02007294
.definelabel Slots_OverlayManager_GetArgs, 0x020072A4
.definelabel Slots_NARC_New, 0x02007688
.definelabel Slots_NARC_Delete, 0x0200770C
.definelabel Slots_GfGfxLoader_LoadCharDataFromOpenNarc, 0x02007B44
.definelabel Slots_GfGfxLoader_LoadScrnDataFromOpenNarc, 0x02007B68
.definelabel Slots_GfGfxLoader_GetScrnDataFromOpenNarc, 0x02007C2C
.definelabel Slots_GfGfxLoader_GetPlttDataFromOpenNarc, 0x02007C48
.definelabel Slots_thunk_ClearMainOAM, 0x0200B2E0
.definelabel Slots_thunk_ClearSubOAM, 0x0200B2E8
.definelabel Slots_StartBrightnessTransition, 0x0200B484
.definelabel Slots_ScreenBrightnessData_InitAll, 0x0200B528
.definelabel Slots_DoAllScreenBrightnessTransitionStep, 0x0200B594
.definelabel Slots_IsBrightnessTransitionActive, 0x0200B5C0
.definelabel Slots_NewMsgDataFromNarc, 0x0200BAF8
.definelabel Slots_DestroyMsgData, 0x0200BB44
.definelabel Slots_ReadMsgDataIntoString, 0x0200BB6C
.definelabel Slots_MessageFormat_New_Custom, 0x0200BD18
.definelabel Slots_MessageFormat_Delete, 0x0200BDA0
.definelabel Slots_SpriteSystem_Alloc, 0x0200CF18
.definelabel Slots_SpriteManager_New, 0x0200CF38
.definelabel Slots_SpriteSystem_Init, 0x0200CF70
.definelabel Slots_SpriteSystem_InitSprites, 0x0200CFF4
.definelabel Slots_SpriteSystem_DrawSprites, 0x0200D020
.definelabel Slots_SpriteSystem_TransferOam, 0x0200D034
.definelabel Slots_SpriteSystem_DestroySpriteManager, 0x0200D0E4
.definelabel Slots_SpriteSystem_Free, 0x0200D108
.definelabel Slots_sub_0200D2A4, 0x0200D2A4
.definelabel Slots_SpriteSystem_CreateSpriteFromResourceHeader, 0x0200D2B4
.definelabel Slots_Sprite_SetPositionXY, 0x0200DD88
.definelabel Slots_SysTask_CreateOnMainQueue, 0x0200E320
.definelabel Slots_SysTask_Destroy, 0x0200E390
.definelabel Slots_LoadUserFrameGfx2, 0x0200E644
.definelabel Slots_DrawFrameAndWindow2, 0x0200E998
.definelabel Slots_ClearFrameAndWindow2, 0x0200E9BC
.definelabel Slots_BeginNormalPaletteFade, 0x0200FA24
.definelabel Slots_IsPaletteFadeFinished, 0x0200FB5C
.definelabel Slots_ResetVisibleHardwareWindows, 0x0200FBDC
.definelabel Slots_sub_0200FBF4, 0x0200FBF4
.definelabel Slots_YesNoPrompt_Create, 0x0201660C
.definelabel Slots_YesNoPrompt_Destroy, 0x02016624
.definelabel Slots_YesNoPrompt_InitFromTemplate, 0x020166FC
.definelabel Slots_YesNoPrompt_HandleInput, 0x020168F4
.definelabel Slots_YesNoPrompt_IsInTouchMode, 0x020169C0
.definelabel Slots_YesNoPrompt_Reset, 0x020169CC
.definelabel Slots_MenuInputStateMgr_GetState, 0x020183F0
.definelabel Slots_Main_SetVBlankIntrCB, 0x0201A0FC
.definelabel Slots_HBlankInterruptDisable, 0x0201A108
.definelabel Slots_Heap_Create, 0x0201A910
.definelabel Slots_Heap_Destroy, 0x0201A9C4
.definelabel Slots_Heap_Alloc, 0x0201AA8C
.definelabel Slots_Heap_AllocAtEnd, 0x0201AACC
.definelabel Slots_Heap_Free, 0x0201AB0C
.definelabel Slots_BgConfig_Alloc, 0x0201AC88
.definelabel Slots_SetBothScreensModesAndDisable, 0x0201ACB0
.definelabel Slots_InitBgFromTemplate, 0x0201B1E4
.definelabel Slots_FreeBgTilemapBuffer, 0x0201BB4C
.definelabel Slots_BgSetPosTextAndCommit, 0x0201BC8C
.definelabel Slots_BG_ClearCharDataRange, 0x0201C1C4
.definelabel Slots_CopyToBgTilemapRect, 0x0201C4EC
.definelabel Slots_BgClearTilemapBufferAndCommit, 0x0201CAE0
.definelabel Slots_AddWindow, 0x0201D4F8
.definelabel Slots_RemoveWindow, 0x0201D520
.definelabel Slots_ScheduleWindowCopyToVram, 0x0201D5C8
.definelabel Slots_ClearWindowTilemapAndCopyToVram, 0x0201D8C8
.definelabel Slots_ClearWindowTilemapAndScheduleTransfer, 0x0201D8E4
.definelabel Slots_FillWindowPixelBuffer, 0x0201D978
.definelabel Slots_DoScheduledBgGpuUpdates, 0x0201EEB4
.definelabel Slots_ScheduleBgTilemapBufferTransfer, 0x0201EFBC
.definelabel Slots_SysTask_GetData, 0x0201F988
.definelabel Slots_GF_SinDegNoWrap, 0x0201FBB8
.definelabel Slots_GetLCRNGSeed, 0x0201FD2C
.definelabel Slots_SetLCRNGSeed, 0x0201FD38
.definelabel Slots_LCRandom, 0x0201FD44
.definelabel Slots_AddTextPrinterParameterizedWithColor, 0x020200FC
.definelabel Slots_GF_CreateVramTransferManager, 0x0202055C
.definelabel Slots_GF_DestroyVramTransferManager, 0x020205AC
.definelabel Slots_sub_020210BC, 0x020210BC
.definelabel Slots_sub_02021148, 0x02021148
.definelabel Slots_sub_02021238, 0x02021238
.definelabel Slots_GfGfx_SetBanks, 0x02022BE8
.definelabel Slots_GfGfx_DisableEngineAPlanes, 0x02022C54
.definelabel Slots_GfGfx_EngineATogglePlanes, 0x02022C60
.definelabel Slots_GfGfx_DisableEngineBPlanes, 0x02022CBC
.definelabel Slots_GfGfx_EngineBTogglePlanes, 0x02022CC8
.definelabel Slots_Sprite_Delete, 0x02024758
.definelabel Slots_Sprite_SetMatrix, 0x020247D4
.definelabel Slots_Sprite_SetDrawFlag, 0x02024830
.definelabel Slots_Sprite_SetAnimActiveFlag, 0x0202484C
.definelabel Slots_Sprite_SetAnimSpeed, 0x02024868
.definelabel Slots_Sprite_SetAffineOverwriteMode, 0x0202487C
.definelabel Slots_Sprite_SetAnimCtrlSeq, 0x020248F0
.definelabel Slots_Sprite_ResetAnimCtrlState, 0x02024964
.definelabel Slots_Sprite_GetAnimationNumber, 0x020249A8
.definelabel Slots_Sprite_SetAnimationFrame, 0x020249D4
.definelabel Slots_Sprite_SetPriority, 0x02024A04
.definelabel Slots_Sprite_SetDrawPriority, 0x02024ADC
.definelabel Slots_TouchscreenHitbox_TouchNewIsIn, 0x02025320
.definelabel Slots_System_GetTouchNew, 0x02025358
.definelabel Slots_GF_AssertFail, 0x0202551C
.definelabel Slots_String_New, 0x02026354
.definelabel Slots_String_Delete, 0x02026380
.definelabel Slots_Save_PlayerData_GetOptionsAddr, 0x02028EA8
.definelabel Slots_Save_PlayerData_GetCoinsAddr, 0x02028EB4
.definelabel Slots_Options_GetTextSpeed, 0x0202AD20
.definelabel Slots_Options_GetFrame, 0x0202ADCC
.definelabel Slots_sub_0202C7DC, 0x0202C7DC
.definelabel Slots_Save_FriendGroup_Get, 0x0202C854
.definelabel Slots_Coins_GetValue, 0x0202C950
.definelabel Slots_Save_GameStats_Get, 0x0202CF54
.definelabel Slots_GameStats_Inc, 0x0202D0FC
.definelabel Slots_GameStats_AddScore, 0x0202D1C0
.definelabel Slots_NNS_GfdDoVramTransfer, 0x020B62EC
.definelabel Slots_FX_Div, 0x020CCBA0
.definelabel Slots_G2x_SetBlendAlpha_, 0x020CF15C
.definelabel Slots_G2x_SetBlendBrightness_, 0x020CF178
.definelabel Slots_MI_CpuFill8, 0x020D4994
.definelabel Slots__fadd, 0x020F1520
.definelabel Slots__f_ftoi, 0x020F2104
.definelabel Slots__f_itof, 0x020F2178
.definelabel Slots__fsub, 0x020F24C8
.definelabel Slots__ll_mul, 0x020F2948
.definelabel Slots__s32_div_f, 0x020F2998
.definelabel Slots__u32_div_f, 0x020F2BA4


.create "base/overlay/overlay_0077.bin", Slots_OverlayBase
Slots_PayloadStart:
.ascii "SlotMachines_Start"
.align 4

; Fixed callback addresses used by overlay 131's casino command.
Slots_InitEntry:
    ldr r3, [@@target]
    bx r3
@@target:
    .word Slots_Slot_GameCornerInit + 1
Slots_MainEntry:
    ldr r3, [@@target]
    bx r3
@@target:
    .word Slots_Slot_GameCornerMain + 1
Slots_ExitEntry:
    ldr r3, [@@target]
    bx r3
@@target:
    .word Slots_Slot_GameCornerExit + 1

Slots_ov77_021E4E40:
    push {r4-r6, lr}
    mov r5, r1
    ldr r1, [r5]
    mov r6, r0
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_2
    b @@branch_3
@@branch_1:
    bl Slots_ov77_021E51F4
    mov r2, #2
    mov r0, #3
    mov r1, #0x4D
    lsl r2, r2, #16
    bl Slots_Heap_Create
    mov r1, #0xC1
    mov r0, r6
    lsl r1, r1, #2
    mov r2, #0x4D
    bl Slots_OverlayManager_CreateAndGetData
    mov r2, #0xC1
    mov r1, #0
    lsl r2, r2, #2
    mov r4, r0
    blx Slots_MI_CpuFill8
    mov r0, #0x4D
    str r0, [r4]
    mov r0, r6
    bl Slots_OverlayManager_GetArgs
    mov r1, r0
    mov r0, r4
    bl Slots_ov77_021E4F34
    ldr r0, [r5]
    add r0, r0, #1
    str r0, [r5]
    b @@branch_3
@@branch_2:
    bl Slots_OverlayManager_GetData
    bl Slots_ov77_021E4FB8
    cmp r0, #0
    beq @@branch_3
    mov r0, #1
    pop {r4-r6, pc}
@@branch_3:
    mov r0, #0
    pop {r4-r6, pc}

Slots_ov77_021E4EA8:
    push {r3-r5, lr}
    mov r4, r1
    bl Slots_OverlayManager_GetData
    ldr r1, [r4]
    mov r5, r0
    cmp r1, #3
    bhi @@branch_1
    add r1, r1, r1
    add r1, pc
    ldrh r1, [r1, #6]
    lsl r1, r1, #16
    asr r1, r1, #16
    add pc, r1
@@table_1:
    .halfword @@case_1 - @@table_1 - 2
    .halfword @@case_3 - @@table_1 - 2
    .halfword @@case_2 - @@table_1 - 2
    .halfword @@case_4 - @@table_1 - 2
@@case_1:
    bl Slots_ov77_021E5018
    str r0, [r4]
    b @@branch_1
@@case_2:
    bl Slots_ov77_021E50A0
    str r0, [r4]
    b @@branch_1
@@case_3:
    bl Slots_ov77_021E5C48
    cmp r0, #0
    beq @@branch_1
    mov r0, #2
    str r0, [r4]
    b @@branch_1
@@case_4:
    mov r0, #1
    pop {r3-r5, pc}
@@branch_1:
    mov r0, r5
    bl Slots_ov77_021E8F1C
    mov r0, #0x7A
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    bl Slots_SpriteSystem_DrawSprites
    mov r0, #0
    pop {r3-r5, pc}
    .align 4

Slots_ov77_021E4F04:
    push {r3-r5, lr}
    mov r5, r0
    bl Slots_OverlayManager_GetData
    mov r4, r0
    bl Slots_ov77_021E5000
    cmp r0, #0
    bne @@branch_1
    mov r0, #0
    pop {r3-r5, pc}
@@branch_1:
    bl Slots_ov77_021E51F4
    mov r0, r4
    bl Slots_ov77_021E4FA0
    mov r0, r5
    bl Slots_OverlayManager_FreeData
    mov r0, #0x4D
    bl Slots_Heap_Destroy
    mov r0, #1
    pop {r3-r5, pc}

Slots_ov77_021E4F34:
    push {r4-r6, lr}
    mov r4, r1
    mov r5, r0
    ldr r0, [r4, #0x14]
    bl Slots_Save_GameStats_Get
    str r0, [r5, #0x1C]
    ldr r0, [r4, #0x14]
    bl Slots_Save_PlayerData_GetCoinsAddr
    str r0, [r5, #0x18]
    bl Slots_Coins_GetValue
    str r0, [r5, #0x28]
    ldr r0, [r4, #0x14]
    bl Slots_Save_PlayerData_GetOptionsAddr
    mov r6, r0
    bl Slots_Options_GetTextSpeed
    mov r1, r5
    add r1, #0x24
    strb r0, [r1]
    mov r0, r6
    bl Slots_Options_GetFrame
    mov r1, r5
    add r1, #0x25
    strb r0, [r1]
    ldr r0, [r4, #0x18]
    bl Slots_MenuInputStateMgr_GetState
    str r0, [r5, #0x20]
    mov r0, r5
    ldr r1, [r4, #4]
    add r0, #0x38
    strb r1, [r0]
    mov r0, r5
    mov r1, #0
    add r0, #0x39
    strb r1, [r0]
    str r4, [r5, #0x14]
    bl Slots_SndRadio_GetSeqNo
    mov r1, #0x17
    lsl r1, r1, #4
    strh r0, [r5, r1]
    ldr r0, [r4, #0x14]
    bl Slots_Save_GameStats_Get
    mov r1, #5
    bl Slots_GameStats_AddScore
    pop {r4-r6, pc}

Slots_ov77_021E4FA0:
    ldr r1, [r0, #0x28]
    ldr r2, [@@pool_1]
    cmp r1, r2
    bls @@branch_1
    mov r1, r2
@@branch_1:
    ldr r3, [@@pool_2]
    ldr r0, [r0, #0x18]
    bx r3
@@pool_1:
    .word 0x0000C350
@@pool_2:
    .word Slots_Coins_SetValue+1

Slots_ov77_021E4FB8:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4, #4]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_2
    b @@branch_3
@@branch_1:
    bl Slots_ov77_021E5160
    mov r0, r4
    bl Slots_ov77_021E51B4
    ldr r0, [r4, #4]
    add r0, r0, #1
    str r0, [r4, #4]
    b @@branch_3
@@branch_2:
    bl Slots_ov77_021E5244
    bl Slots_sub_020210BC
    mov r0, #1
    bl Slots_sub_02021148
    mov r1, #0
    mov r0, #0x45
    mov r2, r1
    bl Slots_Sound_SetSceneAndPlayBGM
    mov r0, #0
    str r0, [r4, #4]
    mov r0, #1
    pop {r4, pc}
@@branch_3:
    mov r0, #0
    pop {r4, pc}
    .align 4

Slots_ov77_021E5000:
    push {r4, lr}
    mov r4, r0
    bl Slots_sub_02021238
    mov r0, r4
    bl Slots_ov77_021E51C8
    mov r0, r4
    bl Slots_ov77_021E5190
    mov r0, #1
    pop {r4, pc}

Slots_ov77_021E5018:
    push {r3-r4, lr}
    sub sp, #0xC
    mov r4, r0
    ldr r0, [r4, #4]
    cmp r0, #0
    beq @@branch_1
    cmp r0, #1
    beq @@branch_3
    b @@branch_5
@@branch_1:
    mov r0, #6
    mov r1, #1
    str r0, [sp]
    str r1, [sp, #4]
    ldr r0, [r4]
    mov r2, r1
    str r0, [sp, #8]
    mov r0, #0
    mov r3, r0
    bl Slots_BeginNormalPaletteFade
    mov r0, #0x10
    mov r1, #1
    bl Slots_GfGfx_EngineATogglePlanes
    mov r0, #0x10
    mov r1, #1
    bl Slots_GfGfx_EngineBTogglePlanes
    mov r0, #0x17
    lsl r0, r0, #4
    ldrh r0, [r4, r0]
    cmp r0, #0
    beq @@branch_2
    bl Slots_GF_GetCurrentPlayingBGM
    mov r1, #8
    bl Slots_StopBGM
    mov r0, #8
    bl Slots_SndRadio_StopSeq
@@branch_2:
    ldr r0, [r4, #4]
    add r0, r0, #1
    str r0, [r4, #4]
    b @@branch_5
@@branch_3:
    bl Slots_IsPaletteFadeFinished
    cmp r0, #0
    beq @@branch_5
    mov r0, #0x17
    lsl r0, r0, #4
    ldrh r0, [r4, r0]
    cmp r0, #0
    beq @@branch_4
    ldr r0, [@@pool_1]
    bl Slots_PlayBGM
@@branch_4:
    mov r0, #0
    str r0, [r4, #4]
    add sp, #0xC
    mov r0, #1
    pop {r3-r4, pc}
@@branch_5:
    mov r0, #0
    add sp, #0xC
    pop {r3-r4, pc}
    nop
@@pool_1:
    .word 0x0000042D

Slots_ov77_021E50A0:
    push {r3-r4, lr}
    sub sp, #0xC
    mov r4, r0
    ldr r0, [r4, #4]
    cmp r0, #0
    beq @@branch_1
    cmp r0, #1
    beq @@branch_3
    b @@branch_5
@@branch_1:
    mov r0, #6
    str r0, [sp]
    mov r0, #1
    str r0, [sp, #4]
    ldr r0, [r4]
    str r0, [sp, #8]
    mov r0, #0
    mov r1, r0
    mov r2, r0
    mov r3, r0
    bl Slots_BeginNormalPaletteFade
    bl Slots_GF_GetCurrentPlayingBGM
    mov r1, #0x17
    lsl r1, r1, #4
    strh r0, [r4, r1]
    ldrh r1, [r4, r1]
    ldr r0, [@@pool_1]
    cmp r1, r0
    beq @@branch_2
    bl Slots_GF_GetCurrentPlayingBGM
    mov r1, #8
    bl Slots_StopBGM
@@branch_2:
    ldr r0, [r4, #4]
    add r0, r0, #1
    str r0, [r4, #4]
    b @@branch_5
@@branch_3:
    bl Slots_IsPaletteFadeFinished
    cmp r0, #0
    beq @@branch_5
    mov r0, #0x17
    lsl r0, r0, #4
    ldrh r1, [r4, r0]
    ldr r0, [@@pool_1]
    cmp r1, r0
    beq @@branch_4
    bl Slots_PlayBGM
@@branch_4:
    mov r0, #0
    str r0, [r4, #4]
    add sp, #0xC
    mov r0, #3
    pop {r3-r4, pc}
@@branch_5:
    mov r0, #2
    add sp, #0xC
    pop {r3-r4, pc}
    nop
@@pool_1:
    .word 0x0000042D

Slots_ov77_021E511C:
    push {r4, lr}
    mov r4, r0
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r4, r0]
    cmp r0, #0
    beq @@branch_1
    bl Slots_PaletteData_PushTransparentBuffers
@@branch_1:
    mov r0, #0x79
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    cmp r0, #0
    beq @@branch_2
    bl Slots_SpriteSystem_TransferOam
@@branch_2:
    blx Slots_NNS_GfdDoVramTransfer
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    bl Slots_DoScheduledBgGpuUpdates
    ldr r3, [@@pool_1]
    ldr r1, [@@pool_2]
    mov r0, #1
    ldr r2, [r3, r1]
    orr r0, r2
    str r0, [r3, r1]
    pop {r4, pc}
@@pool_1:
    .word 0x027E0000
@@pool_2:
    .word 0x00003FF8

Slots_ov77_021E5160:
    push {r4, lr}
    mov r4, r0
    bl Slots_ov77_021E52A0
    mov r0, r4
    bl Slots_ov77_021E554C
    mov r0, r4
    bl Slots_ov77_021E5838
    mov r0, r4
    bl Slots_ov77_021E58C0
    mov r0, r4
    bl Slots_ov77_021E59DC
    ldr r0, [@@pool_1]
    mov r1, r4
    bl Slots_Main_SetVBlankIntrCB
    pop {r4, pc}
    nop
@@pool_1:
    .word Slots_ov77_021E511C+1

Slots_ov77_021E5190:
    push {r4, lr}
    mov r4, r0
    bl Slots_ov77_021E5A04
    mov r0, r4
    bl Slots_ov77_021E5900
    mov r0, r4
    bl Slots_ov77_021E588C
    mov r0, r4
    bl Slots_ov77_021E579C
    mov r0, r4
    bl Slots_ov77_021E54A0
    pop {r4, pc}
    .align 4

Slots_ov77_021E51B4:
    push {r4, lr}
    mov r4, r0
    bl Slots_ov77_021E8D34
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E7E5C
    pop {r4, pc}
    .align 4

Slots_ov77_021E51C8:
    push {r3-r7, lr}
    mov r6, r0
    mov r7, #0x12
    mov r4, #0
    mov r5, r6
    lsl r7, r7, #4
@@branch_1:
    ldr r0, [r5, r7]
    cmp r0, #0
    beq @@branch_2
    mov r0, r6
    mov r1, r4
    bl Slots_ov77_021E7E18
@@branch_2:
    add r4, r4, #1
    add r5, #8
    cmp r4, #5
    blt @@branch_1
    mov r0, r6
    bl Slots_ov77_021E8D7C
    pop {r3-r7, pc}
    .align 4

Slots_ov77_021E51F4:
    push {r3, lr}
    mov r0, #0
    mov r1, r0
    bl Slots_Main_SetVBlankIntrCB
    bl Slots_HBlankInterruptDisable
    bl Slots_GfGfx_DisableEngineAPlanes
    bl Slots_GfGfx_DisableEngineBPlanes
    mov r2, #1
    lsl r2, r2, #26
    ldr r1, [r2]
    ldr r0, [@@pool_1]
    and r1, r0
    str r1, [r2]
    ldr r2, [@@pool_2]
    ldr r1, [r2]
    and r0, r1
    str r0, [r2]
    mov r0, #0
    mov r1, r0
    bl Slots_sub_0200FBF4
    mov r0, #1
    mov r1, #0
    bl Slots_sub_0200FBF4
    mov r0, #0
    bl Slots_ResetVisibleHardwareWindows
    mov r0, #1
    bl Slots_ResetVisibleHardwareWindows
    pop {r3, pc}
@@pool_1:
    .word 0xFFFFE0FF
@@pool_2:
    .word 0x04001000

Slots_ov77_021E5244:
    push {r4, lr}
    mov r4, r0
    bl Slots_ov77_021E8C64
    mov r0, r4
    bl Slots_ov77_021E8CB8
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E72B4
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E71EC
    ldr r1, [r4, #0x28]
    mov r0, r4
    mov r2, #0
    bl Slots_ov77_021E7324
    mov r0, r4
    mov r1, #0
    mov r2, #1
    bl Slots_ov77_021E7324
    mov r0, r4
    bl Slots_ov77_021E5BE8
    pop {r4, pc}
    .align 4

Slots_ov77_021E5280:
    push {r4, lr}
    sub sp, #0x28
    ldr r4, [@@pool_1]
    add r3, sp, #0
    mov r2, #5
@@branch_1:
    ldmia r4!, {r0-r1}
    stmia r3!, {r0-r1}
    sub r2, r2, #1
    bne @@branch_1
    add r0, sp, #0
    bl Slots_GfGfx_SetBanks
    add sp, #0x28
    pop {r4, pc}
@@pool_1:
    .word Slots_ov77_021E9E90

Slots_ov77_021E52A0:
    push {r4-r5, lr}
    sub sp, #0xD4
    mov r4, r0
    bl Slots_ov77_021E5280
    ldr r0, [r4]
    bl Slots_BgConfig_Alloc
    mov r1, #0x61
    lsl r1, r1, #2
    add r3, sp, #0xC4
    ldr r5, [@@pool_1]
    str r0, [r4, r1]
    mov r2, r3
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    mov r0, r2
    bl Slots_SetBothScreensModesAndDisable
    ldr r5, [@@pool_2]
    add r3, sp, #0xA8
    ldmia r5!, {r0-r1}
    mov r2, r3
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldr r0, [r5]
    mov r1, #0
    str r0, [r3]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r3, r1
    bl Slots_InitBgFromTemplate
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #0
    bl Slots_BgClearTilemapBufferAndCommit
    ldr r5, [@@pool_3]
    add r3, sp, #0x8C
    ldmia r5!, {r0-r1}
    mov r2, r3
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldr r0, [r5]
    mov r1, #1
    str r0, [r3]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r3, #0
    bl Slots_InitBgFromTemplate
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #1
    bl Slots_BgClearTilemapBufferAndCommit
    ldr r5, [@@pool_4]
    add r3, sp, #0x70
    ldmia r5!, {r0-r1}
    mov r2, r3
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldr r0, [r5]
    mov r1, #2
    str r0, [r3]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r3, #0
    bl Slots_InitBgFromTemplate
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #2
    bl Slots_BgClearTilemapBufferAndCommit
    ldr r5, [@@pool_5]
    add r3, sp, #0x54
    ldmia r5!, {r0-r1}
    mov r2, r3
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldr r0, [r5]
    str r0, [r3]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #3
    mov r3, #0
    bl Slots_InitBgFromTemplate
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #3
    bl Slots_BgClearTilemapBufferAndCommit
    ldr r5, [@@pool_6]
    add r3, sp, #0x38
    ldmia r5!, {r0-r1}
    mov r2, r3
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldr r0, [r5]
    mov r1, #4
    str r0, [r3]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r3, #0
    bl Slots_InitBgFromTemplate
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #4
    bl Slots_BgClearTilemapBufferAndCommit
    ldr r5, [@@pool_7]
    add r3, sp, #0x1C
    ldmia r5!, {r0-r1}
    mov r2, r3
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldr r0, [r5]
    mov r1, #5
    str r0, [r3]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r3, #0
    bl Slots_InitBgFromTemplate
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #5
    bl Slots_BgClearTilemapBufferAndCommit
    ldr r5, [@@pool_8]
    add r3, sp, #0
    ldmia r5!, {r0-r1}
    mov r2, r3
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldr r0, [r5]
    mov r1, #6
    str r0, [r3]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r3, #0
    bl Slots_InitBgFromTemplate
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #6
    bl Slots_BgClearTilemapBufferAndCommit
    mov r0, #0
    ldr r3, [r4]
    mov r1, #0x20
    mov r2, r0
    bl Slots_BG_ClearCharDataRange
    ldr r3, [r4]
    mov r0, #3
    mov r1, #0x20
    mov r2, #0
    bl Slots_BG_ClearCharDataRange
    ldr r3, [r4]
    mov r0, #4
    mov r1, #0x20
    mov r2, #0
    bl Slots_BG_ClearCharDataRange
    ldr r3, [r4]
    mov r0, #5
    mov r1, #0x20
    mov r2, #0
    bl Slots_BG_ClearCharDataRange
    ldr r0, [@@pool_9]
    mov r2, #0x3F
    ldrh r3, [r0]
    mov r1, #0x1D
    bic r3, r2
    orr r1, r3
    mov r3, #0x20
    orr r1, r3
    strh r1, [r0]
    ldrh r4, [r0]
    ldr r1, [@@pool_10]
    and r4, r1
    lsl r1, r3, #4
    orr r1, r4
    strh r1, [r0]
    ldrh r4, [r0, #2]
    mov r1, #0x1F
    bic r4, r2
    orr r1, r4
    orr r1, r3
    strh r1, [r0, #2]
    add sp, #0xD4
    pop {r4-r5, pc}
@@pool_1:
    .word Slots_ov77_021E9D88
@@pool_2:
    .word Slots_ov77_021E9E38
@@pool_3:
    .word Slots_ov77_021E9E1C
@@pool_4:
    .word Slots_ov77_021E9DE4
@@pool_5:
    .word Slots_ov77_021E9E54
@@pool_6:
    .word Slots_ov77_021E9DAC
@@pool_7:
    .word Slots_ov77_021E9DC8
@@pool_8:
    .word Slots_ov77_021E9E00
@@pool_9:
    .word 0x04000048
@@pool_10:
    .word 0xFFFFC0FF

Slots_ov77_021E54A0:
    push {r4-r6, lr}
    ldr r3, [@@pool_1]
    mov r4, r0
    ldrh r2, [r3]
    mov r0, #0x3F
    mov r1, #0x1F
    bic r2, r0
    mov r5, r2
    orr r5, r1
    mov r2, #0x20
    orr r5, r2
    strh r5, [r3]
    ldrh r6, [r3]
    ldr r5, [@@pool_2]
    and r6, r5
    lsl r5, r1, #8
    orr r6, r5
    lsl r5, r2, #8
    orr r5, r6
    strh r5, [r3]
    ldrh r5, [r3, #2]
    bic r5, r0
    mov r0, r5
    orr r0, r1
    orr r0, r2
    strh r0, [r3, #2]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #6
    bl Slots_FreeBgTilemapBuffer
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #5
    bl Slots_FreeBgTilemapBuffer
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #4
    bl Slots_FreeBgTilemapBuffer
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #3
    bl Slots_FreeBgTilemapBuffer
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #2
    bl Slots_FreeBgTilemapBuffer
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #1
    bl Slots_FreeBgTilemapBuffer
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #0
    bl Slots_FreeBgTilemapBuffer
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    bl Slots_Heap_Free
    ldr r2, [@@pool_3]
    ldrh r1, [r2]
    lsr r0, r2, #11
    orr r0, r1
    strh r0, [r2]
    pop {r4-r6, pc}
    nop
@@pool_1:
    .word 0x04000048
@@pool_2:
    .word 0xFFFFC0FF
@@pool_3:
    .word 0x04000304

Slots_ov77_021E554C:
    push {r3-r7, lr}
    sub sp, #0x10
    mov r5, r0
    ldr r1, [r5]
    mov r0, #0x7F
    bl Slots_NARC_New
    mov r7, r0
    mov r0, #0x2F
    lsl r0, r0, #4
    str r7, [r5, r0]
    ldr r0, [r5]
    bl Slots_PaletteData_Init
    mov r2, #0x1E
    lsl r2, r2, #4
    str r0, [r5, r2]
    ldr r0, [r5, r2]
    ldr r3, [r5]
    mov r1, #0
    sub r2, #0x60
    bl Slots_PaletteData_AllocBuffers
    mov r2, #0x1E
    lsl r2, r2, #4
    ldr r0, [r5, r2]
    ldr r3, [r5]
    mov r1, #1
    sub r2, #0x60
    bl Slots_PaletteData_AllocBuffers
    mov r0, #0x1E
    lsl r0, r0, #4
    mov r1, #2
    ldr r0, [r5, r0]
    ldr r3, [r5]
    lsl r2, r1, #8
    bl Slots_PaletteData_AllocBuffers
    mov r2, #0x1E
    lsl r2, r2, #4
    ldr r0, [r5, r2]
    ldr r3, [r5]
    mov r1, #3
    add r2, #0x20
    bl Slots_PaletteData_AllocBuffers
    mov r1, #0
    mov r0, #6
    str r1, [sp]
    lsl r0, r0, #6
    str r0, [sp, #4]
    str r1, [sp, #8]
    str r1, [sp, #0xC]
    add r0, #0x60
    ldr r0, [r5, r0]
    ldr r3, [r5]
    mov r1, r7
    mov r2, #8
    bl Slots_PaletteData_LoadFromOpenNarc
    mov r0, #1
    mov r1, #6
    str r0, [sp]
    lsl r1, r1, #6
    str r1, [sp, #4]
    mov r0, #0
    str r0, [sp, #8]
    str r0, [sp, #0xC]
    add r1, #0x60
    ldr r0, [r5, r1]
    ldr r3, [r5]
    mov r1, r7
    mov r2, #0x14
    bl Slots_PaletteData_LoadFromOpenNarc
    mov r0, #2
    str r0, [sp]
    lsl r0, r0, #8
    str r0, [sp, #4]
    mov r2, #0
    str r2, [sp, #8]
    mov r0, #0x1E
    str r2, [sp, #0xC]
    lsl r0, r0, #4
    ldr r0, [r5, r0]
    ldr r3, [r5]
    mov r1, r7
    bl Slots_PaletteData_LoadFromOpenNarc
    mov r0, #3
    mov r1, #2
    str r0, [sp]
    lsl r1, r1, #8
    str r1, [sp, #4]
    mov r0, #0
    str r0, [sp, #8]
    str r0, [sp, #0xC]
    sub r1, #0x20
    ldr r0, [r5, r1]
    ldr r3, [r5]
    mov r1, r7
    mov r2, #4
    bl Slots_PaletteData_LoadFromOpenNarc
    mov r0, #0
    str r0, [sp]
    str r0, [sp, #4]
    str r0, [sp, #8]
    ldr r0, [r5]
    mov r2, #0x61
    str r0, [sp, #0xC]
    lsl r2, r2, #2
    ldr r2, [r5, r2]
    mov r0, r7
    mov r1, #0xE
    mov r3, #3
    bl Slots_GfGfxLoader_LoadCharDataFromOpenNarc
    mov r0, #0
    str r0, [sp]
    str r0, [sp, #4]
    str r0, [sp, #8]
    ldr r0, [r5]
    mov r2, #0x61
    str r0, [sp, #0xC]
    lsl r2, r2, #2
    ldr r2, [r5, r2]
    mov r0, r7
    mov r1, #0xF
    mov r3, #3
    bl Slots_GfGfxLoader_LoadScrnDataFromOpenNarc
    mov r3, #0
    str r3, [sp]
    str r3, [sp, #4]
    str r3, [sp, #8]
    ldr r0, [r5]
    mov r2, #0x61
    str r0, [sp, #0xC]
    lsl r2, r2, #2
    ldr r2, [r5, r2]
    mov r0, r7
    mov r1, #9
    bl Slots_GfGfxLoader_LoadCharDataFromOpenNarc
    mov r3, #0
    str r3, [sp]
    str r3, [sp, #4]
    str r3, [sp, #8]
    ldr r0, [r5]
    mov r2, #0x61
    str r0, [sp, #0xC]
    lsl r2, r2, #2
    ldr r2, [r5, r2]
    mov r0, r7
    mov r1, #0xA
    bl Slots_GfGfxLoader_LoadScrnDataFromOpenNarc
    mov r0, #0
    str r0, [sp]
    str r0, [sp, #4]
    str r0, [sp, #8]
    ldr r0, [r5]
    mov r2, #0x61
    str r0, [sp, #0xC]
    lsl r2, r2, #2
    ldr r2, [r5, r2]
    mov r0, r7
    mov r1, #0x15
    mov r3, #5
    bl Slots_GfGfxLoader_LoadCharDataFromOpenNarc
    mov r0, #0
    str r0, [sp]
    str r0, [sp, #4]
    str r0, [sp, #8]
    ldr r0, [r5]
    mov r2, #0x61
    str r0, [sp, #0xC]
    lsl r2, r2, #2
    ldr r2, [r5, r2]
    mov r0, r7
    mov r1, #0x16
    mov r3, #5
    bl Slots_GfGfxLoader_LoadScrnDataFromOpenNarc
    mov r0, #0
    str r0, [sp]
    str r0, [sp, #4]
    str r0, [sp, #8]
    ldr r0, [r5]
    mov r2, #0x61
    str r0, [sp, #0xC]
    lsl r2, r2, #2
    ldr r2, [r5, r2]
    mov r0, r7
    mov r1, #0x17
    mov r3, #6
    bl Slots_GfGfxLoader_LoadScrnDataFromOpenNarc
    mov r1, #0xA1
    lsl r1, r1, #2
    mov r0, r5
    add r1, r5, r1
    mov r2, #0x18
    bl Slots_ov77_021E5BB0
    mov r1, #0xA5
    lsl r1, r1, #2
    mov r0, r5
    add r1, r5, r1
    mov r2, #0xC
    bl Slots_ov77_021E5BB0
    mov r1, #0xA9
    lsl r1, r1, #2
    mov r0, r5
    add r1, r5, r1
    mov r2, #0xB
    bl Slots_ov77_021E5BB0
    mov r0, #0xAD
    lsl r0, r0, #2
    mov r6, #0
    add r4, r5, r0
@@branch_1:
    mov r2, r6
    mov r0, r5
    mov r1, r4
    add r2, #0xF
    bl Slots_ov77_021E5BB0
    add r6, r6, #1
    add r4, #0x10
    cmp r6, #3
    blt @@branch_1
    mov r2, #0xBA
    lsl r2, r2, #2
    ldr r3, [r5]
    mov r0, r7
    mov r1, #0xD
    add r2, r5, r2
    bl Slots_GfGfxLoader_GetPlttDataFromOpenNarc
    mov r1, #0xB9
    lsl r1, r1, #2
    str r0, [r5, r1]
    add r0, r1, #4
    ldr r0, [r5, r0]
    add r1, #8
    ldr r0, [r0, #0xC]
    mov r2, #1
    str r0, [r5, r1]
    mov r0, r5
    add r0, #0x25
    ldrb r0, [r0]
    mov r1, #4
    mov r3, #0xC
    str r0, [sp]
    ldr r0, [r5]
    str r0, [sp, #4]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    bl Slots_LoadUserFrameGfx2
    mov r1, #0x1A
    ldr r2, [r5]
    mov r0, #4
    lsl r1, r1, #4
    bl Slots_LoadFontPal1
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r5, r0]
    mov r1, #1
    bl Slots_PaletteData_SetAutoTransparent
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r5, r0]
    bl Slots_PaletteData_PushTransparentBuffers
    mov r0, #6
    str r0, [sp]
    ldr r0, [@@pool_1]
    mov r1, #4
    mov r2, #0x10
    mov r3, #0x1A
    blx Slots_G2x_SetBlendAlpha_
    add sp, #0x10
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word 0x04001050

Slots_ov77_021E579C:
    push {r3-r7, lr}
    mov r1, #0
    mov r6, r0
    ldr r0, [@@pool_1]
    mov r2, r1
    mov r3, #0x1F
    str r1, [sp]
    blx Slots_G2x_SetBlendAlpha_
    mov r7, #0xAD
    mov r4, #0
    mov r5, r6
    lsl r7, r7, #2
@@branch_1:
    ldr r0, [r5, r7]
    bl Slots_Heap_Free
    add r4, r4, #1
    add r5, #0x10
    cmp r4, #3
    blt @@branch_1
    mov r0, #0xB9
    lsl r0, r0, #2
    ldr r0, [r6, r0]
    bl Slots_Heap_Free
    mov r0, #0xA9
    lsl r0, r0, #2
    ldr r0, [r6, r0]
    bl Slots_Heap_Free
    mov r0, #0xA5
    lsl r0, r0, #2
    ldr r0, [r6, r0]
    bl Slots_Heap_Free
    mov r0, #0xA1
    lsl r0, r0, #2
    ldr r0, [r6, r0]
    bl Slots_Heap_Free
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r6, r0]
    mov r1, #3
    bl Slots_PaletteData_FreeBuffers
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r6, r0]
    mov r1, #2
    bl Slots_PaletteData_FreeBuffers
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r6, r0]
    mov r1, #1
    bl Slots_PaletteData_FreeBuffers
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r6, r0]
    mov r1, #0
    bl Slots_PaletteData_FreeBuffers
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r6, r0]
    bl Slots_PaletteData_Free
    mov r0, #0x2F
    lsl r0, r0, #4
    ldr r0, [r6, r0]
    bl Slots_NARC_Delete
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word 0x04001050

Slots_ov77_021E5838:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4]
    mov r0, #4
    bl Slots_FontID_Alloc
    mov r2, #0x6D
    ldr r3, [r4]
    mov r0, #0
    mov r1, #0x1B
    lsl r2, r2, #2
    bl Slots_NewMsgDataFromNarc
    mov r1, #0x5D
    lsl r1, r1, #2
    str r0, [r4, r1]
    ldr r2, [r4]
    mov r0, #0x10
    mov r1, #0x20
    bl Slots_MessageFormat_New_Custom
    mov r1, #0x5E
    lsl r1, r1, #2
    str r0, [r4, r1]
    sub r1, #0x78
    mov r0, r1
    ldr r1, [r4]
    bl Slots_String_New
    mov r1, #0x5F
    lsl r1, r1, #2
    str r0, [r4, r1]
    sub r1, #0x7C
    mov r0, r1
    ldr r1, [r4]
    bl Slots_String_New
    mov r1, #6
    lsl r1, r1, #6
    str r0, [r4, r1]
    pop {r4, pc}
    .align 4

Slots_ov77_021E588C:
    push {r4, lr}
    mov r4, r0
    mov r0, #6
    lsl r0, r0, #6
    ldr r0, [r4, r0]
    bl Slots_String_Delete
    mov r0, #0x5F
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    bl Slots_String_Delete
    mov r0, #0x5E
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    bl Slots_MessageFormat_Delete
    mov r0, #0x5D
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    bl Slots_DestroyMsgData
    mov r0, #4
    bl Slots_FontID_Release
    pop {r4, pc}

Slots_ov77_021E58C0:
    push {r3-r7, lr}
    mov r7, r0
    mov r0, #0x19
    lsl r0, r0, #4
    ldr r4, [@@pool_1]
    mov r6, #0
    add r5, r7, r0
@@branch_1:
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r7, r0]
    mov r1, r5
    mov r2, r4
    bl Slots_AddWindow
    mov r0, r5
    mov r1, #0
    bl Slots_FillWindowPixelBuffer
    add r6, r6, #1
    add r4, #8
    add r5, #0x10
    cmp r6, #5
    blt @@branch_1
    ldr r0, [r7]
    bl Slots_YesNoPrompt_Create
    mov r1, #0x63
    lsl r1, r1, #2
    str r0, [r7, r1]
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_ov77_021E9EB8

Slots_ov77_021E5900:
    push {r4-r6, lr}
    mov r6, r0
    mov r0, #0x19
    lsl r0, r0, #4
    mov r4, #0
    add r5, r6, r0
@@branch_1:
    mov r0, r5
    bl Slots_ClearWindowTilemapAndCopyToVram
    mov r0, r5
    bl Slots_RemoveWindow
    add r4, r4, #1
    add r5, #0x10
    cmp r4, #5
    blt @@branch_1
    mov r0, #0x63
    lsl r0, r0, #2
    ldr r0, [r6, r0]
    bl Slots_YesNoPrompt_Destroy
    pop {r4-r6, pc}

Slots_ov77_021E592C:
    push {r3-r4, lr}
    sub sp, #4
    mov r4, r0
    ldr r1, [r4]
    mov r0, #0x20
    bl Slots_GF_CreateVramTransferManager
    ldr r0, [r4]
    bl Slots_SpriteSystem_Alloc
    mov r1, #0x79
    lsl r1, r1, #2
    str r0, [r4, r1]
    ldr r0, [r4, r1]
    ldr r1, [@@pool_1]
    ldr r2, [@@pool_2]
    mov r3, #3
    bl Slots_SpriteSystem_Init
    ldr r0, [r4]
    bl Slots_thunk_ClearMainOAM
    ldr r0, [r4]
    bl Slots_thunk_ClearSubOAM
    mov r0, #0x79
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    bl Slots_SpriteManager_New
    mov r1, #0x7A
    lsl r1, r1, #2
    str r0, [r4, r1]
    sub r0, r1, #4
    ldr r0, [r4, r0]
    ldr r1, [r4, r1]
    mov r2, #0x17
    bl Slots_SpriteSystem_InitSprites
    mov r3, #0
    mov r1, #0x79
    str r3, [sp]
    lsl r1, r1, #2
    ldr r0, [r4, r1]
    add r1, r1, #4
    ldr r1, [r4, r1]
    ldr r2, [@@pool_3]
    bl Slots_sub_0200D2A4
    add sp, #4
    pop {r3-r4, pc}
    nop
@@pool_1:
    .word Slots_ov77_021E9E70
@@pool_2:
    .word Slots_ov77_021E9D98
@@pool_3:
    .word Slots_ov77_021E9D78

Slots_ov77_021E59A0:
    push {r4, lr}
    mov r1, #0x79
    mov r4, r0
    lsl r1, r1, #2
    ldr r0, [r4, r1]
    add r1, r1, #4
    ldr r1, [r4, r1]
    bl Slots_SpriteSystem_DestroySpriteManager
    mov r0, #0x7A
    mov r1, #0
    lsl r0, r0, #2
    str r1, [r4, r0]
    sub r0, r0, #4
    ldr r0, [r4, r0]
    bl Slots_SpriteSystem_Free
    mov r0, #0x79
    mov r1, #0
    lsl r0, r0, #2
    str r1, [r4, r0]
    bl Slots_GF_DestroyVramTransferManager
    ldr r0, [r4]
    bl Slots_thunk_ClearMainOAM
    ldr r0, [r4]
    bl Slots_thunk_ClearSubOAM
    pop {r4, pc}

Slots_ov77_021E59DC:
    push {r4, lr}
    mov r4, r0
    bl Slots_ov77_021E592C
    mov r0, r4
    bl Slots_ov77_021E5A28
    mov r0, r4
    bl Slots_ov77_021E5AE0
    mov r0, #0x10
    mov r1, #1
    bl Slots_GfGfx_EngineATogglePlanes
    mov r0, #0x10
    mov r1, #1
    bl Slots_GfGfx_EngineBTogglePlanes
    pop {r4, pc}
    .align 4

Slots_ov77_021E5A04:
    push {r4, lr}
    mov r4, r0
    mov r0, #0x10
    mov r1, #0
    bl Slots_GfGfx_EngineATogglePlanes
    mov r0, #0x10
    mov r1, #0
    bl Slots_GfGfx_EngineBTogglePlanes
    mov r0, r4
    bl Slots_ov77_021E5B78
    mov r0, r4
    bl Slots_ov77_021E59A0
    pop {r4, pc}
    .align 4

Slots_ov77_021E5A28:
    push {r3-r7, lr}
    mov r5, r0
    ldr r6, [@@pool_1]
    mov r7, #0
    mov r4, r5
@@branch_1:
    mov r0, #0x79
    mov r1, #0x7A
    lsl r0, r0, #2
    lsl r1, r1, #2
    ldr r0, [r5, r0]
    ldr r1, [r5, r1]
    mov r2, r6
    bl Slots_SpriteSystem_CreateSpriteFromResourceHeader
    mov r1, #0x7B
    lsl r1, r1, #2
    str r0, [r4, r1]
    mov r0, r1
    ldr r0, [r4, r0]
    mov r1, #1
    bl Slots_Sprite_SetDrawFlag
    mov r0, #0x7B
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #1
    bl Slots_Sprite_SetAnimActiveFlag
    add r7, r7, #1
    add r6, #0x28
    add r4, r4, #4
    cmp r7, #2
    ble @@branch_1
    mov r7, #0x7E
    mov r6, #0
    mov r4, r5
    lsl r7, r7, #2
@@branch_2:
    mov r0, #0x79
    mov r1, #0x7A
    lsl r0, r0, #2
    lsl r1, r1, #2
    ldr r0, [r5, r0]
    ldr r1, [r5, r1]
    ldr r2, [@@pool_2]
    bl Slots_SpriteSystem_CreateSpriteFromResourceHeader
    mov r1, #0x7E
    lsl r1, r1, #2
    str r0, [r4, r1]
    mov r0, r1
    ldr r0, [r4, r0]
    mov r1, #0
    bl Slots_Sprite_SetDrawFlag
    mov r0, #0x7E
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #1
    bl Slots_Sprite_SetAnimActiveFlag
    mov r0, #0x7E
    lsl r0, r0, #2
    mov r1, #1
    ldr r0, [r4, r0]
    lsl r1, r1, #12
    bl Slots_Sprite_SetAnimSpeed
    ldr r0, [r4, r7]
    mov r1, #1
    bl Slots_Sprite_SetAffineOverwriteMode
    add r6, r6, #1
    add r4, r4, #4
    cmp r6, #5
    blt @@branch_2
    mov r0, #0x7B
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    mov r1, #0
    bl Slots_Sprite_SetPriority
    mov r0, #0x7D
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    mov r1, #3
    bl Slots_Sprite_SetPriority
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_ov77_021E9F08
@@pool_2:
    .word Slots_ov77_021E9F08+0x78

Slots_ov77_021E5AE0:
    push {r3-r7, lr}
    sub sp, #0x10
    mov r5, r0
    mov r0, #0
    str r0, [sp, #8]
    str r0, [sp, #4]
    mov r0, #0x28
    str r0, [sp]
@@branch_1:
    ldr r0, [sp]
    mov r7, #0
    lsl r0, r0, #16
    asr r0, r0, #16
    mov r6, #0x58
    str r0, [sp, #0xC]
@@branch_2:
    ldr r0, [sp, #4]
    mov r1, #0x7A
    add r0, r7, r0
    lsl r0, r0, #24
    lsr r0, r0, #22
    add r4, r5, r0
    mov r0, #0x79
    lsl r0, r0, #2
    lsl r1, r1, #2
    ldr r0, [r5, r0]
    ldr r1, [r5, r1]
    ldr r2, [@@pool_1]
    bl Slots_SpriteSystem_CreateSpriteFromResourceHeader
    mov r1, #0x92
    lsl r1, r1, #2
    str r0, [r4, r1]
    mov r0, r1
    lsl r1, r6, #16
    ldr r0, [r4, r0]
    ldr r2, [sp, #0xC]
    asr r1, r1, #16
    bl Slots_Sprite_SetPositionXY
    mov r0, #0x92
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #1
    bl Slots_Sprite_SetDrawFlag
    mov r0, #0x92
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #1
    bl Slots_Sprite_SetAnimActiveFlag
    mov r0, #0x92
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #3
    bl Slots_Sprite_SetPriority
    add r7, r7, #1
    add r6, #0x28
    cmp r7, #3
    blt @@branch_2
    ldr r0, [sp, #4]
    add r0, r0, #3
    str r0, [sp, #4]
    ldr r0, [sp]
    add r0, #0x18
    str r0, [sp]
    ldr r0, [sp, #8]
    add r0, r0, #1
    str r0, [sp, #8]
    cmp r0, #5
    blt @@branch_1
    add sp, #0x10
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021E9EE0

Slots_ov77_021E5B78:
    push {r3-r7, lr}
    mov r5, r0
    mov r7, #0x92
    mov r6, #0
    mov r4, r5
    lsl r7, r7, #2
@@branch_1:
    ldr r0, [r4, r7]
    cmp r0, #0
    beq @@branch_2
    bl Slots_Sprite_Delete
@@branch_2:
    add r6, r6, #1
    add r4, r4, #4
    cmp r6, #0xF
    blt @@branch_1
    mov r6, #0x7B
    mov r4, #0
    lsl r6, r6, #2
@@branch_3:
    ldr r0, [r5, r6]
    cmp r0, #0
    beq @@branch_4
    bl Slots_Sprite_Delete
@@branch_4:
    add r4, r4, #1
    add r5, r5, #4
    cmp r4, #8
    blt @@branch_3
    pop {r3-r7, pc}

Slots_ov77_021E5BB0:
    push {r3-r4, lr}
    sub sp, #4
    mov r4, r1
    ldr r1, [r0]
    add r3, r4, #4
    str r1, [sp]
    mov r1, #0x2F
    lsl r1, r1, #4
    ldr r0, [r0, r1]
    mov r1, r2
    mov r2, #0
    bl Slots_GfGfxLoader_GetScrnDataFromOpenNarc
    str r0, [r4]
    ldr r0, [r4, #4]
    ldrh r0, [r0]
    lsr r0, r0, #3
    strb r0, [r4, #0xC]
    ldr r0, [r4, #4]
    ldrh r0, [r0, #2]
    lsr r0, r0, #3
    strb r0, [r4, #0xD]
    ldr r0, [r4, #4]
    add r0, #0xC
    str r0, [r4, #8]
    add sp, #4
    pop {r3-r4, pc}
    .align 4

Slots_ov77_021E5BE8:
    push {r3-r7, lr}
    sub sp, #0x10
    mov r5, r0
    mov r0, #0x19
    lsl r0, r0, #4
    mov r4, #0
    add r6, r5, r0
@@branch_1:
    add r0, r4, #2
    lsl r7, r0, #4
    add r0, r6, r7
    mov r1, #5
    bl Slots_FillWindowPixelBuffer
    mov r0, #0x5D
    mov r2, #6
    lsl r0, r0, #2
    lsl r2, r2, #6
    ldr r0, [r5, r0]
    ldr r2, [r5, r2]
    add r1, r4, #4
    bl Slots_ReadMsgDataIntoString
    mov r0, #0
    str r0, [sp]
    mov r0, #0xFF
    str r0, [sp, #4]
    ldr r0, [@@pool_1]
    mov r2, #6
    str r0, [sp, #8]
    mov r0, #0
    str r0, [sp, #0xC]
    lsl r2, r2, #6
    mov r1, #0
    ldr r2, [r5, r2]
    add r0, r6, r7
    mov r3, r1
    bl Slots_AddTextPrinterParameterizedWithColor
    add r0, r6, r7
    bl Slots_ScheduleWindowCopyToVram
    add r4, r4, #1
    cmp r4, #3
    blt @@branch_1
    add sp, #0x10
    pop {r3-r7, pc}
@@pool_1:
    .word 0x00030405

Slots_ov77_021E5C48:
    push {r3-r5, lr}
    ldr r4, [@@pool_1]
    mov r5, r0
@@branch_1:
    ldr r1, [r5, #0xC]
    mov r0, r5
    lsl r1, r1, #2
    ldr r1, [r4, r1]
    blx r1
    cmp r0, #1
    beq @@branch_1
    cmp r0, #2
    bne @@branch_2
    mov r0, #1
    pop {r3-r5, pc}
@@branch_2:
    mov r0, #0
    pop {r3-r5, pc}
@@pool_1:
    .word Slots_ov77_021E9FAC

Slots_ov77_021E5C6C:
    push {r3-r5, lr}
    mov r5, r0
    mov r4, r1
    bl Slots_System_GetTouchNew
    cmp r0, #0
    beq @@branch_2
    mov r0, #1
    str r0, [r5, #0x20]
    ldr r0, [r5, #0x6C]
    lsl r0, r0, #26
    lsr r0, r0, #31
    bne @@branch_1
    ldr r0, [@@pool_1]
    bl Slots_TouchscreenHitbox_TouchNewIsIn
    cmp r0, #0
    beq @@branch_1
    ldr r0, [@@pool_2]
    bl Slots_PlaySE
    mov r0, #2
    pop {r3-r5, pc}
@@branch_1:
    mov r0, #1
    pop {r3-r5, pc}
@@branch_2:
    ldr r0, [@@pool_3]
    ldr r1, [r0, #0x48]
    ldr r0, [@@pool_4]
    tst r0, r1
    beq @@branch_3
    mov r0, #0
    str r0, [r5, #0x20]
@@branch_3:
    ldr r0, [r5, #0x6C]
    lsl r0, r0, #26
    lsr r0, r0, #31
    bne @@branch_4
    ldr r0, [@@pool_3]
    ldr r1, [r0, #0x48]
    mov r0, #2
    tst r0, r1
    beq @@branch_4
    ldr r0, [@@pool_2]
    bl Slots_PlaySE
    mov r0, #2
    pop {r3-r5, pc}
@@branch_4:
    ldr r0, [@@pool_3]
    ldr r0, [r0, #0x48]
    tst r0, r4
    beq @@branch_5
    mov r0, #1
    pop {r3-r5, pc}
@@branch_5:
    mov r0, #0
    pop {r3-r5, pc}
@@pool_1:
    .word Slots_ov77_021E9FA8
@@pool_2:
    .word 0x000005DC
@@pool_3:
    .word 0x021D110C
@@pool_4:
    .word 0x00000CF3

Slots_ov77_021E5CE8:
    str r1, [r0, #0xC]
    mov r1, #0
    str r1, [r0, #0x10]
    str r1, [r0, #8]
    bx lr
    .align 4

Slots_ov77_021E5CF4:
    str r1, [r0, #0xC]
    str r2, [r0, #0x10]
    mov r1, #0
    str r1, [r0, #8]
    bx lr
    .align 4

Slots_ov77_021E5D00:
    push {r4, lr}
    mov r4, r0
    mov r1, #0
    str r1, [r4, #0x2C]
    mov r2, r4
    str r1, [r4, #0x30]
    mov r3, #0xC
    add r2, #0x4E
    strb r3, [r2]
    mov r2, r4
    mov r3, #2
    add r2, #0xA2
    strb r3, [r2]
    mov r2, r4
    mov r3, #3
    add r2, #0x3A
    strb r3, [r2]
    ldr r3, [r4, #0x6C]
    mov r2, #1
    bic r3, r2
    mov r2, #2
    bic r3, r2
    mov r2, #0x10
    bic r3, r2
    lsl r2, r3, #29
    str r3, [r4, #0x6C]
    lsr r2, r2, #31
    bne @@branch_1
    bl Slots_ov77_021E72B4
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E71EC
@@branch_1:
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E5CE8
    mov r0, #1
    pop {r4, pc}

Slots_ov77_021E5D50:
    push {r4, lr}
    mov r4, r0
    mov r1, #0x4D
    ldsb r1, [r4, r1]
    cmp r1, #0
    beq @@branch_3
    ldr r1, [r4, #8]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_2
    b @@branch_3
@@branch_1:
    bl Slots_ov77_021E8B9C
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    mov r0, #0
    pop {r4, pc}
@@branch_2:
    ldr r0, [r4, #0x34]
    cmp r0, #0
    beq @@branch_3
    mov r0, #0
    pop {r4, pc}
@@branch_3:
    ldr r1, [r4, #0x6C]
    lsl r0, r1, #29
    lsr r0, r0, #31
    beq @@branch_4
    mov r0, #4
    bic r1, r0
    str r1, [r4, #0x6C]
    mov r0, r4
    mov r1, #4
    bl Slots_ov77_021E5CE8
    mov r0, #0
    pop {r4, pc}
@@branch_4:
    mov r0, r4
    mov r1, #2
    bl Slots_ov77_021E5CE8
    mov r0, #1
    pop {r4, pc}
    .align 4

Slots_ov77_021E5DA8:
    push {r4, lr}
    mov r1, #0x40
    mov r4, r0
    bl Slots_ov77_021E5C6C
    cmp r0, #0
    bne @@branch_1
    mov r0, #0
    pop {r4, pc}
@@branch_1:
    cmp r0, #2
    bne @@branch_2
    mov r0, r4
    mov r1, #0x19
    mov r2, #2
    bl Slots_ov77_021E5CF4
    mov r0, #0
    pop {r4, pc}
@@branch_2:
    mov r1, #3
    str r1, [r4, #0x30]
    ldr r0, [r4, #0x28]
    mov r2, #0
    sub r1, r0, r1
    mov r0, r4
    str r1, [r4, #0x28]
    bl Slots_ov77_021E7324
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E7868
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E78C4
    mov r0, #0
    mov r1, r4
    str r0, [r4, #0x34]
    mov r0, r4
    add r1, #0x34
    mov r2, #8
    bl Slots_ov77_021E8514
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E72B4
    mov r0, r4
    mov r1, #3
    bl Slots_ov77_021E5CE8
    ldr r0, [@@pool_1]
    bl Slots_PlaySE
    mov r0, #0
    pop {r4, pc}
@@pool_1:
    .word 0x000005ED

Slots_ov77_021E5E1C:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4, #0x34]
    cmp r1, #0
    beq @@branch_1
    mov r0, #0
    pop {r4, pc}
@@branch_1:
    mov r1, #0xC0
    bl Slots_ov77_021E5C6C
    cmp r0, #0
    bne @@branch_2
    mov r0, #0
    pop {r4, pc}
@@branch_2:
    cmp r0, #2
    bne @@branch_3
    ldr r1, [r4, #0x6C]
    mov r0, #2
    orr r0, r1
    str r0, [r4, #0x6C]
    mov r0, r4
    mov r1, #0x19
    mov r2, #3
    bl Slots_ov77_021E5CF4
    mov r0, #0
    pop {r4, pc}
@@branch_3:
    mov r0, r4
    mov r1, #4
    bl Slots_ov77_021E5CE8
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E71EC
    mov r0, #1
    pop {r4, pc}
    .align 4

Slots_ov77_021E5E68:
    push {r4, lr}
    mov r4, r0
    bl Slots_ov77_021E6B3C
    mov r0, r4
    bl Slots_ov77_021E8DB0
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E8D98
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E8D98
    mov r0, r4
    mov r1, #2
    bl Slots_ov77_021E8D98
    mov r0, r4
    mov r1, #2
    bl Slots_ov77_021E7308
    mov r0, r4
    mov r1, #0
    mov r2, #4
    bl Slots_ov77_021E7904
    mov r0, r4
    mov r1, #2
    bl Slots_ov77_021E72B4
    mov r0, r4
    mov r1, #5
    bl Slots_ov77_021E5CE8
    ldr r0, [@@pool_1]
    bl Slots_PlaySE
    mov r0, #0
    pop {r4, pc}
    nop
@@pool_1:
    .word 0x000005EE

Slots_ov77_021E5EC0:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4, #8]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_2
    b @@branch_4
@@branch_1:
    mov r1, #1
    bl Slots_ov77_021E5C6C
    cmp r0, #1
    bne @@branch_4
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E8E38
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E78F8
    mov r0, r4
    mov r1, #1
    mov r2, #4
    bl Slots_ov77_021E7904
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_4
@@branch_2:
    add r4, #0xAE
    ldrb r1, [r4]
    cmp r1, #0
    beq @@branch_3
    mov r0, #0
    pop {r4, pc}
@@branch_3:
    mov r1, #6
    bl Slots_ov77_021E5CE8
@@branch_4:
    mov r0, #0
    pop {r4, pc}
    .align 4

Slots_ov77_021E5F14:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4, #8]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_2
    cmp r1, #2
    beq @@branch_6
    b @@branch_8
@@branch_1:
    mov r1, #1
    bl Slots_ov77_021E5C6C
    cmp r0, #1
    bne @@branch_8
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E8E38
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E78F8
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_8
@@branch_2:
    mov r1, r4
    add r1, #0xCA
    ldrb r1, [r1]
    cmp r1, #0
    beq @@branch_3
    mov r0, #0
    pop {r4, pc}
@@branch_3:
    bl Slots_ov77_021E6C20
    cmp r0, #0
    bne @@branch_4
    mov r0, r4
    mov r1, #7
    bl Slots_ov77_021E5CE8
    mov r0, #0
    pop {r4, pc}
@@branch_4:
    mov r2, #0
    str r2, [r4, #0x34]
    ldr r1, [r4, #0x6C]
    mov r0, r4
    lsl r1, r1, #27
    lsr r1, r1, #31
    mov r3, #8
    bl Slots_ov77_021E85E8
    ldr r0, [r4, #0x6C]
    lsl r0, r0, #27
    lsr r0, r0, #31
    beq @@branch_5
    mov r1, r4
    add r1, #0xA2
    ldrb r1, [r1]
    mov r2, r4
    mov r0, r4
    add r1, r1, #5
    add r2, #0x34
    mov r3, #8
    bl Slots_ov77_021E8364
@@branch_5:
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_8
@@branch_6:
    ldr r1, [r4, #0x34]
    cmp r1, #0
    beq @@branch_7
    mov r0, #0
    pop {r4, pc}
@@branch_7:
    mov r1, #7
    bl Slots_ov77_021E5CE8
@@branch_8:
    mov r0, #0
    pop {r4, pc}
    .align 4

Slots_ov77_021E5FB8:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4, #8]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_2
    cmp r1, #2
    beq @@branch_3
    b @@branch_5
@@branch_1:
    mov r1, #2
    mov r2, #4
    bl Slots_ov77_021E7904
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_5
@@branch_2:
    mov r1, #1
    bl Slots_ov77_021E5C6C
    cmp r0, #1
    bne @@branch_5
    mov r0, r4
    mov r1, #2
    bl Slots_ov77_021E8E38
    mov r0, r4
    mov r1, #2
    bl Slots_ov77_021E78F8
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_5
@@branch_3:
    add r4, #0xE6
    ldrb r1, [r4]
    cmp r1, #0
    beq @@branch_4
    mov r0, #0
    pop {r4, pc}
@@branch_4:
    mov r1, #8
    bl Slots_ov77_021E5CE8
@@branch_5:
    mov r0, #0
    pop {r4, pc}

Slots_ov77_021E6014:
    push {r3-r4, lr}
    sub sp, #0x14
    mov r4, r0
    mov r1, #0
    mov r2, r4
@@branch_1:
    mov r0, r2
    add r0, #0xAE
    ldrb r0, [r0]
    cmp r0, #0
    beq @@branch_2
    add sp, #0x14
    mov r0, #0
    pop {r3-r4, pc}
@@branch_2:
    add r1, r1, #1
    add r2, #0x1C
    cmp r1, #3
    blt @@branch_1
    mov r3, r4
    mov r0, r4
    mov r1, #1
    add r2, sp, #0
    add r3, #0x78
    bl Slots_ov77_021E8E48
    cmp r0, #0
    bne @@branch_3
    mov r0, r4
    mov r1, #0
    add r0, #0xA0
    b @@branch_4
@@branch_3:
    mov r0, r4
    ldr r1, [sp]
    add r0, #0xA0
    strb r1, [r0]
    mov r0, r4
    ldr r1, [r4, #0x78]
    add r0, #0xA1
@@branch_4:
    strb r1, [r0]
    mov r0, r4
    bl Slots_ov77_021E85C8
    mov r0, r4
    add r0, #0xA0
    ldrb r0, [r0]
    cmp r0, #0
    bne @@branch_5
    mov r0, r4
    mov r1, #0xA
    bl Slots_ov77_021E5CE8
    add sp, #0x14
    mov r0, #0
    pop {r3-r4, pc}
@@branch_5:
    cmp r0, #1
    bne @@branch_6
    ldr r1, [r4, #0x6C]
    mov r0, #4
    orr r0, r1
    str r0, [r4, #0x6C]
@@branch_6:
    mov r0, r4
    mov r1, #9
    bl Slots_ov77_021E5CE8
    mov r0, #1
    add sp, #0x14
    pop {r3-r4, pc}

Slots_ov77_021E6098:
    push {r3-r5, lr}
    mov r4, r0
    ldr r1, [r4, #8]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_3
    cmp r1, #2
    beq @@branch_6
    b @@branch_11
@@branch_1:
    mov r1, r4
    add r1, #0xA0
    ldrb r1, [r1]
    mov r2, r4
    add r2, #0x34
    mov r3, #3
    bl Slots_ov77_021E8418
    mov r0, #3
    mov r2, r4
    str r0, [sp]
    add r2, #0xA0
    mov r3, r4
    ldrb r2, [r2]
    mov r0, r4
    mov r1, #0
    add r3, #0x34
    bl Slots_ov77_021E7A30
    mov r1, r4
    add r1, #0xA1
    ldrb r1, [r1]
    mov r0, r4
    mov r2, #0
    mov r3, #3
    bl Slots_ov77_021E799C
    mov r0, r4
    add r0, #0xA0
    ldrb r0, [r0]
    bl Slots_ov77_021E7188
    cmp r0, #0
    beq @@branch_2
    mov r2, r4
    mov r0, r4
    mov r1, #4
    add r2, #0x34
    bl Slots_ov77_021E7EA0
@@branch_2:
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_11
@@branch_3:
    ldr r1, [r4, #0x34]
    cmp r1, #0
    beq @@branch_4
    mov r0, #0
    pop {r3-r5, pc}
@@branch_4:
    bl Slots_ov77_021E6E48
    mov r1, r0
    mov r0, r4
    mov r2, #1
    bl Slots_ov77_021E8894
    ldr r0, [r4, #0x6C]
    lsl r0, r0, #29
    lsr r0, r0, #31
    bne @@branch_5
    mov r1, r4
    add r1, #0xA0
    ldrb r1, [r1]
    mov r0, r4
    bl Slots_ov77_021E7198
    mov r2, r4
    mov r1, r0
    mov r0, r4
    add r2, #0x34
    mov r3, #3
    bl Slots_ov77_021E7B04
@@branch_5:
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_11
@@branch_6:
    ldr r0, [r4, #0x34]
    cmp r0, #0
    beq @@branch_7
    mov r0, #0
    pop {r3-r5, pc}
@@branch_7:
    mov r0, r4
    add r0, #0xA0
    ldrb r0, [r0]
    bl Slots_ov77_021E7188
    mov r5, r0
    mov r0, r4
    mov r1, r5
    bl Slots_ov77_021E6A10
    cmp r0, #0
    bne @@branch_8
    mov r0, r4
    mov r1, #0x1A
    bl Slots_ov77_021E5CE8
    mov r0, #0
    pop {r3-r5, pc}
@@branch_8:
    cmp r5, #0
    beq @@branch_9
    mov r0, r4
    mov r1, #0xD
    bl Slots_ov77_021E5CE8
    b @@branch_10
@@branch_9:
    mov r0, r4
    mov r1, #0
    mov r2, #3
    bl Slots_ov77_021E741C
    mov r0, r4
    mov r1, #0xC
    bl Slots_ov77_021E5CE8
@@branch_10:
    mov r0, #0
    pop {r3-r5, pc}
@@branch_11:
    mov r0, #0
    pop {r3-r5, pc}

Slots_ov77_021E619C:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4, #8]
    cmp r1, #3
    bhi @@branch_7
    add r1, r1, r1
    add r1, pc
    ldrh r1, [r1, #6]
    lsl r1, r1, #16
    asr r1, r1, #16
    add pc, r1
@@table_1:
    .halfword @@case_1 - @@table_1 - 2
    .halfword @@case_2 - @@table_1 - 2
    .halfword @@case_3 - @@table_1 - 2
    .halfword @@case_4 - @@table_1 - 2
@@case_1:
    mov r1, r4
    add r1, #0xA2
    ldrb r1, [r1]
    cmp r1, #2
    beq @@branch_1
    mov r2, r4
    mov r1, #0xA
    add r2, #0x34
    mov r3, #3
    bl Slots_ov77_021E8418
@@branch_1:
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
@@case_2:
    ldr r0, [r4, #0x34]
    cmp r0, #0
    beq @@branch_2
    mov r0, #0
    pop {r4, pc}
@@branch_2:
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
@@case_3:
    mov r0, r4
    bl Slots_ov77_021E6EE0
    mov r1, r0
    mov r0, r4
    mov r2, #0
    bl Slots_ov77_021E8894
    mov r0, r4
    mov r1, #5
    bl Slots_ov77_021E7308
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_7
@@case_4:
    ldr r1, [r4, #0x34]
    cmp r1, #0
    beq @@branch_3
    mov r0, #0
    pop {r4, pc}
@@branch_3:
    mov r1, #0
    bl Slots_ov77_021E6A10
    cmp r0, #0
    bne @@branch_4
    mov r0, r4
    mov r1, #0x1A
    bl Slots_ov77_021E5CE8
    mov r0, #0
    pop {r4, pc}
@@branch_4:
    mov r0, r4
    add r0, #0x3A
    ldrb r0, [r0]
    cmp r0, #3
    bne @@branch_5
    mov r0, r4
    mov r1, #0xC
    bl Slots_ov77_021E5CE8
    b @@branch_6
@@branch_5:
    mov r0, r4
    mov r1, #0xB
    bl Slots_ov77_021E5CE8
@@branch_6:
    mov r0, #0
    pop {r4, pc}
@@branch_7:
    mov r0, #0
    pop {r4, pc}
    .align 4

Slots_ov77_021E624C:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4, #8]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_2
    b @@branch_4
@@branch_1:
    mov r1, r4
    mov r2, r4
    add r1, #0x39
    add r2, #0x3A
    mov r3, r4
    ldrb r1, [r1]
    ldrb r2, [r2]
    add r3, #0x34
    bl Slots_ov77_021E80E0
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_4
@@branch_2:
    ldr r1, [r4, #0x34]
    cmp r1, #0
    beq @@branch_3
    mov r0, #0
    pop {r4, pc}
@@branch_3:
    mov r1, r4
    add r1, #0x3A
    ldrb r2, [r1]
    mov r1, r4
    add r1, #0x39
    strb r2, [r1]
    ldr r2, [r4, #0x6C]
    mov r1, #0x80
    bic r2, r1
    mov r1, #0xC
    str r2, [r4, #0x6C]
    bl Slots_ov77_021E5CE8
    mov r0, #0
    pop {r4, pc}
@@branch_4:
    mov r0, #0
    pop {r4, pc}

Slots_ov77_021E62A4:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4, #0x6C]
    lsl r1, r1, #29
    lsr r1, r1, #31
    bne @@branch_1
    mov r1, #0
    bl Slots_ov77_021E7868
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E78C4
@@branch_1:
    mov r0, r4
    mov r1, #3
    bl Slots_ov77_021E7308
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E5CE8
    mov r0, #1
    pop {r4, pc}
    .align 4

Slots_ov77_021E62D4:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4, #8]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_2
    b @@branch_4
@@branch_1:
    mov r1, #1
    bl Slots_ov77_021E6A58
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E7868
    mov r0, r4
    mov r1, #3
    bl Slots_ov77_021E7308
    mov r2, r4
    mov r0, r4
    mov r1, #3
    add r2, #0x34
    bl Slots_ov77_021E7EA0
    mov r1, r4
    mov r0, r4
    add r1, #0x34
    mov r2, #8
    bl Slots_ov77_021E8514
    mov r1, r4
    mov r0, r4
    add r1, #0x34
    mov r2, #8
    bl Slots_ov77_021E7748
    mov r2, r4
    mov r0, r4
    mov r1, #1
    add r2, #0x34
    mov r3, #8
    bl Slots_ov77_021E7678
    bl Slots_GF_GetCurrentPlayingBGM
    mov r1, #8
    bl Slots_StopBGM
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_4
@@branch_2:
    ldr r0, [r4, #0x34]
    cmp r0, #0
    beq @@branch_3
    mov r0, #0
    pop {r4, pc}
@@branch_3:
    ldr r0, [@@pool_1]
    bl Slots_PlayBGM
    mov r0, r4
    mov r1, #0xF
    bl Slots_ov77_021E5CE8
@@branch_4:
    mov r0, #1
    pop {r4, pc}
    nop
@@pool_1:
    .word 0x0000048A

Slots_ov77_021E6360:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4, #8]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_2
    b @@branch_4
@@branch_1:
    mov r1, #0
    bl Slots_ov77_021E6A58
    mov r2, r4
    mov r0, r4
    mov r1, #1
    add r2, #0x34
    bl Slots_ov77_021E7EA0
    mov r1, r4
    mov r0, r4
    add r1, #0x34
    mov r2, #8
    bl Slots_ov77_021E8514
    mov r1, r4
    mov r0, r4
    add r1, #0x34
    mov r2, #8
    bl Slots_ov77_021E7748
    mov r2, r4
    mov r0, r4
    mov r1, #0
    add r2, #0x34
    mov r3, #8
    bl Slots_ov77_021E7678
    bl Slots_GF_GetCurrentPlayingBGM
    mov r1, #8
    bl Slots_StopBGM
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_4
@@branch_2:
    ldr r0, [r4, #0x34]
    cmp r0, #0
    beq @@branch_3
    mov r0, #0
    pop {r4, pc}
@@branch_3:
    ldr r0, [@@pool_1]
    bl Slots_PlayBGM
    mov r0, r4
    mov r1, #0xC
    bl Slots_ov77_021E5CE8
@@branch_4:
    mov r0, #1
    pop {r4, pc}
    nop
@@pool_1:
    .word 0x0000042D

Slots_ov77_021E63DC:
    push {r4, lr}
    mov r4, r0
    mov r1, #0
    str r1, [r4, #0x2C]
    mov r1, r4
    mov r2, #8
    add r1, #0x4E
    strb r2, [r1]
    ldr r2, [r4, #0x6C]
    mov r1, #2
    bic r2, r1
    mov r1, #3
    str r2, [r4, #0x6C]
    bl Slots_ov77_021E72B4
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E71EC
    mov r2, #0
    mov r1, r2
@@branch_1:
    add r0, r4, r2
    add r0, #0x50
    add r2, r2, #1
    strb r1, [r0]
    cmp r2, #3
    blt @@branch_1
    mov r0, r4
    mov r1, #0x10
    bl Slots_ov77_021E5CE8
    mov r0, #1
    pop {r4, pc}
    .align 4

Slots_ov77_021E6420:
    push {r4, lr}
    mov r1, #0x40
    mov r4, r0
    bl Slots_ov77_021E5C6C
    cmp r0, #0
    bne @@branch_1
    mov r0, #0
    pop {r4, pc}
@@branch_1:
    cmp r0, #2
    bne @@branch_2
    mov r0, r4
    mov r1, #0x19
    mov r2, #0x10
    bl Slots_ov77_021E5CF4
    mov r0, #0
    pop {r4, pc}
@@branch_2:
    ldr r1, [r4, #0x28]
    ldr r0, [r4, #0x30]
    mov r2, #0
    sub r1, r1, r0
    mov r0, r4
    str r1, [r4, #0x28]
    bl Slots_ov77_021E7324
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E7868
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E78C4
    mov r0, #0
    mov r1, r4
    str r0, [r4, #0x34]
    mov r0, r4
    add r1, #0x34
    mov r2, #8
    bl Slots_ov77_021E8514
    mov r0, r4
    mov r1, #2
    bl Slots_ov77_021E7308
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E72B4
    mov r0, r4
    mov r1, #0x11
    bl Slots_ov77_021E5CE8
    ldr r0, [@@pool_1]
    bl Slots_PlaySE
    mov r0, #0
    pop {r4, pc}
    nop
@@pool_1:
    .word 0x000005ED

Slots_ov77_021E649C:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4, #0x34]
    cmp r1, #0
    beq @@branch_1
    mov r0, #0
    pop {r4, pc}
@@branch_1:
    mov r1, #0xC0
    bl Slots_ov77_021E5C6C
    cmp r0, #0
    bne @@branch_2
    mov r0, #0
    pop {r4, pc}
@@branch_2:
    cmp r0, #2
    bne @@branch_3
    ldr r1, [r4, #0x6C]
    mov r0, #2
    orr r0, r1
    str r0, [r4, #0x6C]
    mov r0, r4
    mov r1, #0x19
    mov r2, #0x11
    bl Slots_ov77_021E5CF4
    mov r0, #0
    pop {r4, pc}
@@branch_3:
    mov r0, r4
    mov r1, #0x12
    bl Slots_ov77_021E5CE8
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E71EC
    mov r0, #1
    pop {r4, pc}
    .align 4

Slots_ov77_021E64E8:
    push {r4, lr}
    mov r4, r0
    bl Slots_ov77_021E6CD8
    mov r0, r4
    bl Slots_ov77_021E8DB0
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E8D98
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E8D98
    mov r0, r4
    mov r1, #2
    bl Slots_ov77_021E8D98
    mov r1, #0
    mov r0, r4
    mov r2, r4
    str r1, [r4, #0x34]
    add r0, #0x43
    strb r1, [r0]
    mov r0, r4
    add r0, #0x44
    strb r1, [r0]
    mov r0, r4
    mov r1, #1
    add r2, #0x34
    mov r3, #8
    bl Slots_ov77_021E85E8
    mov r1, r4
    add r1, #0x3B
    ldrb r1, [r1]
    mov r2, r4
    mov r0, r4
    add r1, r1, #7
    add r2, #0x34
    mov r3, #8
    bl Slots_ov77_021E8364
    mov r2, r4
    add r2, #0x3B
    ldrb r2, [r2]
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E741C
    mov r0, r4
    mov r1, #6
    bl Slots_ov77_021E7308
    mov r0, r4
    mov r1, #2
    bl Slots_ov77_021E72B4
    mov r0, r4
    mov r1, #0x13
    bl Slots_ov77_021E5CE8
    ldr r0, [@@pool_1]
    bl Slots_PlaySE
    mov r0, #0
    pop {r4, pc}
@@pool_1:
    .word 0x000005EE

Slots_ov77_021E6574:
    push {r3-r7, lr}
    mov r5, r0
    ldr r0, [r5, #8]
    cmp r0, #0
    beq @@branch_1
    cmp r0, #1
    beq @@branch_5
    cmp r0, #2
    beq @@branch_8
    b @@branch_11
@@branch_1:
    ldr r0, [r5, #0x34]
    cmp r0, #0
    bgt @@branch_12
    mov r4, #0
    mov r6, r5
    mov r7, r4
    add r6, #0x43
@@branch_2:
    add r0, r5, r4
    add r0, #0x50
    ldrb r0, [r0]
    cmp r0, #0
    beq @@branch_3
    mov r0, r5
    mov r1, r4
    mov r2, r7
    bl Slots_ov77_021E78EC
    ldrb r0, [r6]
    add r0, r0, #1
    strb r0, [r6]
@@branch_3:
    add r4, r4, #1
    cmp r4, #3
    blt @@branch_2
    mov r0, r5
    add r0, #0x43
    ldrb r0, [r0]
    cmp r0, #0
    bne @@branch_4
    mov r0, r5
    mov r1, #0x14
    bl Slots_ov77_021E5CE8
    mov r0, #0
    pop {r3-r7, pc}
@@branch_4:
    mov r0, #4
    str r0, [r5, #0x70]
    ldr r0, [r5, #8]
    add r0, r0, #1
    str r0, [r5, #8]
    b @@branch_12
@@branch_5:
    ldr r0, [r5, #0x70]
    sub r0, r0, #1
    str r0, [r5, #0x70]
    cmp r0, #0
    bgt @@branch_12
    mov r4, #0
@@branch_6:
    add r0, r5, r4
    add r0, #0x50
    ldrb r0, [r0]
    cmp r0, #0
    beq @@branch_7
    mov r0, r5
    mov r1, r4
    bl Slots_ov77_021E8E38
@@branch_7:
    add r4, r4, #1
    cmp r4, #3
    blt @@branch_6
    ldr r0, [r5, #8]
    add r0, r0, #1
    str r0, [r5, #8]
    b @@branch_12
@@branch_8:
    mov r2, #0
    mov r1, r5
@@branch_9:
    add r0, r5, r2
    add r0, #0x50
    ldrb r0, [r0]
    cmp r0, #0
    beq @@branch_10
    mov r0, r1
    add r0, #0xAE
    ldrb r0, [r0]
    cmp r0, #0
    beq @@branch_10
    mov r0, #0
    pop {r3-r7, pc}
@@branch_10:
    add r2, r2, #1
    add r1, #0x1C
    cmp r2, #3
    blt @@branch_9
@@branch_11:
    mov r0, r5
    mov r1, #0x14
    bl Slots_ov77_021E5CE8
    mov r0, #0
    str r0, [r5, #8]
@@branch_12:
    mov r0, #0
    pop {r3-r7, pc}

Slots_ov77_021E6638:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4, #8]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_5
    cmp r1, #2
    beq @@branch_6
    b @@branch_9
@@branch_1:
    mov r1, #0
@@branch_2:
    add r0, r4, r1
    add r0, #0x50
    ldrb r0, [r0]
    cmp r0, #0
    bne @@branch_3
    mov r0, r4
    add r0, #0x44
    strb r1, [r0]
    mov r0, r4
    add r0, #0x43
    ldrb r0, [r0]
    add r2, r0, #1
    mov r0, r4
    add r0, #0x43
    strb r2, [r0]
    mov r0, r4
    mov r2, #4
    bl Slots_ov77_021E7904
    b @@branch_4
@@branch_3:
    add r1, r1, #1
    cmp r1, #3
    blt @@branch_2
@@branch_4:
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
@@branch_5:
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E5C6C
    cmp r0, #1
    bne @@branch_9
    mov r1, r4
    add r1, #0x44
    ldrb r1, [r1]
    mov r0, r4
    bl Slots_ov77_021E78F8
    mov r1, r4
    add r1, #0x44
    ldrb r1, [r1]
    mov r0, r4
    bl Slots_ov77_021E8E38
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_9
@@branch_6:
    mov r1, r4
    add r1, #0x44
    ldrb r1, [r1]
    mov r2, #0x1C
    mul r2, r1
    add r2, r4, r2
    add r2, #0xAE
    ldrb r2, [r2]
    cmp r2, #0
    beq @@branch_7
    mov r0, #0
    pop {r4, pc}
@@branch_7:
    mov r2, #0
    bl Slots_ov77_021E78EC
    mov r0, r4
    add r0, #0x44
    ldrb r0, [r0]
    mov r1, #1
    add r0, r4, r0
    add r0, #0x50
    strb r1, [r0]
    mov r0, r4
    add r0, #0x43
    ldrb r0, [r0]
    cmp r0, #3
    bcs @@branch_8
    mov r0, #0
    str r0, [r4, #8]
    b @@branch_9
@@branch_8:
    mov r0, r4
    mov r1, #0x15
    bl Slots_ov77_021E5CE8
@@branch_9:
    mov r0, #0
    pop {r4, pc}
    .align 4

Slots_ov77_021E66F8:
    push {r4, lr}
    mov r4, r0
    mov r1, #0
    mov r2, r4
@@branch_1:
    mov r0, r2
    add r0, #0xAE
    ldrb r0, [r0]
    cmp r0, #0
    beq @@branch_2
    mov r0, #0
    pop {r4, pc}
@@branch_2:
    add r1, r1, #1
    add r2, #0x1C
    cmp r1, #3
    blt @@branch_1
    mov r0, r4
    bl Slots_ov77_021E85C8
    mov r0, r4
    mov r1, #1
    bl Slots_ov77_021E8EF8
    cmp r0, #0
    bge @@branch_3
    mov r0, r4
    mov r1, #0x17
    bl Slots_ov77_021E5CE8
    b @@branch_4
@@branch_3:
    mov r0, r4
    add r0, #0x3B
    ldrb r1, [r0]
    mov r0, r4
    add r0, #0xA0
    strb r1, [r0]
    mov r0, r4
    add r0, #0x40
    ldrb r0, [r0]
    add r1, r0, #1
    mov r0, r4
    add r0, #0x40
    strb r1, [r0]
    mov r0, r4
    mov r1, #0x16
    bl Slots_ov77_021E5CE8
@@branch_4:
    mov r0, #1
    pop {r4, pc}

Slots_ov77_021E6758:
    push {r3-r7, lr}
    mov r5, r0
    ldr r1, [r5, #8]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_3
    cmp r1, #2
    beq @@branch_5
    b @@branch_7
@@branch_1:
    mov r1, r5
    add r1, #0xA0
    ldrb r1, [r1]
    mov r2, r5
    add r2, #0x34
    add r1, r1, #7
    mov r3, #3
    bl Slots_ov77_021E8418
    mov r0, #3
    mov r2, r5
    str r0, [sp]
    add r2, #0x3B
    mov r3, r5
    ldrb r2, [r2]
    mov r0, r5
    mov r1, #1
    add r3, #0x34
    bl Slots_ov77_021E7A30
    mov r4, #0
    mov r6, r4
    mov r7, #3
@@branch_2:
    mov r0, r5
    mov r1, r4
    mov r2, r6
    mov r3, r7
    bl Slots_ov77_021E799C
    add r4, r4, #1
    cmp r4, #5
    blt @@branch_2
    ldr r0, [r5, #8]
    add r0, r0, #1
    str r0, [r5, #8]
    b @@branch_7
@@branch_3:
    ldr r1, [r5, #0x34]
    cmp r1, #0
    beq @@branch_4
    mov r0, #0
    pop {r3-r7, pc}
@@branch_4:
    mov r1, r5
    add r1, #0x42
    ldrb r1, [r1]
    mov r2, r5
    add r2, #0x34
    mov r3, #3
    bl Slots_ov77_021E7B04
    ldr r0, [r5, #8]
    add r0, r0, #1
    str r0, [r5, #8]
    b @@branch_7
@@branch_5:
    ldr r1, [r5, #0x34]
    cmp r1, #0
    beq @@branch_6
    mov r0, #0
    pop {r3-r7, pc}
@@branch_6:
    mov r1, #0x18
    bl Slots_ov77_021E5CE8
    mov r0, #0
    pop {r3-r7, pc}
@@branch_7:
    mov r0, #0
    pop {r3-r7, pc}
    .align 4

Slots_ov77_021E67F0:
    push {r4, lr}
    mov r4, r0
    ldr r1, [r4, #8]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_2
    cmp r1, #2
    beq @@branch_4
    b @@branch_6
@@branch_1:
    mov r2, r4
    mov r1, #0xA
    add r2, #0x34
    mov r3, #3
    bl Slots_ov77_021E8418
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_6
@@branch_2:
    ldr r1, [r4, #0x34]
    cmp r1, #0
    beq @@branch_3
    mov r0, #0
    pop {r4, pc}
@@branch_3:
    mov r1, #0x1E
    str r1, [r4, #0x34]
    mov r1, #5
    bl Slots_ov77_021E7308
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_6
@@branch_4:
    ldr r1, [r4, #0x34]
    sub r1, r1, #1
    str r1, [r4, #0x34]
    beq @@branch_5
    mov r0, #0
    pop {r4, pc}
@@branch_5:
    mov r1, #0x18
    bl Slots_ov77_021E5CE8
    mov r0, #0
    pop {r4, pc}
@@branch_6:
    mov r0, #0
    pop {r4, pc}
    .align 4

Slots_ov77_021E6850:
    push {r3-r5, lr}
    mov r5, r0
    add r0, #0x3E
    ldrb r0, [r0]
    mov r4, #1
    add r1, r0, #1
    mov r0, r5
    add r0, #0x3E
    strb r1, [r0]
    mov r0, r5
    add r0, #0x3E
    ldrb r1, [r0]
    mov r0, r5
    add r0, #0x3F
    ldrb r0, [r0]
    cmp r1, r0
    bcc @@branch_1
    mov r4, #0
@@branch_1:
    mov r0, r5
    mov r1, r4
    bl Slots_ov77_021E6A10
    cmp r0, #0
    bne @@branch_2
    mov r0, r5
    mov r1, #0x1A
    bl Slots_ov77_021E5CE8
    mov r0, #0
    pop {r3-r5, pc}
@@branch_2:
    cmp r4, #0
    bne @@branch_3
    mov r0, r5
    mov r1, #0xE
    bl Slots_ov77_021E5CE8
    mov r0, #1
    pop {r3-r5, pc}
@@branch_3:
    mov r0, r5
    mov r1, #0
    add r0, #0x42
    strb r1, [r0]
    mov r0, r5
    mov r1, #1
    mov r2, #3
    bl Slots_ov77_021E741C
    mov r0, r5
    mov r1, #0
    bl Slots_ov77_021E7868
    mov r0, r5
    mov r1, #0
    bl Slots_ov77_021E78C4
    mov r0, r5
    mov r1, #3
    bl Slots_ov77_021E7308
    mov r0, r5
    mov r1, #0xF
    bl Slots_ov77_021E5CE8
    mov r0, #1
    pop {r3-r5, pc}
    .align 4

Slots_ov77_021E68D4:
    push {r3-r4, lr}
    sub sp, #4
    mov r4, r0
    ldr r1, [r4, #8]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_2
    b @@branch_5
@@branch_1:
    mov r1, #2
    bl Slots_ov77_021E71EC
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E721C
    mov r1, #0
    ldr r0, [@@pool_1]
    mov r2, r1
    mov r3, #0x1F
    str r1, [sp]
    blx Slots_G2x_SetBlendAlpha_
    mov r1, #0x1E
    mov r2, r1
    ldr r0, [@@pool_1]
    sub r2, #0x26
    blx Slots_G2x_SetBlendBrightness_
    mov r0, r4
    bl Slots_ov77_021E7074
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_5
@@branch_2:
    bl Slots_ov77_021E70D4
    cmp r0, #0
    bne @@branch_3
    add sp, #4
    mov r0, #0
    pop {r3-r4, pc}
@@branch_3:
    cmp r0, #2
    bne @@branch_4
    mov r0, r4
    mov r1, #0x1B
    bl Slots_ov77_021E5CE8
    b @@branch_5
@@branch_4:
    mov r0, r4
    bl Slots_ov77_021E7280
    mov r0, r4
    mov r1, #0
    bl Slots_ov77_021E71EC
    mov r1, #0
    ldr r0, [@@pool_1]
    mov r2, r1
    blx Slots_G2x_SetBlendBrightness_
    mov r0, #6
    str r0, [sp]
    ldr r0, [@@pool_1]
    mov r1, #4
    mov r2, #0x10
    mov r3, #0x1A
    blx Slots_G2x_SetBlendAlpha_
    ldr r1, [r4, #0x10]
    mov r0, r4
    bl Slots_ov77_021E5CE8
@@branch_5:
    mov r0, #0
    add sp, #4
    pop {r3-r4, pc}
    nop
@@pool_1:
    .word 0x04001050

Slots_ov77_021E6974:
    push {r3-r4, lr}
    sub sp, #4
    mov r4, r0
    ldr r1, [r4, #8]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_2
    b @@branch_5
@@branch_1:
    mov r1, r4
    add r1, #0x26
    ldrb r1, [r1]
    bl Slots_ov77_021E721C
    mov r1, #0
    ldr r0, [@@pool_1]
    mov r2, r1
    mov r3, #0x1F
    str r1, [sp]
    blx Slots_G2x_SetBlendAlpha_
    mov r1, #0x1E
    mov r2, r1
    ldr r0, [@@pool_1]
    sub r2, #0x26
    blx Slots_G2x_SetBlendBrightness_
    ldr r0, [r4, #8]
    add r0, r0, #1
    str r0, [r4, #8]
    b @@branch_5
@@branch_2:
    ldr r0, [@@pool_2]
    ldr r1, [r0, #0x48]
    ldr r0, [@@pool_3]
    tst r0, r1
    beq @@branch_3
    mov r0, #0
    str r0, [r4, #0x20]
@@branch_3:
    ldr r0, [@@pool_2]
    ldr r1, [r0, #0x48]
    mov r0, #3
    tst r0, r1
    beq @@branch_4
    mov r0, r4
    mov r1, #0x1B
    bl Slots_ov77_021E5CE8
    b @@branch_5
@@branch_4:
    bl Slots_System_GetTouchNew
    cmp r0, #0
    beq @@branch_5
    mov r0, #1
    str r0, [r4, #0x20]
    mov r0, r4
    mov r1, #0x1B
    bl Slots_ov77_021E5CE8
@@branch_5:
    mov r0, #0
    add sp, #4
    pop {r3-r4, pc}
    nop
@@pool_1:
    .word 0x04001050
@@pool_2:
    .word 0x021D110C
@@pool_3:
    .word 0x00000CF3

Slots_ov77_021E69FC:
    ldr r1, [r0, #0x6C]
    lsl r1, r1, #30
    lsr r1, r1, #31
    beq @@branch_1
    ldr r2, [r0, #0x28]
    ldr r1, [r0, #0x30]
    add r1, r2, r1
    str r1, [r0, #0x28]
@@branch_1:
    mov r0, #2
    bx lr

Slots_ov77_021E6A10:
    ldr r3, [r0, #0x28]
    ldr r2, [@@pool_1]
    cmp r3, r2
    blt @@branch_1
    mov r1, #1
    add r0, #0x26
    strb r1, [r0]
    mov r0, #0
    bx lr
@@branch_1:
    ldr r2, [r0, #0x6C]
    lsl r2, r2, #29
    lsr r2, r2, #31
    beq @@branch_2
    mov r0, #1
    bx lr
@@branch_2:
    cmp r1, #0
    beq @@branch_3
    cmp r3, #1
    bge @@branch_4
    mov r1, #3
    add r0, #0x26
    strb r1, [r0]
    mov r0, #0
    bx lr
@@branch_3:
    cmp r3, #3
    bge @@branch_4
    mov r1, #2
    add r0, #0x26
    strb r1, [r0]
    mov r0, #0
    bx lr
@@branch_4:
    mov r0, #1
    bx lr
    nop
@@pool_1:
    .word 0x0000C350

Slots_ov77_021E6A58:
    push {r4, lr}
    mov r4, r0
    cmp r1, #0
    ldr r1, [r4, #0x6C]
    bne @@branch_3
    mov r0, #1
    bic r1, r0
    mov r0, r4
    str r1, [r4, #0x6C]
    mov r1, #0
    add r0, #0x3F
    strb r1, [r0]
    mov r0, r4
    mov r1, #1
    add r0, #0x39
    strb r1, [r0]
    mov r0, r4
    add r0, #0x4C
    ldrb r0, [r0]
    cmp r0, #5
    bhi @@branch_1
    mov r1, #3
    blx Slots__s32_div_f
    ldr r1, [@@pool_1]
    ldrb r1, [r1, r0]
    b @@branch_2
@@branch_1:
    ldr r0, [@@pool_1]
    ldrb r1, [r0, #2]
@@branch_2:
    mov r0, r4
    add r0, #0x40
    ldrb r0, [r0]
    add r0, r1, r0
    neg r1, r0
    mov r0, r4
    add r0, #0x4D
    strb r1, [r0]
    ldr r1, [r4, #0x6C]
    mov r0, #0x40
    orr r0, r1
    str r0, [r4, #0x6C]
    mov r0, r4
    add r0, #0x4C
    ldrb r0, [r0]
    cmp r0, #0xA
    bcs @@branch_5
    mov r0, r4
    add r0, #0x4C
    ldrb r0, [r0]
    add r1, r0, #1
    mov r0, r4
    add r0, #0x4C
    strb r1, [r0]
    b @@branch_5
@@branch_3:
    mov r0, #1
    bic r1, r0
    mov r0, #1
    orr r1, r0
    str r1, [r4, #0x6C]
    str r0, [r4, #0x30]
    mov r0, r4
    add r0, #0xA0
    ldrb r0, [r0]
    cmp r0, #6
    bne @@branch_4
    mov r0, r4
    mov r1, #0xF
    add r0, #0x3F
    strb r1, [r0]
    ldr r0, [r4, #0x1C]
    bl Slots_GameStats_Inc
    b @@branch_5
@@branch_4:
    mov r0, r4
    mov r1, #8
    add r0, #0x3F
    strb r1, [r0]
@@branch_5:
    mov r1, r4
    mov r0, #0
    add r1, #0x46
    strh r0, [r1]
    mov r1, r4
    add r1, #0x48
    strh r0, [r1]
    ldr r2, [r4, #0x6C]
    mov r1, #0x80
    bic r2, r1
    mov r1, r4
    str r2, [r4, #0x6C]
    add r1, #0x3E
    strb r0, [r1]
    mov r1, r4
    add r1, #0x40
    strb r0, [r1]
    mov r1, r4
    add r1, #0x4A
    strh r0, [r1]
    mov r1, r4
    add r1, #0x42
    strb r0, [r1]
    mov r2, r0
@@branch_6:
    add r1, r4, r0
    add r1, #0x50
    strb r2, [r1]
    add r1, r4, r0
    add r1, #0x53
    add r0, r0, #1
    strb r2, [r1]
    cmp r0, #3
    blt @@branch_6
    pop {r4, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA118

Slots_ov77_021E6B3C:
    push {r3-r5, lr}
    mov r5, r0
    add r0, #0x38
    ldrb r1, [r0]
    mov r0, #0x2A
    ldr r2, [@@pool_1]
    mul r0, r1
    add r2, r2, r0
    mov r0, r5
    add r0, #0x39
    ldrb r1, [r0]
    mov r0, #0xE
    mul r0, r1
    add r4, r2, r0
    bl Slots_ov77_021E7114
    lsl r0, r0, #16
    asr r1, r0, #16
    ldr r0, [r5, #0x6C]
    mov r2, #0xFA
    lsl r0, r0, #24
    lsl r2, r2, #2
    lsr r0, r0, #31
    bne @@branch_3
    mov r3, r5
    mov r0, #0
    add r3, #0x3B
    strb r0, [r3]
@@branch_1:
    ldrh r3, [r4]
    sub r2, r2, r3
    lsl r2, r2, #16
    asr r2, r2, #16
    cmp r1, r2
    blt @@branch_2
    mov r1, r5
    add r1, #0x3B
    strb r0, [r1]
    b @@branch_3
@@branch_2:
    add r0, r0, #1
    add r4, r4, #2
    cmp r0, #7
    blt @@branch_1
@@branch_3:
    mov r0, r5
    add r0, #0x3B
    ldrb r0, [r0]
    bl Slots_ov77_021E7188
    cmp r0, #0
    beq @@branch_4
    ldr r1, [r5, #0x6C]
    mov r0, #0x80
    orr r0, r1
    str r0, [r5, #0x6C]
@@branch_4:
    bl Slots_ov77_021E7114
    lsl r0, r0, #16
    asr r1, r0, #16
    mov r0, r5
    add r0, #0x3B
    ldrb r0, [r0]
    mov r2, #0x12
    ldr r3, [@@pool_2]
    mul r2, r0
    add r4, r3, r2
    mov r2, r5
    add r2, #0x39
    ldrb r3, [r2]
    mov r2, #6
    mul r2, r3
    add r4, r4, r2
    cmp r0, #4
    bcc @@branch_6
    ldrh r2, [r4]
    mov r0, #0xFA
    lsl r0, r0, #2
    sub r0, r0, r2
    cmp r1, r0
    blt @@branch_5
    mov r0, #0
    add r5, #0x3C
    strb r0, [r5]
    pop {r3-r5, pc}
@@branch_5:
    mov r0, #1
    add r5, #0x3C
    strb r0, [r5]
    pop {r3-r5, pc}
@@branch_6:
    ldrh r3, [r4]
    mov r0, #0xFA
    lsl r0, r0, #2
    sub r2, r0, r3
    cmp r1, r2
    blt @@branch_7
    mov r0, #0
    add r5, #0x3C
    strb r0, [r5]
    pop {r3-r5, pc}
@@branch_7:
    ldrh r2, [r4, #2]
    add r2, r3, r2
    sub r0, r0, r2
    cmp r1, r0
    blt @@branch_8
    mov r0, #1
    add r5, #0x3C
    strb r0, [r5]
    pop {r3-r5, pc}
@@branch_8:
    mov r0, #2
    add r5, #0x3C
    strb r0, [r5]
    pop {r3-r5, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA284
@@pool_2:
    .word Slots_ov77_021EA204

Slots_ov77_021E6C20:
    push {r4-r6, lr}
    mov r5, r0
    mov r2, r5
    mov r3, r5
    mov r1, #0
    add r2, #0x8C
    add r3, #0x78
    bl Slots_ov77_021E8E48
    str r0, [r5, #0x74]
    cmp r0, #0
    bne @@branch_1
    mov r0, #0
    pop {r4-r6, pc}
@@branch_1:
    mov r0, r5
    mov r1, #2
    add r0, #0xA2
    strb r1, [r0]
    ldr r0, [r5, #0x74]
    mov r6, #0
    cmp r0, #0
    ble @@branch_4
    mov r4, r5
@@branch_2:
    mov r0, r4
    add r0, #0x8C
    ldr r0, [r0]
    bl Slots_ov77_021E7188
    cmp r0, #0
    beq @@branch_3
    lsl r0, r6, #2
    add r0, r5, r0
    add r0, #0x8C
    ldr r0, [r0]
    sub r1, r0, #5
    mov r0, r5
    add r0, #0xA2
    strb r1, [r0]
    b @@branch_4
@@branch_3:
    ldr r0, [r5, #0x74]
    add r6, r6, #1
    add r4, r4, #4
    cmp r6, r0
    blt @@branch_2
@@branch_4:
    mov r0, r5
    add r0, #0xA2
    ldrb r0, [r0]
    cmp r0, #2
    bne @@branch_5
    mov r0, #0
    pop {r4-r6, pc}
@@branch_5:
    ldr r0, [r5, #0x74]
    cmp r0, #1
    bgt @@branch_6
    mov r0, r5
    add r0, #0x3B
    ldrb r0, [r0]
    bl Slots_ov77_021E7188
    cmp r0, #0
    bne @@branch_7
@@branch_6:
    mov r0, #1
    pop {r4-r6, pc}
@@branch_7:
    mov r0, #0x64
    bl Slots_ov77_021E7128
    mov r1, r5
    add r1, #0x39
    ldrb r2, [r1]
    mov r1, #7
    ldr r3, [@@pool_1]
    mov r4, r2
    mul r4, r1
    mov r1, r5
    add r1, #0x3B
    ldrb r2, [r1]
    add r1, r3, r4
    ldrb r1, [r2, r1]
    cmp r0, r1
    bge @@branch_8
    ldr r1, [r5, #0x6C]
    mov r0, #0x10
    orr r0, r1
    str r0, [r5, #0x6C]
@@branch_8:
    ldr r0, [r5, #0x6C]
    lsl r0, r0, #27
    lsr r0, r0, #31
    add r0, r0, #1
    pop {r4-r6, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA13C

Slots_ov77_021E6CD8:
    push {r3-r7, lr}
    mov r5, r0
    add r0, #0x4C
    ldrb r1, [r0]
    cmp r1, #5
    bls @@branch_1
    mov r1, #5
@@branch_1:
    mov r0, r5
    add r0, #0x3F
    ldrb r0, [r0]
    cmp r0, #0xF
    bne @@branch_4
    mov r0, r5
    add r0, #0x3E
    ldrb r0, [r0]
    cmp r0, #6
    bcs @@branch_2
    mov r0, #0
    b @@branch_7
@@branch_2:
    cmp r0, #0xB
    bcs @@branch_3
    mov r0, #1
    b @@branch_7
@@branch_3:
    mov r0, #2
    b @@branch_7
@@branch_4:
    mov r0, r5
    add r0, #0x3E
    ldrb r0, [r0]
    cmp r0, #4
    bcs @@branch_5
    mov r0, #0
    b @@branch_7
@@branch_5:
    cmp r0, #6
    bcs @@branch_6
    mov r0, #1
    b @@branch_7
@@branch_6:
    mov r0, #2
@@branch_7:
    mov r2, #0xF
    mul r2, r1
    ldr r3, [@@pool_1]
    lsl r1, r0, #2
    add r2, r3, r2
    add r0, r0, r1
    add r6, r2, r0
    mov r0, #3
    bl Slots_ov77_021E7128
    mov r1, r5
    add r1, #0x3B
    strb r0, [r1]
    mov r1, r5
    add r1, #0x3B
    ldrb r1, [r1]
    mov r0, r5
    bl Slots_ov77_021E7198
    mov r1, r5
    add r1, #0x42
    mov r4, #0
    strb r0, [r1]
    mov r7, r4
@@branch_8:
    mov r0, #0x64
    bl Slots_ov77_021E7128
    lsl r0, r0, #16
    asr r1, r0, #16
    ldrb r0, [r6, #4]
    cmp r1, r0
    bge @@branch_9
    add r0, r5, r4
    add r0, #0x53
    strb r7, [r0]
    b @@branch_10
@@branch_9:
    add r1, r5, r4
    add r1, #0x53
    mov r0, #1
    strb r0, [r1]
@@branch_10:
    add r4, r4, #1
    cmp r4, #3
    blt @@branch_8
    mov r0, #0x64
    bl Slots_ov77_021E7128
    lsl r0, r0, #16
    ldrb r1, [r6, #2]
    asr r2, r0, #16
    cmp r2, r1
    bge @@branch_11
    mov r0, r5
    mov r1, #8
    add r0, #0x4E
    strb r1, [r0]
    mov r0, r5
    mov r1, #0
    add r0, #0x4F
    strb r1, [r0]
    b @@branch_13
@@branch_11:
    ldrb r0, [r6, #3]
    add r0, r1, r0
    cmp r2, r0
    bge @@branch_12
    mov r0, r5
    mov r1, #0xC
    add r0, #0x4E
    strb r1, [r0]
    mov r0, r5
    mov r1, #1
    add r0, #0x4F
    strb r1, [r0]
    b @@branch_13
@@branch_12:
    mov r0, r5
    mov r1, #0x18
    add r0, #0x4E
    strb r1, [r0]
    mov r0, r5
    mov r1, #2
    add r0, #0x4F
    strb r1, [r0]
@@branch_13:
    mov r0, #0x64
    bl Slots_ov77_021E7128
    lsl r0, r0, #16
    ldrb r1, [r6]
    asr r2, r0, #16
    cmp r2, r1
    bge @@branch_17
    mov r0, #3
    bl Slots_ov77_021E7128
    lsl r0, r0, #16
    mov r4, #0
    asr r3, r0, #16
    mov r1, r4
    mov r2, #1
@@branch_14:
    cmp r3, r4
    beq @@branch_15
    add r0, r5, r4
    add r0, #0x50
    strb r2, [r0]
    b @@branch_16
@@branch_15:
    add r0, r5, r4
    add r0, #0x50
    strb r1, [r0]
@@branch_16:
    add r4, r4, #1
    cmp r4, #3
    blt @@branch_14
    pop {r3-r7, pc}
@@branch_17:
    ldrb r0, [r6, #1]
    add r0, r1, r0
    cmp r2, r0
    bge @@branch_21
    mov r0, #3
    bl Slots_ov77_021E7128
    lsl r0, r0, #16
    mov r4, #0
    asr r3, r0, #16
    mov r1, r4
    mov r2, #1
@@branch_18:
    cmp r3, r4
    bne @@branch_19
    add r0, r5, r4
    add r0, #0x50
    strb r2, [r0]
    b @@branch_20
@@branch_19:
    add r0, r5, r4
    add r0, #0x50
    strb r1, [r0]
@@branch_20:
    add r4, r4, #1
    cmp r4, #3
    blt @@branch_18
    pop {r3-r7, pc}
@@branch_21:
    mov r2, #0
    mov r1, r2
@@branch_22:
    add r0, r5, r2
    add r0, #0x50
    add r2, r2, #1
    strb r1, [r0]
    cmp r2, #3
    blt @@branch_22
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA1A8

Slots_ov77_021E6E48:
    push {r3-r7, lr}
    mov r5, #0x64
    mov r6, r0
    mov r0, r5
    mov r4, #3
    bl Slots_ov77_021E7128
    mov r2, r0
    mov r0, r6
    add r0, #0xA0
    ldrb r7, [r0]
    ldr r3, [@@pool_1]
    mov r1, #0
    lsl r0, r7, #1
    add r0, r7, r0
    add r3, r3, r0
@@branch_1:
    ldrb r0, [r3]
    sub r0, r5, r0
    lsl r0, r0, #16
    lsr r5, r0, #16
    cmp r2, r5
    bcc @@branch_2
    mov r4, r1
    b @@branch_3
@@branch_2:
    add r1, r1, #1
    add r3, r3, #1
    cmp r1, #3
    blt @@branch_1
@@branch_3:
    mov r0, r7
    bl Slots_ov77_021E7188
    cmp r0, #0
    bne @@branch_4
    cmp r4, #0
    bne @@branch_5
@@branch_4:
    mov r0, r4
    pop {r3-r7, pc}
@@branch_5:
    ldr r0, [@@pool_2]
    ldr r1, [@@pool_3]
    mov r5, #0
    mov r3, r6
@@branch_6:
    mov r7, r6
    add r7, #0x38
    ldrb r7, [r7]
    mov r2, r3
    add r2, #0x46
    lsl r7, r7, #1
    add r7, r1, r7
    ldrb r7, [r5, r7]
    ldrh r2, [r2]
    mul r7, r4
    add r7, r2, r7
    mov r2, r3
    add r2, #0x46
    strh r7, [r2]
    mov r2, r3
    add r2, #0x46
    ldrh r7, [r2]
    ldr r2, [@@pool_2]
    cmp r7, r2
    bls @@branch_7
    mov r2, r3
    add r2, #0x46
    strh r0, [r2]
@@branch_7:
    add r5, r5, #1
    add r3, r3, #2
    cmp r5, #2
    blt @@branch_6
    mov r0, r4
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_ov77_021EA154
@@pool_2:
    .word 0x00000383
@@pool_3:
    .word Slots_ov77_021EA11C

Slots_ov77_021E6EE0:
    push {r3-r7, lr}
    mov r5, r0
    mov r6, #3
    add r0, #0x3A
    strb r6, [r0]
    mov r0, r5
    add r0, #0xA2
    ldrb r0, [r0]
    cmp r0, #2
    beq @@branch_1
    mov r0, #0x4D
    ldsb r0, [r5, r0]
    cmp r0, #0
    bgt @@branch_3
@@branch_1:
    ldr r0, [r5, #0x6C]
    lsl r0, r0, #31
    lsr r0, r0, #31
    bne @@branch_2
    mov r0, #0x4D
    ldsb r2, [r5, r0]
    cmp r2, #0
    bgt @@branch_2
    mov r0, r5
    add r0, #0x39
    ldrb r1, [r0]
    ldr r0, [@@pool_1]
    add r5, #0x4D
    ldrb r0, [r0, r1]
    add r0, r2, r0
    strb r0, [r5]
@@branch_2:
    mov r0, #0
    pop {r3-r7, pc}
@@branch_3:
    mov r4, #0x64
    mov r0, r4
    bl Slots_ov77_021E7128
    mov r2, r0
    mov r0, r5
    ldr r3, [r5, #0x6C]
    add r0, #0xA2
    lsl r3, r3, #27
    lsr r3, r3, #31
    ldrb r0, [r0]
    lsl r3, r3, #1
    ldr r7, [@@pool_2]
    add r3, r0, r3
    lsl r0, r3, #1
    add r0, r3, r0
    mov r1, #0
    add r0, r7, r0
@@branch_4:
    ldrb r3, [r0]
    sub r3, r4, r3
    lsl r3, r3, #16
    lsr r4, r3, #16
    cmp r2, r4
    bcc @@branch_5
    mov r6, r1
    b @@branch_6
@@branch_5:
    add r1, r1, #1
    add r0, r0, #1
    cmp r1, #3
    blt @@branch_4
@@branch_6:
    mov r1, r5
    add r1, #0x39
    ldrb r3, [r1]
    ldr r1, [@@pool_3]
    mov r2, #0x4D
    ldrb r1, [r1, r3]
    ldsb r0, [r5, r2]
    mov r3, r1
    mul r3, r6
    add r1, r0, r3
    mov r0, r5
    add r0, #0x4D
    strb r1, [r0]
    ldsb r0, [r5, r2]
    cmp r0, #0x63
    ble @@branch_7
    mov r0, r5
    mov r1, #0x63
    add r0, #0x4D
    strb r1, [r0]
@@branch_7:
    mov r0, #0x4D
    ldsb r0, [r5, r0]
    cmp r0, #0
    bgt @@branch_8
    mov r0, r6
    pop {r3-r7, pc}
@@branch_8:
    mov r0, #0x64
    bl Slots_ov77_021E7128
    mov r4, r0
    mov r0, #0x4D
    ldsb r1, [r5, r0]
    ldr r0, [r5, #0x6C]
    ldr r7, [@@pool_4]
    lsl r0, r0, #27
    lsr r2, r0, #31
    mov r0, #0xC
    mov r3, r2
    mul r3, r0
    mov r0, r5
    add r0, #0x38
    ldrb r2, [r0]
    add r3, r7, r3
    lsl r0, r2, #1
    add r0, r2, r0
    mov r2, r5
    add r2, #0x39
    ldrb r2, [r2]
    add r0, r0, r3
    ldrb r0, [r2, r0]
    mul r0, r1
    mov r1, #0xF
    blx Slots__s32_div_f
    lsl r0, r0, #16
    lsr r0, r0, #16
    cmp r4, r0
    bcc @@branch_9
    mov r0, r6
    pop {r3-r7, pc}
@@branch_9:
    mov r0, #0x64
    bl Slots_ov77_021E7128
    mov r3, r0
    mov r0, r5
    mov r1, #2
    add r0, #0x3A
    strb r1, [r0]
    mov r0, r5
    add r0, #0x39
    ldrb r1, [r0]
    mov r0, #0xC
    ldr r7, [@@pool_5]
    mul r0, r1
    add r7, r7, r0
    mov r0, r5
    add r0, #0x38
    ldrb r1, [r0]
    mov r2, #0x64
    mov r4, #0
    lsl r0, r1, #1
    add r0, r1, r0
    add r0, r7, r0
@@branch_10:
    ldrb r1, [r0]
    sub r1, r2, r1
    lsl r1, r1, #16
    lsr r2, r1, #16
    cmp r3, r2
    bcc @@branch_11
    mov r0, r5
    add r0, #0x3A
    strb r4, [r0]
    b @@branch_12
@@branch_11:
    add r4, r4, #1
    add r0, r0, #1
    cmp r4, #3
    blt @@branch_10
@@branch_12:
    mov r0, #0x4D
    ldsb r0, [r5, r0]
    ldr r3, [@@pool_6]
    neg r1, r0
    mov r0, r5
    add r0, #0x39
    ldrb r2, [r0]
    lsl r0, r2, #1
    add r4, r2, r0
    mov r0, r5
    add r0, #0x3A
    ldrb r2, [r0]
    add r0, r3, r4
    ldrb r0, [r2, r0]
    mul r0, r1
    mov r1, #0xA
    blx Slots__s32_div_f
    mov r1, r5
    add r1, #0x4D
    strb r0, [r1]
    mov r0, r5
    mov r1, #0
    add r0, #0x4C
    strb r1, [r0]
    ldr r1, [r5, #0x6C]
    mov r0, #0x40
    bic r1, r0
    str r1, [r5, #0x6C]
    mov r0, r6
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_ov77_021EA114
@@pool_2:
    .word Slots_ov77_021EA130
@@pool_3:
    .word Slots_ov77_021EA108
@@pool_4:
    .word Slots_ov77_021EA16C
@@pool_5:
    .word Slots_ov77_021EA184
@@pool_6:
    .word Slots_ov77_021EA124

Slots_ov77_021E7074:
    push {r4-r5, lr}
    sub sp, #0x14
    mov r4, r0
    add r0, sp, #0
    mov r1, #0
    mov r2, #0x14
    blx Slots_MI_CpuFill8
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r1, [r4, r0]
    mov r2, #0x19
    str r1, [sp]
    mov r1, #4
    str r1, [sp, #4]
    mov r1, #0x1F
    str r1, [sp, #8]
    mov r1, #0xE
    str r1, [sp, #0xC]
    add r1, sp, #0
    strb r2, [r1, #0x10]
    mov r2, #6
    strb r2, [r1, #0x11]
    ldrb r2, [r1, #0x12]
    mov r3, #0xF
    add r0, #8
    bic r2, r3
    ldr r3, [r4, #0x20]
    lsl r3, r3, #24
    lsr r5, r3, #24
    mov r3, #0xF
    and r3, r5
    orr r2, r3
    strb r2, [r1, #0x12]
    ldrb r3, [r1, #0x12]
    mov r2, #0xF0
    bic r3, r2
    mov r2, #0x10
    orr r2, r3
    strb r2, [r1, #0x12]
    mov r2, #0
    strb r2, [r1, #0x13]
    ldr r0, [r4, r0]
    add r1, sp, #0
    bl Slots_YesNoPrompt_InitFromTemplate
    add sp, #0x14
    pop {r4-r5, pc}

Slots_ov77_021E70D4:
    push {r3-r5, lr}
    mov r5, r0
    mov r0, #0x63
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    bl Slots_YesNoPrompt_HandleInput
    cmp r0, #1
    beq @@branch_1
    cmp r0, #2
    beq @@branch_2
    b @@branch_3
@@branch_1:
    mov r4, #2
    b @@branch_4
@@branch_2:
    mov r4, #1
    b @@branch_4
@@branch_3:
    mov r0, #0
    pop {r3-r5, pc}
@@branch_4:
    mov r0, #0x63
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    bl Slots_YesNoPrompt_IsInTouchMode
    str r0, [r5, #0x20]
    mov r0, #0x63
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    bl Slots_YesNoPrompt_Reset
    mov r0, r4
    pop {r3-r5, pc}
    .align 4

Slots_ov77_021E7114:
    push {r3, lr}
    bl Slots_LCRandom
    mov r1, #0xFA
    lsl r1, r1, #2
    blx Slots__s32_div_f
    lsl r0, r1, #16
    lsr r0, r0, #16
    pop {r3, pc}

Slots_ov77_021E7128:
    push {r4, lr}
    mov r4, r0
    cmp r4, #2
    bne @@branch_1
    bl Slots_LCRandom
    mov r1, #0xFA
    lsl r1, r1, #2
    blx Slots__s32_div_f
    mov r0, r1
    mov r1, #0x7D
    lsl r1, r1, #2
    blx Slots__s32_div_f
    lsl r0, r0, #16
    lsr r0, r0, #16
    pop {r4, pc}
@@branch_1:
    bl Slots_LCRandom
    mov r1, r4
    blx Slots__s32_div_f
    lsl r0, r1, #16
    lsr r0, r0, #16
    pop {r4, pc}

Slots_ov77_021E715C:
    push {r4, lr}
    mov r4, r0
    ldr r0, [@@pool_1]
    ldr r1, [r0, #0x48]
    mov r0, #1
    tst r1, r0
    beq @@branch_1
    mov r1, #0
    str r1, [r4, #0x20]
    pop {r4, pc}
@@branch_1:
    bl Slots_System_GetTouchNew
    cmp r0, #0
    beq @@branch_2
    mov r0, #1
    str r0, [r4, #0x20]
    pop {r4, pc}
@@branch_2:
    mov r0, #0
    pop {r4, pc}
    nop
@@pool_1:
    .word 0x021D110C

Slots_ov77_021E7188:
    sub r0, r0, #5
    cmp r0, #1
    bhi @@branch_1
    mov r0, #1
    bx lr
@@branch_1:
    mov r0, #0
    bx lr
    .align 4

Slots_ov77_021E7198:
    push {r3-r5, lr}
    mov r4, r0
    ldr r0, [r4, #0x6C]
    mov r5, r1
    lsl r0, r0, #31
    lsr r0, r0, #31
    beq @@branch_1
    mov r1, r4
    add r1, #0x40
    ldrb r1, [r1]
    ldr r0, [@@pool_1]
    add r4, #0x4C
    lsr r2, r1, #1
    ldrb r1, [r4]
    ldrb r0, [r0, r5]
    lsr r1, r1, #2
    add r1, r1, #1
    mul r1, r2
    add r0, r0, r1
    pop {r3-r5, pc}
@@branch_1:
    mov r0, r5
    bl Slots_ov77_021E7188
    cmp r0, #0
    beq @@branch_2
    ldr r0, [@@pool_2]
    ldrb r1, [r0, r5]
    sub r0, r5, #5
    lsl r0, r0, #1
    add r0, r4, r0
    add r0, #0x46
    ldrh r0, [r0]
    add r0, r1, r0
    pop {r3-r5, pc}
@@branch_2:
    ldr r0, [@@pool_2]
    ldrb r0, [r0, r5]
    pop {r3-r5, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA084
@@pool_2:
    .word Slots_ov77_021EA098

Slots_ov77_021E71EC:
    push {r4, lr}
    mov r4, r0
    cmp r1, #0
    ldr r2, [r4, #0x6C]
    bne @@branch_1
    mov r0, #0x20
    bic r2, r0
    str r2, [r4, #0x6C]
    b @@branch_2
@@branch_1:
    mov r0, #0x20
    orr r0, r2
    str r0, [r4, #0x6C]
@@branch_2:
    mov r0, #0x7B
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    bl Slots_Sprite_SetAnimCtrlSeq
    mov r0, #0x7B
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    bl Slots_Sprite_ResetAnimCtrlState
    pop {r4, pc}
    .align 4

Slots_ov77_021E721C:
    push {r3-r5, lr}
    sub sp, #0x10
    mov r5, r0
    mov r0, #0x19
    mov r4, r1
    lsl r0, r0, #4
    mov r1, #1
    add r0, r5, r0
    mov r2, r1
    mov r3, #0xC
    bl Slots_DrawFrameAndWindow2
    mov r0, #0x19
    lsl r0, r0, #4
    add r0, r5, r0
    mov r1, #0xF
    bl Slots_FillWindowPixelBuffer
    mov r2, #0x5D
    lsl r2, r2, #2
    ldr r0, [r5, r2]
    add r2, #0xC
    ldr r2, [r5, r2]
    mov r1, r4
    bl Slots_ReadMsgDataIntoString
    mov r3, #0
    str r3, [sp]
    mov r2, #0xFF
    ldr r0, [@@pool_1]
    str r2, [sp, #4]
    str r0, [sp, #8]
    mov r0, r2
    add r0, #0x91
    str r3, [sp, #0xC]
    add r2, #0x81
    ldr r2, [r5, r2]
    add r0, r5, r0
    mov r1, #1
    bl Slots_AddTextPrinterParameterizedWithColor
    mov r0, #0x19
    lsl r0, r0, #4
    add r0, r5, r0
    bl Slots_ScheduleWindowCopyToVram
    add sp, #0x10
    pop {r3-r5, pc}
@@pool_1:
    .word 0x0001020F

Slots_ov77_021E7280:
    push {r4, lr}
    mov r4, r0
    mov r0, #0x19
    lsl r0, r0, #4
    add r0, r4, r0
    mov r1, #1
    bl Slots_ClearFrameAndWindow2
    mov r0, #0x19
    lsl r0, r0, #4
    add r0, r4, r0
    mov r1, #0
    bl Slots_FillWindowPixelBuffer
    mov r0, #0x19
    lsl r0, r0, #4
    add r0, r4, r0
    bl Slots_ClearWindowTilemapAndScheduleTransfer
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #4
    bl Slots_ScheduleBgTilemapBufferTransfer
    pop {r4, pc}

Slots_ov77_021E72B4:
    push {r3-r5, lr}
    sub sp, #0x10
    mov r5, r0
    mov r0, #0x1A
    lsl r0, r0, #4
    mov r4, r1
    add r0, r5, r0
    mov r1, #5
    bl Slots_FillWindowPixelBuffer
    mov r2, #0x5D
    lsl r2, r2, #2
    ldr r0, [r5, r2]
    add r2, #0xC
    ldr r2, [r5, r2]
    add r1, r4, #7
    bl Slots_ReadMsgDataIntoString
    mov r1, #0
    str r1, [sp]
    mov r2, #0xFF
    ldr r0, [@@pool_1]
    str r2, [sp, #4]
    str r0, [sp, #8]
    mov r0, r2
    add r0, #0xA1
    str r1, [sp, #0xC]
    add r2, #0x81
    ldr r2, [r5, r2]
    add r0, r5, r0
    mov r3, r1
    bl Slots_AddTextPrinterParameterizedWithColor
    mov r0, #0x1A
    lsl r0, r0, #4
    add r0, r5, r0
    bl Slots_ScheduleWindowCopyToVram
    add sp, #0x10
    pop {r3-r5, pc}
@@pool_1:
    .word 0x00030405

Slots_ov77_021E7308:
    push {r4, lr}
    mov r4, r0
    mov r0, #0x1F
    lsl r0, r0, #4
    ldr r0, [r4, r0]
    add r1, r1, #1
    bl Slots_Sprite_SetAnimCtrlSeq
    mov r0, #0x1F
    lsl r0, r0, #4
    ldr r0, [r4, r0]
    bl Slots_Sprite_ResetAnimCtrlState
    pop {r4, pc}

Slots_ov77_021E7324:
    push {r4-r7, lr}
    sub sp, #0x24
    ldr r3, [@@pool_1]
    str r1, [sp, #0x1C]
    ldrb r4, [r3]
    ldrb r3, [r3, #1]
    add r1, sp, #0x20
    strb r4, [r1]
    mov r5, r0
    add r0, sp, #0x20
    strb r3, [r1, #1]
    ldrb r7, [r0, r2]
    mov r6, #0
    mov r4, #4
@@branch_1:
    lsl r1, r4, #24
    ldr r0, [sp, #0x1C]
    lsr r1, r1, #24
    bl Slots_ov77_021E8C24
    cmp r0, #0
    beq @@branch_2
    mov r6, #1
@@branch_2:
    cmp r6, #0
    beq @@branch_3
    add r0, r0, #2
    b @@branch_5
@@branch_3:
    cmp r0, #0
    bne @@branch_4
    cmp r4, #0
    bne @@branch_4
    mov r0, #2
    b @@branch_5
@@branch_4:
    mov r0, #0
@@branch_5:
    mov r1, #1
    str r1, [sp]
    mov r1, #2
    str r1, [sp, #4]
    mov r1, #0xA3
    lsl r1, r1, #2
    ldr r1, [r5, r1]
    lsl r0, r0, #24
    str r1, [sp, #8]
    lsr r0, r0, #24
    str r0, [sp, #0xC]
    mov r0, #0
    str r0, [sp, #0x10]
    mov r0, #0x29
    lsl r0, r0, #4
    ldrb r0, [r5, r0]
    sub r2, r7, r4
    lsl r2, r2, #24
    str r0, [sp, #0x14]
    ldr r0, [@@pool_2]
    mov r1, #5
    ldrb r0, [r5, r0]
    lsr r2, r2, #24
    mov r3, #0x12
    str r0, [sp, #0x18]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    bl Slots_CopyToBgTilemapRect
    sub r4, r4, #1
    bpl @@branch_1
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    mov r1, #5
    bl Slots_ScheduleBgTilemapBufferTransfer
    add sp, #0x24
    pop {r4-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA01C
@@pool_2:
    .word 0x00000291

Slots_ov77_021E73C0:
    push {r4-r5, lr}
    sub sp, #0x1C
    mov r5, r0
    mov r4, r1
    bne @@branch_1
    mov r0, #6
    b @@branch_2
@@branch_1:
    mov r0, #0xA
@@branch_2:
    mov r1, #0x1D
    mov r2, #0xA7
    str r1, [sp]
    mov r1, #4
    lsl r2, r2, #2
    str r1, [sp, #4]
    ldr r1, [r5, r2]
    mov r3, #0x13
    str r1, [sp, #8]
    mov r1, #0
    str r1, [sp, #0xC]
    str r0, [sp, #0x10]
    add r0, r2, #4
    ldrb r0, [r5, r0]
    str r0, [sp, #0x14]
    add r0, r2, #5
    ldrb r0, [r5, r0]
    mov r2, #1
    str r0, [sp, #0x18]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    bl Slots_CopyToBgTilemapRect
    mov r0, r5
    mov r1, r4
    mov r2, #3
    bl Slots_ov77_021E741C
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    mov r1, #0
    bl Slots_ScheduleBgTilemapBufferTransfer
    add sp, #0x1C
    pop {r4-r5, pc}
    .align 4

Slots_ov77_021E741C:
    push {r3-r4, lr}
    sub sp, #4
    mov r4, r0
    cmp r1, #0
    bne @@branch_1
    mov r1, #0x13
    str r1, [sp]
    mov r1, r4
    add r1, #0x48
    ldrh r1, [r1]
    mov r2, #3
    mov r3, #7
    add r1, #0x64
    bl Slots_ov77_021E7604
    mov r0, #0x15
    mov r1, r4
    str r0, [sp]
    add r1, #0x46
    ldrh r1, [r1]
    mov r0, r4
    mov r2, #3
    add r1, #0x64
    mov r3, #7
    bl Slots_ov77_021E7604
    b @@branch_2
@@branch_1:
    mov r1, r2
    bl Slots_ov77_021E751C
    mov r0, #0x13
    mov r1, r4
    str r0, [sp]
    add r1, #0x3E
    ldrb r1, [r1]
    mov r0, r4
    mov r2, #2
    add r1, r1, #1
    mov r3, #9
    bl Slots_ov77_021E7604
    mov r0, #0x13
    mov r1, r4
    str r0, [sp]
    add r1, #0x3F
    ldrb r1, [r1]
    mov r0, r4
    mov r2, #2
    mov r3, #0xC
    bl Slots_ov77_021E7604
    mov r0, #0x15
    mov r1, r4
    str r0, [sp]
    add r1, #0x4A
    ldrh r1, [r1]
    mov r0, r4
    mov r2, #3
    mov r3, #7
    bl Slots_ov77_021E7604
@@branch_2:
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #0
    bl Slots_ScheduleBgTilemapBufferTransfer
    add sp, #4
    pop {r3-r4, pc}
    .align 4

Slots_ov77_021E74A8:
    push {r3-r6, lr}
    sub sp, #0x1C
    mov r5, r0
    ldr r0, [@@pool_1]
    sub r1, r1, #1
    ldrb r6, [r0, r1]
    mov r1, #3
    mov r0, r6
    blx Slots__s32_div_f
    mov r4, r1
    mov r0, r6
    mov r1, #3
    blx Slots__s32_div_f
    mov r3, r0
    mov r0, #9
    str r0, [sp]
    mov r0, #2
    str r0, [sp, #4]
    mov r0, #0xA7
    lsl r0, r0, #2
    ldr r1, [r5, r0]
    lsl r3, r3, #1
    str r1, [sp, #8]
    mov r2, #0x15
    add r3, #0x13
    lsl r3, r3, #16
    asr r3, r3, #16
    lsl r3, r3, #24
    str r2, [sp, #0xC]
    mov r1, #0xE
    str r1, [sp, #0x10]
    lsl r1, r2, #5
    ldrb r1, [r5, r1]
    mov r2, #0xA
    mul r2, r4
    str r1, [sp, #0x14]
    add r0, r0, #5
    ldrb r0, [r5, r0]
    add r2, r2, #1
    lsl r2, r2, #16
    str r0, [sp, #0x18]
    mov r0, #0x61
    lsl r0, r0, #2
    asr r2, r2, #16
    lsl r2, r2, #24
    ldr r0, [r5, r0]
    mov r1, #0
    lsr r2, r2, #24
    lsr r3, r3, #24
    bl Slots_CopyToBgTilemapRect
    add sp, #0x1C
    pop {r3-r6, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA090

Slots_ov77_021E751C:
    push {r4-r5, lr}
    sub sp, #0x1C
    mov r5, r0
    mov r0, #4
    str r0, [sp]
    str r0, [sp, #4]
    mov r0, #0xA7
    lsl r0, r0, #2
    mov r4, r1
    ldr r1, [r5, r0]
    mov r2, #0x12
    str r1, [sp, #8]
    lsl r1, r4, #26
    lsr r1, r1, #24
    str r1, [sp, #0xC]
    mov r1, #0xE
    str r1, [sp, #0x10]
    add r1, r0, #4
    ldrb r1, [r5, r1]
    add r0, r0, #5
    mov r3, #0x13
    str r1, [sp, #0x14]
    ldrb r0, [r5, r0]
    mov r1, #0
    str r0, [sp, #0x18]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    bl Slots_CopyToBgTilemapRect
    cmp r4, #3
    bne @@branch_1
    mov r0, r5
    mov r1, #0
    bl Slots_ov77_021E7578
    add sp, #0x1C
    pop {r4-r5, pc}
@@branch_1:
    mov r0, r5
    add r5, #0x42
    ldrb r1, [r5]
    bl Slots_ov77_021E7578
    add sp, #0x1C
    pop {r4-r5, pc}
    .align 4

Slots_ov77_021E7578:
    push {r3-r7, lr}
    sub sp, #0x20
    mov r4, #0
    mov r5, r0
    mov r7, r1
    str r4, [sp, #0x1C]
    mov r6, #0x17
@@branch_1:
    mov r1, #1
    sub r1, r1, r4
    lsl r1, r1, #24
    mov r0, r7
    lsr r1, r1, #24
    bl Slots_ov77_021E8C24
    cmp r0, #0
    beq @@branch_2
    mov r1, #1
    str r1, [sp, #0x1C]
@@branch_2:
    ldr r1, [sp, #0x1C]
    cmp r1, #0
    beq @@branch_3
    add r0, r0, #1
    b @@branch_5
@@branch_3:
    cmp r0, #0
    bne @@branch_4
    cmp r4, #1
    bne @@branch_4
    cmp r7, #0
    beq @@branch_4
    mov r0, #1
    b @@branch_5
@@branch_4:
    mov r0, #0
@@branch_5:
    mov r1, #2
    str r1, [sp]
    mov r1, #4
    str r1, [sp, #4]
    mov r1, #0xA7
    lsl r1, r1, #2
    ldr r1, [r5, r1]
    lsl r0, r0, #25
    str r1, [sp, #8]
    lsr r0, r0, #24
    str r0, [sp, #0xC]
    mov r0, #2
    str r0, [sp, #0x10]
    mov r0, #0x2A
    lsl r0, r0, #4
    ldrb r0, [r5, r0]
    lsl r2, r6, #24
    mov r1, #0
    str r0, [sp, #0x14]
    ldr r0, [@@pool_1]
    lsr r2, r2, #24
    ldrb r0, [r5, r0]
    mov r3, #0x13
    str r0, [sp, #0x18]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    bl Slots_CopyToBgTilemapRect
    add r4, r4, #1
    add r6, r6, #2
    cmp r4, #2
    blt @@branch_1
    add sp, #0x20
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word 0x000002A1

Slots_ov77_021E7604:
    push {r4-r7, lr}
    sub sp, #0x24
    mov r5, r0
    ldr r0, [sp, #0x38]
    mov r7, r2
    str r1, [sp, #0x1C]
    mov r6, r3
    mov r4, #0
    str r0, [sp, #0x38]
    cmp r7, #0
    ble @@branch_2
    sub r0, r7, #1
    str r0, [sp, #0x20]
@@branch_1:
    ldr r1, [sp, #0x20]
    ldr r0, [sp, #0x1C]
    sub r1, r1, r4
    lsl r1, r1, #24
    lsr r1, r1, #24
    bl Slots_ov77_021E8C24
    mov r1, #1
    str r1, [sp]
    mov r1, #2
    str r1, [sp, #4]
    mov r1, #0xA7
    lsl r1, r1, #2
    ldr r1, [r5, r1]
    add r0, r0, #1
    lsl r0, r0, #24
    str r1, [sp, #8]
    lsr r0, r0, #24
    str r0, [sp, #0xC]
    mov r0, #0
    str r0, [sp, #0x10]
    mov r0, #0x2A
    lsl r0, r0, #4
    ldrb r0, [r5, r0]
    lsl r2, r6, #24
    mov r1, #0
    str r0, [sp, #0x14]
    ldr r0, [@@pool_1]
    lsr r2, r2, #24
    ldrb r0, [r5, r0]
    str r0, [sp, #0x18]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    ldr r3, [sp, #0x38]
    bl Slots_CopyToBgTilemapRect
    add r4, r4, #1
    add r6, r6, #1
    cmp r4, r7
    blt @@branch_1
@@branch_2:
    add sp, #0x24
    pop {r4-r7, pc}
@@pool_1:
    .word 0x000002A1

Slots_ov77_021E7678:
    push {r3-r7, lr}
    mov r6, r0
    str r3, [sp]
    mov r7, r1
    ldr r0, [r6]
    mov r1, #0x14
    mov r5, r2
    bl Slots_Heap_Alloc
    mov r4, r0
    mov r1, #0
    mov r2, #0x14
    blx Slots_MI_CpuFill8
    str r7, [r4, #8]
    str r6, [r4, #0x10]
    str r5, [r4]
    cmp r5, #0
    beq @@branch_1
    ldr r0, [r5]
    add r0, r0, #1
    str r0, [r5]
@@branch_1:
    ldr r0, [@@pool_1]
    ldr r2, [sp]
    mov r1, r4
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_ov77_021E76B4+1

Slots_ov77_021E76B4:
    push {r4-r6, lr}
    sub sp, #8
    mov r5, r1
    mov r6, r0
    ldr r0, [r5, #4]
    ldr r4, [r5, #0x10]
    cmp r0, #0
    beq @@branch_1
    cmp r0, #1
    beq @@branch_2
    b @@branch_3
@@branch_1:
    ldr r0, [r5, #0xC]
    mov r1, #0
    lsl r0, r0, #24
    lsr r0, r0, #24
    str r0, [sp]
    ldr r0, [@@pool_1]
    mov r2, #0x62
    str r0, [sp, #4]
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r4, r0]
    mov r3, #0xE
    bl Slots_PaletteData_BlendPalette
    ldr r1, [r5, #0xC]
    add r0, r1, #1
    str r0, [r5, #0xC]
    cmp r1, #0x10
    blt @@branch_5
    ldr r1, [r5, #8]
    mov r0, r4
    bl Slots_ov77_021E73C0
    ldr r0, [r5, #4]
    add sp, #8
    add r0, r0, #1
    str r0, [r5, #4]
    pop {r4-r6, pc}
@@branch_2:
    ldr r0, [r5, #0xC]
    mov r1, #0
    lsl r0, r0, #24
    lsr r0, r0, #24
    str r0, [sp]
    ldr r0, [@@pool_1]
    mov r2, #0x62
    str r0, [sp, #4]
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r4, r0]
    mov r3, #0xE
    bl Slots_PaletteData_BlendPalette
    ldr r1, [r5, #0xC]
    sub r0, r1, #1
    str r0, [r5, #0xC]
    cmp r1, #0
    bgt @@branch_5
@@branch_3:
    ldr r1, [r5]
    cmp r1, #0
    beq @@branch_4
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1]
@@branch_4:
    mov r0, r5
    bl Slots_Heap_Free
    mov r0, r6
    bl Slots_SysTask_Destroy
@@branch_5:
    add sp, #8
    pop {r4-r6, pc}
@@pool_1:
    .word 0x000014A5

Slots_ov77_021E7748:
    push {r3-r7, lr}
    mov r6, r0
    ldr r0, [r6]
    mov r5, r1
    mov r1, #0x14
    mov r7, r2
    bl Slots_Heap_Alloc
    mov r4, r0
    mov r1, #0
    mov r2, #0x14
    blx Slots_MI_CpuFill8
    str r6, [r4, #0x10]
    str r5, [r4]
    cmp r5, #0
    beq @@branch_1
    ldr r0, [r5]
    add r0, r0, #1
    str r0, [r5]
@@branch_1:
    ldr r0, [@@pool_1]
    mov r1, r4
    mov r2, r7
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_ov77_021E7780+1

Slots_ov77_021E7780:
    push {r4-r6, lr}
    sub sp, #8
    mov r5, r1
    mov r6, r0
    ldr r0, [r5, #4]
    ldr r4, [r5, #0x10]
    cmp r0, #0
    beq @@branch_1
    cmp r0, #1
    beq @@branch_2
    b @@branch_3
@@branch_1:
    ldr r0, [r5, #0xC]
    mov r1, #3
    lsl r0, r0, #24
    lsr r0, r0, #24
    str r0, [sp]
    ldr r0, [@@pool_1]
    mov r2, #0x10
    str r0, [sp, #4]
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r4, r0]
    mov r3, #0x60
    bl Slots_PaletteData_BlendPalette
    ldr r0, [r5, #0xC]
    add r0, r0, #1
    str r0, [r5, #0xC]
    cmp r0, #0x10
    blt @@branch_5
    mov r0, r4
    bl Slots_ov77_021E8C64
    mov r0, r4
    bl Slots_ov77_021E8CB8
    ldr r0, [r5, #4]
    add sp, #8
    add r0, r0, #1
    str r0, [r5, #4]
    pop {r4-r6, pc}
@@branch_2:
    ldr r0, [r5, #0xC]
    mov r1, #3
    lsl r0, r0, #24
    lsr r0, r0, #24
    str r0, [sp]
    ldr r0, [@@pool_1]
    mov r2, #0x10
    str r0, [sp, #4]
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r4, r0]
    mov r3, #0x60
    bl Slots_PaletteData_BlendPalette
    ldr r0, [r5, #0xC]
    sub r0, r0, #1
    str r0, [r5, #0xC]
    cmp r0, #0
    bgt @@branch_5
@@branch_3:
    ldr r1, [r5]
    cmp r1, #0
    beq @@branch_4
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1]
@@branch_4:
    mov r0, r5
    bl Slots_Heap_Free
    mov r0, r6
    bl Slots_SysTask_Destroy
@@branch_5:
    add sp, #8
    pop {r4-r6, pc}
@@pool_1:
    .word 0x00007FFF

Slots_ov77_021E7818:
    push {r3-r4, lr}
    sub sp, #4
    mov r4, r0
    mov r0, #4
    mov r3, r1
    str r0, [sp]
    mov r0, #0x1E
    mov r1, #0xBB
    lsl r0, r0, #4
    lsl r1, r1, #2
    add r2, #0xA
    ldr r0, [r4, r0]
    ldr r1, [r4, r1]
    ldr r4, [@@pool_1]
    lsl r2, r2, #4
    ldrb r4, [r4, r3]
    add r3, r3, #1
    lsl r3, r3, #4
    lsl r4, r4, #1
    add r2, r4, r2
    add r2, r2, #1
    lsl r2, r2, #16
    add r3, #0xB
    lsr r2, r2, #15
    lsl r3, r3, #16
    add r1, r1, r2
    mov r2, #1
    lsr r3, r3, #16
    bl Slots_PaletteData_LoadPalette
    add sp, #4
    pop {r3-r4, pc}
@@pool_1:
    .word Slots_ov77_021EA088

Slots_ov77_021E785C:
    ldr r3, [@@pool_1]
    lsl r2, r2, #16
    lsr r2, r2, #16
    bx r3
@@pool_1:
    .word Slots_ov77_021E7818+1

Slots_ov77_021E7868:
    push {r4-r6, lr}
    mov r5, r0
    mov r6, r1
    mov r4, #0
@@branch_1:
    mov r0, r5
    mov r1, r4
    mov r2, r6
    bl Slots_ov77_021E785C
    add r4, r4, #1
    cmp r4, #5
    blt @@branch_1
    pop {r4-r6, pc}
    .align 4

Slots_ov77_021E7884:
    push {r3-r4, lr}
    sub sp, #4
    mov r4, r0
    mov r0, #4
    mov r3, r1
    str r0, [sp]
    mov r0, #0x1E
    mov r1, #0xBB
    lsl r0, r0, #4
    lsl r1, r1, #2
    add r2, #0xA
    ldr r0, [r4, r0]
    ldr r1, [r4, r1]
    mov r4, #2
    sub r4, r4, r3
    add r3, r3, #6
    lsl r3, r3, #4
    add r3, #0xB
    lsl r3, r3, #16
    lsl r4, r4, #1
    lsl r2, r2, #4
    add r2, r4, r2
    add r2, r2, #1
    lsl r2, r2, #16
    lsr r2, r2, #15
    add r1, r1, r2
    mov r2, #1
    lsr r3, r3, #16
    bl Slots_PaletteData_LoadPalette
    add sp, #4
    pop {r3-r4, pc}

Slots_ov77_021E78C4:
    push {r4-r6, lr}
    mov r6, r0
    cmp r1, #1
    bne @@branch_1
    mov r0, #1
    b @@branch_2
@@branch_1:
    mov r0, #0
@@branch_2:
    lsl r0, r0, #16
    lsr r5, r0, #16
    mov r4, #0
@@branch_3:
    mov r0, r6
    mov r1, r4
    mov r2, r5
    bl Slots_ov77_021E7884
    add r4, r4, #1
    cmp r4, #3
    blt @@branch_3
    pop {r4-r6, pc}
    .align 4

Slots_ov77_021E78EC:
    ldr r3, [@@pool_1]
    lsl r2, r2, #16
    lsr r2, r2, #16
    bx r3
@@pool_1:
    .word Slots_ov77_021E7884+1

Slots_ov77_021E78F8:
    add r1, r0, r1
    mov r0, #0x46
    mov r2, #1
    lsl r0, r0, #2
    strb r2, [r1, r0]
    bx lr

Slots_ov77_021E7904:
    push {r3-r7, lr}
    mov r5, r0
    ldr r0, [r5]
    mov r6, r1
    mov r1, #0xC
    mov r7, r2
    bl Slots_Heap_Alloc
    mov r1, #0
    mov r2, #0xC
    mov r4, r0
    blx Slots_MI_CpuFill8
    mov r0, #1
    strh r0, [r4, #4]
    str r5, [r4, #8]
    mov r0, #0x46
    strb r6, [r4]
    mov r2, #0
    add r1, r5, r6
    lsl r0, r0, #2
    strb r2, [r1, r0]
    ldr r0, [@@pool_1]
    mov r1, r4
    mov r2, r7
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_ov77_021E7940+1

Slots_ov77_021E7940:
    push {r4-r6, lr}
    mov r5, r1
    ldrb r1, [r5]
    ldr r4, [r5, #8]
    mov r6, r0
    mov r0, #0x46
    add r2, r4, r1
    lsl r0, r0, #2
    ldrb r0, [r2, r0]
    cmp r0, #0
    beq @@branch_1
    mov r0, r4
    mov r2, #0
    bl Slots_ov77_021E7884
    ldrb r0, [r5]
    mov r2, #0
    add r1, r4, r0
    mov r0, #0x46
    lsl r0, r0, #2
    strb r2, [r1, r0]
    mov r0, r5
    bl Slots_Heap_Free
    mov r0, r6
    bl Slots_SysTask_Destroy
    pop {r4-r6, pc}
@@branch_1:
    ldrb r1, [r5, #3]
    add r0, r1, #1
    strb r0, [r5, #3]
    cmp r1, #8
    bcc @@branch_2
    ldrh r1, [r5, #4]
    mov r0, #1
    eor r0, r1
    strh r0, [r5, #4]
    mov r0, #0
    strb r0, [r5, #3]
    ldrb r1, [r5]
    ldrh r2, [r5, #4]
    mov r0, r4
    bl Slots_ov77_021E7884
@@branch_2:
    pop {r4-r6, pc}
    .align 4

Slots_ov77_021E799C:
    push {r3-r7, lr}
    mov r6, r0
    str r3, [sp]
    mov r7, r1
    ldr r0, [r6]
    mov r1, #0xC
    mov r5, r2
    bl Slots_Heap_Alloc
    mov r4, r0
    mov r1, #0
    mov r2, #0xC
    blx Slots_MI_CpuFill8
    str r6, [r4, #8]
    strb r7, [r4, #4]
    ldrb r1, [r4, #4]
    mov r0, r6
    mov r2, #0
    bl Slots_ov77_021E7818
    str r5, [r4]
    cmp r5, #0
    beq @@branch_1
    ldr r0, [r5]
    add r0, r0, #1
    str r0, [r5]
@@branch_1:
    ldr r0, [@@pool_1]
    ldr r2, [sp]
    mov r1, r4
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021E79E4+1

Slots_ov77_021E79E4:
    push {r3-r5, lr}
    mov r4, r1
    ldrb r2, [r4, #6]
    mov r5, r0
    ldr r0, [r4, #8]
    add r1, r2, #1
    strb r1, [r4, #6]
    cmp r2, #8
    bcc @@branch_2
    mov r1, #0
    strb r1, [r4, #6]
    ldrb r2, [r4, #5]
    mov r1, #1
    eor r1, r2
    strb r1, [r4, #5]
    ldrb r1, [r4, #4]
    ldrb r2, [r4, #5]
    bl Slots_ov77_021E7818
    ldrb r1, [r4, #7]
    add r0, r1, #1
    strb r0, [r4, #7]
    cmp r1, #6
    bcc @@branch_2
    ldr r1, [r4]
    cmp r1, #0
    beq @@branch_1
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1]
@@branch_1:
    mov r0, r4
    bl Slots_Heap_Free
    mov r0, r5
    bl Slots_SysTask_Destroy
@@branch_2:
    pop {r3-r5, pc}
    .align 4

Slots_ov77_021E7A30:
    push {r3-r7, lr}
    mov r6, r0
    str r2, [sp]
    mov r7, r1
    ldr r0, [r6]
    mov r1, #0x10
    mov r5, r3
    bl Slots_Heap_Alloc
    mov r4, r0
    mov r1, #0
    mov r2, #0x10
    blx Slots_MI_CpuFill8
    str r6, [r4, #0xC]
    ldr r0, [sp]
    strb r0, [r4, #5]
    mov r0, #8
    strb r7, [r4, #4]
    strb r0, [r4, #8]
    str r5, [r4]
    cmp r5, #0
    beq @@branch_1
    ldr r0, [r5]
    add r0, r0, #1
    str r0, [r5]
@@branch_1:
    add r2, sp, #8
    ldrb r2, [r2, #0x10]
    ldr r0, [@@pool_1]
    mov r1, r4
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021E7A78+1

Slots_ov77_021E7A78:
    push {r4-r6, lr}
    mov r5, r1
    ldrb r1, [r5, #8]
    mov r6, r0
    ldr r4, [r5, #0xC]
    add r0, r1, #1
    strb r0, [r5, #8]
    cmp r1, #8
    bcc @@branch_6
    ldrb r1, [r5, #4]
    ldrb r0, [r5, #7]
    cmp r1, #1
    bne @@branch_2
    cmp r0, #0
    beq @@branch_1
    ldrb r1, [r5, #5]
    mov r0, r4
    bl Slots_ov77_021E751C
    b @@branch_4
@@branch_1:
    mov r0, r4
    mov r1, #3
    bl Slots_ov77_021E751C
    b @@branch_4
@@branch_2:
    cmp r0, #0
    beq @@branch_3
    mov r0, r4
    bl Slots_ov77_021E73C0
    ldrb r1, [r5, #4]
    mov r0, r4
    mov r2, #3
    bl Slots_ov77_021E741C
    b @@branch_4
@@branch_3:
    ldrb r1, [r5, #5]
    mov r0, r4
    bl Slots_ov77_021E74A8
@@branch_4:
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #0
    bl Slots_ScheduleBgTilemapBufferTransfer
    mov r0, #0
    strb r0, [r5, #8]
    ldrb r1, [r5, #7]
    mov r0, #1
    eor r0, r1
    strb r0, [r5, #7]
    ldrb r1, [r5, #9]
    add r0, r1, #1
    strb r0, [r5, #9]
    cmp r1, #7
    bcc @@branch_6
    ldr r1, [r5]
    cmp r1, #0
    beq @@branch_5
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1]
@@branch_5:
    mov r0, r5
    bl Slots_Heap_Free
    mov r0, r6
    bl Slots_SysTask_Destroy
@@branch_6:
    pop {r4-r6, pc}

Slots_ov77_021E7B04:
    push {r3-r7, lr}
    mov r5, r0
    str r3, [sp]
    mov r6, r1
    ldr r0, [r5]
    mov r1, #0x14
    mov r7, r2
    bl Slots_Heap_Alloc
    mov r1, #0
    mov r2, #0x14
    mov r4, r0
    blx Slots_MI_CpuFill8
    ldr r0, [r5, #0x28]
    mov r2, #0
    str r0, [r4, #8]
    str r6, [r4, #4]
    str r5, [r4, #0x10]
    str r7, [r4]
    ldr r1, [r4, #8]
    mov r0, r5
    bl Slots_ov77_021E7324
    ldr r1, [r4, #4]
    mov r0, r5
    mov r2, #1
    bl Slots_ov77_021E7324
    ldr r2, [r5, #0x28]
    ldr r0, [@@pool_1]
    add r1, r2, r6
    cmp r1, r0
    ble @@branch_1
    sub r1, r0, r2
    str r1, [r4, #4]
    str r0, [r5, #0x28]
    b @@branch_2
@@branch_1:
    str r1, [r5, #0x28]
@@branch_2:
    ldr r1, [r4]
    cmp r1, #0
    beq @@branch_3
    ldr r0, [r1]
    add r0, r0, #1
    str r0, [r1]
@@branch_3:
    ldr r0, [@@pool_2]
    ldr r2, [sp]
    mov r1, r4
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word 0x0000C350
@@pool_2:
    .word Slots_ov77_021E7B74+1

Slots_ov77_021E7B74:
    push {r3-r6, lr}
    sub sp, #4
    mov r5, r1
    mov r6, r0
    ldr r0, [r5, #4]
    ldr r4, [r5, #0x10]
    cmp r0, #0
    bne @@branch_3
    ldr r1, [r5]
    cmp r1, #0
    beq @@branch_1
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1]
@@branch_1:
    ldr r0, [r4, #0x6C]
    lsl r0, r0, #31
    lsr r0, r0, #31
    beq @@branch_2
    mov r0, r4
    mov r1, #3
    bl Slots_ov77_021E751C
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #0
    bl Slots_ScheduleBgTilemapBufferTransfer
@@branch_2:
    mov r0, r5
    bl Slots_Heap_Free
    mov r0, r6
    bl Slots_SysTask_Destroy
    add sp, #4
    pop {r3-r6, pc}
@@branch_3:
    mov r0, r4
    bl Slots_ov77_021E715C
    cmp r0, #0
    beq @@branch_5
    ldr r1, [r5, #8]
    ldr r0, [r5, #4]
    add r0, r1, r0
    str r0, [r5, #8]
    ldr r0, [r4, #0x6C]
    lsl r0, r0, #31
    lsr r0, r0, #31
    beq @@branch_4
    mov r0, r4
    add r0, #0x4A
    ldrh r1, [r0]
    ldr r0, [r5, #4]
    add r1, r1, r0
    mov r0, r4
    add r0, #0x4A
    strh r1, [r0]
    mov r0, r4
    add r0, #0x4A
    ldrh r0, [r0]
    ldr r1, [@@pool_1]
    cmp r0, r1
    bls @@branch_4
    mov r0, r4
    add r0, #0x4A
    strh r1, [r0]
@@branch_4:
    mov r0, #0
    str r0, [r5, #4]
    b @@branch_7
@@branch_5:
    ldr r0, [r5, #8]
    add r0, r0, #1
    str r0, [r5, #8]
    ldr r0, [r4, #0x6C]
    lsl r0, r0, #31
    lsr r0, r0, #31
    beq @@branch_6
    mov r0, r4
    add r0, #0x4A
    ldrh r1, [r0]
    ldr r0, [@@pool_1]
    cmp r1, r0
    bcs @@branch_6
    mov r0, r4
    add r0, #0x4A
    ldrh r0, [r0]
    add r1, r0, #1
    mov r0, r4
    add r0, #0x4A
    strh r1, [r0]
@@branch_6:
    ldr r0, [r5, #4]
    sub r0, r0, #1
    str r0, [r5, #4]
@@branch_7:
    ldr r0, [@@pool_2]
    bl Slots_PlaySE
    ldr r1, [r5, #8]
    mov r0, r4
    mov r2, #0
    bl Slots_ov77_021E7324
    ldr r1, [r5, #4]
    mov r0, r4
    mov r2, #1
    bl Slots_ov77_021E7324
    ldr r0, [r4, #0x6C]
    lsl r0, r0, #31
    lsr r0, r0, #31
    beq @@branch_8
    mov r0, #0x15
    mov r1, r4
    str r0, [sp]
    add r1, #0x4A
    ldrh r1, [r1]
    mov r0, r4
    mov r2, #3
    mov r3, #7
    bl Slots_ov77_021E7604
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #0
    bl Slots_ScheduleBgTilemapBufferTransfer
@@branch_8:
    add sp, #4
    pop {r3-r6, pc}
    nop
@@pool_1:
    .word 0x000003E7
@@pool_2:
    .word 0x0000062C

Slots_ov77_021E7C7C:
    push {r3-r7, lr}
    mov r5, r0
    ldr r0, [r5]
    mov r6, r1
    mov r1, #0x18
    mov r7, r2
    bl Slots_Heap_Alloc
    mov r4, r0
    mov r1, #0
    mov r2, #0x18
    blx Slots_MI_CpuFill8
    str r5, [r4, #0x14]
    str r6, [r4, #0x10]
    mov r1, #0
    strb r1, [r4, #6]
    mov r0, #1
    strb r1, [r4, #7]
    strb r0, [r4, #0xD]
    cmp r6, #1
    bne @@branch_1
    strb r0, [r4, #0xC]
    add r0, #0xFF
    strh r0, [r4, #0xA]
    b @@branch_2
@@branch_1:
    cmp r6, #2
    bne @@branch_2
    sub r0, r0, #2
    strb r0, [r4, #0xC]
    strh r1, [r4, #0xA]
@@branch_2:
    ldr r0, [@@pool_1]
    mov r1, r4
    mov r2, r7
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021E7CCC+1

Slots_ov77_021E7CCC:
    push {r4, lr}
    mov r3, r1
    mov r1, #0xC
    ldsb r4, [r3, r1]
    ldr r0, [r3, #0x14]
    cmp r4, #0
    beq @@branch_3
    ldrb r1, [r3, #0xD]
    cmp r1, #0
    beq @@branch_3
    mov r2, #0xA
    ldsh r1, [r3, r2]
    add r1, r1, r4
    strh r1, [r3, #0xA]
    ldsh r4, [r3, r2]
    mov r1, r2
    add r1, #0xF6
    cmp r4, r1
    blt @@branch_1
    mov r1, #0
    strh r1, [r3, #0xA]
    b @@branch_2
@@branch_1:
    cmp r4, #0
    bgt @@branch_2
    add r2, #0xF6
    strh r2, [r3, #0xA]
@@branch_2:
    mov r1, #0x61
    mov r4, #0xA
    lsl r1, r1, #2
    ldr r0, [r0, r1]
    mov r1, #3
    ldsh r3, [r3, r4]
    mov r2, r1
    bl Slots_BgSetPosTextAndCommit
@@branch_3:
    pop {r4, pc}

Slots_ov77_021E7D14:
    push {r3-r7, lr}
    mov r5, r0
    ldr r0, [r5]
    mov r6, r1
    mov r1, #0x10
    mov r7, r2
    bl Slots_Heap_Alloc
    mov r4, r0
    mov r1, #0
    mov r2, #0x10
    blx Slots_MI_CpuFill8
    str r5, [r4, #0xC]
    str r6, [r4, #8]
    mov r0, #0
    strb r0, [r4, #6]
    strb r0, [r4, #7]
    ldr r0, [@@pool_1]
    mov r1, r4
    mov r2, r7
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_ov77_021E7D48+1

Slots_ov77_021E7D48:
    push {r3-r5, lr}
    mov r3, r1
    ldrb r2, [r3, #6]
    ldr r1, [r3, #0xC]
    add r0, r2, #1
    strb r0, [r3, #6]
    cmp r2, #0xF
    bcc @@branch_1
    ldr r0, [r3, #8]
    ldrb r2, [r3, #7]
    lsl r0, r0, #1
    add r0, r2, r0
    mov r2, #0
    strb r2, [r3, #6]
    lsl r4, r0, #20
    ldrb r5, [r3, #7]
    mov r0, #1
    eor r0, r5
    strb r0, [r3, #7]
    mov r0, #0x20
    str r0, [sp]
    mov r5, #0xBB
    mov r0, #0x1E
    lsl r5, r5, #2
    ldr r3, [r3, #8]
    lsl r0, r0, #4
    lsl r3, r3, #20
    ldr r5, [r1, r5]
    ldr r0, [r1, r0]
    lsr r1, r4, #15
    add r1, r5, r1
    lsr r3, r3, #16
    bl Slots_PaletteData_LoadPalette
@@branch_1:
    pop {r3-r5, pc}
    .align 4

Slots_ov77_021E7D90:
    push {r4-r6, lr}
    mov r5, r0
    mov r0, #0x47
    lsl r0, r0, #2
    add r2, r5, r0
    lsl r0, r1, #3
    add r4, r2, r0
    ldr r0, [r4, #4]
    cmp r0, #0
    bne @@branch_1
    mov r0, r4
    mov r1, #0
    mov r2, #8
    blx Slots_MI_CpuFill8
    pop {r4-r6, pc}
@@branch_1:
    bl Slots_SysTask_GetData
    mov r6, r0
    mov r0, #0x61
    lsl r0, r0, #2
    mov r1, #3
    ldr r0, [r5, r0]
    mov r2, r1
    mov r3, #0
    bl Slots_BgSetPosTextAndCommit
    mov r0, r6
    bl Slots_Heap_Free
    ldr r0, [r4, #4]
    bl Slots_SysTask_Destroy
    mov r0, r4
    mov r1, #0
    mov r2, #8
    blx Slots_MI_CpuFill8
    pop {r4-r6, pc}
    .align 4

Slots_ov77_021E7DE0:
    push {r4, lr}
    mov r2, #0x51
    lsl r2, r2, #2
    add r2, r0, r2
    lsl r0, r1, #3
    add r4, r2, r0
    ldr r0, [r4, #4]
    cmp r0, #0
    bne @@branch_1
    mov r0, r4
    mov r1, #0
    mov r2, #8
    blx Slots_MI_CpuFill8
    pop {r4, pc}
@@branch_1:
    bl Slots_SysTask_GetData
    bl Slots_Heap_Free
    ldr r0, [r4, #4]
    bl Slots_SysTask_Destroy
    mov r0, r4
    mov r1, #0
    mov r2, #8
    blx Slots_MI_CpuFill8
    pop {r4, pc}

Slots_ov77_021E7E18:
    push {r3-r5, lr}
    mov r5, r0
    mov r4, r1
    bl Slots_ov77_021E7D90
    mov r0, r5
    mov r1, r4
    bl Slots_ov77_021E7DE0
    pop {r3-r5, pc}

Slots_ov77_021E7E2C:
    push {r3-r5, lr}
    mov r5, r1
    mov r2, #9
    mov r4, r0
    bl Slots_ov77_021E7D14
    lsl r1, r5, #3
    add r2, r4, r1
    mov r1, #0x52
    lsl r1, r1, #2
    str r0, [r2, r1]
    pop {r3-r5, pc}

Slots_ov77_021E7E44:
    push {r3-r5, lr}
    mov r5, r1
    mov r2, #9
    mov r4, r0
    bl Slots_ov77_021E7C7C
    lsl r1, r5, #3
    add r2, r4, r1
    mov r1, #0x12
    lsl r1, r1, #4
    str r0, [r2, r1]
    pop {r3-r5, pc}

Slots_ov77_021E7E5C:
    push {r3-r5, lr}
    sub sp, #0x10
    mov r5, r0
    mov r0, #0
    str r0, [sp]
    str r0, [sp, #4]
    str r0, [sp, #8]
    ldr r0, [r5]
    mov r2, #0x61
    str r0, [sp, #0xC]
    mov r0, #0x2F
    lsl r0, r0, #4
    lsl r2, r2, #2
    mov r4, r1
    ldr r0, [r5, r0]
    ldr r2, [r5, r2]
    add r1, #0xF
    mov r3, #3
    bl Slots_GfGfxLoader_LoadScrnDataFromOpenNarc
    mov r0, r5
    mov r1, r4
    bl Slots_ov77_021E7E44
    mov r0, r5
    mov r1, r4
    bl Slots_ov77_021E7E2C
    mov r0, #0x5B
    lsl r0, r0, #2
    str r4, [r5, r0]
    add sp, #0x10
    pop {r3-r5, pc}
    .align 4

Slots_ov77_021E7EA0:
    push {r3-r7, lr}
    mov r6, r0
    ldr r0, [r6]
    mov r7, r1
    mov r1, #0x10
    mov r5, r2
    bl Slots_Heap_Alloc
    mov r1, #0
    mov r2, #0x10
    mov r4, r0
    blx Slots_MI_CpuFill8
    mov r0, #0
    strh r0, [r4, #6]
    str r7, [r4, #8]
    str r6, [r4, #0xC]
    str r5, [r4]
    cmp r5, #0
    beq @@branch_1
    ldr r0, [r5]
    add r0, r0, #1
    str r0, [r5]
@@branch_1:
    ldr r0, [@@pool_1]
    mov r1, r4
    mov r2, #6
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021E7EE0+1

Slots_ov77_021E7EE0:
    push {r3-r6, lr}
    sub sp, #4
    mov r5, r1
    mov r6, r0
    ldrh r0, [r5, #4]
    ldr r4, [r5, #0xC]
    cmp r0, #0
    beq @@branch_1
    cmp r0, #1
    beq @@branch_2
    cmp r0, #2
    beq @@branch_3
    b @@branch_4
@@branch_1:
    bl Slots_ScreenBrightnessData_InitAll
    mov r0, #1
    str r0, [sp]
    mov r0, #8
    mov r1, #0x10
    mov r2, #0
    mov r3, r0
    bl Slots_StartBrightnessTransition
    ldrh r0, [r5, #4]
    add sp, #4
    add r0, r0, #1
    strh r0, [r5, #4]
    pop {r3-r6, pc}
@@branch_2:
    bl Slots_DoAllScreenBrightnessTransitionStep
    mov r0, #1
    bl Slots_IsBrightnessTransitionActive
    cmp r0, #0
    beq @@branch_6
    mov r1, #0x5B
    lsl r1, r1, #2
    ldr r1, [r4, r1]
    mov r0, r4
    bl Slots_ov77_021E7E18
    ldr r1, [r5, #8]
    mov r0, r4
    bl Slots_ov77_021E7E5C
    bl Slots_ScreenBrightnessData_InitAll
    mov r0, #1
    str r0, [sp]
    mov r0, #8
    mov r1, #0
    mov r2, #0x10
    mov r3, r0
    bl Slots_StartBrightnessTransition
    ldrh r0, [r5, #4]
    add sp, #4
    add r0, r0, #1
    strh r0, [r5, #4]
    pop {r3-r6, pc}
@@branch_3:
    bl Slots_DoAllScreenBrightnessTransitionStep
    mov r0, #1
    bl Slots_IsBrightnessTransitionActive
    cmp r0, #0
    beq @@branch_6
    bl Slots_ScreenBrightnessData_InitAll
    ldrh r0, [r5, #4]
    add sp, #4
    add r0, r0, #1
    strh r0, [r5, #4]
    pop {r3-r6, pc}
@@branch_4:
    ldr r1, [r5]
    cmp r1, #0
    beq @@branch_5
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1]
@@branch_5:
    mov r0, r5
    bl Slots_Heap_Free
    mov r0, r6
    bl Slots_SysTask_Destroy
@@branch_6:
    add sp, #4
    pop {r3-r6, pc}

Slots_ov77_021E7F90:
    push {r3-r7, lr}
    mov r5, r0
    ldr r0, [r5]
    mov r6, r1
    mov r1, #0x18
    mov r7, r2
    str r3, [sp]
    bl Slots_Heap_Alloc
    mov r1, #0
    mov r2, #0x18
    mov r4, r0
    blx Slots_MI_CpuFill8
    mov r0, #0
    strh r0, [r4, #0xC]
    strb r6, [r4, #4]
    str r7, [r4, #0x10]
    mov r1, #3
    ldr r0, [sp]
    str r5, [r4, #0x14]
    str r0, [r4]
    mov r0, #0x1F
    strh r0, [r4, #8]
    mov r0, #0x61
    lsl r0, r0, #2
    ldrh r3, [r4, #6]
    ldr r0, [r5, r0]
    mov r2, r1
    bl Slots_BgSetPosTextAndCommit
    mov r0, #8
    ldsh r0, [r4, r0]
    ldrh r2, [r4, #8]
    sub r0, r0, #1
    strh r0, [r4, #8]
    ldr r1, [r4, #0x10]
    mov r0, r5
    lsl r1, r1, #24
    lsr r1, r1, #24
    bl Slots_ov77_021E8010
    ldr r1, [r4, #0x10]
    ldrh r2, [r4, #8]
    lsl r1, r1, #24
    mov r0, r5
    lsr r1, r1, #24
    bl Slots_ov77_021E8010
    ldr r1, [r4]
    cmp r1, #0
    beq @@branch_1
    ldr r0, [r1]
    add r0, r0, #1
    str r0, [r1]
@@branch_1:
    ldr r0, [@@pool_1]
    mov r1, r4
    mov r2, #5
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021E805C+1

Slots_ov77_021E8010:
    push {r4-r5, lr}
    sub sp, #0x1C
    mov r4, r0
    mov r0, #0xAD
    lsl r0, r0, #2
    add r3, r4, r0
    lsl r0, r1, #4
    mov r1, #0x20
    str r1, [sp]
    mov r1, #1
    add r0, r3, r0
    str r1, [sp, #4]
    ldr r1, [r0, #8]
    mov r5, #0
    str r1, [sp, #8]
    lsl r1, r2, #24
    str r5, [sp, #0xC]
    lsr r3, r1, #24
    str r3, [sp, #0x10]
    ldrb r1, [r0, #0xC]
    mov r2, r5
    str r1, [sp, #0x14]
    ldrb r0, [r0, #0xD]
    mov r1, #3
    str r0, [sp, #0x18]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    bl Slots_CopyToBgTilemapRect
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #3
    bl Slots_ScheduleBgTilemapBufferTransfer
    add sp, #0x1C
    pop {r4-r5, pc}

Slots_ov77_021E805C:
    push {r4-r6, lr}
    mov r5, r1
    mov r6, r0
    mov r0, #0x61
    ldr r4, [r5, #0x14]
    lsl r0, r0, #2
    ldr r0, [r4, r0]
    mov r1, #3
    mov r2, #5
    mov r3, #0x10
    bl Slots_BgSetPosTextAndCommit
    ldrh r0, [r5, #6]
    add r0, #0x10
    strh r0, [r5, #6]
    mov r0, #8
    ldsh r0, [r5, r0]
    add r0, #0x1F
    lsr r2, r0, #31
    lsl r1, r0, #27
    sub r1, r1, r2
    mov r0, #0x1B
    ror r1, r0
    add r0, r2, r1
    strh r0, [r5, #8]
    ldr r1, [r5, #0x10]
    ldrh r2, [r5, #8]
    lsl r1, r1, #24
    mov r0, r4
    lsr r1, r1, #24
    bl Slots_ov77_021E8010
    mov r0, #8
    ldsh r0, [r5, r0]
    add r0, #0x1F
    lsr r2, r0, #31
    lsl r1, r0, #27
    sub r1, r1, r2
    mov r0, #0x1B
    ror r1, r0
    add r0, r2, r1
    strh r0, [r5, #8]
    ldr r1, [r5, #0x10]
    ldrh r2, [r5, #8]
    lsl r1, r1, #24
    mov r0, r4
    lsr r1, r1, #24
    bl Slots_ov77_021E8010
    ldrh r0, [r5, #6]
    cmp r0, #0xF0
    bcc @@branch_2
    ldr r1, [r5]
    cmp r1, #0
    beq @@branch_1
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1]
@@branch_1:
    mov r0, r5
    bl Slots_Heap_Free
    mov r0, r6
    bl Slots_SysTask_Destroy
@@branch_2:
    pop {r4-r6, pc}
    .align 4

Slots_ov77_021E80E0:
    push {r3-r7, lr}
    mov r6, r0
    ldr r0, [r6]
    mov r4, r1
    mov r1, #0x20
    mov r7, r2
    str r3, [sp]
    bl Slots_Heap_Alloc
    mov r1, #0
    mov r2, #0x20
    mov r5, r0
    blx Slots_MI_CpuFill8
    mov r0, #0
    strh r0, [r5, #0x10]
    strb r4, [r5, #0xA]
    strb r7, [r5, #0xB]
    ldrb r0, [r5, #0xA]
    mov r1, #3
    strb r0, [r5, #0xC]
    add r0, r0, #1
    blx Slots__s32_div_f
    strb r1, [r5, #0xD]
    bl Slots_LCRandom
    mov r1, #5
    blx Slots__s32_div_f
    add r1, r1, #2
    lsl r0, r1, #1
    add r0, r1, r0
    strb r0, [r5, #9]
    ldrb r1, [r5, #0xB]
    ldrb r0, [r5, #0xA]
    sub r2, r1, r0
    bpl @@branch_1
    ldrb r1, [r5, #9]
    add r0, r2, #3
    add r0, r1, r0
    b @@branch_2
@@branch_1:
    ldrb r0, [r5, #9]
    add r0, r0, r2
@@branch_2:
    strb r0, [r5, #9]
    ldr r0, [sp]
    str r6, [r5, #0x1C]
    str r0, [r5]
    mov r0, #0x7E
    lsl r0, r0, #2
    ldr r0, [r6, r0]
    mov r4, #0
    str r0, [r5, #0x18]
@@branch_3:
    ldrb r0, [r5, #0xC]
    cmp r4, r0
    beq @@branch_4
    mov r0, r6
    mov r1, r4
    bl Slots_ov77_021E7E2C
@@branch_4:
    add r4, r4, #1
    cmp r4, #3
    blt @@branch_3
    ldr r1, [r5]
    cmp r1, #0
    beq @@branch_5
    ldr r0, [r1]
    add r0, r0, #1
    str r0, [r1]
@@branch_5:
    ldr r0, [@@pool_1]
    mov r1, r5
    mov r2, #6
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021E817C+1

Slots_ov77_021E817C:
    push {r3-r7, lr}
    mov r4, r1
    mov r7, r0
    ldrh r0, [r4, #0xE]
    ldr r6, [r4, #0x1C]
    cmp r0, #5
    bls @@branch_1
    b @@branch_4
@@branch_1:
    add r0, r0, r0
    add r0, pc
    ldrh r0, [r0, #6]
    lsl r0, r0, #16
    asr r0, r0, #16
    add pc, r0
@@table_1:
    .halfword @@case_1 - @@table_1 - 2
    .halfword @@case_2 - @@table_1 - 2
    .halfword @@case_3 - @@table_1 - 2
    .halfword @@case_4 - @@table_1 - 2
    .halfword @@case_5 - @@table_1 - 2
    .halfword @@case_6 - @@table_1 - 2
@@case_1:
    bl Slots_ScreenBrightnessData_InitAll
    mov r0, #1
    str r0, [sp]
    mov r0, #0x10
    mov r1, r0
    mov r2, #0
    mov r3, #8
    bl Slots_StartBrightnessTransition
    ldrh r0, [r4, #0xE]
    add r0, r0, #1
    strh r0, [r4, #0xE]
    pop {r3-r7, pc}
@@case_2:
    bl Slots_DoAllScreenBrightnessTransitionStep
    mov r0, #1
    bl Slots_IsBrightnessTransitionActive
    cmp r0, #0
    bne @@branch_2
    b @@branch_8
@@branch_2:
    ldr r0, [r4, #0x18]
    mov r1, #0xC
    bl Slots_Sprite_SetAnimCtrlSeq
    ldr r0, [r4, #0x18]
    mov r1, #1
    bl Slots_Sprite_SetDrawPriority
    mov r1, #0x54
    ldr r0, [r4, #0x18]
    mov r2, r1
    bl Slots_Sprite_SetPositionXY
    ldr r0, [r4, #0x18]
    mov r1, #1
    bl Slots_Sprite_SetDrawFlag
    ldrb r1, [r4, #0xA]
    mov r0, r6
    bl Slots_ov77_021E7D90
    bl Slots_ScreenBrightnessData_InitAll
    mov r0, #1
    str r0, [sp]
    mov r0, #0x10
    mov r1, #0
    mov r2, r0
    mov r3, #8
    bl Slots_StartBrightnessTransition
    ldrh r0, [r4, #0xE]
    add r0, r0, #1
    strh r0, [r4, #0xE]
    pop {r3-r7, pc}
@@case_3:
    bl Slots_DoAllScreenBrightnessTransitionStep
    mov r0, #1
    bl Slots_IsBrightnessTransitionActive
    cmp r0, #0
    beq @@branch_8
    ldrh r0, [r4, #0xE]
    add r0, r0, #1
    strh r0, [r4, #0xE]
@@case_4:
    ldrb r1, [r4, #0xC]
    ldrb r2, [r4, #0xD]
    mov r0, r6
    add r3, r4, #4
    bl Slots_ov77_021E7F90
    ldrh r0, [r4, #0xE]
    add r0, r0, #1
    strh r0, [r4, #0xE]
    pop {r3-r7, pc}
@@case_5:
    ldr r0, [r4, #4]
    cmp r0, #0
    bne @@branch_8
    ldrb r0, [r4, #0xD]
    mov r1, #3
    strb r0, [r4, #0xC]
    ldrb r0, [r4, #0xD]
    add r0, r0, #1
    blx Slots__s32_div_f
    strb r1, [r4, #0xD]
    ldrb r0, [r4, #8]
    add r0, r0, #1
    strb r0, [r4, #8]
    ldrb r1, [r4, #8]
    ldrb r0, [r4, #9]
    cmp r1, r0
    bcs @@branch_3
    mov r0, #3
    strh r0, [r4, #0xE]
    pop {r3-r7, pc}
@@branch_3:
    bl Slots_ScreenBrightnessData_InitAll
    mov r0, #1
    str r0, [sp]
    mov r0, #8
    mov r1, #0x10
    mov r2, #0
    mov r3, r0
    bl Slots_StartBrightnessTransition
    ldrh r0, [r4, #0xE]
    add r0, r0, #1
    strh r0, [r4, #0xE]
    pop {r3-r7, pc}
@@case_6:
    bl Slots_DoAllScreenBrightnessTransitionStep
    mov r0, #1
    bl Slots_IsBrightnessTransitionActive
    cmp r0, #0
    beq @@branch_8
    ldr r0, [r4, #0x18]
    mov r1, #0
    bl Slots_Sprite_SetDrawFlag
    ldr r0, [r4, #0x18]
    mov r1, #3
    bl Slots_Sprite_SetDrawPriority
    ldrb r1, [r4, #0xC]
    mov r0, r6
    bl Slots_ov77_021E7E44
    mov r0, #0x5B
    ldrb r1, [r4, #0xC]
    lsl r0, r0, #2
    str r1, [r6, r0]
    bl Slots_ScreenBrightnessData_InitAll
    mov r0, #1
    str r0, [sp]
    mov r0, #0x10
    mov r1, #0
    mov r2, r0
    mov r3, #8
    bl Slots_StartBrightnessTransition
    ldrh r0, [r4, #0xE]
    add r0, r0, #1
    strh r0, [r4, #0xE]
    pop {r3-r7, pc}
@@branch_4:
    bl Slots_DoAllScreenBrightnessTransitionStep
    mov r0, #1
    bl Slots_IsBrightnessTransitionActive
    cmp r0, #0
    beq @@branch_8
    mov r5, #0
@@branch_5:
    ldrb r0, [r4, #0xC]
    cmp r5, r0
    beq @@branch_6
    mov r0, r6
    mov r1, r5
    bl Slots_ov77_021E7DE0
@@branch_6:
    add r5, r5, #1
    cmp r5, #3
    blt @@branch_5
    ldr r1, [r4]
    cmp r1, #0
    beq @@branch_7
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1]
@@branch_7:
    mov r0, r4
    bl Slots_Heap_Free
    mov r0, r7
    bl Slots_SysTask_Destroy
@@branch_8:
    pop {r3-r7, pc}

Slots_ov77_021E830C:
    push {r3-r6, lr}
    sub sp, #0x1C
    mov r5, r0
    mov r0, #6
    str r0, [sp]
    mov r3, #0xAB
    str r0, [sp, #4]
    lsl r3, r3, #2
    ldr r6, [r5, r3]
    add r4, r2, #1
    str r6, [sp, #8]
    mov r6, r2
    mul r6, r0
    mul r0, r1
    lsl r2, r6, #24
    lsr r2, r2, #24
    lsl r0, r0, #24
    str r2, [sp, #0xC]
    lsr r0, r0, #24
    str r0, [sp, #0x10]
    add r0, r3, #4
    ldrb r0, [r5, r0]
    lsl r1, r4, #24
    lsr r1, r1, #24
    str r0, [sp, #0x14]
    add r0, r3, #5
    ldrb r0, [r5, r0]
    mov r2, #0xD
    mov r3, #9
    str r0, [sp, #0x18]
    mov r0, #0x61
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    bl Slots_CopyToBgTilemapRect
    mov r0, #0x61
    lsl r0, r0, #2
    lsl r1, r4, #24
    ldr r0, [r5, r0]
    lsr r1, r1, #24
    bl Slots_ScheduleBgTilemapBufferTransfer
    add sp, #0x1C
    pop {r3-r6, pc}

Slots_ov77_021E8364:
    push {r4-r7, lr}
    sub sp, #0xC
    mov r6, r0
    str r3, [sp, #8]
    mov r7, r1
    ldr r0, [r6]
    mov r1, #0xC
    mov r5, r2
    bl Slots_Heap_Alloc
    mov r4, r0
    mov r1, #0
    mov r2, #0xC
    blx Slots_MI_CpuFill8
    str r6, [r4, #8]
    strb r7, [r4, #7]
    mov r3, #0x10
    ldr r0, [@@pool_1]
    str r3, [sp]
    str r0, [sp, #4]
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r6, r0]
    mov r1, #0
    mov r2, #0x70
    bl Slots_PaletteData_BlendPalette
    ldrb r1, [r4, #7]
    mov r0, r6
    mov r2, #1
    bl Slots_ov77_021E830C
    mov r0, #0x10
    strb r0, [r4, #6]
    str r5, [r4]
    cmp r5, #0
    beq @@branch_1
    ldr r0, [r5]
    add r0, r0, #1
    str r0, [r5]
@@branch_1:
    ldr r0, [@@pool_2]
    ldr r2, [sp, #8]
    mov r1, r4
    bl Slots_SysTask_CreateOnMainQueue
    add sp, #0xC
    pop {r4-r7, pc}
@@pool_1:
    .word 0x00006B5A
@@pool_2:
    .word Slots_ov77_021E83CC+1

Slots_ov77_021E83CC:
    push {r3-r5, lr}
    sub sp, #8
    mov r4, r1
    mov r5, r0
    ldrb r0, [r4, #6]
    mov r2, #0x70
    mov r3, #0x10
    str r0, [sp]
    ldr r0, [@@pool_1]
    str r0, [sp, #4]
    mov r0, #0x1E
    ldr r1, [r4, #8]
    lsl r0, r0, #4
    ldr r0, [r1, r0]
    mov r1, #0
    bl Slots_PaletteData_BlendPalette
    ldrb r1, [r4, #6]
    sub r0, r1, #1
    strb r0, [r4, #6]
    cmp r1, #0
    bne @@branch_2
    ldr r1, [r4]
    cmp r1, #0
    beq @@branch_1
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1]
@@branch_1:
    mov r0, r4
    bl Slots_Heap_Free
    mov r0, r5
    bl Slots_SysTask_Destroy
@@branch_2:
    add sp, #8
    pop {r3-r5, pc}
@@pool_1:
    .word 0x00006B5A

Slots_ov77_021E8418:
    push {r3-r7, lr}
    mov r6, r0
    str r3, [sp]
    mov r7, r1
    ldr r0, [r6]
    mov r1, #0x10
    mov r5, r2
    bl Slots_Heap_Alloc
    mov r4, r0
    mov r1, #0
    mov r2, #0x10
    blx Slots_MI_CpuFill8
    str r6, [r4, #0xC]
    strb r7, [r4, #6]
    mov r7, #0
    ldr r3, [@@pool_1]
    strb r7, [r4, #7]
    mov r0, #0x30
    strb r0, [r4, #8]
    mov r0, #2
    strb r0, [r4, #9]
    ldrb r1, [r4, #8]
    ldr r0, [@@pool_2]
    mov r2, r3
    add r1, #0x48
    strh r0, [r3]
    lsl r0, r1, #24
    lsr r1, r0, #24
    mov r0, #0x12
    lsl r0, r0, #10
    orr r0, r1
    strh r0, [r3, #4]
    sub r2, #0x40
    ldr r1, [r2]
    ldr r0, [@@pool_3]
    and r0, r1
    lsl r1, r3, #7
    orr r0, r1
    str r0, [r2]
    ldrb r1, [r4, #6]
    mov r0, r6
    mov r2, r7
    bl Slots_ov77_021E830C
    mov r0, r6
    mov r1, #4
    bl Slots_ov77_021E7308
    ldr r0, [@@pool_4]
    bl Slots_PlaySE
    str r5, [r4]
    cmp r5, #0
    beq @@branch_1
    ldr r0, [r5]
    add r0, r0, #1
    str r0, [r5]
@@branch_1:
    ldr r0, [@@pool_5]
    ldr r2, [sp]
    mov r1, r4
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word 0x04000040
@@pool_2:
    .word 0x00006898
@@pool_3:
    .word 0xFFFF1FFF
@@pool_4:
    .word 0x0000093C
@@pool_5:
    .word Slots_ov77_021E84B0+1

Slots_ov77_021E84B0:
    push {r3-r5, lr}
    mov r4, r1
    ldrb r3, [r4, #8]
    mov r5, r0
    ldr r0, [r4, #0xC]
    ldr r2, [@@pool_1]
    ldr r1, [@@pool_2]
    add r3, #0x48
    strh r2, [r1]
    lsl r2, r3, #24
    lsr r3, r2, #24
    mov r2, #0x12
    lsl r2, r2, #10
    orr r2, r3
    strh r2, [r1, #4]
    ldrb r2, [r4, #8]
    cmp r2, #0
    beq @@branch_1
    ldrb r0, [r4, #9]
    sub r0, r2, r0
    strb r0, [r4, #8]
    pop {r3-r5, pc}
@@branch_1:
    sub r1, #0x40
    ldr r3, [r1]
    ldr r2, [@@pool_3]
    and r2, r3
    str r2, [r1]
    ldr r2, [r4]
    cmp r2, #0
    beq @@branch_2
    ldr r1, [r2]
    sub r1, r1, #1
    str r1, [r2]
@@branch_2:
    mov r1, #1
    bl Slots_ov77_021E7308
    mov r0, r4
    bl Slots_Heap_Free
    mov r0, r5
    bl Slots_SysTask_Destroy
    pop {r3-r5, pc}
    nop
@@pool_1:
    .word 0x00006898
@@pool_2:
    .word 0x04000040
@@pool_3:
    .word 0xFFFF1FFF

Slots_ov77_021E8514:
    push {r3-r7, lr}
    mov r6, r0
    ldr r0, [r6]
    mov r5, r1
    mov r1, #0xC
    mov r7, r2
    bl Slots_Heap_Alloc
    mov r4, r0
    mov r1, #0
    mov r2, #0xC
    blx Slots_MI_CpuFill8
    mov r0, #0
    str r6, [r4, #8]
    strb r0, [r4, #6]
    str r5, [r4]
    cmp r5, #0
    beq @@branch_1
    ldr r0, [r5]
    add r0, r0, #1
    str r0, [r5]
@@branch_1:
    ldr r0, [@@pool_1]
    mov r1, r4
    mov r2, r7
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_ov77_021E8550+1

Slots_ov77_021E8550:
    push {r4-r6, lr}
    sub sp, #8
    mov r5, r1
    mov r6, r0
    ldrb r0, [r5, #6]
    ldr r4, [r5, #8]
    mov r1, #0
    str r0, [sp]
    ldr r0, [@@pool_1]
    mov r2, #0x70
    str r0, [sp, #4]
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r4, r0]
    mov r3, #0x20
    bl Slots_PaletteData_BlendPalette
    ldrb r0, [r5, #6]
    add r0, r0, #2
    strb r0, [r5, #6]
    ldrb r0, [r5, #6]
    cmp r0, #0x10
    bcc @@branch_2
    mov r1, #0
    mov r0, r4
    mov r2, r1
    bl Slots_ov77_021E830C
    mov r0, r4
    mov r1, #0
    mov r2, #1
    bl Slots_ov77_021E830C
    mov r1, #0
    ldr r0, [@@pool_1]
    str r1, [sp]
    str r0, [sp, #4]
    mov r0, #0x1E
    lsl r0, r0, #4
    ldr r0, [r4, r0]
    mov r2, #0x80
    mov r3, #0x10
    bl Slots_PaletteData_BlendPalette
    ldr r1, [r5]
    cmp r1, #0
    beq @@branch_1
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1]
@@branch_1:
    mov r0, r5
    bl Slots_Heap_Free
    mov r0, r6
    bl Slots_SysTask_Destroy
@@branch_2:
    add sp, #8
    pop {r4-r6, pc}
@@pool_1:
    .word 0x00006B5A

Slots_ov77_021E85C8:
    push {r3-r7, lr}
    mov r4, #0
    mov r6, #0x7E
    mov r5, r0
    mov r7, r4
    lsl r6, r6, #2
@@branch_1:
    ldr r0, [r5, r6]
    mov r1, r7
    bl Slots_Sprite_SetDrawFlag
    add r4, r4, #1
    add r5, r5, #4
    cmp r4, #5
    blt @@branch_1
    pop {r3-r7, pc}
    .align 4

Slots_ov77_021E85E8:
    push {r3-r7, lr}
    mov r6, r0
    str r3, [sp]
    mov r7, r1
    ldr r0, [r6]
    mov r1, #0x10
    mov r5, r2
    bl Slots_Heap_Alloc
    mov r4, r0
    mov r1, #0
    mov r2, #0x10
    blx Slots_MI_CpuFill8
    str r6, [r4, #0xC]
    mov r0, #0
    strb r0, [r4, #6]
    mov r0, #0x7E
    strb r7, [r4, #7]
    lsl r0, r0, #2
    ldr r0, [r6, r0]
    add r7, #0xA
    str r0, [r4, #8]
    mov r1, r7
    bl Slots_Sprite_SetAnimCtrlSeq
    ldr r0, [r4, #8]
    mov r1, #0x44
    mov r2, #0x54
    bl Slots_Sprite_SetPositionXY
    ldr r0, [r4, #8]
    mov r1, #1
    bl Slots_Sprite_SetDrawFlag
    ldr r0, [@@pool_1]
    bl Slots_PlaySE
    str r5, [r4]
    cmp r5, #0
    beq @@branch_1
    ldr r0, [r5]
    add r0, r0, #1
    str r0, [r5]
@@branch_1:
    ldr r0, [@@pool_2]
    ldr r2, [sp]
    mov r1, r4
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
@@pool_1:
    .word 0x0000093B
@@pool_2:
    .word Slots_ov77_021E8654+1

Slots_ov77_021E8654:
    push {r3-r5, lr}
    mov r4, r1
    ldrb r3, [r4, #6]
    mov r2, #0x54
    mov r5, r0
    sub r2, r2, r3
    lsl r2, r2, #16
    ldr r0, [r4, #8]
    mov r1, #0x44
    asr r2, r2, #16
    bl Slots_Sprite_SetPositionXY
    ldrb r0, [r4, #6]
    add r0, r0, #2
    strb r0, [r4, #6]
    ldrb r0, [r4, #6]
    cmp r0, #0x10
    bcc @@branch_2
    ldr r1, [r4]
    cmp r1, #0
    beq @@branch_1
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1]
@@branch_1:
    mov r0, r4
    bl Slots_Heap_Free
    mov r0, r5
    bl Slots_SysTask_Destroy
@@branch_2:
    pop {r3-r5, pc}
    .align 4

Slots_ov77_021E8694:
    push {r3-r7, lr}
    mov r5, r0
    ldr r0, [r5]
    mov r6, r1
    mov r1, #0x24
    str r2, [sp]
    mov r7, r3
    bl Slots_Heap_Alloc
    mov r4, r0
    mov r1, #0
    mov r2, #0x24
    blx Slots_MI_CpuFill8
    str r5, [r4, #0x20]
    strh r7, [r4, #0xA]
    add r1, sp, #8
    mov r0, #0x10
    ldsh r0, [r1, r0]
    strh r0, [r4, #0xC]
    strb r6, [r4, #6]
    bl Slots_LCRandom
    lsr r1, r0, #31
    lsl r2, r0, #30
    sub r2, r2, r1
    mov r0, #0x1E
    ror r2, r0
    add r0, r1, r2
    add r0, r0, #6
    cmp r0, #0
    ble @@branch_1
    bl Slots_LCRandom
    lsr r1, r0, #31
    lsl r2, r0, #30
    sub r2, r2, r1
    mov r0, #0x1E
    ror r2, r0
    add r0, r1, r2
    add r0, r0, #6
    lsl r0, r0, #12
    blx Slots__f_itof
    mov r1, r0
    mov r0, #0x3F
    lsl r0, r0, #24
    blx Slots__fadd
    b @@branch_2
@@branch_1:
    bl Slots_LCRandom
    lsr r1, r0, #31
    lsl r2, r0, #30
    sub r2, r2, r1
    mov r0, #0x1E
    ror r2, r0
    add r0, r1, r2
    add r0, r0, #6
    lsl r0, r0, #12
    blx Slots__f_itof
    mov r1, #0x3F
    lsl r1, r1, #24
    blx Slots__fsub
@@branch_2:
    blx Slots__f_ftoi
    str r0, [r4, #0x18]
    mov r0, #0x20
    strh r0, [r4, #0xE]
    mov r0, #0xA
    ldsh r0, [r4, r0]
    cmp r0, #0
    ble @@branch_3
    lsl r0, r0, #12
    blx Slots__f_itof
    mov r1, r0
    mov r0, #0x3F
    lsl r0, r0, #24
    blx Slots__fadd
    b @@branch_4
@@branch_3:
    lsl r0, r0, #12
    blx Slots__f_itof
    mov r1, #0x3F
    lsl r1, r1, #24
    blx Slots__fsub
@@branch_4:
    blx Slots__f_ftoi
    str r0, [r4, #0x14]
    mov r0, #4
    bl Slots_ov77_021E7128
    mov r1, #0x15
    lsl r0, r0, #3
    lsl r1, r1, #4
    add r0, r0, r1
    add r1, #0x18
    blx Slots__s32_div_f
    ldr r0, [sp]
    strb r1, [r4, #8]
    add r0, r0, #3
    lsl r0, r0, #2
    add r1, r5, r0
    mov r0, #0x7B
    lsl r0, r0, #2
    ldr r0, [r1, r0]
    add r6, #8
    mov r1, r6
    str r0, [r4, #0x1C]
    bl Slots_Sprite_SetAnimCtrlSeq
    add r3, sp, #8
    mov r2, #0x10
    ldsh r2, [r3, r2]
    ldr r0, [r4, #0x1C]
    mov r1, r7
    bl Slots_Sprite_SetPositionXY
    ldr r0, [r4, #0x1C]
    mov r1, #1
    bl Slots_Sprite_SetDrawFlag
    ldr r0, [@@pool_1]
    bl Slots_PlaySE
    ldr r1, [sp, #0x1C]
    str r1, [r4]
    cmp r1, #0
    beq @@branch_5
    ldr r0, [r1]
    add r0, r0, #1
    str r0, [r1]
@@branch_5:
    add r2, sp, #8
    ldrb r2, [r2, #0x18]
    ldr r0, [@@pool_2]
    mov r1, r4
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word 0x00000938
@@pool_2:
    .word Slots_ov77_021E87C0+1

Slots_ov77_021E87C0:
    push {r4-r6, lr}
    mov r4, r1
    mov r5, r0
    ldrb r0, [r4, #4]
    cmp r0, #0
    beq @@branch_1
    cmp r0, #1
    b @@branch_4
@@branch_1:
    ldrb r0, [r4, #8]
    ldr r5, [r4, #0x18]
    bl Slots_GF_SinDegNoWrap
    asr r1, r0, #31
    asr r3, r5, #31
    mov r2, r5
    blx Slots__ll_mul
    mov r5, #2
    mov r3, r0
    mov r2, #0xA
    mov r6, #0
    lsl r5, r5, #10
    add r3, r3, r5
    adc r1, r6
    ldsh r2, [r4, r2]
    lsl r1, r1, #20
    lsr r3, r3, #12
    orr r3, r1
    asr r1, r3, #12
    add r1, r2, r1
    mov r2, #0xC
    ldsh r3, [r4, r2]
    mov r2, #0x10
    ldsh r2, [r4, r2]
    lsl r1, r1, #16
    ldr r0, [r4, #0x1C]
    sub r2, r3, r2
    lsl r2, r2, #16
    asr r1, r1, #16
    asr r2, r2, #16
    bl Slots_Sprite_SetPositionXY
    ldrb r0, [r4, #8]
    add r0, #8
    strb r0, [r4, #8]
    mov r0, #0x5A
    ldrb r1, [r4, #8]
    lsl r0, r0, #2
    cmp r1, r0
    blt @@branch_2
    mov r0, r6
    strb r0, [r4, #8]
@@branch_2:
    mov r0, #0x10
    ldsh r1, [r4, r0]
    add r1, r1, #1
    strh r1, [r4, #0x10]
    ldsh r1, [r4, r0]
    mov r0, #0xE
    ldsh r0, [r4, r0]
    sub r0, r0, #6
    cmp r1, r0
    ble @@branch_3
    lsr r3, r1, #31
    lsl r2, r1, #31
    sub r2, r2, r3
    mov r1, #0x1F
    ror r2, r1
    ldr r0, [r4, #0x1C]
    add r1, r3, r2
    bl Slots_Sprite_SetDrawFlag
@@branch_3:
    mov r0, #0x10
    ldsh r1, [r4, r0]
    mov r0, #0xE
    ldsh r0, [r4, r0]
    cmp r1, r0
    blt @@branch_6
    mov r0, #0xF
    strb r0, [r4, #5]
    ldrb r0, [r4, #4]
    add r0, r0, #1
    strb r0, [r4, #4]
    pop {r4-r6, pc}
@@branch_4:
    ldrb r1, [r4, #5]
    sub r0, r1, #1
    strb r0, [r4, #5]
    cmp r1, #0
    bne @@branch_6
    ldr r0, [r4, #0x1C]
    mov r1, #0
    bl Slots_Sprite_SetDrawFlag
    ldr r1, [r4]
    cmp r1, #0
    beq @@branch_5
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1]
@@branch_5:
    mov r0, r4
    bl Slots_Heap_Free
    mov r0, r5
    bl Slots_SysTask_Destroy
@@branch_6:
    pop {r4-r6, pc}
    .align 4

Slots_ov77_021E8894:
    push {r4-r5, lr}
    sub sp, #0xC
    mov r5, r0
    mov r4, r2
    cmp r1, #1
    beq @@branch_1
    cmp r1, #2
    beq @@branch_2
    cmp r1, #3
    beq @@branch_3
    add sp, #0xC
    pop {r4-r5, pc}
@@branch_1:
    mov r1, #0x54
    str r1, [sp]
    add r5, #0x34
    str r5, [sp, #4]
    mov r1, #8
    str r1, [sp, #8]
    mov r1, r4
    mov r2, #0
    mov r3, #0x44
    bl Slots_ov77_021E8694
    add sp, #0xC
    pop {r4-r5, pc}
@@branch_2:
    bl Slots_LCRandom
    lsr r2, r0, #31
    lsl r1, r0, #28
    sub r1, r1, r2
    mov r0, #0x1C
    ror r1, r0
    add r0, r2, r1
    add r0, #0x54
    lsl r0, r0, #16
    asr r0, r0, #16
    str r0, [sp]
    mov r0, r5
    add r0, #0x34
    str r0, [sp, #4]
    mov r0, #8
    str r0, [sp, #8]
    mov r0, r5
    mov r1, r4
    mov r2, #0
    mov r3, #0x38
    bl Slots_ov77_021E8694
    bl Slots_LCRandom
    lsr r2, r0, #31
    lsl r1, r0, #28
    sub r1, r1, r2
    mov r0, #0x1C
    ror r1, r0
    add r0, r2, r1
    add r0, #0x54
    lsl r0, r0, #16
    asr r0, r0, #16
    str r0, [sp]
    mov r0, r5
    add r0, #0x34
    str r0, [sp, #4]
    mov r0, #8
    str r0, [sp, #8]
    mov r0, r5
    mov r1, r4
    mov r2, #1
    mov r3, #0x50
    bl Slots_ov77_021E8694
    add sp, #0xC
    pop {r4-r5, pc}
@@branch_3:
    bl Slots_LCRandom
    lsr r2, r0, #31
    lsl r1, r0, #28
    sub r1, r1, r2
    mov r0, #0x1C
    ror r1, r0
    add r0, r2, r1
    add r0, #0x54
    lsl r0, r0, #16
    asr r0, r0, #16
    str r0, [sp]
    mov r0, r5
    add r0, #0x34
    str r0, [sp, #4]
    mov r0, #8
    str r0, [sp, #8]
    mov r0, r5
    mov r1, r4
    mov r2, #0
    mov r3, #0x44
    bl Slots_ov77_021E8694
    bl Slots_LCRandom
    lsr r2, r0, #31
    lsl r1, r0, #28
    sub r1, r1, r2
    mov r0, #0x1C
    ror r1, r0
    add r0, r2, r1
    add r0, #0x54
    lsl r0, r0, #16
    asr r0, r0, #16
    str r0, [sp]
    mov r0, r5
    add r0, #0x34
    str r0, [sp, #4]
    mov r0, #8
    str r0, [sp, #8]
    mov r0, r5
    mov r1, r4
    mov r2, #1
    mov r3, #0x54
    bl Slots_ov77_021E8694
    bl Slots_LCRandom
    lsr r2, r0, #31
    lsl r1, r0, #28
    sub r1, r1, r2
    mov r0, #0x1C
    ror r1, r0
    add r0, r2, r1
    add r0, #0x54
    lsl r0, r0, #16
    asr r0, r0, #16
    str r0, [sp]
    mov r0, r5
    add r0, #0x34
    str r0, [sp, #4]
    mov r0, #8
    str r0, [sp, #8]
    mov r0, r5
    mov r1, r4
    mov r2, #2
    mov r3, #0x34
    bl Slots_ov77_021E8694
    add sp, #0xC
    pop {r4-r5, pc}

Slots_ov77_021E89B4:
    push {r3-r7, lr}
    mov r5, r0
    str r3, [sp]
    mov r6, r1
    ldr r0, [r5]
    mov r1, #0x30
    mov r7, r2
    bl Slots_Heap_Alloc
    mov r4, r0
    mov r1, #0
    mov r2, #0x30
    blx Slots_MI_CpuFill8
    str r5, [r4, #0x2C]
    mov r0, #0x44
    strh r0, [r4, #0xA]
    mov r0, #0x54
    strh r0, [r4, #0xC]
    ldr r0, [sp]
    add r1, sp, #8
    strh r0, [r4, #0xE]
    mov r0, #0x10
    ldsh r0, [r1, r0]
    strh r0, [r4, #0x10]
    strb r6, [r4, #6]
    mov r0, #0xE
    ldsh r1, [r4, r0]
    mov r0, #0xA
    ldsh r0, [r4, r0]
    sub r0, r1, r0
    cmp r0, #0
    ble @@branch_1
    lsl r0, r0, #12
    blx Slots__f_itof
    mov r1, r0
    mov r0, #0x3F
    lsl r0, r0, #24
    blx Slots__fadd
    b @@branch_2
@@branch_1:
    lsl r0, r0, #12
    blx Slots__f_itof
    mov r1, #0x3F
    lsl r1, r1, #24
    blx Slots__fsub
@@branch_2:
    blx Slots__f_ftoi
    mov r1, #1
    lsl r1, r1, #16
    blx Slots_FX_Div
    str r0, [r4, #0x14]
    mov r0, #0x10
    ldsh r1, [r4, r0]
    mov r0, #0xC
    ldsh r0, [r4, r0]
    sub r0, r1, r0
    cmp r0, #0
    ble @@branch_3
    lsl r0, r0, #12
    blx Slots__f_itof
    mov r1, r0
    mov r0, #0x3F
    lsl r0, r0, #24
    blx Slots__fadd
    b @@branch_4
@@branch_3:
    lsl r0, r0, #12
    blx Slots__f_itof
    mov r1, #0x3F
    lsl r1, r1, #24
    blx Slots__fsub
@@branch_4:
    blx Slots__f_ftoi
    mov r1, #1
    lsl r1, r1, #16
    blx Slots_FX_Div
    str r0, [r4, #0x18]
    mov r0, #0x10
    strb r0, [r4, #8]
    add r0, r7, #3
    lsl r0, r0, #2
    add r1, r5, r0
    mov r0, #0x7B
    lsl r0, r0, #2
    ldr r0, [r1, r0]
    add r6, #0xD
    mov r1, r6
    str r0, [r4, #0x28]
    bl Slots_Sprite_SetAnimCtrlSeq
    add r1, sp, #8
    ldrb r1, [r1, #0x14]
    ldr r0, [r4, #0x28]
    bl Slots_Sprite_SetDrawPriority
    mov r0, #0xA
    ldsh r0, [r4, r0]
    cmp r0, #0
    ble @@branch_5
    lsl r0, r0, #12
    blx Slots__f_itof
    mov r1, r0
    mov r0, #0x3F
    lsl r0, r0, #24
    blx Slots__fadd
    b @@branch_6
@@branch_5:
    lsl r0, r0, #12
    blx Slots__f_itof
    mov r1, #0x3F
    lsl r1, r1, #24
    blx Slots__fsub
@@branch_6:
    blx Slots__f_ftoi
    str r0, [r4, #0x1C]
    mov r0, #0xC
    ldsh r0, [r4, r0]
    cmp r0, #0
    ble @@branch_7
    lsl r0, r0, #12
    blx Slots__f_itof
    mov r1, r0
    mov r0, #0x3F
    lsl r0, r0, #24
    blx Slots__fadd
    b @@branch_8
@@branch_7:
    lsl r0, r0, #12
    blx Slots__f_itof
    mov r1, #0x3F
    lsl r1, r1, #24
    blx Slots__fsub
@@branch_8:
    blx Slots__f_ftoi
    str r0, [r4, #0x20]
    mov r0, #0
    str r0, [r4, #0x24]
    mov r1, r4
    ldr r0, [r4, #0x28]
    add r1, #0x1C
    bl Slots_Sprite_SetMatrix
    ldr r0, [r4, #0x28]
    mov r1, #1
    bl Slots_Sprite_SetDrawFlag
    ldr r1, [sp, #0x20]
    str r1, [r4]
    cmp r1, #0
    beq @@branch_9
    ldr r0, [r1]
    add r0, r0, #1
    str r0, [r1]
@@branch_9:
    ldr r0, [@@pool_1]
    mov r1, r4
    mov r2, #8
    bl Slots_SysTask_CreateOnMainQueue
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_ov77_021E8B14+1

Slots_ov77_021E8B14:
    push {r3-r5, lr}
    mov r4, r1
    mov r5, r0
    ldrh r0, [r4, #4]
    cmp r0, #0
    beq @@branch_1
    cmp r0, #1
    beq @@branch_2
    cmp r0, #2
    b @@branch_3
@@branch_1:
    ldr r2, [r4, #0x1C]
    ldr r0, [r4, #0x14]
    add r1, #0x1C
    add r0, r2, r0
    str r0, [r4, #0x1C]
    ldr r2, [r4, #0x20]
    ldr r0, [r4, #0x18]
    add r0, r2, r0
    str r0, [r4, #0x20]
    ldr r0, [r4, #0x28]
    bl Slots_Sprite_SetMatrix
    ldrb r0, [r4, #8]
    sub r0, r0, #1
    strb r0, [r4, #8]
    ldrb r0, [r4, #8]
    cmp r0, #0
    bne @@branch_5
    mov r1, #0xE
    mov r2, #0x10
    ldsh r1, [r4, r1]
    ldsh r2, [r4, r2]
    ldr r0, [r4, #0x28]
    bl Slots_Sprite_SetPositionXY
    mov r0, #0xF
    strb r0, [r4, #8]
    ldrh r0, [r4, #4]
    add r0, r0, #1
    strh r0, [r4, #4]
    pop {r3-r5, pc}
@@branch_2:
    ldrb r0, [r4, #8]
    sub r0, r0, #1
    strb r0, [r4, #8]
    ldrb r0, [r4, #8]
    cmp r0, #0
    bne @@branch_5
    ldrh r0, [r4, #4]
    add r0, r0, #1
    strh r0, [r4, #4]
    pop {r3-r5, pc}
@@branch_3:
    ldr r0, [r4, #0x28]
    mov r1, #0
    bl Slots_Sprite_SetDrawFlag
    ldr r1, [r4]
    cmp r1, #0
    beq @@branch_4
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1]
@@branch_4:
    mov r0, r4
    bl Slots_Heap_Free
    mov r0, r5
    bl Slots_SysTask_Destroy
@@branch_5:
    pop {r3-r5, pc}

Slots_ov77_021E8B9C:
    push {r3-r7, lr}
    sub sp, #0x18
    mov r1, #0x4D
    ldsb r1, [r0, r1]
    str r0, [sp, #0xC]
    cmp r1, #0
    beq @@branch_6
    bge @@branch_1
    mov r0, #0
    str r0, [sp, #0x14]
    neg r1, r1
    b @@branch_2
@@branch_1:
    mov r0, #1
    str r0, [sp, #0x14]
@@branch_2:
    sub r0, r1, #1
    mov r1, #3
    blx Slots__s32_div_f
    add r7, r0, #1
    cmp r7, #5
    ble @@branch_3
    mov r7, #5
@@branch_3:
    mov r4, #0
    cmp r7, #0
    ble @@branch_5
    sub r0, r7, #1
    lsl r1, r0, #2
    ldr r0, [@@pool_1]
    ldr r5, [r0, r1]
    ldr r0, [sp, #0xC]
    str r0, [sp, #0x10]
    add r0, #0x34
    str r0, [sp, #0x10]
@@branch_4:
    lsl r0, r5, #24
    lsr r1, r0, #24
    lsl r0, r1, #1
    add r6, r1, r0
    ldr r0, [@@pool_2]
    ldr r3, [@@pool_2]
    add r1, r0, r6
    ldrb r0, [r1, #1]
    mov r2, r4
    str r0, [sp]
    ldrb r0, [r1, #2]
    ldr r1, [sp, #0x14]
    str r0, [sp, #4]
    ldr r0, [sp, #0x10]
    str r0, [sp, #8]
    ldrb r3, [r3, r6]
    ldr r0, [sp, #0xC]
    bl Slots_ov77_021E89B4
    add r4, r4, #1
    add r5, r5, #1
    cmp r4, r7
    blt @@branch_4
@@branch_5:
    ldr r0, [@@pool_3]
    bl Slots_PlaySE
@@branch_6:
    add sp, #0x18
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA020
@@pool_2:
    .word Slots_ov77_021EA054
@@pool_3:
    .word 0x00000939

Slots_ov77_021E8C24:
    push {r4-r6, lr}
    sub sp, #0x20
    ldr r5, [@@pool_1]
    add r3, sp, #0
    mov r6, r0
    mov r4, r1
    mov r2, r3
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    ldmia r5!, {r0-r1}
    stmia r3!, {r0-r1}
    add r1, r4, #1
    lsl r1, r1, #2
    ldr r1, [r2, r1]
    mov r0, r6
    blx Slots__u32_div_f
    mov r0, r1
    lsl r2, r4, #2
    add r1, sp, #0
    ldr r1, [r1, r2]
    blx Slots__u32_div_f
    add sp, #0x20
    pop {r4-r6, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA034

Slots_ov77_021E8C64:
    push {r3-r7, lr}
    mov r5, r0
    ldr r7, [@@pool_1]
    mov r6, #0
    mov r4, r5
@@branch_1:
    ldr r0, [r5, #0x6C]
    lsl r0, r0, #31
    lsr r0, r0, #31
    beq @@branch_2
    mov r0, r5
    add r0, #0x3D
    ldrb r0, [r0]
    ldrb r1, [r7, r0]
    b @@branch_3
@@branch_2:
    bl Slots_LCRandom
    mov r1, #0x15
    blx Slots__s32_div_f
@@branch_3:
    mov r0, r4
    add r0, #0x66
    strh r1, [r0]
    mov r0, #0x18
    mov r2, r1
    mul r2, r0
    mov r0, #0x7E
    lsl r0, r0, #2
    sub r1, r0, r2
    mov r0, r4
    add r0, #0x5A
    strh r1, [r0]
    mov r1, r4
    add r1, #0x60
    mov r0, #0
    add r6, r6, #1
    add r4, r4, #2
    strh r0, [r1]
    cmp r6, #3
    blt @@branch_1
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_ov77_021EA110

Slots_ov77_021E8CB8:
    push {r4-r7, lr}
    sub sp, #0x14
    mov r7, r0
    mov r0, #0
    str r0, [sp, #8]
    str r0, [sp, #4]
    mov r0, #0x28
    str r0, [sp]
@@branch_1:
    ldr r0, [sp]
    mov r4, #0
    lsl r0, r0, #16
    asr r0, r0, #16
    mov r5, #0x58
    str r0, [sp, #0x10]
@@branch_2:
    ldr r2, [sp, #8]
    mov r0, r7
    mov r1, r4
    bl Slots_ov77_021E9290
    str r0, [sp, #0xC]
    ldr r0, [sp, #4]
    lsl r1, r5, #16
    add r0, r4, r0
    lsl r0, r0, #2
    add r6, r7, r0
    mov r0, #0x92
    lsl r0, r0, #2
    ldr r0, [r6, r0]
    ldr r2, [sp, #0x10]
    asr r1, r1, #16
    bl Slots_Sprite_SetPositionXY
    mov r0, #0x92
    lsl r0, r0, #2
    ldr r1, [sp, #0xC]
    ldr r0, [r6, r0]
    add r1, r1, #3
    bl Slots_Sprite_SetAnimCtrlSeq
    mov r0, #0x92
    lsl r0, r0, #2
    ldr r0, [r6, r0]
    mov r1, #0
    bl Slots_Sprite_SetAnimationFrame
    add r4, r4, #1
    add r5, #0x28
    cmp r4, #3
    blt @@branch_2
    ldr r0, [sp, #4]
    add r0, r0, #3
    str r0, [sp, #4]
    ldr r0, [sp]
    add r0, #0x18
    str r0, [sp]
    ldr r0, [sp, #8]
    add r0, r0, #1
    str r0, [sp, #8]
    cmp r0, #5
    blt @@branch_1
    add sp, #0x14
    pop {r4-r7, pc}

Slots_ov77_021E8D34:
    push {r3-r7, lr}
    mov r7, r0
    mov r6, r7
    mov r4, #0
    mov r5, r7
    add r6, #0xA4
@@branch_1:
    mov r1, r5
    add r1, #0xA4
    mov r0, #0
    str r0, [r1]
    mov r0, r5
    add r0, #0xB4
    str r4, [r0]
    mov r0, r5
    add r0, #0xBC
    str r7, [r0]
    ldr r0, [@@pool_1]
    mov r1, r6
    mov r2, r4
    bl Slots_SysTask_CreateOnMainQueue
    mov r1, r5
    add r1, #0xB8
    add r4, r4, #1
    str r0, [r1]
    add r5, #0x1C
    add r6, #0x1C
    cmp r4, #3
    blt @@branch_1
    mov r0, #0xC
    add r7, #0x4E
    strb r0, [r7]
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021E8F48+1

Slots_ov77_021E8D7C:
    push {r3-r5, lr}
    mov r5, r0
    mov r4, #0
@@branch_1:
    mov r0, r5
    add r0, #0xB8
    ldr r0, [r0]
    bl Slots_SysTask_Destroy
    add r4, r4, #1
    add r5, #0x1C
    cmp r4, #3
    blt @@branch_1
    pop {r3-r5, pc}
    .align 4

Slots_ov77_021E8D98:
    mov r2, #0x1C
    mov r3, r1
    mul r3, r2
    add r1, r0, r3
    add r0, r0, r3
    mov r2, #1
    add r1, #0xA4
    str r2, [r1]
    add r0, #0xAE
    strb r2, [r0]
    bx lr
    .align 4

Slots_ov77_021E8DB0:
    push {r3-r7, lr}
    mov r5, r0
    ldr r0, [r5, #0x6C]
    lsl r0, r0, #31
    lsr r0, r0, #31
    beq @@branch_2
    ldr r7, [@@pool_1]
    mov r6, #0
    mov r4, r5
@@branch_1:
    mov r0, r5
    add r0, #0x3B
    ldrb r0, [r0]
    mov r1, #0x15
    ldrb r0, [r7, r0]
    add r0, r0, #2
    blx Slots__s32_div_f
    mov r0, r4
    add r0, #0xAF
    strb r1, [r0]
    mov r0, r5
    add r0, #0x3B
    ldrb r1, [r0]
    lsl r0, r1, #3
    add r0, r1, r0
    add r0, #0xA
    add r1, r6, r0
    mov r0, r4
    add r0, #0xB0
    add r6, r6, #1
    add r4, #0x1C
    str r1, [r0]
    cmp r6, #3
    blt @@branch_1
    pop {r3-r7, pc}
@@branch_2:
    mov r0, r5
    add r0, #0x3B
    ldrb r0, [r0]
    cmp r0, #0
    bne @@branch_4
    mov r0, r5
    add r0, #0x3C
    ldrb r0, [r0]
    cmp r0, #0
    bne @@branch_3
    mov r0, #2
    bl Slots_ov77_021E7128
    add r0, r0, #5
    bl Slots_ov77_021E95A0
    b @@branch_5
@@branch_3:
    mov r0, #6
    b @@branch_5
@@branch_4:
    bl Slots_ov77_021E95A0
@@branch_5:
    mov r2, #0
@@branch_6:
    mov r1, r5
    add r1, #0xB0
    add r2, r2, #1
    add r5, #0x1C
    str r0, [r1]
    cmp r2, #3
    blt @@branch_6
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA110

Slots_ov77_021E8E38:
    mov r2, #0x1C
    mul r2, r1
    add r0, r0, r2
    mov r3, #2
    add r0, #0xA4
    str r3, [r0]
    bx lr
    .align 4

Slots_ov77_021E8E48:
    push {r3-r7, lr}
    sub sp, #0x28
    str r0, [sp, #8]
    str r1, [sp, #0xC]
    str r2, [sp, #0x10]
    str r3, [sp, #0x14]
    mov r5, #0
    mov r6, #1
@@branch_1:
    mov r0, r6
    bl Slots_ov77_021E95A0
    mov r7, r0
    cmp r6, #4
    bne @@branch_4
    ldr r0, [sp, #0xC]
    cmp r0, #0
    beq @@branch_7
    ldr r0, [sp, #0x14]
    lsl r1, r5, #2
    add r0, r0, r1
    str r0, [sp, #0x18]
    ldr r0, [sp, #0xC]
    mov r4, #0
    add r0, r0, #1
    str r0, [sp, #0x20]
@@branch_2:
    ldr r0, [sp, #0x20]
    mov r1, r4
    str r0, [sp]
    mov r0, #0
    str r0, [sp, #4]
    ldr r0, [sp, #8]
    mov r2, r7
    mov r3, #1
    bl Slots_ov77_021E93B0
    cmp r0, #0
    beq @@branch_3
    ldr r0, [sp, #0x18]
    mov r1, r5
    stmia r0!, {r4}
    str r0, [sp, #0x18]
    ldr r0, [sp, #0x10]
    lsl r1, r1, #2
    add r5, r5, #1
    str r6, [r0, r1]
@@branch_3:
    add r4, r4, #1
    cmp r4, #2
    ble @@branch_2
    b @@branch_7
@@branch_4:
    ldr r0, [sp, #0x14]
    lsl r1, r5, #2
    add r0, r0, r1
    str r0, [sp, #0x1C]
    ldr r0, [sp, #0xC]
    mov r4, #0
    add r0, r0, #1
    str r0, [sp, #0x24]
@@branch_5:
    ldr r0, [sp, #0x24]
    ldr r3, [sp, #0xC]
    str r0, [sp]
    mov r0, #0
    str r0, [sp, #4]
    ldr r0, [sp, #8]
    mov r1, r4
    mov r2, r7
    add r3, r3, #2
    bl Slots_ov77_021E93B0
    cmp r0, #0
    beq @@branch_6
    ldr r0, [sp, #0x1C]
    mov r1, r5
    stmia r0!, {r4}
    str r0, [sp, #0x1C]
    ldr r0, [sp, #0x10]
    lsl r1, r1, #2
    add r5, r5, #1
    str r6, [r0, r1]
@@branch_6:
    add r4, r4, #1
    cmp r4, #5
    blt @@branch_5
@@branch_7:
    add r6, r6, #1
    cmp r6, #6
    ble @@branch_1
    mov r0, r5
    add sp, #0x28
    pop {r3-r7, pc}
    .align 4

Slots_ov77_021E8EF8:
    push {r4, lr}
    mov r4, r0
    mov r2, r1
    mov r1, r4
    add r1, #0x3B
    ldrb r1, [r1]
    add r2, r2, #2
    mov r3, #0
    bl Slots_ov77_021E941C
    cmp r0, #0
    beq @@branch_1
    add r4, #0x3B
    ldrb r0, [r4]
    pop {r4, pc}
@@branch_1:
    mov r0, #0
    mvn r0, r0
    pop {r4, pc}

Slots_ov77_021E8F1C:
    push {r3-r7, lr}
    mov r7, r0
    mov r5, r7
    mov r6, #0
    mov r4, r7
    add r5, #0xA4
@@branch_1:
    mov r0, r4
    add r0, #0xAE
    ldrb r0, [r0]
    cmp r0, #0
    beq @@branch_2
    mov r0, r5
    mov r1, r7
    bl Slots_ov77_021E91E8
@@branch_2:
    add r6, r6, #1
    add r4, #0x1C
    add r5, #0x1C
    cmp r6, #3
    blt @@branch_1
    pop {r3-r7, pc}
    .align 4

Slots_ov77_021E8F48:
    push {r4-r6, lr}
    mov r5, r1
    ldr r4, [r5, #0x18]
    ldr r6, [@@pool_1]
@@branch_1:
    ldr r2, [r5]
    mov r0, r5
    lsl r2, r2, #2
    ldr r2, [r6, r2]
    mov r1, r4
    blx r2
    cmp r0, #1
    beq @@branch_1
    pop {r4-r6, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA0A8

Slots_ov77_021E8F68:
    mov r0, #0
    bx lr

Slots_ov77_021E8F6C:
    push {r3, lr}
    mov r2, r0
    mov r0, r1
    ldr r1, [r2, #0x10]
    mov r2, r0
    add r2, #0x4E
    ldrb r2, [r2]
    bl Slots_ov77_021E9150
    mov r0, #0
    pop {r3, pc}
    .align 4

Slots_ov77_021E8F84:
    mov r2, #8
    ldsh r2, [r0, r2]
    cmp r2, #0x15
    blt @@branch_1
    mov r0, #1
    bx lr
@@branch_1:
    ldr r3, [r1, #0x6C]
    lsl r3, r3, #31
    lsr r3, r3, #31
    beq @@branch_2
    ldr r0, [r0, #0x10]
    add r0, r1, r0
    add r0, #0x50
    ldrb r0, [r0]
    cmp r0, #0
    bne @@branch_7
    add r1, #0x4F
    ldrb r1, [r1]
    ldr r0, [@@pool_1]
    ldrb r0, [r0, r1]
    cmp r2, r0
    ble @@branch_7
    mov r0, #1
    bx lr
@@branch_2:
    mov r3, r1
    add r3, #0x3B
    ldrb r3, [r3]
    cmp r3, #0
    bne @@branch_3
    ldr r3, [r0, #0x10]
    cmp r3, #2
    bne @@branch_3
    mov r0, #0
    bx lr
@@branch_3:
    add r1, #0x3C
    ldrb r3, [r1]
    cmp r3, #0
    bne @@branch_4
    ldr r1, [r0, #0x10]
    cmp r1, #2
    bge @@branch_4
    mov r0, #0
    bx lr
@@branch_4:
    cmp r3, #1
    bne @@branch_5
    cmp r2, #4
    ble @@branch_5
    mov r0, #1
    bx lr
@@branch_5:
    cmp r3, #2
    beq @@branch_6
    mov r0, #0
    bx lr
@@branch_6:
    ldr r0, [r0, #0x10]
    cmp r0, #0
    bne @@branch_7
    cmp r2, #4
    ble @@branch_7
    mov r0, #1
    bx lr
@@branch_7:
    mov r0, #0
    bx lr
@@pool_1:
    .word Slots_ov77_021EA10C

Slots_ov77_021E9004:
    push {r3-r5, lr}
    mov r4, r1
    mov r5, r0
    ldr r0, [r4, #0x6C]
    ldr r1, [r5, #0x10]
    lsl r0, r0, #31
    lsr r0, r0, #31
    beq @@branch_1
    mov r0, r4
    mov r1, r5
    bl Slots_ov77_021E9714
    mov r0, r5
    mov r1, r4
    bl Slots_ov77_021E8F84
    cmp r0, #0
    beq @@branch_6
    mov r0, #8
    ldsh r0, [r5, r0]
    cmp r0, #0x15
    blt @@branch_6
    mov r0, #0
    strh r0, [r5, #8]
    b @@branch_6
@@branch_1:
    cmp r1, #0
    beq @@branch_2
    cmp r1, #1
    beq @@branch_3
    cmp r1, #2
    beq @@branch_4
    b @@branch_5
@@branch_2:
    mov r0, r4
    mov r1, r5
    bl Slots_ov77_021E95A4
    b @@branch_5
@@branch_3:
    mov r0, r4
    mov r1, r5
    bl Slots_ov77_021E95F0
    b @@branch_5
@@branch_4:
    mov r0, r4
    mov r1, r5
    bl Slots_ov77_021E96B8
@@branch_5:
    mov r0, r5
    mov r1, r4
    bl Slots_ov77_021E8F84
    cmp r0, #0
    beq @@branch_6
    mov r0, #8
    ldsh r0, [r5, r0]
    cmp r0, #0x15
    blt @@branch_6
    mov r0, #0
    strh r0, [r5, #8]
@@branch_6:
    mov r0, #3
    str r0, [r5]
    mov r0, #1
    pop {r3-r5, pc}

Slots_ov77_021E9080:
    push {r3-r7, lr}
    mov r5, r0
    ldr r0, [r5, #0x10]
    mov r4, r1
    str r0, [sp]
    add r1, #0x5A
    lsl r0, r0, #1
    add r7, r1, r0
    ldsh r0, [r1, r0]
    mov r1, #0x18
    mov r6, #0
    blx Slots__s32_div_f
    mov r2, r1
    beq @@branch_2
    mov r0, r4
    add r0, #0x4E
    ldrb r0, [r0]
    cmp r2, r0
    blt @@branch_1
    mov r2, r0
@@branch_1:
    ldr r1, [sp]
    mov r0, r4
    bl Slots_ov77_021E91AC
    mov r2, r0
    mov r6, #1
    b @@branch_3
@@branch_2:
    mov r0, #8
    ldsh r0, [r5, r0]
    cmp r0, #0
    beq @@branch_3
    sub r0, r0, #1
    strh r0, [r5, #8]
    mov r0, r4
    add r4, #0x4E
    ldrb r2, [r4]
    ldr r1, [sp]
    bl Slots_ov77_021E9150
    mov r0, r6
    ldsh r0, [r7, r0]
    mov r1, #0x18
    blx Slots__s32_div_f
    mov r2, r1
    mov r6, #1
@@branch_3:
    cmp r2, #0
    bne @@branch_4
    mov r0, #8
    ldsh r0, [r5, r0]
    cmp r0, #0
    bne @@branch_4
    mov r0, #3
    strh r0, [r5, #6]
    mov r0, #0
    strh r0, [r5, #4]
    mov r0, #4
    str r0, [r5]
    ldr r0, [@@pool_1]
    bl Slots_PlaySE
    cmp r6, #0
    bne @@branch_4
    mov r0, #1
    pop {r3-r7, pc}
@@branch_4:
    mov r0, #0
    pop {r3-r7, pc}
@@pool_1:
    .word 0x00000625

Slots_ov77_021E910C:
    push {r4-r5}
    ldr r2, [r0, #0x10]
    mov r4, #6
    lsl r3, r2, #1
    ldsh r2, [r0, r4]
    add r1, #0x60
    strh r2, [r1, r3]
    ldsh r5, [r0, r4]
    sub r4, r4, #7
    add r2, r0, #6
    mul r4, r5
    strh r4, [r0, #6]
    ldrh r5, [r0, #4]
    add r4, r5, #1
    strh r4, [r0, #4]
    mov r4, #1
    tst r4, r5
    beq @@branch_1
    mov r4, #0
    ldsh r4, [r2, r4]
    sub r4, r4, #1
    strh r4, [r2]
@@branch_1:
    mov r2, #6
    ldsh r2, [r0, r2]
    cmp r2, #0
    bne @@branch_2
    mov r2, #0
    str r2, [r0]
    strb r2, [r0, #0xA]
    strh r2, [r1, r3]
@@branch_2:
    mov r0, #0
    pop {r4-r5}
    bx lr
    .align 4

Slots_ov77_021E9150:
    push {r3-r7, lr}
    mov r7, r0
    add r0, r7, r1
    add r0, #0x53
    ldrb r0, [r0]
    cmp r0, #0
    beq @@branch_1
    lsl r5, r1, #1
    mov r1, r7
    add r1, #0x5A
    ldsh r0, [r1, r5]
    add r6, r1, r5
    sub r0, r0, r2
    strh r0, [r1, r5]
    ldsh r1, [r1, r5]
    cmp r1, #0
    bge @@branch_2
    mov r0, #0x7E
    lsl r0, r0, #2
    add r0, r1, r0
    strh r0, [r6]
    b @@branch_2
@@branch_1:
    mov r4, r7
    lsl r5, r1, #1
    add r4, #0x5A
    ldsh r0, [r4, r5]
    mov r1, #0x7E
    lsl r1, r1, #2
    add r0, r0, r2
    strh r0, [r4, r5]
    ldsh r0, [r4, r5]
    add r6, r4, r5
    blx Slots__s32_div_f
    strh r1, [r4, r5]
@@branch_2:
    mov r0, #0
    ldsh r0, [r6, r0]
    mov r1, #0x18
    blx Slots__s32_div_f
    mov r1, #0x15
    sub r1, r1, r0
    add r0, r7, r5
    add r0, #0x66
    strh r1, [r0]
    pop {r3-r7, pc}

Slots_ov77_021E91AC:
    push {r3-r7, lr}
    mov r7, r0
    mov r5, r1
    mov r1, r7
    add r1, #0x5A
    lsl r0, r5, #1
    add r6, r1, r0
    ldsh r0, [r1, r0]
    mov r1, #0x18
    mov r4, r2
    blx Slots__s32_div_f
    cmp r1, #0
    beq @@branch_2
    cmp r1, r4
    bge @@branch_1
    mov r4, r1
@@branch_1:
    mov r0, r7
    mov r1, r5
    mov r2, r4
    bl Slots_ov77_021E9150
    mov r0, #0
    ldsh r0, [r6, r0]
    mov r1, #0x18
    blx Slots__s32_div_f
@@branch_2:
    mov r0, r1
    pop {r3-r7, pc}
    .align 4

Slots_ov77_021E91E8:
    push {r3-r7, lr}
    sub sp, #0x18
    ldr r0, [r0, #0x10]
    str r1, [sp]
    str r0, [sp, #8]
    ldr r7, [sp, #8]
    mov r0, #0
    str r0, [sp, #0xC]
    mov r4, r0
    mov r0, r7
    lsl r1, r0, #1
    ldr r0, [sp]
    add r0, r0, r1
    str r0, [sp, #4]
    mov r1, #0x28
    mov r0, r7
    mul r1, r0
    add r1, #0x58
    lsl r0, r1, #16
    asr r0, r0, #16
    str r0, [sp, #0x10]
@@branch_1:
    ldr r1, [sp, #4]
    mov r0, #0x5A
    ldsh r0, [r1, r0]
    mov r1, #0x78
    add r0, r0, r4
    blx Slots__s32_div_f
    str r1, [sp, #0x14]
    ldr r6, [sp, #0x14]
    ldr r3, [sp, #4]
    mov r2, #0x60
    ldr r0, [sp]
    lsl r1, r7, #2
    add r5, r0, r1
    mov r0, #0x92
    lsl r0, r0, #2
    ldsh r2, [r3, r2]
    add r6, #0x28
    ldr r0, [r5, r0]
    add r2, r6, r2
    lsl r2, r2, #16
    ldr r1, [sp, #0x10]
    asr r2, r2, #16
    bl Slots_Sprite_SetPositionXY
    ldr r0, [sp, #0x14]
    mov r1, #0x18
    blx Slots__s32_div_f
    mov r2, r0
    ldr r0, [sp]
    ldr r1, [sp, #8]
    bl Slots_ov77_021E9290
    add r6, r0, #3
    mov r0, #0x92
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    bl Slots_Sprite_GetAnimationNumber
    cmp r6, r0
    beq @@branch_2
    mov r0, #0x92
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    mov r1, r6
    bl Slots_Sprite_SetAnimCtrlSeq
    mov r0, #0x92
    lsl r0, r0, #2
    ldr r0, [r5, r0]
    mov r1, #0
    bl Slots_Sprite_SetAnimationFrame
@@branch_2:
    ldr r0, [sp, #0xC]
    add r7, r7, #3
    add r0, r0, #1
    add r4, #0x18
    str r0, [sp, #0xC]
    cmp r0, #5
    blt @@branch_1
    add sp, #0x18
    pop {r3-r7, pc}

Slots_ov77_021E9290:
    push {r3-r5, lr}
    mov r4, r1
    mov r5, r0
    lsl r0, r4, #1
    add r1, r5, r0
    mov r0, #0x66
    ldsh r0, [r1, r0]
    mov r1, #0x15
    add r0, r2, r0
    blx Slots__s32_div_f
    cmp r1, #0
    bge @@branch_1
    add r1, #0x15
@@branch_1:
    ldr r0, [r5, #0x6C]
    lsl r0, r0, #31
    lsr r0, r0, #31
    beq @@branch_2
    mov r0, #0x54
    mov r2, r4
    mul r2, r0
    ldr r0, [@@pool_1]
    lsl r1, r1, #2
    add r0, r0, r2
    ldr r0, [r1, r0]
    pop {r3-r5, pc}
@@branch_2:
    mov r0, #0x54
    mov r2, r4
    mul r2, r0
    ldr r0, [@@pool_2]
    lsl r1, r1, #2
    add r0, r0, r2
    ldr r0, [r1, r0]
    pop {r3-r5, pc}
@@pool_1:
    .word Slots_ov77_021EA428
@@pool_2:
    .word Slots_ov77_021EA32C

Slots_ov77_021E92DC:
    push {r3-r7, lr}
    mov r6, r1
    mov r5, r0
    lsl r0, r6, #1
    add r1, r5, r0
    mov r0, #0x5A
    ldsh r0, [r1, r0]
    mov r1, #0x18
    mov r7, r2
    mov r4, #0
    blx Slots__s32_div_f
    cmp r1, #0
    beq @@branch_1
    add r0, r5, r6
    add r0, #0x53
    ldrb r0, [r0]
    cmp r0, #0
    bne @@branch_1
    sub r4, r4, #1
@@branch_1:
    mov r0, r5
    mov r1, r6
    add r2, r7, r4
    bl Slots_ov77_021E9290
    pop {r3-r7, pc}

Slots_ov77_021E9310:
    push {r3-r7, lr}
    mov r7, r0
    str r1, [sp]
    mov r5, r2
    mov r6, r3
    mov r4, #1
@@branch_1:
    sub r4, r4, #1
    add r2, r4, #1
    ldr r1, [sp]
    mov r0, r7
    add r2, r2, r5
    bl Slots_ov77_021E92DC
    cmp r0, r6
    bne @@branch_1
    neg r0, r4
    pop {r3-r7, pc}
    .align 4

Slots_ov77_021E9334:
    push {r3-r7, lr}
    sub sp, #8
    mov r7, r0
    mov r0, r1
    add r0, r7, r0
    add r0, #0x53
    ldrb r0, [r0]
    mov r4, #0
    mvn r4, r4
    str r1, [sp]
    str r2, [sp, #4]
    cmp r0, #0
    beq @@branch_1
    mov r6, #1
    b @@branch_2
@@branch_1:
    mov r6, r4
@@branch_2:
    neg r5, r6
@@branch_3:
    add r5, r5, r6
    ldr r1, [sp]
    mov r0, r7
    add r2, r5, #2
    add r4, r4, #1
    bl Slots_ov77_021E92DC
    ldr r1, [sp, #4]
    cmp r0, r1
    bne @@branch_3
    mov r0, r4
    add sp, #8
    pop {r3-r7, pc}

Slots_ov77_021E9370:
    push {r3-r7, lr}
    sub sp, #0x10
    str r3, [sp, #0xC]
    str r0, [sp]
    mov r5, #0
    ldr r0, [sp, #0xC]
    mov r4, r5
    str r1, [sp, #4]
    str r2, [sp, #8]
    ldr r6, [sp, #0x28]
    ldr r7, [sp, #0x2C]
    cmp r0, #0
    ble @@branch_3
@@branch_1:
    ldr r0, [sp]
    ldr r1, [sp, #4]
    sub r2, r6, r4
    bl Slots_ov77_021E92DC
    ldr r1, [sp, #8]
    cmp r0, r1
    bne @@branch_2
    lsl r0, r5, #2
    add r1, r4, #1
    add r5, r5, #1
    str r1, [r7, r0]
@@branch_2:
    ldr r0, [sp, #0xC]
    add r4, r4, #1
    cmp r4, r0
    blt @@branch_1
@@branch_3:
    mov r0, r5
    add sp, #0x10
    pop {r3-r7, pc}

Slots_ov77_021E93B0:
    push {r3-r7, lr}
    sub sp, #8
    mov r7, r0
    ldr r0, [sp, #0x20]
    mov r4, #0
    str r0, [sp, #0x20]
    ldr r0, [sp, #0x24]
    mov r6, r3
    str r2, [sp]
    str r0, [sp, #0x24]
    str r4, [sp, #4]
    cmp r6, #0
    ble @@branch_5
    mov r0, #6
    ldr r2, [@@pool_1]
    mul r0, r1
    add r5, r2, r0
@@branch_1:
    ldr r0, [sp, #0x20]
    cmp r4, r0
    bne @@branch_2
    ldrb r3, [r5, #1]
    ldr r2, [sp, #0x24]
    ldrb r1, [r5]
    mov r0, r7
    add r2, r2, r3
    bl Slots_ov77_021E92DC
    b @@branch_3
@@branch_2:
    ldrb r1, [r5]
    ldrb r2, [r5, #1]
    mov r0, r7
    bl Slots_ov77_021E92DC
@@branch_3:
    ldr r1, [sp]
    cmp r0, r1
    bne @@branch_4
    ldr r0, [sp, #4]
    add r0, r0, #1
    str r0, [sp, #4]
    cmp r0, r6
    bne @@branch_4
    add sp, #8
    mov r0, #1
    pop {r3-r7, pc}
@@branch_4:
    add r4, r4, #1
    add r5, r5, #2
    cmp r4, r6
    blt @@branch_1
@@branch_5:
    mov r0, #0
    add sp, #8
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA0E8

Slots_ov77_021E941C:
    push {r3-r7, lr}
    sub sp, #0x10
    mov r4, #0
    mov r6, r2
    mov r7, r0
    str r3, [sp]
    str r4, [sp, #8]
    cmp r6, #0
    ble @@branch_5
    lsl r0, r1, #3
    add r0, r1, r0
    str r0, [sp, #4]
    sub r0, r6, #1
    ldr r5, [@@pool_1]
    str r0, [sp, #0xC]
@@branch_1:
    ldr r0, [sp, #0xC]
    cmp r4, r0
    bne @@branch_2
    ldrb r3, [r5, #1]
    ldr r2, [sp]
    ldrb r1, [r5]
    mov r0, r7
    add r2, r2, r3
    bl Slots_ov77_021E92DC
    b @@branch_3
@@branch_2:
    ldrb r1, [r5]
    ldrb r2, [r5, #1]
    mov r0, r7
    bl Slots_ov77_021E92DC
@@branch_3:
    mov r2, r4
    ldr r1, [sp, #4]
    add r2, #0xA
    add r1, r2, r1
    cmp r0, r1
    bne @@branch_4
    ldr r0, [sp, #8]
    add r0, r0, #1
    str r0, [sp, #8]
    cmp r0, r6
    bne @@branch_4
    add sp, #0x10
    mov r0, #1
    pop {r3-r7, pc}
@@branch_4:
    add r4, r4, #1
    add r5, r5, #2
    cmp r4, r6
    blt @@branch_1
@@branch_5:
    mov r0, #0
    add sp, #0x10
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_ov77_021EA0A0

Slots_ov77_021E9488:
    push {r4-r7, lr}
    sub sp, #0xC
    str r0, [sp]
    ldr r0, [sp, #0x20]
    mov r6, #0
    str r1, [sp, #4]
    mov r7, r2
    str r3, [sp, #8]
    str r0, [sp, #0x20]
    mov r4, r6
    mov r5, r0
@@branch_1:
    ldr r2, [sp, #8]
    add r3, r4, #1
    ldr r0, [sp]
    ldr r1, [sp, #4]
    add r2, r3, r2
    bl Slots_ov77_021E92DC
    cmp r0, r7
    bne @@branch_3
    ldr r0, [sp, #0x20]
    cmp r0, #0
    beq @@branch_2
    str r4, [r5]
@@branch_2:
    add r5, r5, #4
    add r6, r6, #1
@@branch_3:
    add r4, r4, #1
    cmp r4, #3
    blt @@branch_1
    mov r0, r6
    add sp, #0xC
    pop {r4-r7, pc}

Slots_ov77_021E94C8:
    push {r3-r5, lr}
    sub sp, #8
    ldr r5, [sp, #0x18]
    mov r4, r0
    str r5, [sp]
    mov r5, r4
    lsl r3, r3, #16
    add r5, #0xF8
    lsr r3, r3, #16
    str r5, [sp, #4]
    bl Slots_ov77_021E9370
    cmp r0, #0
    bne @@branch_1
    add sp, #8
    mov r0, #0
    pop {r3-r5, pc}
@@branch_1:
    bl Slots_ov77_021E7128
    lsl r0, r0, #2
    add r0, r4, r0
    add r0, #0xF8
    ldr r0, [r0]
    add sp, #8
    pop {r3-r5, pc}
    .align 4

Slots_ov77_021E94FC:
    push {r4-r7, lr}
    sub sp, #0x14
    mov r6, #0
    str r0, [sp, #8]
    str r1, [sp, #0xC]
    mov r7, r2
    str r3, [sp, #0x10]
    mov r4, r6
    mov r5, r3
@@branch_1:
    mov r0, #1
    str r0, [sp]
    ldr r0, [sp, #8]
    ldr r2, [sp, #0xC]
    mov r1, r4
    mov r3, #2
    str r7, [sp, #4]
    bl Slots_ov77_021E93B0
    cmp r0, #0
    beq @@branch_3
    ldr r0, [sp, #0x10]
    cmp r0, #0
    beq @@branch_2
    str r4, [r5]
@@branch_2:
    add r5, r5, #4
    add r6, r6, #1
@@branch_3:
    add r4, r4, #1
    cmp r4, #5
    blt @@branch_1
    mov r0, r6
    add sp, #0x14
    pop {r4-r7, pc}

Slots_ov77_021E953C:
    push {r3-r7, lr}
    sub sp, #8
    mov r4, r1
    mov r7, r0
    mov r6, r2
    cmp r4, #3
    bne @@branch_3
    mov r5, #0
@@branch_1:
    mov r0, #2
    str r0, [sp]
    mov r0, r7
    mov r1, r5
    mov r2, r4
    mov r3, #1
    str r6, [sp, #4]
    bl Slots_ov77_021E93B0
    cmp r0, #0
    beq @@branch_2
    add sp, #8
    mov r0, #1
    pop {r3-r7, pc}
@@branch_2:
    add r5, r5, #1
    cmp r5, #2
    ble @@branch_1
    add sp, #8
    mov r0, #0
    pop {r3-r7, pc}
@@branch_3:
    mov r5, #0
@@branch_4:
    mov r0, #2
    str r0, [sp]
    mov r0, r7
    mov r1, r5
    mov r2, r4
    mov r3, #3
    str r6, [sp, #4]
    bl Slots_ov77_021E93B0
    cmp r0, #0
    beq @@branch_5
    add sp, #8
    mov r0, #1
    pop {r3-r7, pc}
@@branch_5:
    add r5, r5, #1
    cmp r5, #5
    blt @@branch_4
    mov r0, #0
    add sp, #8
    pop {r3-r7, pc}
    .align 4

Slots_ov77_021E95A0:
    sub r0, r0, #1
    bx lr

Slots_ov77_021E95A4:
    push {r4, lr}
    mov r4, r1
    mov r1, r0
    add r1, #0x3B
    ldrb r1, [r1]
    cmp r1, #0
    bne @@branch_1
    mov r1, r0
    add r1, #0x3C
    ldrb r1, [r1]
    cmp r1, #0
    beq @@branch_2
    bl Slots_ov77_021E9734
    strh r0, [r4, #8]
    pop {r4, pc}
@@branch_1:
    cmp r1, #4
    bne @@branch_2
    ldr r1, [r4, #0xC]
    bl Slots_ov77_021E975C
    strh r0, [r4, #8]
    pop {r4, pc}
@@branch_2:
    mov r1, r0
    add r1, #0x3C
    ldrb r1, [r1]
    cmp r1, #0
    ldr r1, [r4, #0xC]
    bne @@branch_3
    bl Slots_ov77_021E97A4
    strh r0, [r4, #8]
    pop {r4, pc}
@@branch_3:
    bl Slots_ov77_021E9854
    strh r0, [r4, #8]
    pop {r4, pc}
    .align 4

Slots_ov77_021E95F0:
    push {r4, lr}
    mov r4, r1
    mov r1, r0
    add r1, #0x3B
    ldrb r1, [r1]
    cmp r1, #0
    bne @@branch_4
    mov r1, r0
    add r1, #0x3C
    ldrb r1, [r1]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #1
    beq @@branch_2
    cmp r1, #2
    b @@branch_3
@@branch_1:
    ldr r1, [r4, #0xC]
    bl Slots_ov77_021E9A40
    strh r0, [r4, #8]
    pop {r4, pc}
@@branch_2:
    bl Slots_ov77_021E9A14
    strh r0, [r4, #8]
    pop {r4, pc}
@@branch_3:
    mov r0, #0
    strh r0, [r4, #8]
    pop {r4, pc}
@@branch_4:
    cmp r1, #4
    bne @@branch_5
    bl Slots_ov77_021E9A14
    strh r0, [r4, #8]
    pop {r4, pc}
@@branch_5:
    mov r1, r0
    add r1, #0x3C
    ldrb r1, [r1]
    cmp r1, #0
    ldr r1, [r4, #0xC]
    bne @@branch_6
    bl Slots_ov77_021E9A40
    strh r0, [r4, #8]
    pop {r4, pc}
@@branch_6:
    bl Slots_ov77_021E9AB0
    strh r0, [r4, #8]
    pop {r4, pc}

Slots_ov77_021E9650:
    push {r3-r7, lr}
    sub sp, #8
    mov r6, r0
    add r0, #0x3B
    ldrb r0, [r0]
    mov r7, r1
    mov r5, #0
    cmp r0, #0
    bne @@branch_1
    add sp, #8
    mov r0, r5
    pop {r3-r7, pc}
@@branch_1:
    add r0, sp, #0
    mov r1, r5
    mov r2, #5
    blx Slots_MI_CpuFill8
    mov r4, r5
@@branch_2:
    mov r2, #8
    ldsh r2, [r7, r2]
    mov r0, r6
    mov r1, r4
    neg r2, r2
    bl Slots_ov77_021E953C
    cmp r0, #0
    beq @@branch_3
    add r1, r4, #1
    add r0, sp, #0
    strb r1, [r0, r5]
    add r5, r5, #1
@@branch_3:
    add r4, r4, #1
    cmp r4, #5
    ble @@branch_2
    cmp r5, #1
    bne @@branch_4
    add r0, sp, #0
    add r6, #0x3B
    ldrb r1, [r0]
    ldrb r0, [r6]
    cmp r1, r0
    beq @@branch_5
    add sp, #8
    mov r0, #1
    pop {r3-r7, pc}
@@branch_4:
    ble @@branch_5
    add sp, #8
    mov r0, #1
    pop {r3-r7, pc}
@@branch_5:
    mov r0, #0
    add sp, #8
    pop {r3-r7, pc}

Slots_ov77_021E96B8:
    push {r3-r5, lr}
    mov r5, r0
    mov r4, r1
    mov r1, r5
    add r1, #0x3B
    ldrb r1, [r1]
    cmp r1, #0
    beq @@branch_1
    cmp r1, #4
    bne @@branch_2
@@branch_1:
    mov r0, r5
    bl Slots_ov77_021E9BE4
    strh r0, [r4, #8]
    b @@branch_5
@@branch_2:
    cmp r1, #6
    beq @@branch_3
    cmp r1, #5
    beq @@branch_3
    mov r1, r5
    add r1, #0x3C
    ldrb r1, [r1]
    cmp r1, #0
    beq @@branch_4
@@branch_3:
    ldr r1, [r4, #0xC]
    mov r0, r5
    bl Slots_ov77_021E9C30
    strh r0, [r4, #8]
    b @@branch_5
@@branch_4:
    ldr r1, [r4, #0xC]
    bl Slots_ov77_021E9C14
    strh r0, [r4, #8]
@@branch_5:
    mov r0, r5
    mov r1, r4
    bl Slots_ov77_021E9650
    cmp r0, #0
    beq @@branch_6
    mov r0, r5
    bl Slots_ov77_021E9BE4
    strh r0, [r4, #8]
@@branch_6:
    pop {r3-r5, pc}
    .align 4

Slots_ov77_021E9714:
    push {r4, lr}
    mov r4, r1
    ldr r2, [r4, #0x10]
    add r2, r0, r2
    add r2, #0x50
    ldrb r2, [r2]
    cmp r2, #0
    beq @@branch_1
    bl Slots_ov77_021E9D08
    strh r0, [r4, #8]
    pop {r4, pc}
@@branch_1:
    bl Slots_ov77_021E9D18
    strh r0, [r4, #8]
    pop {r4, pc}

Slots_ov77_021E9734:
    push {r3-r7, lr}
    sub sp, #0x10
    mov r5, r0
    mov r4, #1
    add r6, sp, #4
    mov r7, #0
@@branch_1:
    sub r4, r4, #1
    mov r0, r5
    mov r1, r7
    mov r2, #3
    mov r3, r4
    str r6, [sp]
    bl Slots_ov77_021E9488
    cmp r0, #0
    bne @@branch_1
    neg r0, r4
    add sp, #0x10
    pop {r3-r7, pc}
    .align 4

Slots_ov77_021E975C:
    push {r3-r5, lr}
    sub sp, #8
    mov r4, r1
    mov r1, #0
    mov r2, r4
    add r3, sp, #0
    mov r5, r0
    bl Slots_ov77_021E9994
    cmp r0, #0
    beq @@branch_1
    add sp, #8
    mov r0, #0
    pop {r3-r5, pc}
@@branch_1:
    mov r0, r5
    add r0, #0x3C
    ldrb r0, [r0]
    cmp r0, #0
    bne @@branch_2
    mov r0, #3
    bl Slots_ov77_021E7128
    lsl r1, r0, #1
    add r0, sp, #0
    add sp, #8
    ldrh r0, [r0, r1]
    pop {r3-r5, pc}
@@branch_2:
    mov r0, r5
    mov r1, #0
    mov r2, r4
    mov r3, #4
    bl Slots_ov77_021E99D0
    add sp, #8
    pop {r3-r5, pc}
    .align 4

Slots_ov77_021E97A4:
    push {r3-r7, lr}
    sub sp, #0x28
    mov r6, r0
    mov r7, r1
    mov r5, #1
    mov r4, #0
@@branch_1:
    sub r5, r5, #1
    add r0, sp, #0x1C
    str r0, [sp]
    mov r0, r6
    mov r1, #0
    mov r2, r7
    mov r3, r5
    bl Slots_ov77_021E9488
    str r0, [sp, #8]
    cmp r0, #0
    beq @@branch_2
    mov r0, #0
    str r0, [sp]
    mov r0, r6
    mov r1, #0
    mov r2, #3
    mov r3, r5
    bl Slots_ov77_021E9488
    cmp r0, #0
    bne @@branch_2
    mov r4, #1
@@branch_2:
    cmp r4, #0
    beq @@branch_1
    cmp r5, #0
    bne @@branch_3
    add sp, #0x28
    mov r0, #0
    pop {r3-r7, pc}
@@branch_3:
    ldr r0, [sp, #8]
    add r1, sp, #0x1C
    sub r0, r0, #1
    lsl r0, r0, #2
    ldr r1, [r1, r0]
    str r0, [sp, #0xC]
    cmp r1, #2
    bne @@branch_4
    add sp, #0x28
    neg r0, r5
    pop {r3-r7, pc}
@@branch_4:
    mov r0, #3
    mov r7, #1
    sub r0, r0, r1
    mov r4, r7
    str r5, [sp, #0x10]
    cmp r0, #1
    ble @@branch_7
@@branch_5:
    sub r0, r5, r4
    str r0, [sp, #4]
    mov r0, #0
    str r0, [sp]
    ldr r3, [sp, #4]
    mov r0, r6
    mov r1, #0
    mov r2, #3
    bl Slots_ov77_021E9488
    cmp r0, #0
    bne @@branch_6
    ldr r1, [sp, #4]
    lsl r2, r7, #2
    add r0, sp, #0x10
    add r7, r7, #1
    str r1, [r0, r2]
@@branch_6:
    ldr r0, [sp, #0xC]
    add r1, sp, #0x1C
    ldr r1, [r1, r0]
    mov r0, #3
    add r4, r4, #1
    sub r0, r0, r1
    cmp r4, r0
    blt @@branch_5
@@branch_7:
    mov r0, r7
    bl Slots_ov77_021E7128
    lsl r1, r0, #2
    add r0, sp, #0x10
    ldr r0, [r0, r1]
    neg r0, r0
    add sp, #0x28
    pop {r3-r7, pc}

Slots_ov77_021E9854:
    push {r3-r7, lr}
    sub sp, #0x30
    str r1, [sp, #0x10]
    mov r1, #0
    str r1, [sp, #0xC]
    add r1, sp, #0x24
    str r1, [sp]
    ldr r1, [sp, #0xC]
    ldr r2, [sp, #0x10]
    mov r3, r1
    mov r4, r0
    bl Slots_ov77_021E9488
    mov r5, r0
    beq @@branch_4
    mov r1, #0
    mov r0, r4
    mov r2, #3
    mov r3, r1
    str r1, [sp]
    bl Slots_ov77_021E9488
    cmp r0, #0
    bne @@branch_1
    add sp, #0x30
    mov r0, #0
    pop {r3-r7, pc}
@@branch_1:
    mov r2, #0
    cmp r5, #0
    ble @@branch_4
    add r3, sp, #0x24
    add r7, sp, #0x14
@@branch_2:
    ldr r0, [r3]
    cmp r0, #2
    bge @@branch_3
    neg r1, r0
    ldr r0, [sp, #0xC]
    ldr r6, [sp, #0xC]
    lsl r0, r0, #2
    add r6, r6, #1
    str r6, [sp, #0xC]
    str r1, [r7, r0]
@@branch_3:
    add r2, r2, #1
    add r3, r3, #4
    cmp r2, r5
    blt @@branch_2
@@branch_4:
    ldr r0, [sp, #0xC]
    mov r1, #0
    add r2, sp, #0x14
    lsl r0, r0, #2
    add r0, r2, r0
    str r1, [sp]
    str r0, [sp, #4]
    ldr r2, [sp, #0x10]
    mov r0, r4
    mov r3, #4
    bl Slots_ov77_021E9370
    ldr r1, [sp, #0xC]
    mov r7, #0
    add r0, r1, r0
    str r0, [sp, #0xC]
    str r7, [sp, #8]
    cmp r0, #0
    ble @@branch_12
    add r6, sp, #0x14
@@branch_5:
    ldr r3, [r6]
    cmp r3, #1
    bge @@branch_8
    ldr r0, [@@pool_1]
    lsl r1, r3, #2
    add r0, r0, r1
    ldr r0, [r0, #4]
    mov r5, #0
    cmp r0, #0
    ble @@branch_11
@@branch_6:
    mov r0, #0
    add r3, r5, #1
    str r0, [sp]
    mov r0, r4
    mov r1, #0
    mov r2, #3
    neg r3, r3
    bl Slots_ov77_021E9488
    cmp r0, #0
    bne @@branch_7
    lsl r0, r7, #2
    add r0, r4, r0
    add r1, r5, #1
    add r0, #0xF8
    add r7, r7, #1
    str r1, [r0]
@@branch_7:
    ldr r0, [r6]
    add r5, r5, #1
    lsl r1, r0, #2
    ldr r0, [@@pool_1]
    add r0, r0, r1
    ldr r0, [r0, #4]
    cmp r5, r0
    blt @@branch_6
    b @@branch_11
@@branch_8:
    ldr r0, [@@pool_1]
    lsl r1, r3, #2
    add r0, r0, r1
    ldr r0, [r0, #4]
    mov r5, #0
    cmp r0, #0
    ble @@branch_11
@@branch_9:
    mov r0, #0
    add r3, r5, r3
    str r0, [sp]
    mov r0, r4
    mov r1, #0
    mov r2, #3
    neg r3, r3
    bl Slots_ov77_021E9488
    cmp r0, #0
    bne @@branch_10
    ldr r0, [r6]
    add r1, r5, r0
    lsl r0, r7, #2
    add r0, r4, r0
    add r0, #0xF8
    add r7, r7, #1
    str r1, [r0]
@@branch_10:
    ldr r3, [r6]
    ldr r0, [@@pool_1]
    lsl r1, r3, #2
    add r0, r0, r1
    ldr r0, [r0, #4]
    add r5, r5, #1
    cmp r5, r0
    blt @@branch_9
@@branch_11:
    ldr r0, [sp, #8]
    add r6, r6, #4
    add r1, r0, #1
    ldr r0, [sp, #0xC]
    str r1, [sp, #8]
    cmp r1, r0
    blt @@branch_5
@@branch_12:
    cmp r7, #0
    bne @@branch_13
    mov r0, r4
    bl Slots_ov77_021E9734
    add sp, #0x30
    pop {r3-r7, pc}
@@branch_13:
    mov r0, r7
    bl Slots_ov77_021E7128
    lsl r0, r0, #2
    add r0, r4, r0
    add r0, #0xF8
    ldr r0, [r0]
    add sp, #0x30
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_ov77_021EA0D0

Slots_ov77_021E9994:
    push {r4-r7, lr}
    sub sp, #0xC
    mov r4, #0
    mov r6, r0
    mov r7, r1
    str r2, [sp]
    str r3, [sp, #4]
    str r4, [sp, #8]
    mov r5, r3
@@branch_1:
    ldr r3, [sp]
    mov r0, r6
    mov r1, r7
    mov r2, r4
    bl Slots_ov77_021E9310
    cmp r0, #0
    bne @@branch_2
    add r1, r4, #1
    str r1, [sp, #8]
@@branch_2:
    ldr r1, [sp, #4]
    cmp r1, #0
    beq @@branch_3
    strh r0, [r5]
@@branch_3:
    add r4, r4, #1
    add r5, r5, #2
    cmp r4, #3
    blt @@branch_1
    ldr r0, [sp, #8]
    add sp, #0xC
    pop {r4-r7, pc}

Slots_ov77_021E99D0:
    push {r3-r5, lr}
    sub sp, #8
    mov r5, #0
    lsl r3, r3, #16
    mov r4, r0
    str r5, [sp]
    mov r5, r4
    add r5, #0xF8
    lsr r3, r3, #16
    str r5, [sp, #4]
    bl Slots_ov77_021E9370
    cmp r0, #0
    bne @@branch_1
    add sp, #8
    mov r0, #0
    pop {r3-r5, pc}
@@branch_1:
    bl Slots_ov77_021E7128
    lsl r0, r0, #2
    add r0, r4, r0
    add r0, #0xF8
    ldr r4, [r0]
    ldr r0, [@@pool_1]
    lsl r1, r4, #2
    ldr r0, [r0, r1]
    bl Slots_ov77_021E7128
    add r0, r4, r0
    add sp, #8
    pop {r3-r5, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA0BC

Slots_ov77_021E9A14:
    push {r3-r7, lr}
    mov r5, r0
    mov r4, #1
    mov r7, #0
@@branch_1:
    sub r4, r4, #1
    mov r0, r5
    mov r1, #5
    mov r2, r4
    mov r3, r7
    bl Slots_ov77_021E94FC
    add r6, r7, r0
    mov r0, r5
    mov r1, #4
    mov r2, r4
    mov r3, #0
    bl Slots_ov77_021E94FC
    add r0, r6, r0
    bne @@branch_1
    neg r0, r4
    pop {r3-r7, pc}

Slots_ov77_021E9A40:
    push {r3-r7, lr}
    sub sp, #8
    mov r6, r0
    mov r7, r1
    mov r1, r6
    add r1, #0xF8
    str r1, [sp]
    mov r1, #0
    mov r2, r7
    mov r3, r1
    mov r4, #1
    bl Slots_ov77_021E9488
    cmp r0, #0
    bne @@branch_1
    bl Slots_GF_AssertFail
    add sp, #8
    mov r0, #0
    pop {r3-r7, pc}
@@branch_1:
    bl Slots_ov77_021E7128
    lsl r0, r0, #2
    add r0, r6, r0
    add r0, #0xF8
    ldr r0, [r0]
    lsl r0, r0, #16
    lsr r5, r0, #16
    mov r0, #2
    bl Slots_ov77_021E7128
    cmp r0, #0
    beq @@branch_3
    cmp r5, #0
    bne @@branch_2
    mov r5, #3
    b @@branch_3
@@branch_2:
    cmp r5, #2
    bne @@branch_3
    mov r5, #4
@@branch_3:
    mov r0, #1
    str r0, [sp]
    sub r4, r4, #1
    mov r0, r6
    mov r1, r5
    mov r2, r7
    mov r3, #2
    str r4, [sp, #4]
    bl Slots_ov77_021E93B0
    cmp r0, #0
    beq @@branch_3
    neg r0, r4
    add sp, #8
    pop {r3-r7, pc}
    .align 4

Slots_ov77_021E9AB0:
    push {r4-r7, lr}
    sub sp, #0x2C
    mov r6, r1
    add r1, sp, #0x20
    str r1, [sp]
    mov r1, #0
    mov r2, r6
    mov r3, r1
    mov r5, r0
    bl Slots_ov77_021E9488
    str r0, [sp, #4]
    cmp r0, #0
    bne @@branch_2
    mov r0, r5
    add r0, #0x3C
    ldrb r0, [r0]
    cmp r0, #1
    bne @@branch_1
    mov r0, r5
    bl Slots_ov77_021E9A14
    add sp, #0x2C
    pop {r4-r7, pc}
@@branch_1:
    add sp, #0x2C
    mov r0, #0
    pop {r4-r7, pc}
@@branch_2:
    mov r2, #0
    mov r0, r5
    mov r1, r6
    mov r3, r2
    bl Slots_ov77_021E94FC
    cmp r0, #0
    beq @@branch_3
    add sp, #0x2C
    mov r0, #0
    pop {r4-r7, pc}
@@branch_3:
    ldr r0, [sp, #4]
    mov r4, #0
    str r4, [sp, #8]
    cmp r0, #0
    ble @@branch_11
    add r7, sp, #0x20
@@branch_4:
    ldr r0, [r7]
    cmp r0, #0
    beq @@branch_5
    cmp r0, #1
    beq @@branch_7
    cmp r0, #2
    beq @@branch_8
    b @@branch_10
@@branch_5:
    mov r0, #0
    str r0, [sp]
    mov r0, r5
    mov r1, #1
    mov r2, r6
    mov r3, #4
    bl Slots_ov77_021E94C8
    cmp r0, #0
    beq @@branch_6
    lsl r2, r4, #2
    add r1, sp, #0xC
    add r4, r4, #1
    str r0, [r1, r2]
@@branch_6:
    mov r0, #1
    str r0, [sp]
    mov r0, r5
    mov r1, #1
    mov r2, r6
    mov r3, #4
    bl Slots_ov77_021E94C8
    cmp r0, #0
    beq @@branch_10
    lsl r2, r4, #2
    add r1, sp, #0xC
    add r4, r4, #1
    str r0, [r1, r2]
    b @@branch_10
@@branch_7:
    mov r0, #1
    str r0, [sp]
    mov r0, r5
    mov r1, #1
    mov r2, r6
    mov r3, #4
    bl Slots_ov77_021E94C8
    cmp r0, #0
    beq @@branch_10
    lsl r2, r4, #2
    add r1, sp, #0xC
    add r4, r4, #1
    str r0, [r1, r2]
    b @@branch_10
@@branch_8:
    mov r0, #1
    str r0, [sp]
    mov r0, r5
    mov r1, #1
    mov r2, r6
    mov r3, #4
    bl Slots_ov77_021E94C8
    cmp r0, #0
    beq @@branch_9
    lsl r2, r4, #2
    add r1, sp, #0xC
    add r4, r4, #1
    str r0, [r1, r2]
@@branch_9:
    mov r0, #2
    str r0, [sp]
    mov r0, r5
    mov r1, #1
    mov r2, r6
    mov r3, #4
    bl Slots_ov77_021E94C8
    cmp r0, #0
    beq @@branch_10
    lsl r2, r4, #2
    add r1, sp, #0xC
    add r4, r4, #1
    str r0, [r1, r2]
@@branch_10:
    ldr r0, [sp, #8]
    add r7, r7, #4
    add r1, r0, #1
    ldr r0, [sp, #4]
    str r1, [sp, #8]
    cmp r1, r0
    blt @@branch_4
@@branch_11:
    cmp r4, #0
    bne @@branch_13
    mov r0, r5
    add r0, #0x3C
    ldrb r0, [r0]
    cmp r0, #1
    bne @@branch_12
    mov r0, r5
    bl Slots_ov77_021E9A14
    add sp, #0x2C
    pop {r4-r7, pc}
@@branch_12:
    add sp, #0x2C
    mov r0, #0
    pop {r4-r7, pc}
@@branch_13:
    mov r0, r4
    bl Slots_ov77_021E7128
    lsl r1, r0, #2
    add r0, sp, #0xC
    ldr r0, [r0, r1]
    add sp, #0x2C
    pop {r4-r7, pc}

Slots_ov77_021E9BE4:
    push {r3-r7, lr}
    mov r6, r0
    mov r5, #1
@@branch_1:
    mov r7, #0
    sub r5, r5, #1
    mov r4, r7
@@branch_2:
    cmp r4, #3
    beq @@branch_3
    mov r0, r6
    mov r1, r4
    mov r2, r5
    bl Slots_ov77_021E953C
    cmp r0, #0
    beq @@branch_3
    mov r7, #1
@@branch_3:
    add r4, r4, #1
    cmp r4, #5
    ble @@branch_2
    cmp r7, #0
    bne @@branch_1
    neg r0, r5
    pop {r3-r7, pc}
    .align 4

Slots_ov77_021E9C14:
    push {r4-r6, lr}
    mov r5, r0
    mov r6, r1
    mov r4, #1
@@branch_1:
    sub r4, r4, #1
    mov r0, r5
    mov r1, r6
    mov r2, r4
    bl Slots_ov77_021E953C
    cmp r0, #0
    beq @@branch_1
    neg r0, r4
    pop {r4-r6, pc}

Slots_ov77_021E9C30:
    push {r4-r7, lr}
    sub sp, #0x34
    mov r2, #0
    add r3, sp, #0x20
    mov r5, r0
    mov r6, r1
    bl Slots_ov77_021E94FC
    str r0, [sp, #4]
    cmp r0, #0
    bne @@branch_1
    add sp, #0x34
    mov r0, #0
    pop {r4-r7, pc}
@@branch_1:
    mov r0, r5
    mov r1, r6
    mov r2, #0
    bl Slots_ov77_021E953C
    cmp r0, #0
    beq @@branch_2
    add sp, #0x34
    mov r0, #0
    pop {r4-r7, pc}
@@branch_2:
    ldr r0, [sp, #4]
    mov r4, #0
    mov r7, r4
    cmp r0, #0
    ble @@branch_5
    lsl r0, r0, #2
    str r0, [sp, #8]
@@branch_3:
    ldr r0, [sp, #8]
    add r1, sp, #0x20
    ldr r0, [r1, r0]
    cmp r0, #4
    bhi @@branch_4
    add r0, r0, r0
    add r0, pc
    ldrh r0, [r0, #6]
    lsl r0, r0, #16
    asr r0, r0, #16
    add pc, r0
@@table_1:
    .halfword @@case_1 - @@table_1 - 2
    .halfword @@case_2 - @@table_1 - 2
    .halfword @@case_3 - @@table_1 - 2
    .halfword @@case_1 - @@table_1 - 2
    .halfword @@case_3 - @@table_1 - 2
@@case_1:
    mov r0, #0
    str r0, [sp]
    mov r0, r5
    mov r1, #2
    mov r2, r6
    mov r3, #4
    bl Slots_ov77_021E94C8
    mov r2, r0
    beq @@branch_4
    lsl r1, r4, #2
    add r0, sp, #0xC
    add r4, r4, #1
    str r2, [r0, r1]
    b @@branch_4
@@case_2:
    mov r0, #1
    str r0, [sp]
    mov r0, r5
    mov r1, #2
    mov r2, r6
    mov r3, #4
    bl Slots_ov77_021E94C8
    mov r2, r0
    beq @@branch_4
    lsl r1, r4, #2
    add r0, sp, #0xC
    add r4, r4, #1
    str r2, [r0, r1]
    b @@branch_4
@@case_3:
    mov r0, #2
    str r0, [sp]
    mov r0, r5
    mov r1, #2
    mov r2, r6
    mov r3, #4
    bl Slots_ov77_021E94C8
    mov r2, r0
    beq @@branch_4
    lsl r1, r4, #2
    add r0, sp, #0xC
    add r4, r4, #1
    str r2, [r0, r1]
@@branch_4:
    ldr r0, [sp, #4]
    add r7, r7, #1
    cmp r7, r0
    blt @@branch_3
@@branch_5:
    cmp r4, #0
    bne @@branch_6
    add sp, #0x34
    mov r0, #0
    pop {r4-r7, pc}
@@branch_6:
    mov r0, r4
    bl Slots_ov77_021E7128
    lsl r1, r0, #2
    add r0, sp, #0xC
    ldr r0, [r0, r1]
    add sp, #0x34
    pop {r4-r7, pc}

Slots_ov77_021E9D08:
    ldr r3, [@@pool_1]
    mov r2, r1
    ldr r1, [r2, #0x10]
    ldr r2, [r2, #0xC]
    bx r3
    nop
@@pool_1:
    .word Slots_ov77_021E9334+1

Slots_ov77_021E9D18:
    push {r3-r7, lr}
    mov r4, r1
    ldr r1, [r4, #0x10]
    ldr r2, [r4, #0xC]
    mov r5, r0
    bl Slots_ov77_021E9334
    mov r1, r5
    add r1, #0x4F
    ldrb r2, [r1]
    ldr r1, [@@pool_1]
    ldrb r1, [r1, r2]
    cmp r0, r1
    ble @@branch_4
    ldr r0, [r4, #0x10]
    cmp r0, #2
    beq @@branch_1
    mov r0, #0
    pop {r3-r7, pc}
@@branch_1:
    mov r4, #0
    mov r6, #3
    mov r7, r4
@@branch_2:
    mov r0, r5
    add r0, #0x3B
    ldrb r0, [r0]
    cmp r0, r4
    beq @@branch_3
    mov r0, r5
    mov r1, r4
    mov r2, r6
    mov r3, r7
    bl Slots_ov77_021E941C
    cmp r0, #0
    beq @@branch_3
    mov r0, #2
    bl Slots_ov77_021E7128
    add r0, r0, #1
    pop {r3-r7, pc}
@@branch_3:
    add r4, r4, #1
    cmp r4, #3
    blt @@branch_2
    mov r0, #0
@@branch_4:
    pop {r3-r7, pc}
    nop
@@pool_1:
    .word Slots_ov77_021EA10C

Slots_Coins_SetValue:
    push {r3-r5, lr}
    mov r5, r0
    ldr r0, [@@pool_1]
    mov r4, r1
    cmp r4, r0
    bls @@branch_1
    bl Slots_GF_AssertFail
@@branch_1:
    strh r4, [r5]
    pop {r3-r5, pc}
@@pool_1:
    .word 0x0000C350

Slots_Slot_GetGameCornerHardness:
    push {r3-r7, lr}
    mov r4, r0
    bl Slots_GetLCRNGSeed
    str r0, [sp]
    mov r0, r4
    bl Slots_Save_FriendGroup_Get
    bl Slots_sub_0202C7DC
    bl Slots_SetLCRNGSeed
    mov r0, #0x20
    mov r1, #0x15
    bl Slots_Heap_AllocAtEnd
    mov r1, #0
    mov r2, #0x15
    mov r4, r0
    blx Slots_MI_CpuFill8
    mov r6, #0
@@branch_1:
    ldr r0, [@@pool_1]
    mov r5, #0
    ldrb r0, [r0, r6]
    cmp r0, #0
    bls @@branch_3
    add r0, r6, #1
    lsl r0, r0, #24
    lsr r7, r0, #24
@@branch_2:
    bl Slots_LCRandom
    mov r1, #0x15
    blx Slots__s32_div_f
    lsl r0, r1, #24
    lsr r1, r0, #24
    ldrb r0, [r4, r1]
    cmp r0, #0
    bne @@branch_2
    add r0, r5, #1
    lsl r0, r0, #24
    lsr r5, r0, #24
    ldr r0, [@@pool_1]
    strb r7, [r4, r1]
    ldrb r0, [r0, r6]
    cmp r5, r0
    bcc @@branch_2
@@branch_3:
    add r0, r6, #1
    lsl r0, r0, #24
    lsr r6, r0, #24
    cmp r6, #2
    bcc @@branch_1
    mov r0, r4
    ldrb r5, [r4]
    bl Slots_Heap_Free
    ldr r0, [sp]
    bl Slots_SetLCRNGSeed
    mov r0, r5
    pop {r3-r7, pc}
@@pool_1:
    .word Slots_sLuckDistribution

Slots_Slot_InitWithCoinCheck:
    push {r4, lr}
    mov r4, r0
    bl Slots_ov77_021E4E40
    cmp r0, #0
    bne @@branch_1
    mov r0, #0
    pop {r4, pc}
@@branch_1:
    mov r0, r4
    bl Slots_OverlayManager_GetData
    ldr r1, [r0, #0x28]
    cmp r1, #3
    bge @@branch_4
    cmp r1, #0
    bne @@branch_2
    mov r2, #3
    b @@branch_3
@@branch_2:
    mov r2, #2
@@branch_3:
    mov r1, r0
    add r1, #0x26
    strb r2, [r1]
    mov r1, #0x1A
    str r1, [r0, #0xC]
    mov r1, #0
    str r1, [r0, #0x10]
    str r1, [r0, #8]
@@branch_4:
    mov r0, #1
    pop {r4, pc}
    .align 4

Slots_Slot_GameCornerInit:
    push {r4-r6, lr}
    mov r6, r1
    ldr r1, [r6]
    mov r5, r0
    cmp r1, #0
    bne @@branch_1
    ldr r1, [@@pool_1]
    ldr r1, [r1]
    cmp r1, #0
    bne @@branch_1
    bl Slots_OverlayManager_GetArgs
    mov r4, r0
    ldr r0, [@@pool_2]
    mov r1, #0
    mov r2, #0x1C
    blx Slots_MI_CpuFill8
    ; The field command already calculated luck for this machine and city.
    ldr r0, [r4, #0x14]
    ldr r1, [@@pool_1]
    str r0, [r1, #8]
    ldr r0, [r4, #0x10]
    str r0, [r1, #0x18]
    ldr r0, [r4, #8]
    str r0, [r1, #0x1C]
    ldr r0, [@@pool_2]
    str r4, [r1]
    str r0, [r5, #0x18]
@@branch_1:
    mov r0, r5
    mov r1, r6
    bl Slots_Slot_InitWithCoinCheck
    pop {r4-r6, pc}
    nop
@@pool_1:
    .word Slots_sLaunchArgs
@@pool_2:
    .word Slots_sSlotArgs

Slots_Slot_GameCornerMain:
    ldr r3, [@@pool_1]
    bx r3
@@pool_1:
    .word Slots_ov77_021E4EA8+1

Slots_Slot_GameCornerExit:
    push {r4, lr}
    mov r4, r0
    bl Slots_ov77_021E4F04
    cmp r0, #0
    bne @@branch_1
    mov r0, #0
    pop {r4, pc}
@@branch_1:
    ldr r0, [@@pool_1]
    ldr r1, [r0]
    str r1, [r4, #0x18]
    mov r1, #0
    str r1, [r0]
    mov r0, #1
    pop {r4, pc}
    nop
@@pool_1:
    .word Slots_sLaunchArgs

Slots_ov77_021E9D78:
    .halfword 0x0046, 0x0047, 0x0045, 0x0044, 0xFFFF, 0xFFFF, 0x0059
    .align 4

Slots_ov77_021E9D88:
    .word 0x00000001, 0x00000000, 0x00000000, 0x00000000

Slots_ov77_021E9D98:
    .word 0x00000002, 0x00010000, 0x00004000, 0x00000010
    .word 0x00000010

Slots_ov77_021E9DAC:
    .word 0x00000000, 0x00000000, 0x00000800, 0x00000000
    .word 0x041F0001, 0x00000000, 0x00000000

Slots_ov77_021E9DC8:
    .word 0x00000000, 0x00000000, 0x00000800, 0x00000000
    .word 0x001E0001, 0x00000100, 0x00000000

Slots_ov77_021E9DE4:
    .word 0x00000000, 0x00000000, 0x00000800, 0x00000000
    .word 0x001D0001, 0x00000200, 0x00000000

Slots_ov77_021E9E00:
    .word 0x00000000, 0x00000000, 0x00000800, 0x00000000
    .word 0x001D0001, 0x00000200, 0x00000000

Slots_ov77_021E9E1C:
    .word 0x00000000, 0x00000000, 0x00000800, 0x00000000
    .word 0x001E0001, 0x00000100, 0x00000000

Slots_ov77_021E9E38:
    .word 0x00000000, 0x00000000, 0x00000800, 0x00000000
    .word 0x001F0001, 0x00000000, 0x00000000

Slots_ov77_021E9E54:
    .word 0x00000000, 0x00000000, 0x00000800, 0x00000000
    .word 0x041C0001, 0x00000300, 0x00000000

Slots_ov77_021E9E70:
    .word 0x00000000, 0x00000080, 0x00000000, 0x00000020
    .word 0x00000000, 0x00000080, 0x00000000, 0x00000020

Slots_ov77_021E9E90:
    .word 0x00000001, 0x00000000, 0x00000004, 0x00000000
    .word 0x00000010, 0x00000000, 0x00000100, 0x00000000
    .word 0x00000000, 0x00000000

Slots_ov77_021E9EB8:
    .word 0x1B010204, 0x005B0D04, 0x1C000205, 0x03C80B02
    .word 0x06160205, 0x03BC0B02, 0x06160A05, 0x03B00B02
    .word 0x06161205, 0x03A40B02

Slots_ov77_021E9EE0:
    .word 0x00000001, 0x00280058, 0x00080000, 0x00000000
    .word 0x00000000, 0x00000002, 0x00000001, 0x00000000
    .word 0x00000000, 0x00000000

Slots_ov77_021E9F08:
    .word 0x00000001, 0x00B800E8, 0x00000000, 0x00000001
    .word 0x00000000, 0x00000002, 0x00000001, 0x00000000
    .word 0x00000000, 0x00000000, 0x00000000, 0x00740050
    .word 0x00010000, 0x00000002, 0x00000000, 0x00000001
    .word 0x00000001, 0x00000000, 0x00000000, 0x00000000
    .word 0x00000000, 0x00600080, 0x00000000, 0x00000008
    .word 0x00000000, 0x00000001, 0x00000001, 0x00000000
    .word 0x00000000, 0x00000000, 0x00000000, 0x00000000
    .word 0x00090000, 0x00000003, 0x00000000, 0x00000001
    .word 0x00000001, 0x00000000, 0x00000000, 0x00000000

Slots_ov77_021E9FA8:
    .word 0x00D0C0AD

Slots_ov77_021E9FAC:
    .word Slots_ov77_021E5D00+1, Slots_ov77_021E5D50+1, Slots_ov77_021E5DA8+1, Slots_ov77_021E5E1C+1
    .word Slots_ov77_021E5E68+1, Slots_ov77_021E5EC0+1, Slots_ov77_021E5F14+1, Slots_ov77_021E5FB8+1
    .word Slots_ov77_021E6014+1, Slots_ov77_021E6098+1, Slots_ov77_021E619C+1, Slots_ov77_021E624C+1
    .word Slots_ov77_021E62A4+1, Slots_ov77_021E62D4+1, Slots_ov77_021E6360+1, Slots_ov77_021E63DC+1
    .word Slots_ov77_021E6420+1, Slots_ov77_021E649C+1, Slots_ov77_021E64E8+1, Slots_ov77_021E6574+1
    .word Slots_ov77_021E6638+1, Slots_ov77_021E66F8+1, Slots_ov77_021E6758+1, Slots_ov77_021E67F0+1
    .word Slots_ov77_021E6850+1, Slots_ov77_021E68D4+1, Slots_ov77_021E6974+1, Slots_ov77_021E69FC+1

Slots_ov77_021EA01C:
    .halfword 0x1B0E
    .align 4

Slots_ov77_021EA020:
    .word 0x00000000, 0x00000001, 0x00000003, 0x00000006
    .word 0x0000000A

Slots_ov77_021EA034:
    .word 0x00000001, 0x0000000A, 0x00000064, 0x000003E8
    .word 0x00002710, 0x000186A0, 0x000F4240, 0x00989680

Slots_ov77_021EA054:
    .byte 0x44, 0x50, 0x03, 0x30, 0x50, 0x03, 0x58, 0x50, 0x03, 0x44, 0x4A, 0x03, 0x28, 0x50, 0x04, 0x60
    .byte 0x50, 0x04, 0x30, 0x50, 0x03, 0x58, 0x50, 0x03, 0x28, 0x38, 0x04, 0x60, 0x38, 0x04, 0x30, 0x50
    .byte 0x03, 0x58, 0x50, 0x03, 0x44, 0x38, 0x04, 0x28, 0x38, 0x05, 0x60, 0x38, 0x05
    .align 4

Slots_ov77_021EA084:
    .byte 0x14, 0x14, 0x14
    .align 4

Slots_ov77_021EA088:
    .byte 0x01, 0x00, 0x01, 0x02, 0x02
    .align 4

Slots_ov77_021EA090:
    .byte 0x05, 0x04, 0x02, 0x01, 0x03, 0x00
    .align 4

Slots_ov77_021EA098:
    .byte 0x00, 0x00, 0x0F, 0x0A, 0x02, 0x64, 0x64
    .align 4

Slots_ov77_021EA0A0:
    .byte 0x00, 0x02, 0x01, 0x02, 0x02, 0x02
    .align 4

Slots_ov77_021EA0A8:
    .word Slots_ov77_021E8F68+1, Slots_ov77_021E8F6C+1, Slots_ov77_021E9004+1, Slots_ov77_021E9080+1
    .word Slots_ov77_021E910C+1

Slots_ov77_021EA0BC:
    .word 0x00000003, 0x00000003, 0x00000002, 0x00000001
    .word 0x00000001

Slots_ov77_021EA0D0:
    .word 0x00000001, 0x00000002, 0x00000003, 0x00000003
    .word 0x00000002, 0x00000001

Slots_ov77_021EA0E8:
    .byte 0x00, 0x01, 0x01, 0x01, 0x02, 0x01, 0x00, 0x02, 0x01, 0x02, 0x02, 0x02, 0x00, 0x03, 0x01, 0x03
    .byte 0x02, 0x03, 0x00, 0x01, 0x01, 0x02, 0x02, 0x03, 0x00, 0x03, 0x01, 0x02, 0x02, 0x01
    .align 4

Slots_ov77_021EA108:
    .byte 0x01, 0x02, 0x03
    .align 4

Slots_ov77_021EA10C:
    .byte 0x02, 0x03, 0x0A
    .align 4

Slots_ov77_021EA110:
    .byte 0x0D, 0x06, 0x14
    .align 4

Slots_ov77_021EA114:
    .byte 0x01, 0x01, 0x01
    .align 4

Slots_ov77_021EA118:
    .byte 0x0F, 0x0A, 0x00
    .align 4

Slots_ov77_021EA11C:
    .byte 0x02, 0x04, 0x02, 0x04, 0x02, 0x04, 0x04, 0x06

Slots_ov77_021EA124:
    .byte 0x05, 0x0F, 0x0A, 0x0A, 0x05, 0x0A, 0x0A, 0x14, 0x05
    .align 4

Slots_ov77_021EA130:
    .byte 0x05, 0x19, 0x23, 0x05, 0x23, 0x23, 0x00, 0x14, 0x1E, 0x00, 0x1E, 0x1E

Slots_ov77_021EA13C:
    .byte 0x28, 0x28, 0x05, 0x05, 0x05, 0x05, 0x05, 0x3C, 0x3C, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x28, 0x28
    .byte 0x05, 0x05, 0x05, 0x05, 0x05
    .align 4

Slots_ov77_021EA154:
    .byte 0x64, 0x00, 0x00, 0x0F, 0x1E, 0x1E, 0x0F, 0x1E, 0x1E, 0x0F, 0x1E, 0x1E, 0x0F, 0x1E, 0x1E, 0x64
    .byte 0x00, 0x00, 0x64, 0x00, 0x00
    .align 4

Slots_ov77_021EA16C:
    .byte 0x1E, 0x2D, 0x0F, 0x20, 0x2A, 0x11, 0x22, 0x27, 0x14, 0x24, 0x24, 0x17, 0x3C, 0x5A, 0x1E, 0x40
    .byte 0x54, 0x22, 0x44, 0x4E, 0x28, 0x48, 0x48, 0x2E

Slots_ov77_021EA184:
    .byte 0x18, 0x1C, 0x30, 0x1D, 0x21, 0x26, 0x22, 0x26, 0x1C, 0x27, 0x2B, 0x12, 0x14, 0x0A, 0x46, 0x19
    .byte 0x0F, 0x3C, 0x1E, 0x14, 0x32, 0x23, 0x19, 0x28, 0x28, 0x0F, 0x2D, 0x2D, 0x14, 0x23, 0x32, 0x19
    .byte 0x19, 0x37, 0x1E, 0x0F

Slots_ov77_021EA1A8:
    .byte 0x64, 0x00, 0x5F, 0x05, 0x50, 0x46, 0x19, 0x55, 0x0A, 0x4B, 0x46, 0x14, 0x4B, 0x0F, 0x46, 0x55
    .byte 0x05, 0x4B, 0x0F, 0x41, 0x3C, 0x1E, 0x41, 0x14, 0x3C, 0x3C, 0x19, 0x41, 0x14, 0x37, 0x55, 0x0A
    .byte 0x37, 0x19, 0x32, 0x37, 0x23, 0x37, 0x19, 0x32, 0x37, 0x1E, 0x2D, 0x1E, 0x32, 0x50, 0x0F, 0x2D
    .byte 0x1E, 0x32, 0x32, 0x28, 0x23, 0x23, 0x32, 0x32, 0x23, 0x23, 0x23, 0x32, 0x4B, 0x14, 0x19, 0x28
    .byte 0x32, 0x2D, 0x2D, 0x19, 0x28, 0x32, 0x2D, 0x28, 0x0F, 0x2D, 0x32, 0x46, 0x19, 0x0F, 0x2D, 0x32
    .byte 0x28, 0x32, 0x05, 0x32, 0x32, 0x28, 0x2D, 0x05, 0x32, 0x32
    .align 4

Slots_ov77_021EA204:
    .halfword 0x012C, 0x01DB, 0x0000, 0x0096, 0x01DB, 0x0000, 0x0190, 0x01F4
    .halfword 0x0000, 0x0258, 0x00FA, 0x0000, 0x02BC, 0x00C8, 0x0000, 0x0320
    .halfword 0x0064, 0x0000, 0x0258, 0x00FA, 0x0000, 0x0190, 0x012C, 0x0000
    .halfword 0x0320, 0x0064, 0x0000, 0x0258, 0x00FA, 0x0000, 0x0190, 0x012C
    .halfword 0x0000, 0x0320, 0x0064, 0x0000, 0x0258, 0x0190, 0x0000, 0x0190
    .halfword 0x0258, 0x0000, 0x0320, 0x00C8, 0x0000, 0x012C, 0x02BC, 0x0000
    .halfword 0x0258, 0x0190, 0x0000, 0x0064, 0x0384, 0x0000, 0x012C, 0x02BC
    .halfword 0x0000, 0x0258, 0x0190, 0x0000, 0x0064, 0x0384, 0x0000
    .align 4

Slots_ov77_021EA284:
    .halfword 0x029E, 0x004B, 0x004B, 0x004B, 0x004B, 0x000F, 0x000F, 0x02BC
    .halfword 0x0050, 0x0028, 0x0028, 0x0028, 0x0032, 0x0032, 0x0290, 0x000A
    .halfword 0x006E, 0x006E, 0x006E, 0x0002, 0x0002, 0x028A, 0x004B, 0x004B
    .halfword 0x004B, 0x004B, 0x0019, 0x0019, 0x0258, 0x0050, 0x0028, 0x0028
    .halfword 0x0028, 0x0064, 0x0064, 0x026E, 0x000A, 0x0078, 0x0078, 0x0078
    .halfword 0x0004, 0x0004, 0x0258, 0x004B, 0x004B, 0x004B, 0x004B, 0x0032
    .halfword 0x0032, 0x01F4, 0x0050, 0x0028, 0x0028, 0x0028, 0x0096, 0x0096
    .halfword 0x024C, 0x000A, 0x0082, 0x0082, 0x0082, 0x0006, 0x0006, 0x01F4
    .halfword 0x004B, 0x004B, 0x004B, 0x004B, 0x0064, 0x0064, 0x00C8, 0x0050
    .halfword 0x0028, 0x0028, 0x0028, 0x012C, 0x012C, 0x022A, 0x000A, 0x008C
    .halfword 0x008C, 0x008C, 0x0008, 0x0008

Slots_ov77_021EA32C:
    .word 0x00000002, 0x00000005, 0x00000004, 0x00000001
    .word 0x00000000, 0x00000002, 0x00000003, 0x00000004
    .word 0x00000000, 0x00000002, 0x00000003, 0x00000005
    .word 0x00000000, 0x00000002, 0x00000001, 0x00000004
    .word 0x00000002, 0x00000001, 0x00000000, 0x00000005
    .word 0x00000000, 0x00000004, 0x00000005, 0x00000002
    .word 0x00000000, 0x00000001, 0x00000003, 0x00000000
    .word 0x00000003, 0x00000002, 0x00000004, 0x00000000
    .word 0x00000002, 0x00000004, 0x00000001, 0x00000002
    .word 0x00000000, 0x00000005, 0x00000003, 0x00000001
    .word 0x00000000, 0x00000002, 0x00000003, 0x00000005
    .word 0x00000002, 0x00000004, 0x00000003, 0x00000000
    .word 0x00000001, 0x00000002, 0x00000005, 0x00000002
    .word 0x00000000, 0x00000001, 0x00000004, 0x00000003
    .word 0x00000000, 0x00000001, 0x00000002, 0x00000000
    .word 0x00000001, 0x00000002, 0x00000000

Slots_ov77_021EA428:
    .word 0x00000019, 0x0000001C, 0x0000001F, 0x00000006
    .word 0x00000006, 0x00000006, 0x00000006, 0x00000010
    .word 0x00000013, 0x00000016, 0x00000006, 0x00000006
    .word 0x00000006, 0x00000006, 0x00000007, 0x0000000A
    .word 0x0000000D, 0x00000006, 0x00000006, 0x00000006
    .word 0x00000006, 0x0000001A, 0x0000001D, 0x00000020
    .word 0x00000006, 0x00000006, 0x00000006, 0x00000006
    .word 0x00000011, 0x00000014, 0x00000017, 0x00000006
    .word 0x00000006, 0x00000006, 0x00000006, 0x00000008
    .word 0x0000000B, 0x0000000E, 0x00000006, 0x00000006
    .word 0x00000006, 0x00000006, 0x0000001B, 0x0000001E
    .word 0x00000021, 0x00000006, 0x00000006, 0x00000006
    .word 0x00000006, 0x00000012, 0x00000015, 0x00000018
    .word 0x00000006, 0x00000006, 0x00000006, 0x00000006
    .word 0x00000009, 0x0000000C, 0x0000000F, 0x00000006
    .word 0x00000006, 0x00000006, 0x00000006

Slots_sLuckDistribution:
    .byte 0x07, 0x03
    .fill 10, 0

Slots_sLaunchArgs:
    .fill 0x4, 0

Slots_sSlotArgs:
    .fill 0x1C, 0xFF

.ascii "SlotMachines_End"

Slots_PayloadEnd:
.if Slots_PayloadEnd - Slots_PayloadStart > 0x6000
    .error "Slot machines: payload exceeds its reviewed 24 KiB memory budget."
.endif
.close

; Overlay 131 supplies a separate overlay-77 template only for command 780's
; game selectors 2 and 3; the restored native template serves selectors 0 and 1.

; Replace the empty stub's size, constructors, and compression metadata.
; Preserve its file ID at +0x18 (checked above).
.open "base/overarm9.bin", 0
.org 77 * 0x20
.word Slots_OverlayId
.word Slots_OverlayBase
.word Slots_PayloadEnd - Slots_PayloadStart
.word 0 ; BSS: mutable launch arguments are already in the initialized payload
.word 0 ; no constructors
.word 0
.org 77 * 0x20 + 0x1C
.word 0 ; uncompressed, unsigned
.close
