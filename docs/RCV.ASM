;******************************************************************************
;*                      RS232C�����{�� ( PC --> 8051 )                        *
;*                                                                            *
;*    1. crystal : 12MHZ                                                      *
;*    2. Under Test !!!                                                       *
;*    3. DATE: 2004.  2. 16                                                   *
;*    4. Baud rate : 4800 bps                                                 *
;*    5. �N�����{���g�J�~�� RAM ��.                                           *
;*    6. ��ʪ� !!!                                                           *
;*                                                                            *
;******************************************************************************
;�z�w�w�w�w�w�w�w�w�w�w�w�w�w�{
;�x  �H�U�]�w�U�ܼƦ�m.     �x
;�|�w�w�w�w�w�w�w�w�w�w�w�w�w�}
lengthh         equ     21h             ; �{ �u�@�ܼ�,�`�Ƹs.
lengthl         equ     22h             ; �}

;�z�w�w�w�w�w�w�w�w�w�w�w�w�w�{
;�x    �]�w�U���_�V�q��}    �x
;�|�w�w�w�w�w�w�w�w�w�w�w�w�w�}
        org     00h
        jmp     start

;�z�w�w�w�w�w�w�w�w�w�w�w�w�w�{
;�x       ��l�Ƴ]�w         �x
;�x1.Set stack pointer.      �x
;�x2.Set timer's mode.       �x
;�x3.Set interrupt disable.  �x
;�x4.Set register bank.      �x
;�|�w�w�w�w�w�w�w�w�w�w�w�w�w�}
start:
        mov     sp,#30h
        mov     psw,#00000000b
        mov     ie,#00000000b                   ; Disable all interrupt.
        mov     scon,#01010000b                 ; �W����C�𬰼Ҧ�1.
        mov     tmod,#00100000b                 ; �j�v��Timer1�]�w(auto reload)
        orl     pcon,#10000000b                 ; pcon.7(smod) = 1.
        mov     th1,#0f3h                       ; Baud rate = 4800.
        setb    tr1

;�z�w�w�w�w�w�w�w�w�w�w�w�w�w�{
;�x       �D�{������         �x
;�|�w�w�w�w�w�w�w�w�w�w�w�w�w�}
wait:   jnb     ri,$                            ; �{
        clr     ri                              ; �u ���ݶǰe�}�l.
        mov     a,sbuf                          ; �u ���ݦr�� P.
        cjne    a,#'P',wait                     ; �}

        jnb     ri,$                            ; �{
        clr     ri                              ; �u ������ƪ��פ�High byte.
        mov     a,sbuf                          ; �x
        mov     lengthh,a                       ; �}

        jnb     ri,$                            ; �{
        clr     ri                              ; �u ������ƪ��פ�Low byte.
        mov     a,sbuf                          ; �x
        mov     lengthl,a                       ; �}
        jnz     go
        dec     lengthh

go:     mov     dptr,#0000h
loop:   jnb     ri,$
        clr     ri
        mov     a,sbuf
        movx    @dptr,a
        inc     dptr

handshk:
        mov     a,#'Z'
        mov     sbuf,a
        jnb     ti,$
        clr     ti

        djnz    lengthl,loop
        mov     a,lengthh
        jz      ok
        dec     lengthh
        jmp     loop
ok:     jmp     ok
        end