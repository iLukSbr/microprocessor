library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 5
-- Máquina de 3 estados
entity state_machine is
   port(
      clk, rst : in std_logic; -- Clock e Reset
      state   : out unsigned(1 downto 0) := (others => '0') -- Estado atual da máquina de estados
   );
end entity;
architecture a_state_machine of state_machine is
   signal state_sig: unsigned(1 downto 0) := (others => '0'); -- Estado atual da máquina de estados
begin
   process(clk, rst)
   begin
      if rst='1' then
         state_sig <= (others => '0');
      elsif rising_edge(clk) then
         if state_sig = "10" then -- Se agora está em 2
            state_sig <= (others => '0'); -- No próximo clock vai voltar ao estado zero
         else
            state_sig <= state_sig + 1;   -- Senão avança o estado
         end if;
      end if;
   end process;

   state <= state_sig; -- Saída do estado
end architecture;

-- "00" = fetch
-- "01" = decode
-- "10" = execute
