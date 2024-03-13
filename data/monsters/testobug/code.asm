.include "event/start.asm"
.include "event/turn.asm"
.include "event/custom.asm"
.include "event/hit.asm"
.include "event/act.asm"
.include "event/item.asm"
.include "event/spare.asm"
.include "event/flee.asm"


data_testobug_act:
.byte $03
.byte FONT_CHR_BNK, "* Check", $00, "       "
.byte FONT_CHR_BNK, "* Debug", $00, "       "
.byte FONT_CHR_BNK, "* Test", $00, "        "
