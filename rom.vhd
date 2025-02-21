library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lucas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 5
-- ROM (Read-Only Memory)
entity rom is
   port( clk     : in std_logic; -- Clock
         address : in unsigned(6 downto 0); -- Endereço da instrução na ROM
         data    : out unsigned(18 downto 0) := (others => '0') -- Saída (instrução) da ROM
   );
end entity;

architecture a_rom of rom is
   type mem is array (0 to 127) of unsigned(18 downto 0);
   constant rom_content : mem := (
      -- Caso o endereço tenha um conteúdo:
      0 =>  B"1001_0111_0000_0000000", -- CLR R7
      1 =>  B"1000_0000_0000_0000001", -- LI R0, 1
      2 =>  B"1000_0001_0000_0100000", -- LI R1, 32
      3 =>  B"0011_0010_0001_0000000", -- CLZ R2, R1
      4 =>  B"0100_0001_0000_0000001", -- ADDI R1, 1
      5 =>  B"1110_0000_0000_0000000", -- LOAD_LOOP: SW R0, 0(R0)
      6 =>  B"0100_0000_0000_0000001", -- ADDI R0, 1
      7 =>  B"0111_0001_0000_0000000", -- CMP R1, R0
      8 =>  B"1100_0000_0000_1111101", -- BLO LOAD_LOOP (-3)
      9 =>  B"1000_0000_0000_0000001", -- LI R0, 1
      10 => B"1000_0110_0000_0001100", -- LI R6, 12
      11 => B"1001_0100_0000_0000000", -- CLR R4
      12 => B"0100_0000_0000_0000001", -- OUTER_ELIMINATION_LOOP: ADDI R0, 1
      13 => B"1101_0101_0000_0000000", -- LW R5, 0(R0)
      14 => B"0111_0101_0100_0000000", -- CMP R5, R4
      15 => B"1100_0000_0000_0000010", -- BLO MOV_LOOP (+2)
      16 => B"1111_0000_0000_0001100", -- JMP OUTER_ELIMINATION_LOOP (12)
      17 => B"0110_0011_0000_0000000", -- MOV_LOOP: MOV R3, R0
      18 => B"0001_0011_0000_0000000", -- ELIMINATION_LOOP: ADD R3, R0
      19 => B"1110_0011_0100_0000000", -- SW R4, 0(R3)
      20 => B"0011_0101_0011_0000000", -- CLZ R5, R3
      21 => B"0111_0010_0101_0000000", -- CMP R2, R5
      22 => B"1010_0000_0000_1111100", -- BHI ELIMINATION_LOOP (-4)
      23 => B"0111_0110_0000_0000000", -- CMP R6, R0
      24 => B"1100_0000_0000_1110100", -- BLO OUTER_ELIMINATION_LOOP (-12)
      25 => B"0110_1000_0001_0000000", -- MOV R8, R1
      26 => B"1000_0000_0000_0000010", -- LI R0, 2
      27 => B"1101_0011_0000_0000000", -- PRINT_LOOP: LW R3, 0(R0)
      28 => B"0011_0101_0000_0000000", -- CLZ R5, R0
      29 => B"0100_0000_0000_0000001", -- ADDI R0, 1
      30 => B"0111_0011_0100_0000000", -- CMP R3, R4
      31 => B"1100_0000_0000_0000010", -- BLO RESULT_LOOP (+2)
      32 => B"1111_0000_0000_0100011", -- JMP LOOP (35)
      33 => B"1110_1000_0011_0000000", -- RESULT_LOOP: SW R3, 0(R8)
      34 => B"0100_1000_0000_0000001", -- ADDI R8, 1
      35 => B"0111_0010_0101_0000000", -- LOOP: CMP R2, R5
      36 => B"1010_0000_0000_1110111", -- BHI PRINT_LOOP (-9)
      37 => B"0110_1001_0001_0000000", -- MOV R9, R1
      38 => B"1101_0111_1001_0000000", -- PIN_LOOP: LW R7, 0(R9)
      39 => B"0100_1001_0000_0000001", -- ADDI R9, 1
      40 => B"0111_1000_1001_0000000", -- CMP R8, R9
      41 => B"1100_0000_0000_1111101", -- BLO PIN_LOOP (-3)
      42 => B"1111_0000_0000_1111110", -- JMP 126
      -- Abaixo: casos omissos => (zero em todos os bits = NOP, nenhuma operação a executar)
      others => (others=>'0')
   );
begin
   process(clk)
   begin
      if rising_edge(clk) then
         data <= rom_content(to_integer(address)); -- Saída (instrução) da ROM
      end if;
   end process;
end architecture;
