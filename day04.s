*   = $0801
    .word (+), 10
    .null $9e, format("%d", main)
+   .word 0

Puzzle = 2
InputPtr = $58
Counter = $5a
Values = $60
InputAddrHi = sInput >> 8
InputAddrLo = sInput & $ff

sHex:   .text "0123456789abcdef"
sInput: .binary "day04.txt"
        .byte   0,0,0,0,0,0,0,0

main:
    lda #InputAddrLo    ; init zeropage
    sta InputPtr+0
    lda #InputAddrHi
    sta InputPtr+1
    lda #0
    sta Counter+0
    sta Counter+1
    cld
    jmp loop
done:
    jmp show

loop:                   ; loop all lines
    ; parse line
    ldy #0
    lda (InputPtr),y
    cmp #0
    beq done            ; no more?
.for idx = 0, idx < 4, idx = idx + 1
    clc
    lda (InputPtr),y    ; get char
    sbc #$2f            ; to int
    sta Values+idx
    inc y               ; next
    clc
    lda (InputPtr),y    ; get char
    sbc #$2f            ; to int
    bcc +               ; not an int?
    clc
    rol Values+idx      ; shift to high nibble
    rol Values+idx
    rol Values+idx
    rol Values+idx
    adc Values+idx      ; write low nibble
    sta Values+idx
    inc y               ; next
+   inc y               ; next
.next
    ; next line
    tya                 ; y -> a
    clc                 ; clear carry flag
    adc InputPtr+0      ; add low byte
    sta InputPtr+0      ; overflow?
    bcc compare
    inc InputPtr+1      ; increment high byte

compare:
    lda Values+0        ; start1
    cmp Values+2        ; start2
    beq found
    bcc l1
    ; start1 > start2
.if puzzle == 1
    lda Values+1
    cmp Values+3
.else
    lda Values+0
    cmp Values+3
.endif
    bcc found
    beq found
    jmp loop
l1: ; start1 < start2
.if puzzle == 1
    lda Values+3
    cmp Values+1
.else
    lda Values+2
    cmp Values+1
.endif
    bcc found
    beq found
    jmp loop
found:
    clc
    lda #1
    adc Counter+0
    sta Counter+0
    bcc l2
    inc Counter+1
l2: jmp loop

show:
    ; print result
    lda #147
    jsr $ffd2
.for idx = 1, idx >= 0, idx = idx - 1
    lda Counter+idx
    lsr a
    lsr a
    lsr a
    lsr a
    sta Values
    lda #$f
    and Values
    tay
    lda sHex,y
    jsr $ffd2
    lda Counter+idx
    sta Values
    lda #$f
    and Values
    tay
    lda sHex,y
    jsr $ffd2
.next
    lda #0
    jsr $ffd2
    lda #13
    jsr $ffd2
    lda #10
    jsr $ffd2
    rts
