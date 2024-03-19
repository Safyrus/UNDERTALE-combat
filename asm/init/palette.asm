;################
; File: palette
;################
; subrountines related to changing palettes

;--------------------------------
; Subroutine: init_pal
;--------------------------------
;
; initialize background and sprite palettes to default values.
;
;--------------------------------
init_pal:
    push_ax

    ; set palettes by copying data_pal_bkg
    for_x @loop_bkg, #0
        LDA @data_pal_bkg, X
        STA palettes, X
    to_x_inc @loop_bkg, #25

    pull_ax
    RTS

@data_pal_bkg:
    .byte $0F ; backdrop color
    ; background
    .byte $30, $0F, $30 ; first white palette
    .byte $0F, $30, $30 ; second white palette
    .byte $16, $28, $30 ; UI + text palette
    .byte $17, $00, $00 ; orange
    ; sprite
    .byte $30, $00, $16 ; sprite palette 0
    .byte $16, $00, $0F ; sprite palette 1
    .byte $00, $00, $00 ; sprite palette 2
    .byte $00, $00, $00 ; sprite palette 3
