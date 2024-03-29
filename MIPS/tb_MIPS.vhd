library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_MIPS is
end tb_MIPS;

architecture test of tb_MIPS is

component MIPS is 
    port(
        clk, reset  : in std_logic;
        Instruction : in std_logic_vector(31 downto 0);
        ReadData    : in std_logic_vector(31 downto 0);
        ALUOut      : out std_logic_vector(31 downto 0);
        PC          : out std_logic_vector(31 downto 0);
        WriteData   : out std_logic_vector(31 downto 0);
        MemWrite    : out std_logic
    );
end component;

    -- Clock period definitions
    constant PERIOD     : time := 20 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	inputs_data	      : text open read_mode  is "input.txt";
    file	data_compare      : text open read_mode  is "inputcompare.txt";
	file	outputs_data	  : text open write_mode is "output.txt";
    file	outputs_data_comp : text open write_mode is "outputdata_comp.txt";

    constant min_value	: natural := 1;
    constant max_value  : natural := 22;

    signal read_data_in	 : std_logic:='0';
    signal flag_write	 : std_logic:='0';

    signal data_CLK     : std_logic := '0';
    signal data_reset   : std_logic := '0';
    signal ReadDatain   : std_logic_vector(31 downto 0);
    signal data_Instr   : std_logic_vector(31 downto 0);
    signal pc_out       : std_logic_vector(31 downto 0);
    signal ALU_out      : std_logic_vector(31 downto 0);
    signal Write_out    : std_logic_vector(31 downto 0);
    signal MemWrite_out : std_logic;
    signal Tempo : std_logic := '0';
begin
    DUT : MIPS 
    port map(
        clk         => data_CLK,
        reset       => data_reset,
        ReadData    => ReadDatain,
        Instruction => data_Instr,
        PC          => pc_out,
        ALUOut      => ALU_out,
        WriteData   => Write_out,
        MemWrite    => MemWrite_out
    );
    Tempo <= '1' afteR 20 ns;
    clk : process
    begin
        if Tempo = '1' then
            data_CLK <= not data_CLK;
        end if;
        wait for DUTY_CYCLE*PERIOD;
    end process;
    data_reset <= '0', '1' after 18 ns, '0' after 23 ns;
    

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo input.txt
------------------------------------------------------------------------------------
data :process
variable linea         : line;
variable inputReadData : std_logic_vector(31 downto 0);
variable inputInstr    : std_logic_vector(31 downto 0);
begin
while not endfile(inputs_data) loop
    if read_data_in = '1' then
        readline(inputs_data,linea);
        read(linea,inputInstr);
        data_Instr <= inputInstr;

        readline(inputs_data,linea);
        hread(linea,inputReadData);
        ReadDatain <= inputReadData;
    end if;
    wait for PERIOD;
end loop;
wait;
end process data;

------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada do OP
------------------------------------------------------------------------------------
tb_stimulus : PROCESS
begin
wait for (PERIOD+OFFSET);
    read_data_in <= '1';		
    for i in min_value to max_value loop --para leitura do n° de valores de entrada
        wait for DUTY_CYCLE*PERIOD;
    end loop;
    read_data_in <= '0';		
wait; --suspend process
end process tb_stimulus;	

------------------------------------------------------------------------------------
------ processo para gerar os estimulos de escrita do arquivo de saida
------------------------------------------------------------------------------------   
tb_outputs : PROCESS
begin
wait for PERIOD+OFFSET;
    flag_write <= '1';
    for i in min_value to max_value loop 
        wait for DUTY_CYCLE*PERIOD;
    end loop;
    flag_write <= '0';			
wait; 
END PROCESS tb_outputs;   
-- ------------------------------------------------------------------------------------
-- ------ processo para escrever os dados de saida no output.txt
-- ------------------------------------------------------------------------------------   
write_outputs:process
variable linea            : line;
variable lineSTR          : line;
variable compPC_out       : std_logic_vector(31 downto 0);
variable compALU_out      : std_logic_vector(31 downto 0);
variable compWD_out       : std_logic_vector(31 downto 0);
variable compWE_out       : std_logic;
variable PCoutput         : std_logic_vector(31 downto 0);
variable ALUoutput        : std_logic_vector(31 downto 0);
variable WriteDataoutput  : std_logic_vector(31 downto 0);
variable MemWriteoutput   : std_logic;


begin
    while true loop
        if (flag_write ='1')then
            PCoutput  := pc_out;
            write(lineSTR, string'("PC"));
            writeline(outputs_data, lineSTR);
            write(linea,PCoutput);
            writeline(outputs_data, linea);

            --To read in order to compare--
            readline(data_compare, linea);
			read(linea, compPC_out);
            assert compPC_out = PCoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (compPC_out /= PCoutput) then
                write(lineSTR, string'("Error"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("Good"));
                writeline(outputs_data_comp, lineSTR);
            end if;

            ALUoutput    := ALU_out;
            write(lineSTR, string'("ALUOut"));
            writeline(outputs_data, lineSTR);
            write(linea,ALUoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, linea);
			read(linea, compALU_out);
            assert compALU_out = ALUoutput  report "ERROR" severity warning;
           -- Writing if the output it's good or not--
            if (compALU_out /= ALUoutput) then
                write(lineSTR, string'("Error"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("Good"));
                writeline(outputs_data_comp, lineSTR);
            end if;

            WriteDataoutput    := Write_out;
            write(lineSTR, string'("Write Data"));
            writeline(outputs_data, lineSTR);
            write(linea,WriteDataoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, linea);
			read(linea, compWD_out);
            assert compWD_out = WriteDataoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (compWD_out /= WriteDataoutput) then
                write(lineSTR, string'("Error"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("Good"));
                writeline(outputs_data_comp, lineSTR);
            end if;

            MemWriteoutput  := MemWrite_out;
            write(lineSTR, string'("MemWrite"));
            writeline(outputs_data, lineSTR);
            write(linea,MemWriteoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, linea);
			read(linea, compWE_out);
            assert compWE_out = MemWriteoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (compWE_out /= MemWriteoutput) then
                write(lineSTR, string'("Error"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("Good"));
                writeline(outputs_data_comp, lineSTR);
            end if;

            write(lineSTR, string'("-------------------------"));
            writeline(outputs_data, lineSTR);
        end if;
        wait for PERIOD;
    end loop; 
end process write_outputs;   		


end test;