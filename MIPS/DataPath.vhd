library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataPath is 
    port(
        clk   : in std_logic;
        reset : in std_logic;
       -- MemWrite : in std_logic;
        MemToReg : in std_logic;
        RegWrite : in std_logic;
        ALUSrc : in std_logic;
        ALUControl : in std_logic_vector(2 downto 0);
        RegDST : in std_logic;
        Jump : in std_logic;
        Instr : in std_logic_vector(31 downto 0);
        Pcsrc : in std_logic;
        ReadData : in std_logic_vector(31 downto 0);
        WriteData : out std_logic_vector(31 downto 0);
        PC_OUT : out std_logic_vector(31 downto 0);
        Excpetion : out std_logic;
        Zero : out std_logic;
        ALUOut : out std_logic_vector(31 downto 0)
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
		  end component;

        component ShiftLeft 
            port(
                InSll  : in std_logic_vector(31 downto 0);
                OutSll : out std_logic_vector(31 downto 0)
            );
        end component;

        component ShiftLeftJump is
            port(
                InSll  : in std_logic_vector(25 downto 0);
                OutSll : out std_logic_vector(25 downto 0)
            );
        end component;

        component SignExt
            port(
                value : in std_logic_vector(15 downto 0);
                valueEXT : out std_logic_vector(31 downto 0)
            );
        end component;

        component MUX5
            port (
                Control_5 	: in    std_logic;
                InA_5   	: in    std_logic_vector(4 downto 0);
                InB_5   	: in    std_logic_vector(4 downto 0);
                OutputS_5 	: out   std_logic_vector(4 downto 0)
            );
        end component;

            -- Internal signals ALU --
            signal internal_ALUResult : std_logic_vector(31 downto 0);

            -- Internal signals MUX ALU --
            signal internal_OutputSrc : std_logic_vector(31 downto 0);

            -- Internal signals MUX Data Memory --
            signal Result_dataMEM : std_logic_vector(31 downto 0);

            -- Internal signals MUX Register File --
            signal WriteReg : std_logic_vector(4 downto 0);    

            -- Internal signals Register file --
            signal internal_RD1 : std_logic_vector(31 downto 0);
            signal internal_RD2 : std_logic_vector(31 downto 0);
            
            -- Internal signals Sign Extend --
            signal internal_valueEXT : std_logic_vector(31 downto 0);

            -- Internal signals PC --
            signal PC_next : std_logic_vector(31 downto 0);
            signal PC_plus4 : std_logic_vector(31 downto 0);
            signal PC_Branch : std_logic_vector(31 downto 0);

            -- Internal signals MUX PC --
            signal Result_PC : std_logic_vector(31 downto 0);

            -- Internal signals Shift Left PC --
            signal OutSll_PC : std_logic_vector(31 downto 0);

            -- Internal signals Shift Left PC JUMP --
            signal OutSll_PCJUMP : std_logic_vector(25 downto 0);
				

        begin
            -- BEGIN OF ALU LOGIC --
            ALU_inst : ALU port map(
                ALUControl => ALUControl, 
                SrcA => internal_RD1,
                SrcB => internal_OutputSrc,
                ZEROFlag => Zero,
                ALUResult => ALUOut
            );
            MUX_ALU : MUX port map(
                Control => ALUSrc,
                InA => internal_RD2,
                InB => internal_valueEXT,
                OutputS => internal_OutputSrc
            );
            -- END OF ALU LOGIC --

            -- BEGIN OF REGISTER FILE LOGIC --
            RegisterFile_inst : RegisterFile port map(
                A1 => instr(25 downto 21),
                A2 => instr(20 downto 16),
                A3 => WriteReg,
                WD3 => Result_dataMEM,
                WE3 => RegWrite,
                clk => clk,
                RD1 => internal_RD1,
                RD2 => internal_RD2
            );
				WriteData <= internal_RD2;
            
            MUX_RegFile : MUX5 port map(
                Control_5 => RegDST,
                InA_5 => Instr(20 downto 16),
                InB_5 => Instr(15 downto 11),
                OutputS_5  => WriteReg
            );
            MUX_DataMemory : MUX port map(
                Control => MemToReg,
                InA => internal_ALUResult,
                InB => ReadData,
                OutputS => Result_dataMEM
            );
            -- END OF REGISTER FILE LOGIC --

            -- BEGIN OF SIGN EXTEND LOGIC --
            SignExt_inst : SignExt port map(
                value => Instr(15 downto 0),
                valueEXT => internal_valueEXT
            );
            -- END OF SIGN EXTEND LOGIC --

            -- BEGIN OF PC LOGIC --
            PC_inst : PC port map(
                pcin => PC_next,         
			    clk => clk, 
                reset => reset,  
			    overflowFlag => Excpetion, 
			    pcout => PC_OUT        
            );
            ADDER_PC : ADDER port map(
                InA   => PC_next,
                InB   => x"00000004",
                Result => PC_plus4
            );
            ShiftLeft_PC : ShiftLeft port map(
                InSll  => internal_valueEXT,
                OutSll => OutSll_PC
            );
            ShiftLeft_JUMP : ShiftLeftJump port map(
                InSll  => Instr(25 downto 0),
                OutSll => OutSll_PCJUMP
            );
            ADDER_PCbranch : ADDER port map(
                InA   => OutSll_PC,
                InB   => PC_plus4,
                Result => PC_Branch
            );
            MUX_PC : MUX port map(
                Control => Pcsrc,
                InA => PC_plus4,
                InB => PC_Branch,
                OutputS => Result_PC
            );
            MUX_JUMPPC : MUX port map(
                Control => Jump,
                InA => Result_PC,
                InB => PC_plus4(31 downto 28)  & (OutSll_PCJUMP) & "00",
                OutputS => PC_next
            );
    end Arch;