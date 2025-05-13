;Called when first starting the game - initializes graphics + sets title screen
INIT:
	;start APU
	LDA #%00000001
	STA $4015
	LDA #%10011111
	STA $4000
	LDA #$FB
	STA $4002
	LDA #$01
	STA $4003

    ;set palettes
	LDA $2002
	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006

	LDX #$00
PalSetLoop:
	LDA palettes, X
	STA $2007
	INX
	CPX #$20
	BNE PalSetLoop

	JSR GEN_INIT

	;Set title sprites
	LDX #$00
SpriteStartLoop:
	LDA start_sprites, X
	STA $0200, X
	INX
	CPX #$10
	BNE SpriteStartLoop

	JSR enableNMI

await:
    JMP await ;wait for NMI

;run before bg changes
disableNMI:
	LDA #$00
	STA $2000
	LDA #$00
	STA $2001
	RTS

;run after bg changes
enableNMI:
	LDA #%10000000
	LDX state
	BNE do8sprites
	ORA #%00100000
do8sprites:
	STA $2000
	LDA #%00011110
	STA $2001
	RTS

;Sets bg for non-game states
GEN_INIT:
	;Set bg
	LDA $2002
	LDA #$20
	STA $2006
	LDA #$00
	STA $2006

	LDY #$00
BGStartLoop1:
	LDX #$00
BGStartLoop2:
	LDA #$00
	CPY #$12
	BNE BGStartEmpty
	LDA subtitle,X
BGStartEmpty:
	STA $2007
	INX
	CPX #$20
	BNE BGStartLoop2
	INY
	CPY #$3C
	BNE BGStartLoop1

	RTS
