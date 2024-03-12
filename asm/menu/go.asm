; menu_main
; -> menu_fight
;    -> monster_0
;    -> monster_1
;    -> monster_2
; -> menu_act
;    -> menu_monster_0_act
;       -> act_0
;       -> act_1
;       -> act_2
;       -> ...
;    -> menu_monster_1_act
;       -> act_0
;       -> act_1
;       -> act_2
;       -> ...
;    -> menu_monster_2_act
;       -> act_0
;       -> act_1
;       -> act_2
;       -> ...
; -> menu_item
;    -> item_0
;    -> item_1
;    -> item_2
;    -> ...
; -> menu_mercy
;    -> menu_spare
;    -> flee


menu_go_item_choice:
    ; get item id
    LDA player_inv, X
    PHA
    ; remove item from inventory
    JSR remove_item
    ; reset item variable
    STA item_var
    ; find_item(id)
    plx
    JSR find_item
    ; clear_inside_box()
    JSR clear_inside_box
    ; switch player to wait soul and return
    mov player_soul, #SOUL::WAIT
    JMP switch_player_soul


menu_go_flee:
    JMP menu_ret


menu_go_item:
    ; menu_size = 0
    mov menu_size, #$00

    ; set item names bank
    LDA mmc5_banks+1
    PHA
    LDA #<.bank(item_names)+$80
    STA mmc5_banks+1
    STA MMC5_PRG_BNK0

    ; for item in inv size
    for_x @loop, #INV_SIZE-1
        ; if item == 0
        LDA player_inv, X
            ; continue
            BEQ @continue
        ; Y = item.idx
        TAY
        ; menu_size++
        INC menu_size

        ; menu_list_pos_x[X] = menu_data_pos_x[X]
        LDA menu_data_pos_x, X
        STA menu_list_pos_x, X
        ; menu_list_pos_y[X] = menu_data_pos_y[X]
        LDA menu_data_pos_y, X
        STA menu_list_pos_y, X

        ; menu_list[X] = menu_go_item_choice
        LDA #<menu_go_item_choice
        STA menu_list_lo, X
        LDA #>menu_go_item_choice
        STA menu_list_hi, X

        ; item.name
        JSR get_item_name_adr
        ; idx = X << 4
        phx
        TXA
        shift ASL, 4
        TAX
        ; for c in item.name
        for_y @name, #$00
            ; menu_list_str[idx][Y] = c
            LDA (tmp), Y
            STA menu_list_str, X
            INX
        to_y_inc @name, #ITEM_NAME_SIZE
        plx

        @continue:
    to_x_dec @loop, #-1

    ; restore bank
    PLA
    STA mmc5_banks+1
    STA MMC5_PRG_BNK0

    ; if no item
    LDA menu_size
    BNE :+
        ; cancel menu & return
        JMP menu_ret
    ; else
    :
        ; draw_menu & return
        JMP draw_menu


menu_go_act_monster_choice:
    ; act event
    LDA #EVENT::ACT
    STA monster_events, X
    ; reset menu
    JMP menu_init


menu_go_act_monster:
    ; skip if act size == 0
    LDA monster_act_str_size, X
    BNE :+
        JMP menu_ret
    :
    ; menu_size = act size
    STA menu_size

    ; tmp = monster_act_str[X]
    TXA
    JSR get_monster_act_str_adr_for_cur_monster
    ; X = act size - 1
    LDX menu_size
    DEX
    ;
    @loop:
        ; menu_list_pos_x[X] = menu_data_pos_x[X]
        LDA menu_data_pos_x, X
        STA menu_list_pos_x, X
        ; menu_list_pos_y[X] = menu_data_pos_y[X]
        LDA menu_data_pos_y, X
        STA menu_list_pos_y, X
        ; menu_list[X] = menu_go_act_monster_choice
        LDA #<menu_go_act_monster_choice
        STA menu_list_lo, X
        LDA #>menu_go_act_monster_choice
        STA menu_list_hi, X
        ;
        TXA
        shift ASL, 4
        TAY
        @copy:
            LDA (tmp), Y
            STA menu_list_str, Y
            ; continue
            INY
            TYA
            AND #$0F
            BNE @copy
    to_x_dec @loop, #-1
    JMP draw_menu


menu_go_main:
    sta_ptr tmp, menu_data_main
    JSR menu_setup
    ;
    LDX #$03
    @copy_pos:
        LDA menu_data_main_pos_x, X
        STA menu_list_pos_x, X
        LDA #224
        STA menu_list_pos_y, X
    to_x_dec @copy_pos, #-1
    ;
    JSR update_player_menu_pos
    ;
    JSR clear_inside_box
    ;
    LDA menu_dialog_flag
    BEQ :+
        JSR menu_update_dialog
    :
    ;
    JMP draw_update_menu


menu_go_mercy:
    ; set menu pointers
    sta_ptr tmp, menu_data_mercy
    JSR menu_setup
    ; set menu positions
    LDA menu_data_pos_x
    STA menu_list_pos_x+0
    STA menu_list_pos_x+1
    LDA menu_data_pos_y_ver+0
    STA menu_list_pos_y+0
    LDA menu_data_pos_y_ver+1
    STA menu_list_pos_y+1
    ; set menu text
    for_x @copy, #$1F
        LDA menu_data_spare, X
        STA menu_list_str, X
    to_x_dec @copy, #-1

    ; change color of spare if needed
    @spare:
        ; can_be_spare = monster_flags[X] & MONSTER_FLAG_SPARE
        INX
        LDA monster_flags+0, X
        AND #MONSTER_FLAG_SPARE
        ; if can_be_spare
        BEQ :+
            ;
            LDA #FONT_CHR_BNK+1
            STA menu_list_str+0
        :
        ; continue
        CPX #$02
        BNE @spare

    ; draw the menu
    JMP draw_menu


menu_go_act:
    sta_ptr tmp, menu_go_act_monster
    JMP menu_setup_monster


menu_go_fight:
    sta_ptr tmp, menu_go_fight_monster
    JMP menu_setup_monster


menu_go_spare:
    ; spare event
    LDA #EVENT::SPARE
    STA monster_events+0
    STA monster_events+1
    STA monster_events+2
    ; reset menu
    JMP menu_init


menu_go_fight_monster:
    ; save choosen monster
    STX fight_monster
    ; switch player to fight soul and return
    mov player_soul, #SOUL::FIGHT
    JMP switch_player_soul


menu_data_main:
    .byte $04
    .word menu_go_fight
    .word menu_go_act
    .word menu_go_item
    .word menu_go_mercy
menu_data_main_pos_x:
    .byte $0C
    .byte $4C
    .byte $8C
    .byte $CC

menu_data_mercy:
    .byte $02
    .word menu_go_spare
    .word menu_go_flee

menu_data_pos_x:
    .byte 2*8+4
    .byte 15*8+4
    .byte 2*8+4
    .byte 15*8+4
    .byte 2*8+4
    .byte 15*8+4
menu_data_pos_y:
    .byte 17*8+4
    .byte 17*8+4
    .byte 19*8+4
    .byte 19*8+4
    .byte 21*8+4
    .byte 21*8+4

menu_data_pos_y_ver:
    .byte 17*8+4
    .byte 19*8+4
    .byte 21*8+4

menu_data_spare:
    .byte FONT_CHR_BNK, "* Spare", $00, "       "
    .byte FONT_CHR_BNK, "* Flee", $00, "        "
