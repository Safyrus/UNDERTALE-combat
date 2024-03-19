;################
; File: Constants
;################
; List all constants

;================
; Group: PPU
;================

    ; Constants: PPU registers
    ;
    ; PPU_CTRL   - _$2000_ PPU Control register address
    ; PPU_MASK   - _$2001_ PPU Mask register address
    ; PPU_STATUS - _$2002_ PPU Status register address
    ; PPU_SCROLL - _$2005_ PPU Scroll register address
    ; PPU_ADDR   - _$2006_ PPU Addr register address
    ; PPU_DATA   - _$2007_ PPU Data register address
    ; OAMDMA     - _$4014_ OAM DMA register address
    PPU_CTRL   := $2000
    PPU_MASK   := $2001
    PPU_STATUS := $2002
    PPU_SCROLL := $2005
    PPU_ADDR   := $2006
    PPU_DATA   := $2007
    OAMDMA := $4014

    ; Constants: PPU Mask register flags
    ;
    ; PPU_MASK_GREY - _%00000001_ Render as grayscale
    ; PPU_MASK_BKG8 - _%00000010_ Display background in leftmost 8 pixels
    ; PPU_MASK_SPR8 - _%00000100_ Display sprites in leftmost 8 pixels
    ; PPU_MASK_BKG  - _%00001000_ Display background
    ; PPU_MASK_SPR  - _%00010000_ Display sprites
    ; PPU_MASK_R    - _%00100000_ Emphasize red
    ; PPU_MASK_G    - _%01000000_ Emphasize green
    ; PPU_MASK_B    - _%10000000_ Emphasize blue
    PPU_MASK_GREY = %00000001
    PPU_MASK_BKG8 = %00000010
    PPU_MASK_SPR8 = %00000100
    PPU_MASK_BKG  = %00001000
    PPU_MASK_SPR  = %00010000
    PPU_MASK_R    = %00100000
    PPU_MASK_G    = %01000000
    PPU_MASK_B    = %10000000

    ; Constants: PPU Control register flags
    ;
    ; PPU_CTRL_NM_0     - _%00000000_ PPU nametable 0 (top left)
    ; PPU_CTRL_NM_1     - _%00000001_ PPU nametable 1 (top right)
    ; PPU_CTRL_NM_2     - _%00000010_ PPU nametable 2 (bottom left)
    ; PPU_CTRL_NM_3     - _%00000011_ PPU nametable 3 (bottom right)
    ; PPU_CTRL_INC      - _%00000100_ Increment VRAM address by 32
    ; PPU_CTRL_SPR      - _%00001000_ Sprite pattern table address
    ; PPU_CTRL_BKG      - _%00010000_ Background pattern table address
    ; PPU_CTRL_SPR_SIZE - _%00100000_ 8*16 Sprite size
    ; PPU_CTRL_SEL      - _%01000000_ PPU Master/Slave select
    ; PPU_CTRL_NMI      - _%10000000_ Generate an NMI at the start of the Vblank
    PPU_CTRL_NM_0     = %00000000
    PPU_CTRL_NM_1     = %00000001
    PPU_CTRL_NM_2     = %00000010
    PPU_CTRL_NM_3     = %00000011
    PPU_CTRL_INC      = %00000100
    PPU_CTRL_SPR      = %00001000
    PPU_CTRL_BKG      = %00010000
    PPU_CTRL_SPR_SIZE = %00100000
    PPU_CTRL_SEL      = %01000000
    PPU_CTRL_NMI      = %10000000

    ; Constants: PPU Nametable addresses
    ;
    ; PPU_NAMETABLE_0 - _$2000_
    ; PPU_NAMETABLE_1 - _$2400_
    ; PPU_NAMETABLE_2 - _$2800_
    ; PPU_NAMETABLE_3 - _$2C00_
    PPU_NAMETABLE_0 := $2000
    PPU_NAMETABLE_1 := $2400
    PPU_NAMETABLE_2 := $2800
    PPU_NAMETABLE_3 := $2C00



