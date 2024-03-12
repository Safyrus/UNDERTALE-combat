;--------------------------------
; Struct: Fight
;
; flag - *byte* : fight flags (......nn: n=number of monsters)
; id0  - *byte* : first monster id
; id1  - *byte* : second monster id
; id2  - *byte* : third monster id
;
; size: 4 bytes
;--------------------------------
.struct Fight
    flag.byte
    id0 .byte
    id1 .byte
    id2 .byte
.endstruct

; Constant: FIGHT_SHIFT
; size of struct <Fight> in power of 2
FIGHT_SHIFT = 2
