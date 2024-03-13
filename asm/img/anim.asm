; tmp = anim data idx
; return X = anim idx (-1 = not found)
add_anim:
    for_x @loop, #MAX_ANIM-1
        ; if animation is not set
        LDA anims_flag, X
        BMI :+
            AND #$FC
            ORA cur_monster_fight_pos
            STA anims_flag, X
            ; add anim there
            JMP draw_anim
        :
    to_x_dec @loop, #-1
    LDX #$FF
    RTS


update_anims:
    ; for each background animation
    for_x @loop, #MAX_ANIM-1
        ; if animation is set
        LDA anims_flag, X
        BPL @continue
            ; if animation delay == 0
            LDA anims_delay, X
            BNE @else
                ; disable animation
                LDA #$7F
                AND anims_flag, X
                STA anims_flag, X
                ; get monster pos from flags
                ; LDA anims_flag, X
                AND #$03
                STA cur_monster_fight_pos
                ; clear entity sprites
                phx
                JSR clear_entity_spr
                plx
                ; tmp = anim index
                LDA anims_next_hi, X
                STA tmp+1
                LDA anims_next_lo, X
                STA tmp+0
                ; if anim index != 0
                BNE :+
                LDA tmp+1
                BEQ @ifend
                :
                    ; draw animation
                    JSR draw_anim
                    JMP @ifend
            ; else
            @else:
                ; delay--
                DEC anims_delay, X
            @ifend:
        @continue:
    to_x_dec @loop, #-1
    RTS
