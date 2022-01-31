library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity InstrMemory is 
    generic (N : integer);
    port(
        address : in std_logic_vector(31 downto 0);
        instr   : out std_logic_vector(31 downto 0)
    );
end InstrMemory;
--addi $s6, $0, 100
--sw $s6, 40($0)	#Will fail because the memory address is not allowed sw $s6, 0x10010000($0)
--lw $t2, 40($0)	#lw $s2 0x10010000($0)
--add $s3, $s6, $t2
--sub $s4, $s3, $t2
--and $s5, $s3, $s6
--or $s7, $s5, $s4
--lw $t2, 40($0)	#lw $s2 0x10010000($0)
--add $s1, $s3, $s5
--sw $s1, 40($0)	#lw $s2 0x10010000($0)
--lw $t0, 40($0)
--syscall

architecture InstrARCH of InstrMemory is 
signal rom_addr : std_logic_vector(3 downto 0);
type rom is array (0 to N - 1) of std_logic_vector(31 downto 0);

constant Instr_data : 
rom :=rom'(
    "00100000000101100000000001100100",
    "10101100000101100000000000101000",
    "10001100000010100000000000101000",
    "00000010110010101001100000100000",
    "00000010011010101010000000100010",
    "00000010011101101010100000100100",
    "00000010101101001011100000100101",
    "00000010011101011000100000100000",
    "10101100000100010000000000101000",
    "10001100000010000000000000101000",
    "00000000000000000000000000001100"
    );
begin
    rom_addr <= address(5 downto 2);
    instr <= Instr_data(to_integer(unsigned(rom_addr))) when 
            ((address >= x"00400000") and (address < x"10010000")) else x"0000000C";    --syscall. The range can be change if there are more instr.                                                                                                                               
end InstrARCH; 