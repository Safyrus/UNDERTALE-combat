;--------------------------------
; Subroutine: draw_UI
;--------------------------------
;
; Draw the UI
; /!\ rendering must be disable /!\
;
;--------------------------------
draw_UI:
    push_ax

    ; set PPU_ADDR to $2340
    BIT PPU_STATUS
    mov PPU_ADDR, #$23
    mov PPU_ADDR, #$40

    for_x @ui, #0
        LDA @UI_data_lo, X ; load lower tile
        STA PPU_DATA ; write to ppu
    to_x_inc @ui, #128

    ; Set the Extented RAM as work RAM
    mov MMC5_EXT_RAM, #$02
    ;
    LDA #FONT_CHR_BNK ; load upper tile
    for_x @player_ui, #31
        STA MMC5_EXP_RAM+$320, X ; write to MMC5 ram
    to_x_dec @player_ui, #-1
    ; Set back the Extented RAM to attribute data
    mov MMC5_EXT_RAM, #$01

    ; set PPU_ADDR to $2321
    BIT PPU_STATUS
    mov PPU_ADDR, #$23
    mov PPU_ADDR, #$21
    ; write player name
    for_x @name, #0
        LDA player_stats + PlayerStat::name, X ; load name tile
        STA PPU_DATA ; write to ppu
    to_x_inc @name, #6
    ; write rest of player UI
    for_x @uiplayer, #0
        LDA @UI_player, X ; load tile
        STA PPU_DATA ; write to ppu
    to_x_inc @uiplayer, #9

    ; set PPU_ADDR to $232A
    BIT PPU_STATUS
    mov PPU_ADDR, #$23
    mov PPU_ADDR, #$2A
    ; convert player LV to string
    LDA player_stats + PlayerStat::lv
    JSR byte2dec
    ; and display the result (max 99)
    mov PPU_DATA, tmp+1
    mov PPU_DATA, tmp+2

    ; return
    pull_ax
    RTS

    @UI_player:
    .byte " LV??  HP"

    @UI_data_lo:
    .byte $0E,$3E,$3E,$3E,$3E,$3E,$3E,$0F,$0E,$3E,$3E,$3E,$3E,$3E,$3E,$0F,$0E,$3E,$3E,$3E,$3E,$3E,$3E,$0F,$0E,$3E,$3E,$3E,$3E,$3E,$3E,$0F
    .byte $1E,$28,$29,$2A,$2B,$2C,$2D,$1F,$1E,$08,$09,$0A,$0B,$0C,$0D,$1F,$1E,$48,$49,$4A,$4B,$4C,$4D,$1F,$1E,$68,$69,$6A,$6B,$6C,$6D,$1F
    .byte $1E,$38,$39,$3A,$3B,$3C,$3D,$1F,$1E,$18,$19,$1A,$1B,$1C,$1D,$1F,$1E,$58,$59,$5A,$5B,$5C,$5D,$1F,$1E,$78,$79,$7A,$7B,$7C,$7D,$1F
    .byte $2E,$3F,$3F,$3F,$3F,$3F,$3F,$2F,$2E,$3F,$3F,$3F,$3F,$3F,$3F,$2F,$2E,$3F,$3F,$3F,$3F,$3F,$3F,$2F,$2E,$3F,$3F,$3F,$3F,$3F,$3F,$2F
