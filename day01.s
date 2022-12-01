	; os boilerplate
	text
 	move.l	4(sp),a0		; a0 = basepage
	move.l	#1000,d0		; base
  	add.l	$c(a0),d0		; text
  	add.l	$14(a0),d0		; data
  	add.l	$1c(a0),d0		; bss
  	move.l	d0,-(sp)		; mshrink
	move.l	a0,-(sp)
	clr.w	-(sp)
	move.w	#$4a,-(sp)
	trap	#1
	add.l	#12,sp
    pea     main			; go supervisor
    move.w  #38,-(sp)
    trap    #14
    move.w  #0,-(sp)        ; exit(0)
    trap    #1
shex:
	dc.w	'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
sfilename:
	dc.b	"DAY01.TXT",0
	even
main:
	; load file
    move.w  #0,-(sp)		; fopen
	pea		sfilename
    move.w  #61,-(sp)
    trap    #1
    move.w  d0,d3       	; d3 = file handle
    move.w  #2,-(sp)    	; Fseek(0, SEEK_END)
    move.w  d0,-(sp)
    move.l  #0,-(sp)
    move.w  #66,-(sp)
    trap    #1
	move.l  d0,d4       	; d4 = file size
    move.w  #0,8(sp)    	; Fseek(0, SEEK_SET)
    trap    #1
	move.l	d4,d5
	addq.l	#4,d5
	and.l	#$FFFFFFFE,d5
	move.w	#0,-(sp)		; Mxalloc
    move.l  d5,-(sp)
    move.w  #68,-(sp)
    trap    #1
    move.l  d0,a4      	 	; a4 = buffer
    move.l  d0,-(sp)		; Fread
    move.l  d4,-(sp)
    move.w  d3,-(sp)
    move.w  #63,-(sp)
    trap    #1
    move.w  d3,-(sp)    	; Fclose
    move.w  #62,-(sp)
    trap    #1
	add.l	#42,sp			; restore stack
	move.l	a4,d0			; null terminate buffer
	add.l	d4,d0
	movea.l	d0,a5
	move.b	#0,(a5)+
	move.b	#0,(a5)+
	; count elf foodstuffs
	clr.l	d1
	move.l	#$FFFFFFFF,d5	; max
	rept 3
	inline
	move.l	d5,d6
	move.l	a4,a5
	clr.l	d5				; d5 = most cals
.0:	clr.l	d4				; d4 = curr cals
.1:	clr.l	d0				; d0 = temp
	clr.l	d3				; d3 = current n
.2:	move.l	d3,d2			; d3 *= 10
	lsl.l	#3,d3
	lsl.l	#1,d2
	add.l	d2,d3
	add.l	d0,d3			; d3 += temp
	move.b	(a5)+,d0		; read char
	sub.b	#$30,d0			; to integer
	btst	#7,d0			; end?
	beq		.2
	add.l	d3,d4			; add to curr cals
	cmp.b	#$0A,(a5)		; next elf?
	bhi.s	.1
	move.b	(a5)+,d0		; skip char
.3:	cmp.l	d5,d4			; more calories?
	bls.s	.4
	cmp.l	d6,d4			; lower than max?
	bcc.s	.4
	move.l	d4,d5			; new high cals
.4:	cmp.b	#0,d0			; more elves?
	bne.s	.0
	add.l	d5,d1			; add to total
	einline
	endr
	; print result
    move.l  #shex,a0
    move.w  #7,d3
.5: rol.l   #4,d1
    move.w  d1,d2
    and.w   #$f,d2
    move.w  0(a0,d2.w*2),-(sp)
    move.w  #2,-(sp)
    trap    #1
    dbra    d3,.5
    add.l   #4*8,sp
    rts
