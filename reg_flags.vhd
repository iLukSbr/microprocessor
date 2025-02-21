library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 6
-- Registradores de flag
entity reg_flags is
    port(
        clk                 : in  std_logic; -- Clock
        rst                 : in  std_logic; -- Reset
        wr_en               : in  std_logic; -- Habilita escrita no registrador de flag
        C, V, Z             : in  std_logic; -- Flags de Zero, Overflow e Carry
        C_out, V_out, Z_out : out std_logic := '0' -- Flags de Zero, Overflow e Carry
    );
end entity;

architecture a_reg_flags of reg_flags is
    signal C_reg, V_reg, Z_reg : std_logic := '0'; -- Registrador de flag
begin
    process(clk, rst, wr_en)
    begin
        if rst = '1' then -- Reset
            C_reg <= '0';
            V_reg <= '0';
            Z_reg <= '0';
        elsif rising_edge(clk) and wr_en = '1' then -- Escreve no registrador de flag se write enabled
            C_reg <= C;
            V_reg <= V;
            Z_reg <= Z;
        end if;
    end process;

    -- Saída do registrador de flag
    C_out <= C_reg;
    V_out <= V_reg;
    Z_out <= Z_reg;

end architecture;
