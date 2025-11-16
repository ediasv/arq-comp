# Programa de Teste (Lab 7)

## Objetivo

Testar a funcionalidade de leitura e escrita da RAM com dados variados,
endereços espaçados e evitando falsos positivos.

## Estratégia de Teste

1. **Escritas espaçadas**: Dados em endereços não sequenciais (3, 17, 42, 89, 120)
2. **Dados variados**: Valores diferentes dos endereços para evitar falso positivo
3. **Leituras não subsequentes**: Fazer todas as escritas primeiro, depois
   todas as leituras
4. **Uso de registradores distintos**: Cada operação usa registradores diferentes
5. **Valores embaralhados**: Dados aleatórios sem padrão óbvio

---

## Implementação do Programa

### Assembly

```asm
;  ====================================
; FASE 1: ESCRITAS NA RAM
; Escrever valores variados em endereços espaçados
; ====================================

; --- Escrita 1: RAM[3] = 100 ---
    LD   R0, 3        ; R0 = 3 (endereço)
    LD   R1, 100      ; R1 = 100 (dado != endereço)
    SW   R1, R0       ; RAM[3] = 100

; --- Escrita 2: RAM[17] = 89 ---
    LD   R2, 17       ; R2 = 17 (endereço)
    LD   R3, 89       ; R3 = 89 (dado != endereço)
    SW   R3, R2       ; RAM[17] = 89

; --- Escrita 3: RAM[42] = 95 ---
    LD   R4, 42       ; R4 = 42 (endereço)
    LD   R5, 95      ; R5 = 95 (dado != endereço)
    SW   R5, R4       ; RAM[42] = 95

; --- Escrita 4: RAM[89] = 31 ---
    LD   R6, 89       ; R6 = 89 (endereço)
    LD   R7, 31       ; R7 = 31 (dado != endereço)
    SW   R7, R6       ; RAM[89] = 31

; --- Escrita 5: RAM[120] =29 ---
    LD   R0, 120      ; R0 = 120 (endereço - reutiliza R0)
    LD   R1,29      ; R1 =29 (dado != endereço)
    SW   R1, R0       ; RAM[120] =29

; ====================================
; FASE 2: OPERAÇÕES INTERMEDIÁRIAS
; Fazer operações com a ULA para "sujar" os registradores
; Evita falso positivo de valores remanescentes
; ====================================

    LD   R0, 50       ; R0 = 50
    LD   R1, 25       ; R1 = 25
    MV   A, R0        ; A = 50
    ADD  A, R1        ; A = 75
    MV   R2, A        ; R2 = 75

    LD   R3, 10       ; R3 = 10
    MV   A, R2        ; A = 75
    SUB  A, R3        ; A = 75 - 10 = 65
    MV   R4, A        ; R4 = 65

; ====================================
; FASE 3: LEITURAS DA RAM
; Ler os valores escritos anteriormente
; Usar registradores diferentes para cada leitura
; ====================================

; --- Leitura 1: R5 = RAM[3] (deve ser 100) ---
    LD   R0, 3        ; R0 = 3 (endereço)
    LW   R5, R0       ; R5 = RAM[3] = 100

; --- Leitura 2: R6 = RAM[17] (deve ser 89) ---
    LD   R1, 17       ; R1 = 17 (endereço)
    LW   R6, R1       ; R6 = RAM[17] = 89

; --- Leitura 3: R7 = RAM[42] (deve ser 95) ---
    LD   R2, 42       ; R2 = 42 (endereço)
    LW   R7, R2       ; R7 = RAM[42] = 95

; --- Leitura 4: R3 = RAM[89] (deve ser 31) ---
    LD   R4, 89       ; R4 = 89 (endereço)
    LW   R3, R4       ; R3 = RAM[89] = 31

; --- Leitura 5: R0 = RAM[120] (deve ser29) ---
    LD   R1, 120      ; R1 = 120 (endereço)
    LW   R0, R1       ; R0 = RAM[120] =29
```

---

### Codificação Binária

#### Endereço 0: LD R0, 3

- **Formato**: C
- **Opcode**: 0101
- **A**: 0000 (R0)
- **I**: 0000011 (3)
- **Binário**: `0000_0000011_0101`

#### Endereço 1: LD R1, 100

- **Formato**: C
- **Opcode**: 0101
- **A**: 0001 (R1)
- **I**: 1100100 (100)
- **Binário**: `0001_1100100_0101`

#### Endereço 2: SW R1, R0

