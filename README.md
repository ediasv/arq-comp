<!-- markdownlint-disable MD013 -->

# Documentação do Microprocessador

Este documento descreve a arquitetura e o funcionamento do microprocessador
desenvolvido para o projeto.

---

## Arquitetura do Microprocessador

### Características Gerais

- **ULA**: Implementada com acumulador
- **Banco de Registradores**: 8 registradores de propósito geral + Acumulador
- **Tamanho da Instrução**: 15 bits
- **ROM**: Síncrona

### Mapeamento de Registradores

| Registrador | Código Binário  | Descrição                        |
| :---------- | :-------------: | :------------------------------- |
| **R0 - R7** | `0000` a `0111` | Registradores de Propósito Geral |
| **ACC**     |     `1000`      | Acumulador                       |

### Flags (PSW)

As flags são atualizadas apenas por operações aritméticas na ULA
(`ADD`, `SUB`, `SUBI`). Instruções de movimentação
(`MV`, `LD`, `LW`, `SW`) **não** alteram as flags.

- **Z (Zero):** Setado quando o resultado da ULA é zero. (Afeta: `BEQ`)
- **V (Overflow):** Setado quando há estouro em soma/subtração com sinal.
  (Afeta: `BVS`)
- **N (Negative):** Setado quando o bit mais significativo do resultado é 1.
  (Afeta: `BLT`)

### Operações Suportadas

- **Carga de Constantes**: Via instrução LD (sem somar)
- **Soma**: Sempre entre um registrador e o acumulador (não suporta soma com constantes)
- **Subtração**: Entre um registrador e o acumulador ou com constantes
- **Saltos Condicionais**: BEQ (Branch if Equal), BVS (Branch if Overflow Set) e
  BLT (Branch if Less Than)
- **Não há instruções exclusivas de comparação**

---

## Formato das Instruções

As instruções têm 15 bits e podem ser dos formatos:

- **Formato S**: **S**em constante (operações entre registradores)
- **Formato C**: **C**om constante ou salto

### Formato S (Standard/Register)

| 14..12 |       11..8 (A)       |  7..4 (B)   | 3..0 (Opcode) |
| :----: | :-------------------: | :---------: | :-----------: |
| `000`  | **Destino / Fonte 1** | **Fonte 2** |  **Opcode**   |

### Formato C (Constant/Control)

|       14..11 (A)       |    10..4 (Imediato)    | 3..0 (Opcode) |
| :--------------------: | :--------------------: | :-----------: |
| **Destino / Condição** | **Constante (7 bits)** |  **Opcode**   |

---

## Conjunto de Instruções

### Tabela de Instruções

| Mnemônico     | Opcode | Formato | Operação (RTL)              | Descrição              |
| :------------ | :----: | :-----: | :-------------------------- | :--------------------- |
| `NOP`         | `0000` |   N/A   | -                           | No Operation           |
| `ADD A, Rx`   | `0001` |    S    | `ACC <- ACC + Rx`           | Soma                   |
| `SUB A, Rx`   | `0010` |    S    | `ACC <- Rx - ACC`           | Subtração              |
| `SUBI A, Imm` | `0011` |    C    | `ACC <- Imm - ACC`          | Subtração Imediata     |
| `MV Rd, Rs`   | `0100` |    S    | `Rd <- Rs`                  | Movimentação           |
| `LD Rd, Imm`  | `0101` |    C    | `Rd <- Imm`                 | Carga Imediata         |
| `JMP Addr`    | `0110` |    C    | `PC <- Addr`                | Salto Incondicional    |
| `BEQ Offset`  | `0111` |    C    | `if Z=1, PC <- PC + Offset` | Branch if Equal        |
| `BVS Offset`  | `1000` |    C    | `if V=1, PC <- PC + Offset` | Branch if Overflow Set |
| `BLT Offset`  | `1001` |    C    | `if N=1, PC <- PC + Offset` | Branch if Less Than    |
| `LW Rd, ACC`  | `1010` |    S    | `Rd <- RAM[ACC]`            | Load Word              |
| `SW Rs, ACC`  | `1011` |    S    | `RAM[ACC] <- Rs`            | Store Word             |

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

### LW RD, ACC

**Descrição**: Carrega (Load Word) o valor armazenado na RAM no endereço contido
no Acumulador (ACC) e armazena no registrador de destino (RD).

- **Opcode**: `1010`
- **Formato**: S
- **Operandos**: Registrador de destino (RD) e Acumulador (Implícito como ponteiro)

**Sintaxe**: `LW RD, ACC`

**Operação**: `RD = RAM[ACC]`

**Exemplo**:

```asm
LD ACC, 10   ; ACC = 10 (endereço da RAM)
LW R5, ACC   ; R5 = RAM[10]
```

---

### SW RS, ACC

**Descrição**: Armazena (Store Word) o valor contido no registrador fonte (RS)
na RAM no endereço contido no Acumulador (ACC).

- **Opcode**: `1011`
- **Formato**: S
- **Operandos**: Registrador fonte (RS) e Acumulador (Implícito como ponteiro)

**Sintaxe**: `SW RS, ACC`

**Operação**: `RAM[ACC] = RS`

**Exemplo**:

```asm
LD R4, 42    ; R4 = 42
LD ACC, 10   ; ACC = 10 (endereço)
SW R4, ACC   ; RAM[10] = 42
```
