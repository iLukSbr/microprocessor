library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 5
-- Banco de registradores
entity reg_bank is
    port (
        clk, rst, wr_en : in  std_logic; -- Clock, reset, write enable
        reg_src         : in  unsigned(3 downto 0); -- Registrador de origem
        reg_dest        : in  unsigned(3 downto 0); -- Registrador de destino
        data_in         : in  unsigned(15 downto 0); -- Valor de entrada
        reg_src_data    : out unsigned(15 downto 0) := (others => '0');
        reg_dest_data   : out unsigned(15 downto 0) := (others => '0'); -- Valores que estão no registradores de origem e destino
        result          : out unsigned(15 downto 0) := (others => '0') -- Resultado da operação
    );
end entity;

architecture a_reg_bank of reg_bank is
    -- Write enable e data out para cada registrador
    signal wr_en_0, wr_en_1, wr_en_2, wr_en_3, wr_en_4, wr_en_5, wr_en_6, wr_en_7, wr_en_8, wr_en_9 : std_logic := '0'; -- Inicia com write desativado
    signal data_out_0, data_out_1, data_out_2, data_out_3, data_out_4, data_out_5, data_out_6, data_out_7, data_out_8, data_out_9 : unsigned(15 downto 0) := (others => '0'); -- Inicia zerado
     
    begin -- 10 registradores de 16 bits
    r0 : entity work.reg_16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_0,
        data_in   => data_in,
        data_out  => data_out_0
    );

    r1: entity work.reg_16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_1,
        data_in   => data_in,
        data_out  => data_out_1  
    );  

    r2: entity work.reg_16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_2,
        data_in   => data_in,
        data_out  => data_out_2  
    );  

    r3: entity work.reg_16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_3,
        data_in   => data_in,
        data_out  => data_out_3  
    );  

    r4: entity work.reg_16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_4,
        data_in   => data_in,
        data_out  => data_out_4  
    );  

    r5: entity work.reg_16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_5,
        data_in   => data_in,
        data_out  => data_out_5  
    );  

    r6: entity work.reg_16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_6,
        data_in   => data_in,
        data_out  => data_out_6  
    );  

    r7: entity work.reg_16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_7,
        data_in   => data_in,
        data_out  => data_out_7  
    );  

    r8: entity work.reg_16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_8,
        data_in   => data_in,
        data_out  => data_out_8  
    );  

    r9: entity work.reg_16bits
    port map( 
        clk       => clk,
        rst       => rst,
        wr_en     => wr_en_9,
        data_in   => data_in,
        data_out  => data_out_9  
    );  

    -- Preparo do registrador para escrita ou apenas leitura
    wr_en_0 <= '1' when wr_en = '1' and reg_dest = "0000" else '0';
    wr_en_1 <= '1' when wr_en = '1' and reg_dest = "0001" else '0';
    wr_en_2 <= '1' when wr_en = '1' and reg_dest = "0010" else '0';
    wr_en_3 <= '1' when wr_en = '1' and reg_dest = "0011" else '0';
    wr_en_4 <= '1' when wr_en = '1' and reg_dest = "0100" else '0';
    wr_en_5 <= '1' when wr_en = '1' and reg_dest = "0101" else '0';
    wr_en_6 <= '1' when wr_en = '1' and reg_dest = "0110" else '0';
    wr_en_7 <= '1' when wr_en = '1' and reg_dest = "0111" else '0';
    wr_en_8 <= '1' when wr_en = '1' and reg_dest = "1000" else '0';
    wr_en_9 <= '1' when wr_en = '1' and reg_dest = "1001" else '0';

    -- Valor que está no registrador de origem, endereço rs
    reg_src_data <= 
        data_out_0 when reg_src = "0000" else
        data_out_1 when reg_src = "0001" else
        data_out_2 when reg_src = "0010" else
        data_out_3 when reg_src = "0011" else
        data_out_4 when reg_src = "0100" else
        data_out_5 when reg_src = "0101" else
        data_out_6 when reg_src = "0110" else
        data_out_7 when reg_src = "0111" else
        data_out_8 when reg_src = "1000" else
        data_out_9 when reg_src = "1001" else
        (others => '0');

    -- Valor que está no registrador de destino, endereço rd
    reg_dest_data <= 
        data_out_0 when reg_dest = "0000" else
        data_out_1 when reg_dest = "0001" else
        data_out_2 when reg_dest = "0010" else
        data_out_3 when reg_dest = "0011" else
        data_out_4 when reg_dest = "0100" else
        data_out_5 when reg_dest = "0101" else
        data_out_6 when reg_dest = "0110" else
        data_out_7 when reg_dest = "0111" else
        data_out_8 when reg_dest = "1000" else
        data_out_9 when reg_dest = "1001" else
        (others => '0');

    result <= data_out_7; -- Resultado da operação
    
end architecture;
