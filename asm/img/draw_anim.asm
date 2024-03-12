; X = anim pos idx
; tmp = anim data idx
draw_anim:
    pushregs

    ; --------
    ; find anim
    ; --------
    mov tmp+2, #0
    ; idx << 3
    for_y @find_anim_1, #ANIM_SHIFT_SIZE
        ASL tmp+0
        ROL tmp+1
        ROL tmp+2
    ; shift 3 last bits of adr into bnk
    to_y_dec @find_anim_1, #0
    @find_anim_2:
        ASL tmp+1
        ROL tmp+2
    to_y_inc @find_anim_2, #3
    ; shift adr >> 3
    LDA tmp+1
    LSR
    LSR
    LSR
    ;
    ORA #>anim_data
    STA tmp+1

    ; --------
    ; read anim
    ; --------
    ; set bank
    LDA mmc5_banks+1
    PHA
    LDA tmp+2
    add #MONSTER_ANIM_BNK
    STA MMC5_PRG_BNK0
    STA mmc5_banks+1
    ; get anim.delay
    LDY #Anim::delay
    LDA (tmp), Y
    ; if anim.delay > 0
    BEQ :+
        ; add to anim list
        STA anims_delay, X
        ; flag
        LDA anims_flag, X
        AND #$03
        ORA #$80
        STA anims_flag, X
        ; type
        LDY #Anim::type
        LDA (tmp), Y
        STA anims_type, X
        ; next
        LDY #Anim::next+0
        LDA (tmp), Y
        STA anims_next_lo, X
        LDY #Anim::next+1
        LDA (tmp), Y
        STA anims_next_hi, X
        ; pos
        LDY #Anim::posx
        LDA (tmp), Y
        STA anims_x, X
        LDY #Anim::posy
        LDA (tmp), Y
        STA anims_y, X
    :

    ; offset position by monster position
    LDA tmp
    PHA
    TYA
    PHA
    STX tmp
    LDA anims_flag, X
    AND #$03
    TAY
    JSR monster_fightid_to_pos
    TXA
    LDX tmp
    add anims_x, X
    STA anims_x, X
    TYA
    add anims_y, X
    STA anims_y, X
    PLA
    TAY
    PLA
    STA tmp
    ; for later
    phx
    LDA anims_type, X
    PHA
    LDA anims_x, X
    PHA
    LDA anims_y, X
    PHA


    ; --------
    ; draw anim
    ; --------
    ; find background image
    LDY #Anim::img+0
    LDA (tmp), Y
    TAX
    LDY #Anim::img+1
    LDA (tmp), Y
    TAY
    JSR find_rleimg
    ; change bank
    LDA tmp+2
    STA mmc5_banks+1
    STA MMC5_PRG_BNK0
    ;
    PLA
    TAY
    PLA
    TAX
    PLA
    BEQ @bkg
    @spr:
        PLA
        JSR draw_spr_rleimg
        JMP @end
    @bkg:
        PLA
        ; draw background image
        JSR draw_bkg_rleimg

    @end:
    ; restore bank
    PLA
    STA mmc5_banks+1
    STA MMC5_PRG_BNK0
    ; return
    pullregs
    RTS
