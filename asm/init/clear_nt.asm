;################
; File: clear_nt
;################
; subrountines related to clearing nametables

;--------------------------------
; Subroutine: clear_nt_all_raw
;--------------------------------
;
; Clear all nametables.
; /!\ rendering must be disable /!\
;
;--------------------------------
clear_nt_all_raw:
    pushregs

    ; set PPU_ADDR to $2000
    BIT PPU_STATUS
    mov PPU_ADDR, #$20
    mov PPU_ADDR, #$00

    ; clear all nametable
    LDA #CLEAR_TILE
    for_x @loop_x, #0
        for_y @loop_y, #0
            STA PPU_DATA
        to_y_inc @loop_y, #0
    to_x_inc @loop_x, #$10

    pullregs
    RTS
