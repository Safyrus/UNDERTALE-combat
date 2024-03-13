clear_event:
    LDA #$00
    LDX cur_monster_fight_pos
    STA monster_events, X
    RTS


get_var_idx:
    ; X = cur_monster_fight_pos << 3
    LDA cur_monster_fight_pos
    shift ASL, 3
    TAX
    RTS

; tmp+2 = act data adr
init_monster_act:
    ; size = data[0]
    LDY #$00
    LDA (tmp+2), Y
    ; monster_act_str_size[X] = size
    LDX cur_monster_fight_pos
    STA monster_act_str_size ,  X
    ; Y = size << 4
    shift ASL, 4
    TAY

    ; find the monster_act_str address to use
    LDA cur_monster_fight_pos
    JSR get_monster_act_str_adr_for_cur_monster

    ; data++
    inc_16 tmp+2
    ; copy act data to menu
    @copy_act:
        LDA (tmp+2), Y
        STA (tmp), Y
    to_y_dec @copy_act ,  #-1
    ; return
    RTS
