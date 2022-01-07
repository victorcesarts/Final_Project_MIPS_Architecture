library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_Adder is
end tb_Adder;

architecture test of tb_Adder is

component Adder is 
    port (
        InA   : in std_logic_vector(31 downto 0);
        InB   : in std_logic_vector(31 downto 0);
        Result : out std_logic_vector(31 downto 0)
    );
end component;

    -- Clock period definitions
    constant PERIOD     : time := 15 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	inputs_data_Adder : text open read_mode  is "inputAdder.txt";
    file	data_compare      : text open read_mode  is "inputcompare.txt";
	file	outputs_data	  : text open write_mode is "output.txt";
    file	outputs_data_comp : text open write_mode is "outputdata_comp.txt";

    constant min_value  : natural := 1;
    constant max_value  : natural := 4096;

    signal read_data_inAdder : std_logic:='0';
    signal flag_write	     : std_logic:='0';

    signal data_in_A        : std_logic_vector(31 downto 0);
    signal data_in_B        : std_logic_vector(31 downto 0);
    signal Adderout           : std_logic_vector(31 downto 0);
   
begin
    DUT : Adder 
    port map(
        InA     => data_in_A, 
        InB     => data_in_B, 
        Result => Adderout
    );

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo inputALUop.txt
------------------------------------------------------------------------------------
data_Adder : process
variable linea     : line;
variable inputA : std_logic_vector(31 downto 0);
variable inputB : std_logic_vector(31 downto 0);
begin
while not endfile(inputs_data_Adder) loop
    if read_data_inAdder = '1' then
        readline(inputs_data_Adder,linea);
        hread(linea,inputA);
        data_in_A <= inputA;
        readline(inputs_data_Adder,linea);
        hread(linea,inputB);
        data_in_B <= inputB;
    end if;
    wait for PERIOD;
end loop;
wait;
end process data_Adder;

------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada do OP
------------------------------------------------------------------------------------
tb_stimulus_Adder : PROCESS
begin
wait for (OFFSET + 0.5*PERIOD);
    read_data_inAdder <= '1';		
    for i in min_value to max_value loop --para leitura do n° de valores de entrada
        wait for PERIOD;
    end loop;
    read_data_inAdder <= '0';		
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
variable comp_outAdder   : std_logic_vector(31 downto 0);
variable Addertoutput    : std_logic_vector(31 downto 0);

begin
    while true loop
        if (flag_write ='1')then

            Addertoutput  := Adderout;
            write(lineSTR, string'("Selected Value"));
            writeline(outputs_data, lineSTR);
            write(linea,Addertoutput);
            writeline(outputs_data, linea);

            --To read in order to compare--
            readline(data_compare, lineb);
			read(lineb, comp_outAdder);
            assert comp_outAdder = Addertoutput  report "ERROR" severity warning;

            --Writing if the output it's good or not--
            if (comp_outAdder = Addertoutput) then
                write(lineSTR, string'("Sum is"));
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