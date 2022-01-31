library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	

entity MUX is
    port (
        Control 	: in    std_logic;
        InA    	    : in    std_logic_vector(31 downto 0);
        InB    	    : in    std_logic_vector(31 downto 0);
        OutputS  	: out   std_logic_vector(31 downto 0)
    );
end MUX;

architecture MUXArch of MUX is
    begin
        with Control select
        OutputS <=  InA when '0',
                    InB when '1',
                    x"XXXXXXXX" when others;
end MUXArch;