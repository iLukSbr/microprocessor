library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 8
-- Registrador de endereços
entity reg_addr is
    port(
        clk       : in  std_logic; -- Clock
        rst       : in  std_logic; -- Reset
        wr_en     : in  std_logic; -- Habilita escrita no registrador de endereços
        addr_in  : in  unsigned(18 downto 0); -- endereço a armazenar
        addr_out : out unsigned(18 downto 0) := (others => '0') -- Saída do registrador de endereços
    );
end entity;

architecture a_reg_addr of reg_addr is
    signal addr_reg : unsigned(18 downto 0) := (others => '0'); -- Registrador de endereços
begin
    process(clk, rst)
    begin
        if rst = '1' then
            addr_reg <= (others => '0'); -- Reset
        elsif rising_edge(clk) and wr_en = '1' then
            addr_reg <= addr_in; -- Escreve no registrador de endereços
        end if;
    end process;

    addr_out <= addr_reg; -- Saída do registrador de endereços
end architecture;
