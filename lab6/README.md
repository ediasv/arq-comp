# Documentação do Microprocessador

Este documento descreve a arquitetura e o funcionamento do microprocessador
desenvolvido para o projeto.

---

## Arquitetura do Microprocessador

### Características Gerais

- **ULA**: Implementada com acumulador
- **Banco de Registradores**: 8 registradores (R0-R7)
- **Tamanho da Instrução**: 15 bits
- **ROM**: Síncrona

### Operações Suportadas

- **Carga de Constantes**: Via instrução LD (sem somar)
- **Soma**: Sempre entre um registrador e o acumulador (não suporta soma com constantes)
- **Subtração**: Entre um registrador e o acumulador ou com constantes
- **Saltos Condicionais**: BEQ (Branch if Equal) e BVS (Branch if Overflow Set)
- **Não há instruções exclusivas de comparação**

---

## Formato das Instruções

As instruções têm 15 bits e podem ser dos formatos:

- **Formato S**: **S**em constante (operações entre registradores)
- **Formato C**: **C**om constante ou salto incondicional

### Formato S

```asm
XXX AAAA BBBB OOOO
```

| Campo | Bits   | Descrição                                    |
| ----- | ------ | -------------------------------------------- |
| **X** | 3 bits | Reservado/Não utilizado                      |
| **A** | 4 bits | Número do primeiro registrador (R0-R7 + ACC) |
| **B** | 4 bits | Número do segundo registrador (R0-R7 + ACC)  |
| **O** | 4 bits | Opcode da instrução                          |

### Formato C

```asm
AAAA CCCCCCC OOOO
```

| Campo    | Bits   | Descrição                                         |
| -------- | ------ | ------------------------------------------------- |
| **A**    | 4 bits | Número do primeiro registrador (R0-R7 + ACC)      |
| **I**    | 7 bits | Valor imediato ou endereço do salto incondicional |
| **OOOO** | 4 bits | Opcode da instrução                               |

---

## Conjunto de Instruções

### Tabela de Instruções

| Instrução   | Opcode | Formato | Descrição                             |
| ----------- | ------ | ------- | ------------------------------------- |
| NOP         | `0000` | N/A     | Instrução sem operação                |
| ADD RX, A   | `0001` | S       | Soma registrador com acumulador       |
| SUB RX, A   | `0010` | S       | Subtrai acumulador de registrador     |
| SUBI I, A   | `0011` | C       | Subtrai acumulador de valor imediato  |
| MV RX, RY   | `0100` | S       | Move conteúdo entre registradores     |
| LD RX, I    | `0101` | C       | Carrega valor imediato em registrador |
| JMP ADDRESS | `0110` | C       | Salto incondicional                   |
| BEQ         | `0111` | C       | Salto condicional                     |
| BVS         | `1000` | C       | Salto condicional                     |
| BLT         | `1001` | C       | Salto condicional                     |

---

### NOP

**Descrição**: Instrução sem operação. Não executa nenhuma ação,
apenas consome um ciclo de clock.

- **Opcode**: `0000`
- **Formato**: N/A (sem operandos)

**Exemplo**:

```asm
NOP  ; Não faz nada
```

---

### ADD A, RX

**Descrição**: Soma o conteúdo de um registrador com o valor do acumulador
e armazena o resultado no acumulador.

- **Opcode**: `0001`
- **Formato**: S
- **Operandos**: Dois registradores (um deles é o acumulador)
- **Restrição**: Não há soma com constantes

**Sintaxe**: `ADD A, RX`

**Operação**: `A = RX + A`

**Exemplo**:

```asm
ADD A, R4  ; A = R4 + A
```

---

### SUB A, RX

**Descrição**: Subtrai do conteúdo de um registrador o valor do acumulador e
armazena o resultado no acumulador.

- **Opcode**: `0010`
- **Formato**: S
- **Operandos**: Dois registradores (um deles é o acumulador)

**Sintaxe**: `SUB A, RX`

**Operação**: `A = RX - A`

**Exemplo**:

```asm
SUB A, R3  ; A = R3 - A
```

---

### SUBI A, I

**Descrição**: Subtrai do valor imediato (constante) o valor do acumulador e
armazena o resultado no acumulador.

- **Opcode**: `0011`
- **Formato**: C
- **Operandos**: Acumulador e valor imediato de 7 bits

**Sintaxe**: `SUBI A, I`

**Operação**: `A = I - A`

**Exemplo**:

```asm
SUBI A, I  ; A = 1 - A
```

---

### MV RX, RY

**Descrição**: Move (copia) o conteúdo de um registrador para outro
registrador. RX recebe o valor de RY.

- **Opcode**: `0100`
- **Formato**: S
- **Operandos**: Dois registradores (destino e origem)

**Sintaxe**: `MV RX, RY`

**Operação**: `RX = RY`

**Exemplo**:

```asm
MV R5, R3  ; R5 = R3
```

---

### LD RX, I

**Descrição**: Carrega um valor imediato (constante) em um registrador.

- **Opcode**: `0101`
- **Formato**: C
- **Operandos**: Registrador de destino e valor imediato de 7 bits
- **Restrição**: Não realiza operações aritméticas, apenas carregamento

**Sintaxe**: `LD RX, I`

**Operação**: `RX = I`