;================
; Group: APU
;================

    ; Constant: APU start address
    ; _$4000_
    APU := $4000

    ; Constants: APU square 1 channel registers
    ;
    ; APU_SQ1_VOL   - _$4000_
    ; APU_SQ1_SWEEP - _$4001_
    ; APU_SQ1_LO    - _$4002_
    ; APU_SQ1_HI    - _$4003_
    APU_SQ1_VOL   := $4000
    APU_SQ1_SWEEP := $4001
    APU_SQ1_LO    := $4002
    APU_SQ1_HI    := $4003

    ; Constants: APU square 2 channel registers
    ;
    ; APU_SQ2_VOL   - _$4004_
    ; APU_SQ2_SWEEP - _$4005_
    ; APU_SQ2_LO    - _$4006_
    ; APU_SQ2_HI    - _$4007_
    APU_SQ2_VOL   := $4004
    APU_SQ2_SWEEP := $4005
    APU_SQ2_LO    := $4006
    APU_SQ2_HI    := $4007

    ; Constants: APU triangle channel registers
    ;
    ; APU_TRI_LINEAR - _$4008_
    ; APU_TRI_LO     - _$400A_
    ; APU_TRI_HI     - _$400B_
    APU_TRI_LINEAR := $4008
    APU_TRI_LO     := $400A
    APU_TRI_HI     := $400B

    ; Constants: APU noise channel registers
    ;
    APU_NOISE_VOL := $400C
    APU_NOISE_LO  := $400E
    APU_NOISE_HI  := $400F

    ; Constants: APU DPCM channel registers
    ;
    APU_DMC_FREQ  := $4010
    APU_DMC_RAW   := $4011
    APU_DMC_START := $4012
    APU_DMC_LEN   := $4013

    ; Constants: APU other registers
    ;
    ; APU_SND_CHN - _$4015_
    ; APU_CTRL    - _$4015_
    ; APU_STATUS  - _$4015_
    ; APU_FRAME   - _$4017_
    APU_SND_CHN := $4015
    APU_CTRL    := $4015
    APU_STATUS  := $4015
    APU_FRAME   := $4017


;================
; Group: IO
;================

    ; Constants: Joypad registers
    ;
    ; IO_JOY1 - _$4016_ Joypad 1 address
    ; IO_JOY2 - _$4017_ Joypad 2 address
    IO_JOY1 := $4016
    IO_JOY2 := $4017

    ; Constants: Button masks
    ; See <buttons_1> variable
    ;
    ; BTN_A      - _%10000000_
    ; BTN_B      - _%01000000_
    ; BTN_SELECT - _%00100000_
    ; BTN_START  - _%00010000_
    ; BTN_UP     - _%00001000_
    ; BTN_DOWN   - _%00000100_
    ; BTN_LEFT   - _%00000010_
    ; BTN_RIGHT  - _%00000001_
    BTN_A      = %10000000
    BTN_B      = %01000000
    BTN_SELECT = %00100000
    BTN_START  = %00010000
    BTN_UP     = %00001000
    BTN_DOWN   = %00000100
    BTN_LEFT   = %00000010
    BTN_RIGHT  = %00000001


;================
; Group: NMI
;================

    ; Constants: NMI vector control flags
    ;
    ; NMI_DONE  - _%10000000_ Signal that NMI has finish. Flag must be clear before another frame is process
    ; NMI_FORCE - _%01000000_ Force NMI acknowledge
    ; NMI_SCRL  - _%00010000_ Send scroll data
    ; NMI_PLT   - _%00001000_ Send palette data
    ; NMI_ATR   - _%00000100_ Send Nametables attributes data
    ; NMI_SPR   - _%00000010_ Send sprites data
    ; NMI_BKG   - _%00000001_ Send background data
    NMI_DONE  = %10000000
    NMI_FORCE = %01000000
    NMI_SCRL  = %00010000
    NMI_PLT   = %00001000
    NMI_ATR   = %00000100
    NMI_SPR   = %00000010
    NMI_BKG   = %00000001


