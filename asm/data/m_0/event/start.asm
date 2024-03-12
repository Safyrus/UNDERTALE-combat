.macro call_read_dialog val
    load_dialog_arg val
    JSR read_dialog
.endmacro

.macro set_menu_dialog val
    load_dialog_arg val
    JSR menu_set_dialog
.endmacro

.macro const_to_xy val
    LDX #<val
    LDY #>val
.endmacro

m_0_start:
    ; if we are the first monster
    LDA cur_monster_fight_pos
    BNE @dialog_end
        ; change soul to menu
        mov player_soul ,  #SOUL::MENU
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
    LDA #<ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_BKG_1
    STA tmp+0
    LDA #>ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_BKG_1
    STA tmp+1
    JSR add_anim
    ; find and display sprite animation
    LDA #<ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_SPR_0
    STA tmp+0
    LDA #>ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_SPR_0
    STA tmp+1
    JSR add_anim

    ; monster_vars[X][0] = 0
    JSR get_var_idx
    LDA #$00
    STA monster_vars+0 ,  X

    ; init act size
    LDA data_act
    LDX cur_monster_fight_pos
    STA monster_act_str_size ,  X

    ; find the monster_act_str address to use
    LDA cur_monster_fight_pos
    JSR get_monster_act_str_adr_for_cur_monster

    ; copy act data to menu
    LDY #data_act_end-data_act-2
    @copy_act:
        LDA data_act+1 ,  Y
        STA (tmp) ,  Y
    to_y_dec @copy_act ,  #-1

    JMP m_0_clear_event
