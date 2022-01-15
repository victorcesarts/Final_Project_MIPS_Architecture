library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity InstrMemory is 
    port(
        address : in std_logic_vector(31 downto 0);
        instr : out std_logic_vector(31 downto 0)
    );
end InstrMemory;
--addi $s6, $0, 100
--sw $s6, 40($0)	#Will fail because the memory address is not allowed sw $s6, 0x10010000($0)
--lw $t2, 40($0)	#lw $s2 0x10010000($0)
--dd $s3, $s6, $t2
--sub $s4, $s3, $t2
--and $s5, $s3, $s6
--or $s7, $s5, $s4


architecture InstrARCH of InstrMemory is 
signal rom_addr : std_logic_vector(7 downto 0);
type rom is array (0 to 12) of std_logic_vector(31 downto 0);

constant Instr_data : 
rom :=rom'(
    "00100000000010100000000000000000",
    "00100000000100110000000000000000",
    "00100000000101000000000000000000",
    "00100000000101010000000000000000",
    "00100000000101110000000000000000",
    "00100000000101100000000000000000",
    "00100000000101100000000001100100",
    "10101100000101100000000000101000",
    "10001100000010100000000000101000",
    "00000010110010101001100000100000",
    "00000010011010101010000000100010",
    "00000010011101101010100000100100",
    "00000010101101001011100000100101");
begin
    rom_addr <= address(9 downto 2);
    instr <= Instr_data(to_integer(unsigned(rom_addr))) when ((address >= x"00400000") and (address <= x"0FFFFFFD")) else x"00000000";      
end InstrARCH; 