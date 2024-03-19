dmg_anim:

    ; if fight_timer == 0
    LDA fight_timer
        ; goto init
        BEQ @init
    ; elif fight_timer < FIGHT_STRICK_TIME
    CMP #FIGHT_STRICK_TIME
        ; goto strick_anim
        blt @strick_anim
    ; elif fight_timer < FIGHT_NUMBER_TIME + FIGHT_STRICK_TIME
    CMP #FIGHT_NUMBER_TIME + FIGHT_STRICK_TIME
        ; goto number_anim
        blt @number_anim
    ; else
        ; goto end_anim

    @end_anim:
        ; clear_main_box()
        JSR clear_main_box
        ; call monster hit event
        mvx cur_monster_fight_pos, selected_monster
        LDA #EVENT::HIT
        STA monster_events, X
        ; fight_state--
        DEC fight_state
        ; fight_timer = 0
        mov fight_timer, #0
        ; switch to wait soul
        mov player_soul, #SOUL::WAIT
        JSR switch_player_soul
        ; set CHR bank 0 to player sprites
        mov MMC5_CHR_BNK0, #PLAYER_SPRITE_BNK
        ; return
        RTS


    @init:
        ; display strick anim
        ; TODO
        ; dmg -> BCD
        mov tmp+0, fight_damage
        mov tmp+1, #0
        JSR int16_2_bcd
        mov fight_bcd+0, tmp+2
        mov fight_bcd+1, tmp+3
        mov fight_bcd+2, tmp+4
        ;
        JMP @end

    @strick_anim:
        JSR draw_hitmark
        JMP @end

    @number_anim:
        ; set CHR bank 0 to dmg sprites
        mov MMC5_CHR_BNK0, #DMG_SPRITE_BNK
        ; xy pos
        JSR monster_fightid_to_pos
        TXA
        sub #$08
        STA tmp+1
        STY tmp+2
        ;
        LDA fight_damage
        BEQ @miss
            ; 10000
            LDA fight_bcd+2
            AND #$0F
            BEQ :+ ; skip if == 0
                STA tmp
                JSR draw_digit
            :
            ; 1000
            LDA fight_bcd+1
            shift LSR, 4
            BEQ :+ ; skip if == 0
                STA tmp
                JSR draw_digit
            :
            ; 100
            LDA fight_bcd+1
            AND #$0F
            BEQ :+ ; skip if == 0
                STA tmp
                JSR draw_digit
            :
            ; 10
            LDA fight_bcd+0
            shift LSR, 4
            BEQ :+ ; skip if == 0
                STA tmp
                JSR draw_digit
            :
            ; 1
            LDA fight_bcd+0
            AND #$0F
            STA tmp
            JSR draw_digit
            ;
            JMP @end
        @miss:
            ; 1
            mov tmp, #$0A
            JSR draw_digit
            ;
            JMP @end

    @end:
    ; fight_timer++
    INC fight_timer
    ; return
    RTS


; tmp = digit
; tmp+1 = x pos
; tmp+2 = y pos
draw_digit:
    @param_x = tmp+1
    @param_y = tmp+2
    pushregs

    ; X = digit
    LDX tmp
    ; Y = number of sprite ((table_dmg_sprite[X+1] - table_dmg_sprite[X]) / 2)
    LDA table_dmg_sprite+1, X
    sub table_dmg_sprite, X
    LSR
    TAY
    ; X = offset in dmg_sprites
    LDA table_dmg_sprite, X
    TAX

    ; for each sprite
    @loop:
        phy
        ; get sprite pos in oam
        LDA oam_size
        ASL
        ASL
        TAY
        ; y
        LDA @param_y
        STA OAM+0, Y
        ; tile
        LDA dmg_sprites, X
        STA OAM+1, Y
        INX
        ; atr
        LDA dmg_sprites, X
        STA OAM+2, Y
        INX
        ; x
        LDA @param_x
        STA OAM+3, Y
        ; param_x += 8
        add #$08
        STA @param_x

        ; oam_size++
        INC oam_size
        ;
        ply
    to_y_dec @loop, #0

    ; return
    pullregs
    RTS
