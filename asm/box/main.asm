;--------------------------------
; Subroutine: dialog_box_anim
;--------------------------------
;
; Perform the resizing dialog box animation.
;
; /!\ does not save registers /!\
;
; /!\ use tmp (0, 1 and 2) /!\
;
;--------------------------------
dialog_box_anim:
    and_adr dialogbox_anim_flag, #%11111010

    ; if anim on left side needed
    LDA futur_box_pos_x1
    CMP player_bound_x1
    BEQ :+
        ora_adr dialogbox_anim_flag, #$05
        JSR dialog_box_anim_left
    :
    ; if anim on right side needed
    LDA futur_box_pos_x2
    CMP player_bound_x2
    BEQ :+
        ora_adr dialogbox_anim_flag, #$05
        JSR dialog_box_anim_right
    :

    LDA dialogbox_anim_flag
    AND #$04
    BNE @no_y
    ; if anim on top side needed
    LDA futur_box_pos_y1
    CMP player_bound_y1
    BEQ :+
        ora_adr dialogbox_anim_flag, #$01
        JSR dialog_box_anim_top
    :
    ; if anim on bot side needed
    LDA futur_box_pos_y2
    CMP player_bound_y2
    BEQ :+
        ora_adr dialogbox_anim_flag, #$01
        JSR dialog_box_anim_bot
    :
    @no_y:

    ; if no anim
    LDA dialogbox_anim_flag
    BEQ @end
    ; flag
    ORA #$02
    STA dialogbox_anim_flag
    ;
    ; if anim just end
    LSR
    BCS :+
        @anim_end:
        ; draw corner tiles
        ; JSR dialog_box_anim_corner_del_sprites
        JSR dialog_box_anim_corner_tiles
        ; update end anim var (we are done)
        mov dialogbox_anim_flag, #$00
        RTS
    ; else
    :
        ; draw corner sprites
        ; JSR dialog_box_anim_corner_del_sprites
        JMP dialog_box_anim_corner_sprites

    @end:
    RTS
