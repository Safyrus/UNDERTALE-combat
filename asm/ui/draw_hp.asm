
;--------------------------------
; Subroutine: update_player_hp
;--------------------------------
;
; Draw the current value of the player HP (bar, HP, MAXHP).
; The subroutine will do nothing if it can't draw (not enought space in background buffer or not enought time before NMI)
; If it has drawn, the <PLAYER_FLAG_DRAW_HP> of <player_flag> will be cleared.
;
; /!\ Change registers /!\
;
; /!\ use tmp+0, tmp+1 and tmp+2 /!\
;
;--------------------------------
update_player_hp:
    @h  = tmp+0
    @mh = tmp+1
    @tile = tmp+2

    ; if background buffer too full
    LDX background_index
    CPX #$60-1-19
    blt :+
        ; return
        RTS
    :
    ; or if not in frame
    BIT scanline
    BVS :+
        ; return
        RTS
    :

    ; open packet of size 15
    LDA #15
    STA background, X
    INX
    ; write ppu adr
    LDA #$23
    STA background, X
    INX
    LDA #$30
    STA background, X
    INX

    ; h = hp >> 1
    LDA player_stats + PlayerStat::hp
    LSR
    STA @h
    ; mh = maxhp >> 1
    LDA player_stats + PlayerStat::maxhp
    LSR
    STA @mh
    ; for i from 8 to 0
    for_y @loop, #8
        ; tile = #' '
        mov @tile, #' '
        ; if mh == 0
        LDA @mh
        BNE :+
            ; break
            JMP @break
        :
        ; if mh >= 8
        LDA @mh
        CMP #$08
        blt :+
            ; tile = FIRST_HP_TILE + (7 << 4)
            mov @tile, #FIRST_HP_TILE + $70
            JMP :++
        ; else
        :
            ; tile = FIRST_HP_TILE + ((mh-1) << 4)
            sub #$01
            shift ASL, 4
            add #FIRST_HP_TILE
            STA @tile
        :

        ; if h < mh and if hp < 8
        LDA @h
        CMP @mh
        bge :++
        LDA #$08
        CMP @h
        ble :++
            ; tile += min(8, mh) - h
            CMP @mh
            blt :+
                LDA @mh
            :
            sub @h
            add @tile
            STA @tile
        :

        ; send tile
        @send:
        LDA @tile
        STA background, X
        INX

        ; h -= 8
        LDA @h
        sub #$08
        ; if h < 0 then h == 0
        BCS :+
            LDA #$00
        :
        STA @h
        ; mh -= 8
        LDA @mh
        sub #$08
        ; if mh < 0 then mh == 0
        BCS :+
            LDA #$00
        :
        STA @mh
    to_y_dec @loop, #0
    @break:
    TYA
    PHA

    ; convert player HP to string
    TXA
    PHA
    LDA player_stats + PlayerStat::hp
    JSR byte2dec
    PLA
    TAX
    ; send text
    LDA tmp+0
    STA background, X
    INX
    LDA tmp+1
    STA background, X
    INX
    LDA tmp+2
    STA background, X
    INX

    ; send '/'
    LDA #'/'
    STA background, X
    INX

    ; convert player max HP to string
    TXA
    PHA
    LDA player_stats + PlayerStat::maxhp
    JSR byte2dec
    PLA
    TAX
    ; send text
    LDA tmp+0
    STA background, X
    INX
    LDA tmp+1
    STA background, X
    INX
    LDA tmp+2
    STA background, X
    INX

    ; fill with empty tiles
    PLA
    TAY
    BEQ @fill_end
    LDA #$20
    @fill:
        STA background, X
        INX
        DEY
        BNE @fill
    @fill_end:

    ; close ppu packet
    LDA #$00
    STA background, X
    STX background_index

    ; clear update_player_hp_flag
    and_adr player_flag, #$FF - PLAYER_FLAG_DRAW_HP

    ; return
    @end:
    RTS

