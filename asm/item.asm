
; Y = item idx
; return in tmp
get_item_name_adr:
    ; low
    TYA
    shift ASL, ITEM_NAME_SHIFT
    STA tmp+0

    ; high
    TYA
    shift LSR, 8-ITEM_NAME_SHIFT
    ORA #>item_names
    STA tmp+1

    ; return
    RTS


; X = item id
use_item:
    ; set item names bank
    JSR item_setbank

    LDA #>(item_return-1)
    PHA
    LDA #<(item_return-1)
    PHA
    JMP (item_adr)


; X = item id
find_item:
    ; set item names bank
    JSR item_setbank

    ; item_adr = item_code
    sta_ptr item_adr, item_code

    ; Y = 0
    LDY #$00
    @loop:
        ; if x == 0
        CPX #$00
            ; break
            BEQ @loop_end
        ; X--
        DEX
        ; item_adr += code size
        LDA (item_adr), Y
        add_A2ptr item_adr
        ; item_adr ++ (size does not count the size byte)
        inc_16 item_adr
        ; continue
        JMP @loop
    @loop_end:

    ; item_adr ++ (size does not count the size byte)
    inc_16 item_adr

    JMP item_return


item_setbank:
    ; set item names bank
    LDA #<.bank(item_code)+$80
    STA MMC5_PRG_BNK0
    RTS


item_return:
    ; restore bank
    LDA mmc5_banks+1
    STA MMC5_PRG_BNK0
    ; return
    RTS


end_item:
    LDA #$00
    STA item_adr+0
    STA item_adr+1
    LDA #EVENT::ITEM
    STA monster_0_event
    STA monster_1_event
    STA monster_2_event
    RTS


; X = idx
remove_item:
    ; while X != INV_SIZE-1
    CPX #INV_SIZE-1
    BEQ @end
        ; player_inv[X] = player_inv[X+1]
        LDA player_inv+1, X
        STA player_inv+0, X
        ; X++
        INX
        ; while
        BNE remove_item ; JMP

    @end:
    ; player_inv[X] = 0
    LDA #$00
    STA player_inv, X
    ; return
    RTS
