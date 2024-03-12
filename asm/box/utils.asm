;--------------------------------
; Subroutine: dialog_box_anim_corner_tiles
;--------------------------------
;
; Draw the dialog box corner.
;
; /!\ does not save registers /!\
;
;--------------------------------
dialog_box_anim_corner_tiles:
    ; top left
    LDX player_bound_x1
    LDY player_bound_y1
    JSR xy_2_ppu
    LDY #$01
    LDA #DIALOG_BOX_TILE_TL
    JSR dialogbox_anim_send_ppu
    ; top right
    LDX player_bound_x2
    LDY player_bound_y1
    JSR xy_2_ppu
    LDY #$01
    LDA #DIALOG_BOX_TILE_TR
    JSR dialogbox_anim_send_ppu
    ; bot left
    LDX player_bound_x1
    LDY player_bound_y2
    JSR xy_2_ppu
    LDY #$01
    LDA #DIALOG_BOX_TILE_BL
    JSR dialogbox_anim_send_ppu
    ; bot right
    LDX player_bound_x2
    LDY player_bound_y2
    JSR xy_2_ppu
    LDY #$01
    LDA #DIALOG_BOX_TILE_BR
    JSR dialogbox_anim_send_ppu
    ;return
    RTS

;--------------------------------
; Subroutine: dialog_box_anim_corner_del_sprites
;--------------------------------
;
; Delete the dialog box corner sprites.
;
; /!\ does not save registers /!\
;
;--------------------------------
dialog_box_anim_corner_del_sprites:
    LDX #$13
    @loop:
        LDA @data-4, X
        STA OAM, X
        ;
        DEX
        CPX #$03
        BNE @loop
    RTS
    @data:
    .byte $FF, DIALOG_BOX_SPRITE_TILE, $00, $00
    .byte $FF, DIALOG_BOX_SPRITE_TILE, $40, $00
    .byte $FF, DIALOG_BOX_SPRITE_TILE, $80, $00
    .byte $FF, DIALOG_BOX_SPRITE_TILE, $C0, $00


;--------------------------------
; Subroutine: dialog_box_anim_corner_sprites
;--------------------------------
;
; Draw the dialog box corner sprites.
;
; /!\ does not save registers /!\
;
;--------------------------------
dialog_box_anim_corner_sprites:
    JSR dialog_box_anim_corner_del_sprites
    ; y1
    LDA player_bound_y1
    AND #$FE
    TAX
    DEX
    STX OAM+4
    STX OAM+8
    ; y2
    LDA player_bound_y2
    AND #$FE
    sub #$0F
    STA OAM+12
    STA OAM+16
    ; x1
    LDA player_bound_x1
    AND #$FE
    STA OAM+7
    STA OAM+15
    ; x2
    LDA player_bound_x2
    AND #$FE
    sub #$06
    STA OAM+11
    STA OAM+19
    ;
    LDA #$04
    add oam_size
    STA oam_size
    ;return
    RTS



;--------------------------------
; Subroutine: dialogbox_anim_send_ppu
;--------------------------------
;
; Send a background packet to draw with the same tile y times.
;
; Parameters:
; A - tile
; Y - size
; tmp - ppu address
;
; /!\ does not save registers /!\
;
; /!\ dont check for background buffer overflow /!\
;
;--------------------------------
dialogbox_anim_send_ppu:
    ;
    PHA
    ; size
    LDX background_index
    STY background, X
    INX
    ; adr
    LDA tmp+1
    STA background, X
    INX
    LDA tmp+0
    STA background, X
    INX
    ; remove vertical flag
    TYA
    AND #$7F
    TAY
    ; tiles
    PLA
    @loop:
        STA background, X
        INX
        ;
        DEY
        BNE @loop
    ; close
    LDA #$00
    STA background, X
    STX background_index
    ; return
    @end:
    RTS
