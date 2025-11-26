# Validação (Entrega Final)

## Objetivo

Realizar uma bateria de testes para garantir que o processador funciona.

Os testes devem incluir:

1. Crivo de Eratóstenes.
2. Testar todas as instruções implementadas.

Além disso é preciso implementar duas "complicações" adicionais. Elas são:

1.
2.

---

## Crivo de Eratóstenes

Vamos passar o limite superior de verificação. Isso significa que, se queremos
achar todos os primos até 37, já vamos passar 6 como o limite, vamos remover
todos os múltiplos de 2, 3, ..., $\lfloor \sqrt{37} \rfloor = 6$.

### Execução

1. Fazer um loop para carregar os números de 2 a 32 na memória RAM.
2. Carregar $\lfloor \sqrt{37} \rfloor = 6$ no R3 (limite para o crivo).

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

    ; se R1 = R2, fim do loop
    BEQ fim_carrega_ram

    ; jump incondicional para carrega_ram

fim_carrega_ram:
    NOP
```

### Resumo da Memória ROM para o Crivo de Eratóstenes

| Endereço | Instrução Assembly | Código Binário  |
| -------- | ------------------ | --------------- |
| 0        | LD R1, 2           | 000100000100101 |
| 1        | LD R2, 32          | 001001000000101 |
| 2        | LD R7, 1           | 011100000010101 |
| 3        | MV ACC, R1         | 000100000010100 |
| 4        | SW ACC, R1         | 000100000011011 |
| 5        | ADD ACC, R7        | 000100001110001 |
| 6        | MV R1, ACC         | 000000110000100 |
