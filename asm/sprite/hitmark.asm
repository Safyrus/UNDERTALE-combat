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
    ; if mark not inside main box
    LDA fight_markpos
    CMP #$0A
    blt @end
    CMP #$F8
        ; return
        bge @end

    ; get sprite pos in oam
    LDA oam_size
    ASL
    ASL
    TAY
    ; y
    TXA
    STA OAM+0, Y
    ; tile
    LDA #HITMARK_TILE
    STA OAM+1, Y
    ; x
    LDA fight_markpos
    sub #$02 ; offset for sprite
    STA OAM+3, Y

    ; if fight_state != 0 (anim)
    LDA fight_state
    BEQ @atk
        ; if frame counter % 16 < 8
        LDA frame_counter
        AND #$08
        BEQ :+
            ; other palette
            LDA #HITMARK_PLT + 1
            JMP @store_atr
        ; else
        :
            ; normal palette
            LDA #HITMARK_PLT
            JMP @store_atr
    ; else
    @atk:
        ; same palette
        LDA #HITMARK_PLT
    @store_atr:
    ; atr
    STA OAM+2, Y

    ; oam_size++
    INC oam_size

    @end:
    ; return
    RTS
