;--------------------------------
; Subroutine: new_dialog_box
;--------------------------------
;
; Create a new <DialogBox> and add it to <dialog_boxs>.
;
; Parameters:
; A - Index in <str_buf>
; X - x position
; Y - y position
;
; /!\ Change A and X /!\
;
;--------------------------------
new_dialog_box:
    ; push param A,X
    PHA
    TXA
    PHA
    ; x = n_dialog * sizeof(DialogBox)
    LDA n_dialog
    shift ASL, DIALOGBOX_SIZE
    TAX
    ; xpos
    PLA
    STA dialog_boxs + DialogBox::xpos, X
    ; xstart
    STA dialog_boxs + DialogBox::xstart, X
    ; ypos
    TYA
    STA dialog_boxs + DialogBox::ypos, X
    ; ystart
    STA dialog_boxs + DialogBox::ystart, X
    ; ptr
    PLA
    STA dialog_boxs + DialogBox::ptr, X
    ; font
    LDA #DEFAULT_FONT
    STA dialog_boxs + DialogBox::font, X
    ; wait
    LDA #DEFAULT_WAIT
    STA dialog_boxs + DialogBox::wait, X
    ; spd
    LDA #DEFAULT_SPD
    STA dialog_boxs + DialogBox::spd, X
    ; bip
    LDA #DEFAULT_BIP
    STA dialog_boxs + DialogBox::bip, X
    ; spa
    LDA #DEFAULT_SPACING
    STA dialog_boxs + DialogBox::spa, X
    ; n_dialog++
    INC n_dialog
    ; return
    RTS


;--------------------------------
; Subroutine: text_pre_process
;--------------------------------
;
; Create every dialog boxes.
; Called first when the game want to read and display text.
;
; /!\ change RAM bank to <TEXT_BUF_BNK> /!\
;
;--------------------------------
text_pre_process:
    pushregs

    ; change ram bank to text bank
    LDA mmc5_banks+0
    PHA
    mov MMC5_RAM_BNK, #TEXT_BUF_BNK
    STA mmc5_banks+0

    ; new_dialog_box(0,def_x,def_y)
    LDA #$00
    LDX #DEFAULT_X
    LDY #DEFAULT_Y
    JSR new_dialog_box
    ; i = 0
    LDX #$00
    ; while (true)
    @while:
        ; c = read_next_char()
        JSR read_next_char
        ; if c == CHAR::END
        CMP #CHAR::END
            ; break
            BEQ @end

        ; if c == CHAR::POS
        CMP #CHAR::POS
        BNE :+
            STX tmp
            ; x = read_next_char() * 2
            JSR read_next_char
            ASL
            TAX
            ; y = read_next_char() * 2
            JSR read_next_char
            ASL
            TAY
            ; new_dialog_box(i,x,y)
            LDA tmp
            JSR new_dialog_box
            ;
            LDX tmp
            JMP @while
        ; else
        :
            ; buf[i] = c
            STA str_buf, X
            ; i++
            INX
            ;
            JMP @while
    @end:
    ; restore RAM bank
    PLA
    STA mmc5_banks+0
    STA MMC5_RAM_BNK
    ; return
    pullregs
    RTS
