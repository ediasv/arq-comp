    ; carregar 2 no R1
    LD R1, 2    ; 0001 0000010 0101

    ; carregar 32 no R2
    LD R2, 127  ; 0010 1111111 0101

    MV A, R2    ; 000 1000 0010 0100
    ADD A, R2   ; 000 1000 0010  0001
    
    MV R2 A     ; 000 0010 1000 0100
    ; agora tem 256 em R2

    ADD A, R2 ; 000 1000 0010 0001
    ADD A, R2 ; 000 1000 0010 0001
    MV R2, A  ; 000 0010 1000 0100
    ; agora tem 768 em R2

    LD A, 5   ; 1000 0000101 0101
    ADD A, R2 ; 000 1000 0010 0001
    MV R2, A  ; 000 0010 1000 0100
    ; R2 tem 773

    ; carregar 1 no R7
    LD R7, 1 ; 0111 0000001 0101

    ; carrega 0 no R6
    LD R6, 0

    ; carrega R1 na RAM no endereço (R1)
carrega_ram:
    MV ACC, R1  ; 000 1000 0001 0100
    SW ACC, R7  ; 000 1000 0111 1011

    ; soma 1 em R1
    ADD ACC, R7  ; 000 1000 0111 0001
    MV R1, ACC   ; 000 0001 1000  0100

    ; move R6 para ACC
    MV ACC, R6  ; 000 1000 0010  0100

    ; subtrai R2 - ACC (R6)
    SUB ACC, R2  ; 000 1000 0001  0010

    ; se R6 = R2, fim do loop (zero = '1')
    BEQ fim_carrega_ram

    ; jump incondicional para carrega_ram
    JMP 3

fim_carrega_ram:
    NOP