;================
; Group: MMC5
;================

    ; Constant: MMC5 PRG banking mode
    ; address: _$5100_
    MMC5_PRG_MODE  := $5100

    ; Constant: MMC5 CHR banking mode
    ; address: _$5101_
    MMC5_CHR_MODE  := $5101

    ; Constants: MMC5 RAM protection registers
    ;
    ; MMC5_RAM_PRO1 - _$5102_
    ; MMC5_RAM_PRO2 - _$5103_
    MMC5_RAM_PRO1  := $5102
    MMC5_RAM_PRO2  := $5103

    ; Constant: MMC5 Extended RAM mode
    ; address: _$5104_
    MMC5_EXT_RAM   := $5104

    ; Constant: MMC5 Nametable mapping
    ; address: _$5105_
    ;
    ;--- Text
    ; 7  bit  0
    ; ---- ----
    ; DDCC BBAA
    ; |||| ||||
    ; |||| ||++- Select nametable at PPU $2000-$23FF
    ; |||| ++--- Select nametable at PPU $2400-$27FF
    ; ||++------ Select nametable at PPU $2800-$2BFF
    ; ++-------- Select nametable at PPU $2C00-$2FFF
    ;---
    MMC5_NAMETABLE := $5105

    ; Constants: MMC5 Fill nametable registers
    ;
    ; MMC5_FILL_TILE - _$5106_
    ; MMC5_FILL_COL  - _$5107_
    MMC5_FILL_TILE := $5106
    MMC5_FILL_COL  := $5107

    ; Constant: MMC5 RAM Bank
    ; address: _$5113_
    MMC5_RAM_BNK   := $5113

    ; Constants: MMC5 PRG banks control registers
    ;
    ; MMC5_PRG_BNK0  - _$5114_
    ; MMC5_PRG_BNK1  - _$5115_
    ; MMC5_PRG_BNK2  - _$5116_
    ; MMC5_PRG_BNK3  - _$5117_
    MMC5_PRG_BNK0  := $5114
    MMC5_PRG_BNK1  := $5115
    MMC5_PRG_BNK2  := $5116
    MMC5_PRG_BNK3  := $5117

    ; Constants: MMC5 CHR banks control registers
    ;
    ; MMC5_CHR_BNK0  - _$5120_
    ; MMC5_CHR_BNK1  - _$5121_
    ; MMC5_CHR_BNK2  - _$5122_
    ; MMC5_CHR_BNK3  - _$5123_
    ; MMC5_CHR_BNK4  - _$5124_
    ; MMC5_CHR_BNK5  - _$5125_
    ; MMC5_CHR_BNK6  - _$5126_
    ; MMC5_CHR_BNK7  - _$5127_
    ; MMC5_CHR_BNK8  - _$5128_
    ; MMC5_CHR_BNK9  - _$5129_
    ; MMC5_CHR_BNKA  - _$512A_
    ; MMC5_CHR_BNKB  - _$512B_
    ; MMC5_CHR_UPPER - _$5130_
    MMC5_CHR_BNK0  := $5120
    MMC5_CHR_BNK1  := $5121
    MMC5_CHR_BNK2  := $5122
    MMC5_CHR_BNK3  := $5123
    MMC5_CHR_BNK4  := $5124
    MMC5_CHR_BNK5  := $5125
    MMC5_CHR_BNK6  := $5126
    MMC5_CHR_BNK7  := $5127
    MMC5_CHR_BNK8  := $5128
    MMC5_CHR_BNK9  := $5129
    MMC5_CHR_BNKA  := $512A
    MMC5_CHR_BNKB  := $512B
    MMC5_CHR_UPPER := $5130

    ; Constants: MMC5 Vertical Split registers
    ;
    ; MMC5_SPLT_MODE - _$5200_
    ; MMC5_SPLT_SCRL - _$5201_
    ; MMC5_SPLT_BNK  - _$5202_
    MMC5_SPLT_MODE := $5200
    MMC5_SPLT_SCRL := $5201
    MMC5_SPLT_BNK  := $5202

    ; Constants: MMC5 IRQ Scanline counter
    ;
    ; MMC5_SCNL_VAL  - _$5203_
    ; MMC5_SCNL_STAT - _$5204_
    MMC5_SCNL_VAL  := $5203
    MMC5_SCNL_STAT := $5204

    ; Constants: MMC5 multiplier registers
    ;
    ; MMC5_MUL_A - _$5205_
    ; MMC5_MUL_B - _$5206_
    MMC5_MUL_A     := $5205
    MMC5_MUL_B     := $5206

    ; Constant: MMC5 Expansion RAM
    ; address: _$5C00_
    MMC5_EXP_RAM   := $5C00

    ; Constant: MMC5 RAM
    ; address: _$6000_
    MMC5_RAM       := $6000