**Exemplo**:

```asm
LD R3, 5  ; R3 = 5
```

---

### JMP ADDRESS

**Descrição**: Salto incondicional para um endereço da memória.

- **Opcode**: `0110`
- **Formato**: C
- **Operandos**: Endereço de destino de 7 bits

**Sintaxe**: `JMP ADDRESS`

**Operação**: `PC = ADDRESS`

**Exemplo**:

```asm
JMP 20  ; PC = 20
```

---

### BEQ OFST

**Descrição**: Salto condicional para um endereço relativo da memória se a flag
Zero (Z) estiver setada (igual a 1). Verifica se o resultado da última operação
da ULA foi zero.

- **Opcode**: `0111`
- **Formato**: C
- **Operandos**: Posição do endereço de destino em relação ao endereço atual
- **Condição**: `PC = PC + OFST when Z = '1' else PC + 1`

**Sintaxe**: `BEQ OFST`

**Operação**: `if (Z == 1) then PC = PC + OFST`

**Exemplo**:

```asm
SUB A, R3    ; A = R3 - A (atualiza flags)
BEQ 10       ; Se resultado foi zero, salta para endereço PC + 10
```

---

### BVS OFST

**Descrição**: Salto condicional para um endereço relativo da memória se a flag
Overflow (V) estiver setada (igual a 1). Verifica se houve overflow aritmético
na última operação da ULA.

- **Opcode**: `1000`
- **Formato**: C
- **Operandos**: Posição do endereço de destino em relação ao endereço atual
- **Condição**: `PC = PC + OFST when V = '1' else PC + 1`

**Sintaxe**: `BVS OFST`

**Operação**: `if (V == 1) then PC = PC + OFST`

**Exemplo**:

```asm
ADD A, R7    ; A = R7 + A (atualiza flags)
BVS -4       ; Se houve overflow, salta para PC - 4
```

---

### BLT OFST

**Descrição**: Salto condicional para um endereço relativo da memória se a flag
Negative (N) estiver setada (igual a 1). Verifica se o resultado da última
operação da ULA foi menor que zero.

- **Opcode**: `1001`
- **Formato**: C
- **Operandos**: Posição do endereço de destino em relação ao endereço atual
- **Condição**: `PC = PC + OFST when N = '1' else PC + 1`

**Sintaxe**: `BLT OFST`

**Operação**: `if (N == 1) then PC = PC + OFST`

**Exemplo**:

```asm
SUB A, R7    ; A = R7 - A (atualiza flags)
BLT -5       ; Se R7 < A, salta para PC - 5
```

---

## Programa de Teste (Lab 6)

### Objetivo

Implementar um programa na ROM que executa as seguintes operações em sequência:

### Pseudocódigo do Programa

| Passo | Descrição                                  | Endereço |
| ----- | ------------------------------------------ | -------- |
| A     | Carrega R3 com o valor 0                   | 0        |
| B     | Carrega R4 com o valor 0                   | 1        |
| C     | Soma R3 com R4 e guarda em R4              | 2-4      |
| D     | Soma 1 em R3                               | 5-8      |
| E     | Se R3<30 salta para a instrução do passo C | 9-12     |
| F     | Copia valor de R4 para R5                  | 13       |

## Implementação do Programa

### Assembly

```asm
; ====================================
; A: Carrega R3 com o valor 0
; ====================================
    LD  R3, 0

; ====================================
; B: Carrega R4 com o valor 0
; ====================================
    LD  R4, 0

; ====================================
; C: Soma R3 com R4 e guarda em R4
; ====================================
C:  MV   A, R3      ; A = R3
    ADD  A, R4      ; A = A + R4
    MV   R4, A      ; R4 = A

; ====================================
; D: Soma 1 em R3
; ====================================
    LD   R7, 1      ; R7 = 1
    MV   A, R7      ; A = R7
    ADD  A, R3      ; A = A + R3
    MV   R3, A      ; R3 = A

; ====================================
; E: Se R3 < 30 salta para a instrução do passo C
; ====================================
    LD   R7, 30     ; R7 = 30
    MV   A, R7      ; A = R7
    SUB  A, R3      ; A = R7 - R3
    BLT  -10        ; Se R7 < R3 (ou seja, R3 >= 30), não salta

; ====================================
; F: Copia valor de R4 para R5
; ====================================
    MV   R5, R4     ; R5 = R4
```

## Resumo da Memória ROM

| Endereço | Instrução Assembly | Código Binário  |
| -------- | ------------------ | --------------- |
| 0        | LD R3, 0           | 001100000000101 |
| 1        | LD R4, 0           | 010000000000101 |
| 2        | MV A, R3           | 000100000110100 |
| 3        | ADD A, R4          | 000100001000001 |
| 4        | MV A, R4           | 000010010000100 |
| 5        | LD R7, 1           | 011100000010101 |
| 6        | MV A, R7           | 000100001110100 |
| 7        | ADD A, R3          | 000100000110001 |
| 8        | MV R3, A           | 000001110000100 |
| 9        | LD, R7, 30         | 011100111100101 |
| 10       | MV A, R7           | 000100001110100 |
| 11       | SUB A, R3          | 000100000110010 |
| 12       | BLT -10            | 000011101101001 |
| 13       | MV R5, R4          | 000010101000100 |
