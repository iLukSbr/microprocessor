library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 4
-- PC (Program Counter)
entity pc is
    port(
        clk             : in  std_logic; -- Clock
        rst             : in  std_logic; -- Reset
        wr_en           : in  std_logic; -- Habilita escrita no PC
        data_in         : in  unsigned(6 downto 0); -- Endereço da instrução da ROM
        data_out        : out unsigned(6 downto 0) := (others => '0'); -- Endereço da instrução da ROM
        invalid_address : out std_logic := '0' -- Flag de endereço de ROM inválido
    );
end entity;

architecture a_pc of pc is
    signal reg : unsigned(6 downto 0) := (others => '0'); -- Registrador do PC
    constant MAX_ROM_ADDRESS : unsigned(6 downto 0) := (others => '1'); -- Endereço máximo da ROM
begin
    process(clk, rst, wr_en)
    begin
        if rst = '1' then
            reg <= (others => '0'); -- Reset

        elsif rising_edge(clk) and wr_en = '1' then
            reg <= data_in(6 downto 0); -- Escreve no PC um endereço da da ROM
        end if;  
    end process;

    invalid_address <= '1' when reg >= MAX_ROM_ADDRESS else '0'; -- Verifica se o endereço é válido
    data_out <= reg; -- Saída do PC
end architecture;
