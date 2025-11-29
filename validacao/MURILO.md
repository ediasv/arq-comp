### 2.2 Assembly

```asm
; Teste 1: Operações Aritméticas Básicas
LD R1, 7          ; R1 = 7
NOP               ; No operation
LD R6, 5          ; R6 = 5
ADD A, R6         ; ACC = 0 + 5 = 5
SUB A, R1         ; ACC = 5 - 7 = -2
SUBI A, 7         ; ACC = 7 - (-2) = 9
MV R2, A          ; R2 = 9
NOP               ; No operation

; Teste 2: Branch Condicional (BEQ)
LD R4, 5          ; R4 = 5
SUB A, R4         ; ACC = 9 - 5 = 4 (Z = 0, não salta)
BEQ 2             ; Se Z=1, salta +2 (não salta neste caso)

; Teste 3: Acumulação com Overflow (BVS)
LD R7, 127        ; R7 = 127
MV A, R7          ; ACC = 127
ADD A, R7         ; ACC = 254
MV R7, A          ; R7 = 254
ADD A, R7         ; ACC = 508
MV R7, A          ; R7 = 508
ADD A, R7         ; ACC = 1016
MV R7, A          ; R7 = 1016
ADD A, R7         ; ACC = 2032
MV R7, A          ; R7 = 2032
ADD A, R7         ; ACC = 4064
MV R7, A          ; R7 = 4064
ADD A, R7         ; ACC = 8128
MV R7, A          ; R7 = 8128
ADD A, R7         ; ACC = 16256
MV R7, A          ; R7 = 16256
ADD A, R7         ; ACC = 32512
MV R7, A          ; R7 = 32512
ADD A, R7         ; ACC = 65024 (OVERFLOW!)
BVS 6             ; Se V=1, salta +6 (salta para endereço 37)

; Teste 4: Escrita e Leitura na RAM (SW e LW)
LD R0, 3          ; R0 = 3 (endereço)
MV A, R0          ; ACC = 3
LD R1, 100        ; R1 = 100 (valor)
SW A, R1          ; RAM[3] = 100 (escreve)

LD R5, A          ; [ERRO: deveria ser LW R5, A]
LW R5, A          ; R5 = RAM[ACC] = RAM[3] = 100 (lê)
JMP 10            ; Salta para endereço 10
```

### 2.3 Codificação Binária

#### Endereço 0: LD R1, 7

- **Formato**: C
- **Opcode**: 0101
- **A**: 0001 (R1)
- **I**: 0000111 (7)
- **Binário**: `0001_0000111_0101`

#### Endereço 1: NOP

- **Formato**: N/A
- **Opcode**: 0000
- **Binário**: `000_0000_0000_0000`

#### Endereço 2: LD R6, 5

- **Formato**: C
- **Opcode**: 0101
- **A**: 0110 (R6)
- **I**: 0000101 (5)
- **Binário**: `0110_0000101_0101`

#### Endereço 3: ADD A, R6

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0110 (R6)
- **Binário**: `000_1000_0110_0001`

#### Endereço 4: SUB A, R1

- **Formato**: S
- **Opcode**: 0010
- **A**: 1000 (ACC)
- **B**: 0001 (R1)
- **Binário**: `000_1000_0001_0010`

#### Endereço 5: SUBI A, 7

- **Formato**: C
- **Opcode**: 0011
- **A**: 1000 (ACC)
- **I**: 0000111 (7)
- **Binário**: `1000_0000111_0011`

#### Endereço 6: MV R2, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0010 (R2)
- **B**: 1000 (ACC)
- **Binário**: `000_0010_1000_0100`

#### Endereço 7: NOP

- **Formato**: N/A
- **Opcode**: 0000
- **Binário**: `000_0000_0000_0000`

#### Endereço 8: LD R4, 5

- **Formato**: C
- **Opcode**: 0101
- **A**: 0100 (R4)
- **I**: 0000101 (5)
- **Binário**: `0100_0000101_0101`

#### Endereço 9: SUB A, R4

- **Formato**: S
- **Opcode**: 0010
- **A**: 1000 (ACC)
- **B**: 0100 (R4)
- **Binário**: `000_1000_0100_0010`

#### Endereço 10: BEQ 2

- **Formato**: C
- **Opcode**: 0111
- **A**: 0000 (Não usado)
- **I**: 0000010 (2)
- **Binário**: `0000_0000010_0111`

#### Endereço 12: LD R7, 127

- **Formato**: C
- **Opcode**: 0101
- **A**: 0111 (R7)
- **I**: 1111111 (127)
- **Binário**: `0111_1111111_0101`

#### Endereço 13: MV A, R7

- **Formato**: S
- **Opcode**: 0100
- **A**: 1000 (ACC)
- **B**: 0111 (R7)
- **Binário**: `000_1000_0111_0100`

#### Endereço 14: ADD A, R7

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0111 (R7)
- **Binário**: `000_1000_0111_0001`

#### Endereço 15: MV R7, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0111 (R7)
- **B**: 1000 (ACC)
- **Binário**: `000_0111_1000_0100`

#### Endereço 16: ADD A, R7

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0111 (R7)
- **Binário**: `000_1000_0111_0001`

#### Endereço 17: MV R7, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0111 (R7)
- **B**: 1000 (ACC)
- **Binário**: `000_0111_1000_0100`

#### Endereço 18: ADD A, R7

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0111 (R7)
- **Binário**: `000_1000_0111_0001`

#### Endereço 19: MV R7, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0111 (R7)
- **B**: 1000 (ACC)
- **Binário**: `000_0111_1000_0100`

