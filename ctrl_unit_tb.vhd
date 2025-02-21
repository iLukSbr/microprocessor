library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 5
-- Testbench da UC
entity ctrl_unit_tb is
end entity;

architecture tb of ctrl_unit_tb is
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal rom_data  : unsigned(18 downto 0) := (others => '0');
    signal unknown   : std_logic := '0';
    signal C, V, Z   : std_logic := '0';
    signal next_instr: std_logic := '0';
    signal jump_addr : unsigned(6 downto 0) := (others => '0');

    -- Geração do clock
    constant clk_period : time := 10 ns;
begin
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Instanciação da unidade de controle
    uut: entity work.ctrl_unit
        port map (
            clk       => clk,
            rst       => rst,
            rom_data  => rom_data,
            unknown   => unknown,
            C         => C,
            V         => V,
            Z         => Z,
            next_instr=> next_instr,
            jump_addr => jump_addr
        );

    process
    begin
        -- Caso de teste: Reset do sistema
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        -- Caso de teste: Simular dados da ROM
        rom_data <= "111100000000000000"; -- Jump para endereço 0
        wait for 20 ns;
        rom_data <= "000000000000000000"; -- NOP
        wait for 20 ns;
        rom_data <= "111100000000000001"; -- Jump para endereço 1
        wait for 20 ns;
        rom_data <= "000000000000000000"; -- NOP
        wait for 20 ns;
        rom_data <= "101000000000000000"; -- Instrução desconhecida
        wait for 20 ns;

        -- Fim da simulação
        wait;
    end process;
end architecture;
