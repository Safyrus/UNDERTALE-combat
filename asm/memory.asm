;################
; File: Memory
;################
;
;----------------
; Layout:
;----------------
; 
; - NES Memory:
;--- Text
;   Page | Description
;   $00  | Zero page (NMI, tmp & other variables)
;   $01  | Stack + string buffer
;   $02  | OAM (sprites)
;   $03  | Famistudio
;   $04  | Famistudio + Game
;   $05  | Game
;   $06  | Game
;   $07  | Nothing
;---
;
; - MMC5 Memeory:
;--- Text
;   $0000-$1FFF: Variables
;       Page | Description
;       $00      | Saved Variables
;       $01-$02  | Sprites Buffer
;       $03      | Animation Table
;       $04      | Hitbox Table
;       $05-$06  | Image Buffer
;       $07-$0E  | Packet Buffer
;   $2000-$3FFF: LZ decoding text buffer
;---


;****************
; ZEROPAGE SEGMENT
;****************
.segment "ZEROPAGE"
    ;================
    ; Group: Zero Page
    ;================
    
    ; Variable: nmi_flags
    ;----------------
    ; NMI Flags to activate graphical update
    ;
    ; Note:
    ;   You cannot activate all updates.
    ;   You need to have a execution time < ~2273 cycles (2000 to be sure)
    ;--- Text
    ; 7  bit  0
    ; ---- ----
    ; EFJR PASB
    ; |||| ||||
    ; |||| |||+- Background tiles update
    ; |||| |||   Execution time depend on data
    ; |||| |||   (cycles ~= 16 + 38*p + for i:p do (14*p[i].n))
    ; |||| |||   (p=packet number, p[i].n = packet data size)
    ; |||| ||+-- Sprites update (513+ cycles)
    ; |||| |+--- Nametables attributes update (821 cycles)
    ; |||| +---- Palettes update (356 cycles)
    ; |||+------ Scroll update (31 cycles)
    ; ||+------- Jump to specific subroutine
    ; |+-------- Force NMI acknowledge
    ; +--------- 1 when NMI has ended, should be set to 0 after reading.
    ;            If let to 1, it means the NMI is disable
    ;---
    nmi_flags: .res 1

    ; Variable: scroll_x
    ;----------------
    ; Scroll X position
    scroll_x: .res 1

    ; Variable: scroll_y
    ;----------------
    ; Scroll Y position
    scroll_y: .res 1

    ; Variable: atr_nametable
    ;----------------
    ; (unused)
    ;
    ; Nametable high address to update attributes for
    ;
    ; - $23 = Nametable 1
    ; - $27 = Nametable 2
    ; - $2B = Nametable 3
    ; - $2F = Nametable 4
    ;
    ; atr_nametable: .res 1

    ; Variable: ppu_ctrl_val
    ;----------------
    ; value of the PPUCTRL register (need to be refresh manually)
    ppu_ctrl_val: .res 1

    ; Variable: next_char_ptr
    ;----------------
    ; pointer to the next text character to read when calling <read_next_char>
    next_char_ptr: .res 2

    ; Variable: n_dialog
    ;----------------
    ; number of <DialogBox> and size of the <dialog_boxs> list
    n_dialog: .res 1

    ; Variable: palettes
    ;----------------
    ; Palettes data to send to PPU during VBLANK
    ;
    ; - byte 0   = transparente color
    ; - byte 1-3 = background palette 1
    ; - byte 4-6 = background palette 2
    ; - ...
    ; - byte 13-16 = sprite palette 1
    ; - ...
    palettes: .res 25

    ; Variable: attributes
    ;----------------
    ; (unused)
    ;
    ; Attributes data to send to PPU during VBLANK
    ;
    ; attributes: .res 64

    ; Variable: background_index
    ;----------------
    ; Index for the background data
    ;--- Text
    ; FIII IIII
    ; |+++-++++-- Index
    ; +---------- A flag to tell that you are currently writing to the background buffer.
    ;             If it is already set, you must wait for it to be cleared.
    ;---
    background_index: .res 1

    ; Variable: background
    ;----------------
    ; Background data to send to PPU during VBLANK
    ;
    ; Packet structure:
    ;
    ; - byte 0   = vsssssss (v= vertical draw, s= size)
    ; - byte 1-2 = ppu address (most significant byte, least significant byte)
    ; - byte 3-s = tile data
    ;
    ; A packet of size 0 means there is no more data to draw
    background: .res $60-1

    ; Variable: tmp
    ;----------------
    ; temporary variables
    tmp: .res 16

    ; Variable: scanline
    ;----------------
    ; Scanline status (bit 6 = inframe).
    scanline: .res 1

    ; Variable: divisor
    ;----------------
    ; use in <div>
    divisor: .res 1
    ; Variable: seed
    ;----------------
    ; seed use for <rng>
    seed: .res 2

    frame_counter: .res 2

    mmc5_banks: .res 4

    oam_size: .res 1

    fight_timer: .res 1
    fight_monster: .res 1
    fight_damage: .res 1
    fight_markpos: .res 1

    item_adr: .res 2
    item_var: .res 1

    cur_music: .res 1
    cur_music_bank: .res 1
    cur_dpcm_bank: .res 1

    ;================
    ; Group: ZP - LZ variables
    ;================

        ; Variable: lz_in
        ;----------------
        ; text input pointer for <lz_decode>
        lz_in: .res 2

        ; Variable: lz_in
        ;----------------
        ; index of the LZ block to decode. See: <lz_init>
        lz_idx: .res 1

        ; Variable: lz_in
        ;----------------
        ; text input bank for <lz_decode>
        lz_in_bnk: .res 1

    ;================
    ; Group: ZP - Input variables
    ;================

        ; Variable: btn_1
        ;----------------
        ; player 1 inputs
        ;
        ; See Also:
        ;   <update_input>
        btn_1: .res 1

        ; Variable: btn_1_timer
        ;----------------
        ; timer before processing any input of player 1
        ;
        ; See Also:
        ;   <update_input>
        btn_1_timer: .res 1

        ; Variable: btn_1_timer
        ;----------------
        ; amount of time/frame to wait between input reads
        ;
        ; See Also:
        ;   <update_input>
        btn_timer_var: .res 1

    ;================
    ; Group: ZP - Box Animation
    ;================

        ; Variable: futur_box_pos_x1
        ;----------------
        ; wanted top left x position for the player bounding box
        futur_box_pos_x1: .res 1

        ; Variable: futur_box_pos_y1
        ;----------------
        ; wanted top left y position for the player bounding box
        futur_box_pos_y1: .res 1

        ; Variable: futur_box_pos_x2
        ;----------------
        ; wanted bot right x position for the player bounding box
        futur_box_pos_x2: .res 1

        ; Variable: futur_box_pos_y2
        ;----------------
        ; wanted bot right y position for the player bounding box
        futur_box_pos_y2: .res 1

        ; state variable use for dialog box animation
        ;
        ; ---Text
        ; clear each frame (except bit 1)
        ; bit 0 = Set if animation just happened
        ; bit 1 = Set if end of animation reached
        ; bit 2 = Set if x animation just happened
        ; ---
        dialogbox_anim_flag: .res 1

    ;================
    ; Group: ZP - Player variables
    ;================

        ; Variable: player_subx
        ;----------------
        ; sub-pixel part of the X position of the player
        player_subx: .res 1

        ; Variable: player_x
        ;----------------
        ; X position of the player
        player_x: .res 1

        ; Variable: player_suby
        ;----------------
        ; sub-pixel part of the Y position of the player
        player_suby: .res 1

        ; Variable: player_y
        ;----------------
        ; Y position of the player
        player_y: .res 1

        ; Variable: player_y_spd
        ;----------------
        ; Player Y speed when having a blue soul type
        player_y_spd: .res 1

        ; Variable: player_y_spd
        ;----------------
        ; Player Y speed direction (+=UP, -=DOWN) when having a blue soul type
        player_y_spd_dir: .res 1

        ; Variable: player_bound_x1
        ;----------------
        ; Top left X position of the player bounding box
        player_bound_x1: .res 1

        ; Variable: player_bound_y1
        ;----------------
        ; Top left X position of the player bounding box
        player_bound_y1: .res 1

        ; Variable: player_bound_x2
        ;----------------
        ; Bottom right position of the player bounding box
        player_bound_x2: .res 1

        ; Variable: player_bound_y2
        ;----------------
        ; Bottom right position of the player bounding box
        player_bound_y2: .res 1

        ; Variable: player_soul
        ;----------------
        ; The player soul type determine the type of movement the player can make
        player_soul: .res 1

        ; Variable: player_stats
        ;----------------
        ; Structure containing player stats (hp, atk, def, ...).
        ; see <PlayerStat>
        player_stats: .tag PlayerStat

        ; Variable: player_flag
        ;----------------
        ; flags related to the player
        ;
        ; ---Text
        ; .... ..PH
        ;        |+-- draw HP
        ;        +--- draw player
        ; ---
        player_flag: .res 1

        ; Variable: player_inv
        ;----------------
        ; player inventory
        player_inv: .res INV_SIZE

    ;================
    ; Group: ZP - Monster
    ;================

        ; Variable: monster_stats
        ;----------------
        ; List of 3 list of size MONSTER_VAR_SIZE.
        ; Use by monsters scripts.
        monster_vars:
        monster_0_var: .res MONSTER_VAR_SIZE
        monster_1_var: .res MONSTER_VAR_SIZE
        monster_2_var: .res MONSTER_VAR_SIZE


