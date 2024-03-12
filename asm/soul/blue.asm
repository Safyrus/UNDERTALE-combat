;--------------------------------
; Subroutine: switch_player_soul_to_blue
;--------------------------------
;
; Update variables to be able to switch to blue soul.
;
;--------------------------------
switch_player_soul_to_blue:
    ;
    mov palettes+15, #$12
    ora_adr nmi_flags, #NMI_PLT
    ;
    mov btn_timer_var, #$00
    ;
    JSR draw_update_menu
    ;
    mov btn_1_timer, #BTN_TIMER
    ;
    mov player_y_spd, #$00
    mov player_y_spd_dir, #$FF
    ; draw the player
    ora_adr player_flag, #PLAYER_FLAG_DRAW_PLAYER
    ; return
    RTS


;--------------------------------
; Subroutine: update_player_blue
;--------------------------------
;
; Update the player postion based on the d-pad and gravity.
;
;--------------------------------
update_player_blue:
    PHA

    ; switch(btn_1)
    LDA btn_1
    ; right
    LSR
    BCC :+
        ; player_x++
        INC player_x
    :
    ; left
    LSR
    BCC :+
        ; player_x--
        DEC player_x
    :
    ; down
    LSR
    ; if up
    LSR
    BCC :++
        ; if player_y == player_bound_y2
        PHA
        LDA player_y
        CMP player_bound_y2
        BNE :+
            ; player_y_spd = JUMP_FORCE
            mov player_y_spd, #JUMP_FORCE
            ; player_y_spd_dir = positive value
            mov player_y_spd_dir, #$00
        :
        PLA
        JMP :+++
    ; else
    :
        ; if player_y_spd_dir == UP
        LDA player_y_spd_dir
        BMI :+
            ; player_y_spd = 0
            mov player_y_spd, #$00
            ; player_y_spd_dir = negative value
            mov player_y_spd_dir, #$FF
        :
    :

    ; if player_y_spd_dir == UP
    LDA player_y_spd_dir
    BMI :++++
        ; player_y += player_y_spd
        sub_A2ptr player_suby, player_y_spd
        ; if UP button pressed
        LDA btn_1
        AND #BTN_UP
        BEQ :+
            ; player_y_spd -= JUMP_GRAVITY
            LDA player_y_spd
            sub #JUMP_GRAVITY
            STA player_y_spd
            JMP :++
        ; else
        :
            ; player_y_spd -= GRAVITY
            LDA player_y_spd
            sub #GRAVITY
            STA player_y_spd
        :
        ; if player_y_spd < 0
        BCS :+
            ; player_y_spd_dir = DOWN
            mov player_y_spd_dir, #$FF
            EOR player_y_spd
            STA player_y_spd
            INC player_y_spd
        :
        JMP :++
    ; else
    :
        ; player_y -= player_y_spd
        add_A2ptr player_suby, player_y_spd
        ; player_y_spd += GRAVITY
        LDA player_y_spd
        add #GRAVITY
        STA player_y_spd
    :

    ; if player_y_spd > MAX_GRAVITY
    LDA player_y_spd_dir
    BPL :+
    LDA #MAX_GRAVITY
    CMP player_y_spd
    bge :+
        ; player_y_spd = MAX_GRAVITY
        STA player_y_spd
    :

    ; if player_y >= player_bound_y2
    LDA player_y
    CMP player_bound_y2
    blt :+
        ; player_y_spd = 0
        mov player_y_spd, #$00
        ; player_y = player_bound_y2
        ; mov player_y, player_bound_y2
        ;
        ; JMP :+
    :

    ; debug for now
    LDA btn_1
    AND #BTN_START
    BEQ :+
        mov player_soul, #SOUL::MENU
        JSR switch_player_soul
    :

    ; return
    PLA
    RTS
