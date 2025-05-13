;Parallelize + store controller inputs
INPUT:
	;check if start held
	LDA controller
	AND #%00010000
	STA start_held

    ;query controller
	LDA #$01
	STA $4016
	LDA #$00
	STA $4016

	;Store buttons
	LDX #$00
READ_CONTROLLER_LINE:
	LDA $4016
	AND #$01
	ASL controller
	ORA controller
	STA controller
	INX
	CPX #$08
	BNE READ_CONTROLLER_LINE
	RTS

;Game screen input
GAME_INPUT:

UP:
	LDA controller
	AND #%00001000
	BEQ DOWN
	LDA y1
	SEC
	SBC #PADDLE_SPEED
	STA y1

DOWN:
	LDA controller
	AND #%00000100
    BEQ FINISH_INP
	LDA y1
    CLC
    ADC #PADDLE_SPEED
	STA y1

FINISH_INP:
    RTS

;Manage pause w/ start button
PAUSE_INPUT:
	LDA controller
	AND #%00010000
	BEQ END_PAUSE_INP
	LDA start_held
	BNE END_PAUSE_INP
	LDA pause
	EOR #$01
	STA pause
	
	;set/clear pause msg
	LDX #$0
PAUSE_LOOP:
	TXA
	ASL A
	ASL A
	TAY

	LDA $0239, Y
	EOR pause_msg, X
	STA $0239, Y

	INX
	CPX #$05
	BNE PAUSE_LOOP

END_PAUSE_INP:
	RTS

;change screen on start press
SCR_INPUT:
	LDA controller
	AND #%00010000
	BEQ END_SCR_INP
	LDA #$01
	STA state
	JSR GAME_INIT
END_SCR_INP:
	RTS