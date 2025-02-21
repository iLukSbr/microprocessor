library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 5
-- Testbench do PC
entity pc_tb is
end entity;

architecture a_pc_tb of pc_tb is
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal wr_en    : std_logic := '0';
    signal data_in  : unsigned(6 downto 0) := (others => '0');
    signal data_out : unsigned(6 downto 0) := (others => '0');

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

    -- PC
    uut: entity pc
        port map (
            clk      => clk,
            rst      => rst,
            wr_en    => wr_en,
            data_in  => data_in,
            data_out => data_out
        );

    process
    begin
        -- Reset do PC
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        -- Escrita no PC
        wr_en <= '1';
        data_in <= "0000010"; -- Escreve valor 2
        wait for 20 ns;

        -- Escrita de outro valor no PC
        data_in <= "0000100"; -- Escreve valor 4
        wait for 20 ns;

        -- Desabilitar write enable
        wr_en <= '0';
        data_in <= "0000110"; -- Tenta escrever valor 6 (não deve mudar)
        wait for 20 ns;

        -- Fim da simulação
        wait;
    end process;
end architecture;
