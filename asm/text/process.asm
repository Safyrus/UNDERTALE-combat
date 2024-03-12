;--------------------------------
; Subroutine: print
;--------------------------------
;
; Print a character on the screen.
;
; Parameters:
; A - Char
; X - index in <dialog_boxs>
; Y - <background_index>
;
; /!\ Change A and Y /!\
;
; /!\ Change tmp+2 and tmp+1 /!\
;
;--------------------------------
print:
    ; push char
    PHA
    ; compute ppu adr (hi)
    LDA dialog_boxs + DialogBox::ypos, X
    shift LSR, 3
    ORA #$20
    STA tmp+2
    ; compute ppu adr (lo)
    LDA dialog_boxs + DialogBox::ypos, X
    shift ASL, 5
    add dialog_boxs + DialogBox::xpos, X
    STA tmp+1

    ; open ppu packet of size 1
    LDA #$01
    STA background, Y
    INY
    ; put adr
    LDA tmp+2
    STA background, Y
    INY
    LDA tmp+1
    STA background, Y
    INY
    ; put data
    PLA
    STA background, Y
    INY
    ; close ppu packet
    LDA #$00
    STA background, Y
    STY background_index

    ; change ppu adr to mmc5 adr
    LDA tmp+2
    AND #$03
    ORA #>MMC5_EXP_RAM
    STA tmp+2
    LDY #$00
    ; wait to be in frame
    @wait_inframe:
        BIT scanline
        BVC @wait_inframe
    ; set mmc5 tiles
    LDA dialog_boxs + DialogBox::font, X
    STA (tmp+1), Y

    ; return
    RTS

;--------------------------------
; Subroutine: text_process
;--------------------------------
;
; Process and print the text in each dialog box.
;
;--------------------------------
text_process:
    @all_print_end = tmp
    pushregs

    ; all_print_end = true
    mov @all_print_end, #$FF

    ; for each dialog box
    LDX n_dialog
    DEX
    TXA
    shift ASL, DIALOGBOX_SIZE ; (n_dialog-1) * DIALOGBOX_SIZE
    TAX
    @loop:
        ; if DialogBox.wait > 0
        LDA dialog_boxs + DialogBox::wait, X
        BEQ :+
            ; DialogBox.wait--
            DEC dialog_boxs + DialogBox::wait, X
            ; all_print_end = false
            mov @all_print_end, #$00
            ; continue
            JMP @next
        :

        ; if DialogBox.flags.input (waiting for input)
        LDA dialog_boxs + DialogBox::flags, X
        AND #DIALOGBOX_FLAG_INPUT
        BEQ :++
            ; if input has occured
            LDA btn_1
            AND #BTN_A
            ; else continue
            BEQ :+
                ; clear DialogBox.flags.input
                LDA dialog_boxs + DialogBox::flags, X
                AND #$FF - DIALOGBOX_FLAG_INPUT
                STA dialog_boxs + DialogBox::flags, X
                ; clear dialog box
                ; TODO
                JMP :++
            :
            ; all_print_end = false
            mov @all_print_end, #$00
            ; continue
            JMP @next
        :

        ; c = read_char()
        LDY dialog_boxs + DialogBox::ptr, X
        LDA str_buf, Y
        ; if c is printable
        CMP #$20
        blt @control
        @printable:
            ; all_print_end = false
            mvy @all_print_end, #$00
            ; if not enought space remaining in print buffer
            LDY background_index
            CPY #$60-5
            ; continue
                bge @next
            ; print(c)
            JSR print
            ; DialogBox.xpos++
            INC dialog_boxs + DialogBox::xpos, X
            ; if DialogBox.xpos >= DialogBox.xoff
            LDA dialog_boxs + DialogBox::xpos, X
            CMP dialog_boxs + DialogBox::xoff, X
            bge :+
                ; DialogBox.xoff = DialogBox.xpos
                STA dialog_boxs + DialogBox::xoff, X
            :
            ; TODO: check if x go out of screen
            ; DialogBox.wait = DialogBox.spd
            LDA dialog_boxs + DialogBox::spd, X
            STA dialog_boxs + DialogBox::wait, X
            ;
            JMP @ret
        ; else
        @control:
            ; if c != CHAR::FDB
            CMP #CHAR::FDB
            BEQ :+
                ; all_print_end = false
                mvy @all_print_end, #$00
                JMP :++
            :
            ; else
                ; continue
                JMP @next
            :
            ; do the thing the char say
            TAY
            LDA #>(@ret-1)
            PHA
            LDA #<(@ret-1)
            PHA
            LDA @ctrl_jmp_table_hi, Y
            PHA
            LDA @ctrl_jmp_table_lo, Y
            PHA
            RTS
        @ret:

        ; DialogBox.ptr++
        INC dialog_boxs + DialogBox::ptr, X
        ; if DialogBox.wait == 0
        LDA dialog_boxs + DialogBox::wait, X
        BNE :+
            ; redo
            JMP @loop
        :

        ; next
        @next:
        TXA
        sub #.sizeof(DialogBox)
        TAX
        BMI :+
            JMP @loop
        :

    ; if all_print_end
    ; a.k.a (no more text can be read from any dialog box)
    BIT @all_print_end
    BPL :+
        ; text_post_process()
        JSR text_post_process
    :

    ; return
    pullregs
    RTS

    @ctrl_jmp_table_lo:
    .byte <(char_END-1)
    .byte <(char_LB-1)
    .byte <(char_DB-1)
    .byte <(char_FDB-1)
    .byte <(char_TD-1)
    .byte <(char_SET-1)
    .byte <(char_CLR-1)
    .byte <(char_SAK-1)
    .byte <(char_SPD-1)
    .byte <(char_DL-1)
    .byte <(char_NAM-1)
    .byte <(char_FLH-1)
    .byte <(char_FAD-1)
    .byte <(char_SAV-1)
    .byte <(char_COL-1)
    .byte <(char_RET-1)
    .byte <(char_BIP-1)
    .byte <(char_MUS-1)
    .byte <(char_SND-1)
    .byte <(char_PHT-1)
    .byte <(char_CHR-1)
    .byte <(char_ANI-1)
    .byte <(char_BKG-1)
    .byte <(char_FNT-1)
    .byte <(char_JMP-1)
    .byte <(char_ACT-1)
    .byte <(char_BP-1)
    .byte <(char_SP-1)
    .byte <(char_POS-1)
    .byte <(char_SPA-1)
    .byte <(char_EVT-1)
    .byte <(char_EXT-1)

    @ctrl_jmp_table_hi:
    .byte >(char_END-1)
    .byte >(char_LB-1)
    .byte >(char_DB-1)
    .byte >(char_FDB-1)
    .byte >(char_TD-1)
    .byte >(char_SET-1)
    .byte >(char_CLR-1)
    .byte >(char_SAK-1)
    .byte >(char_SPD-1)
    .byte >(char_DL-1)
    .byte >(char_NAM-1)
    .byte >(char_FLH-1)
    .byte >(char_FAD-1)
    .byte >(char_SAV-1)
    .byte >(char_COL-1)
    .byte >(char_RET-1)
    .byte >(char_BIP-1)
    .byte >(char_MUS-1)
    .byte >(char_SND-1)
    .byte >(char_PHT-1)
    .byte >(char_CHR-1)
    .byte >(char_ANI-1)
    .byte >(char_BKG-1)
    .byte >(char_FNT-1)
    .byte >(char_JMP-1)
    .byte >(char_ACT-1)
    .byte >(char_BP-1)
    .byte >(char_SP-1)
    .byte >(char_POS-1)
    .byte >(char_SPA-1)
    .byte >(char_EVT-1)
    .byte >(char_EXT-1)


