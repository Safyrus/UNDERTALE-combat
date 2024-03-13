;--------------------------------
; Subroutine: switch_player_soul_to_menu
;--------------------------------
;
; Update variables to be able to switch to menu soul.
;
;--------------------------------
switch_player_soul_to_menu:
    ; change soul color to red
    mov palettes+15, #$16
    ora_adr nmi_flags, #NMI_PLT
    ; make input take time
    mov btn_timer_var, #BTN_TIMER
    STA btn_1_timer
    ;
    JSR menu_init
    ; draw the player
    ora_adr player_flag, #PLAYER_FLAG_DRAW_PLAYER
    ; return
    RTS


;--------------------------------
; Subroutine: update_player_menu
;--------------------------------
;
; Update the player postion based on the menu.
;
;--------------------------------
update_player_menu:
    PHA

    ; set player position
    JSR update_player_menu_pos

    ; right / down
    LDA btn_1
    AND #%00000101
    BEQ :+
        ;
        JSR menu_down
        ; update main menu
        JSR update_player_menu_pos
        JSR draw_update_menu
    :
    ; left / up
    LDA btn_1
    AND #%00001010
    BEQ :+
        ;
        JSR menu_up
        ; update main menu
        JSR update_player_menu_pos
        JSR draw_update_menu
    :
    LDA btn_1
    LSR
    LSR
    LSR
    LSR
    ; start
    LSR
    BCC :+
        JSR clear_main_box
        JSR text_post_process
        mov player_soul, #SOUL::RED
        JSR switch_player_soul
        JMP @end
    :
    ; select
    LSR
    BCC :+
        LDX cur_music
        INC cur_music
        JSR play_music
        JMP @end
    :
    ; B
    LSR
    BCC :+
        JSR all_dialog_spd_to_zero
        JSR menu_ret
        JMP @end
    :
    ; A
    LSR
    BCC :+
        JSR menu_go
        JSR draw_update_menu
        JMP @end
    :

    ; return
    @end:
    PLA
    RTS



update_player_menu_pos:
    LDX menu_idx
    LDA menu_list_pos_x, X
    STA player_x
    LDA menu_list_pos_y, X
    STA player_y
    RTS
