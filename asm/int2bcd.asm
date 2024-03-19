int16_2_bcd:
    @val = tmp+0
    @bcd = tmp+2

    ; bcd = 0
    LDA #$00
    STA @bcd+0
    STA @bcd+1
    STA @bcd+2

    ; for each bit
    for_x @loop, #16
        ; add 3 to each nimble >= 5
        for_y @add3, #2
            ; lower nimble
            LDA @bcd, Y
            AND #$0F
            ; if nimble >= 5
            CMP #$05
            blt :+
                ; nimble += 3
                LDA #$03
                add @bcd, Y
                STA @bcd, Y
            :
            ; lower nimble
            LDA @bcd, Y
            AND #$F0
            ; if nimble >= 5
            CMP #$50
            blt :+
                ; nimble += 3
                LDA #$30
                add @bcd, Y
                STA @bcd, Y
            :
        to_y_dec @add3, #-1

        ; bcd, val << 1
        ; val
        ASL @val+0
        ROL @val+1
        ; bcd
        ROL @bcd+0
        ROL @bcd+1
        ROL @bcd+2
    to_x_dec @loop, #0

    ; return
    RTS
