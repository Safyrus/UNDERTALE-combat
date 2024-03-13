.macro load_dialog_arg val
    LDA #(val >> 16)
    LDY #(val >> 8)
    LDX #<(val >> 0)
.endmacro

.macro call_read_dialog val
    load_dialog_arg val
    JSR read_dialog
.endmacro

.macro set_menu_dialog val
    load_dialog_arg val
    JSR menu_set_dialog
.endmacro

.macro const_to_xy val
    LDX #<val
    LDY #>val
.endmacro


.macro display_anim idx
    LDA #<idx
    STA tmp+0
    LDA #>idx
    STA tmp+1
    JSR add_anim
.endmacro

