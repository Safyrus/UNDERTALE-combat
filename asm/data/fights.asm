
; this file was generated

.segment "MONSTER_DATA"

;--------------------------------
; Array: fights
;--------------------------------
;
; List of 256 <Fight> structures.
; The index in the array is the ID of the fight.
;--------------------------------
fights:
    .byte $03, $00, $00, $00 ; fight 0
    .byte $01, $02, $00, $00 ; fight 1

    ; unused data
    .repeat 254
        .tag Fight
    .endrepeat
