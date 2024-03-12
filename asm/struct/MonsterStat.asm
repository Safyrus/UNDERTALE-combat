;--------------------------------
; Struct: MonsterStat
;
; maxhp      - *word* : maximum Health Points
; hp         - *word* : Health Points
; atk        - *word* : ATacK points
; def        - *word* : DEFense points
; xp         - *word* : number of XP given if defeated
; gold       - *word* : number of gold given
; item       - *byte* : ID of the item given if lucky
; itemchance - *byte* : chance of obtaining the item (0 = 0%, 255 = 100%)
;
; size: 16 bytes
;--------------------------------
.struct MonsterStat
    maxhp       .word
    hp          .word
    atk         .word
    def         .word
    xp          .word
    gold        .word
    item        .byte
    itemchance  .byte
    pad         .res 2
.endstruct

; Constant: MONSTER_STAT_SHIFT
; size of struct <MonsterStat> in power of 2
MONSTER_STAT_SHIFT = 4
