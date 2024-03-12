;--------------------------------
; Struct: PlayerStat
;
; maxhp - *byte* : max Health Points
; hp    - *byte* : Health Points
; atk   - *byte* : ATacK points
; def   - *byte* : DEFense points
; lv    - *byte* : number of LV
; xp    - *word* : number of XP
; gold  - *word* : number of gold
; name  - *6 bytes* : Player name
;
; size: 15 bytes
;--------------------------------
.struct PlayerStat
    maxhp   .byte
    hp      .byte
    atk     .byte
    def     .byte
    lv      .byte
    xp      .word
    gold    .word
    name    .res 6
.endstruct
