    .text
    .globl _main
_main:
    | Run Elf program as 68000
    .macro noop
        move.b  d5,(a5)+
    .endm
    .macro addx,x
        move.b  d5,(a5)+
        move.b  d5,(a5)+
        add.b  #\x,d5
    .endm
    move.l  #trace,a5   | a5 = trace
    moveq.l #1,d5       | d5 = x register
    #include "day10.txt"
    noop

    | Draw the screen
    moveq.l #0,d3           | d4 = x counter
    moveq.l #5,d4           | d4 = y counter
    move.l  #trace,a4       | a4 = trace
    move.l  #disp,a5        | a5 = display
.0: move.b  #'.',(a5)+      | d0 = output
    move.b  (a4)+,d1        | d1 = sprite pos
    sub.b   d3,d1           | x = sprx?
    beq.s   .1
    sub.b   #1,d1           | x = sprx+1?
    beq.s   .1
    add.b   #2,d1           | x == sprx-1?
    bne.s   .2
.1: move.b  #'#',-1(a5)     | this is a pixel
.2: addq.w  #1,d3           | step x
    cmp.w   #40,d3          | at end?
    bne.s   .0
    move.l  #disp,a5        | draw line
    move.l  a5,-(sp)
    move.w  #9,-(sp)
    trap    #1
    addq.l  #6,sp
    clr.l   d3              | next line
    dbra    d4,.0
    move.w  #0,-(sp)        | Exit(0)
    trap    #1

disp:
.fill 40,1,0        | scanline
.byte 10,13,0,0     | newline, return, null
trace:
.fill 1024,1,0
