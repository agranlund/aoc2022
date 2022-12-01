; defines and macros
Print macro
    pea     .\@s+3                  ; str
    move.w  #9,-(sp)
    trap    #1
    if NARG==2
    move.l  \2,d0
    bsr PrintHex32                  ; arg
    endif
    pea     .\@s                    ; cr+lf
    move.w  #9,-(sp)
    trap    #1
    add.l   #12,sp
    bra.s   .\@e
.\@s: dc.b  13,10,0,\1,0
    even
.\@e:
endm

; platform code
    if ATARI==1
    include atari.s
    else
    include amiga.s
    endif

; utility functions
PrintHex32:
    movem.l d0-d3/a0,-(sp)
    move.l  #.1,a0
    move.l  d0,d1
    move.w  #7,d3
.0: rol.l   #4,d1
    move.w  d1,d2
    and.w   #$f,d2
    move.w  0(a0,d2.w*2),-(sp)
    move.w  #2,-(sp)
    trap    #1
    dbra    d3,.0
    add.l   #4*8,sp
    movem.l (sp)+,d0-d3/a0
    rts
.1: dc.w '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'


LoadFile:   ; in: a0=filename, out: a0=buffer,d0=size
    moveq.l #0,d5       ; d5 = retval
    move.w  #0,-(sp)    ; mode
    move.l  a0,-(sp)    ; filename
    move.w  #61,-(sp)   ; Fopen
    trap    #1
    addq.l  #8,sp
    btst.l  #31,d0      ; success?
    beq     .0
    move.w  d0,d3       ; d3 = file handle
    move.w  #2,-(sp)    ; SEEK_END
    move.w  d0,-(sp)    ; handle
    move.l  0,-(sp)     ; offset
    move.w  #66,-(sp)   ; Fseek
    trap    #1
    move.l  d0,d4       ; d4 = file size
    move.w  #0,8(sp)    ; SEEK_SET
    trap    #1
    add.l   #10,sp
    move.l  d4,-(sp)    ; size
    move.w  #71,-(sp)   ; Malloc
    trap    #1
    addq.l  #6,sp
    cmp.l   #0,d0       ; returned null?
    beq.s   .1
    move.l  d0,a0       ; a0 = buffer
    move.l  d0,-(sp)    ; buf
    move.l  d4,-(sp)    ; size
    move.w  d3,-(sp)    ; handle
    move.w  #63,-(sp)   ; Fread
    trap    #1
    add.l   #12,sp
    cmp.l   d0,d4       ; read success?
    bne.s   .1
    move.l  d4,d5       ; retval = size
.1: move.w  d3,-(sp)    ; handle
    move.w  #62,-(sp)   ; Fclose
    trap    #1
    addq.l  #4,sp
.0: move.l  d5,d0       ; return retval
    rts

