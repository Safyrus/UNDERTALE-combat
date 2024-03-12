;################
; File: player
;################
; subrountines related to the player

;--------------------------------
; Subroutine: switch_player_soul
;--------------------------------
;
; Switch the player soul by calling the correct soul switching subroutine.
;
;--------------------------------
switch_player_soul:
    ; X = player_soul
    LDA player_soul
    ASL
    TAX

    ; jump(soul_type[X])
    LDA @soul_type+1, X
    PHA
    LDA @soul_type, X
    PHA
    RTS

    @soul_type:
    .word switch_player_soul_to_menu-1
    .word switch_player_soul_to_red-1
    .word switch_player_soul_to_blue-1
    .word switch_player_soul_to_fight-1
    .word switch_player_soul_to_wait-1

;--------------------------------
; Subroutine: update_player
;--------------------------------
;
; Update player movement or action by calling the correct soul update subroutine.
;
;--------------------------------
update_player:

    ; X = player_soul
    LDA player_soul
    ASL
    TAX

    ; jump(soul_type[X])
    LDA #>(@ret-1)
    PHA
    LDA #<(@ret-1)
    PHA
    LDA @soul_type+1, X
    PHA
    LDA @soul_type, X
    PHA
    RTS

    @soul_type:
    .word update_player_menu-1
    .word update_player_red-1
    .word update_player_blue-1
    .word update_player_fight-1
    .word update_player_wait-1


    @ret:
    ; if player soul != menu soul or fight soul or wait soul
    LDA player_soul
    CMP #SOUL::MENU
    BEQ :+++++
    CMP #SOUL::FIGHT
    BEQ :+++++
    CMP #SOUL::WAIT
    BEQ :+++++
        ; if player_bound_x2 < player_x
        LDA player_bound_x2
        CMP player_x
        bge :+
            ; player_x = player_bound_x2
            STA player_x
        :
        ; if player_bound_x1 >= player_x
        LDA player_bound_x1
        CMP player_x
        blt :+
            ; player_x = player_bound_x1
            STA player_x
        :
        ; if player_bound_y2 < player_y
        LDA player_bound_y2
        CMP player_y
        bge :+
            ; player_y = player_bound_y2
            STA player_y
        :
        ; if player_bound_y1 >= player_y
        LDA player_bound_y1
        CMP player_y
        blt :+
            ; player_y = player_bound_y1
            STA player_y
        :
    :

    ; return
    RTS


;--------------------------------
; Subroutine: center_player
;--------------------------------
;
; Set the player postion to the center of the bounding box
;
;--------------------------------
center_player:
    PHA

    ; center player x postion to bounding box
    mov player_x, player_bound_x1 ; player_x = player_bound_x1
    LDA player_bound_x2 ; a = player_bound_x2 - player_bound_x1
    sub player_bound_x1 ;
    LSR ; a //= 2
    ADC player_x ; player_x += a
    STA player_x ;

    ; center player y postion to bounding box
    mov player_y, player_bound_y1 ; player_y = player_bound_y1
    LDA player_bound_y2 ; a = player_bound_y2 - player_bound_y1
    sub player_bound_y1 ;
    LSR ; a //= 2
    ADC player_y ; player_y += a
    STA player_y ;
    
    ; return
    PLA
    RTS
