; X, Y = img pos
; tmp = img idx
draw_bkg_img:
    ; X,Y = img idx
    phx
    phy
    LDX tmp+0
    LDY tmp+1
    ; find img
    JSR find_rleimg
    ; X,Y = pos
    ply
    plx
    ; change bank
    push mmc5_banks+1
    LDA tmp+2
    STA mmc5_banks+1
    STA MMC5_PRG_BNK0
    ;
    JSR draw_bkg_rleimg
    ; restore bank
    PLA
    STA mmc5_banks+1
    STA MMC5_PRG_BNK0
    ; return
    RTS
