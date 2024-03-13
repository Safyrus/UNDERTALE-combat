m_0_turn:
    @turn_stat = monster_vars+0
    @turn_time = monster_vars+1

    ; if not main monster
    LDA cur_monster_fight_pos
    BEQ :+
        ; return
        JMP @end_event
    :

    ; switch monster_vars[X][0]
    JSR get_var_idx
    LDA @turn_stat ,  X
    ; case 0
    BNE :+
        ; turn timer = $1E0 (8s)
        LDA #$E0
        STA @turn_time+0 ,  X
        LDA #$01
        STA @turn_time+1 ,  X
        ; turn state++
        INC @turn_stat ,  X
        ; switch to red soul
        JSR clear_main_box
        JSR text_post_process
        mov player_soul ,  #SOUL::RED
        JSR switch_player_soul
        ; change dialog box x size
        mov futur_box_pos_x1 ,  #$40
        mov futur_box_pos_x2 ,  #$C6
        
        @err:
        @end:
        RTS
    :
    ; case 1
    CMP #$01
    BNE :+
        ; if dialog box anim is done
        LDA dialogbox_anim_flag
        BNE @end
            ; turn state++
            INC @turn_stat ,  X
            RTS
    :
    ; case 2
    CMP #$02
    BNE @case2end
        ; if turn_time % $3F == 0
        LDA @turn_time+0 ,  X
        AND #$3F
        BNE @blt_end
            phx
            ; px = rng() % $7F + $40
            JSR rng
            AND #$7F
            add #$40
            TAX
            ; py = $80
            LDY #$80
            ; h_idx = new_hitbox(HITBOX::FOLLOW_DIAMOND, px, py)
            LDA #HITBOX::FOLLOW_DIAMOND
            JSR new_hitbox
            ; if error (not slot found)
            CPY #$FF
            BEQ @err
            ; hitbox[h_idx].w = 3
            TXA
            add #$03
            STA hitbox_w ,  Y
            ; hitbox[h_idx].h = 3
            LDA #$83
            STA hitbox_h ,  Y
            ; a_idx = add_anim(TESTOBUG_ANIMS_SPR_0)
            LDA #<ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_SPR_0
            STA tmp+0
            LDA #>ANIM_DATA_MONSTERS_TESTOBUG_ANIMS_SPR_0
            STA tmp+1
            JSR add_anim
            ; if error (not slot found)
            CMP #$FF
            BNE :+
                ; remove hitbox
                LDA #$00
                STA hitbox_t ,  Y
                BNE @err
            :
            INX
            TXA
            ; hitbox[h_idx].anim = a_idx
            STA hitbox_a ,  Y
            plx
        @blt_end:

        ; turn timer--
        dcx_16 @turn_time
        ; if turn timer == 0
        LDA @turn_time+1 ,  X
        BNE @end
        LDA @turn_time+0 ,  X
        BNE @end
            ; turn state = 0
            LDA #$00
            STA @turn_stat ,  X
            ; change dialog box x size
            mov futur_box_pos_x1 ,  #$08
            mov futur_box_pos_x2 ,  #$F6
            ; switch to menu soul
            mov player_soul ,  #SOUL::MENU
            JSR switch_player_soul
            
            JSR clear_hitbox
    @case2end:
    ; default
        @end_event:
        JMP clear_event
