;--------------------------------
; Subroutine: switch_player_soul_to_red
;--------------------------------
;
; Update variables to be able to switch to red soul.
;
;--------------------------------
switch_player_soul_to_red:
    ;
    mov palettes+15, #$16
    ora_adr nmi_flags, #NMI_PLT
    ;
    mov btn_timer_var, #$00
    ;
    JSR draw_update_menu
    ;
    mov btn_1_timer, #BTN_TIMER
    ; draw the player
    ora_adr player_flag, #PLAYER_FLAG_DRAW_PLAYER
    ; move player to the center of the bounding box
    JMP center_player


;--------------------------------
; Subroutine: update_player_red
;--------------------------------
;
; Update the player postion based on the d-pad.
;
;--------------------------------
update_player_red:
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
    BCC :+
        ; player_y++
        INC player_y
    :
    ; up
    LSR
    BCC :+
        ; player_y--
        DEC player_y
    :

    ; debug for now
    LDA btn_1
    AND #BTN_START
    BEQ :+
        mov player_soul, #SOUL::BLUE
        JSR switch_player_soul
    :

    ; return
    PLA
    RTS