;****************
; STACK SEGMENT
;****************
.segment "STACK"
    ; Variable: str_buf
    ;----------------
    ; Buffer containing the current text to print in dialog boxes.
    ; /!\ located inside stack /!\
    str_buf:

;****************
; OAM SEGMENT
;****************
.segment "OAM"
OAM:


;****************
; BSS SEGMENT
;****************
.segment "BSS"
    ;================
    ; Group: Dialog structures
    ;================
        ; str_buf: .res 128

        ; Variable: dialog_boxs
        ;----------------
        ; list of <DialogBox>
        dialog_boxs: .res .sizeof(DialogBox)*MAX_DIALOGBOX

    ;================
    ; Group: Monster
    ;================

        ; Variable: monster_stats
        ;----------------
        ; List of 3 <MonsterStat> structure.
        monster_stats:
        monster_0: .tag MonsterStat
        monster_1: .tag MonsterStat
        monster_2: .tag MonsterStat

        ; monster_vars in ZP

        ; Variable: monster_act_str
        ;----------------
        ; List of 3 monster ACT menu strings
        monster_act_str:
        monster_0_act_str: .res MAX_MENU*16
        monster_1_act_str: .res MAX_MENU*16
        monster_2_act_str: .res MAX_MENU*16

        ; Variable: monster_names
        ;----------------
        ; List of 3 monster names.
        monster_names:
        monster_0_name: .res 8
        monster_1_name: .res 8
        monster_2_name: .res 8

        ; Variable: n_monster
        ;----------------
        ; Number of monsters.
        n_monster: .res 1

        ; Variable: fight_id
        ;----------------
        ; ID of the current fight.
        fight_id: .res 1

        ; Variable: cur_monster_fight_pos
        ;----------------
        ; current position in the fight of the monster being process.
        cur_monster_fight_pos: .res 1

        ; Variable: monster_flags
        ;----------------
        ; List of 3 monster flags.
        ; --- txt
        ; .......S
        ;        +-- can be Spare
        ; ---
        monster_flags:
        monster_0_flag: .res 1
        monster_1_flag: .res 1
        monster_2_flag: .res 1

        ; Variable: monster_ids
        ;----------------
        ; List of 3 monster ids.
        monster_ids:
        monster_0_id: .res 1
        monster_1_id: .res 1
        monster_2_id: .res 1

        ; Variable: monster_events
        ;----------------
        ; List of 3 monster 'interrupt' events.
        monster_events:
        monster_0_event: .res 1
        monster_1_event: .res 1
        monster_2_event: .res 1

        ; Variable: monster_last_events
        ;----------------
        ; List of 3 monster 'interrupt' last events.
        monster_last_events:
        monster_0_last_event: .res 1
        monster_1_last_event: .res 1
        monster_2_last_event: .res 1


        ; Variable: monster_act_str_size
        ;----------------
        ; 'size' of lists in monster_act_str
        monster_act_str_size:
        monster_0_act_str_size: .res 1
        monster_1_act_str_size: .res 1
        monster_2_act_str_size: .res 1

    ;================
    ; Group: Menu
    ;================

        menu_stack_idx: .res 1
        menu_curadr: .res 2
        menu_stack_lo: .res 4
        menu_stack_hi: .res 4

        menu_dialog_lo: .res 1
        menu_dialog_hi: .res 1
        menu_dialog_bnk: .res 1
        menu_dialog_flag: .res 1

        menu_idx: .res 1
        menu_size: .res 1
        menu_list_lo: .res MAX_MENU
        menu_list_hi: .res MAX_MENU
        menu_list_pos_x: .res MAX_MENU
        menu_list_pos_y: .res MAX_MENU
        menu_list_str: .res MAX_MENU*16


