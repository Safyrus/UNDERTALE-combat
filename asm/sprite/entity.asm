
; A = idx
; dont save regs
clear_entity_spr:
    add #$01

    ; for each sprite
    for_x @loop, #MAX_SPR-1
        ; if sprite.anim_idx == idx
        CMP spr_buf_anim, X
        BNE :+
            ; sprite.anim_idx = 0
            PHA
            LDA #$00
            STA spr_buf_anim, X
            PLA
        :
    to_x_dec @loop, #-1
    RTS


; A = tile info
; X,Y = pos
; tmp+0 = anim_idx
add_entity_spr:
    push_ax

    ; for each sprite
    for_x @loop, #MAX_SPR-1
        ; if sprite.anim_idx == 0
        LDA spr_buf_anim, X
        BNE :+
            ; set y pos
            TYA
            STA spr_buf_y, X
            ; set anim idx
            LDA tmp+0
            add #$01
            STA spr_buf_anim, X
            ; set x pos
            TXA
            TAY
            PLA
            STA spr_buf_x, Y
            ; set atr
            PLA
            PHA
            AND #$C1
            STA spr_buf_atr, Y
            ; set idx
            PLA
            AND #$3E
            STA spr_buf_idx, Y
            ; idx += monster CHR BNK (bit 2)
            JSR get_monster_chr_bnk_offset
            TXA
            LSR
            LSR
            ORA spr_buf_idx, Y
            STA spr_buf_idx, Y
            ; idx += monster CHR BNK (bit 0 & 1)
            TXA
            CLC
            ROR
            ROR
            ROR
            ORA spr_buf_idx, Y
            STA spr_buf_idx, Y
            ; return
            RTS
        :
    to_x_dec @loop, #0

    ; return
    pull_ax
    RTS
