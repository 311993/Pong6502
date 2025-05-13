GAME_LOOP:
    ;Update player paddle pose
	JSR GAME_INPUT

	;Update computer paddle pos
	LDA y2
	CMP by
	BEQ BallUpdate
	BMI PADDLE_UP
	SEC
	SBC #PADDLE_SPEED
	STA y2
	JMP BallUpdate
PADDLE_UP:
	CLC
	ADC #PADDLE_SPEED
	STA y2


	;update ball pose
BallUpdate:

	;vertical movement
	LDA by
	CLC
	ADC bvert
	STA by

	;horizontal movement
	LDA bx
	CLC
	ADC bhor
	STA bx

;collision w/ walls
BALL_VERT:
	LDA by
	ADC #$FF - BOTTOM_BOUND
	ADC #BOTTOM_BOUND - TOP_BOUND + 1
	BCS PADDLE_COL
	LDA #$81
	STA $4003 ;play boop
	LDA bvert
	EOR #$FF
	ADC #$01
	STA bvert

;collision w/ paddles
PADDLE_COL:

;Player paddle bounds
PLAYER_COL:
	LDA bx
	CMP #LEFT_BOUND
	BCS COMP_COL
	LDA by
	ADC #$10
	CMP y1
	BCC COMP_COL
	SBC #$30
	CMP y1
	BCS COMP_COL

	LDX #LEFT_BOUND - $02
	STX bx

;Sweet spot in middle of paddle speeds ball up vertically
SWEET_COL:
	ADC #$1B
	CMP y1
	BCC H_COL
	SBC #$0A
	CMP y1
	BCS H_COL
	LDA bvert
	CMP #$80
	BCS SWEET2
	ADC #$01
	JMP H_COL
SWEET2:
	CLC
	ADC #$FF
	STA bvert
	JMP H_COL

;Computer paddle bounds
COMP_COL:
	LDA bx
	CMP #RIGHT_BOUND
	BCC END_COL
	LDA by
	ADC #$10
	CMP y2
	BCC END_COL
	SBC #$30
	CMP y2
	BCS	END_COL

;Do horizontal collision
H_COL:
	LDA #$82
	STA $4003 ;play boop
	LDA bhor
	EOR #$FF
	CLC
	ADC #$01
	STA bhor

	LDA bvert
	CMP #$00
	BNE END_COL
	LDA #$01
	STA bvert

;Check score bounds
END_COL:
	LDA bx
	CMP #$0E
	BCS END_COL2
	LDA #$C3
	STA $4003 ;play low
	INC $0235
	JSR MATCH_SET
	RTS

END_COL2:
	LDA bx
	CMP #$E2
	BCC NO_COL
	LDA #$C0
	STA $4003 ;play high
	INC $0231
	JSR MATCH_SET
	RTS

NO_COL:

	;update ball sprite poses
	LDX #$00
BallUpdateLoop:
	LDA by
	CLC
	ADC offsets, X
	STA $0200, X
	INX
	INX
	INX

	LDA bx
	CLC
	ADC offsets, X
	STA $0200, X
	INX
	CPX #$10
	BNE BallUpdateLoop

	;update paddle sprite poses
	LDA #$00
PaddleUpdateLoop:
	TAX

	CPX #$10
	BPL Paddle2
	ASL A
	CLC
	ADC y1
	JMP Paddle1
Paddle2:
	AND #$0F
	ASL A
	CLC
	ADC y2
Paddle1:
	STA $0210, X 
	
	TXA
	CLC
	ADC #$04 
	CMP #$20
	BNE PaddleUpdateLoop

    RTS ;return from subroutine
