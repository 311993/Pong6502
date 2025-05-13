;Reset Routine
RESET:
	SEI ;disable IRQ
	CLD	;disable decimal

	LDX #$40
	STX $4017 ;disable APU frame IRQ
	LDX #$00
	STX $2000 ;disable NMI + render
	STX $2001
	STX $4010 ;disable DMC IRQ

	LDX #$FF  ;Setup stack
	TXS

    JSR VBLANKWAIT  ;wait for ppu

MEM_RESET:
	LDA #$00 ;clear RAM 0x0000 - 0x0800
	STA $0000, X
	STA $0100, X
	STA $0200, X
	STA $0400, X
	STA $0500, X
	STA $0600, X
	STA $0700, X
	LDA #$FE
	STA $0300, X

	INX	;Continue to next mem segment 
	BNE MEM_RESET

    JSR VBLANKWAIT  ;wait for ppu

	JMP INIT ;Start main program

VBLANKWAIT: ;wait for ppu to be ready
	BIT $2002
	BPL VBLANKWAIT
    RTS