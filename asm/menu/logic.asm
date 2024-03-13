push_menu:
    LDX menu_stack_idx
    LDA tmp+0
    STA menu_stack_lo, X
    LDA tmp+1
    STA menu_stack_hi, X
    INC menu_stack_idx
    RTS


pop_menu:
    DEC menu_stack_idx
    LDX menu_stack_idx
    LDA menu_stack_lo, X
    STA tmp+0
    LDA menu_stack_hi, X
    STA tmp+1
    RTS


menu_init:
    mov menu_stack_idx, #$00
    STA menu_idx
    sta_ptr menu_curadr, menu_go_main
    JMP menu_go_main


menu_set_dialog:
    PHA
    STA menu_dialog_bnk
    STX menu_dialog_lo
    STY menu_dialog_hi
    PLA
    RTS


menu_update_dialog:
    LDA menu_dialog_bnk
    LDX menu_dialog_lo
    LDY menu_dialog_hi
    JMP read_dialog


; adr
menu_setup_monster:
    ; menu_size = n_monster
    mvx menu_size, n_monster
    ; for n_monster
    DEX
    @loop:
        ; menu_list_lo[X] = call_adr (lo)
        LDA tmp+0
        STA menu_list_lo, X
        ; menu_list_hi[X] = call_adr (hi)
        LDA tmp+1
        STA menu_list_hi, X
        ; menu_list_pos_x[X] = menu_data_pos_x[0]
        LDA menu_data_pos_x
        STA menu_list_pos_x, X
        ; menu_list_pos_y[X] = menu_data_pos_y_ver[X]
        LDA menu_data_pos_y_ver, X
        STA menu_list_pos_y, X
        ; Y = X << 4
        TXA
        shift ASL, 4
        TAY
        ; menu_list_str[0:2] = FONT + "* "
        LDA #FONT_CHR_BNK
        STA menu_list_str, Y
        INY
        LDA #'*'
        STA menu_list_str, Y
        INY
        LDA #' '
        STA menu_list_str, Y
        INY
        ; push x
        phx
        ; menu_list_str[3:10] = monster name
        LDX #$00
        @str:
            LDA monster_names, X
            STA menu_list_str, Y
            ;
            INY
            INX
            CPX #$08
            BNE @str
        ; menu_list_str[11:15]
        @space:
            LDA #$00
            STA menu_list_str, Y
            INY
            TYA
            AND #$0F
            BNE @space
        ; pull x
        plx
    to_x_dec @loop, #-1
    JMP draw_menu


menu_down:
    ; menu_idx + 1
    LDX menu_idx
    INX
    ; if menu_idx + 1 >= menu_size
    CPX menu_size
    blt :+
        ; menu_idx = 0
        LDX #$00
    ; else
    :
        ; menu_idx++
    STX menu_idx
    ; return
    RTS


menu_up:
    ; if menu_idx == 0
    LDX menu_idx
    BNE :+
        ; menu_idx = menu_size - 1
        LDX menu_size
    ; else
    :
        ; menu_idx--
    DEX
    STX menu_idx
    ; return
    RTS


menu_go:
    ;
    JSR text_post_process
    ; push_menu(menu_curadr)
    mov_ptr tmp, menu_curadr
    JSR push_menu
    ; adr, menu_curadr = menu[idx]
    LDY menu_idx
    LDA menu_list_lo, Y
    STA tmp+0
    STA menu_curadr+0
    LDA menu_list_hi, Y
    STA tmp+1
    STA menu_curadr+1
    ; arg
    LDX menu_idx
    ; idx = 0
    mov menu_idx, #$00
    ; jump adr(arg)
    JMP (tmp)


menu_ret:
    ; if menu_stack_idx == 0
    LDA menu_stack_idx
    BNE :+
        ; return
        RTS
    :

    ; adr = pop_menu()
    JSR pop_menu
    ; menu_curadr = adr
    mov_ptr menu_curadr, tmp
    ; idx = 0
    mov menu_idx, #$00
    ; jump adr
    JMP (tmp)


; tmp = data
menu_setup:
    ; menu_size = data[0]
    LDY #$00
    LDA (tmp), Y
    STA menu_size
    ; X = menu_size - 1
    TAX
    DEX
    ; Y = menu_size*2
    ASL
    TAY

    ; for X to 0
    @loop:
        ; menu[i] = args.data[i] (hi)
        LDA (tmp), Y
        DEY
        STA menu_list_hi, X
        ; menu[i] = args.data[i] (lo)
        LDA (tmp), Y
        DEY
        STA menu_list_lo, X
    to_x_dec @loop, #-1

    RTS


