;--------------------------------
; Subroutine: draw_player
;--------------------------------
;
; Draw the player soul at the player position.
;
;--------------------------------
draw_player:
    ; y
    LDA player_y
    sub #$05
    STA PLAYER_SPRITE+0
    ; tile
    mov PLAYER_SPRITE+1, #SOUL_TILE
    ; atr
    mov PLAYER_SPRITE+2, #SOUL_PLT
    ; x
    LDA player_x
    sub #$04
    STA PLAYER_SPRITE+3

    INC oam_size

    ; return
    RTS
