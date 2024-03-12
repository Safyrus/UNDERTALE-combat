;--------------------------------
; Subroutine: rng
;--------------------------------
;
; From: https://www.nesdev.org/wiki/Random_number_generator
;
; Returns a random 8-bit number in A (0-255), clobbers Y (0).
;
; Requires a 2-byte value on the zero page called "seed".
; Initialize seed to any value except 0 before the first call to rng.
; (A seed value of 0 will cause rng to always return 0.)
;
; This is a 16-bit Galois linear feedback shift register with polynomial $0039.
; The sequence of numbers it generates will repeat after 65535 calls.
;
; Execution time is an average of 125 cycles (excluding jsr and rts)

rng:
	LDY #8     ; iteration count (generates 8 bits)
	LDA seed+0
:
	ASL        ; shift the register
	ROL seed+1
	BCC :+
	EOR #$39   ; apply XOR feedback whenever a 1 bit is shifted out
:
	DEY
	BNE :--
	STA seed+0
	CMP #0     ; reload flags
	RTS