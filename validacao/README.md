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
    MV R2, A  ; 000 0010 1000 0100
    ; agora tem 768 em R2

    LD A, 12   ; 1000 0001100 0101
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
    MV ACC, R1  ; 000 1000 0001  0100

    ; subtrai R2 - ACC (R1)
    SUB ACC, R2  ; 000 1000 0010  0010

    ; se R1 = R2, fim do loop (zero = '1') (soma 2 no pc)
    BEQ fim_carrega_ram ; 0000 00000010 0111

    ; jump incondicional para carrega_ram
    JMP 3       ; 0000 0000011 0110

fim_carrega_ram:
    ; percorrer a ram de 2 até 27, tirando os multiplos
    ; desde que o multiplo seja menor que 773
    ; basicamente um loop aninhado
    ; loop externo de 0 ate 773
```

### 2.3 Codificação Binária

#### Endereço 0: LD R1, 2

- **Formato**: C
- **Opcode**: 0101
- **A**: 0001 (R1)
- **I**: 0000010 (2)
- **Binário**: `0001_0000010_0101`

#### Endereço 1: LD R2, 127

- **Formato**: C
- **Opcode**: 0101
- **A**: 0010 (R2)
- **I**: 1111111 (127)
- **Binário**: `0010_1111111_0101`

#### Endereço 2: MV A, R2

- **Formato**: S
- **Opcode**: 0100
- **A**: 1000 (ACC)
- **B**: 0010 (R2)
- **Binário**: `000_1000_0010_0100`

#### Endereço 3: ADD A, R2

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0010 (R2)
- **Binário**: `000_1000_0010_0001`

#### Endereço 4: MV R2, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0010 (R2)
- **B**: 1000 (ACC)
- **Binário**: `000_0010_1000_0100`

#### Endereço 5: ADD A, R2

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0010 (R2)
- **Binário**: `000_1000_0010_0001`

#### Endereço 6: ADD A, R2

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0010 (R2)
- **Binário**: `000_1000_0010_0001`

#### Endereço 7: MV R2, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0010 (R2)
- **B**: 1000 (ACC)
- **Binário**: `000_0010_1000_0100`

#### Endereço 8: LD A, 12

- **Formato**: C
- **Opcode**: 1100
- **A**: 1000 (ACC)
- **I**: 0001100 (6)
- **Binário**: `1000_0001100_0101`

#### Endereço 9: ADD A, R2

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0010 (R2)
- **Binário**: `000_1000_0010_0001`

#### Endereço 10: MV R2, A

- **Formato**: S
- **Opcode**: 0100
- **A**: 0010 (R2)
- **B**: 1000 (ACC)
- **Binário**: `000_0010_1000_0100`

#### Endereço 11: LD R7, 1

- **Formato**: C
- **Opcode**: 0101
- **A**: 0111 (R7)
- **I**: 0000001 (1)
- **Binário**: `0111_0000001_0101`

#### Endereço 12: MV ACC, R1

- **Formato**: S
- **Opcode**: 0100
- **A**: 1000 (ACC)
- **B**: 0001 (R1)
- **Binário**: `000_1000_0001_0100`

#### Endereço 13: SW ACC, R7

- **Formato**: S
- **Opcode**: 1011
- **A**: 1000 (ACC - Ponteiro)
- **B**: 0111 (R7 - Fonte)
- **Binário**: `000_1000_0111_1011`

#### Endereço 14: ADD ACC, R7

- **Formato**: S
- **Opcode**: 0001
- **A**: 1000 (ACC)
- **B**: 0111 (R7)
- **Binário**: `000_1000_0111_0001`

#### Endereço 15: MV R1, ACC

- **Formato**: S
- **Opcode**: 0100
- **A**: 0001 (R1)
- **B**: 1000 (ACC)
- **Binário**: `000_0001_1000_0100`

#### Endereço 16: MV ACC, R1

- **Formato**: S
- **Opcode**: 0100
- **A**: 1000 (ACC)
- **B**: 0001 (R1)
- **Binário**: `000_1000_0001_0100`

#### Endereço 17: SUB ACC, R2

- **Formato**: S
- **Opcode**: 0010
- **A**: 1000 (ACC)
- **B**: 0010 (R2)
- **Binário**: `000_1000_0010_0010`

#### Endereço 18: BEQ 2

- **Formato**: C
- **Opcode**: 0111
- **A**: 0000 (Não usado)
- **I**: 0000010 (2)
- **Binário**: `0000_0000010_0111`

#### Endereço 19: JMP 12

- **Formato**: C
- **Opcode**: 0110
- **A**: 0000 (Não usado)
- **I**: 0001100 (12)
- **Binário**: `0000_0001100_0110`

#### Endereço 20: NOP

- **Formato**: N/A
- **Opcode**: 0000
- **Binário**: `000_0000_0000_0000`

### 2.4 Resumo da Memória ROM para o Crivo de Eratóstenes

| Endereço | Instrução Assembly | Código Binário  | Comentário                    |
| -------- | ------------------ | --------------- | ----------------------------- |
| 0        | LD R1, 2           | 000100000100101 | Inicializa contador           |
| 1        | LD R2, 127         | 001011111110101 | Carrega 127 em R2             |
| 2        | MV A, R2           | 000100000100100 | A = R2 (127)                  |
| 3        | ADD A, R2          | 000100000100001 | A = 127 + 127 = 254           |
| 4        | MV R2, A           | 000001010000100 | R2 = 254                      |
| 5        | ADD A, R2          | 000100000100001 | A = 254 + 254 = 508           |
| 6        | ADD A, R2          | 000100000100001 | A = 508 + 254 = 762           |
| 7        | MV R2, A           | 000001010000100 | R2 = 762                      |
| 8        | LD A, 6            | 100000001100101 | A = 12                         |
| 9        | ADD A, R2          | 000100000100001 | A = 12 + 762 = 774             |
| 10       | MV R2, A           | 000001010000100 | R2 = 774 (limite)             |
| 11       | LD R7, 1           | 011100000010101 | R7 = 1 (incremento)           |
| 12       | MV ACC, R1         | 000100000010100 | ACC = R1 (endereço)           |
| 13       | SW ACC, R7         | 000100001111011 | RAM[ACC] = R7                 |
| 14       | ADD ACC, R7        | 000100001110001 | ACC = ACC + 1                 |
| 15       | MV R1, ACC         | 000000110000100 | R1 = ACC (atualiza contador)  |
| 16       | MV ACC, R1         | 000100000010100 | ACC = R1                      |
| 17       | SUB ACC, R2        | 000100000100010 | ACC = R1 - R2                 |
| 18       | BEQ 2              | 000000000100111 | Se R1 = R2, pula 2 instruções |
| 19       | JMP 12             | 000000011000110 | Volta para carrega_ram        |
| 20       | NOP                | 000000000000000 | Fim                           |
