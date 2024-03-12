; X, Y = (lo), (hi)
; return
; tmp - img adr
; tmp+2 - bank
find_rleimg:
    ; save bank
    LDA mmc5_banks+1
    PHA
    ; change bank
    LDA #MONSTER_IMG_BNK
    STA tmp+2
    STA mmc5_banks+1
    STA MMC5_PRG_BNK0
    ; adr = monster_img_data
    sta_ptr tmp, monster_img_data
    ; while idx > 0
    @while_y:
        TYA
        PHA
        CPX #$00
        BEQ @while_x_end
        LDY #$00
        @while_x:
            ; size = *adr
            LDA (tmp), Y
            ; adr += len + 1
            add_A2ptr tmp
            inc_16 tmp
            ; if adr outside of bank
            LDA tmp+1
            CMP #$A0
            blt :+
                ; bnk++
                INC tmp+2
                ; offset adr
                sub #$20
                STA tmp+1
            :
            ; idx--
            DEX
            BNE @while_x
        @while_x_end:
        LDX #$FF
        PLA
        TAY
    to_y_dec @while_y, #-1
    ; restore bank
    PLA
    STA mmc5_banks+1
    STA MMC5_PRG_BNK0
    ; return adr++
    inc_16 tmp
    RTS
