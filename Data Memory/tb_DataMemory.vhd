library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_DataMemory is
end tb_DataMemory;

architecture test of tb_DataMemory is

component DataMemory is 
    port(
        MemAddress  : in std_logic_vector (31 downto 0);
		Datain		: in std_logic_vector (31 downto 0);
		clk         : in std_logic;
		WE	        : in std_logic;
		ReadDataOut : out std_logic_vector(31 downto 0)
	);
end component;

    -- Clock period definitions
    constant PERIOD     : time := 15 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	inputs_data_DataMemory  : text open read_mode  is "inputDataMemory.txt";
    file	data_compare            : text open read_mode  is "inputcompare.txt";
	file	outputs_data	        : text open write_mode is "output.txt";
    file	outputs_data_comp       : text open write_mode is "outputdata_comp.txt";

    constant min_value : natural := 1;
    constant max_value : natural := 13;

    signal read_data_in   : std_logic:='0';
    signal flag_write	  : std_logic:='0';

    signal data_in_data  : std_logic_vector(31 downto 0);
    signal data_in_Addr  : std_logic_vector(31 downto 0);
    signal in_clk        : std_logic := '0';
    signal WE_in         : std_logic;
    signal ReadOtoutput  : std_logic_vector(31 downto 0);
    
   
begin
    DUT : DataMemory 
    port map(
        MemAddress  => data_in_Addr,
		Datain		=> data_in_data,
		clk         => in_clk,
		WE	        => WE_in,
		ReadDataOut => ReadOtoutput
    );

    in_clk <= not in_clk after PERIOD/5;
    

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo input.txt
------------------------------------------------------------------------------------
data_U : process
variable linea     : line;
variable inputData : std_logic_vector(31 downto 0);
variable inputWE   : std_logic;
variable inputAddr : std_logic_vector(31 downto 0);
begin
while not endfile(inputs_data_DataMemory) loop
    if read_data_in = '1' then

        readline(inputs_data_DataMemory,linea);
        read(linea, inputAddr);
        data_in_Addr <= inputAddr;

        readline(inputs_data_DataMemory,linea);
        read(linea,inputData);
        data_in_data <= inputData;

        readline(inputs_data_DataMemory,linea);
        read(linea,inputWE);
        WE_in <= inputWE;
    end if;
    wait for PERIOD;
end loop;
wait;
end process data_U;

------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada 
------------------------------------------------------------------------------------
tb_stimulus_PC : PROCESS
begin
wait for (OFFSET + 0.5*PERIOD);
    read_data_in   <= '1';		
    for i in min_value to max_value loop --para leitura do n° de valores de entrada
        wait for PERIOD;
    end loop;
    read_data_in <= '0';		
wait; --suspend process
end process tb_stimulus_PC;	

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
variable linea            : line;
variable lineb            : line;
variable lineSTR          : line;
variable ReadData_out     : std_logic_vector(31 downto 0);
variable CompReadData_out : std_logic_vector(31 downto 0);

begin
    while true loop
        if (flag_write ='1')then

            ReadData_out  := ReadOtoutput;
            write(lineSTR, string'("The output is"));
            writeline(outputs_data, lineSTR);
            write(linea,ReadData_out);
            writeline(outputs_data, linea);

            --To read in order to compare--
            readline(data_compare, lineb);
			read(lineb, CompReadData_out);
            assert CompReadData_out = ReadData_out  report "ERROR" severity warning;

            --Writing if the output it's good or not--
            if (CompReadData_out = ReadData_out) then
                write(lineSTR, string'("GOOD"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("ERROR"));
                writeline(outputs_data_comp, lineSTR);         
            end if;
        end if;
        wait for PERIOD;
    end loop; 
end process write_outputs;   		
end test;