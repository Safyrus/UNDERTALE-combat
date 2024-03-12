
; this file was generated

.segment "MONSTER_DATA"

;--------------------------------
; Array: monster_names_data
;--------------------------------
;
; List of 256 monster names (each 8 bytes long).
; The index in the array is the ID of the monster.
;--------------------------------
monster_names_data:
    .byte "TESTOBUG"

    ; unused data
    .repeat 255
        .byte "        "
    .endrepeat
