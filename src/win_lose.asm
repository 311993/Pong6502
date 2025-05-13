;set up player win screen
WIN_INIT:
    JSR disableNMI
    JSR GEN_INIT
    LDA #02
    STA state
    JSR CLEAR_SPRITES

    ;display win msg
    LDX #$00
WIN_LOOP:
    LDA win_msg, x
    STA $0200, X
    INX
    CPX #$20
    BNE WIN_LOOP

    JSR enableNMI
    RTS

;set up computer win / player lose screen
LOSE_INIT:
    JSR disableNMI
    JSR GEN_INIT
    LDA #02
    STA state
    JSR CLEAR_SPRITES

    ;display lose msg
    LDX #$00
LOSE_LOOP:
    LDA lose_msg, x
    STA $0200, X
    INX
    CPX #$20
    BNE LOSE_LOOP
    
    JSR enableNMI
    RTS

CLEAR_SPRITES:
    LDX #$00
    LDA #$00
CLEAR_SPRITES_LOOP:
    STA $0200, X
    INX
    CPX #$00
    BNE CLEAR_SPRITES_LOOP
    RTS