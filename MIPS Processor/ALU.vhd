--    This is the descripton of an ALU			--
--    for a MIPS Single Cycle Processor.        --
--    THE MEMORY IS IN LITTLE ENDIAN            --
--    Author: Víctor César Teixeira Santos      --
--    Federal University of Minas Gerais        --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	

entity ALU is
    port (
        ALUControl 	: in    std_logic_vector(2 downto 0);
        SrcA    	: in    std_logic_vector(31 downto 0);
        SrcB    	: in    std_logic_vector(31 downto 0);
        ZEROFlag  	: out   std_logic;
        ALUResult	: out   std_logic_vector(31 downto 0)
    );
end ALU;

architecture ALUCarch of ALU is
		signal temp_result : std_logic_vector(31 downto 0);
	begin
		process (all) is 
		begin
		case ALUControl is
			when "000" =>
				temp_result <= SrcA and SrcB; --and
			when "001" =>
				temp_result <= SrcA or SrcB; --or
			when "010" =>
				temp_result <= std_logic_vector(signed(SrcA) + signed(SrcB)); --add
			when "110" =>
				temp_result <= std_logic_vector(signed(SrcA) - signed(SrcB)); --sub
			when "111" =>
				if(SrcA < SrcB) then
					temp_result <= x"00000001";
				else
					temp_result <= x"00000000";
				end if;
			when others =>
				temp_result <= (others => 'X');
	end case;
	ALUResult <=  temp_result;
	if (temp_result = x"00000000") then
		ZEROflag <= '1';
	else
		ZEROflag <= '0';
	end if;	
	end process;	
end ALUCarch;