;================
; Group: Game
;================

    ; Constant: CLEAR TILE
    ; Lower tile to use when clearing the screen
    CLEAR_TILE = $00

    ; Constant: BTN TIMER
    ; If used, number of frame before processing another input
    BTN_TIMER = $10

    ; Constant: PLAYER_SPRITE_BNK
    ; CHR 1K bank where the player sprite is located
    PLAYER_SPRITE_BNK = (4*1)+2

    ; Constant: PLAYER_SPRITE
    ; reserved sprite index for the player
    PLAYER_SPRITE := OAM+0

    ; Constant: FONT_CHR_BNK
    ; Bank index of the default font
    FONT_CHR_BNK = 0 + $80

    ; Constant: UI_CHR_BNK
    ; upper char UI tiles containing dialog box tiles
    UI_CHR_BNK = 5

    ; Constant: GRAVITY
    ; gravity acceleration applied to blue soul in sub-pixels
    GRAVITY = 8

    ; Constant: MAX_GRAVITY
    ; maximum value of the gravity speed
    MAX_GRAVITY = $FF-GRAVITY

    ; Constant: JUMP_GRAVITY
    ; gravity acceleration applied to blue soul in sub-pixels when performing a jump
    JUMP_GRAVITY = 4

    ; Constant: JUMP_FORCE
    ; speed added to y position when jumping
    JUMP_FORCE = $FF

    ; Constant: PLAYER_FLAG_DRAW_HP
    ; Flag in <player_flag> , use to indicate that the player HP on the screen must be updated.
    PLAYER_FLAG_DRAW_HP = %00000001

    ; Constant: PLAYER_FLAG_DRAW_PLAYER
    ; Flag in <player_flag> , use to indicate that a need to draw the player.
    PLAYER_FLAG_DRAW_PLAYER = %00000010

    ; Constant: FIRST_HP_TILE
    ; Upper left tile in CHR where HP bar tiles are located
    FIRST_HP_TILE = $80

    ; Constant: TEXT_BUF_BNK
    ; RAM bank index where decoded text data is located
    TEXT_BUF_BNK = $01

    ; Constant: VAR_RAM_BNK
    ; RAM bank index where saved variables are located
    VAR_RAM_BNK = $00

    MAX_ANIM = 32

    MAX_SPR = 64

    PACKET_DRAW_LIMIT = $48

    MAX_MENU = 6

    MAX_DIALOGBOX = 4

    HITMARK_TILE = $1E
    HITMARK_PLT = $00

    INV_SIZE = 6

    ITEM_NAME_SIZE = 16
    ITEM_NAME_SHIFT = 4

    FIGHT_STRICK_TIME = 15*5
    FIGHT_NUMBER_TIME = 15*5
    DMG_SPRITE_BNK = (4*0)+2

