    section text
  	move.l	4(sp),a0				; a0 = basepage
	move.l	#100,d0					; basepage size
	add.l	#$1000,d0				; 
  	add.l	$c(a0),d0				; text size
  	add.l	$14(a0),d0				; data size
  	add.l	$1c(a0),d0				; bss size
  	move.l	d0,-(sp)				; Mshrink()
	move.l	a0,-(sp)
	clr.w	-(sp)
	move.w	#$4a,-(sp)
	trap	#1
	add.l	#12,sp
    pea     __super                  ; Supexec(__super)
    move.w  #38,-(sp)
    trap    #14
    move.w  #0,-(sp)                ; Exit(0)
    trap    #1
__super:
    move.l  $4ba,-(sp)              ; save current 200hz ticks
    bsr     main                    ; main()
    move.l  $4ba,d3                 ; get current ticks
    sub.l   (sp)+,d3                ; subtract previous
    move.l  d3,d2                   ; convert to ms
    lsl.l   #2,d2
    add.l   d2,d3
    Print   "ms: ",d3
    rts

