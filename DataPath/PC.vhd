library IEEE;
use ieee.std_logic_1164.all;

entity PC is 
    port(
		pcin         : in std_logic_vector(31 downto 0);
		clk, reset   : in std_logic;
		pcout        : out std_logic_vector(31 downto 0)
	);
end PC;

    architecture PCArch of PC is
	signal temp : std_logic_vector(31 downto 0);
	begin   
        process (clk, pcin)
        begin
            if (reset = '1') then 
                temp <= x"BFC00000";                           
			else
                if (temp = x"BFC00000") then
                    temp <= x"00400000"; 
                elsif (pcin > x"00400028" and (temp /= x"BFC00000")) then -- this condition needs to be changed if you have a bigger program
                    temp <= x"90000000"; 
                else
                    temp <= x"00000000";
                end if;
		    end if;

            if (rising_edge(clk)) then
                if (reset = '1') then 
                    pcout <= temp;       
			    else 
                    if (temp = x"00400000" or temp = x"90000000") then
			            pcout <= temp;
                    else
                        pcout <= pcin;
                    end if;
                end if;               
            end if;
		end process;
    end PCArch;