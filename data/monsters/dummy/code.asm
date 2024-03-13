start:
    ; set starting dialog
    set_menu_dialog TXT_DUMMY_START
    
    ; change soul to menu
    mov player_soul, #SOUL::MENU
    JSR switch_player_soul

    ; find and display dummy
    display_anim ANIM_DATA_MONSTERS_DUMMY_NORMAL
    
    ; init act data
    sta_ptr tmp+2, dummy_act_txt
    JSR init_monster_act

    ; monster_vars[X][0] = 7
    JSR get_var_idx
    LDA #$07
    STA monster_vars+0, X
    ; monster_vars[X][1] = 0
    LDA #$00
    STA monster_vars+1, X

    ; clear event
    JMP clear_event

turn:
    ; monster_vars[X][1]
    JSR get_var_idx
    LDA monster_vars+1, X
    ; if monster_vars[X][1] == 0
    BNE @wait
    @start:
        ; monster_vars[X][1] = 1
        INC monster_vars+1, X
        ; turn remaining --
        JSR get_var_idx
        DEC monster_vars+0, X
        ; if turn remaining == 0
        BNE @normal
        @endfight:
            ; read_dialog(TXT_DUMMY_TIRED)
            call_read_dialog TXT_DUMMY_TIRED
            ; TODO: anim + delete monster
            ; return
            RTS
        ; else
        @normal:
            ; read_dialog(TXT_DUMMY_FIGHT)
            call_read_dialog TXT_DUMMY_FIGHT
            ; return
            RTS
    @wait:
        ; if waiting for dialog box
        LDA n_dialog
        BEQ :+
            ; return
            RTS
        :
        ; monster_vars[X][1] = 0
        DEC monster_vars+1, X
        ; if rng() % 2 == 0
        JSR rng
        LSR
        BCS :+
            ; set dialog
            set_menu_dialog TXT_DUMMY_RND_1
            ; clear event
            JMP :++
        :
            ; set dialog
            set_menu_dialog TXT_DUMMY_RND_2
        :
        ; change soul to menu
        mov player_soul, #SOUL::MENU
        JSR switch_player_soul
        ; clear event
        JMP clear_event

custom:
hit:
    ; clear event
    JMP clear_event
act:
    ; monster_vars[X][1]
    JSR get_var_idx
    LDA monster_vars+1, X
    ; if monster_vars[X][1] == 0
    BNE @wait
    @start:
        ; monster_vars[X][1] = 1
        INC monster_vars+1, X
        ; if act choice == 0 (Check)
        LDA act_choice
        BNE @talk
        @check:
            ; read_dialog(TXT_DUMMY_CHECK)
            call_read_dialog TXT_DUMMY_CHECK
            ; return
            RTS
        @talk:
            ; read_dialog(TXT_DUMMY_ACT_TALK)
            call_read_dialog TXT_DUMMY_ACT_TALK
            ; monster_flags[cur_monster_fight_pos] |= MONSTER_FLAG_SPARE
            LDX cur_monster_fight_pos
            LDA monster_flags, X
            ORA #MONSTER_FLAG_SPARE
            STA monster_flags, X
            ; return
            RTS
    ; else
    @wait:
        ; if waiting for dialog box
        LDA n_dialog
        BEQ :+
            ; return
            RTS
        :
        ; monster_vars[X][1] = 0
        DEC monster_vars+1, X
        ; clear event
        JMP clear_event

item:
spare:
flee:
    ; clear event
    JMP clear_event


dummy_act_txt:
.byte $02
.byte FONT_CHR_BNK, "* Check", $00, "       "
.byte FONT_CHR_BNK, "* Talk", $00, "        "
