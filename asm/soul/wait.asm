;--------------------------------
; Subroutine: switch_player_soul_to_wait
;--------------------------------
;
; Update variables to be able to switch to wait soul.
;
;--------------------------------
switch_player_soul_to_wait:
    ; move player off screen
    LDA #$FF
    STA player_x
    STA player_y
    ; deselect any main buttons
    JSR draw_update_menu
    ; do not draw the player
    and_adr player_flag, #$FF - PLAYER_FLAG_DRAW_PLAYER
    ; return
    RTS


;--------------------------------
; Subroutine: update_player_wait
;--------------------------------
;
; Do almost nothing.
;
;--------------------------------
update_player_wait:
    ; if B button
    LDA btn_1
    AND #BTN_B
    BEQ :+
        ; skip dialog
        JSR all_dialog_spd_to_zero
    :
    ; return
    RTS
