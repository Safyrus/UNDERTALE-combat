; TODO: change to have monster capable of using multiple CHR banks
get_monster_chr_bnk_offset:
    LDA cur_monster_fight_pos
    TAX
    INX
    RTS
