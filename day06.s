%assign len 4

    org 0x100
    mov si,input
find:               ; find packet
%assign i 0
%rep len-1
%assign j i+1
    mov dl,[si+i]
%rep len-1-i
    cmp dl,[si+j]
    jz  .1
%assign j j+1
%endrep
%assign i i+1
%endrep
    jmp show
.1: add si,1
    jmp find

show:               ; show result
    mov dx,si       ; current offset
    add dx,len      ; + packet length
    sub dx,input    ; - buffer start
    mov cl,12
.3: push dx
    shr dx,cl       ; shift into place
    and dl,0xf      ; isolate nibble
    add dl,0x30     ; to '0-9'
    cmp dl,0x39     ; > 9?
    jle .4
    add dl,0x7      ; to 'A-F'
.4: mov ah,0x2      ; print to console
    int 0x21
    pop dx
    sub cl,4
    jge .3
    mov ah,0x4c     ; exit
    int 0x21
input incbin 'day06.txt'

