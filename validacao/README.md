# Validação (Entrega Final)

## 1. Objetivos

Realizar uma bateria de testes para garantir que o processador funciona.

Os testes devem incluir:

1. Crivo de Eratóstenes.
2. Testar todas as instruções implementadas.

Além disso é preciso implementar duas "complicações" adicionais. Elas são:

1.
2.

---

## 2. Crivo de Eratóstenes

Vamos passar o limite superior de verificação. Isso significa que, se queremos
achar todos os primos até 37, já vamos passar 6 como o limite, vamos remover
todos os múltiplos de 2, 3, ..., $\lfloor \sqrt{37} \rfloor = 6$.

### 2.1 Estratégia

1. Fazer um loop para carregar os números de 2 a 32 na memória RAM.
2. Carregar $\lfloor \sqrt{37} \rfloor = 6$ no R3 (limite para o crivo).

### 2.2 Assembly

```asm
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

        MV R5, R3
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
```

### 2.3 Codificação Binária

#### Endereço 0: LD R1, 2
- **Formato**: C | **Binário**: `0001_0000010_0101`

#### Endereço 1: LD R2, 127
- **Formato**: C | **Binário**: `0010_1111111_0101`

#### Endereço 2: MV A, R2
- **Formato**: S | **Binário**: `000_1000_0010_0100`

#### Endereço 3: ADD A, R2
- **Formato**: S | **Binário**: `000_1000_0010_0001`

#### Endereço 4: MV R2, A
- **Formato**: S | **Binário**: `000_0010_1000_0100`

#### Endereço 5: ADD A, R2
- **Formato**: S | **Binário**: `000_1000_0010_0001`

#### Endereço 6: ADD A, R2
- **Formato**: S | **Binário**: `000_1000_0010_0001`

#### Endereço 7: LD R5, 12
- **Formato**: C | **Binário**: `0101_0001100_0101`

#### Endereço 8: ADD A, R5
- **Formato**: S | **Binário**: `000_1000_0101_0001`

#### Endereço 9: MV R2, A
- **Formato**: S | **Binário**: `000_0010_1000_0100`

#### Endereço 10: LD R7, 1
- **Formato**: C | **Binário**: `0111_0000001_0101`

#### Endereço 11: MV ACC, R1 (carrega_ram)
- **Formato**: S | **Binário**: `000_1000_0001_0100`

#### Endereço 12: SW ACC, R7
- **Formato**: S | **Binário**: `000_1000_0111_1011`

#### Endereço 13: ADD ACC, R7
- **Formato**: S | **Binário**: `000_1000_0111_0001`

#### Endereço 14: MV R1, ACC
- **Formato**: S | **Binário**: `000_0001_1000_0100`

#### Endereço 15: MV ACC, R1
- **Formato**: S | **Binário**: `000_1000_0001_0100`

#### Endereço 16: SUB ACC, R2
- **Formato**: S | **Binário**: `000_1000_0010_0010`

#### Endereço 17: BEQ 2 (fim_carrega_ram)
- **Formato**: C | **Binário**: `0000_0000010_0111`

#### Endereço 18: JMP 11 (carrega_ram)
- **Formato**: C | **Binário**: `0000_0001011_0110`

#### Endereço 19: MV R5, R3 (fim_carrega_ram)
- **Formato**: S | **Binário**: `000_0101_0011_0100`

#### Endereço 20: LD R3, 28
- **Formato**: C | **Binário**: `0011_0011100_0101`

#### Endereço 21: LD R2, 2
- **Formato**: C | **Binário**: `0010_0000010_0101`

#### Endereço 22: LD R1, 1
- **Formato**: C | **Binário**: `0001_0000001_0101`

#### Endereço 23: LD R0, 0
- **Formato**: C | **Binário**: `0000_0000000_0101`

#### Endereço 24: MV A, R2 (inicio_loop_crivo)
- **Formato**: S | **Binário**: `000_1000_0010_0100`

#### Endereço 25: LW R4, A
- **Formato**: S | **Binário**: `000_0100_1000_1010`

#### Endereço 26: MV A, R4
- **Formato**: S | **Binário**: `000_1000_0100_0100`

#### Endereço 27: SUB A, R1
- **Formato**: S | **Binário**: `000_1000_0001_0010`

#### Endereço 28: BEQ 2 (tira_multiplos)
- **Formato**: C | **Binário**: `0000_0000010_0111`

#### Endereço 29: JMP 31 (proximo_endereco_ram)
- **Formato**: C | **Binário**: `0000_0011111_0110`

#### Endereço 30: MV R6, R2 (tira_multiplos)
- **Formato**: S | **Binário**: `000_0110_0010_0100`

#### Endereço 31: MV A, R6 (prox_multiplo)
- **Formato**: S | **Binário**: `000_1000_0110_0100`

#### Endereço 32: ADD A, R2
- **Formato**: S | **Binário**: `000_1000_0010_0001`

#### Endereço 33: SW A, R0
- **Formato**: S | **Binário**: `000_1000_0000_1011`

#### Endereço 34: MV R6, A
- **Formato**: S | **Binário**: `000_0110_1000_0100`

#### Endereço 35: SUB A, R5
- **Formato**: S | **Binário**: `000_1000_0101_0010`

