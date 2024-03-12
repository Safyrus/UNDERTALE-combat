;--------------------------------
; Subroutine: draw_update_menu
;--------------------------------
;
; Update the highlight on the main menu.
;
; /!\ this subroutine wait to be in-frame /!\
;
;--------------------------------
draw_update_menu:
    pushregs

    ; wait to be in frame to be able to edit MMC5 expansion RAM
    @wait_inframe:
        BIT scanline
        BVC @wait_inframe

    ; for each menu action
    LDX #$00
    @loop_all:
        ; if the player have a soul menu
        LDA player_soul
        CMP #SOUL::MENU
        BNE :+
        ; and we are in the main menu (menu_stack_idx == 0)
        LDA menu_stack_idx
        BNE :+
        ; and player_x == menu_data_main_pos_x[X >> 3]
        TXA
        shift LSR, 3
        TAY
        LDA menu_data_main_pos_x, Y
        CMP player_x
        BNE :+
            ; upper tile = UI_CHR_BNK + 1 + yellow palette
            LDY #UI_CHR_BNK + 1 + $80
            BNE :++ ; JMP
        ; else
        :
            ; upper tile = UI_CHR_BNK + brown palette
            LDY #UI_CHR_BNK + $C0
        :
        ; set tiles
        @loop_one:
            TYA
            ; 1st line
            STA MMC5_EXP_RAM+$340, X
            ; 2nd line
            STA MMC5_EXP_RAM+$360, X
            ; 3th line
            STA MMC5_EXP_RAM+$380, X
            ; 4th line
            STA MMC5_EXP_RAM+$3A0, X
            ; for x to x+8
            INX
            TXA
            AND #%00000111
            BNE @loop_one
        ; loop
        CPX #$20
        BNE @loop_all

    pullregs
    RTS

;
clear_inside_box:
    @packet = tmp

    ; change RAM bank
    ; LDA #VAR_RAM_BNK
    ; STA mmc5_banks+0
    ; STA MMC5_RAM_BNK
    ; @packet = packet_buffer_end
    mov_ptr @packet, packet_buffer_end

    ;
    for_x @line, #0
        ; size
        LDY #$00
        LDA #28+$40
        STA (@packet), Y
        INY
        ; pos hi
        LDA #$22
        STA (@packet), Y
        INY
        ; pos lo
        LDA #$20
        STA MMC5_MUL_A
        STX MMC5_MUL_B
        LDA MMC5_MUL_A
        add #$22
        STA (@packet), Y
        ;
        INY
        TYA
        add_A2ptr @packet

        ; lower tiles
        LDA #$00
        for_y @lo, #0
            STA (@packet), Y
        to_y_inc @lo, #28
        ;
        TYA
        add_A2ptr @packet

        ; upper tiles
        LDA #UI_CHR_BNK
        for_y @hi, #0
            STA (@packet), Y
        to_y_inc @hi, #28
        ;
        TYA
        add_A2ptr @packet
    to_x_inc @line, #6

    ; packet_buffer_end = @packet
    mov_ptr packet_buffer_end, @packet

    ; return
    RTS
