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
clear_main_box:
    pushregs
    ; params
    LDX #2
    LDY #17
    mov tmp+2, #28
    mov tmp+3, #6
    ; clear_inside_box(params)
    JSR clear_inside_box
    ; return
    pullregs
    RTS


; X = x pos (tile)
; Y = y pos (tile)
; tmp+2 = width (tile)
; tmp+3 = height (tile)
clear_inside_box:
    @ppu = tmp+0
    @w = tmp+2
    @h = tmp+3
    @packet = tmp+4

    ; change RAM bank
    ; LDA #VAR_RAM_BNK
    ; STA mmc5_banks+0
    ; STA MMC5_RAM_BNK
    ; @packet = packet_buffer_end
    mov_ptr @packet, packet_buffer_end

    ;
    JSR xytile_2_ppu

    ;
    for_x @line, @h
        ; size
        LDY #$00
        LDA @w
        ORA #$40 ; high priority
        STA (@packet), Y
        INY
        ; pos hi
        LDA @ppu+1
        STA (@packet), Y
        INY
        ; pos lo
        LDA @ppu+0
        STA (@packet), Y
        INY
        ; packet += 3
        TYA
        add_A2ptr @packet
        ; ppu += $20 (one line)
        add_A2ptr @ppu, #$20

        ; lower tiles
        LDA #$00
        for_y @lo, #0
            STA (@packet), Y
        to_y_inc @lo, @w
        ; packet += w
        TYA
        add_A2ptr @packet

        ; upper tiles
        LDA #UI_CHR_BNK
        for_y @hi, #0
            STA (@packet), Y
        to_y_inc @hi, @w
        ; packet += w
        TYA
        add_A2ptr @packet
        ; continue
    to_x_dec @line, #0

    ; packet_buffer_end = @packet
    mov_ptr packet_buffer_end, @packet

    ; return
    RTS
