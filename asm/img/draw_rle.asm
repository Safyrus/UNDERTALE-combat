draw_rle_header:
    @packet = tmp+0
    @img = tmp+2
    @w = tmp+12
    @h = tmp+13
    @ppu_adr = tmp+6
    @img_up = tmp+8
    @y = tmp+10
    @count = tmp+11

    ;
    STY @y

    ; change RAM bank
    ; LDA #VAR_RAM_BNK
    ; STA mmc5_banks+0
    ; STA MMC5_RAM_BNK
    ; @img, @img_up = img_buf
    LDA #<img_buf
    STA @img+0
    STA @img_up+0
    LDA #>img_buf
    STA @img+1
    STA @img_up+1

    ; @count = 0
    LDA #$00
    STA @count
    ; width
    TAY
    LDA (tmp), Y
    AND #$0F
    STA @w
    STA MMC5_MUL_A
    ; height
    LDA (tmp), Y
    shift LSR, 4
    STA @h
    ; @img_up += w * h
    STA MMC5_MUL_B
    LDA MMC5_MUL_A
    add_A2ptr @img_up
    ;
    inc_16 tmp
    RTS
