GAME_INIT:
    JSR disableNMI

    ;Set vars
	JSR MATCH_SET
	
	;Set sprites
	LDX #$00
SpriteGameLoop:
	LDA sprites, X
	STA $0200, X
	INX
	CPX #$4C
	BNE SpriteGameLoop

	;Set bg
	LDA $2002
	LDA #$20
	STA $2006
	LDA #$00
	STA $2006

	;Top empty space
	LDA #$00
	LDX #$00
BGEmptyLoop:
	STA $2007
	INC param1
	INX
	CPX #$40
	BNE BGEmptyLoop
	STA param1

	;Header
	LDX #$00
BGHeaderLoop:
	LDA game_header, X
	STA $2007
	INX
	CPX #$40
	BNE BGHeaderLoop

	;Bars
	LDY #$04
BGLoop1:
	LDX #$00
BGLoop2:

	TXA
	AND #$0F
	CMP #$02
	BEQ BG1
	CMP #$0D
	BEQ BG1

	LDA #$00
	JMP STBG
BG1:
	LDA #$02
	JMP STBG

STBG:
	STA $2007
	INX
	CPX #$20
	BNE BGLoop2
	INY
	CPY #$1E
	BNE BGLoop1

	;set attribute table
	LDX #$00
AttrLoop:
	TXA
	CMP #$08
	BCS Attr1
	LDA #$00
	JMP AttrFin
Attr1:
	AND #$04
	BNE Attr2
	LDA #%01010101
	JMP AttrFin

Attr2:
	LDA #%10101010
AttrFin:
	STA $2007
	INX
	CPX #$00
	BNE AttrLoop

    JSR enableNMI
    RTS

    ;Setup vars before match or after scoring
MATCH_SET:
	LDA sprites
	STA by
	STA bx
	LDA #$03
	STA bhor
	LDA #$00
	STA bvert
	LDA #$70
	STA y1
	STA y2
CHECK_PWIN:
	LDA $0231
	CMP #'5'
	BNE CHECK_CWIN
	JSR WIN_INIT
CHECK_CWIN:
	LDA $0235
	CMP #'5'
	BNE END_MATCH_SET
	JSR LOSE_INIT
END_MATCH_SET:
	RTS