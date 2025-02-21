# Assembly para o processador

# A. Carrega o registrador R3 com o valor 5
LI R3, 0

# B. Carrega o registrador R4 com o valor 8
LI R4, 0

# C. Soma R3 e R4 e guarda em R4
desvio: ADD R4, R3

# D. Soma 1 em R3
ADDI R3, 1

# E. Se R3 < 30, salta para o passo C
CMP R3, 30
BLO desvio

# F. Copia R4 para R5
MOV R5, R4
