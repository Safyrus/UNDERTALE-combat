; offset from dmg_sprites
table_dmg_sprite:
.byte dmg_sprite_0 - dmg_sprites
.byte dmg_sprite_1 - dmg_sprites
.byte dmg_sprite_2 - dmg_sprites
.byte dmg_sprite_3 - dmg_sprites
.byte dmg_sprite_4 - dmg_sprites
.byte dmg_sprite_5 - dmg_sprites
.byte dmg_sprite_6 - dmg_sprites
.byte dmg_sprite_7 - dmg_sprites
.byte dmg_sprite_8 - dmg_sprites
.byte dmg_sprite_9 - dmg_sprites
.byte dmg_sprite_miss - dmg_sprites
.byte dmg_sprite_end - dmg_sprites


; sprite data (.byte tile, atr)
dmg_sprites:
dmg_sprite_0:
.byte $08, $01
.byte $08, $41
dmg_sprite_1:
.byte $0A, $01
dmg_sprite_2:
.byte $0C, $01
.byte $0C, $C1
dmg_sprite_3:
.byte $0E, $01
.byte $1C, $41
dmg_sprite_4:
.byte $18, $01
.byte $1A, $01
dmg_sprite_5:
.byte $0C, $81
.byte $0C, $41
dmg_sprite_6:
.byte $1C, $01
.byte $0C, $41
dmg_sprite_7:
.byte $1E, $01
.byte $28, $01
dmg_sprite_8:
.byte $1C, $01
.byte $1C, $41
dmg_sprite_9:
.byte $0C, $81
.byte $1C, $C1
dmg_sprite_miss:
.byte $2A, $01 ; M
.byte $2A, $41
.byte $2C, $01 ; I
.byte $2E, $01 ; S
.byte $2E, $C1
.byte $2E, $01 ; S
.byte $2E, $C1
dmg_sprite_end:
