library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 8
-- Debouncer de botão
entity debounce is
    generic(counter_size  :  INTEGER := 1); -- Generaliza a capacidade do contador
    port(
        clk     : in  std_logic; -- Entrada do clock
        button  : in  std_logic; -- Sinal de entrada do botão
        result  : out std_logic := '0'
    ); -- Sinal debounced
end debounce;

architecture a_debounce of debounce is
    signal flip_flops  : std_logic_vector(1 downto 0) := (others => '0');            -- Flip-flops FF0 e FF1.
    signal counter_set : std_logic := '0';                                           -- Condição XOR para reset síncrono.
    signal counter_out : std_logic_vector(counter_size downto 0) := (others => '0'); -- Contador de amostras.
begin
    counter_set <= flip_flops(0) xor flip_flops(1); -- Reseta cnt se amostras diferem.
  
    process(clk)
    begin
        if(clk'event and clk = '1') then
            flip_flops(0) <= button;
            flip_flops(1) <= flip_flops(0);
            if(counter_set = '1') then -- Reseta contador se amostras diferem.
                counter_out <= (others => '0');
            elsif counter_out /= "11" then
                counter_out <= counter_out + 1;
            else -- Contagem estabilizada foi atingida.
                    result <= flip_flops(1);
            end if;    
        end if;
    end process;
end a_debounce;
