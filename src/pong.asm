;Settings
	.inesprg 1	;use 1 16KB PRG block
	.ineschr 1	;use 1 8KB CHR block
	.inesmap 0	;mapper 0 (no bank swapping) 
	.inesmir 1	;bg mirroring
	
	.include "data.asm"

;Vars
    .rsset $0000 ;start vars @ beginning of RAM

param1 .rs 1

controller .rs 1
pause .rs 1
start_held .rs 1
state .rs 1
    
bx .rs 1
by .rs 1
bvert .rs 1	;FF if up, 1 if down
bhor .rs 1 ;FF if left, 1 if right

y1 .rs 1
y2 .rs 1

;CONSTANTS
TOP_BOUND = $1C
BOTTOM_BOUND = $D4
LEFT_BOUND = $1C
RIGHT_BOUND = $D8

PADDLE_SPEED = $02

;Program
    .bank 0
    .org $C000

    .include "reset.asm"
	.include "init.asm"
	.include "game_init.asm"
	.include "controller.asm"
	.include "game.asm"
	.include "win_lose.asm"

;Main loop
NMI:
;write sprites
	LDA #$00
	STA $2003
	LDA #$02
	STA $4014

	JSR INPUT

;Run game state
GAME:
	LDA state
	CMP #$01
	BNE MSG
	JSR PAUSE_INPUT
	LDA pause
	BNE PAUSE
	;main game screen - state 1
	JSR GAME_LOOP
	RTI
;Run non-game (message) states (0 = title, 2 = win, 3 = lose)
MSG:
	JSR SCR_INPUT
PAUSE:
	RTI ;return from interrupt