;****************
; MMC5 SEGMENT
;****************
.segment "MMC5_RAM"
    ; Variable: seed
    ;----------------
    ; saved seed from <rng>
    ; to be able to have a different seed each time the game boot.
    saved_seed: .res 2

    packet_buffer_end: .res 2

    packet_buffer_counter: .res 2

    .res 250

    ;================
    ; Group: Sprites
    ;================

        spr_buf_x:    .res MAX_SPR
        spr_buf_atr:  .res MAX_SPR
        spr_buf_idx:  .res MAX_SPR
        spr_buf_y:    .res MAX_SPR
        spr_buf_anim: .res MAX_SPR ; 0 = unused, val-1 = anim idx

        ; padding
        .res MAX_SPR*3

    ;================
    ; Group: Animation
    ;================

        ; Variable: anims_delay
        ;----------------
        anims_delay:   .res MAX_ANIM
        ; Variable: anims_flag
        ;----------------
        ; ---Text
        ; 76543210
        ; ||    ++-- monster fight pos
        ; |+-------- is sprite
        ; +--------- anim set/use
        ; ---
        anims_flag:    .res MAX_ANIM
        ; Variable: anims_next_lo
        ;----------------
        anims_next_lo: .res MAX_ANIM
        ; Variable: anims_next_hi
        ;----------------
        anims_next_hi: .res MAX_ANIM
        ; Variable: anims_x
        ;----------------
        anims_x:       .res MAX_ANIM
        ; Variable: anims_y
        ;----------------
        anims_y:       .res MAX_ANIM
        ; Variable: anims_type
        ;----------------
        anims_type:    .res MAX_ANIM

        ; padding
        .res MAX_ANIM

    ;================
    ; Group: Hitboxes
    ;================
        hitbox_t :.res MAX_HITBOX
        hitbox_x :.res MAX_HITBOX
        hitbox_y :.res MAX_HITBOX
        hitbox_w :.res MAX_HITBOX
        hitbox_h :.res MAX_HITBOX
        hitbox_a :.res MAX_HITBOX

        ; padding
        .res MAX_HITBOX*2

    img_buf: .res 512

    packet_buffer: .res 2048
