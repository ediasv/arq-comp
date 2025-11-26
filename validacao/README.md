# Validação (Entrega Final)

## Objetivo

Realizar uma bateria de testes para garantir que o processador funciona.

Os testes devem incluir:

1. Crivo de Eratóstenes.
2. Testar todas as instruções implementadas.

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

    ;

```

### Resumo da Memória ROM para o Crivo de Eratóstenes

| Endereço | Instrução Assembly | Código Binário  |
| -------- | ------------------ | --------------- |
| 0        | LD R1, 2           | 000100000100101 |
| 1        | LD R2, 32          | 001001000000101 |
