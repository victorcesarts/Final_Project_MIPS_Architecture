library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_MIPSProcessor is
end tb_MIPSProcessor;

architecture test of tb_MIPSProcessor is

component MIPSProcessor is 
    port(
        clk         : in std_logic;
        reset       : in std_logic;
        Instr_MIPS      : out std_logic_vector(31 downto 0);
		ReadData_MIPS   : out std_logic_vector(15 downto 0)
    );
end component;

    -- Clock period definitions
    constant PERIOD     : time := 15 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	data_compare      : text open read_mode  is "inputcompare.txt";
	file	outputs_data	  : text open write_mode is "output.txt";
    file	outputs_data_comp : text open write_mode is "outputdata_comp.txt";

    constant min_value	: natural := 1;
    constant max_value  : natural := 14;

    signal flag_write	: std_logic:='0';

    signal data_CLK     : std_logic := '0';
    signal data_reset   : std_logic := '0';
    signal Instr_out    : std_logic_vector(31 downto 0);
    signal ReadData_out : std_logic_vector(15 downto 0);
    
    
begin
    DUT : MIPSProcessor 
    port map(
        clk      => data_CLK,
        reset    => data_reset,
        Instr_MIPS    => Instr_out,
        ReadData_MIPS => ReadData_out
    );

data_CLK <= not data_CLK after PERIOD/2;


data_reset <= '0', '1' after 15 ns, '0' after 22 ns, '1' after 125 ns, '0' after 135 ns;   

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
variable compInstr_out    : std_logic_vector(15 downto 0);
variable compReadData_out : std_logic_vector(15 downto 0);
variable InstrOutput      : std_logic_vector(31 downto 0);
variable ReadDataOutput   : std_logic_vector(15 downto 0);

begin
    while true loop
        if (flag_write ='1')then
            InstrOutput := Instr_out;
            --write(lineSTR, string'("Instruction"));
            --writeline(outputs_data, lineSTR);
            write(linea,InstrOutput);
            writeline(outputs_data, linea);

            --To read in order to compare--
           -- readline(data_compare, linea);
			--read(linea, compInstr_out);
            --assert compInstr_out = InstrOutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            --if (compInstr_out /= InstrOutput) then
             --   write(lineSTR, string'("Error"));
             --   writeline(outputs_data_comp, lineSTR);
            --else
             --   write(lineSTR, string'("Good"));
              --  writeline(outputs_data_comp, lineSTR);
            --end if;

            ReadDataOutput := ReadData_out;
            --write(lineSTR, string'("DATA"));
            --writeline(outputs_data, lineSTR);
            write(linea,ReadDataOutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            --readline(data_compare, linea);
			--read(linea, compReadData_out);
            --assert compReadData_out = ReadDataOutput  report "ERROR" severity warning;
           -- Writing if the output it's good or not--
            --if (compReadData_out /= ReadDataOutput) then
            --    write(lineSTR, string'("Error"));
             --   writeline(outputs_data_comp, lineSTR);
            --else
             --   write(lineSTR, string'("Good"));
            --    writeline(outputs_data_comp, lineSTR);
            --end if;

            write(lineSTR, string'("-------------------------"));
            writeline(outputs_data, lineSTR);
        end if;
        wait for PERIOD;
    end loop; 
end process write_outputs;   		


end test;