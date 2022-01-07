library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_SignExt is
end entity;

architecture test of tb_signExt is

    component SignExt is
        port(
            value : in std_logic_vector(15 downto 0);
            valueEXT : out std_logic_vector(31 downto 0)
        );
    end component;

     -- Clock period definitions
     constant PERIOD     : time := 15 ns;
     constant DUTY_CYCLE : real := 0.5;
     constant OFFSET     : time := 5 ns;
 
     file	inputs_data_Sign : text open read_mode  is "inputSign.txt";
     file	data_compare      : text open read_mode  is "inputcompare.txt";
     file	outputs_data	  : text open write_mode is "output.txt";
     file	outputs_data_comp : text open write_mode is "outputdata_comp.txt";
 
     constant min_value  : natural := 1;
     constant max_value  : natural := 65536;
 
     signal read_data_inSign : std_logic:='0';
     signal flag_write	     : std_logic:='0';
 
     signal data_in_Value : std_logic_vector(15 downto 0);
     signal Signout       : std_logic_vector(31 downto 0);
    
 begin
     DUT : SignExt 
     port map(
        value    => data_in_Value, 
        valueEXT => Signout
     );
 
 ------------------------------------------------------------------------------------
 ----------------- processo para ler os dados do arquivo inputSign.txt
 ------------------------------------------------------------------------------------
 data_Sign : process
 variable linea     : line;
 variable inputValue : std_logic_vector(15 downto 0);

 begin
 while not endfile(inputs_data_Sign) loop
     if read_data_inSign = '1' then
         readline(inputs_data_Sign,linea);
         read(linea,inputValue);
         data_in_Value <= inputValue;
     end if;
     wait for PERIOD;
 end loop;
 wait;
 end process data_Sign;
 
 ------------------------------------------------------------------------------------
 ----------------- processo para gerar os estimulos de entrada do inputSign
 ------------------------------------------------------------------------------------
 tb_stimulus_Sign : PROCESS
 begin
 wait for (OFFSET + 0.5*PERIOD);
    read_data_inSign <= '1';		
     for i in min_value to max_value loop --para leitura do n° de valores de entrada
         wait for PERIOD;
     end loop;
     read_data_inSign <= '0';		
 wait; --suspend process
 end process tb_stimulus_Sign;	
 
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
 -- ------ processo para escrever os dados de saida no output.txt e outputdata_comp.txt
 -- ------------------------------------------------------------------------------------   
 write_outputs : process
 variable linea          : line;
 variable lineb          : line;
 variable lineSTR        : line;
 variable comp_outSign   : std_logic_vector(31 downto 0);
 variable Signtoutput    : std_logic_vector(31 downto 0);
 
 begin
     while true loop
         if (flag_write ='1')then
 
            Signtoutput  := Signout;
             write(lineSTR, string'("Signed Extended value is:"));
             writeline(outputs_data, lineSTR);
             write(linea,Signtoutput);
             writeline(outputs_data, linea);
 
             --To read in order to compare--
             readline(data_compare, lineb);
             read(lineb, comp_outSign);
             assert comp_outSign = Signtoutput  report "ERROR" severity warning;
 
             --Writing if the output it's good or not--
             if (comp_outSign = Signtoutput) then
                 write(lineSTR, string'("Sign Extended value is"));
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