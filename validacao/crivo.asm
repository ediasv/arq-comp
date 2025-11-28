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

    LD A, 6   ; 1000 0000101 0101
    ADD A, R2 ; 000 1000 0010 0001
    MV R2, A  ; 000 0010 1000 0100
    ; R2 tem 774

    ; carregar 1 no R7
    LD R7, 1 ; 0111 0000001 0101

    ; carrega R1 na RAM no endereço (R1)
carrega_ram:
    MV ACC, R1  ; 000 1000 0001 0100
    SW ACC, R7  ; 000 1000 0111 1011

    ; INCREMENTA O ENDERECO
    ; soma 1 em R1
    ADD ACC, R7  ; 000 1000 0111 0001
    MV R1, ACC   ; 000 0001 1000  0100

    ; VERIFICA SE O NOVO ENDERECO EH VALIDO
    ; move R1 para ACC
    MV ACC, R1  ; 000 1000 0010  0100

    ; subtrai R2 - ACC (R1)
    SUB ACC, R2  ; 000 1000 0001  0010

    ; se R1 = R2, fim do loop (zero = '1')
    BEQ fim_carrega_ram

    ; jump incondicional para carrega_ram
    JMP 3

fim_carrega_ram:
    ; percorrer a ram de 2 até 27, tirando os multiplos
    ; desde que o multiplo seja menor que 773
    ; basicamente um loop aninhado
    ; loop externo de 0 ate 773
