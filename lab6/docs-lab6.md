# Programa de Teste (Lab 6)

## Objetivo

Implementar um programa na ROM que executa as seguintes operações em sequência:

## Pseudocódigo do Programa

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
