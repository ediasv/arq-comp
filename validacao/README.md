# Validação (Entrega Final)

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

```

---

## Resumo da Memória ROM

| Endereço | Instrução Assembly | Código Binário  |
| -------- | ------------------ | --------------- |
| 0        | LD R0, 3           | 000000000110101 |
| 1        | LD R1, 100         | 000111001000101 |
| 2        | SW R1, R0          | 000000100001011 |
| 3        | LD R2, 17          | 001000100010101 |
| 4        | LD R3, 89          | 001110110010101 |
| 5        | SW R3, R2          | 000001100101011 |
| 6        | LD R4, 42          | 010001010100101 |
| 7        | LD R5, 95          | 010110111110101 |
| 8        | SW R5, R4          | 000010101001011 |
| 9        | LD R6, 89          | 011010110010101 |
| 10       | LD R7, 31          | 011100111110101 |
| 11       | SW R7, R6          | 000011101101011 |
| 12       | LD R0, 120         | 000011110000101 |
| 13       | LD R1, 29          | 000100111010101 |
| 14       | SW R1, R0          | 000000100001011 |
| 15       | LD R0, 50          | 000001100100101 |
| 16       | LD R1, 25          | 000100110010101 |
| 17       | MV A, R0           | 000100000000100 |
| 18       | ADD A, R1          | 000100000010001 |
| 19       | MV R2, A           | 000001010000100 |
| 20       | LD R3, 10          | 001100010100101 |
| 21       | MV A, R2           | 000100000100100 |
| 22       | SUB A, R3          | 000100000110010 |
| 23       | MV R4, A           | 000010010000100 |
| 24       | LD R0, 3           | 000000000110101 |
| 25       | LW R5, R0          | 000010100001010 |
| 26       | LD R1, 17          | 000100100010101 |
| 27       | LW R6, R1          | 000011000011010 |
| 28       | LD R2, 42          | 001001010100101 |
| 29       | LW R7, R2          | 000011100101010 |
| 30       | LD R4, 89          | 010010110010101 |
| 31       | LW R3, R4          | 000001101001010 |
| 32       | LD R1, 120         | 000111110000101 |
| 33       | LW R0, R1          | 000000000011010 |
