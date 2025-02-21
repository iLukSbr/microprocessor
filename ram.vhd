library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 7
-- Memória RAM
entity ram is
    port( 
        clk      : in std_logic; -- Clock
        address  : in unsigned(6 downto 0); -- Endereço
        wr_en    : in std_logic; -- Habilita escrita
        data_in  : in unsigned(15 downto 0); -- Dado de entrada
        data_out : out unsigned(15 downto 0) := (others => '0') -- Dado de saída
    );
end entity;

architecture a_ram of ram is
    type mem is array (0 to 127) of unsigned(15 downto 0); -- Memória RAM
    signal ram_content : mem := (others => (others => '0')); -- Conteúdo da memória
begin
    process(clk,wr_en)
    begin
        if rising_edge(clk) and wr_en='1' then -- Escreve na memória se o clock subir e o sinal de escrita estiver ativo
            ram_content(to_integer(address)) <= data_in;
        end if;
    end process;
    
    data_out <= ram_content(to_integer(address)); -- Lê da memória

end architecture;
