library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_ControlUnit is
end tb_ControlUnit;

architecture test of tb_ControlUnit is

component ControlUnit is 
    port(    
        OP          : in std_logic_vector (5 downto 0);
        Funct       : in std_logic_vector (5 downto 0);
        MemToReg    : out std_logic;
        MemWrite    : out std_logic;
        Branch      : out std_logic;
        ALUControl  : out std_logic_vector(2 downto 0);
        AluSrc      : out std_logic;
        RegDst      : out std_logic;
        RegWrite    : out std_logic;
        Jump        : out std_logic
    );

end component;

    -- Clock period definitions
    constant PERIOD     : time := 15 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	inputs_data_op	    : text open read_mode  is "inputop.txt";
    file	inputs_data_Funct   : text open read_mode  is "inputFunct.txt";
    file	data_compare        : text open read_mode  is "inputcompare.txt";
	file	outputs_data	    : text open write_mode is "output.txt";
    file	outputs_data_comp   : text open write_mode is "outputdata_comp.txt";

    constant min_value	: natural := 1;
    constant max_value  : natural := 14;

    signal read_data_inOP	 : std_logic:='0';
    signal read_data_inFunct : std_logic:='0';
    signal flag_write	     : std_logic:='0';

    signal data_in_op   : std_logic_vector(5 downto 0);
    signal data_in_Funct: std_logic_vector(5 downto 0);
    signal MemToRegOut  : std_logic;
    signal MemWriteOut  : std_logic;
    signal BranchOut    : std_logic;
    signal ALUControlOut: std_logic_vector(2 downto 0);
    signal AluSrcOut    : std_logic;
    signal RegDstOut    : std_logic;
    signal RegWriteOut  : std_logic;
    signal JumpOut      : std_logic;
   
begin
    DUT : ControlUnit 
    port map(
        OP         => data_in_op,
        Funct      => data_in_Funct, 
        MemToReg   => MemToRegOut, 
        MemWrite   => MemWriteOut,
        Branch     => BranchOut,
        ALUControl => ALUControlOut,
        AluSrc     => AluSrcOut,
        RegDst     => RegDstOut,
        RegWrite   => RegWriteOut,
        Jump       => JumpOut
    );

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo inputALUop.txt
------------------------------------------------------------------------------------
data_op:process
variable linea : line;
variable inputOP : std_logic_vector(5 downto 0);
begin
while not endfile(inputs_data_op) loop
    if read_data_inOP = '1' then
        readline(inputs_data_op,linea);
        read(linea,inputOP);
        data_in_op <= inputOP;
    end if;
    wait for PERIOD;
end loop;
wait;
end process data_op;

------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada do OP
------------------------------------------------------------------------------------
tb_stimulus_OP : PROCESS
begin
wait for (OFFSET + 0.5*PERIOD);
    read_data_inOP <= '1';		
    for i in min_value to max_value loop --para leitura do n° de valores de entrada
        wait for PERIOD;
    end loop;
    read_data_inOP <= '0';		
wait; --suspend process
end process tb_stimulus_OP;	

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo inputFunct.txt
------------------------------------------------------------------------------------
data_Funct:process
variable linea : line;
variable inputFunct : std_logic_vector(5 downto 0);
begin
while not endfile(inputs_data_Funct) loop
    if read_data_inOP = '1' then
        readline(inputs_data_Funct,linea);
        read(linea,inputFunct);
        data_in_Funct <= inputFunct;
    end if;
    wait for PERIOD;
end loop;
wait;
end process data_Funct;

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
variable RegWriteoutput   : std_logic;
variable RegDstoutput     : std_logic;
variable AluSrcoutput     : std_logic;
variable Branchoutput     : std_logic;
variable MemWriteoutput   : std_logic;
variable MemToRegoutput   : std_logic;
variable Jumpoutput       : std_logic;
variable ALUControloutput : std_logic_vector(2 downto 0);

begin
    while true loop
        if (flag_write ='1')then
            RegWriteoutput  := RegWriteout;
            write(lineSTR, string'("RegWrite"));
            writeline(outputs_data, lineSTR);
            write(linea,RegWriteoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, linea);
			read(linea, comp_out);
            assert comp_out = RegWriteoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (comp_out /= RegWriteoutput) then
                write(lineSTR, string'("Error"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("Good"));
                writeline(outputs_data_comp, lineSTR);
            end if;

            RegDstoutput    := RegDstOut;
            write(lineSTR, string'("RegDst"));
            writeline(outputs_data, lineSTR);
            write(linea,RegDstoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, linea);
			read(linea, comp_out);
            assert comp_out = RegDstoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (comp_out /= RegDstoutput) then
                write(lineSTR, string'("Error"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("Good"));
                writeline(outputs_data_comp, lineSTR);
            end if;

            AluSrcoutput    := AluSrcOut;
            write(lineSTR, string'("AluSrc"));
            writeline(outputs_data, lineSTR);
            write(linea,AluSrcoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, linea);
			read(linea, comp_out);
            assert comp_out = AluSrcoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (comp_out /= AluSrcoutput) then
                write(lineSTR, string'("Error"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("Good"));
                writeline(outputs_data_comp, lineSTR);
            end if;

            Branchoutput    := BranchOut;
            write(lineSTR, string'("BranchOut"));
            writeline(outputs_data, lineSTR);
            write(linea,Branchoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, linea);
			read(linea, comp_out);
            assert comp_out = Branchoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (comp_out /= Branchoutput) then
                write(lineSTR, string'("Error"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("Good"));
                writeline(outputs_data_comp, lineSTR);
            end if;

            MemWriteoutput  := MemWriteOut;
            write(lineSTR, string'("MemWrite"));
            writeline(outputs_data, lineSTR);
            write(linea,MemWriteoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, linea);
			read(linea, comp_out);
            assert comp_out = MemWriteoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (comp_out /= MemWriteoutput) then
                write(lineSTR, string'("Error"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("Good"));
                writeline(outputs_data_comp, lineSTR);
            end if;

            MemToRegoutput  := MemToRegOut;
            write(lineSTR, string'("MemToReg"));
            writeline(outputs_data, lineSTR);
            write(linea,MemToRegoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, linea);
			read(linea, comp_out);
            assert comp_out = MemToRegoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (comp_out /= MemToRegoutput) then
                write(lineSTR, string'("Error"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("Good"));
                writeline(outputs_data_comp, lineSTR);
            end if;

            Jumpoutput       := JumpOut;
            write(lineSTR, string'("JUMP"));
            writeline(outputs_data, lineSTR);
            write(linea,Jumpoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, linea);
			read(linea, comp_out);
            assert comp_out = Jumpoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (comp_out /= Jumpoutput) then
                write(lineSTR, string'("Error"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("Good"));
                writeline(outputs_data_comp, lineSTR);
            end if;

            ALUControloutput       := ALUControlOut;
            write(lineSTR, string'("ALUControl"));
            writeline(outputs_data, lineSTR);
            write(linea,ALUControloutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            readline(data_compare, linea);
			read(linea, comp_outALU);
            assert comp_outALU = ALUControloutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            if (comp_outALU /= ALUControloutput) then
                write(lineSTR, string'("Error"));
                writeline(outputs_data_comp, lineSTR);
            else
                write(lineSTR, string'("Good"));
                writeline(outputs_data_comp, lineSTR);
            end if;
            write(lineSTR, string'("-------------------------"));
            writeline(outputs_data, lineSTR);
        end if;
        wait for PERIOD;
    end loop; 
end process write_outputs;   		


end test;