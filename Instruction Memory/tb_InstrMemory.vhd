library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_InstrMemory is
end tb_InstrMemory;

architecture test of tb_InstrMemory is

component InstrMemory is    
        port(
        address : in std_logic_vector(31 downto 0);
        instr : out std_logic_vector(31 downto 0)
    );
end component;

    -- Clock period definitions
    constant PERIOD     : time := 15 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	inputs_data	        : text open read_mode  is "inputData.txt";
    file	data_compare        : text open read_mode  is "inputcompare.txt";
	file	outputs_data	    : text open write_mode is "output.txt";
    file	outputs_data_comp   : text open write_mode is "outputdata_comp.txt";

    constant min_value	: natural := 1;
    constant max_value  : natural := 14;

    signal read_data	 : std_logic:='0';
    signal flag_write	     : std_logic:='0';

    signal data_in    : std_logic_vector(31 downto 0);
    signal data_instr : std_logic_vector(31 downto 0);
   
begin
    DUT : InstrMemory 
    port map(
        address => data_in,
        instr   => data_instr
    );

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo inputALUop.txt
------------------------------------------------------------------------------------
data :process
variable linea : line;
variable inputDT : std_logic_vector(31 downto 0);
begin
while not endfile(inputs_data) loop
    if read_data = '1' then
        readline(inputs_data,linea);
        hread(linea,inputDT);
        data_in <= inputDT;
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
wait for (OFFSET + 0.5*PERIOD);
    read_data <= '1';		
    for i in min_value to max_value loop --para leitura do n° de valores de entrada
        wait for PERIOD;
    end loop;
    read_data <= '0';		
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
variable comp_out         : std_logic;
variable comp_outALU      : std_logic_vector(2 downto 0);
variable DataInstrout   : std_logic_vector(31 downto 0);

begin
    while true loop
        if (flag_write ='1')then
            DataInstrout  := data_instr;
            write(lineSTR, string'("RegWrite"));
            writeline(outputs_data, lineSTR);
            write(linea,DataInstrout);
            writeline(outputs_data, linea);
            --To read in order to compare--
            --readline(data_compare, linea);
			--read(linea, comp_out);
            --assert comp_out = DataInstrout  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            --if (comp_out /= DataInstrout) then
                --write(lineSTR, string'("Error"));
                --writeline(outputs_data_comp, lineSTR);
            --else
                --write(lineSTR, string'("Good"));
                --writeline(outputs_data_comp, lineSTR);
            --end if;

            write(lineSTR, string'("-------------------------"));
            writeline(outputs_data, lineSTR);
        end if;
        wait for PERIOD;
    end loop; 
end process write_outputs;   		


end test;