library IEEE;
use ieee.std_logic_1164.all;

entity SignExt is
    port(
        value : in std_logic_vector(15 downto 0);
        valueEXT : out std_logic_vector(31 downto 0)
    );
end SignExt;

architecture SignARCH of SignExt is
    begin
        valueEXT <= x"ffff" & value when value(15) = '1' else
                    x"0000" & value;
end SignARCH;