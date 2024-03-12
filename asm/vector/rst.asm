;***********
; RST vector
;***********


_RST:
    SEI         ; Disable interrupt

    LDX #$FF    ; Initialized stack
    TXS

    INX         ; X=0
    STX PPU_CTRL ; Disable NMI
    STX PPU_MASK ; Disable Rendering
    STX APU_DMC_FREQ ; Disable DMC IRQ

    ; Wait for the PPU to initialized
    BIT PPU_STATUS       ; Clear the VBL flag if it was set at reset time
@vwait1:
    BIT PPU_STATUS
    BPL @vwait1      ; At this point, about 27384 cycles have passed

@clrmem:
    LDA #$00
    STA $0000, x
    STA $0100, x
    STA $0200, x
    STA $0300, x
    STA $0400, x
    STA $0500, x
    STA $0600, x
    STA $0700, x
    INX
    BNE @clrmem

@vwait2:
    BIT PPU_STATUS
    BPL @vwait2      ; At this point, about 57165 cycles have passed

    ; - - - - - - -
    ; setup MMC5
    ; - - - - - - -

    ; disable ram protection
    mov MMC5_RAM_PRO1, #$02
    mov MMC5_RAM_PRO2, #$01

    ; Set the Extented RAM as work RAM to clean it
    mov MMC5_EXT_RAM, #$02
    ; Reset Extended RAM content
    LDA #$00
    for_x @rst_exp_ram, 0
        STA MMC5_EXP_RAM, X
        STA MMC5_EXP_RAM+$100, X
        STA MMC5_EXP_RAM+$200, X
        STA MMC5_EXP_RAM+$300, X
    to_x_dec @rst_exp_ram, 0

    ; Set the Extented RAM as extended attribute data
    mov MMC5_EXT_RAM, #$01

    ; Set fill tile
    LDA #CLEAR_TILE
    STA MMC5_FILL_TILE
    STA MMC5_FILL_COL

    ; Disable Vertical split
    LDA #$00
    STA MMC5_SPLT_MODE
    STA MMC5_SPLT_BNK
    STA MMC5_SPLT_SCRL

    ; Set 1KB CHR pages mode
    mov MMC5_CHR_MODE, #$03

    ; Enable NMI + set sprite to 8*16
    LDA #PPU_CTRL_NMI+PPU_CTRL_SPR_SIZE
    STA PPU_CTRL
    STA ppu_ctrl_val

    ; set nametable mapping
    mov MMC5_NAMETABLE, #%11100100 ; D = fill, C = attr, B = nt1, A = nt0

    CLI ; Enable back interrupt
    JMP MAIN ; jump to main function
