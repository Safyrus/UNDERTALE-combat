item_code:
    ; useless item
    item_0:
        .byte item_1 - item_0 - 1
        JMP end_item

    ; testing
    item_1:
        .byte item_2 - item_1 - 1
        LDA item_var
        BNE :+
            INC item_var
            load_dialog_arg TXT_ITEM_1
            JMP read_dialog
        :
        LDA n_dialog
        BEQ :+
            RTS
        :
        JMP end_item

    item_2:
    .repeat 254
        .byte $03
        JMP end_item
    .endrepeat
