library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_ALU is
end tb_ALU;

architecture test of tb_ALU is

component ALU is 
port (
    ALUControl 	: in    std_logic_vector(2 downto 0);
    SrcA    	: in    std_logic_vector(31 downto 0);
    SrcB    	: in    std_logic_vector(31 downto 0);
    ZEROFlag  	: out   std_logic;
    ALUResult	: out   std_logic_vector(31 downto 0)
);

end component;

    -- Clock period definitions
    constant PERIOD     : time := 15 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	inputs_data_ALU	  : text open read_mode  is "inputALU.txt";
    file	data_compare      : text open read_mode  is "inputcompare.txt";
	file	outputs_data	  : text open write_mode is "output.txt";
    file	outputs_data_comp : text open write_mode is "outputdata_comp.txt";

    constant min_value  : natural := 1;
    constant max_value  : natural := 54;

    signal read_data_inALU : std_logic:='0';
    signal flag_write	  : std_logic:='0';

    signal data_ALUControl  : std_logic_vector(2 downto 0);
    signal data_in_SrcA     : std_logic_vector(31 downto 0);
    signal data_in_SrcB     : std_logic_vector(31 downto 0);
    signal ZEROFlagout      : std_logic;
    signal ALUresultout     : std_logic_vector(31 downto 0);
   
begin
    DUT : ALU 
    port map(
        ALUControl  => data_ALUControl,
        SrcA        => data_in_SrcA, 
        SrcB        => data_in_SrcB, 
        ZEROFlag    => ZEROFlagout,
        ALUResult   => ALUresultout
    );

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo inputALUop.txt
------------------------------------------------------------------------------------
data_alu:process
variable linea     : line;
variable inputALU  : std_logic_vector(2 downto 0);
variable inputSrcA : std_logic_vector(31 downto 0);
variable inputSrcB : std_logic_vector(31 downto 0);
begin
while not endfile(inputs_data_ALU) loop
    if read_data_inALU = '1' then
        readline(inputs_data_ALU,linea);
        read(linea,inputALU);
        data_ALUControl <= inputALU;
        readline(inputs_data_ALU,linea);
        hread(linea,inputSrcA);
        data_in_SrcA <= inputSrcA;
        readline(inputs_data_ALU,linea);
        hread(linea,inputSrcB);
        data_in_SrcB <= inputSrcB;
    end if;
    wait for PERIOD;
end loop;
wait;
end process data_alu;

------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada do OP
------------------------------------------------------------------------------------
tb_stimulus_ALU : PROCESS
begin
wait for (OFFSET + 0.5*PERIOD);
    read_data_inALU <= '1';		
    for i in min_value to max_value loop --para leitura do n° de valores de entrada
        wait for PERIOD;
    end loop;
    read_data_inALU <= '0';		
wait; --suspend process
end process tb_stimulus_ALU;	

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
variable linea              : line;
variable lineb              : line;
variable lineSTR            : line;
variable comp_outALU        : std_logic_vector(31 downto 0);
variable comp_outZERO       : std_logic;
variable ZEROFlagoutput     : std_logic;
variable ALUresultoutput    : std_logic_vector(31 downto 0);

begin
    while true loop
        if (flag_write ='1')then

            ALUresultoutput  := ALUresultout;
            write(lineSTR, string'("ALUresult"));
            writeline(outputs_data, lineSTR);
            write(linea,ALUresultoutput);
           writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, lineb);
			read(lineb, comp_outALU);
            assert comp_outALU = ALUresultoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (comp_outALU = ALUresultoutput) then
                write(lineSTR, string'("ALU Result"));
                writeline(outputs_data_comp, lineSTR);
                write(lineSTR, string'("GOOD"));
                writeline(outputs_data_comp, lineSTR);
           else
                write(lineSTR, string'("ALU Result"));
                writeline(outputs_data_comp, lineSTR);
                write(lineSTR, string'("ERROR"));
                writeline(outputs_data_comp, lineSTR);
            end if;

            ZEROFlagoutput := ZEROFlagout;
            write(lineSTR, string'("ZEROFlag"));
            writeline(outputs_data, lineSTR);
            write(linea,ZEROFlagoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, lineb);
			read(lineb, comp_outZERO);
            assert comp_outZERO = ZEROFlagoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (comp_outZERO /= ZEROFlagoutput) then
                write(lineSTR, string'("Zero Flag"));
                writeline(outputs_data_comp, lineSTR);
                write(lineSTR, string'("Error"));
                writeline(outputs_data_comp, lineSTR);
                write(lineSTR, string'("-------------------------"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("Zero Flag"));
                writeline(outputs_data_comp, lineSTR);
                write(lineSTR, string'("Good"));
                writeline(outputs_data_comp, lineSTR);
                write(lineSTR, string'("-------------------------"));
                writeline(outputs_data_comp, lineSTR);
            end if;
            write(lineSTR, string'("-------------------------"));
            writeline(outputs_data, lineSTR);
        end if;
        wait for PERIOD;
    end loop; 
end process write_outputs;   		
end test;