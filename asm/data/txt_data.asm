
; This file was generated


.segment "TXT_BNK"
text_data:
.incbin "asm/data/txt.bin"

.segment "LAST_BNK"
;--------------------------------
; Array: lz_bnk_table
;--------------------------------
;
; LUT from lz index to lz block ROM bank index.
;--------------------------------
lz_bnk_table:
    .byte <.bank(text_data) + $80 + $00


;--------------------------------
; Array: lz_bnk_table
;--------------------------------
;
; LUT from lz index to lz block starting address (low byte).
;--------------------------------
lz_adr_table_lo:
    .byte $00


;--------------------------------
; Array: lz_bnk_table
;--------------------------------
;
; LUT from lz index to lz block starting address (high byte).
;--------------------------------
lz_adr_table_hi:
    .byte $A0
