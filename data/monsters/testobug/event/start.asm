start:
    ; if we are the first monster
    LDA cur_monster_fight_pos
    BNE @dialog_end
        ; change soul to menu
        mov player_soul, #SOUL::MENU
        JSR switch_player_soul

        ; rng()
        JSR rng
        ; choose random dialog
        LSR
        BCC :+
            set_menu_dialog TXT_START_1
            JMP @dialog_end
        :
        LSR
        BCC :+
            set_menu_dialog TXT_START_2
            JMP @dialog_end
        :
            set_menu_dialog TXT_START_3
    @dialog_end:

    ; find and display background animation
    display_anim ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_BKG_1
    ; find and display sprite animation
    display_anim ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_SPR_0

    ; monster_vars[X][0] = 0
    JSR get_var_idx
    LDA #$00
    STA monster_vars+0, X

    ; init act data
    sta_ptr tmp+2, data_testobug_act
    JSR init_monster_act

    JMP clear_event
