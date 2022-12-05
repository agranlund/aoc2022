Puzzle = 2

        bss
        ds 16*4*64
stacks: ds 4*16
    text
    rept 16
    move.l  #stacks-(REPTN*4*64),stacks+(4*REPTN)
    endr
    move.l  #stacks,a5          ; a5 = stack pointer list
    move.l  #input,a4           ; a4 = input data

; parse drawing
    clr.l   d6                  ; d6 = width
.0: addq.l  #1,d6
    cmp.b   #$a,0(a4,d6)
    bne.s   .0
    addq.l  #1,d6
    move.l  #0,-(sp)            ; push end marker
.1: move.l  a4,-(sp)            ; push line ptr
    add.l   d6,a4
    cmp.b   #$a,(a4)            ; more lines?
    bne.s   .1
    lsr.l   #2,d6               ; d6 = columns
    addq.l  #4,sp               ; get rid of ID line
.2: move.l  (sp)+,a0            ; pop line ptr
    cmp.l   #0,a0               ; no more?
    beq.s   moveboxes
    clr.l   d3                  ; d3 = column counter
.3: move.b  1(a0,d3*4),d0       ; get boxid
    cmp.b   #' ',d0             ; empty?
    beq.s   .4
    subq.l  #4,0(a5,d3.w*4)     ; add box
    move.b  d0,([a5,d3.w*4])
.4: addq.l  #1,d3
    cmp.l   d3,d6
    bne.s   .3                  ; next column
    bra.s   .2                  ; next line

; parse move orders
moveboxes:
    addq.l  #1,a4
    moveq.l #0,d3               ; d3 = src
    moveq.l #0,d4               ; d4 = dst
.0: clr.l   d2
    move.b  5(a4),d2            ; d2 = count = in[5]
    sub.b   #'0',d2             ; to number
    bmi.s   done                ; no more data?
    move.b  6(a4),d3            ; count > 9?
    sub.b   #'0',d3
    bmi.s   .1
    mulu    #10,d2              ; count = in[5]*10
    add.b   d3,d2               ; count += in[6]
    addq.l  #1,a4               ; in++
.1: move.b  12(a4),d3           ; get src
    sub.b   #'1',d3
    move.b  17(a4),d4           ; get dst
    sub.b   #'1',d4
    add.l   #19,a4              ; next line
    if Puzzle=1    
        bra.s   .3
.2:     move.b  ([a5,d3.w*4]),d0    ; pop box from src
        addq.l  #4,0(a5,d3.w*4)
        subq.l  #4,0(a5,d4.w*4)     ; push box onto dst
        move.b  d0,([a5,d4.w*4])
.3:     dbra.w  d2,.2
    else
        move.l  d2,d5
        move.l  d5,d1               ; d1 = offset
        subq.l  #1,d1
        lsl.l   #2,d1
        add.l   d1,0(a5,d3.w*4)
        bra.s   .3
.2      move.b  ([a5,d3.w*4]),d0    ; pop box from src
        subq.l  #4,0(a5,d3.w*4)
        subq.l  #4,0(a5,d4.w*4)     ; push box onto dst
        move.b  d0,([a5,d4.w*4])
.3:     dbra.w  d2,.2
        move.l  d5,d1
        addq.l  #1,d1
        lsl.l   #2,d1
        add.l   d1,0(a5,d3.w*4)
    endif
    bra.s   .0                  ; do next order

; show result and quit
done:
    clr.w   d3
    clr.w   d4
.0: move.b  ([a5,d3.w*4]),d4
    move.w  d4,-(sp)
    move.w  #2,-(sp)
    trap    #1
    addq.w  #1,d3
    cmp.w   d3,d6
    bne.s   .0
    move.w  #0,-(sp)
    trap    #1

input:
    incbin "day05.txt"
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
