# Executar com .\banco_ula.ps1 no terminal

# ULA
ghdl -a ula.vhd
ghdl -e ula

# RAM
ghdl -a ram.vhd
ghdl -e ram

# Registrador 16 bits
ghdl -a reg_16bits.vhd
ghdl -e reg_16bits

# Banco de registradores
ghdl -a reg_bank.vhd
ghdl -e reg_bank

# PC
ghdl -a pc.vhd
ghdl -e pc

# ROM
ghdl -a rom.vhd
ghdl -e rom

# Máquina de estados
ghdl -a state_machine.vhd
ghdl -e state_machine

# Registrador de instruções
ghdl -a reg_instr.vhd
ghdl -e reg_instr

# Registrador de flags
ghdl -a reg_flags.vhd
ghdl -e reg_flags

# Unidade de Controle
ghdl -a ctrl_unit.vhd
ghdl -e ctrl_unit

# Processador
ghdl -a processor.vhd
ghdl -e processor

# Testbench do processador
ghdl -a processor_tb.vhd
ghdl -e processor_tb

# Simulação do processador
ghdl -r processor_tb --wave=processor_tb.ghw

# Visualização no simulador
gtkwave processor_tb.ghw -a processor_tb.gtkw
