library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity RegisterFile is
    port(
        A1 : in std_logic_vector(4 downto 0);
        A2 : in std_logic_vector(4 downto 0);
        A3 : in std_logic_vector(4 downto 0);
        WD3 : in std_logic_vector(31 downto 0);
        WE3 : in std_logic;
        clk : in std_logic;
        RD1 : out std_logic_vector(31 downto 0);
        RD2 : out std_logic_vector(31 downto 0)
    );
end RegisterFile;

architecture REGFileARCH of RegisterFile is
        type regtype is array (31 downto 0) of std_logic_vector(31 downto 0);
        signal reg : regtype;
    begin
        process(clk) begin
            if (rising_edge(clk)) then
                if (WE3 = '1') then
                    reg(to_integer(unsigned(A3))) <= WD3;
                end if;
            end if;
        end process;
		  
	    process (A1,A2) begin
            if((to_integer(unsigned(A1))) = 0) then
			    RD1 <= x"00000000";
            else
                RD1 <= reg(to_integer(unsigned(A1)));
		    end if;
            if((to_integer(unsigned(A2))) = 0) then
			    RD2 <= x"00000000";
            else
                RD2 <= reg(to_integer(unsigned(A2)));
		    end if;
	    end process;
end REGFileARCH; 

        

