;***********
; IRQ vector
;***********


IRQ:
    ; save register
    PHA

    ; clear APU interrupt
    LDA APU_STATUS

    BIT MMC5_SCNL_STAT
    BPL :+
        JMP SCANLINE_IRQ
    :

    ; restore register
    PLA
    ; return
    RTI



SCANLINE_IRQ:
    LDA scanline
    BNE :+
        ORA #$40
        STA scanline
        LDA #$70
        STA MMC5_SCNL_VAL
        JMP @end
    :
    AND #$FF - $40
    STA scanline

    @end:
    INC scanline
    ; restore register
    PLA
    ; return
    RTI
