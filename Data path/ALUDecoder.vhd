--    This is the descripton of an Unit Control --
--    for a MIPS Single Cycle Processor.        --
--    THE MEMORY IS IN LITTLE ENDIAN            --
--    Author: Víctor César Teixeira Santos      --
--    Federal University of Minas Gerais        --


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALUDecoder is 
    port(   FunctD      : in std_logic_vector(5 downto 0);
            ALUopD      : in std_logic_vector(1 downto 0);
            ALUControlD : out std_logic_vector(2 downto 0)
    );
end ALUDecoder;

architecture ALUDecARCH of ALUDecoder is
begin
    process (all)
    begin
        case ALUopD is
            when "00" =>
            ALUControlD <= "010"; --add
            when "01" =>
            ALUControlD <= "110"; --subtract

            -- Operations for R-Type instructions--
            when "10" => --look at funct
                case FunctD is
                    when "100000" =>
                    ALUControlD <= "010"; --add 
                    when "100010" =>
                    ALUControlD <= "110"; --sub
                    when "100100" =>
                    ALUControlD <= "000"; --and
                    when "100101" =>
                    ALUControlD <= "001"; --or
                    when "101010" =>
                    ALUControlD <= "111"; --slt
                    when others =>
                    ALUControlD <= "XXX";
                end case;
            when others =>
            ALUControlD <= "XXX";
        end case;
    end process;
end ALUDecARCH;
            