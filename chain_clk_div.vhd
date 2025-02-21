library ieee;
use ieee.std_logic_1164.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 8
-- Divisor de frequência em cadeia
entity chain_clk_div is
    generic(divisor_1: integer := 5;
        divisor_2: integer := 3);
    port(
        clk_in    : in  std_logic; -- Clock in.
        clk_out_1 : out std_logic := '0'; -- Clock in dividido 2 x divisor_1.
        clk_out_2 : out std_logic := '0' -- Clock in dividido por 2 x divisor_1 x divisor_2.
    );
end chain_clk_div;

architecture a_chain_clk_div of chain_clk_div is
signal temp_1, temp_2: std_logic :='0';
begin
    P_div:process (clk_in)                                              
    variable count_1:integer range 0 to divisor_1;
    variable count_2:integer range 0 to divisor_2;
    begin                                                                
        if clk_in'event and clk_in = '1' then
            count_1 := count_1 + 1;
            if (count_1 = divisor_1) then
                temp_1 <= not temp_1;
                count_1 := 0;
                count_2 := count_2 + 1;
                if(count_2 = divisor_2) then
                    count_2 := 0;
                    temp_2 <= not temp_2;
                end if;
            end if;
         end if; 
    end process P_div;
    clk_out_1 <= temp_1;
    clk_out_2 <= temp_2;
end a_chain_clk_div;
