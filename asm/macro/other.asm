.macro load_dialog_arg val
    LDA #(val >> 14)
    LDY #(val >> 7)
    LDX #(val >> 0)
.endmacro
