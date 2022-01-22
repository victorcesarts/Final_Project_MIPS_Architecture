library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity DataMemory is 
	port(
		MemAddress  : in std_logic_vector (31 downto 0);
		Datain		: in std_logic_vector (31 downto 0);
		clk         : in std_logic;
		WE	         : in std_logic;
		ReadDataOut : out std_logic_vector(31 downto 0)
	);
end DataMemory;

architecture DataMemARCH of DataMemory is
begin 	 
    process(clk, MemAddress)
    type ramM is array (63 downto 0) of std_logic_vector(31 downto 0);
    variable ramContent : ramM := (others => (others => '0'));
        begin
	        if (rising_edge(clk)) then
		        if (WE = '1') then
			        ramContent(to_integer(unsigned(MemAddress(7 downto 2)))) := Datain;
			    end if;
		    end if;
		ReadDataOut <= ramContent(to_integer(unsigned(MemAddress(7 downto 2))));
	end process;
end DataMemARCH;