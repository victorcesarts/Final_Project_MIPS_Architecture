library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity DataPath is 
    port(
        clk   : in std_logic;
        reset : in std_logic;
        memwrite : in std_logic;
        readdata : in std_logic_vector(31 downto 0);
        writedata : out std_logic_vector(31 downto 0);
        address : out std_logic_vector(31 downto 0)  
    );
    end DataPath;

    architecture Arch of DataPath is
        component Adder
            port(
                InA   : in std_logic_vector(31 downto 0);
                InB   : in std_logic_vector(31 downto 0);
                Result : out std_logic_vector(31 downto 0)
            );
        end component;

        component ALU 
            port (
                ALUControl 	: in    std_logic_vector(2 downto 0);
                SrcA    	: in    std_logic_vector(31 downto 0);
                SrcB    	: in    std_logic_vector(31 downto 0);
                ZEROFlag  	: out   std_logic;
                ALUResult	: out   std_logic_vector(31 downto 0)
            );
        end component;
        
        component MUX 
            port (
                Control 	: in    std_logic;
                InA    	    : in    std_logic_vector(31 downto 0);
                InB    	    : in    std_logic_vector(31 downto 0);
                OutputS  	: out   std_logic_vector(31 downto 0)
            );
        end component;

        component PC 
            port(
                pcin         : in std_logic_vector(31 downto 0);
			    clk, reset   : in std_logic;
			    overflowFlag : out std_logic;
			    pcout        : out std_logic_vector(31 downto 0)
	        );
        end component;

        component RegisterFile
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

        component ShiftLeft 
            port(
                InSll  : in std_logic_vector(31 downto 0);
                OutSll : out std_logic_vector(31 downto 0)
            );
        end component;

        component SignExt
            port(
                value : in std_logic_vector(15 downto 0);
                valueEXT : out std_logic_vector(31 downto 0)
            );
        end component;
            -- Internal signals ALU --
            signal internal_ALUControl : std_logic_vector(2 downto 0); -- will be changed
            signal internal_srcA : std_logic_vector(31 downto 0);
            signal internal_srcB : std_logic_vector(31 downto 0);
            signal internal_Zero : std_logic;
            signal internal_ALUResult : std_logic_vector(31 downto 0);

            -- Internal signals MUX --
            signal internal_Control : std_logic;
            signal internal_InA : std_logic_vector(31 downto 0);
            signal internal_InB : std_logic_vector(31 downto 0);
            signal internal_OutputS : std_logic_vector(31 downto 0);

            -- Internal signals Register file --
            signal internal_A1 : std_logic_vector(4 downto 0);
            signal internal_A2 : std_logic_vector(4 downto 0);
            signal internal_A3 : std_logic_vector(4 downto 0);
            signal internal_WD3 : std_logic_vector(31 downto 0);
            signal internal_WE3 : std_logic;
            signal internal_RD1 : std_logic_vector(31 downto 0);
            signal internal_RD2 : std_logic_vector(31 downto 0)
    

        begin
            ALU_inst : ALU port map(
                ALUControl => internal_ALUControl, -- will be changed
                SrcA => internal_RD1,
                SrcB => internal_OutputS,
                ZEROFlag => internal_Zero,
                ALUResult => internal_ALUResult
            );
            MUX_ALU_inst : MUX port map(
                Control => internal_Control,
                InA => internal_RD2,
                InB => internal_InB,
                OutputS => internal_OutputS
            );

            Register_inst : RegisterFile port map(
                A1 => internal_A1,
                A2 => internal_A2,
                A3 => internal_A3,
                WD3 => internal_WD3,
                WE3 => internal_WE3,
                clk => clk,
                RD1 => internal_RD1,
                RD2 => internal_RD2
            )
    end Arch;

