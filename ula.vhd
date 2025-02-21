library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 5
-- ULA (Unidade Lógico-Aritmética)
entity ula is
    port(
        in1, in2 : in unsigned(15 downto 0);                     -- Entradas
        selec_op : in unsigned(2 downto 0);                      -- Seleciona a operação
        result   : out unsigned(15 downto 0) := (others => '0'); -- Resultado
        C, V, Z  : out std_logic := '0'                          -- Carry, Overflow, Zero
    );
end entity;

architecture a_ula of ula is
    signal in1_ext, in2_ext, result_ext : unsigned(16 downto 0) := (others => '0'); -- Inicia zerado
    signal clz_count : unsigned(4 downto 0) := (others => '0'); -- Contagem de zeros à esquerda
begin
    in1_ext <= '0' & in1; -- Extensão do sinal in1 de 15 para 16 bits (0 no MSB)
    in2_ext <= '0' & in2; -- Extensão do sinal in2 de 15 para 16 bits (0 no MSB)

    -- Contar zeros à esquerda
    clz_count <= "00000" when in1(15) = '1' else
                 "00001" when in1(14) = '1' else
                 "00010" when in1(13) = '1' else
                 "00011" when in1(12) = '1' else
                 "00100" when in1(11) = '1' else
                 "00101" when in1(10) = '1' else
                 "00110" when in1(9) = '1' else
                 "00111" when in1(8) = '1' else
                 "01000" when in1(7) = '1' else
                 "01001" when in1(6) = '1' else
                 "01010" when in1(5) = '1' else
                 "01011" when in1(4) = '1' else
                 "01100" when in1(3) = '1' else
                 "01101" when in1(2) = '1' else
                 "01110" when in1(1) = '1' else
                 "01111" when in1(0) = '1' else
                 "10000";

    result_ext <= (in1_ext + in2_ext) when selec_op = "001" else  -- ADD (in1 + in2)
                  (in1_ext - in2_ext) when selec_op = "010" else  -- SUB (in1 - in2)
                  in1_ext when selec_op = "011" else  -- MOV in1 (copia in1 para result)
                  "000000000000" & clz_count when selec_op = "100" else  -- CLZ (conta zeros à esquerda)
                  "00000000000000000"; -- Se falhar

    result <= result_ext(15 downto 0); -- Resultado, descartando o bit de extensão

    -- Flags para os saltos condicionais BHI (higher, C = 1 e Z = 0) e BVS (overflow, V = 1)
    
    -- Flag Carry (operações unsigned) (sem bit de borrow)
    C <= '1' when (selec_op = "001" and result_ext(16) = '1') or -- ADD: in1 + in2 estourou um bit
                  (selec_op = "010" and result_ext(16) = '1') else -- SUB: in1 - in2 estourou um bit
         '0';

    -- Flag Overflow (operações signed em complemento de 2)
    V <= '1' when (selec_op = "001" and -- ADD
                   in1_ext(15) = in2_ext(15) and -- Ambos positivos ou ambos negativos (mesmo bit de sinal)
                   result_ext(15) /= in1_ext(15) -- Resultou em sinal diferente
                  ) or (
                   selec_op = "010" and -- SUB
                   in1_ext(15) /= in2_ext(15) and -- Um positivo e outro negativo (bit de sinal diferente, 0=positivo, 1=negativo)
                   result_ext(15) /= in1_ext(15) -- in1 negativo - in2 positivo = negativo; in1 positivo - in2 negativo = positivo (overflow se o resultado tem sinal diferente de in1)
                  ) else
         '0';

    -- Flag Zero (se o resultado for igual a zero)
    Z <= '1' when result_ext(15 downto 0) = "00000000000000000" else '0';
end architecture;
