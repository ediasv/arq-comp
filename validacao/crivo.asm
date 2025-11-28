    LD R1, 2 

    LD R2, 127
    MV A, R2
    ADD A, R2
    MV R2 A    

    ADD A, R2
    ADD A, R2   
    MV R2, A

    LD A, 5
    ADD A, R2   
    MV R2, A    

    LD R7, 0

carrega_ram:
    MV ACC, R1
    SW ACC, R7

    ADD ACC, R7
    MV R1, ACC

    MV ACC, R2

    SUB ACC, R1

    BEQ fim_carrega_ram

    JMP 3

fim_carrega_ram:
    NOP
