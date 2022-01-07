library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	

entity Adder is
    port(
        InA   : in std_logic_vector(31 downto 0);
        InB   : in std_logic_vector(31 downto 0);
        Result : out std_logic_vector(31 downto 0)
    );
end Adder;

architecture AdderARCH of Adder is
    begin
        Result <= std_logic_vector(unsigned(InA) + unsigned(Inb));
end AdderARCH;