
; X,Y = pos
; tmp = rleimg
draw_bkg_rleimg:
    @packet = tmp+0
    @img = tmp+2
    @w = tmp+12
    @h = tmp+13
    @ppu_adr = tmp+6
    @img_up = tmp+8
    @y = tmp+10
    @count = tmp+11

    JSR draw_rle_header

    ; img_buf = rleinc(rleimg)
    JSR rleinc
    sta_ptr @img, img_buf
    ; @packet = packet_buffer_end
    mov_ptr @packet, packet_buffer_end

    ; for line in img
    @for_height:
        ;
        TXA
        PHA
        LDA tmp+0
        PHA
        LDA tmp+1
        PHA
        ; @ppu_adr = xy_2_ppu(x,y)
        LDA @count
        shift ASL, 3
        add @y
        TAY
        JSR xy_2_ppu
        mov_ptr @ppu_adr, tmp
        ;
        PLA
        STA tmp+1
        PLA
        STA tmp+0
        PLA
        TAX
        ; packet_buffer += width
        LDY #$00
        LDA @w
        STA (@packet), Y
        inc_16 @packet
        ; packet_buffer += ppu_adr
        LDA @ppu_adr+1 ; ppu hi
        STA (@packet), Y
        inc_16 @packet
        LDA @ppu_adr+0 ; ppu lo
        STA (@packet), Y
        inc_16 @packet
        ; packet_buffer += ppu tiles
        LDY @w
        DEY
        @copy_lo:
            ; packet_buffer += tile
            LDA (@img), Y
            STA (@packet), Y
        to_y_dec @copy_lo, #-1
        ; Y = w ; @packet += w
        LDA @w
        TAY
        DEY
        add_A2ptr @packet
        ; packet_buffer += mmc5 tiles
        @copy_hi:
            ; packet_buffer += tile
            LDA (@img_up), Y
            STA (@packet), Y
        to_y_dec @copy_hi, #-1
        ;
        add_A2ptr @packet, @w
        ;
        add_A2ptr @img, @w
        add_A2ptr @img_up, @w
        ; loop
        INC @count
        LDA @count
        CMP @h
        BEQ @for_height_end
        JMP @for_height
    @for_height_end:
    ; packet_buffer_end = @packet
    mov_ptr packet_buffer_end, @packet
    ; return
    RTS
