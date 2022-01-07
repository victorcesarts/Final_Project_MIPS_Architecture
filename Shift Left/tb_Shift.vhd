library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_Shift is
end tb_Shift;

architecture test of tb_Shift is

component ShiftLeft is 
    port(
        InSll  : in std_logic_vector(31 downto 0);
        OutSll : out std_logic_vector(31 downto 0)
    );
end component;

    -- Clock period definitions
    constant PERIOD     : time := 15 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	inputs_data_SLL   : text open read_mode  is "inputShift.txt";
    file	data_compare      : text open read_mode  is "inputcompare.txt";
	file	outputs_data	  : text open write_mode is "output.txt";
    file	outputs_data_comp : text open write_mode is "outputdata_comp.txt";

    constant min_value  : natural := 1;
    constant max_value  : natural := 1024;

    signal read_data_inShift : std_logic:='0';
    signal flag_write	     : std_logic:='0';

    signal data_in  : std_logic_vector(31 downto 0);
    signal data_Out : std_logic_vector(31 downto 0);
   
begin
    DUT : ShiftLeft 
    port map(
        InSll => data_in, 
        OutSll => data_Out 
    );

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo inputALUop.txt
------------------------------------------------------------------------------------
data_Sll : process
variable linea     : line;
variable input : std_logic_vector(31 downto 0);
begin
while not endfile(inputs_data_SLL) loop
    if read_data_inShift = '1' then
        readline(inputs_data_SLL,linea);
        hread(linea,input);
        data_in <= input;
    end if;
    wait for PERIOD;
end loop;
wait;
end process data_Sll;

------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada do OP
------------------------------------------------------------------------------------
tb_stimulus_Adder : PROCESS
begin
wait for (OFFSET + 0.5*PERIOD);
    read_data_inShift <= '1';		
    for i in min_value to max_value loop --para leitura do n° de valores de entrada
        wait for PERIOD;
    end loop;
    read_data_inShift <= '0';		
wait; --suspend process
end process tb_stimulus_Adder;	

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
variable comp_outSll   : std_logic_vector(31 downto 0);
variable Slltoutput    : std_logic_vector(31 downto 0);

begin
    while true loop
        if (flag_write ='1')then

            Slltoutput  := data_Out;
            write(lineSTR, string'("Selected Value"));
            writeline(outputs_data, lineSTR);
            write(linea,Slltoutput);
            writeline(outputs_data, linea);

            --To read in order to compare--
            readline(data_compare, lineb);
			read(lineb, comp_outSll);
            assert comp_outSll = Slltoutput  report "ERROR" severity warning;

            --Writing if the output it's good or not--
            if (comp_outSll = Slltoutput) then
                write(lineSTR, string'("It is"));
                writeline(outputs_data_comp, lineSTR);
                write(lineSTR, string'("GOOD"));
                writeline(outputs_data_comp, lineSTR);
           else
                write(lineSTR, string'("You've got an"));
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