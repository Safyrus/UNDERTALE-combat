load_fight:
    push_ay

    ; compute fight adr
    LDA fight_id
    shift ASL, FIGHT_SHIFT
    STA tmp+0
    LDA fight_id
    shift LSR, 8-FIGHT_SHIFT
    ORA #>fights
    STA tmp+1

    ; set PRG bank
    mov MMC5_PRG_BNK1, #FIGHT_BNK
    STA mmc5_banks+2

    ; load fight monster number
    LDY #$00
    LDA (tmp), Y
    AND #FIGHT_FLAG_N_MONSTER
    STA n_monster
    ; load fight monster ids
    INY
    LDA (tmp), Y
    STA monster_0_id
    INY
    LDA (tmp), Y
    STA monster_1_id
    INY
    LDA (tmp), Y
    STA monster_2_id

    ;
    JSR load_monsters_stats
    JSR load_monsters_name
    ;
    LDA #EVENT::START
    STA monster_0_event
    STA monster_1_event
    STA monster_2_event

    ; return
    pull_ay
    RTS

load_monsters_stats:
    push_ax

    ; set PRG bank
    mov MMC5_PRG_BNK1, #MONSTER_STAT_BNK
    STA mmc5_banks+2

    ; if n_monster == 0 then return
    LDX n_monster
    BEQ @end
    ; for each monster
    DEX
    @loop:
        ; load_monster_stats(monster_id)
        LDA monster_ids, X
        JSR load_monster_stats
    to_x_dec @loop, #-1

    @end:
    pull_ax
    RTS


; A = monster id
; X = monster pos
load_monster_stats:
    STA tmp+1
    pushregs

    ; compute stat adr
    LDA tmp+1
    shift ASL, MONSTER_STAT_SHIFT
    STA tmp+0
    LDA tmp+1
    shift LSR, 8-MONSTER_STAT_SHIFT
    ORA #>monster_stats_data
    STA tmp+1

    ; compute stat offset
    ; X = (X+1) << MONSTER_STAT_SHIFT
    INX
    TXA
    shift ASL, MONSTER_STAT_SHIFT
    TAX

    ; copy stats
    for_y @loop, #(1 << MONSTER_STAT_SHIFT) - 1
        DEX
        LDA (tmp), Y
        STA monster_stats, X
    to_y_dec @loop, #-1

    ; return
    pullregs
    RTS


load_monsters_name:
    push_ax

    ; set PRG bank
    mov MMC5_PRG_BNK1, #MONSTER_NAME_BNK
    STA mmc5_banks+2

    ; if n_monster == 0 then return
    LDX n_monster
    BEQ @end
    ; for each monster
    DEX
    @loop:
        ; load_monster_name(monster_id)
        LDA monster_ids, X
        JSR load_monster_name
    to_x_dec @loop, #-1

    @end:
    pull_ax
    RTS


; A = monster id
; X = monster pos
load_monster_name:
    STA tmp+1
    pushregs

    ; compute name adr
    LDA tmp+1
    shift ASL, 3
    STA tmp+0
    LDA tmp+1
    shift LSR, 5
    ORA #>monster_names_data
    STA tmp+1

    ; compute stat offset
    ; X = (X+1) << 3
    INX
    TXA
    shift ASL, 3
    TAX

    ; copy name
    for_y @loop, #(1 << 3) - 1
        DEX
        LDA (tmp), Y
        STA monster_names, X
    to_y_dec @loop, #-1

    ; return
    pullregs
    RTS
