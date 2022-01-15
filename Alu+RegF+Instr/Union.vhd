library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 entity Union is port(
        Address_u : in std_logic_vector(31 downto 0);
        ReadData : in std_logic_vector(31 downto 0);
        clk : in std_logic;
        RegWrite : in std_logic;
        ALUSrc : in std_logic;
        MemtoReg : in std_logic;
        RegDst : in std_logic_vector(1 downto 0);
        ALUControl_U : in std_logic_vector(2 downto 0);
        ZEROFlag_U : out std_logic;
        Result : out std_logic_vector(31 downto 0);
        WriteData: out std_logic_vector(31 downto 0)
 );
end Union;

architecture ARCH of Union is

    component InstrMemory is port(
        address : in std_logic_vector(31 downto 0);
        instr : out std_logic_vector(31 downto 0)
    );
    end component;

    component RegisterFile is
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

    component ALU is
        port (
            ALUControl 	: in    std_logic_vector(2 downto 0);
            SrcA    	: in    std_logic_vector(31 downto 0);
            SrcB    	: in    std_logic_vector(31 downto 0);
            ZEROFlag  	: out   std_logic;
            ALUResult	: out   std_logic_vector(31 downto 0)
        );
    end component;

    component MUX is
        port (
            Control 	: in    std_logic;
            InA    	    : in    std_logic_vector(31 downto 0);
            InB    	    : in    std_logic_vector(31 downto 0);
            OutputS  	: out   std_logic_vector(31 downto 0)
        );
    end component;

    component SignExt is
        port(
            value : in std_logic_vector(15 downto 0);
            valueEXT : out std_logic_vector(31 downto 0)
        );
     end component;

    component MUX5 is
        port (
            Control_5 	: in    std_logic_vector(1 downto 0);
            InA_5   	: in    std_logic_vector(4 downto 0);
            InB_5   	: in    std_logic_vector(4 downto 0);
            In31        : in    std_logic_vector(4 downto 0);
            OutputS_5 	: out   std_logic_vector(4 downto 0)
        );
    end component;

    component PC is 
        port(
			pcin         : in std_logic_vector(31 downto 0);
			clk, reset   : in std_logic;
			pcout        : out std_logic_vector(31 downto 0)
	    );
    end component;

    signal internal_RD1 : std_logic_vector(31 downto 0);
    signal internal_RD2 : std_logic_vector(31 downto 0);
    signal internal_Instr : std_logic_vector(31 downto 0);
    signal SignImm : std_logic_vector(31 downto 0);
    signal internal_SrcB : std_logic_vector(31 downto 0);
    signal internal_ALUResult : std_logic_vector(31 downto 0);
    signal internal_ReadData : std_logic_vector(31 downto 0);
    signal internal_A3 : std_logic_vector(4 downto 0);
    signal internal_Result : std_logic_vector(31 downto 0);
    begin
        PC_inst :PC port map(
            pcin         =>
			clk, reset   : in std_logic;
			pcout        : out std_logic_vector(31 downto 0)
        );

        Instr_inst : InstrMemory  port map(
            address => Address_u,
            instr => internal_Instr
        );

       internal_Result <= Result;
       WriteData <= internal_RD2;
        Reg_inst : RegisterFile port map(
            A1 => internal_Instr(25 downto 21),
            A2 => internal_Instr(20 downto 16),
            A3 => internal_A3,
            WD3 => internal_Result,
            WE3 => RegWrite,
            clk => clk,
            RD1 => internal_RD1,
            RD2 => internal_RD2 
        );

        Sign_Ext : SignExt port map(
            value => internal_Instr(15 downto 0),
            valueEXT => SignImm
        );

        MUX_Inst : MUX port map(
            Control 	=> ALUSrc,
            InA    	    => internal_RD2,
            InB    	    => SignImm,
            OutputS  	=> internal_SrcB
        ); 
        internal_ReadData <= ReadData;
        MUX_InstDM : MUX port map(
            Control 	=> MemtoReg,
            InA    	    => internal_ALUResult,
            InB    	    => internal_ReadData,
            OutputS  	=> Result
        ); 

        MUX5_Inst : MUX5 port map(
            Control_5 	=> RegDst,
            InA_5   	=> internal_Instr(20 downto 16),
            InB_5   	=> internal_Instr(15 downto 11),
            In31        => "11111",
            OutputS_5 	=> internal_A3
        );
        

        ALU_inst : ALU port map (
            ALUControl 	=> ALUControl_U,
            SrcA    	=> internal_RD1,
            SrcB    	=> internal_SrcB,
            ZEROFlag  	=> ZEROFlag_U,
            ALUResult	=> internal_ALUResult
        );
    end ARCH;