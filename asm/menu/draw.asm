draw_menu:
    JSR clear_main_box
    ;
    LDX menu_size
    DEX
    @loop:
        JSR draw_menu_str
    to_x_dec @loop, #-1
    RTS


; X = menu index
draw_menu_str:
    push_ax

    @packet = tmp
    @size = tmp+2

    ; get string position
    LDA menu_list_pos_y, X
    TAY
    phx
    LDA menu_list_pos_x, X
    add #$10
    TAX
    ; find ppu adr
    JSR xy_2_ppu
    ; Y = X << 4
    PLA
    shift ASL, 4
    TAY
    ; push ppu adr
    push tmp+0
    push tmp+1
    ;
    phy

    ;
    sta_ptr tmp, menu_list_str
    INY
    JSR str_len_y
    CPX #$10
    blt :+
        LDX #$0F
    :
    STX @size
    ;
    plx
    ; @packet = packet_buffer_end
    mov_ptr @packet, packet_buffer_end
    ; @packet += size
    LDY #$00
    LDA @size
    STA (@packet), Y
    INY
    ; @packet += pull ppu hi
    PLA
    STA (@packet), Y
    INY
    ; @packet += pull ppu lo
    PLA
    STA (@packet), Y
    INY

    ;
    LDA menu_list_str, X
    PHA
    INX

    ; low tiles
    @str_lo:
        LDA menu_list_str, X
        BEQ @str_lo_end
        INX
        STA (@packet), Y
        INY
        BNE @str_lo
    @str_lo_end:

    ; high tiles
    LDX @size
    PLA
    @str_hi:
        STA (@packet), Y
        INY
    to_x_dec @str_hi, #0

    ; @packet += Y
    TYA
    add_A2ptr @packet
    ; packet_buffer_end = @packet
    mov_ptr packet_buffer_end, @packet

    ; return
    pull_ax
    RTS
