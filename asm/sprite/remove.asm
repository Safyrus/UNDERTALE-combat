;################
; File: sprite
;################
; subrountines related to sprites

;--------------------------------
; Subroutine: remove_all_spr
;--------------------------------
;
; Remove all sprites on the screen.
;
;--------------------------------
remove_all_spr:

    ; X = oam_size * 4
    LDA oam_size
    ASL
    ASL
    TAX
    ; A = $FF
    LDA #$FF
    ; for each sprite
    @loop:
        ; set sprite y postion to $FF, unrendering the sprite
        STA OAM, X
        ; skip tile,atr,x of the sprite
        DEX
        DEX
        DEX
    to_x_dec @loop, #0

    mov oam_size, #$00

    ; return
    RTS
