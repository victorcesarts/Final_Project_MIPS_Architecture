library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ShiftLeft is
    port(
        InSll  : in std_logic_vector(31 downto 0);
        OutSll : out std_logic_vector(31 downto 0)
    );
end ShiftLeft;

architecture ShiftArch of ShiftLeft is
    begin
        OutSll <= std_logic_vector(shift_left(unsigned(InSll), 2));
end ShiftArch; 