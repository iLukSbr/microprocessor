library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor_tb is
end entity;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 5
-- Testbench do processador
architecture a_processor_tb of processor_tb is
    constant period_time : time := 100 ns; -- Período para o clock
    signal clk, rst      : std_logic := '0'; -- Sinais de clock e reset
    signal finished      : std_logic := '0'; -- Sinal de terminou
    signal exception     : std_logic := '0'; -- Flag de erro
    signal number        : unsigned(15 downto 0) := (others => '0'); -- Saída do número

begin
    processor_inst : entity work.processor  -- Instância do processador
        port map(
            clk   => clk, -- Clock
            rst   => rst, -- Reset
            exception => exception, -- Flag de erro
            result => number -- Saída do número
        );

    -- Reset dos registradores para iniciar
    reset_global: process
    begin
        rst <= '1';
        wait for period_time * 3; -- Espera 3 clocks, para resetar o estado da máquina de estados
        rst <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        -- for i in 0 to 9999 loop
        --     wait for 100 ns;
        --     if exception = '1' then
        --         finished <= '1';
        --         wait for period_time * 3;
        --         exit;
        --     end if;
        -- end loop;
        wait for 500 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    -- Simula um clock com período period_time até que o tempo da simulação, sim_time_proc, se esgote
    clk_proc: process
    begin
        while (exception /= '1' and finished /= '1') loop
            clk <= '0';
            wait for period_time / 2;
            clk <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    -- Casos de teste
    process
    begin

        wait; -- Para terminar a simulação
    end process;

end architecture;
