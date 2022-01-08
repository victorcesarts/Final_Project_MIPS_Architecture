library IEEE;
use ieee.std_logic_1164.all;

entity PC is 
    port(
			pcin         : in std_logic_vector(31 downto 0);
			clk, reset   : in std_logic;
			overflowFlag : out std_logic;
			pcout        : out std_logic_vector(31 downto 0)
	);
end PC;

        architecture PCArch of PC is
	 begin   
        process (clk, reset)
        begin
            if ((pcin >= x"00400000") and (pcin <= x"0FFFFFFD")) then
                overflowFlag <= '0';
                if (reset = '1' and rising_edge(clk)) then 
                    pcout <= x"00400000";           
                elsif(rising_edge(clk)) then
                    pcout <= pcin;
                end if;
            else 
                overflowFlag <= '1';
                pcout <= x"80000180";
            end if;
			end process;
    end PCArch;