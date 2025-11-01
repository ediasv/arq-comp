# Documentação

## Especificações do Microprocessador

1. ULA com acumulador
2. 8 registradores no banco
3. Carga de constantes com LD, sem somar
4. Soma: sempre com dois operandos e apenas entre registradores (não somar com
   constantes)
5. Subtração: sempre com dois operandos e há subtração com constantes
6. Instruções de 15 bits
7. ROM síncrona
8. Registrador de instruções: wr_en ativo no primeiro estado (read)
9. Incremento do PC: PC+1 gravado entre o primeiro e segundo estado e jmp
   executado no último estado
10. Não há instruções exclusivas de comparação
11. Saltos condicionais: BEQ, BVS

## Requisito do lab 5

A ROM deve estar configurada para executar um programa que faz as seguintes ações:

A. Carrega R3 com o valor 5
B. Carrega R4 com 8
C. Soma R3 com R4 e guarda em R5
D. Subtrai 1 de R5
E. Salta para o endereço 20
F. Zera R5 (nunca será executada)
G. No endereço 20, copia R5 para R3
H. Salta para o passo C desta lista (R5 <= R3+R4)
I. Zera R3 (nunca será executada)

## Formato das instruções do nosso microprocessador

Nossas instruções têm 15 bits e seguem seguinte formato

XXX AAAA BBBB OOOO

- **A**: É o número do primeiro registrador
- **B**: É o número do segundo registrador
- **O**: É o _opcode_ da instrução

## Instruções

### ADD r1, r2

A instrução de soma sempre deve ser entre dois operandos -- um deles sempre
será o acumulador -- e não há soma com constantes

- **opcode**: 0001
