

default_player_stat:
.byte 20, 20, 1, 1, 1, 0, 0, 0, 0, "TEST  "

;--------------------------------
; Subroutine: INIT
;--------------------------------
;
; Part of main. Called once at the start of the game.
;
;--------------------------------
INIT:
    ; save init bank
    mov mmc5_banks+1, #<.bank(INIT)+$80
    ; load var ram bank
    mov MMC5_RAM_BNK, #VAR_RAM_BNK
    STA mmc5_banks+0

    ; Reset buffers in RAM bank
    LDA #$00
    for_x @rst_exp_ram, 0
        ; STA MMC5_RAM, X ; nop, need to be saved between reset
        STA MMC5_RAM+$100, X
        STA MMC5_RAM+$200, X
        STA MMC5_RAM+$300, X
        STA MMC5_RAM+$400, X
    to_x_dec @rst_exp_ram, 0

    ; clear graphics
    JSR clear_nt_all_raw
    JSR remove_all_spr

    ; setup player stat hard coded for now
    for_x @set_player, #.sizeof(PlayerStat)-1
        LDA default_player_stat, X
        STA player_stats, X
    to_x_dec @set_player, #-1
    
    ; init graphics
    JSR init_pal
.ifndef MUSICROM
    JSR draw_dialog_box
    JSR draw_UI
.endif

    ; set CHR bank 0 to player sprites
    mov MMC5_CHR_BNK0, #PLAYER_SPRITE_BNK

    ; enable rendering
    mov PPU_MASK, #(PPU_MASK_BKG+PPU_MASK_BKG8+PPU_MASK_SPR+PPU_MASK_SPR8)
    mov nmi_flags, #(NMI_PLT+NMI_SPR+NMI_SCRL+NMI_BKG)

    ; Enable scanline IRQ
    mov MMC5_SCNL_STAT, #$80
    ; wait 1 frame (because 1st scanline IRQ will trigger because of turning on rendering)
    and_adr nmi_flags, #$FF - NMI_DONE
    @wait_vblank:
        BIT nmi_flags
        BPL @wait_vblank

    ; init player bounding box
    mov player_bound_x1, #1*8
    STA futur_box_pos_x1
    mov player_bound_y1, #16*8
    STA futur_box_pos_y1
    mov player_bound_x2, #30*8+6
    STA futur_box_pos_x2
    mov player_bound_y2, #23*8+6
    STA futur_box_pos_y2
    ; init player soul type
    mov player_soul, #SOUL::WAIT
    JSR switch_player_soul

    ; init text reading
    mov lz_idx, #$00
    JSR lz_init
    JSR lz_decode

    ; init rng
    mov_ptr seed, saved_seed
    ; if seed == 0
    CMP seed+0
    BNE :+
    CMP seed+1
    BNE :+
        ; seed += 1
        INC seed
    :
    ; saved seed = rng()
    JSR rng
    mov_ptr saved_seed, seed

    ; init packet_buffer_end
    sta_ptr packet_buffer_end, packet_buffer

    ; load fight 1
    mov fight_id, #$01
    JSR load_fight

    ; update player UI
    mov player_flag, #PLAYER_FLAG_DRAW_HP + PLAYER_FLAG_DRAW_PLAYER

    ; set inventory
    for_x @inv, #INV_SIZE-1
        TXA
        STA player_inv, X
        INC player_inv, X
    to_x_dec @inv, #-1

    ; Init FamiStudio
    LDA #<.bank(music_data_undertale_ost_0)+$80
    JSR init_famistudio

    RTS