;================
; Group: Game - Soul
;================

    ; Constant: SOUL_TILE
    ; CHR tile for drawing the player soul
    SOUL_TILE = 0

    ; Constant: SOUL_TILE
    ; palette of the player soul
    SOUL_PLT = 0

    ; Enum: SOUL
    ; - MENU
    ; - RED
    ; - BLUE
    ; - FIGHT
    ; - WAIT
    ;
    ; soul type that the player can take
    .enum SOUL
        MENU
        RED
        BLUE
        FIGHT
        WAIT
    .endenum

;================
; Group: Game - Dialog box
;================

    ; Constant: DIALOG_BOX_TILE_TL
    ; Top left lower tile of the dialog box
    DIALOG_BOX_TILE_TL     = $01

    ; Constant: DIALOG_BOX_TILE_TOP
    ; Top lower tile of the dialog box
    DIALOG_BOX_TILE_TOP    = $03

    ; Constant: DIALOG_BOX_TILE_TR
    ; Top right lower tile of the dialog box
    DIALOG_BOX_TILE_TR     = $02

    ; Constant: DIALOG_BOX_TILE_LEFT
    ; Left lower tile of the dialog box
    DIALOG_BOX_TILE_LEFT   = $13

    ; Constant: DIALOG_BOX_TILE_MIDDLE
    ; Middle lower tile of the dialog box
    DIALOG_BOX_TILE_MIDDLE = $00

    ; Constant: DIALOG_BOX_TILE_RIGHT
    ; Right lower tile of the dialog box
    DIALOG_BOX_TILE_RIGHT  = $16

    ; Constant: DIALOG_BOX_TILE_BL
    ; Bottom left lower tile of the dialog box
    DIALOG_BOX_TILE_BL     = $11

    ; Constant: DIALOG_BOX_TILE_BOT
    ; Bottom lower tile of the dialog box
    DIALOG_BOX_TILE_BOT    = $06

    ; Constant: DIALOG_BOX_TILE_BR
    ; Bottom right lower tile of the dialog box
    DIALOG_BOX_TILE_BR     = $12

    ; Constant: DIALOG_BOX_ANIM_TILE_X_OFFSET
    ; starting lower tile for dialog box x animation
    DIALOG_BOX_ANIM_TILE_X_OFFSET = $13

    ; Constant: DIALOG_BOX_ANIM_TILE_Y_OFFSET
    ; starting lower tile for dialog box y animation
    DIALOG_BOX_ANIM_TILE_Y_OFFSET = $03

    ; Constant: DIALOG_BOX_SPRITE_TILE
    ; lower tile for the dialog box corner sprite
    DIALOG_BOX_SPRITE_TILE = $0E

