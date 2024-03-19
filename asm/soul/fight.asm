;--------------------------------
; Subroutine: switch_player_soul_to_fight
;--------------------------------
;
; Update variables to be able to switch to fight soul.
;
;--------------------------------
switch_player_soul_to_fight:
    ; change soul color to red
    mov palettes+15, #$16
    ora_adr nmi_flags, #NMI_PLT
    ; move player off screen
    LDA #$FF
    STA player_x
    STA player_y
    ; init fight timer to 127
    LDA #$7F
    STA fight_timer
    ; damage done = 0
    mov fight_damage, #0
    ; marker pos = 0
    STA fight_markpos
    ; make input take time
    mov btn_timer_var, #BTN_TIMER / 2
    STA btn_1_timer
    ; find and display atk_img
    LDA #<ANIM_DATA_MONSTERS_ATKIMG_L
    STA tmp+0
    LDA #>ANIM_DATA_MONSTERS_ATKIMG_L
    STA tmp+1
    LDX #$10
    LDY #$88
    JSR draw_bkg_img
    ; (right part)
    LDA #<ANIM_DATA_MONSTERS_ATKIMG_R
    STA tmp+0
    LDA #>ANIM_DATA_MONSTERS_ATKIMG_R
    STA tmp+1
    LDX #$80
    LDY #$88
    JSR draw_bkg_img
    ; do not draw the player
    and_adr player_flag, #$FF - PLAYER_FLAG_DRAW_PLAYER
    ; return
    RTS


;--------------------------------
; Subroutine: update_player_fight
;--------------------------------
;
; Check for player inputs during fight.
;
;--------------------------------
update_player_fight:
    LDA fight_state
    BNE @anim
    @atk:
        JMP update_player_fight_atk
    @anim:
        JMP dmg_anim


update_player_fight_atk:
    PHA

    ; if fight_timer == 0
    LDA fight_timer
    BNE :+
        ; miss
        mov fight_damage, #0
        ;
        JMP @event
    :

    ; fight_timer--
    DEC fight_timer
    ; fight_markpos++
    INC fight_markpos
    INC fight_markpos

    JSR draw_hitmark

    ; if A is pressed
    LDA btn_1
    AND #%10000000
    BEQ @end

        @hit:
        ; update_damage()
        JSR update_damage

        @event:
        ; fight_state++
        INC fight_state
        ; fight_timer = 0
        mov fight_timer, #$00

    ; return
    @end:
    PLA
    RTS



update_damage:
    push_ax

    ; find monster stats
    LDA selected_monster
    shift ASL, MONSTER_STAT_SHIFT
    TAX

    ; damage = atk - monster.def
    LDA player_stats + PlayerStat::atk
    sub monster_stats + MonsterStat::def, X
    ; if underflow or damage == 0 then damage = 1
    BCS :+
        LDA #$01
    :
    BNE :+
        LDA #$01
    :
    STA fight_damage

    ; if markpos < center
    LDA fight_markpos
    BMI :+
        ; dist = center - fight_markpos - 1
        LDA #$80
        CLC
        SBC fight_markpos
        JMP :++
    ; else
    :
        ; dist = fight_markpos - center
        sub #$80
    :
    ; dist = 15 - (dist >> 3)
    shift LSR, 3
    STA tmp
    LDA #15
    sub tmp
    TAX

    ; damage *= 2
    LDA fight_damage
    ASL
    ; if overflow
    CMP fight_damage
    bge :+
        ; damage = $FF
        LDA #$FF
    :

    ; damage *= dist
    STA MMC5_MUL_A
    STX MMC5_MUL_B
    ; if damage > 255
    LDA MMC5_MUL_B
    BEQ :+
        ; damage = 255
        LDA #$FF
        JMP :++
    ; else
    :
        ; damage >>= 3
        LDA MMC5_MUL_A
        shift LSR, 3
    :
    STA fight_damage

    pull_ax
    RTS
