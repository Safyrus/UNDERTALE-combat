;--------------------------------
; Subroutine: read_next_char
;--------------------------------
;
; Read the next character in text data.
;
; Return:
; A - char read
;
; /!\ Change Y to 0 /!\
;--------------------------------
read_next_char:
    LDY #$00
    LDA (next_char_ptr), Y
    inc_16 next_char_ptr
    RTS


;--------------------------------
; Subroutine: read_dialog
;--------------------------------
;
; Init <next_char_ptr> and call <text_pre_process>.
; LZ decode text if needed (with <lz_init> and <lz_decode>).
;
; Parameters:
; A - bank position of the uncompressed text
; X - address (low) of the uncompressed text
; Y - address (high) of the uncompressed text
;--------------------------------
read_dialog:
    PHA
    ; if A != lz_idx
    CMP lz_idx
    BEQ :+
        ; lz_idx = A
        STA lz_idx
        ; lz_init()
        JSR lz_init
        ; lz_decode()
        JSR lz_decode
    :
    ; next_char_ptr = X + (Y << 8) + $6000
    STX next_char_ptr+0
    TYA
    ORA #$60
    STA next_char_ptr+1
    PLA
    ; text_pre_process()
    JMP text_pre_process


;--------------------------------
; Subroutine: all_dialog_spd_to_zero
;--------------------------------
;
; Set speed of all dialog boxes to 0
;
; /!\ Does not save registers /!\
;--------------------------------
all_dialog_spd_to_zero:
    LDX #DialogBox::spd
    @loop:
        ; dialog_boxs[X].spd = 0
        LDA #$00
        STA dialog_boxs, X
        ; X += 8
        TXA
        add #$08
        TAX
        ; break if X == MAX_DIALOGBOX*8
        CPX #MAX_DIALOGBOX*8
        bge @loop
    RTS



; X = dialog box offset
clear_text_dialog_box:
    pushregs
    ; y = ystart
    LDA dialog_boxs + DialogBox::ystart, X
    TAY
    ; h = ypos - ystart + 1
    LDA dialog_boxs + DialogBox::ypos, X
    sub dialog_boxs + DialogBox::ystart, X
    STA tmp+3
    INC tmp+3
    ; w = xstart
    LDA dialog_boxs + DialogBox::xstart, X
    STA tmp+2
    ; x = xstart
    ; w = xoff - w
    LDA dialog_boxs + DialogBox::xoff, X
    LDX tmp+2
    sub tmp+2
    STA tmp+2
    ; clear_inside_box(params)
    JSR clear_inside_box
    ; return
    pullregs
    RTS
