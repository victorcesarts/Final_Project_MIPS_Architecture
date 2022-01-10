--    This is the descripton of an Unit Control --
--    for a MIPS Single Cycle Processor.        --
--    THE MEMORY IS IN LITTLE ENDIAN            --
--    Author: Víctor César Teixeira Santos      --
--    Federal University of Minas Gerais        --


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity maindecoder is 
    port(   
            OPM        : in std_logic_vector(5 downto 0);
            MemToRegM  : out std_logic;
            MemWriteM  : out std_logic;
            BranchM    : out std_logic;
            AluSrcM    : out std_logic;
            RegDstM    : out std_logic_vector(1 downto 0);
            RegWriteM  : out std_logic;
            jumpM      : out std_logic;
            ALUopM     : out std_logic_vector(1 downto 0)
    );
end maindecoder;

architecture MainDECARCH of maindecoder is
    begin
    process(all)
    begin
        case to_integer(unsigned(OPM)) is
        when 0 => --R-Type
            RegWriteM <= '1';
            RegDstM <= "01";
            AluSrcM <= '0';
            BranchM <= '0'; 
            MemWriteM <= '0'; 
            MemToRegM <= '0';    
            ALUopM <= "10"; --look at funct   
            jumpM <= '0';

        when 3 => --Jump and link
            RegWriteM <= '1';
            RegDstM <= "10"; --31
            AluSrcM <= '0';
            BranchM <= '0'; 
            MemWriteM <= '0'; 
            MemToRegM <= '0';    
            ALUopM <= "10"; --look at funct   
            jumpM <= '0';

            when 32 to 37 => --all load instructions
                RegWriteM <= '1';
                RegDstM <= "00";
                AluSrcM <= '1';
                BranchM <= '0'; 
                MemWriteM <= '0'; 
                MemToRegM <= '1';    
                ALUopM <= "00"; --ADD 
                jumpM <= '0';

            when 40 to 43 => --all store instructions
                RegWriteM <= '0';
                RegDstM <= "XX";
                AluSrcM <= '1';
                BranchM <= '0'; 
                MemWriteM <= '1'; 
                MemToRegM <= 'X';    
                ALUopM <= "00"; --ADD 
                jumpM <= '0';
            
            when 8 | 9 => --addi or addiu
                RegWriteM <= '1';
                RegDstM <= "00";
                AluSrcM <= '1';
                BranchM <= '0'; 
                MemWriteM <= '0'; 
                MemToRegM <= '0';    
                ALUopM <= "00"; --ADD 
                jumpM <= '0';

            when 2 => --JUMP
                RegWriteM <= '0';
                RegDstM <= "XX";
                AluSrcM <= 'X';
                BranchM <= 'X'; 
                MemWriteM <= '0'; 
                MemToRegM <= 'X';    
                ALUopM <= "XX";  
                jumpM <= '1';

            when others => 
                MemToRegM <= 'X';
                MemWriteM <= 'X';
                BranchM <= 'X';
                AluSrcM <= 'X';
                RegDstM <= "XX";
                RegWriteM <= 'X';
                jumpM <= 'X';
                ALUopM <= "XX";
        end case;
    end process;
end MainDECARCH;