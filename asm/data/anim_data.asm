
; this file was generated

.segment "MONSTER_ANIM_DATA"

anim_data:
    ; ANIM_DATA_MONSTERS_FROGGIT_FROGGIT_BKG
    .byte 0, 0, 0, 0 ; x, y, delay, type
    .word IMG_DATA_MONSTERS_FROGGIT_FROGGIT, 0 ; img, next
    ; ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_BKG_1
    .byte 248, 0, 60, 0 ; x, y, delay, type
    .word IMG_DATA_MONSTERS_TESTOBUG_ANIMS_BKG_1, ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_BKG_2 ; img, next
    ; ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_BKG_2
    .byte 248, 0, 60, 0 ; x, y, delay, type
    .word IMG_DATA_MONSTERS_TESTOBUG_ANIMS_BKG_2, ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_BKG_1 ; img, next

; anim_data_bkg_cl
    ; ANIM_DATA_MONSTERS_ATKIMG_L
    .byte 0, 0, 0, 0 ; x, y, delay, type
    .word IMG_CL_DATA_MONSTERS_ATK_IMG_LEFT, 0 ; img, next
    ; ANIM_DATA_MONSTERS_ATKIMG_R
    .byte 112, 0, 0, 0 ; x, y, delay, type
    .word IMG_CL_DATA_MONSTERS_ATK_IMG_RIGHT, 0 ; img, next

; anim_data_spr
    ; ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_SPR_0
    .byte 20, 8, 10, 1 ; x, y, delay, type
    .word IMG_DATA_MONSTERS_TESTOBUG_ANIMS_SPR, ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_SPR_1 ; img, next
    ; ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_SPR_1
    .byte 20, 8, 10, 1 ; x, y, delay, type
    .word IMG_DATA_MONSTERS_TESTOBUG_ANIMS_SPR_V, ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_SPR_0 ; img, next
