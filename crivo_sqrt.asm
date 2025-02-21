# ASSEMBLY DESCARTADO!

# Assembly do Crivo de Eratóstenes
# Valores armazenados iguais ao endereço da RAM

LI R0, 1 # Inicializa o registrador R0 com 1
LI R1, 1 # Inicializa o registrador R1 com o endereço inicial da RAM (1)
LI R2, 32 # Carrega o valor no registrador R2 (até qual número gerar os primos)
CLZ R7, R2 # Conta o número de zeros à esquerda no valor de R2 e armazena em R7

LOAD_LOOP: SW R0, 0(R1) # Armazena o valor de R0 no endereço apontado por R1 da RAM com deslocamento 0
           ADDI R0, 1 # Incrementa o endereço de R1 em 1
           ADDI R1, 1 # Incrementa o valor de R0 em 1
           CMP R0, R2 # Compara o valor de R0 com R2
           BLO LOAD_LOOP # Se R0 for menor que R2, repete o loop

# Calcular a raiz quadrada de R2
# 1 + 3 + 5 + 7 + ... + (2n-1) = n^2
# Doma dos primeiros n ímpares = n^2
LI R3, 0 # Inicializa o registrador R3 com 0 (aproximação inicial)
LI R4, 1 # Inicializa o registrador R4 com 1 (incremento)
LI R5, 0 # Inicializa o registrador R5 com 0 (para armazenar o quadrado)

SQRT_LOOP: ADD R5, R3 # Calcula o próximo valor de R3 (R3 + R4)
           ADD R5, R4
           ADD R6, R5 # Calcula o dobro de R5 (2 * R5)
           ADD R6, R5
           CMP R6, R2 # Compara 2 * R5 com R2
           BHI END_SQRT # Se 2 * R5 for maior que R2, termina o loop
           ADDI R3, 1 # Incrementa o valor de R3
           ADDI R4, 2 # Incrementa o valor de R4 em 2
           JMP SQRT_LOOP  # Repete o loop

END_SQRT: CLR R0 # Zera o registrador R0. R3 agora contém a aproximação da raiz quadrada de R2 (máximo múltiplo a eliminar)

LI R1, 1 # Inicializa o registrador R1 com o endereço inicial da RAM (1)
ADDI R3, 1 # Incrementa a aproximação da raiz quadrada de R2 em 1 para usar com BLO

TILL_SQRT_LOOP: ADDI R1, 1 # Incrementa o endereço de R1 em 1
                CMP R1, R3 # Compara o endereço atual da RAM com a aproximação da raiz quadrada de R2 + 1
                BLO CHECK_ZERO_LOOP # Se o endereço atual for menor que o endereço máximo, prossegue para verificar se não está zerado

JMP POST_READ # Se o endereço atual for igual ao endereço máximo, prossegue para ler como ficou a RAM

CHECK_ZERO_LOOP: LW R4, 0(R1) # Carrega o valor do endereço apontado por R1 em R4
                 CMP R4, R0 # Compara o valor de R4 com 0
                 BHI ELIMINATION_LOOP # Se R4 for maior que 0, prossegue para eliminar os múltiplos

JMP TILL_SQRT_LOOP # Se R4 for igual a 0, repete o loop de busca de primos

ELIMINATION_LOOP: ADD R1, R4 # Incrementa o endereço de R1 em com o valor de R4
                  SW R0, 0(R1) # Armazena o valor de R0 no endereço apontado por R1 da RAM com deslocamento 0
                  CLZ R5, R1 # Conta o número de zeros à esquerda do endereço atual e armazena em R5
                  CMP R5, R7 # Compara o endereço atual da RAM com o endereço máximo
                  BHI ELIMINATION_LOOP # Se o endereço atual tem mais zeros à esquerda que o endeço máximo, continua eliminando os múltiplos

JMP TILL_SQRT_LOOP # Repete o loop de busca de primos se já zerou todos os múltiplos de R4

POST_READ: LI R1, 1 # Inicializa o registrador R1 com o endereço inicial da RAM (1)

PRIME_LOOP: ADDI R1, 1 # Incrementa o endereço de R1 em 1
            CLZ R3, R1 # Conta o número de zeros à esquerda do endereço atual e armazena em R3
            CMP R3, R7 # Compara o endereço atual da RAM com o endereço máximo
            BHI CHECK_ZERO_LOOP2 # Se o endereço atual tem mais zeros à esquerda que o endeço máximo, finaliza a execução

JMP FINISH # Se o endereço atual tem menos zeros à esquerda que o endereço máximo, prossegue para verificar se é primo

CHECK_ZERO_LOOP2: LW R2, 0(R1) # Carrega o valor do endereço apontado por R1 em R2
                  CMP R2, R0 # Compara o valor de R2 com R0
                  BHI PRINT_LOOP # Se R2 for maior que 0, imprime o valor de R0 em R2

JMP PRIME_LOOP # Se R2 for 0, repete o loop de busca de primos

PRINT_LOOP: MOV R2, R1 # Copia o valor de R1 para R2

FINISH:
CLR R1 # Zera o registrador R1
CLR R2 # Zera o registrador R2
CLR R3 # Zera o registrador R3
CLR R4 # Zera o registrador R4
CLR R5 # Zera o registrador R5
CLR R6 # Zera o registrador R6
CLR R7 # Zera o registrador R7
JMP 126 # Salta para o endereço 126 (endereço 127 é o máximo e gera exception) para finalizar a execução
