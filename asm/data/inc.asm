.include "img_bkg_const.asm"
.include "img_bkg_cl_const.asm"
.include "img_spr_const.asm"
.include "anim_const.asm"
.include "txt_const.asm"

.include "txt_data.asm"
.include "anim_data.asm"
.include "code_data.asm"
.include "fights.asm"
.include "monster_code.asm"
.include "monster_names.asm"
.include "monster_stats.asm"
.include "items_name.asm"
.include "items_code.asm"

.segment "MONSTER_IMG_DATA"

monster_img_data:
.incbin "img_bkg.bin"
.incbin "img_bkg_cl.bin"
.incbin "img_spr.bin"
