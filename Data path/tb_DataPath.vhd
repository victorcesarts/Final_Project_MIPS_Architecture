library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_DataPath is
end tb_DataPath;

architecture test of tb_DataPath is

component DataPath is 
    port(    
        clk        : in std_logic;
        reset      : in std_logic;
        MemToReg   : in std_logic;
        RegWrite   : in std_logic;
        ALUSrc     : in std_logic;
        ALUControl : in std_logic_vector(2 downto 0);
        RegDST     : in std_logic_vector(1 downto 0);
        Jump       : in std_logic;
        Instr      : in std_logic_vector(31 downto 0);
        Pcsrc      : in std_logic;
        ReadData   : in std_logic_vector(31 downto 0);
        WriteData  : out std_logic_vector(31 downto 0);
        PC_OUT     : out std_logic_vector(31 downto 0)
    );
end component;

    -- Clock period definitions
    constant PERIOD     : time := 15 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	inputs_data	    : text open read_mode  is "input.txt";
    --file	data_compare        : text open read_mode  is "inputcompare.txt";
	file	outputs_data	    : text open write_mode is "output.txt";
    file	outputs_data_comp   : text open write_mode is "outputdata_comp.txt";

    constant min_value	: natural := 1;
    constant max_value  : natural := 31;

    signal read_data_in	 : std_logic:='0';
    signal flag_write	 : std_logic:='0';

    signal data_clk      : std_logic := '0';
    signal in_reset      : std_logic := '0';
    signal MemToRegIn   : std_logic;
    signal RegWriteIn   : std_logic;
    signal AluSrcIn     : std_logic;
    signal ALUControlIn : std_logic_vector(2 downto 0);
    signal RegDstIn     : std_logic_vector(1 downto 0);
    signal JumpIn       : std_logic;
    signal InstrIn      : std_logic_vector(31 downto 0) := "00100010000100000000000000001100";
    signal PCsrcIn      : std_logic;
    signal ReadDataIn   : std_logic_vector(31 downto 0);
    signal WriteDataOut  : std_logic_vector(31 downto 0);
    signal PCOUT         : std_logic_vector(31 downto 0);
begin
    DUT : DataPath 
    port map(
        clk        => data_clk,
        reset      => in_reset,
        MemToReg   => MemToRegIn,
        RegWrite   => RegWriteIn,
        ALUSrc     => AluSrcIn,
        ALUControl => ALUControlIn,
        RegDST     => RegDstIn,
        Jump       => JumpIn,      
        Instr      => InstrIn,
        Pcsrc      => PCsrcIn,
        ReadData   => ReadDataIn,
        WriteData  => WriteDataOut,
        PC_OUT     => PCOUT
    );

data_CLK <= not data_CLK after PERIOD/2;
    reset : process
    begin
        wait for 600 ns;
        in_reset <= '1';
        wait for 50 ns;
        in_reset <= '0';
        wait;
     end process;
------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo inputALUop.txt
------------------------------------------------------------------------------------
data:process
variable linea : line;
variable ALUcontroldata : std_logic_vector(2 downto 0);
variable MemToRegData : std_logic;
variable RegWriteData : std_logic;
variable ALUSrcData : std_logic;
variable RegDstData : std_logic_vector(1 downto 0);
variable JumpData : std_logic;
variable InstrData : std_logic_vector(31 downto 0);
variable PCsrcData : std_logic;
variable ReadDatadata : std_logic_vector(31 downto 0);


begin
while not endfile(inputs_data) loop
    if read_data_in = '1' then
        readline(inputs_data,linea);
        hread(linea,ReadDatadata);
        ReadDataIn <= ReadDatadata;

        readline(inputs_data,linea);
        read(linea,InstrData);
        InstrIn <= InstrData;

        readline(inputs_data,linea);
        read(linea,RegWriteData);
        RegWriteIn <= RegWriteData;
        
        readline(inputs_data,linea);
        read(linea,RegDstData);
        RegDstIn <= RegDstData;

        readline(inputs_data,linea);
        read(linea,ALUSrcData);
        AluSrcIn <= ALUSrcData;

        readline(inputs_data,linea);
        read(linea,MemToRegData);
        MemToRegIn <= MemToRegData;

        readline(inputs_data,linea);
        read(linea,ALUcontroldata);
        ALUControlIn <= ALUcontroldata;

        readline(inputs_data,linea);
        read(linea,JumpData);
        JumpIn <= JumpData;

        readline(inputs_data,linea);
        read(linea,PCsrcData);
        PCsrcIn <= PCsrcData;        
    end if;
    wait for PERIOD;
end loop;
wait;
end process data;

------------------------------------------------------------------------------------
----------------- processo para gerar os estimulos de entrada 
------------------------------------------------------------------------------------
tb_stimulus : PROCESS
begin
wait for (OFFSET + 0.5*PERIOD);
    read_data_in <= '1';		
    for i in min_value to max_value loop --para leitura do n° de valores de entrada
        wait for PERIOD;
    end loop;
    read_data_in <= '0';		
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
variable WriteDataoutput  : std_logic_vector(31 downto 0);
variable PCoutput         : std_logic_vector(31 downto 0);

begin
    while true loop
        if (flag_write ='1')then
            WriteDataoutput  := WriteDataOut;
            write(lineSTR, string'("RegWrite"));
            writeline(outputs_data, lineSTR);
            write(linea,WriteDataoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            --readline(data_compare, linea);
			--read(linea, comp_out);
            --assert comp_out = WriteDataoutput  report "ERROR" severity warning;
            --Writing if the output it's good or not--
            --if (comp_out /= WriteDataoutput) then
            --    write(lineSTR, string'("Error"));
            --    writeline(outputs_data_comp, lineSTR);
            --else
            --    write(lineSTR, string'("Good"));
            --    writeline(outputs_data_comp, lineSTR);
            --end if;

            PCoutput    := PCOUT;
            write(lineSTR, string'("RegDst"));
            writeline(outputs_data, lineSTR);
            write(linea,PCoutput);
            writeline(outputs_data, linea);
            --To read in order to compare--
            --readline(data_compare, linea);
			--read(linea, comp_out);
            --assert comp_out = PCoutput  report "ERROR" severity warning;
            ----Writing if the output it's good or not--
            --if (comp_out /= PCoutput) then
            --    write(lineSTR, string'("Error"));
            --    writeline(outputs_data_comp, lineSTR);
            --else
            --    write(lineSTR, string'("Good"));
            --    writeline(outputs_data_comp, lineSTR);
            --end if;

            write(lineSTR, string'("-------------------------"));
            writeline(outputs_data, lineSTR);
        end if;
        wait for PERIOD;
    end loop; 
end process write_outputs;   		


end test;