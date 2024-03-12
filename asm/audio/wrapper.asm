; A = music bank
init_famistudio:
    ; set bank
    STA MMC5_PRG_BNK1
    STA cur_music_bank

    ; init Famistudio
    LDX #<music_data_undertale_ost_0
    LDY #>music_data_undertale_ost_0
    TYA
    JSR famistudio_init

    ; test music
    LDA #$06
    JSR famistudio_music_play

    ; restore bank
    LDA mmc5_banks+2
    STA MMC5_PRG_BNK1
    ; return
    RTS


famistudio_dpcm_bank_callback:
    add #<.bank(DPCM_START)+$80
    STA cur_dpcm_bank
    STA mmc5_banks+3
    RTS


; X = idx
play_music:
    ; set FamiStudio/tables bank
    mov MMC5_PRG_BNK0, #<.bank(famistudio_music_play)+$80

    ; b = music_bank_table[X]
    LDA music_bank_table, X
    ; if b != cur_music_bank
    CMP cur_music_bank
    BEQ :+
        ; init_famistudio(b)
        phx
        LDA music_bank_table, X
        JSR init_famistudio
        plx
    :

    ; set bank
    mov MMC5_PRG_BNK1, cur_music_bank

    ; a = music_idx_table[X]
    LDA music_idx_table, X
    ; play(a)
    JSR famistudio_music_play

    ; restore bank
    mov MMC5_PRG_BNK0, mmc5_banks+1
    mov MMC5_PRG_BNK1, mmc5_banks+2
    ; return
    RTS
