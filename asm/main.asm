;**********
; Main
;**********

.include "audio/wrapper.asm"

.include "box/main.asm"
.include "box/left.asm"
.include "box/right.asm"
.include "box/top.asm"
.include "box/bot.asm"
.include "box/utils.asm"

.include "dmg/table.asm"
.include "dmg/anim.asm"

.include "img/anim.asm"
.include "img/draw_buf.asm"
.include "img/draw_img.asm"
.include "img/draw_anim.asm"
.include "img/draw_rle_bkg.asm"
.include "img/draw_rle_spr.asm"
.include "img/draw_rle.asm"
.include "img/find.asm"
.include "img/rleinc.asm"

.include "menu/draw.asm"
.include "menu/go.asm"
.include "menu/logic.asm"

.include "monster/code_utils.asm"
.include "monster/event.asm"
.include "monster/load.asm"
.include "monster/utils.asm"

.include "soul/menu.asm"
.include "soul/red.asm"
.include "soul/blue.asm"
.include "soul/fight.asm"
.include "soul/wait.asm"

.include "sprite/draw_spr_buf.asm"
.include "sprite/entity.asm"
.include "sprite/hitmark.asm"
.include "sprite/player.asm"
.include "sprite/monster.asm"
.include "sprite/remove.asm"

.include "text/post.asm"
.include "text/pre.asm"
.include "text/process.asm"
.include "text/utils.asm"
.include "text/lz.asm"

.include "ui/draw_ui.asm"
.include "ui/draw_hp.asm"

.include "hitbox.asm"
.include "int2bcd.asm"
.include "item.asm"
.include "joypad.asm"
.include "player.asm"
.include "utils.asm"
.include "rng.asm"


;--------------------------------
; Subroutine: MAIN
;--------------------------------
;
; MAIN function for the entire game.
; Starting point of the code after RST is done.
;
;--------------------------------
MAIN:
    JSR INIT

.ifdef MUSICROM
    .include "music_override.asm"
.endif

MAIN_loop:
    ; wait for the next frame
    @wait_vblank:
        ;
        JSR rng
        ; is NMI_DONE set
        BIT nmi_flags
        ; loop until it is
        BPL @wait_vblank

    ; acknowledge NMI by clearing NMI_DONE
    ; and update sprites + scroll + background
    mov nmi_flags, #(NMI_SPR+NMI_SCRL+NMI_BKG)

    @DEBUG_MAIN_FIRST:

    ; frame_counter++
    inc_16 frame_counter
    ; remove all sprites
    JSR remove_all_spr

    ; process input + player
    JSR update_input
    JSR update_player

    @DEBUG_MAIN_DRAW:

    ; if PLAYER_FLAG_DRAW_PLAYER
    LDA player_flag
    AND #PLAYER_FLAG_DRAW_PLAYER
    BEQ :+
        ; draw player
        JSR draw_player
    :

    ; dialog box animation
    JSR dialog_box_anim

    JSR draw_packet_buffer
    JSR draw_spr_buf
    JSR update_anims

    ; update player hp (if needed)
    LDA player_flag
    AND #PLAYER_FLAG_DRAW_HP
    BEQ :+
        JSR update_player_hp
    :

    @DEBUG_MAIN_LOGIC:

    ;
    JSR update_hitboxes

    ; if number of dialog > 0
    LDA n_dialog
    BEQ :+
    ; and dialog box animation is done
    LDA dialogbox_anim_flag
    BNE :+
        ; process text
        JSR text_process
    :

    ;
    JSR update_monster_events

    ;
    LDA item_adr+0
    BNE @item
    LDA item_adr+1
    BNE @item
        JMP @item_end
    @item:
        JSR use_item
    @item_end:

    NOP ; for debug: make label below exist
    ; loop
MAIN_end:
    JMP MAIN_loop

    ; only for debbug, should be removed latter
    ; (not really important to forget because doing this only save 1 byte)
    RTS
