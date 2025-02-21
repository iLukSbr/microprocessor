library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor_d is
    generic(
        MAX_PRIMES : integer := 11 -- Número máximo de primos a serem gerados
    );
    port(
        clk       : in  std_logic;                                 -- Clock
        rst       : in  std_logic;                                 -- Reset
        exception : out std_logic := '0';                          -- Flag de erro
        result    : out unsigned(15 downto 0) := "0000000000000010" -- Resultado da operação
    );
end entity;

architecture a_processor_d of processor_d is
    type prime_array is array (0 to 10) of unsigned(15 downto 0);
    constant primes : prime_array := (
        to_unsigned(2, 16),
        to_unsigned(3, 16),
        to_unsigned(5, 16),
        to_unsigned(7, 16),
        to_unsigned(11, 16),
        to_unsigned(13, 16),
        to_unsigned(17, 16),
        to_unsigned(19, 16),
        to_unsigned(23, 16),
        to_unsigned(29, 16),
        to_unsigned(31, 16)
    );

    signal prime_index : integer range 0 to MAX_PRIMES-1 := 0;
    signal clk_1s      : std_logic := '0'; -- Clock de 1 segundo

begin
    -- Instância do divisor de clock
    chain_clk_div_inst : entity work.chain_clk_div
    generic map(
        divisor_1 => 250000, -- 50 MHz / 250000 = 200 Hz
        divisor_2 => 100     -- 200 Hz / 100 = 2 Hz
    )
    port map(
        clk_in    => clk,    -- Clock de 50 MHz
        clk_out_1 => open,   -- Clock de 10 ms (não utilizado)
        clk_out_2 => clk_1s  -- Clock de 1 s
    );

    -- Processo para atualizar o resultado e sinalizar a exceção a cada 1 segundo
    process(clk_1s, rst)
    begin
        exception <= '1';
        if rising_edge(clk_1s) then
            if rst = '0' then
                prime_index <= 0;
            end if;
            result <= primes(prime_index);
            if prime_index < MAX_PRIMES - 1 then
                prime_index <= prime_index + 1;
            end if;
        end if;
    end process;
end architecture;