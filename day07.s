    bss
size: ds 4*32

    text
    move.l  #input,a0       ; a0 = puzzle input
    move.l  #dirs,a1        ; a1 = directory sizes
    move.l  #size,a2        ; a2 = temp sizes
    
ParseInput:
.0: cmp.b   #$0,0(a0)
    beq.s   ParseDone
    cmp.b   #'.',5(a0)      ; "cd.." ?
    bne     .1
    move.l  (a2),d0         ; add cur size to prev
    subq.l  #4,a2
    add.l   d0,(a2)
    move.l  d0,(a1)+        ; add new dir
    bra     .5
.1: cmp.b   #'c',2(a0)      ; "cd dir"
    bne     .2
    addq.l  #4,a2           ; next size
    clr.l   (a2)            ; and clear
    bra     .5
.2: cmp.b   #'9',(a0)
    bhi.s   .5
    cmp.b   #'0'-1,(a0)
    bls.s   .5
    clr.l   d2
    clr.l   d0
.3: move.b  (a0)+,d2        ; d2 = input char
    cmp.b   #' ',d2         ; done?
    bne.s   .4
    add.l   d0,(a2)         ; add to cur size
    bra.s   .5
.4: move.l  d0,d1           ; d0 *= 10
    lsl.l   #3,d0
    add.l   d1,d0
    add.l   d1,d0
    sub.b   #'0',d2         ; to int
    add.l   d2,d0           ; d0 += d2
    bra.s   .3              ; and loop for next char
.5: cmp.b   #$a,(a0)+       ; skip to next line
    bne     .5
    bra     .0

ParseDone:
    cmp.l   #size,a2
    blo.s   FindResult
    move.l  (a2),d0
    subq.l  #4,a2
    add.l   d0,(a2)
    move.l  d0,(a1)+
    bra.s   ParseDone

FindResult:
    subq.l  #4,a1
    move.l   -(a1),d1       ; used space
    move.l  #30000000,d2    ; free space needed
    add.l   d1,d2
    sub.l   #70000000,d2    ; d2 = target size
.0: cmp.l   #dirs,a1
    beq.s   Show
    move.l  -(a1),d0        ; d0 = dir size
    cmp.l   d0,d2           ; target > dir?
    bhi.s   .0
    cmp.l   d1,d0           ; best < dir?
    bhi.s   .0
    move.l  d0,d1           ; best = dir
    bra.s   .0

Show:
    move.l  #sHex,a4
    move.w  #7,d3
.0: rol.l   #4,d1
    move.w  d1,d2
    and.l   #$f,d2
    add.w   d2,d2
    add.l   a4,d2
    move.l  d2,a0
    move.w  (a0),-(sp)
    move.w  #2,-(sp)
    trap    #1
    dbra    d3,.0
    move.w  #0,-(sp)
    trap    #1

sHex:
	dc.w '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
dirs:
    db 0,0,0,0,0,0,0,0
input:
    incbin "day07.txt"
    db $a,$0