- **Formato**: S
- **Opcode**: 1011
- **A**: 0001 (R1 - registrador fonte)
- **B**: 0000 (R0 - registrador ponteiro)
- **Binário**: `000_0001_0000_1011`

#### Endereço 3: LD R2, 17

- **Formato**: C
- **Opcode**: 0101
- **A**: 0010 (R2)
- **I**: 0010001 (17)
- **Binário**: `0010_0010001_0101`

#### Endereço 4: LD R3, 89

- **Formato**: C
- **Opcode**: 0101
- **A**: 0011 (R3)
- **I**: 1011001 (89)
- **Binário**: `0011_1011001_0101`

#### Endereço 5: SW R3, R2

- **Formato**: S
- **Opcode**: 1011
- **A**: 0011 (R3 - registrador fonte)
- **B**: 0010 (R2 - registrador ponteiro)
- **Binário**: `000_0011_0010_1011`

#### Endereço 6: LD R4, 42

- **Formato**: C
- **Opcode**: 0101
- **A**: 0100 (R4)
- **I**: 0101010 (42)
- **Binário**: `0100_0101010_0101`

#### Endereço 7: LD R5, 95

- **Formato**: C
- **Opcode**: 0101
- **A**: 0101 (R5)
- **I**: 1011111 (95)
- **Binário**: `0101_1011111_0101`

#### Endereço 8: SW R5, R4

- **Formato**: S
- **Opcode**: 1011
- **A**: 0101 (R5 - registrador fonte)
- **B**: 0100 (R4 - registrador ponteiro)
- **Binário**: `000_0101_0100_1011`

#### Endereço 9: LD R6, 89

- **Formato**: C
- **Opcode**: 0101
- **A**: 0110 (R6)
- **I**: 1011001 (89)
- **Binário**: `0110_1011001_0101`

#### Endereço 10: LD R7, 31

- **Formato**: C
- **Opcode**: 0101
- **A**: 0111 (R7)
- **I**: 0011111 (31)
- **Binário**: `0111_0011111_0101`

#### Endereço 11: SW R7, R6

- **Formato**: S
- **Opcode**: 1011
- **A**: 0111 (R7 - registrador fonte)
- **B**: 0110 (R6 - registrador ponteiro)
- **Binário**: `000_0111_0110_1011`

#### Endereço 12: LD R0, 120

- **Formato**: C
- **Opcode**: 0101
- **A**: 0000 (R0)
- **I**: 1111000 (120)
- **Binário**: `0000_1111000_0101`

#### Endereço 13: LD R1, 29

- **Formato**: C
- **Opcode**: 0101
- **A**: 0001 (R1)
- **I**: 0011101 (29)
- **Binário**: `0001_0011101_0101`

#### Endereço 14: SW R1, R0

- **Formato**: S
- **Opcode**: 1011
- **A**: 0001 (R1 - registrador fonte)
- **B**: 0000 (R0 - registrador ponteiro)
- **Binário**: `000_0001_0000_1011`

#### Endereço 15: LD R0, 50

- **Formato**: C
- **Opcode**: 0101
- **A**: 0000 (R0)
- **I**: 0110010 (50)
- **Binário**: `0000_0110010_0101`

#### Endereço 16: LD R1, 25

- **Formato**: C
- **Opcode**: 0101
- **A**: 0001 (R1)
- **I**: 0011001 (25)
- **Binário**: `0001_0011001_0101`

#### Endereço 17: MV A, R0

- **Formato**: S
- **Opcode**: 0100
- **A**: 1000 (ACC)
- **B**: 0000 (R0)
- **Binário**: `000_1000_0000_0100`

#### Endereço 18: ADD A, R1

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0001 (R1)
- **Binário**: `000_1000_0001_0001`

#### Endereço 19: MV R2, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0010 (R2)
- **B**: 1000 (ACC)
- **Binário**: `000_0010_1000_0100`

#### Endereço 20: LD R3, 10

- **Formato**: C
- **Opcode**: 0101
- **A**: 0011 (R3)
- **I**: 0001010 (10)
- **Binário**: `0011_0001010_0101`

#### Endereço 21: MV A, R2

- **Formato**: S
- **Opcode**: 0100
- **A**: 1000 (ACC)
- **B**: 0010 (R2)
- **Binário**: `000_1000_0010_0100`

#### Endereço 22: SUB A, R3

- **Formato**: S
- **Opcode**: 0010
- **A**: 1000 (ACC)
- **B**: 0011 (R3)
- **Binário**: `000_1000_0011_0010`

