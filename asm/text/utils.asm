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
