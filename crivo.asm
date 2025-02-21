CLR R7 # Zera o registrador R8
LI R0, 1 # Inicializa o registrador R0 com 1
LI R1, 32 # Carrega 32 no registrador R2 (até qual número gerar os primos)
CLZ R2, R1 # Conta o número de zeros à esquerda de 32 e armazena em R7
ADDI R1, 1 # Incrementa o R1 em 1

LOAD_LOOP: SW R0, 0(R0) # Armazena o valor de R0 no endereço apontado por R1 da RAM com deslocamento 0
           ADDI R0, 1 # Incrementa o endereço de R1 em 1
           CMP R1, R0 # Compara o valor de R0 com R1
           BLO LOAD_LOOP # Se R0 for menor que R1, repete o loop

LI R0, 1 # Inicializa o registrador R0 com 1
LI R6, 12 # Inicializa o registrador R5 com 12 (zero até multiplos de 11, no 12 para)
CLR R4 # Zera o registrador R4

OUTER_ELIMINATION_LOOP: ADDI R0, 1 # Incrementa o R0 em 1
                        LW R5, 0(R0) # Carrega o valor do endereço apontado por R0 da RAM com deslocamento 0 em R5
                        CMP R5, R4 # Compara o valor de R4 com R5
                        BLO MOV_LOOP # Se R4 for menor que R5, prossegue

                        JMP OUTER_ELIMINATION_LOOP # Pula para o loop de eliminação externo

                        MOV_LOOP: MOV R3, R0 # Copia o valor de R0 para R3

                        ELIMINATION_LOOP: ADD R3, R0 # Incrementa o R3 em R0
                                          SW R4, 0(R3) # Armazena o valor de R4 no endereço apontado por R3 da RAM com deslocamento 0
                                          CLZ R5, R3 # Conta o número de zeros à esquerda do endereço atual e armazena em R5
                                          CMP R2, R5 # Compara se o endereço atual é maior que o endereço máximo
                                          BHI ELIMINATION_LOOP # Se o endereço atual tem mais zeros à esquerda que o endeço máximo, continua eliminando os múltiplos

                        CMP R6, R0 # Compara o valor de R6 com R0
                        BLO OUTER_ELIMINATION_LOOP # Se R6 for menor que R0, repete o loop de eliminação

MOV R8, R1
LI R0, 2 # Inicializa o registrador R0 com 2

PRINT_LOOP: LW R3, 0(R0) # Carrega o valor do endereço apontado por R1 da RAM com deslocamento 0 em R0
            CLZ R5, R0 # Conta o número de zeros à esquerda do endereço atual e armazena em R5
            ADDI R0, 1 # Incrementa o endereço de R0 em 1
            CMP R3, R4 # Compara o valor de R4 com R3
            BLO RESULT_LOOP # Se R4 for menor que R3, repete o loop de impressão

            JMP LOOP # Pula para o loop final 

            RESULT_LOOP: SW R3, 0(R8) # Armazena o valor de R3 no endereço apontado por R8 da RAM com deslocamento 0
                        ADDI R8, 1 # Incrementa o endereço de R8 em 1

            LOOP: CMP R2, R5 # Compara se o endereço atual é maior que o endereço máximo
                  BHI PRINT_LOOP # Se o endereço atual tem mais zeros à esquerda que o endeço máximo, continua eliminando os múltiplos

MOV R9, R1 # Copia o valor de R1 para R9

PIN_LOOP: LW R7, 0(R9) # Armazena o valor do endereço apontado por R9 da RAM com deslocamento 0 em R10
          ADDI R9, 1 # Incrementa o endereço de R9 em 1
          CMP R8, R9 # Compara o valor de R8 com R9
          BLO PIN_LOOP # Se R8 for menor que R9, repete o loop de impressão

JMP 126 # Pula para o endereço 126 (127 é o final da ROM, inválido)
NOP
