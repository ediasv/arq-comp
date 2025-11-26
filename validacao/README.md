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
    ; ========= Loop para carregar números de 2 a 32 na RAM =========

    ; carregar 2 no R1
    LD R1, 2

    ; carregar 32 no R2
    LD R2, 32

    ; carregar 1 no R7
    LD R7, 1

    ; carrega R1 na RAM no endereço (R1)
carrega_ram:
    MV ACC, R1
    SW ACC, R1

    ; soma 1 em R1
    ADD ACC, R7
    MV R1, ACC

    ; ---- verifica se R1 > R2 ----
    ; move R2 para ACC
    MV ACC, R2

    ; subtrai R1 - ACC
    SUB ACC, R1

    ; se R1 = R2, fim do loop
    BEQ fim_carrega_ram
    ; ------------------------------

    ; jump incondicional para carrega_ram

fim_carrega_ram:
    NOP
```

### 2.3 Codificação Binária

#### Endereço 0: LD R1, 2

- **Formato**: C
- **Opcode**: 0101
- **A**: 0001 (R1)
- **I**: 0000010 (2)
- **Binário**: `0001_0000010_0101`

#### Endereço 1: LD R2, 32

- **Formato**: C
- **Opcode**: 0101
- **A**: 0010 (R2)
- **I**: 0100000 (32)
- **Binário**: `0010_0100000_0101`

#### Endereço 2: LD R7, 1

- **Formato**: C
- **Opcode**: 0101
- **A**: 0111 (R7)
- **I**: 0000001 (1)
- **Binário**: `0111_0000001_0101`

#### Endereço 3: MV ACC, R1

- **Formato**: S
- **Opcode**: 0100
- **A**: 1000 (ACC)
- **B**: 0001 (R1)
- **Binário**: `000_1000_0001_0100`

#### Endereço 4: SW ACC, R1

- **Formato**: S
- **Opcode**: 1011
- **A**: 1000 (ACC - Fonte)
- **B**: 0001 (R1 - Ponteiro)
- **Binário**: `000_1000_0001_1011`

#### Endereço 5: ADD ACC, R7

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0111 (R7)
- **Binário**: `000_1000_0111_0001`

#### Endereço 6: MV R1, ACC

- **Formato**: S
- **Opcode**: 0100
- **A**: 0001 (R1)
- **B**: 1000 (ACC)
- **Binário**: `000_0001_1000_0100`

#### Endereço 7: MV ACC, R2

- **Formato**: S
- **Opcode**: 0100
- **A**: 1000 (ACC)
- **B**: 0010 (R2)
- **Binário**: `000_1000_0010_0100`

#### Endereço 8: SUB ACC, R1

- **Formato**: S
- **Opcode**: 0010
- **A**: 1000 (ACC)
- **B**: 0001 (R1)
- **Binário**: `000_1000_0001_0010`

#### Endereço 9: BEQ 2

- **Formato**: C
- **Opcode**: 0111
- **A**: 0000 (Não usado)
- **I**: 0000010 (2)
- **Binário**: `0000_0000010_0111`

#### Endereço 10: JMP 3

- **Formato**: C
- **Opcode**: 0110
- **A**: 0000 (Não usado)
- **I**: 0000011 (3)
- **Binário**: `0000_0000011_0110`

#### Endereço 11: NOP

- **Formato**: N/A
- **Opcode**: 0000
- **Binário**: `000_0000_0000_0000`

### 2.4 Resumo da Memória ROM para o Crivo de Eratóstenes

| Endereço | Instrução Assembly | Código Binário  |
| -------- | ------------------ | --------------- |
| 0        | LD R1, 2           | 000100000100101 |
| 1        | LD R2, 32          | 001001000000101 |
| 2        | LD R7, 1           | 011100000010101 |
| 3        | MV ACC, R1         | 000100000010100 |
| 4        | SW ACC, R1         | 000100000011011 |
| 5        | ADD ACC, R7        | 000100001110001 |
| 6        | MV R1, ACC         | 000000110000100 |
| 7        | MV ACC, R2         | 000100000100100 |
| 8        | SUB ACC, R1        | 000100000010010 |
| 9        | BEQ 2              | 000000000100111 |
| 10       | JMP 3              | 000000000110110 |
| 11       | NOP                | 000000000000000 |
