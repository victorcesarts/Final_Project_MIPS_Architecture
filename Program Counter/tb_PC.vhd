library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_PC is
end tb_PC;

architecture test of tb_PC is

component PC is 
    port(
        pcin         : in std_logic_vector(31 downto 0);
        clk, reset   : in std_logic;
        overflowFlag : out std_logic;
        pcout        : out std_logic_vector(31 downto 0)
    );
end component;

    -- Clock period definitions
    constant PERIOD     : time := 15 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	inputs_data_PC    : text open read_mode  is "inputPC.txt";
    file	data_compare      : text open read_mode  is "inputcompare.txt";
	file	outputs_data	  : text open write_mode is "output.txt";
    file	outputs_data_comp : text open write_mode is "outputdata_comp.txt";

    constant min_value  : natural := 1;
    constant max_value  : natural := 329860;

    signal read_data_inPC : std_logic:='0';
    signal flag_write	  : std_logic:='0';

    signal data_in_PCin  : std_logic_vector(31 downto 0);
    signal in_clk        : std_logic := '0';
    signal in_reset      : std_logic := '0';
    signal overflowFLG   : std_logic;
    signal pcoutput      : std_logic_vector(31 downto 0);
   
begin
    DUT : PC 
    port map(
        pcin   => data_in_PCin, 
        clk    => in_clk, 
        reset  => in_reset,
        pcout => pcoutput
    );
    in_clk <= not in_clk after PERIOD/2;
clk : process
begin
    wait for 6000 ns;
    in_reset <= '1';
    wait for 500 ns;
    in_reset <= '0';
    wait;
 end process;

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo input.txt
------------------------------------------------------------------------------------
data_PC : process
variable linea     : line;
variable inputPC : std_logic_vector(31 downto 0);
begin
while not endfile(inputs_data_PC) loop
    if read_data_inPC = '1' then
        readline(inputs_data_PC,linea);
        hread(linea,inputPC);
        data_in_PCin <= inputPC;
    end if;
    wait for PERIOD;
end loop;
wait;
end process data_PC;

------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada 
------------------------------------------------------------------------------------
tb_stimulus_PC : PROCESS
begin
wait for (OFFSET + 0.5*PERIOD);
    read_data_inPC   <= '1';		
    for i in min_value to max_value loop --para leitura do n° de valores de entrada
        wait for PERIOD;
    end loop;
    read_data_inPC <= '0';		
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
variable linea              : line;
variable lineb              : line;
variable lineSTR            : line;
variable comp_outPC  : std_logic_vector(31 downto 0);
variable PCotpt    : std_logic_vector(31 downto 0);

begin
    while true loop
        if (flag_write ='1')then

            PCotpt  := pcoutput;
           --write(lineSTR, string'("The output is"));
            --writeline(outputs_data, lineSTR);
            write(linea,PCotpt);
            writeline(outputs_data, linea);

            --To read in order to compare--
            readline(data_compare, lineb);
			read(lineb, comp_outPC);
            assert comp_outPC = PCotpt  report "ERROR" severity warning;

            --Writing if the output it's good or not--
            if (comp_outPC = PCotpt) then
               -- write(lineSTR, string'("The output is"));
               -- writeline(outputs_data_comp, lineSTR);
                write(lineSTR, string'("GOOD"));
                writeline(outputs_data_comp, lineSTR);
           else
                --write(lineSTR, string'("You've got an"));
                --writeline(outputs_data_comp, lineSTR);
                write(lineSTR, string'("ERROR"));
                writeline(outputs_data_comp, lineSTR);

            end if;
           -- write(lineSTR, string'("-------------------------"));
           -- writeline(outputs_data_comp, lineSTR);

        end if;
        wait for PERIOD;
    end loop; 
end process write_outputs;   		
end test;