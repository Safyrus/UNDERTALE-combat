.segment "ITEM_BNK"

item_names:
    .byte $80, "!IMPOSSIBLE!", $00, $00, $00
    .byte $80, "* USELESS", $00, $00, $00, $00, $00, $00
    .repeat 253
        .byte $80, "* NONAME", $00, $00, $00, $00, $00, $00, $00
    .endrepeat
