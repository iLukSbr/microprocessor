library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 5
-- Testbench da ROM
entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is
    signal clk      : std_logic := '0';
    signal address : unsigned(6 downto 0);
    signal dado     : unsigned(18 downto 0);

    -- Componente ROM
    component rom
        port(
            clk      : in std_logic;
            address : in unsigned(6 downto 0);
            dado     : out unsigned(18 downto 0)
        );
    end component;

begin
    -- Geração do clock
    clock: process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Instanciação da ROM
    uut: rom
        port map (
            clk => clk,
            address => address,
            dado => dado
        );

    process
    begin
        -- Caso de teste 1: Endereço 0
        address <= unsigned'("0000000");
        wait for 20 ns;

        -- Caso de teste 2: Endereço 1
        address <= unsigned'("0000001");
        wait for 20 ns;

        -- Caso de teste 3: Endereço 2
        address <= unsigned'("0000010");
        wait for 20 ns;

        -- Caso de teste 4: Endereço 3
        address <= unsigned'("0000011");
        wait for 20 ns;

        -- Caso de teste 5: Endereço 4
        address <= unsigned'("0000100");
        wait for 20 ns;

        -- Caso de teste 6: Endereço 5
        address <= unsigned'("0000101");
        wait for 20 ns;

        -- Caso de teste 7: Endereço 6
        address <= unsigned'("0000110");
        wait for 20 ns;

        -- Caso de teste 8: Endereço 7
        address <= unsigned'("0000111");
        wait for 20 ns;

        -- Caso de teste 9: Endereço 8
        address <= unsigned'("0001000");
        wait for 20 ns;

        -- Caso de teste 10: Endereço 9
        address <= unsigned'("0001001");
        wait for 20 ns;

        -- Caso de teste 11: Endereço 10
        address <= unsigned'("0001010");
        wait for 20 ns;

        -- Caso de teste para outros endereços: Endereço 11
        address <= unsigned'("0001011");
        wait for 20 ns;

        -- Fim da simulação
        wait;
    end process;
end architecture;
