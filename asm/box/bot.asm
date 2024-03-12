;--------------------------------
; Subroutine: dialog_box_anim_bot
;--------------------------------
;
; Perform the bottom side of the resizing dialog box animation.
;
; /!\ does not save registers /!\
;
; /!\ use tmp (0, 1 and 2) /!\
;
;--------------------------------
dialog_box_anim_bot:
    ; wich side ?
    blt @up
    @down:
        INC player_bound_y2
        INC player_bound_y2
        mov tmp+2, #$00
        JMP :+
    @up:
        DEC player_bound_y2
        DEC player_bound_y2
        mov tmp+2, #$FF
    :

    ; adr ?
    LDX player_bound_x1
    LDY player_bound_y2
    JSR xy_2_ppu
    ; what tile ?
    LDA player_bound_y2
    AND #$07
    LSR
    add #DIALOG_BOX_ANIM_TILE_Y_OFFSET
    TAX
    ; size ?
    LDA player_bound_x2
    sub player_bound_x1
    shift LSR, 3
    TAY
    INY
    TYA
    ; can fit in background buffer ?
    add background_index
    CMP #$60-1-3
    bge @fail ; if branch: can't fit
    TYA
    PHA

    ; if player_bound_y2 & 1 == 0
    LDA player_bound_y2
    LSR
    BCS :+
        TXA
        JSR dialogbox_anim_send_ppu
    :
    PLA
    TAY

    ; need to erase previous tiles ?
    ; if up
    LDA tmp+2
    BPL :+
        ; if player_bound_y2 & 1 == 0
        LDA player_bound_y2
        LSR
        BCS @end
        ; and if tile state == 3
        LDA player_bound_y2
        AND #$06
        CMP #$06
        BNE @end
            ; erase
            add_A2ptr tmp, #$20
            LDA #DIALOG_BOX_TILE_MIDDLE
            JMP dialogbox_anim_send_ppu
    ; else
    :
        ; if player_bound_y2 & 1 == 0
        LDA player_bound_y2
        LSR
        BCS @end
        ; and if tile state == 0
        LDA player_bound_y2
        AND #$06
        BNE @end
            ;
            STY tmp+2
            ; erase
            sub_A2ptr tmp, #$20
            LDA #DIALOG_BOX_TILE_MIDDLE
            JSR dialogbox_anim_send_ppu
            ; edit last tile of ppu packet
            LDX background_index
            DEX
            LDA #DIALOG_BOX_TILE_RIGHT
            STA background, X
            ; edit first tile of ppu packet
            LDA background_index
            sub tmp+2
            TAX
            LDA #DIALOG_BOX_TILE_LEFT
            STA background, X
            ;
            RTS

    @fail:
    ; restore pos
    LDA tmp+2
    BPL :+
        INC player_bound_y2
        RTS
    :
        DEC player_bound_y2
    ; return
    @end:
    RTS
