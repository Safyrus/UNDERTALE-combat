;################
; File: Joypad
;################
; subrountines related to player inputs

;--------------------------------
; Subroutine: readjoy
;--------------------------------
;
; Subroutine from <NesDev:https://www.nesdev.org/wiki/Controller_reading_code>
;
; Read the player input from joypad 1
;
; Return:
;   btn_1 - Joypad 1 inputs (ABTSUDLR)
;--------------------------------
readjoy:
    lda #$01
    ; While the strobe bit is set, buttons will be continuously reloaded.
    ; This means that reading from IO_JOY1 will only return the state of the
    ; first button: button A.
    sta IO_JOY1
    sta btn_1
    lsr a        ; now A is 0
    ; By storing 0 into IO_JOY1, the strobe bit is cleared and the reloading stops.
    ; This allows all 8 buttons (newly reloaded) to be read from IO_JOY1.
    sta IO_JOY1
    @loop:
        lda IO_JOY1
        lsr a	       ; bit 0 -> Carry
        rol btn_1  ; Carry -> bit 0; bit 7 -> Carry
        bcc @loop
    rts


;--------------------------------
; Subroutine: readjoy_safe
;--------------------------------
;
; Subroutine from <NesDev:https://www.nesdev.org/wiki/Controller_reading_code>
;
; Same as <readjoy> but is safe from DPCM conflict.
;
; Return:
;   btn_1 - Joypad 1 inputs (ABTSUDLR)
;--------------------------------
readjoy_safe:
    jsr readjoy
@reread:
    lda btn_1
    pha
    jsr readjoy
    pla
    cmp btn_1
    bne @reread
    rts


;--------------------------------
; Subroutine: update_input
;--------------------------------
;
; Update the player input
; if the input timer has reached 0
;
; Return:
;   btn_1 - Joypad 1 inputs (ABTSUDLR)
;--------------------------------
update_input:
    ; if btn_1_timer > 0
    LDA btn_1_timer
    bze @timer_reset
    ; then
        ; btn_1_timer--
        DEC btn_1_timer
        ; input = 0
        mov btn_1, #$00
        ; end
        JMP @end
    ; else
    @timer_reset:
        ; read input
        JSR readjoy_safe
        ; if input != 0
        LDA btn_1
        bze @end
            ; btn_1_timer = btn_timer_var
            mov btn_1_timer, btn_timer_var
    @end:
    RTS
