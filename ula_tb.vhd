library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end ula_tb;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 5
-- Testbench da ULA
architecture a_ula_tb of ula_tb is
    component ula
        port (
            in1, in2 : in unsigned(15 downto 0);  -- Entradas
            selec_op : in unsigned(1 downto 0);   -- Seleciona a operação
            result   : out unsigned(15 downto 0); -- Resultado
            C, V, Z  : out std_logic := '0'              -- Carry, Overflow, Zero
        );
    end component;
    
    -- Zera tudo para iniciar
    signal in1, in2, result : unsigned(15 downto 0) := (others => '0');
    signal selec_op : unsigned(1 downto 0)  := (others => '0');
    signal C, V, Z : std_logic := '0';

begin
    uut : ula port map(
        in1 => in1,
        in2 => in2,
        selec_op => selec_op,
        result => result,
        C => C,
        V => V,
        Z => Z
    );

    process
    begin
        -- Teste com valores positivos (unsigned)
        in1 <= "0000000000000011"; -- 3
        in2 <= "0000000000000101"; -- 5

        -- Teste 1
        selec_op <= "00"; -- ADD
        wait for 50 ns;

        -- Teste 2
        selec_op <= "01"; -- SUB
        wait for 50 ns;

        -- Teste 3
        selec_op <= "10"; -- MOV in1
        wait for 50 ns;

        -- Teste 4
        selec_op <= "11"; -- MOV in2
        wait for 50 ns;

        -- Teste com valores negativos (complemento de 2)
        in1 <= "1111111111111101"; -- -3
        in2 <= "1111111111111011"; -- -5

        -- Teste 5
        selec_op <= "00"; -- ADD
        wait for 50 ns;

        -- Teste 6
        selec_op <= "01"; -- SUB
        wait for 50 ns;

        -- Teste 7
        selec_op <= "10"; -- MOV in1
        wait for 50 ns;

        -- Teste 8
        selec_op <= "11"; -- MOV in2
        wait for 50 ns;

        -- Teste com valores positivos e negativos (complemento de 2)
        in1 <= "0000000000000011"; -- 3
        in2 <= "1111111111111011"; -- -5

        -- Teste 9
        selec_op <= "00"; -- ADD
        wait for 50 ns;

        -- Teste 10
        selec_op <= "01"; -- SUB
        wait for 50 ns;

        -- Teste 11
        selec_op <= "10"; -- MOV in1
        wait for 50 ns;

        -- Teste 12
        selec_op <= "11"; -- MOV in2
        wait for 50 ns;

        -- ADD que resulta Zero (complemento de 2)
        in1 <= "0000000000000101"; -- 5
        in2 <= "1111111111111011"; -- -5

        -- Teste 13
        selec_op <= "00"; -- ADD
        wait for 50 ns;

        -- SUB que resulta Zero (unsigned)
        in1 <= "0000000000000101"; -- 5
        in2 <= "0000000000000101"; -- 5

        -- Teste 14
        selec_op <= "01"; -- SUB
        wait for 50 ns;

        -- Tudo resulta Zero (unsigned)
        in1 <= "0000000000000000"; -- 0
        in2 <= "0000000000000000"; -- 0

        -- Teste 15
        selec_op <= "00"; -- ADD
        wait for 50 ns;

        -- Teste 16
        selec_op <= "01"; -- SUB
        wait for 50 ns;

        -- ADD que resulta em Carry (unsigned)
        in1 <= "1111111111111111"; -- 65535
        in2 <= "0000000000000001"; -- 1

        -- Teste 17
        selec_op <= "00"; -- ADD
        wait for 50 ns;

        -- SUB que resulta em Carry (unsigned)
        in1 <= "0000000000000000"; -- 0
        in2 <= "0000000000000011"; -- 3

        -- Teste 18
        selec_op <= "01"; -- SUB
        wait for 50 ns;

        -- ADD que resulta em Overflow (complemento de 2)
        in1 <= "1000000000000001"; -- 32767
        in2 <= "0000000000000001"; -- 1

        -- Teste 19
        selec_op <= "00"; -- ADD
        wait for 50 ns;

        -- SUB que resulta em Overflow (complemento de 2)
        in1 <= "1000000000000000"; -- -32768
        in2 <= "1111111111111111"; -- 1

        -- Teste 20
        selec_op <= "01"; -- SUB
        wait for 50 ns;

        wait;
    end process;
end architecture;
