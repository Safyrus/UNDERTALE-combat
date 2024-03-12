; A = anim_idx
; X,Y = pos
; tmp = rleimg
draw_spr_rleimg:
    @arg = tmp+0
    @count_x = tmp+1
    @img = tmp+2
    @w = tmp+12
    @h = tmp+13
    @x = tmp+6
    @y = tmp+10
    @count_y = tmp+11

    ; push anim_idx
    PHA

    JSR draw_rle_header
    ; @x = X
    STX @x
    ; MMC5_CHR_BNKX = data.sprite_bank
    JSR get_monster_chr_bnk_offset
    LDA (tmp), Y
    STA MMC5_CHR_BNK0, X
    ;
    inc_16 tmp

    ; img_buf = rleinc(rleimg)
    JSR rleinc

    ; arg = anim_idx
    pull @arg

    ; for line in img
    LDY #$00
    @for_height:
        ;
        mov @count_x, #$00
        ; for tile in line
        @for_width:
            ; push Y
            phy

            ; tile
            LDA img_buf, Y
            PHA
            ; X = @x + count_x * 8
            LDA @count_x
            shift ASL, 3
            add @x
            TAX
            ; Y = @y + count_y * 16
            LDA @count_y
            shift ASL, 4
            add @y
            TAY
            ; create_sprite(X, Y, tile, anim_idx)
            PLA
            JSR add_entity_spr

            ; pull Y
            ply
            INY
            ; loop x
            INC @count_x
            LDA @count_x
            CMP @w
            BNE @for_width
        ; loop y
        INC @count_y
        LDA @count_y
        CMP @h
        BNE @for_height

    ; return
    RTS
