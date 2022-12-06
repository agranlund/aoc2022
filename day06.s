%assign len 14

%macro pkt 2
    mov dl,[si+%1]
    cmp dl,[si+%2]
    jz  .1
%endmacro

org 0x100
    mov si,input
.0:
%assign i 0
%rep len-1
%assign j i+1
%rep len-1-i
    pkt i,j
%assign j j+1
%endrep
%assign i i+1
%endrep
    jmp .2
.1: add si,1
    jmp .0
.2: mov dx,si       ; show the result
    add dx,len
    sub dx,input
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
