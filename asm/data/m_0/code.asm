.include "event/start.asm"
.include "event/turn.asm"
.include "event/custom.asm"
.include "event/hit.asm"
.include "event/act.asm"
.include "event/item.asm"
.include "event/spare.asm"


; code to test python script
; ---------------------------
; JMP start
; lol: JMP start ; some comments
; JMP start; some comments
; .byte "start this word : start \" start \" efzefjnz \"start\" should not be replaced start", start,start,start
; .byte "",","

m_0_clear_event:
    LDA #$00
    LDX cur_monster_fight_pos
    STA monster_events ,  X
    RTS


get_var_idx:
    ; X = cur_monster_fight_pos << 3
    LDA cur_monster_fight_pos
    shift ASL ,  3
    TAX
    RTS




data_act:
.byte $03
.byte FONT_CHR_BNK ,  "* Check" ,  $00 ,  "       "
.byte FONT_CHR_BNK ,  "* Debug" ,  $00 ,  "       "
.byte FONT_CHR_BNK ,  "* Test" ,  $00 ,  "        "
data_act_end:
