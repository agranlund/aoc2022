
DEF PUZZLE = 1

SECTION	"hdr",ROM0[$0100]
    nop     ; cartridge header
    jp      main
    db      $ce,$ed,$66,$66,$cc,$0d,$00,$0b,$03,$73,$00,$83,$00,$0c,$00,$0d
    db      $00,$08,$11,$1f,$88,$89,$00,$0e,$dc,$cc,$6e,$e6,$dd,$dd,$d9,$99
    db      $bb,$bb,$67,$63,$6E,$0e,$ec,$cc,$dd,$dc,$99,$9f,$bb,$b9,$33,$3e
    db      "AOC:2022",0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,$33,0,0,0,0,0,0,0,0,0

SECTION "bss",WRAM0[$C000]
gPresents: ds 256   ; must start at $C000 due to indexing optimisations

SECTION	"data",ROM0[$0241]
sScores:    ; must start at $0241 due to indexing optimisations
    db 27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52
    db 0,0,0,0,0,0
    db 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26
sFontGfx:   ; beware of coder art
    db $00,$fe,$82,$82,$92,$82,$82,$fe,$00,$7c,$44,$64,$24,$24,$24,$3c
    db $00,$fe,$82,$e2,$82,$8e,$82,$fe,$00,$fe,$82,$e2,$82,$e2,$82,$fe
    db $00,$fe,$92,$82,$82,$f2,$12,$1e,$00,$fe,$82,$8e,$82,$e2,$82,$fe
    db $00,$f0,$90,$9e,$82,$92,$82,$fe,$00,$fe,$82,$f2,$26,$24,$24,$3c
    db $00,$fe,$82,$92,$82,$92,$82,$fe,$00,$fe,$82,$92,$82,$e2,$22,$3e
    db $00,$7c,$82,$92,$82,$92,$92,$fe,$00,$fc,$82,$92,$86,$92,$82,$fc
    db $00,$7e,$82,$82,$8e,$82,$82,$7e,$00,$fc,$82,$82,$92,$82,$82,$fc
    db $00,$fe,$82,$8e,$82,$8e,$82,$fe,$00,$fe,$82,$8e,$82,$8e,$88,$f8
    db $00,$00,$00,$fe,$82,$fe,$00,$00
sInput:     ; puzzle input
    incbin  "day03.txt"
    db      $0a,$00

SECTION	"text",ROM0
main:       ; main
    di                      ; no irqs thankyouverymuch
    ld      bc,0
    push    bc              ; keep score on stack
    ld      hl,sInput       ; hl = input

IF PUZZLE == 1
    ; -------------------------------------------------
    ; Part 1
    ; -------------------------------------------------
    ; count presents and record their rightmost position
.0: push    hl              ; save start of rucksack ptr
    ld      d,$C0           ; de = present data
    ld      c,0             ;  c = rucksize size counter
.1: ld      a,[hl+]         ; grab present
    cp      $0a             ; end of rucksack?
    jr      z,.2
    ld      e,a             ; index into present position list
    ld      a,c
    ld      [de],a          ; and update position
    inc     c               ; increment present counter
    jr      .1              ; and keep going through the bag
.2: ; find presents which exist in both compartments
    pop     de
    push    hl
    ld      h,d
    ld      l,e             ; hl = start of rucksack
    sra     c               ; b = size / 2
    ld      b,c             ; c = loop count
    ld      d,$C0           ; de = present data
.3: ld      a,[hl+]         ; grab present
    ld      e,a
    ld      a,[de]          ; a = rightmost position
    cp      b               ; in second compartment?
    jr      nc,.4
    dec     c
    jr      nz,.3
    pop     hl              ; go through the next sack
    ld      a,[hl]          ; if there are any more
    cp      0
    jr      z,show
    jr      .1
.4: ; duplicate present found
    ld      d,$02           ; de = scores
    ld      a,[de]
    pop     de              ; de = input ptr
    pop     hl              ; hl = total score
    ld      c,a             ; add current
    ld      b,0
    add     hl,bc
    push    hl              ; push total back on stack
    ld      h,d             ; hl = input ptr
    ld      l,e
    ld      a,[hl]          ; go through the next sack
    cp      0               ; if there are any more
    jr      nz,.0
ELSE
    ; -------------------------------------------------
    ; Part 2
    ; -------------------------------------------------

ENDC


show: ; display result on screen
.0: ld      a,[$FF44]       ; wait for vbl, this hardware is touchy
    cp      145
    jr      nz,.0
    ld      a,[$FF40]       ; turn off the lcd so we don't have to
    res     7,a             ; both with proper vram access timing.
    ld      [$FF40],a
    ld      de,sFontGfx     ; upload font graphics to tile vram
    ld      hl,$8200
    ld      bc,17*8
.1: ld      a,[de]
    ld      [hl+],a
    ld      [hl+],a
    inc     de
    dec     c
    jr      nz,.1
    ; print value
    pop     bc              ; bc = src value
    ld      hl,$9967        ; display the value by assigning
    ld      a,16+32         ; tilemap vram
    ld      [hl+],a
    ld      a,b             ; $X...
    srl     a
    srl     a
    srl     a
    srl     a
    add     a,32
    ld      [hl+],a
    ld      a,b             ; $.X..
    and     a,$f
    add     a,32
    ld      [hl+],a
    ld      a,c             ; $..X.
    srl     a
    srl     a
    srl     a
    srl     a
    add     a,32
    ld      [hl+],a
    ld      a,c             ; $...X
    and     a,$f
    add     a,32
    ld      [hl+],a
    ld      a,16+32
    ld      [hl+],a
    ld      a,[$FF40]       ; liquid crystals, activate!
    set     7,a
    ld      [$FF40],a
    halt                    ; forever wait



