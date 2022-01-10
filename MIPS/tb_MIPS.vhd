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
        clk, reset : in std_logic;
        ReadData : in std_logic_vector(31 downto 0);
        Instr_mips : in std_logic_vector(31 downto 0);
        pc : out std_logic_vector(31 downto 0);
        ALUOut : out std_logic_vector(31 downto 0);
        WriteData : out std_logic_vector(31 downto 0);
        MemWrite : out std_logic
    );
end component;

    -- Clock period definitions
    constant PERIOD     : time := 15 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	inputs_data	    : text open read_mode  is "input.txt";
    file	data_compare        : text open read_mode  is "inputcompare.txt";
	file	outputs_data	    : text open write_mode is "output.txt";
    file	outputs_data_comp   : text open write_mode is "outputdata_comp.txt";

    constant min_value	: natural := 1;
    constant max_value  : natural := 35;

    signal read_data_in	 : std_logic:='0';
    signal flag_write	     : std_logic:='0';

    signal data_CLK   : std_logic := '0';
    signal in_reset : std_logic := '1';
    signal ReadDatain : std_logic_vector(31 downto 0);
    signal instrIN : std_logic_vector(31 downto 0);
    signal pc_out : std_logic_vector(31 downto 0);
    signal ALU_out : std_logic_vector(31 downto 0);
    signal Write_out : std_logic_vector(31 downto 0);
    signal MemWrite_out : std_logic;
begin
    DUT : MIPS 
    port map(
        clk => data_CLK,
        reset => in_reset,
        ReadData => ReadDatain,
        Instr_mips => instrIN,
        pc => pc_out,
        ALUOut => ALU_out,
        WriteData => Write_out,
        MemWrite => MemWrite_out
    );
    data_CLK <= not data_CLK after PERIOD/5;
reset : process
begin
    wait for 600 ns;
    in_reset <= '1';
    wait for 50 ns;
    in_reset <= '0';
    wait;
 end process;

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo inputALUop.txt
------------------------------------------------------------------------------------
data :process
variable linea : line;
variable inputReadData : std_logic_vector(31 downto 0);
variable inputInstr : std_logic_vector(31 downto 0);
begin
while not endfile(inputs_data) loop
    if read_data_in = '1' then
        readline(inputs_data,linea);
        hread(linea,inputReadData);
        ReadDatain <= inputReadData;
        readline(inputs_data,linea);
        read(linea,inputInstr);
        instrIN <= inputInstr;
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
wait for (OFFSET);
    read_data_in <= '1';		
    for i in min_value to max_value loop --para leitura do n° de valores de entrada
        wait for PERIOD;
    end loop;
    read_data_in <= '0';		
wait; --suspend process
end process tb_stimulus;	

------------------------------------------------------------------------------------
------ processo para gerar os estimulos de escrita do arquivo de saida
------------------------------------------------------------------------------------   
tb_outputs : PROCESS
begin
wait for PERIOD;
    flag_write <= '1';
    for i in min_value to max_value loop 
        wait for PERIOD;
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
variable comp_out         : std_logic_vector(31 downto 0);
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
            --readline(data_compare, linea);
			--read(linea, comp_out);
            --assert comp_out = PCoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            --if (comp_out /= PCoutput) then
                --write(lineSTR, string'("Error"));
                --writeline(outputs_data_comp, lineSTR);
           -- else
                --write(lineSTR, string'("Good"));
                --writeline(outputs_data_comp, lineSTR);
            --end if;

            ALUoutput    := ALU_out;
            write(lineSTR, string'("ALUOut"));
            writeline(outputs_data, lineSTR);
            write(linea,ALUoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            --readline(data_compare, linea);
			--read(linea, comp_out);
            --assert comp_out = ALUoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            --if (comp_out /= ALUoutput) then
            --    write(lineSTR, string'("Error"));
           --     writeline(outputs_data_comp, lineSTR);
           -- else
            --    write(lineSTR, string'("Good"));
             --   writeline(outputs_data_comp, lineSTR);
            --end if;

            WriteDataoutput    := Write_out;
            write(lineSTR, string'("Write Data"));
            writeline(outputs_data, lineSTR);
            write(linea,WriteDataoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            --readline(data_compare, linea);
			--read(linea, comp_out);
            --assert comp_out = WriteDataoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            --if (comp_out /= WriteDataoutput) then
            --    write(lineSTR, string'("Error"));
            --    writeline(outputs_data_comp, lineSTR);
            --else
            --    write(lineSTR, string'("Good"));
            --    writeline(outputs_data_comp, lineSTR);
            --end if;

            MemWriteoutput  := MemWrite_out;
            write(lineSTR, string'("MemWrite"));
            writeline(outputs_data, lineSTR);
            write(linea,MemWriteoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            --readline(data_compare, linea);
			--read(linea, comp_out);
            --assert comp_out = MemWriteoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            --if (comp_out /= MemWriteoutput) then
            --    write(lineSTR, string'("Error"));
            --    writeline(outputs_data_comp, lineSTR);
            --else
            --    write(lineSTR, string'("Good"));
             --   writeline(outputs_data_comp, lineSTR);
            --end if;

            write(lineSTR, string'("-------------------------"));
            writeline(outputs_data, lineSTR);
        end if;
        wait for PERIOD;
    end loop; 
end process write_outputs;   		


end test;