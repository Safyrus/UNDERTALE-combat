;--------------------------------
; Subroutine: draw_hitmark
;--------------------------------
;
; Draw the marker during attack.
;
;--------------------------------
draw_hitmark:
    LDX #$88
    JSR draw_hitmark_part
    LDX #$98
    JSR draw_hitmark_part
    LDX #$A8
    JMP draw_hitmark_part


draw_hitmark_part:
    ; get sprite pos in oam
    LDA oam_size
    ASL
    ASL
    TAY
    ; y
    TXA
    STA OAM, Y
    INY
    ; tile
    LDA #HITMARK_TILE
    STA OAM, Y
    INY
    ; atr
    LDA #HITMARK_PLT
    STA OAM, Y
    INY
    ; x
    LDA fight_markpos
    STA OAM, Y

    INC oam_size

    ; return
    RTS