#### Endereço 23: MV R4, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0100 (R4)
- **B**: 1000 (ACC)
- **Binário**: `000_0100_1000_0100`

#### Endereço 24: LD R0, 3

- **Formato**: C
- **Opcode**: 0101
- **A**: 0000 (R0)
- **I**: 0000011 (3)
- **Binário**: `0000_0000011_0101`

#### Endereço 25: LW R5, R0

- **Formato**: S
- **Opcode**: 1010
- **A**: 0101 (R5 - registrador destino)
- **B**: 0000 (R0 - registrador ponteiro)
- **Binário**: `000_0101_0000_1010`

#### Endereço 26: LD R1, 17

- **Formato**: C
- **Opcode**: 0101
- **A**: 0001 (R1)
- **I**: 0010001 (17)
- **Binário**: `0001_0010001_0101`

#### Endereço 27: LW R6, R1

- **Formato**: S
- **Opcode**: 1010
- **A**: 0110 (R6 - registrador destino)
- **B**: 0001 (R1 - registrador ponteiro)
- **Binário**: `000_0110_0001_1010`

#### Endereço 28: LD R2, 42

- **Formato**: C
- **Opcode**: 0101
- **A**: 0010 (R2)
- **I**: 0101010 (42)
- **Binário**: `0010_0101010_0101`

#### Endereço 29: LW R7, R2

- **Formato**: S
- **Opcode**: 1010
- **A**: 0111 (R7 - registrador destino)
- **B**: 0010 (R2 - registrador ponteiro)
- **Binário**: `000_0111_0010_1010`

#### Endereço 30: LD R4, 89

- **Formato**: C
- **Opcode**: 0101
- **A**: 0100 (R4)
- **I**: 1011001 (89)
- **Binário**: `0100_1011001_0101`

#### Endereço 31: LW R3, R4

- **Formato**: S
- **Opcode**: 1010
- **A**: 0011 (R3 - registrador destino)
- **B**: 0100 (R4 - registrador ponteiro)
- **Binário**: `000_0011_0100_1010`

#### Endereço 32: LD R1, 120

- **Formato**: C
- **Opcode**: 0101
- **A**: 0001 (R1)
- **I**: 1111000 (120)
- **Binário**: `0001_1111000_0101`

#### Endereço 33: LW R0, R1

- **Formato**: S
- **Opcode**: 1010
- **A**: 0000 (R0 - registrador destino)
- **B**: 0001 (R1 - registrador ponteiro)
- **Binário**: `000_0000_0001_1010`

## Resumo da Memória ROM

| Endereço | Instrução Assembly | Código Binário      |
| -------- | ------------------ | ------------------- |
| 0        | LD R0, 3           | 000000000110101     |
| 1        | LD R1, 100         | 000111001000101     |
| 2        | SW R1, R0          | 000000100001011     |
| 3        | LD R2, 17          | 001000100010101     |
| 4        | LD R3, 89          | 001110110010101     |
| 5        | SW R3, R2          | 000001100101011     |
| 6        | LD R4, 42          | 010001010100101     |
| 7        | LD R5, 95          | 010110111110101     |
| 8        | SW R5, R4          | 000010101001011     |
| 9        | LD R6, 89          | 011010110010101     |
| 10       | LD R7, 31          | 011100111110101     |
| 11       | SW R7, R6          | 000011101101011     |
| 12       | LD R0, 120         | 000011110000101     |
| 13       | LD R1, 29          | 000100111010101     |
| 14       | SW R1, R0          | 000000100001011     |
| 15       | LD R0, 50          | 000001100100101     |
| 16       | LD R1, 25          | 000100110010101     |
| 17       | MV A, R0           | 000100000000100     |
| 18       | ADD A, R1          | 000100000010001     |
| 19       | MV R2, A           | 000001010000100     |
| 20       | LD R3, 10          | 001100010100101     |
| 21       | MV A, R2           | 000100000100100     |
| 22       | SUB A, R3          | 000100000110010     |
| 23       | MV R4, A           | 000010010000100     |
| 24       | LD R0, 3           | 000000000110101     |
| 25       | LW R5, R0          | 000010100001010     |
| 26       | LD R1, 17          | 000100100010101     |
| 27       | LW R6, R1          | 000011000011010     |
| 28       | LD R2, 42          | 001001010100101     |
| 29       | LW R7, R2          | 000011100101010     |
| 30       | LD R4, 89          | 010010110010101     |
| 31       | LW R3, R4          | 000001101001010     |
| 32       | LD R1, 120         | 000111110000101     |
| 33       | LW R0, R1          | 000000000011010     |