;================
; Group: Game - Char
;================

    ; Enum: CHAR
    ; END - END of dialog
    ; LB  - Line Break
    ; DB  - Dialog Break
    ; FDB - Force Dialog Break
    ; TD  - Toggle Dialog Box display
    ; SET - Set flag
    ; CLR - Clear flag
    ; SAK - ShAKe
    ; SPD - SPeeD
    ; DL  - DeLay
    ; NAM - change NAMe of dialog box
    ; FLH - FLasH
    ; FAD - FADe in/out
    ; SAV - Save the current text location
    ; COL - change text COLor
    ; RET - Return to the previous saved location
    ; BIP - change dialog BIP effect
    ; MUS - MUSic
    ; SND - SouND effect
    ; PHT - show PHoto
    ; CHR - CHaRacter to show
    ; ANI - character ANImation
    ; BKG - change BacKGround
    ; FNT - Change FoNT to use
    ; JMP - JuMP to another dialog
    ; ACT - jump to the selected choice (depending on the player ACTion)
    ; BP  - Background Palette
    ; SP  - Sprite Palette
    ; POS - create new dialog box at POSition
    ; SPA - change amount of space to add after LB
    ; EVT - EVenT. Use to add control characters specific to the game
    ; EXT - EXTension. Reserved to add more ctrl char to the dialog box
    .enum CHAR
        END ; END of dialog
        LB  ; Line Break
        DB  ; Dialog Break
        FDB ; Force Dialog Break
        TD  ; Toggle Dialog Box display
        SET ; Set flag
        CLR ; Clear flag
        SAK ; ShAKe
        SPD ; SPeeD
        DL  ; DeLay
        NAM ; change NAMe of dialog box
        FLH ; FLasH
        FAD ; FADe in/out
        SAV ; Save the current text location
        COL ; change text COLor
        RET ; Return to the previous saved location
        BIP ; change dialog BIP effect
        MUS ; MUSic
        SND ; SouND effect
        PHT ; show PHoto
        CHR ; CHaRacter to show
        ANI ; character ANImation
        BKG ; change BacKGround
        FNT ; Change FoNT to use
        JMP ; JuMP to another dialog
        ACT ; jump to the selected choice (depending on the player ACTion)
        BP  ; Background Palette
        SP  ; Sprite Palette
        POS ; create new dialog box at POSition
        SPA ; change amount of space to add after LB
        EVT ; EVenT. Use to add control characters specific to the game
        EXT ; EXTension. Reserved to add more ctrl char to the dialog box
    .endenum

;================
; Group: Game - Monster
;================

    ; Constant: MONSTER_VAR_SIZE
    ; size of the monster variable array
    MONSTER_VAR_SIZE = 8

    ; Enum: EVENT
    ; NONE - no event
    ; START - event called when the fight start
    ; TURN - event called when its the monster turn
    ; CUSTOM - custom event
    ; HIT - event called when the monster was hit
    ; ACT - event called when the monster was act
    ; ITEM - event called when the player use an item
    ; SPARE - event called when the monster was spare
    ; FLEE - event called when the player try to flee
    .enum EVENT
        NONE
        START
        TURN
        CUSTOM
        HIT
        ACT
        ITEM
        SPARE
        FLEE
    .endenum

    ; Constant: MONSTER_IMG_BNK
    ; Bank index where <monster_img_data> is located
    MONSTER_IMG_BNK = <.bank(monster_img_data) + $80

    ; Constant: MONSTER_CODE_BNK_BNK
    ; Bank index where <monster_code_bnk> is located
    MONSTER_CODE_BNK_BNK = <.bank(monster_code_bnk) + $80

    ; Constant: MONSTER_CODE_STRUCT_BNK
    ; Bank index where <monster_code_struct> is located
    MONSTER_CODE_STRUCT_BNK = <.bank(monster_code_struct) + $80

    ; Constant: MONSTER_CODE_START_BNK
    ; First bank index where monster code is located
    MONSTER_CODE_START_BNK = <.bank(monster_code_data) + $80

    ; Constant: MONSTER_STAT_BNK
    ; Bank index where <monster_stats_data> is located
    MONSTER_STAT_BNK = <.bank(monster_stats_data) + $80

    ; Constant: MONSTER_NAME_BNK
    ; Bank index where <monster_names_data> is located
    MONSTER_NAME_BNK = <.bank(monster_names_data) + $80

    ; Constant: FIGHT_BNK
    ; Bank index where <fights> is located
    FIGHT_BNK = <.bank(fights) + $80

    ; Constant: FIGHT_FLAG_N_MONSTER
    ; Flag for the number of monster (0 to 3)
    FIGHT_FLAG_N_MONSTER = %00000011

    MONSTER_ANIM_BNK = $88

    MONSTER_FLAG_SPARE = $01


;================
; Group: Hitbox
;================

    MAX_HITBOX = 32

    .enum HITBOX
        NONE
        FOLLOW_DIAMOND
    .endenum