#### Endereço 36: BEQ 2 (proximo_endereco_ram)
- **Formato**: C | **Binário**: `0000_0000010_0111`

#### Endereço 37: JMP 31 (prox_multiplo)
- **Formato**: C | **Binário**: `0000_0011111_0110`

#### Endereço 38: MV A, R2 (proximo_endereco_ram)
- **Formato**: S | **Binário**: `000_1000_0010_0100`

#### Endereço 39: ADD A, R1
- **Formato**: S | **Binário**: `000_1000_0001_0001`

#### Endereço 40: MV R2, A
- **Formato**: S | **Binário**: `000_0010_1000_0100`

#### Endereço 41: SUB A, R3
- **Formato**: S | **Binário**: `000_1000_0011_0010`

#### Endereço 42: BEQ 2 (fim_loop_crivo)
- **Formato**: C | **Binário**: `0000_0000010_0111`

#### Endereço 43: JMP 24 (inicio_loop_crivo)
- **Formato**: C | **Binário**: `0000_0011000_0110`

#### Endereço 44: NOP (fim_loop_crivo)
- **Formato**: N/A | **Binário**: `000_0000_0000_0000`

### 2.4 Resumo da Memória ROM para o Crivo de Eratóstenes

<!-- markdownlint-disable MD013 -->

| End. | Instrução       | Binário         | Comentário                          |
| ---: | :-------------- | :-------------- | :---------------------------------- |
|    0 | LD R1, 2        | 000100000100101 | Inicializa contador                 |
|    1 | LD R2, 127      | 001011111110101 | Carrega 127                         |
|    2 | MV A, R2        | 000100000100100 | A = 127                             |
|    3 | ADD A, R2       | 000100000100001 | A = 254                             |
|    4 | MV R2, A        | 000001010000100 | R2 = 254                            |
|    5 | ADD A, R2       | 000100000100001 | A = 508                             |
|    6 | ADD A, R2       | 000100000100001 | A = 762                             |
|    7 | LD R5, 12       | 010100011000101 | R5 = 12                             |
|    8 | ADD A, R5       | 000100001010001 | A = 774                             |
|    9 | MV R2, A        | 000001010000100 | R2 = 774 (limite)                   |
|   10 | LD R7, 1        | 011100000010101 | R7 = 1                              |
|   11 | MV ACC, R1      | 000100000010100 | carrega_ram: ACC = R1               |
|   12 | SW ACC, R7      | 000100001111011 | RAM[ACC] = 1                        |
|   13 | ADD ACC, R7     | 000100001110001 | ACC++                               |
|   14 | MV R1, ACC      | 000000110000100 | R1 = ACC                            |
|   15 | MV ACC, R1      | 000100000010100 | ACC = R1                            |
|   16 | SUB ACC, R2     | 000100000100010 | ACC = R2 - R1                       |
|   17 | BEQ 2           | 000000000100111 | Se zero, pula para fim_carrega_ram  |
|   18 | JMP 11          | 000000010110110 | Volta para carrega_ram              |
|   19 | MV R5, R3       | 000010100110100 | fim_carrega_ram: Salva R3           |
|   20 | LD R3, 28       | 001100111000101 | R3 = 28 (limite crivo)              |
|   21 | LD R2, 2        | 001000000100101 | R2 = 2 (início)                     |
|   22 | LD R1, 1        | 000100000010101 | R1 = 1 (constante)                  |
|   23 | LD R0, 0        | 000000000000101 | R0 = 0 (constante)                  |
|   24 | MV A, R2        | 000100000100100 | inicio_loop_crivo: A = R2           |
|   25 | LW R4, A        | 000010010001010 | R4 = RAM[A]                         |
|   26 | MV A, R4        | 000100001000100 | A = R4                              |
|   27 | SUB A, R1       | 000100000010010 | A = R1 - A                          |
|   28 | BEQ 2           | 000000000100111 | Se primo, vai tira_multiplos        |
|   29 | JMP 31          | 000000111110110 | Senão, proximo_endereco_ram         |
|   30 | MV R6, R2       | 000011000100100 | tira_multiplos: R6 = R2             |
|   31 | MV A, R6        | 000100001100100 | prox_multiplo: A = R6               |
|   32 | ADD A, R2       | 000100000100001 | A = A + R2 (próximo múltiplo)       |
|   33 | SW A, R0        | 000100000001011 | RAM[A] = 0 (marca não-primo)        |
|   34 | MV R6, A        | 000011010000100 | R6 = A                              |
|   35 | SUB A, R5       | 000100001010010 | A = R5 - A                          |
|   36 | BEQ 2           | 000000000100111 | Se >= limite, proximo_endereco_ram  |
|   37 | JMP 31          | 000000111110110 | Senão, prox_multiplo                |
|   38 | MV A, R2        | 000100000100100 | proximo_endereco_ram: A = R2        |
|   39 | ADD A, R1       | 000100000010001 | A = A + 1                           |
|   40 | MV R2, A        | 000001010000100 | R2 = A (próximo candidato)          |
|   41 | SUB A, R3       | 000100000110010 | A = R3 - A                          |
|   42 | BEQ 2           | 000000000100111 | Se >= R3, fim_loop_crivo            |
|   43 | JMP 24          | 000000110000110 | Senão, inicio_loop_crivo            |
|   44 | NOP             | 000000000000000 | fim_loop_crivo                      |
