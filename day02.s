Puzzle = 2
    text
    movem.l     d0-a6,-(sp)
	lea		    sDosLib,a1      ; exec->OpenLibrary("dos.library")
	moveq	    #36,d0
	movea.l	    4,a6
	jsr		    -552(a6)
    movea.l     d0,a6           ; a6 = doslib
    ; play games
    lea         input,a4        ; a4 = inputs
    clr.l       d0              ; d0 = temp
    clr.l       d1              ; d1 = temp
    clr.l       d4              ; d4 = total score
.0: move.b      (a4),d0         ; player1 move
    beq.s       .1              ; end?
    addq.l      #2,a4
    sub.b       #$41,d0
    lsl.b       #2,d0
    move.b      (a4),d1         ; player2 move
    addq.l      #2,a4
    sub.b       #$58,d1
    or.b        d0,d1
    move.l      #sScoreTab,d0   ; lookup score
    add.l       d1,d0
    movea.l     d0,a0
    move.b      (a0),d1
    add.l       d1,d4           ; add to total
    bra.s       .0
    ; print result
.1: move.l      #7,d3           ; count
.2: rol.l       #4,d4
    move.b      d4,d1
    and.l       #$0000000f,d1
    add.l       #sHex,d1        ; doslib->WriteChar
    moveq.l     #1,d2
    jsr         -942(a6)
    dbra        d3,.2           ; loop
    ; done
    movea.l     a6,a1           ; exec->CloseLibrary(doslib)
    movea.l     4,a6
    jsr         -414(a6)
    movem.l     (sp)+,d0-a6
    rts
          
input:      incbin "day02.txt",0
sDosLib:    dc.b "dos.library",0
sHex:       dc.b "0123456789ABCDEF"
sScoreTab:
    if Puzzle=1
    dc.b 3+1, 6+2, 0+3, 0   ; A:XYZ
    dc.b 0+1, 3+2, 6+3, 0   ; B:XYZ
    dc.b 6+1, 0+2, 3+3, 0   ; C:XYZ
    else
    dc.b 0+3, 3+1, 6+2, 0   ; A:XYZ
    dc.b 0+1, 3+2, 6+3, 0   ; B:XYZ
    dc.b 0+2, 3+3, 6+1, 0   ; C:XYZ
    endif
