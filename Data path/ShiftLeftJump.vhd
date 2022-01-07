library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ShiftLeftJump is
    port(
        InSll  : in std_logic_vector(25 downto 0);
        OutSll : out std_logic_vector(25 downto 0)
    );
end ShiftLeftJump;

architecture ShiftArch of ShiftLeftJump is
    begin
        OutSll <= std_logic_vector(shift_left(unsigned(InSll), 2));
end ShiftArch; 