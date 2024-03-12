;--------------------------------
; Subroutine: byte2dec
;--------------------------------
;
; Convert a byte to a decimal string.
;
; Parameter:
; A - byte to convert
;
; Return:
; tmp - a string 3 char long (from tmp+0 to tmp+2)
;
; /!\ Change registers /!\
;--------------------------------
byte2dec:
    PHA
    ; init tmp to "  0"
    mov tmp+0, #' '
    STA tmp+1
    mov tmp+2, #'0'
    ; init div by 10
    mov divisor, #10

    ; X = n
    PLA
    TAX
    ; Y = 2 (offset of tmp)
    LDY #2
    ; while true
    @while:
        ; n, r = n / 10
        TXA
        JSR div
        ; tmp+Y = '0' + r
        ORA #$30
        STA tmp, Y
        ; if n == 0 then break
        CPX #$00
        BEQ @end
        ; Y--
        DEY
        ; loop
        JMP @while

    @end:
    ; return
    RTS


;--------------------------------
; Subroutine: div
;--------------------------------
;
; Perform a division (A / divisor).
;
; Parameter:
; A - the dividend
; divisor - the divisor, see <divisor>
;
; Return:
; X - result
; A - remainder
;
;--------------------------------
div:
    LDX #$FF
    @loop:
        INX
        sub divisor
        BCS @loop
    BNE @end
        INX
    @end:
    ADC divisor
    RTS


;--------------------------------
; Subroutine: xy_2_ppu
;--------------------------------
;
; Transform an xy position into a ppu address.
;
; Parameters:
; X - x position
; Y - y position
;
; Return:
; tmp - ppu address
;
; /!\ does not save registers /!\
;
;--------------------------------
xy_2_ppu:
    ; pixels to tiles
    TXA
    shift LSR, 3
    TAX
    TYA
    shift LSR, 3
    TAY
    ; compute ppu adr (hi)
    TYA
    shift LSR, 3
    ORA #$20
    STA tmp+1
    ; compute ppu adr (lo)
    TYA
    shift ASL, 5
    STA tmp+0
    TXA
    add tmp+0
    STA tmp+0
    ; return
    RTS


; A = mosnter fight pos
; return tmp
get_monster_act_str_adr_for_cur_monster:
    BNE :+
        sta_ptr tmp, monster_0_act_str
        RTS
    :
    CMP #$01
    BNE :+
        sta_ptr tmp, monster_1_act_str
        RTS
    :
        sta_ptr tmp, monster_2_act_str
        RTS



str_len:
    LDY #$00
str_len_y:
    LDX #$00
    @while:
        LDA (tmp), Y
        BEQ @end
        INY
        INX
        BNE @while
    @end:
    RTS
