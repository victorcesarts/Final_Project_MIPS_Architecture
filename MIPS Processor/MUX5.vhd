--    This is the descripton of a MUX			--
--    for a MIPS Single Cycle Processor.        --
--    THE MEMORY IS IN LITTLE ENDIAN            --
--    Author: Víctor César Teixeira Santos      --
--    Federal University of Minas Gerais        --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	

entity MUX5 is
    port (
        Control_5 	: in    std_logic;
        InA_5   	: in    std_logic_vector(4 downto 0);
        InB_5   	: in    std_logic_vector(4 downto 0);
        OutputS_5 	: out   std_logic_vector(4 downto 0)
    );
end MUX5;

architecture MUXArch of MUX5 is
    begin
        with Control_5 select
        OutputS_5 <=  InA_5 when '0',
                      InB_5 when '1',
                    "XXXXX" when others;
end MUXArch;