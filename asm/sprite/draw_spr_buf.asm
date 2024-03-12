.macro draw_spr_buf_one
    ; if sprite.anim_idx != 0
    LDA spr_buf_anim, X
    BEQ :+
    ; and sprite.y < 240
    LDA spr_buf_y, X
    CMP #240
    bge :+
        ; if OAM full
        LDA oam_size
        CMP #64
            ; return
            bge @end
        ; Y = oam_size << 2
        ASL
        ASL
        TAY
        ; add sprite to OAM
        LDA spr_buf_y, X
        STA OAM+0, Y
        LDA spr_buf_idx, X
        STA OAM+1, Y
        LDA spr_buf_atr, X
        STA OAM+2, Y
        LDA spr_buf_x, X
        STA OAM+3, Y
        ; oam_size++
        INC oam_size
    :
.endmacro


draw_spr_buf:
    ; tmp = frame_counter & $01
    LDA frame_counter
    AND #$01
    STA tmp
    ; if odd frame
    LSR
    BCS :+
        ; X = MAX_SPR-1
        LDX #MAX_SPR-1
        JMP @loop
    ; else
    :
        ; X = 0
        TAX

    ; for each sprite
    @loop:
        draw_spr_buf_one

        ; if odd frame
        LDA tmp
        BNE @inc
        @dec:
            ; then decrease index
            DEX
            BPL @loop
            BMI @end ; JMP
        @inc:
            ; else increase index
            INX
            CPX #MAX_SPR
            BNE @loop

    @end:
    RTS