#### Endereço 20: ADD A, R7

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0111 (R7)
- **Binário**: `000_1000_0111_0001`

#### Endereço 21: MV R7, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0111 (R7)
- **B**: 1000 (ACC)
- **Binário**: `000_0111_1000_0100`

#### Endereço 22: ADD A, R7

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0111 (R7)
- **Binário**: `000_1000_0111_0001`

#### Endereço 23: MV R7, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0111 (R7)
- **B**: 1000 (ACC)
- **Binário**: `000_0111_1000_0100`

#### Endereço 24: ADD A, R7

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0111 (R7)
- **Binário**: `000_1000_0111_0001`

#### Endereço 25: MV R7, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0111 (R7)
- **B**: 1000 (ACC)
- **Binário**: `000_0111_1000_0100`

#### Endereço 26: ADD A, R7

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0111 (R7)
- **Binário**: `000_1000_0111_0001`

#### Endereço 27: MV R7, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0111 (R7)
- **B**: 1000 (ACC)
- **Binário**: `000_0111_1000_0100`

#### Endereço 28: ADD A, R7

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0111 (R7)
- **Binário**: `000_1000_0111_0001`

#### Endereço 29: MV R7, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0111 (R7)
- **B**: 1000 (ACC)
- **Binário**: `000_0111_1000_0100`

#### Endereço 30: ADD A, R7

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0111 (R7)
- **Binário**: `000_1000_0111_0001`

#### Endereço 31: BVS 6

- **Formato**: C
- **Opcode**: 1000
- **A**: 0000 (Não usado)
- **I**: 0000110 (6)
- **Binário**: `0000_0000110_1000`

#### Endereço 37: LD R0, 3

- **Formato**: C
- **Opcode**: 0101
- **A**: 0000 (R0)
- **I**: 0000011 (3)
- **Binário**: `0000_0000011_0101`

#### Endereço 38: MV A, R0

- **Formato**: S
- **Opcode**: 0100
- **A**: 1000 (ACC)
- **B**: 0000 (R0)
- **Binário**: `000_1000_0000_0100`

#### Endereço 39: LD R1, 100

- **Formato**: C
- **Opcode**: 0101
- **A**: 0001 (R1)
- **I**: 1100100 (100)
- **Binário**: `0001_1100100_0101`

#### Endereço 40: SW A, R1

- **Formato**: S
- **Opcode**: 1011
- **A**: 1000 (ACC)
- **B**: 0001 (R1)
- **Binário**: `000_1000_0001_1011`

#### Endereço 41: LW R5, A

- **Formato**: S
- **Opcode**: 1010
- **A**: 0101 (R5)
- **B**: 1000 (ACC)
- **Binário**: `000_0101_1000_1010`

#### Endereço 42: JMP 10

- **Formato**: C
- **Opcode**: 0110
- **A**: 0000 (Não usado)
- **I**: 0001010 (10)
- **Binário**: `0000_0001010_0110`

### 2.4 Resumo da Memória ROM

| Endereço | Instrução Assembly | Código Binário       |
| -------- | ------------------ | -------------------- |
| 0        | LD R1, 7           | `0001_0000111_0101`  |
| 1        | NOP                | `000_0000_0000_0000` |
| 2        | LD R6, 5           | `0110_0000101_0101`  |
| 3        | ADD A, R6          | `000_1000_0110_0001` |
| 4        | SUB A, R1          | `000_1000_0001_0010` |
| 5        | SUBI A, 7          | `1000_0000111_0011`  |
| 6        | MV R2, A           | `000_0010_1000_0100` |
| 7        | NOP                | `000_0000_0000_0000` |
| 8        | LD R4, 5           | `0100_0000101_0101`  |
| 9        | SUB A, R4          | `000_1000_0100_0010` |
| 10       | BEQ 2              | `0000_0000010_0111`  |
| 12       | LD R7, 127         | `0111_1111111_0101`  |
| 13       | MV A, R7           | `000_1000_0111_0100` |
| 14       | ADD A, R7          | `000_1000_0111_0001` |
| 15       | MV R7, A           | `000_0111_1000_0100` |
| 16       | ADD A, R7          | `000_1000_0111_0001` |
| 17       | MV R7, A           | `000_0111_1000_0100` |
| 18       | ADD A, R7          | `000_1000_0111_0001` |
| 19       | MV R7, A           | `000_0111_1000_0100` |
| 20       | ADD A, R7          | `000_1000_0111_0001` |
| 21       | MV R7, A           | `000_0111_1000_0100` |
| 22       | ADD A, R7          | `000_1000_0111_0001` |
| 23       | MV R7, A           | `000_0111_1000_0100` |
| 24       | ADD A, R7          | `000_1000_0111_0001` |
| 25       | MV R7, A           | `000_0111_1000_0100` |
| 26       | ADD A, R7          | `000_1000_0111_0001` |
| 27       | MV R7, A           | `000_0111_1000_0100` |
| 28       | ADD A, R7          | `000_1000_0111_0001` |
| 29       | MV R7, A           | `000_0111_1000_0100` |
| 30       | ADD A, R7          | `000_1000_0111_0001` |
| 31       | BVS 6              | `0000_0000110_1000`  |
| 37       | LD R0, 3           | `0000_0000011_0101`  |
| 38       | MV A, R0           | `000_1000_0000_0100` |
| 39       | LD R1, 100         | `0001_1100100_0101`  |
| 40       | SW A, R1           | `000_1000_0001_1011` |
| 41       | LW R5, A           | `000_0101_1000_1010` |
| 42       | JMP 10             | `0000_0001010_0110`  |
