library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Lctrl_unitas Yukio Fukuda Matsumoto - Matrícula 2516977
-- Laboratório uProcessador 4
-- UC (Unidade de Controle)
entity ctrl_unit is
    port(
        clk             : in  std_logic; -- Clock
        rst             : in  std_logic; -- Reset
        instr           : in  unsigned(18 downto 0); -- Instrução
        reg_src_data    : in  unsigned(15 downto 0); -- Dados do registrador de origem
        reg_dest_data   : in  unsigned(15 downto 0); -- Dados do registrador de destino
        ram_out_data    : in  unsigned(15 downto 0); -- Dados da saída da RAM
        pc_out          : in  unsigned(6 downto 0); -- Saída do PC
        C               : in  std_logic; -- Flag de carry
        Z               : in  std_logic; -- Flag de zero
        V               : in  std_logic; -- Flag de overflow
        invalid_address : in  std_logic; -- Flag de endereço de ROM inválido
        val1, val2      : out unsigned(15 downto 0) := (others => '0'); -- Valores para a ULA
        ula_opcode      : out unsigned(2 downto 0) := (others => '0'); -- Código da operação da ULA
        banco_wr_en     : out std_logic := '0'; -- Habilitador de escrita no banco de registradores
        flags_wr_en     : out std_logic := '0'; -- Habilitador de escrita no registrador de flags
        src_addr        : out unsigned(3 downto 0) := (others => '0'); -- Endereço do registrador fonte no banco
        dest_addr       : out unsigned(3 downto 0) := (others => '0'); -- Endereço do registrador destino no banco
        ram_wr_en       : out std_logic := '0'; -- Habilitador de escrita na RAM
        ram_addr        : out unsigned(6 downto 0) := (others => '0'); -- Endereço da RAM
        pc_in           : out unsigned(6 downto 0) := (others => '0'); -- Próximo endereço do PC
        pc_wr_en        : out std_logic := '0'; -- Habilitador de escrita no PC
        reg_instr_wr_en : out std_logic := '0'; -- Habilitador de escrita no registrador de instrução
        error           : out std_logic := '0' -- Flag de erro
    );
end entity;

architecture a_ctrl_unit of ctrl_unit is
    signal state_sig      : unsigned(1 downto 0) := (others => '0'); -- Estado da máquina de estados
    signal opcode         : unsigned(3 downto 0) := (others => '0'); -- Código da operação
    signal dest_addr_sig  : unsigned(3 downto 0) := (others => '0'); -- Endereço do registrador destino no banco
    signal src_addr_sig   : unsigned(3 downto 0) := (others => '0'); -- Endereço do registrador fonte no banco
    signal imm_val_sig    : unsigned(6 downto 0) := (others => '0'); -- Valor em complemento de 2 (7 bits)
    signal jump_addr      : unsigned(6 downto 0) := (others => '0'); -- Endereço de salto
    signal jump_en        : std_logic := '0'; -- Habilitador de jump
    signal branch_code    : unsigned(1 downto 0) := (others => '0'); -- Habilitador de tipos de branch
    signal unknown        : std_logic := '0'; -- Flag que sinaliza instrução desconhecida
    signal ram_delta      : signed(7 downto 0) := (others => '0'); -- Delta para endereço da RAM
    signal ram_addr_sig   : unsigned(7 downto 0) := (others => '0'); -- Endereço da RAM
