# Programa de Teste (Lab 7)

## Objetivo

Testar a funcionalidade de leitura e escrita da RAM com dados variados, endereços espaçados e evitando falsos positivos.

## Estratégia de Teste

1. **Escritas espaçadas**: Dados em endereços não sequenciais (3, 17, 42, 89, 120)
2. **Dados variados**: Valores diferentes dos endereços para evitar falso positivo
3. **Leituras não subsequentes**: Fazer todas as escritas primeiro, depois todas as leituras
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

; --- Escrita 1: RAM[3] = 157 ---
    LD   R0, 3        ; R0 = 3 (endereço)
    LD   R1, 157      ; R1 = 157 (dado != endereço)
    SW   R1, R0       ; RAM[3] = 157

; --- Escrita 2: RAM[17] = 89 ---
    LD   R2, 17       ; R2 = 17 (endereço)
    LD   R3, 89       ; R3 = 89 (dado != endereço)
    SW   R3, R2       ; RAM[17] = 89

; --- Escrita 3: RAM[42] = 203 ---
    LD   R4, 42       ; R4 = 42 (endereço)
    LD   R5, 203      ; R5 = 203 (dado != endereço)
    SW   R5, R4       ; RAM[42] = 203

; --- Escrita 4: RAM[89] = 31 ---
    LD   R6, 89       ; R6 = 89 (endereço)
    LD   R7, 31       ; R7 = 31 (dado != endereço)
    SW   R7, R6       ; RAM[89] = 31

; --- Escrita 5: RAM[120] = 255 ---
    LD   R0, 120      ; R0 = 120 (endereço - reutiliza R0)
    LD   R1, 255      ; R1 = 255 (dado != endereço)
    SW   R1, R0       ; RAM[120] = 255

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

; --- Leitura 1: R5 = RAM[3] (deve ser 157) ---
    LD   R0, 3        ; R0 = 3 (endereço)
    LW   R5, R0       ; R5 = RAM[3] = 157

; --- Leitura 2: R6 = RAM[17] (deve ser 89) ---
    LD   R1, 17       ; R1 = 17 (endereço)
    LW   R6, R1       ; R6 = RAM[17] = 89

; --- Leitura 3: R7 = RAM[42] (deve ser 203) ---
    LD   R2, 42       ; R2 = 42 (endereço)
    LW   R7, R2       ; R7 = RAM[42] = 203

; --- Leitura 4: R3 = RAM[89] (deve ser 31) ---
    LD   R4, 89       ; R4 = 89 (endereço)
    LW   R3, R4       ; R3 = RAM[89] = 31

; --- Leitura 5: R0 = RAM[120] (deve ser 255) ---
    LD   R1, 120      ; R1 = 120 (endereço)
    LW   R0, R1       ; R0 = RAM[120] = 255


---

```

## Resumo da Memória ROM

| Endereço | Instrução Assembly | Código Binário        |
| -------- | ------------------ | --------------------- |
| 0        | LD R0, 3           | 000 0000 0000011 0101 |
| 1        | LD R1, 157         | 000 0001 0011101 0101 |
| 2        | SW R1, R0          | 000 0001 0000 1011    |
| 3        | LD R2, 17          | 000 0010 0010001 0101 |
| 4        | LD R3, 89          | 000 0011 1011001 0101 |
| 5        | SW R3, R2          | 000 0011 0010 1011    |
| 6        | LD R4, 42          | 000 0100 0101010 0101 |
| 7        | LD R5, 203         | 000 0101 1001011 0101 |
| 8        | SW R5, R4          | 000 0101 0100 1011    |
| 9        | LD R6, 89          | 000 0110 1011001 0101 |
| 10       | LD R7, 31          | 000 0111 0011111 0101 |
| 11       | SW R7, R6          | 000 0111 0110 1011    |
| 12       | LD R0, 120         | 000 0000 1111000 0101 |
| 13       | LD R1, 255         | 000 0001 1111111 0101 |
| 14       | SW R1, R0          | 000 0001 0000 1011    |
| 15       | LD R0, 50          | 000 0000 0110010 0101 |
| 16       | LD R1, 25          | 000 0001 0011001 0101 |
| 17       | MV A, R0           | 000 1000 0000 0100    |
| 18       | ADD A, R1          | 000 1000 0001 0001    |
| 19       | MV R2, A           | 000 0010 1000 0100    |
| 20       | LD R3, 10          | 000 0011 0001010 0101 |
| 21       | MV A, R2           | 000 1000 0010 0100    |
| 22       | SUB A, R3          | 000 1000 0011 0010    |
| 23       | MV R4, A           | 000 0100 1000 0100    |
| 24       | LD R0, 3           | 000 0000 0000011 0101 |
| 25       | LW R5, R0          | 000 0101 0000 1010    |
| 26       | LD R1, 17          | 000 0001 0010001 0101 |
| 27       | LW R6, R1          | 000 0110 0001 1010    |
| 28       | LD R2, 42          | 000 0010 0101010 0101 |
| 29       | LW R7, R2          | 000 0111 0010 1010    |
| 30       | LD R4, 89          | 000 0100 1011001 0101 |
| 31       | LW R3, R4          | 000 0011 0100 1010    |
| 32       | LD R1, 120         | 000 0001 1111000 0101 |
| 33       | LW R0, R1          | 000 0000 0001 1010    |
