
;--------------------------------
; Subroutine: draw_dialog_box
;--------------------------------
;
; Draw the dialog box
; /!\ rendering must be disable /!\
;
;--------------------------------
draw_dialog_box:
    pushregs

    ; Set the Extented RAM as work RAM
    mov MMC5_EXT_RAM, #$02

    ; set dialog box upper tiles
    LDA #UI_CHR_BNK + $80 ; load upper tile + choose UI palette
    for_x @hi, #0
        ; write to MMC5 ram
        STA MMC5_EXP_RAM+$000, X
        STA MMC5_EXP_RAM+$100, X
        STA MMC5_EXP_RAM+$200, X
        STA MMC5_EXP_RAM+$300, X
    to_x_inc @hi, #0

    ; Set back the Extented RAM to attribute data
    mov MMC5_EXT_RAM, #$01

    ; set PPU_ADDR to $2200
    BIT PPU_STATUS
    mov PPU_ADDR, #$22
    mov PPU_ADDR, #$00

    ; draw 8 lines
    for_y @line, #0
        ; empty tile
        mov PPU_DATA, #DIALOG_BOX_TILE_MIDDLE
        ; set dialog left tile
        LDA @data_left, Y
        STA PPU_DATA
        ; set dialog box middle tile
        LDA @data_center, Y
        for_x @mid, #0
            STA PPU_DATA
        to_x_inc @mid, #28
        ; set dialog right tile
        LDA @data_right, Y
        STA PPU_DATA
        ; empty tile
        mov PPU_DATA, #DIALOG_BOX_TILE_MIDDLE
    to_y_inc @line, #8

    ; return
    pullregs
    RTS

    @data_left:
    .byte DIALOG_BOX_TILE_TL
    .repeat 6
    .byte DIALOG_BOX_TILE_LEFT
    .endrepeat
    .byte DIALOG_BOX_TILE_BL

    @data_right:
    .byte DIALOG_BOX_TILE_TR
    .repeat 6
    .byte DIALOG_BOX_TILE_RIGHT
    .endrepeat
    .byte DIALOG_BOX_TILE_BR

    @data_center:
    .byte DIALOG_BOX_TILE_TOP
    .repeat 6
    .byte DIALOG_BOX_TILE_MIDDLE
    .endrepeat
    .byte DIALOG_BOX_TILE_BOT

