;--------------------------------
; Subroutine: text_post_process
;--------------------------------
;
; Clear every dialog boxes.
; Call when every dialog boxes have finished displaying text.
;
;--------------------------------
text_post_process:
    push_ax

    ; if n_dialog == 0
    LDX n_dialog
        ; return
        BEQ @end

    ; TODO: remove this and find a better solution for not erasing wantedd dialog
    ; if n_dialog == 1
    DEX
        ; return
        BEQ @skip_loop

    ; for each dialog box
    TXA
    shift ASL, DIALOGBOX_SIZE ; (n_dialog-1) * DIALOGBOX_SIZE
    TAX
    @loop:
        ; clear_text_dialog_box(X)
        JSR clear_text_dialog_box
        ; next
        @next:
        TXA
        sub #.sizeof(DialogBox)
        TAX
        BMI :+
            JMP @loop
        :
    @skip_loop:

    ; delete every dialog box
    mov n_dialog, #$00

    ; return
    @end:
    pull_ax
    RTS
