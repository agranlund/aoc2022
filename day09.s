    text
Main:
    move.l  #visit,a6           ; a6 = visits
    move.l  #input,a0           ; a0 = input
    move.l  #delta,a1           ; a1 = delta lookup
    move.l  #head+(10*4),a3     ; a3 = end of knots
    move.l  #dmovx,a4           ; a4 = move lookup

ParseLine:
    move.b  (a0),d0             ; get move char
    cmp.b   #$a,d0              ; no more moves?
    bls.l   Done
    and.w   #$f,d0              ; mask low nibble
    move.l  0(a1,d0.w*4),d1     ; lookup delta
    addq.l  #2,a0               ; parse move count
    move.b  (a0)+,d0            ; get char
    sub.b   #'0',d0             ; to int
    move.b  (a0)+,d6            ; get next char
    sub.b   #'0',d6             ; to int
    blo.s   .0
    addq.l  #1,a0
    mulu    #10,d0
    add.b   d6,d0
.0: sub.l   #1,d0

MakeMoves:
    move.l  #head,a2            ; a2 = knot ptr
    add.l   d1,(a2)+            ; move it
    bra.s   .2
.Visit:
    move.l  -4(a2),d3           ; d3 = prev knot pos
    move.l  #visit,a5
.0: cmp.l   a5,a6               ; record visited
    beq.s   .1                  ; position
    move.l  (a5)+,d2
    cmp.l   d2,d3               ; already visited?
    beq.s   .3
    bra.s   .0
.1: move.l  d3,(a6)+
    bra.s   .3
.2: cmp.l   a3,a2               ; last knot?
    beq.s   .Visit
    bra.s   .MoveKnot
.3: dbra    d0,MakeMoves        ; more moves?
    bra.s   ParseLine           ; process next line
.MoveKnot:
    move.l  -4(a2),d3           ; d3 = prev knot pos
    move.l  d3,d2
    move.l  (a2),d4             ; d4 = curr knot pos
    sub.w   d4,d3               ; d3 = dx
    swap    d4
    swap    d2
    sub.w   d4,d2               ; d2 = dy
    cmp.w   #2,d3
    beq.s   .5
    cmp.w   #-2,d3
    beq.s   .5
    cmp.w   #2,d2
    beq.s   .5
    cmp.w   #-2,d2
    beq.s   .5
    addq.l  #4,a2
    bra.s   .2
.5: add.w   #2,d2               ; to table index
    add.w   #2,d3
    move.l  0(a4,d3.w*4),d3     ; lookup dx/dy
    add.l   20(a4,d2.w*4),d3
    add.l   d3,(a2)+            ; move knot
    bra.s   .2

Done:                           ; d1 = result
    move.l  a6,d1
    sub.l   #visit,d1
    lsr.l   #2,d1

PrintResult:            ; print d1 to screen
    clr.w   d2
    move.w  #7,d3
.0: rol.l   #4,d1       ; rotate nibble in place
    move.w  d1,d2
    and.w   #$f,d2      ; mask it
    add.w   #'0',d2     ; to '0-9'
    cmp.w   #'9',d2     ; > 9 ?
    bls.s   .1
    add.w   #7,d2       ; to 'A-F'
.1: move.w  d2,-(sp)
    move.w  #2,-(sp)
    trap    #1          ; Cconout(d2)
    dbra    d3,.0
    move.w  #0,-(sp)
    trap    #1          ; Pterm(0)

        even
input:  incbin "day09.txt"
        db $a,0,0,0
        even
head:   dl $80008000,$80008000,$80008000,$80008000,$80008000
        dl $80008000,$80008000,$80008000,$80008000,$80008000
        dl $80008000,$80008000,$80008000,$80008000,$80008000
        dl $80008000,$80008000,$80008000,$80008000,$80008000
delta:  dl 0,0,1,0,65536,-65536,0,0,0,0,0,0,-1,0,0,0
dmovx:  dl -1,-1,0,1,1
dmovy:  dl -65536,-65536,0,65536,65536
visit:  ds 4*8192
