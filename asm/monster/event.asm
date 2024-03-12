update_monster_events:
    ; if n_monster == 0 then return
    LDY n_monster
    BEQ @end
    ; for each monster
    DEY
    @loop:
        ; if monster has an event
        LDA monster_events, Y
        STA monster_last_events, Y
        BEQ @call_end
            ; X = event--
            TAX
            DEX
            ; if event id >= 7
            CPX #$07
            blt :+
                LDX EVENT::CUSTOM
            :
            ; cur_monster_fight_pos = Y
            STY cur_monster_fight_pos
            ; call_monster_event(monster_id, event_type)
            LDA monster_ids, Y
            JSR call_monster_event
        @call_end:
        ; if monster event == NONE
        LDA monster_events, Y
        BNE :+
        ; and monster event has changed
        CMP monster_last_events, Y
        BEQ :+
        ; and last event was not START,TURN or CUSTOM
        LDA monster_last_events, Y
        AND #$FC
        BEQ :+
            ; change monster event to turn event
            LDA #EVENT::TURN
            STA monster_0_event
            STA monster_1_event
            STA monster_2_event
        :
    to_y_dec @loop, #-1

    @end:
    RTS


; A = monster id
; X = event type
; use tmp 0-3
call_monster_event:
    STA tmp+1
    pushregs

    ; save bank
    push mmc5_banks+1

    ; compute code adr
    LDA tmp+1
    PHA
    shift ASL, MONSTER_CODE_SHIFT
    STA tmp+0
    LDA tmp+1
    shift LSR, 8-MONSTER_CODE_SHIFT
    ORA #>monster_code_struct
    STA tmp+1

    ; set PRG bank
    mov MMC5_PRG_BNK1, #MONSTER_CODE_STRUCT_BNK
    STA mmc5_banks+2

    ; first event adr
    ; tmp+2 = (tmp)
    LDY #$00
    LDA (tmp), Y
    STA tmp+2
    INY
    LDA (tmp), Y
    STA tmp+3
    INY
    ; find event adr
    @find_adr:
        ; if x == 0 then break
        CPX #$00
        BEQ @adr_found
        ; tmp+2 += (tmp)
        LDA (tmp), Y
        INY
        add_A2ptr tmp+2
        LDA (tmp), Y
        INY
        add tmp+3
        STA tmp+3
        ; next
        DEX
        BNE @find_adr
    @adr_found:

    ; set monster code PRG bank
    mov MMC5_PRG_BNK1, #MONSTER_CODE_BNK_BNK
    STA mmc5_banks+2
    PLA
    TAX
    LDA monster_code_bnk, X
    STA mmc5_banks+1
    STA MMC5_PRG_BNK0

    ; push return adr
    LDA #>(@end-1)
    PHA
    LDA #<(@end-1)
    PHA
    ; call
    JMP (tmp+2)

    @end:
    ; restore bank
    pull mmc5_banks+1
    STA MMC5_PRG_BNK0
    ; return
    pullregs
    RTS

