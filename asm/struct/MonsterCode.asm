;--------------------------------
; Struct: MonsterCode
;
; start  - *word* : Address of the 'start' event subroutine
; turn   - *word* : Address offset from last event pointing to 'turn' event subroutine
; custom - *word* : Address offset from last event pointing to 'custom' event subroutine
; hit    - *word* : Address offset from last event pointing to 'hit' event subroutine
; act    - *word* : Address offset from last event pointing to 'act' event subroutine
; item   - *word* : Address offset from last event pointing to 'item' event subroutine
; spare  - *word* : Address offset from last event pointing to 'spare' event subroutine
; flee   - *word* : Address offset from last event pointing to 'flee' event subroutine
;
; size: 16 bytes
;
; Each address is offset from the last (expept first event).
; the PRG bank is found at <monster_code_bnk>.
;--------------------------------
.struct MonsterCode
    start   .word
    turn    .word
    custom  .word
    hit     .word
    act     .word
    item    .word
    spare   .word
    flee    .word
.endstruct

; Constant: MONSTER_CODE_SHIFT
; size of struct <MonsterCode> in power of 2
MONSTER_CODE_SHIFT = 4
