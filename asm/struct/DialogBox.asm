;--------------------------------
; Struct: DialogBox
;
; xpos - *byte* : text x pos
; ypos - *byte* : text y pos
; ptr  - *byte* : pointer to current text
; font - *byte* : font to use
; wait - *byte* : wait for x frame
; spd  - *byte* : speed
; bip  - *byte* : bip sound
; spa  - *byte* : line spacing
; xstart - *byte* : starting x position
; ystart - *byte* : starting y position
; flags - *byte* : 
;   ---Text
;   .......I
;          +-- waiting for Input
;   ---
; xoff - *byte*: maximum x offset reached (width=xoff-xstart)
;
; size: 16 bytes
;--------------------------------
.struct DialogBox
    xpos .byte ; text x pos
    ypos .byte ; text y pos
    ptr  .byte ; pointer to current text
    font .byte ; font to use
    wait .byte ; wait for x frame
    spd  .byte ; speed
    bip  .byte ; bip sound
    spa  .byte ; line spacing
    xstart .byte ; starting x position
    ystart .byte ; starting y position
    flags .byte ; flags (.......I)
    xoff .byte ; maximum x offset reached (width=xoff-xstart)
    .res 4
.endstruct

; Constant: DIALOGBOX_SIZE
; size of struct <DialogBox> in power of 2
DIALOGBOX_SIZE = 4

; Constants: Default DialobBox values
; DEFAULT_X - $02
; DEFAULT_Y - $11
; DEFAULT_FONT - 0
; DEFAULT_WAIT - 0
; DEFAULT_SPD - 4
; DEFAULT_BIP - 0
; DEFAULT_SPACING - 2
DEFAULT_X = $02
DEFAULT_Y = $11
DEFAULT_FONT = $80
DEFAULT_WAIT = 0
DEFAULT_SPD = 4
DEFAULT_BIP = 0
DEFAULT_SPACING = 2

DIALOGBOX_FLAG_INPUT = %00000001
