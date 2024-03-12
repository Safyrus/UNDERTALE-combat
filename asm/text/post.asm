;--------------------------------
; Subroutine: text_post_process
;--------------------------------
;
; Clear every dialog boxes.
; Call when every dialog boxes have finished displaying text.
;
;--------------------------------
text_post_process:
    PHA
    ; delete every dialog box
    mov n_dialog, #$00
    ; return
    PLA
    RTS
