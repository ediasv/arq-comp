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

        LD R5, 12   ; 0101 0001100 0101
        ADD A, R5 ; 000 1000 0101 0001
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
        MV ACC, R1  ; 000 1000 0001  0100

    ; subtrai R2 - ACC (R1)
        SUB ACC, R2  ; 000 1000 0010  0010

    ; se R1 = R2, fim do loop (zero = '1') (soma 2 no pc)
        BEQ fim_carrega_ram ; 0000 00000010 0111

    ; jump incondicional para carrega_ram
        JMP carrega_ram     ; 0000 0000011 0110

fim_carrega_ram:

    ; percorrer a ram de 2 até 27, tirando os multiplos
    ; desde que o multiplo seja menor que 773
    ; basicamente um loop aninhado
    ; loop externo de 0 ate 773

        MV R5, R2
        LD R3, 28
        LD R2, 2
        LD R1, 1
        LD R0, 0

inicio_loop_crivo:
        ; se RAM[R2] == *(R1), tira os multiplos
        MV A, R2
        LW R4, A
        MV A, R4
        SUB A, R1
        BEQ tira_multiplos
        JMP proximo_endereco_ram

tira_multiplos:
        MV R6, R2
prox_multiplo:
        MV A, R6
        ADD A, R2
        SW A, R0 
        MV R6, A 
        SUB A, R5 
        BEQ proximo_endereco_ram
        JMP prox_multiplo

proximo_endereco_ram:
        MV A, R2
        ADD A, R1
        MV R2, A
        SUB A, R3
        BEQ fim_loop_crivo
        JMP inicio_loop_crivo

fim_loop_crivo:
        