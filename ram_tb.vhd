library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 7
-- Testbench da memória RAM

entity ram_tb is
end entity;

architecture a_ram_tb of ram_tb is
    signal clk      : std_logic := '0'; -- Clock
    signal address : unsigned(6 downto 0) := (others => '0'); -- Endereço
    signal wr_en    : std_logic := '0'; -- Habilita escrita
    signal data_in  : unsigned(15 downto 0) := (others => '0'); -- Dado de entrada
    signal data_out : unsigned(15 downto 0) := (others => '0'); -- Dado de saída
begin
    uut : entity work.ram
        port map(
            clk      => clk, -- Clock
            address => address, -- Endereço
            wr_en    => wr_en, -- Habilita escrita
            data_in  => data_in, -- Dado de entrada
            data_out => data_out -- Dado de saída
        );
        
    process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;
    
    process
    begin
        data_in <= x"0001";
        address <= "0000000";
        wr_en <= '1';
        wait for 10 ns;
        wr_en <= '0';
        wait for 10 ns;
        
        data_in <= x"00015";
        address <= "0000001";
        wr_en <= '1';
        wait for 10 ns;
        wr_en <= '0';
        wait for 10 ns;
        
        data_in <= x"00037";
        address <= "0000010";
        wr_en <= '1';
        wait for 10 ns;
        wr_en <= '0';
        wait for 10 ns;
        
        data_in <= x"00044";
        address <= "0000011";
        wr_en <= '1';
        wait for 10 ns;
        wr_en <= '0';
        wait for 10 ns;
        
        data_in <= x"0100";
        address <= "0000100";
        wr_en <= '1';
        wait for 10 ns;
        wr_en <= '0';
        wait for 10 ns;
        
        data_in <= x"0121";
        address <= "0000101";
        wr_en <= '1';
        wait for 10 ns;
        wr_en <= '0';
        wait for 10 ns;
        
        data_in <= x"0127";
        address <= "0000110";
        wr_en <= '1';
        wait for 10 ns;
        wr_en <= '0';
        wait for 10 ns;
        
        data_in <= x"0008";
        address <= "0000111";
        wr_en <= '1';
        wait for 10 ns;
        wr_en <= '0';
        wait for 10 ns;
        
        data_in <= x"0072";
        address <= "0001000";
        wr_en <= '1';
        wait for 10 ns;
        wr_en <= '0';
        wait for 10 ns;

    end process;
end architecture;
