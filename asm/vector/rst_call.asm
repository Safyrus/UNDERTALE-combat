RST:
    LDA #<.bank(_RST)+$80
    STA MMC5_PRG_BNK0
    JMP _RST
