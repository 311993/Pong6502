# Pong 6502
A pong version for the NES system. Written in 6502 assembly and compiled with nesasm CE v3.6.

Play unlimited games against a computer opponent. First to 5 wins. Skillful play will speed up the ball ...

### Binary

The ready-to-play game is located in *pong.nes*

It has been tested only on the MESEN emulator, though it should be able to be run on any emulator or NES system.

### Source Files

The .asm files in *src/* contain the source code for the project.

- *pong.asm* is the main file + includes game state control

- *data.asm* defines some ROM data needed for the game

- *reset.asm* holds a standard bootup/reset routine

- *init.asm* has program initialization routines

- *game_init.asm* has game screen initialization routines

- *controller.asm* handles inputs

- *win_lose.asm* holds win + lose routines


*pong.chr* contains sprite and background graphics data.

Running *build.bat* or "nesasm pong.asm" in the terminal will assemble the game. This requires the [nesasm CE v3.6 assembler](https://github.com/ClusterM/nesasm/) or another compatible nesasm fork. 

The location of nesasm must be added to the PATH environment variable for the commands to be run as written. Otherwise, specify the full path to the nesasm executable or copy it to the current directory. See the nesasm docs for further info.
