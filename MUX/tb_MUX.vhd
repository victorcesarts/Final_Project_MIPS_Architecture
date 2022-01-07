library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_MUX is
end tb_MUX;

architecture test of tb_MUX is

component MUX is 
    port (
        Control 	: in    std_logic;
        InA    	    : in    std_logic_vector(31 downto 0);
        InB    	    : in    std_logic_vector(31 downto 0);
        OutputS  	: out   std_logic_vector(31 downto 0)
    );
end component;

    -- Clock period definitions
    constant PERIOD     : time := 15 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	inputs_data_MUX	  : text open read_mode  is "inputMUX.txt";
    file	data_compare      : text open read_mode  is "inputcompare.txt";
	file	outputs_data	  : text open write_mode is "output.txt";
    file	outputs_data_comp : text open write_mode is "outputdata_comp.txt";

    constant min_value  : natural := 1;
    constant max_value  : natural := 8192;

    signal read_data_inMUX : std_logic:='0';
    signal flag_write	  : std_logic:='0';

    signal data_MUXControl  : std_logic;
    signal data_in_A        : std_logic_vector(31 downto 0);
    signal data_in_B        : std_logic_vector(31 downto 0);
    signal MUXout           : std_logic_vector(31 downto 0);
   
begin
    DUT : MUX 
    port map(
        Control => data_MUXControl,
        InA     => data_in_A, 
        InB     => data_in_B, 
        OutputS => MUXout
    );

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo inputALUop.txt
------------------------------------------------------------------------------------
data_MUX : process
variable linea     : line;
variable inputMUX  : std_logic;
variable inputA : std_logic_vector(31 downto 0);
variable inputB : std_logic_vector(31 downto 0);
begin
while not endfile(inputs_data_MUX) loop
    if read_data_inMUX = '1' then
        readline(inputs_data_MUX,linea);
        read(linea,inputMUX);
        data_MUXControl <= inputMUX;
        readline(inputs_data_MUX,linea);
        hread(linea,inputA);
        data_in_A <= inputA;
        readline(inputs_data_MUX,linea);
        hread(linea,inputB);
        data_in_B <= inputB;
    end if;
    wait for PERIOD;
end loop;
wait;
end process data_MUX;

------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada do OP
------------------------------------------------------------------------------------
tb_stimulus_MUX : PROCESS
begin
wait for (OFFSET + 0.5*PERIOD);
    read_data_inMUX <= '1';		
    for i in min_value to max_value loop --para leitura do n° de valores de entrada
        wait for PERIOD;
    end loop;
    read_data_inMUX <= '0';		
wait; --suspend process
end process tb_stimulus_MUX;	

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
write_outputs : process
variable linea              : line;
variable lineb              : line;
variable lineSTR            : line;
variable comp_outMUX        : std_logic_vector(31 downto 0);
variable MUXtoutput    : std_logic_vector(31 downto 0);

begin
    while true loop
        if (flag_write ='1')then

            MUXtoutput  := MUXout;
            write(lineSTR, string'("Selected Value"));
            writeline(outputs_data, lineSTR);
            write(linea,MUXtoutput);
           writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, lineb);
			read(lineb, comp_outMUX);
            assert comp_outMUX = MUXtoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (comp_outMUX = MUXtoutput) then
                write(lineSTR, string'("Selected Value"));
                writeline(outputs_data_comp, lineSTR);
                write(lineSTR, string'("GOOD"));
                writeline(outputs_data_comp, lineSTR);
           else
                write(lineSTR, string'("Selected Value"));
                writeline(outputs_data_comp, lineSTR);
                write(lineSTR, string'("ERROR"));
                writeline(outputs_data_comp, lineSTR);
            end if;
            write(lineSTR, string'("-------------------------"));
            writeline(outputs_data_comp, lineSTR);
        end if;
        wait for PERIOD;
    end loop; 
end process write_outputs;   		
end test;