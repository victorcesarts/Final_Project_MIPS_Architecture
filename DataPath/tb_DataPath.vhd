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
        Instr        : in std_logic_vector(31 downto 0);
        Reset        : in std_logic;
        clk          : in std_logic;
        ReadData     : in std_logic_vector(31 downto 0);
        RegWrite     : in std_logic;
        RegDst       : in std_logic_vector(1 downto 0);
        ALUSrc       : in std_logic;
        MemtoReg     : in std_logic;
        PCSrc        : in std_logic;
        ALUControl_U : in std_logic_vector(2 downto 0);
        ZEROFlag_U   : out std_logic;
        PCout        : out std_logic_vector(31 downto 0);
        ALUOut       : out std_logic_vector(31 downto 0);
        WriteData    : out std_logic_vector(31 downto 0)
    );
end component;

    -- Clock period definitions
    constant PERIOD     : time := 15 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET     : time := 5 ns;

    file	inputs_data_DataPath   : text open read_mode  is "inputDataPath.txt";
  -- file	data_compare      : text open read_mode  is "inputcompare.txt";
	file	outputs_data	  : text open write_mode is "output.txt";
    file	outputs_data_comp : text open write_mode is "outputdata_comp.txt";

    constant min_value  : natural := 1;
    constant max_value  : natural := 13;

    signal read_data_inPC : std_logic:='0';
    signal flag_write	  : std_logic:='0';

    --signal data_in_addres  : std_logic_vector(31 downto 0);
    signal data_in_reset      : std_logic;
    signal data_in_instr      : std_logic_vector(31 downto 0);
    signal data_in_data       : std_logic_vector(31 downto 0);
    signal data_in_RegWrite   : std_logic := '0';
    signal data_in_ALUSrc     : std_logic;
    signal data_in_MemtoReg   : std_logic;
    signal data_in_PCSrc      : std_logic;
    signal data_in_RegDst     : std_logic_vector(1 downto 0);
    signal data_in_ALUControl : std_logic_vector(2 downto 0);
    signal in_clk             : std_logic := '0';
    signal ZeroOutput         : std_logic;
    signal ALUOutin           : std_logic_vector(31 downto 0);
    signal Writetoutput       : std_logic_vector(31 downto 0);
    signal PCtoutput          : std_logic_vector(31 downto 0);
    
   
begin
    DUT : DataPath 
    port map(
        Instr        => data_in_instr,
        Reset        => data_in_reset,
        RegWrite     => data_in_RegWrite,
        ALUSrc       => data_in_ALUSrc,
        RegDst       => data_in_RegDst,
        ReadData     => data_in_data,
        MemtoReg     => data_in_MemtoReg,
        PCSrc        => data_in_PCSrc,
        clk          => in_clk,
        ALUControl_U => data_in_ALUControl,
        ZEROFlag_U   => ZeroOutput,
        PCout        => PCtoutput,
        ALUOut       => ALUOutin,
        WriteData    => Writetoutput
    );

    in_clk <= not in_clk after PERIOD/2;
    

------------------------------------------------------------------------------------
----------------- processo para ler os dados do arquivo input.txt
------------------------------------------------------------------------------------
data_U : process
variable linea         : line;
variable inputAddress  : std_logic_vector(31 downto 0);
variable inputData     : std_logic_vector(31 downto 0);
variable inputReg      : std_logic;
variable inputReset    : std_logic;
variable inputALUSrc   : std_logic;
variable inputPCSrc    : std_logic;
variable inputMemToReg : std_logic;
variable inputRegDst   : std_logic_vector(1 downto 0);
variable inputALUC     : std_logic_vector(2 downto 0);
variable inputInstr    : std_logic_vector(31 downto 0);
begin
while not endfile(inputs_data_DataPath) loop
    if read_data_inPC = '1' then

        readline(inputs_data_DataPath,linea);
        read(linea, inputInstr);
        data_in_instr <= inputInstr;

        readline(inputs_data_DataPath,linea);
        read(linea,inputReset);
        data_in_reset <= inputReset;

        readline(inputs_data_DataPath,linea);
        hread(linea,inputData);
        data_in_data <= inputData;

        readline(inputs_data_DataPath,linea);
        read(linea,inputReg);
        data_in_RegWrite <= inputReg;

        readline(inputs_data_DataPath,linea);
        read(linea,inputALUC);
        data_in_ALUControl <= inputALUC;

        readline(inputs_data_DataPath,linea);
        read(linea,inputALUSrc);
        data_in_ALUSrc <= inputALUSrc;

        readline(inputs_data_DataPath,linea);
        read(linea,inputPCSrc);
        data_in_PCSrc <= inputPCSrc;

        readline(inputs_data_DataPath,linea);
        read(linea,inputRegDst);
        data_in_RegDst <= inputRegDst;

        readline(inputs_data_DataPath,linea);
        read(linea,inputMemToReg);
        data_in_MemtoReg <= inputMemToReg;
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
variable linea      : line;
variable lineb      : line;
variable lineSTR    : line;
variable comp_outPC : std_logic_vector(31 downto 0);
variable ALUvOut    : std_logic_vector(31 downto 0);
variable PCoutDoc   : std_logic_vector(31 downto 0);
variable Writeout   : std_logic_vector(31 downto 0);
variable ZeroOut    : std_logic;

begin
    while true loop
        if (flag_write ='1')then

            ALUvOut  := ALUOutin;
           --write(lineSTR, string'("The output is"));
            --writeline(outputs_data, lineSTR);
            write(linea,ALUvOut);
            writeline(outputs_data, linea);

            PCoutDoc := PCtoutput;
            --write(lineSTR, string'("The output is"));
             --writeline(outputs_data, lineSTR);
             write(linea,PCoutDoc);
             writeline(outputs_data, linea);
            

            --To read in order to compare--
            --readline(data_compare, lineb);
			--read(lineb, comp_outPC);
            --assert comp_outPC = PCotpt  report "ERROR" severity warning;

            --Writing if the output it's good or not--
           -- if (comp_outPC = PCotpt) then
               -- write(lineSTR, string'("The output is"));
               -- writeline(outputs_data_comp, lineSTR);
            --    write(lineSTR, string'("GOOD"));
            --    writeline(outputs_data_comp, lineSTR);
          -- else
                --write(lineSTR, string'("You've got an"));
                --writeline(outputs_data_comp, lineSTR);
            --    write(lineSTR, string'("ERROR"));
            --    writeline(outputs_data_comp, lineSTR);
            
            ZeroOut  := ZeroOutput;
            --write(lineSTR, string'("The output is"));
             --writeline(outputs_data, lineSTR);
             write(linea,ZeroOut);
             writeline(outputs_data, linea);

             Writeout := Writetoutput;
            --write(lineSTR, string'("The output is"));
             --writeline(outputs_data, lineSTR);
             write(linea,Writeout);
             writeline(outputs_data, linea);
            

           -- end if;
           -- write(lineSTR, string'("-------------------------"));
           -- writeline(outputs_data_comp, lineSTR);

        end if;
        wait for PERIOD;
    end loop; 
end process write_outputs;   		
end test;