char_DB:
    ; set dialog_boxs[X].flags.input
    LDA dialog_boxs + DialogBox::flags, X
    ORA #DIALOGBOX_FLAG_INPUT
    STA dialog_boxs + DialogBox::flags, X
    ; return
    RTS
char_FDB:
    ; clear dialog box
    ; TODO
    RTS
char_LB:
    ; xpos = xstart
    LDA dialog_boxs + DialogBox::xstart, X
    STA dialog_boxs + DialogBox::xpos, X
    ; ypos += spa
    LDA dialog_boxs + DialogBox::spa, X
    add dialog_boxs + DialogBox::ypos, X
    STA dialog_boxs + DialogBox::ypos, X
    ; return
    RTS
char_FNT:
    ; dialog_boxs[X].ptr ++
    INC dialog_boxs + DialogBox::ptr, X
    ; Y = dialog_boxs[X].ptr
    LDY dialog_boxs + DialogBox::ptr, X
    ; dialog_boxs[X].font = str_buf[Y]
    LDA str_buf, Y
    STA dialog_boxs + DialogBox::font, X
    ; return
    RTS
char_SPD:
    ; dialog_boxs[X].ptr ++
    INC dialog_boxs + DialogBox::ptr, X
    ; Y = dialog_boxs[X].ptr
    LDY dialog_boxs + DialogBox::ptr, X
    ; if dialog_boxs[X].spd > 0
    LDA dialog_boxs + DialogBox::spd, X
    BEQ :+
        ; dialog_boxs[X].spd = str_buf[Y]
        LDA str_buf, Y
        STA dialog_boxs + DialogBox::spd, X
    :
    ; return
    RTS
char_DL:
    ; dialog_boxs[X].ptr ++
    INC dialog_boxs + DialogBox::ptr, X
    ; Y = dialog_boxs[X].ptr
    LDY dialog_boxs + DialogBox::ptr, X
    ; dialog_boxs[X].wait = str_buf[Y]
    LDA str_buf, Y
    STA dialog_boxs + DialogBox::wait, X
    ; return
    RTS
char_MUS:
    INC dialog_boxs + DialogBox::ptr, X
    ; TODO
    RTS
char_SND:
    INC dialog_boxs + DialogBox::ptr, X
    ; TODO
    RTS
char_BIP:
    INC dialog_boxs + DialogBox::ptr, X
    ; TODO
    RTS
char_JMP:
    ; TODO
    BRK
char_SPA:
    ; dialog_boxs[X].ptr ++
    INC dialog_boxs + DialogBox::ptr, X
    ; Y = dialog_boxs[X].ptr
    LDY dialog_boxs + DialogBox::ptr, X
    ; dialog_boxs[X].spa = str_buf[Y]
    LDA str_buf, Y
    STA dialog_boxs + DialogBox::spa, X
    ; return
    RTS

char_END:
    ; if you break here, that means that
    ; there is a problem somewhere
    ; in the code related to reading dialog
    BRK

char_TD:
char_SET:
char_CLR:
char_SAK:
char_NAM:
char_FLH:
char_FAD:
char_SAV:
char_COL:
char_RET:
char_PHT:
char_CHR:
char_ANI:
char_BKG:
char_ACT:
char_BP:
char_SP:
char_POS:
char_EVT:
char_EXT:
    RTS
