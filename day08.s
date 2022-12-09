    text

CalculateDeltas:
    move.l  #input,a0
.0: cmp.b   #'0',(a0)+
    bhs.s   .0
    move.l  a0,d5
    sub.l   #input,d5   ; d5 = width
    move.l  d5,delta+8  ; delta down
    move.l  d5,delta+12 
    neg.l   delta+12    ; delta up

FindBestScore:
    move.l  #input,a0
    clr.l   d1          ; d1 = best score
.0: move.b  (a0),d0     ; d0 = tree height
    cmp.b   #'0',d0     ; at newline?
    blo.s   .4
    move.l  #delta,a2   ; a2 = deltas
    moveq.l #3,d6       ; d6 = dirs
    move.l  #1,d4       ; d4 = total
.1: clr.l   d3          ; d3 = score
    move.l  (a2)+,a3    ; a3 = delta
    move.l  a0,a1       ; a1 = a0 + delta
.2: add.l   a3,a1
    move.b  (a1),d2     ; d2 = next height
    cmp.b   #'0',d2     ; edge?
    blo.s   .3
    addq.l  #1,d3       ; no, add score
    cmp.b   d2,d0       ; more?
    bhi.s   .2
.3: mulu    d3,d4       ; increase total
    clr.l   d3
    dbra    d6,.1
    cmp.l   d1,d4       ; new best?
    blo.s   .4
    move.l  d4,d1
.4: addq.l  #1,a0       ; next tree
    cmp.l   #inend,a0   ; no more?
    blo.s   .0

PrintResult:
    clr.w   d2
    move.w  #7,d3
.0: rol.l   #4,d1
    move.w  d1,d2
    and.w   #$f,d2
    add.w   #'0',d2 ; to '0-9'
    cmp.w   #'9',d2 ; > 9 ?
    bls.s   .1
    add.w   #7,d2   ; to 'A-F'
.1: move.w  d2,-(sp)
    move.w  #2,-(sp)
    trap    #1
    dbra    d3,.0
    move.w  #0,-(sp)
    trap    #1

delta:  dl -1,1,0,0
        ds 256
input:  incbin "day08.txt"
inend:  ds 256
