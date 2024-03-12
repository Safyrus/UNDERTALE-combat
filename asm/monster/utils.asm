
; Y = id
monster_fightid_to_pos:
    LDX n_monster
    ; ; 0 monster
    ; BNE :+
    ;     ; X, Y = 0
    ;     TAX
    ;     TAY
    ;     RTS
    ; :
    ; 1 monster
    DEX
    BNE :+
        ; X, Y = (128,32)
        LDX #128
        LDY #32
        RTS
    :
    ; 2 monster
    DEX
    BNE :+
        ; X, Y = (m2_x[Y],32)
        LDX @m2_x, Y
        LDY #32
        RTS
    :
    ; 3 monster
    ; X, Y = (m3_x[Y],32)
    LDX @m2_x, Y
    LDY #32
    RTS

    @m2_x: .byte 64, 192
    @m3_x: .byte 128, 64, 192
