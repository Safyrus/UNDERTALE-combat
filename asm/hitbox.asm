
update_hitboxes:
    LDA #<.bank(hitbox_call_table_move_lo)+$80
    STA MMC5_PRG_BNK1
    STA mmc5_banks+2

    ; for each hitbox
    for_x @loop, #MAX_HITBOX-1
        ; if hitbox inactive (type == 0)
        LDA hitbox_t, X
            ; continue
            BEQ :++

        ; call_hitbox_move(X)
        TAY
        phx
        JSR call_hitbox_move
        plx
        ; if hitbox link to animation
        LDA hitbox_a, X
        BEQ :+
            ; anim[Y].pos = hitbox[X].pos
            TAY
            DEY
            LDA hitbox_x, X
            STA anims_x, Y
            LDA hitbox_y, X
            STA anims_y, Y
            ;
            JSR update_entity_hitbox_pos
        :
        ; if is_player_hit(X)
        JSR is_player_hit
        BNE :+
            LDA hitbox_t, X
            TAY
            ; call_hitbox_hit(X)
            phx
            JSR call_hitbox_hit
            plx
        :
    to_x_dec @loop, #-1

    RTS


; X = hitbox index
; use A
is_player_hit:
    ; if player x >= hitbox_x[X]
    LDA player_x
    CMP hitbox_x, X
    blt :+
    ; and player x < hitbox_w[X]
    CMP hitbox_w, X
    bge :+
    ; and player y >= hitbox_y[X]
    LDA player_y
    CMP hitbox_y, X
    blt :+
    ; and player y < hitbox_h[X]
    CMP hitbox_h, X
    bge :+
        ; set Z
        LDA #$00
        RTS
    :
        ; clear Z
        LDA #$01
        RTS


call_hitbox_hit:
    LDA hitbox_call_table_hit_hi, Y
    PHA
    LDA hitbox_call_table_hit_lo, Y
    PHA
    RTS

call_hitbox_move:
    LDA hitbox_call_table_move_hi, Y
    PHA
    LDA hitbox_call_table_move_lo, Y
    PHA
    RTS


update_entity_hitbox_pos:
    INY
    STY tmp
    TYA
    for_y @loop, #MAX_SPR-1
        CMP spr_buf_anim, Y
        BNE :+
            LDA hitbox_x, X
            STA spr_buf_x, Y
            LDA hitbox_y, X
            STA spr_buf_y, Y
            LDA tmp
        :
    to_y_dec @loop, #-1
    RTS


; A = type
; X,Y = pos
; return Y = idx (-1=no idx)
new_hitbox:
    push_ay
    for_y @loop, #MAX_HITBOX-1
        LDA hitbox_t, Y
        BNE :+
            TXA
            STA hitbox_x, Y
            PLA
            STA hitbox_y, Y
            PLA
            STA hitbox_t, Y
            RTS
        :
    to_y_dec @loop, #0
    PLA
    PLA
    DEY
    RTS


clear_hitbox:
    pushregs
    for_x @loop, #MAX_HITBOX-1
        LDA hitbox_t, X
        BEQ :+
            JSR remove_hitbox
        :
    to_x_dec @loop, #0
    pullregs
    RTS


; X = idx
remove_hitbox:
    LDA #$00
    STA hitbox_t, X
    LDA hitbox_a, X
    BEQ :+
        TAY
        DEY
        LDA #$00
        STA anims_flag, Y
        phx
        TYA
        JSR clear_entity_spr
        plx
    :
    RTS
