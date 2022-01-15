library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_REGFile is
end tb_REGFile;

architecture test of tb_REGFile is

component RegisterFile is 
port(
        A1 : in std_logic_vector(4 downto 0);
        A2 : in std_logic_vector(4 downto 0);
        A3 : in std_logic_vector(4 downto 0);
        WD3 : in std_logic_vector(31 downto 0);
        WE3 : in std_logic;
        clk : in std_logic;
        RD1 : out std_logic_vector(31 downto 0);
        RD2 : out std_logic_vector(31 downto 0)
    );

end component;

    -- Clock period definitions
    constant PERIOD     : time := 15 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	inputs_data_REG   : text open read_mode  is "inputREGfile.txt";
    file	data_compare      : text open read_mode  is "inputcompare.txt";
	file	outputs_data	  : text open write_mode is "output.txt";
    file	outputs_data_comp : text open write_mode is "outputdata_comp.txt";

    constant min_value  : natural := 1;
    constant max_value  : natural := 13;
    --2895622

    signal read_data_inREG : std_logic:='0';
    signal flag_write	  : std_logic:='0';

    signal data_A1        : std_logic_vector(4 downto 0);
    signal data_A2        : std_logic_vector(4 downto 0);
    signal data_A3        : std_logic_vector(4 downto 0);
    signal data_WD3        : std_logic_vector(31 downto 0);
    signal data_WE3        : std_logic;
    signal data_RD1       : std_logic_vector(31 downto 0);
    signal data_RD2        : std_logic_vector(31 downto 0);
    signal data_CLK        : std_logic := '0';
   
   
begin
    DUT : RegisterFile 
    port map(
        A1  => data_A1,
        A2  => data_A2, 
        A3  => data_A3, 
        WD3 => data_WD3,
        WE3 => data_WE3,
        RD1 => data_RD1,
        RD2 => data_RD2,
        clk => data_CLK
    );

    data_CLK <= not data_CLK after PERIOD/5;

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo input.txt
------------------------------------------------------------------------------------
data_reg:process
variable linea    : line;
variable inputA1  : std_logic_vector(4 downto 0);
variable inputA2  : std_logic_vector(4 downto 0);
variable inputA3  : std_logic_vector(4 downto 0);
variable inputWD3 : std_logic_vector(31 downto 0);
variable inputWE3 : std_logic;
variable inputRD1 : std_logic_vector(31 downto 0);
variable inputRD2 : std_logic_vector(31 downto 0);
begin
while not endfile(inputs_data_REG) loop
    if read_data_inREG = '1' then
        readline(inputs_data_REG,linea);
        read(linea,inputA1);
        data_A1 <= inputA1;
        readline(inputs_data_REG,linea);
        read(linea,inputA2);
        data_A2 <= inputA2;
        readline(inputs_data_REG,linea);
        read(linea,inputA3);
        data_A3 <= inputA3;
        readline(inputs_data_REG,linea);
        hread(linea,inputWD3);
        data_WD3 <= inputWD3;
        readline(inputs_data_REG,linea);
        read(linea,inputWE3);
        data_WE3 <= inputWE3;
    end if;
    wait for PERIOD;
end loop;
wait;
end process data_reg;

------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada 
------------------------------------------------------------------------------------
tb_stimulus_REG : PROCESS
begin
wait for (OFFSET + 0.5*PERIOD);
    read_data_inREG <= '1';		
    for i in min_value to max_value loop --para leitura do n° de valores de entrada
        wait for PERIOD;
    end loop;
    read_data_inREG <= '0';		
wait; --suspend process
end process tb_stimulus_REG;	

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
variable linea       : line;
variable lineb       : line;
variable lineSTR     : line;
variable comp_outRD1 : std_logic_vector(31 downto 0);
variable comp_outRD2 : std_logic_vector(31 downto 0);
variable RD1Out      : std_logic_vector(31 downto 0);
variable RD2Out      : std_logic_vector(31 downto 0);


begin
    while true loop
        if (flag_write ='1')then

            RD1Out  := data_RD1;
            write(lineSTR, string'("RD1"));
            writeline(outputs_data, lineSTR);
            write(linea,RD1Out);
            writeline(outputs_data, linea);
            --To read in order to compare--
            --readline(data_compare, lineb);
			--read(lineb, comp_outRD1);
            --assert comp_outRD1 = RD1Out  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            --if (comp_outRD1 = RD1Out) then
             --   write(lineSTR, string'("GOOD"));
             --   writeline(outputs_data_comp, lineSTR);
           --else
                --write(lineSTR, string'("ERROR"));
                --writeline(outputs_data_comp, lineSTR);
           --end if;

            RD2Out  := data_RD2;
            write(lineSTR, string'("RD1"));
            writeline(outputs_data, lineSTR);
            write(linea,RD2Out);
            writeline(outputs_data, linea);
            --To read in order to compare--
            --readline(data_compare, lineb);
			--read(lineb, comp_outRD2);
            --assert comp_outRD2 = RD2Out  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            --if (comp_outRD2 = RD2Out) then
                --write(lineSTR, string'("GOOD"));
                --writeline(outputs_data_comp, lineSTR);
           --else
                --write(lineSTR, string'("ERROR"));
                --writeline(outputs_data_comp, lineSTR);
            --end if;

            write(lineSTR, string'("-------------------------"));
            writeline(outputs_data, lineSTR);
        end if;
        wait for PERIOD;
    end loop; 
end process write_outputs;   		
end test;