library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 5
-- Registrador de 16 bits
entity reg_16bits is
    port(
        clk, rst, wr_en   : in  std_logic;
        data_in           : in  unsigned(15 downto 0);
        data_out          : out unsigned(15 downto 0) := (others => '0')
    );
end entity;

architecture a_reg_16bits of reg_16bits is
    signal reg: unsigned(15 downto 0) := (others => '0'); -- Inicia zerado
begin

    process(clk,rst,wr_en) -- Acionado se houver mudança em clk, rst ou wr_en
    begin                
        if rst='1' then -- Se reset ativo, zera o registrador
            reg <= (others => '0');
        elsif rising_edge(clk) and wr_en='1' then -- Se wr_en ativo, salva no registrador o valor recebido
            reg <= data_in;
        end if;
    end process;

    data_out <= reg; -- Sai o valor que está no registrador
end architecture;