begin
    -- Instanciação da máquina de estados de 3 estados
    state_machine_inst : entity work.state_machine
        port map (
            clk   => clk, -- Clock
            rst   => rst, -- Reset
            state => state_sig -- Estado da máquina de estados
        );

    -- Atribuições baseadas no estado (só vai usar se o respectivo enable estiver ativo)
    opcode        <= instr(18 downto 15);
    dest_addr_sig <= instr(14 downto 11);
    src_addr_sig  <= instr(10 downto 7);
    imm_val_sig   <= instr(6 downto 0);

    -- Verifica se a instrução é desconhecida
    unknown <= '0' when (opcode = "0000" or -- NOP
                         opcode = "0001" or -- ADD
                         opcode = "0010" or -- SUB
                         opcode = "0011" or -- CLZ
                         opcode = "0100" or -- ADDI
                         opcode = "0101" or -- SUBI
                         opcode = "0110" or -- MOV
                         opcode = "0111" or -- CMP
                         opcode = "1000" or -- LI
                         opcode = "1001" or -- CLR
                         opcode = "1010" or -- BHI
                         opcode = "1011" or -- BVS
                         opcode = "1100" or -- BLO
                         opcode = "1101" or -- LW
                         opcode = "1110" or -- SW
                         opcode = "1111") else -- JUMP
               '1';

    -- Verifica se é um salto
    jump_en <= '1' when (opcode = "1111") else '0';
    jump_addr <= imm_val_sig when (opcode = "1111" or opcode = "1010" or opcode = "1011" or opcode = "1100") else "0000000";
    branch_code <= "01" when (opcode = "1010") else -- BHI
                   "10" when (opcode = "1011") else -- BVS
                   "11" when (opcode = "1100") else -- BLO
                   (others => '0');

    -- Verifica se é para atualizar o registrador de flags
    flags_wr_en <= '0' when (((state_sig = "00" or state_sig = "10") and opcode = "0111") or -- CMP, impede gravar no fetch/decode, permite apenas no execute da comparação
                             opcode = "1010" or    -- BHI
                             opcode = "1011" or    -- BVS
                             opcode = "1100" or    -- BLO
                             opcode = "1111" or    -- JUMP
                             opcode = "0000" or    -- NOP
                             opcode = "0110" or    -- MOV
                             opcode = "1000" or    -- LI
                             opcode = "0011" or    -- CLZ
                             opcode = "1001" or    -- CLR
                             opcode = "1101" or    -- LW
                             opcode = "1110") else -- SW
                   '1';

    ula_opcode <= "001" when (state_sig = "01" and (opcode = "0001" or opcode = "0100" or opcode = "1000" or opcode = "1001")) else -- ADD, ADDI, LI e CLR
                  "010" when (state_sig = "01" and (opcode = "0010" or opcode = "0101" or opcode = "0111")) else -- SUB, SUBI e CMP
                  "011" when (state_sig = "01" and (opcode = "0110" or opcode = "1101" or opcode = "1110")) else -- MOV, LW e SW
                  "100" when (state_sig = "01" and opcode = "0011") else -- CLZ
                  (others => '0'); -- NOP, JUMP, BHI, BVS e BLO

    -- Valores para a ULA
    val1 <= reg_src_data when (opcode = "0001" or     -- ADD
                               opcode = "0010" or     -- SUB
                               opcode = "0011" or     -- CLZ
                               opcode = "0110" or     -- MOV
                               opcode = "0111" or     -- CMP
                               opcode = "1110") else  -- SW
            ram_out_data when (opcode = "1101") else  -- LW
            reg_dest_data when (opcode = "0100" or    -- ADDI
                                opcode = "0101") else -- SUBI
            (others => '0'); -- LI, NOP, CLR, JUMP, BHI, BVS e BLO

    val2 <= reg_dest_data when (state_sig = "01" and (opcode = "0001" or     -- ADD
                                                      opcode = "0010" or     -- SUB
                                                      opcode = "0111")) else -- CMP
            "000000000" & imm_val_sig when (opcode = "0100" or    -- ADDI
                                            opcode = "0101" or    -- SUBI
                                            opcode = "1000") else -- LI
            (others => '0'); -- MOV, CLZ, NOP, CLR, JUMP, BHI, BVS, BLO, LW e SW

    -- Endereços dos registradores
    src_addr <= src_addr_sig;
    dest_addr <= dest_addr_sig;

    -- Habilitador de escrita no banco de registradores
    banco_wr_en <= '1' when (state_sig = "01" and (opcode = "0001" or     -- ADD
                                                   opcode = "0010" or     -- SUB
                                                   opcode = "0011" or     -- CLZ
                                                   opcode = "0100" or     -- ADDI
                                                   opcode = "0101" or     -- SUBI
                                                   opcode = "0110" or     -- MOV
                                                   opcode = "1000" or     -- LI
                                                   opcode = "1001" or     -- CLR
                                                   opcode = "1101")) else -- LW
                   '0';

    -- Habilitador de escrita na RAM
    ram_wr_en <= '1' when (state_sig = "01" and opcode = "1110") else -- SW
                 '0';
    ram_delta <= signed(imm_val_sig(6) & imm_val_sig);
    ram_addr_sig <= unsigned(signed(reg_src_data(7 downto 0)) + ram_delta) when (state_sig = "01" and opcode = "1101") else -- LW
                unsigned(signed(reg_dest_data(7 downto 0)) + ram_delta) when (state_sig = "01" and opcode = "1110") else -- SW
                (others => '0');
    ram_addr <= ram_addr_sig(6 downto 0);

    pc_in <= jump_addr when (state_sig = "01" and jump_en = '1') else -- Pula para endereço absoluto se é JUMP
             unsigned(signed(pc_out) + signed(jump_addr)) when (state_sig = "01" and ((branch_code = "11" and C = '1' and Z = '0') or -- Pula endereço relativo se BLO
                                                               (branch_code = "10" and V = '1') or -- Pula endereço relativo se BVS
                                                               (branch_code = "01" and C = '0' and Z = '0'))) else -- Pula endereço relativo se BHI
             pc_out + 1; -- Incrementa o PC se não é JUMP nem BRANCH
       
    pc_wr_en <= '1' when (state_sig = "01") else -- Habilita escrita no PC se o estado é decode (próxima instrução)
                '0'; -- Desabilita escrita no PC se o estado não é decode

    reg_instr_wr_en <= '1' when (state_sig = "00") else -- Habilita escrita no registrador de instrução se o estado é fetch
                       '0'; -- Desabilita escrita no registrador de instrução se o estado não é fetch
       
    error <= unknown or invalid_address or ram_addr_sig(7); -- Flag de erro se instrução desconhecida ou endereço de ROM inválido ou endereço de RAM inválido

end architecture;
