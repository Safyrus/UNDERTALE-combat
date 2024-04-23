MAIN_music_init:
    @pause = act_choice
    mov @pause, #$FF

    mov PPU_MASK, #$00 ; Disable Rendering
    mov nmi_flags, #$00

    ; clear graphics
    JSR clear_nt_all_raw

    ; enable rendering
    mov PPU_MASK, #(PPU_MASK_BKG+PPU_MASK_BKG8+PPU_MASK_SPR+PPU_MASK_SPR8)
    mov nmi_flags, #(NMI_PLT+NMI_SPR+NMI_SCRL+NMI_BKG)

    ; add delay between inputs
    mov btn_timer_var, #BTN_TIMER

    ; --------
    ; draw things
    ; --------
    ; find and display undertale logo
    LDA #<ANIM_DATA_MONSTERS_UNDERTALE_LOGO_L
    STA tmp+0
    LDA #>ANIM_DATA_MONSTERS_UNDERTALE_LOGO_L
    STA tmp+1
    LDX #48
    LDY #64
    JSR draw_bkg_img
    ; (right part)
    LDA #<ANIM_DATA_MONSTERS_UNDERTALE_LOGO_R
    STA tmp+0
    LDA #>ANIM_DATA_MONSTERS_UNDERTALE_LOGO_R
    STA tmp+1
    LDX #48+80
    LDY #64
    JSR draw_bkg_img

MAIN_music:
    @pause = act_choice

    JSR clear_main_box
    ; get music name
    LDY cur_music
    LDA song_strings_adr_lo, Y
    STA tmp+0
    LDA song_strings_adr_hi, Y
    STA tmp+1
    ; add music name to text
    mov $0700+0, #CHAR::SPD
    mov $0700+1, #$00
    LDY #$00
    LDX #$02
    @copy_name:
        ; if name[Y] == 0
        LDA (tmp), Y
            ; break
            BEQ :+
        ; text[X] = name[Y]
        STA $0700, X
        INX
        INY
        BNE @copy_name
    :
    ; copy controls text
    for_y @copy_txt, #0
        LDA @text, Y
        STA $0700, X
        INX
    to_y_inc @copy_txt, #@text_end - @text

    ; next_char_ptr = text_buffer
    mov next_char_ptr+0, #$00
    mov next_char_ptr+1, #$07
    ; text_pre_process()
    JSR text_pre_process

    ; play selected music
    LDX cur_music
    JSR play_music
    LDA @pause
    JSR famistudio_music_pause

    @inputs:
    ; --------
    ; wait for the next frame
    ; --------
    @wait_vblank:
        ; is NMI_DONE set
        BIT nmi_flags
        ; loop until it is
        BPL @wait_vblank
    ; acknowledge NMI by clearing NMI_DONE
    ; and update sprites + scroll + background
    mov nmi_flags, #(NMI_SCRL+NMI_BKG)

    ; wait to be in frame
    @wait_inframe:
        BIT scanline
        BVC @wait_inframe

    ; update graphics
    JSR draw_packet_buffer

    ; if number of dialog > 0
    LDA n_dialog
    BEQ :+
    ; and dialog box animation is done
    LDA dialogbox_anim_flag
    BNE :+
        ; process text
        JSR text_process
    :

    ; --------
    ; process inputs
    ; --------
    JSR update_input
    ; if A is pressed
    LDA btn_1
    AND #BTN_A
    BEQ :+
        ; play/pause music
        LDA @pause
        EOR #$FF
        STA @pause
        JSR famistudio_music_pause
    :
    ; if left is pressed
    LDA btn_1
    AND #BTN_LEFT
    BEQ :++
        ; previous musics
        DEC cur_music
        ; if underflow
        LDA cur_music
        CMP #$FF
        BNE :+
            ;
            mov cur_music, #MAX_MUSIC
        :
        JMP MAIN_music
    :
    ; if right is pressed
    LDA btn_1
    AND #BTN_RIGHT
    BEQ :++
        ; next musics
        INC cur_music
        ; if overflow
        LDA cur_music
        CMP #MAX_MUSIC
        ble :+
            ;
            mov cur_music, #0
        :
        JMP MAIN_music
    :
    JMP @inputs


@text:
.byte CHAR::FDB, CHAR::POS, $02, $18, CHAR::SPD, $00
.byte "A Play/Pause", CHAR::LB
.byte "< Previous   > Next";, CHAR::FDB
.byte CHAR::FDB, CHAR::END
@text_end:
