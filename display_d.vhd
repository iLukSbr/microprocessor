library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 8
-- Validação na FPGA
entity display is
    port(
        reset_button : in  std_logic;                                       -- Botão de reset
        clk_50mhz    : in  std_logic;                                       -- Clock de 50 MHz
        disp_d       : out std_logic_vector(6 downto 0) := (others => '0'); -- Display dezena
        disp_u       : out std_logic_vector(6 downto 0) := (others => '0')  -- Display unidade
    );
end display;

architecture a_display of display is
    signal clk_1s          : std_logic := '0'; -- Clock de 1 s
    signal clk_10ms        : std_logic := '0'; -- Clock de 10 ms
    signal reset_debounced : std_logic := '0'; -- Reset debounced
    signal exception       : std_logic := '0'; -- Flag de erro
    signal number          : unsigned(15 downto 0) := (others => '0'); -- Saída do número

    signal disp_bin_d : unsigned(3 downto 0) := (others => '0'); -- Valor binário para display dezena
    signal disp_bin_u : unsigned(3 downto 0) := (others => '0'); -- Valor binário para display unidade

    function to_7segment(input : unsigned(3 downto 0)) return std_logic_vector is
    begin
        case input is
            when "0000" => return "1111110"; -- 0
            when "0001" => return "0110000"; -- 1
            when "0010" => return "1101101"; -- 2
            when "0011" => return "1111001"; -- 3
            when "0100" => return "0110011"; -- 4
            when "0101" => return "1011011"; -- 5
            when "0110" => return "1011111"; -- 6
            when "0111" => return "1110000"; -- 7
            when "1000" => return "1111111"; -- 8
            when "1001" => return "1110011"; -- 9
            when others => return "0000000"; -- Blank
        end case;
    end function;

begin
    processor_d_inst : entity work.processor_d  -- Instância do processador
    port map(
        clk       => clk_50mhz,       -- Clock
        rst       => reset_debounced, -- Reset
        exception => exception,       -- Flag de erro
        result    => number           -- Saída do número
    );

    chain_clk_div_inst : entity work.chain_clk_div
    generic map(
        divisor_1 => 250000, -- 50 MHz / 250000 = 200 Hz
        divisor_2 => 100     -- 200 Hz / 100 = 2 Hz
    )
    port map(
        clk_in    => clk_50mhz, -- Clock de 50 MHz
        clk_out_1 => clk_10ms,  -- Clock de 10 ms
        clk_out_2 => clk_1s     -- Clock de 1 s
    );

    debounce_inst : entity work.debounce
    port map(
        clk    => clk_10ms,       -- Clock de 10 ms
        button => reset_button,   -- Botão de reset
        result => reset_debounced -- Reset debounced
    );

    process(clk_1s)
        variable decimal_value : integer := 0;
        variable tens : integer := 0;
        variable unit : integer := 0;
    begin
        if rising_edge(clk_1s) then
            if exception = '1' then
                decimal_value := to_integer(number);
                tens := decimal_value / 10;
                unit := decimal_value mod 10;
                disp_bin_d <= to_unsigned(tens, 4);
                disp_bin_u <= to_unsigned(unit, 4);
            end if;
        end if;
    end process;

    disp_d <= to_7segment(disp_bin_d);
    disp_u <= to_7segment(disp_bin_u);
end a_display;