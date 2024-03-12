
; this file was generated

.segment "MONSTER_STRUCT_DATA"

;--------------------------------
; Array: monster_stats_data
;--------------------------------
;
; List of 256 <MonsterStats> structures.
; The index in the array is the ID of the monster.
;--------------------------------
monster_stats_data:
    .word $0001,$0002,$0003,$0004,$0005,$0006; monster 0
    .byte $07,$08,$00,$00                    ;

    ; unused data
    .repeat 255
        .tag MonsterStat
    .endrepeat
