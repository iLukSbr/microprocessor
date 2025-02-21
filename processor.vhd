library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 5
-- Processador
entity processor is
    port(
        clk, rst  : in  std_logic;                               -- Clock e Reset
        exception : out std_logic := '0';                        -- Flag de erro
        result    : out unsigned(15 downto 0) := (others => '0') -- Resultado da operação
    );
end entity;

architecture a_processor of processor is
    signal rom_instr           : unsigned(18 downto 0) := (others => '0'); -- Instrução
    signal pc_in               : unsigned(6 downto 0) := (others => '0'); -- Contador de programa
    signal pc_out              : unsigned(6 downto 0) := (others => '0'); -- Contador de programa
    signal pc_wr_en            : std_logic := '1'; -- Sinal para carregar o contador de programa
    signal reg_instr_wr_en     : std_logic := '1'; -- Sinal para carregar a instrução no registrador de instrução
    signal reg_instr_out       : unsigned(18 downto 0) := (others => '0'); -- Saída do registrador de instrução
    signal val1, val2          : unsigned(15 downto 0) := (others => '0'); -- Valores para a ULA
    signal ula_opcode          : unsigned(2 downto 0) := (others => '0'); -- Código da operação da ULA
    signal reg_src_data        : unsigned(15 downto 0) := (others => '0'); -- Dados de saída dos registradores
    signal reg_dest_data       : unsigned(15 downto 0) := (others => '0'); -- Dados de entrada dos registradores
    signal ula_result          : unsigned(15 downto 0) := (others => '0'); -- Resultado da ULA
    signal banco_dest_addr     : unsigned(3 downto 0) := (others => '0'); -- Endereço do registrador destino no banco
    signal banco_src_addr      : unsigned(3 downto 0) := (others => '0'); -- Endereço do registrador fonte no banco
    signal banco_wr_en         : std_logic := '0'; -- Sinal de escrita no banco de registradores
    signal C_ula, V_ula, Z_ula : std_logic := '0'; -- Flags de carry, overflow e zero da ULA
    signal C, V, Z             : std_logic := '0'; -- Flags de carry, overflow e zero do registrador de flags
    signal reg_flags_wr_en     : std_logic := '1'; -- Sinal para carregar o registrador de flags
    signal invalid_address     : std_logic := '0'; -- Flag de endereço de ROM inválido do registrador de flags
    signal ram_addr            : unsigned(6 downto 0) := (others => '0'); -- Endereço da RAM
    signal ram_wr_en           : std_logic := '0'; -- Sinal de escrita na RAM
    signal ram_out             : unsigned(15 downto 0) := (others => '0'); -- Dado de saída da RAM

begin
    -- PC
    pc_inst : entity work.pc
        port map(
            clk             => clk, -- Clock
            rst             => rst, -- Reset
            wr_en           => pc_wr_en, -- Habilita escrita no PC
            data_in         => pc_in, -- Endereço da instrução da ROM
            data_out        => pc_out, -- Endereço da instrução da ROM
            invalid_address => invalid_address -- Flag de endereço de ROM inválido
        );

    -- ROM
    rom_inst : entity work.rom
        port map(
            clk     => clk, -- Clock
            address => pc_out, -- Endereço da instrução
            data    => rom_instr -- Instrução
        );

    -- Registrador de instrução
    reg_instr_inst : entity work.reg_instr
        port map(
            clk       => clk, -- Clock
            rst       => rst, -- Reset
            wr_en     => reg_instr_wr_en, -- Habilita escrita no registrador de instrução
            instr_in  => rom_instr, -- Instrução
            instr_out => reg_instr_out -- Saída do registrador de instrução
        );

    -- Unidade de Controle
    ctrl_unit_inst : entity work.ctrl_unit
        port map(
            clk             => clk, -- Clock
            rst             => rst, -- Reset
            instr           => reg_instr_out, -- Instrução
            reg_src_data    => reg_src_data, -- Dados da origem
            reg_dest_data   => reg_dest_data, -- Dados do destino
            ram_out_data    => ram_out, -- Dados da origem da RAM
            pc_out          => pc_out, -- Endereço da instrução da ROM
            C               => C, -- Flag de carry
            V               => V, -- Flag de overflow
            Z               => Z, -- Flag de zero
            invalid_address => invalid_address, -- Flag de endereço de ROM inválido
            val1            => val1, -- Valor 1 para a operação da ULA
            val2            => val2, -- Valor 2 para a operação da ULA
            ula_opcode      => ula_opcode, -- Código da operação da ULA
            banco_wr_en     => banco_wr_en, -- Habilitador de escrita no banco de registradores
            flags_wr_en     => reg_flags_wr_en, -- Habilitador de escrita no registrador de flags
            src_addr        => banco_src_addr, -- Endereço do registrador fonte no banco
            dest_addr       => banco_dest_addr, -- Endereço do registrador destino no banco
            ram_wr_en       => ram_wr_en, -- Habilitador de escrita na RAM
            ram_addr        => ram_addr, -- Endereço da RAM
            pc_in           => pc_in, -- Próximo endereço do PC
            pc_wr_en        => pc_wr_en, -- Habilitador de escrita no PC
            reg_instr_wr_en => reg_instr_wr_en, -- Habilitador de escrita no registrador de instrução
            error           => exception -- Flag de erro
        );

    -- Banco de registradores
    reg_bank_inst : entity work.reg_bank
        port map(
            clk            => clk, -- Clock
            rst            => rst, -- Reset
            wr_en          => banco_wr_en, -- Habilita escrita no banco de registradores
            reg_src        => banco_src_addr, -- Endereço do registrador de origem
            reg_dest       => banco_dest_addr, -- Endereço do registrador de destino
            data_in        => ula_result, -- Dados a serem escritos
            reg_src_data   => reg_src_data, -- Dados do registrador de origem
            reg_dest_data  => reg_dest_data, -- Dados do registrador de destino
            result         => result -- Resultado da operação
        );

    -- ULA
    ula_inst : entity work.ula
        port map(
            in1      => val1, -- Valor 1 para a operação da ULA
            in2      => val2, -- Valor 2 para a operação da ULA
            selec_op => ula_opcode, -- Código da operação da ULA
            result   => ula_result, -- Recebe o resultado da ULA
            C        => C_ula, -- Flag de carry
            V        => V_ula, -- Flag de overflow
            Z        => Z_ula -- Flag de zero
        );

    -- Registrador de flags
    reg_flags_inst : entity work.reg_flags
        port map(
            clk   => clk, -- Clock
            rst   => rst, -- Reset
            wr_en => reg_flags_wr_en, -- Habilita escrita no registrador de flags
            C     => C_ula, -- Flag de carry
            V     => V_ula, -- Flag de overflow
            Z     => Z_ula, -- Flag de zero
            C_out => C, -- Saída do registrador de flags
            V_out => V, -- Saída do registrador de flags
            Z_out => Z -- Saída do registrador de flags
        );

    ram_inst : entity work.ram
        port map(
            clk      => clk, -- Clock
            address  => ram_addr, -- Endereço
            wr_en    => ram_wr_en, -- Habilita escrita
            data_in  => ula_result, -- Dado de entrada
            data_out => ram_out -- Dado de saída
        );
end architecture;
