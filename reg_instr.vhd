library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 5
-- Registrador de instrução
entity reg_instr is
    port(
        clk       : in  std_logic; -- Clock
        rst       : in  std_logic; -- Reset
        wr_en     : in  std_logic; -- Habilita escrita no registrador de instrução
        instr_in  : in  unsigned(18 downto 0); -- Instrução a armazenar
        instr_out : out unsigned(18 downto 0) := (others => '0') -- Saída do registrador de instrução
    );
end entity;

architecture a_reg_instr of reg_instr is
    signal instr_reg : unsigned(18 downto 0) := (others => '0'); -- Registrador de instrução
begin
    process(clk, rst, wr_en)
    begin
        if rst = '1' then
            instr_reg <= (others => '0'); -- Reset
        elsif rising_edge(clk) and wr_en = '1' then
            instr_reg <= instr_in; -- Escreve no registrador de instrução
        end if;
    end process;

    instr_out <= instr_reg; -- Saída do registrador de instrução
end architecture;
