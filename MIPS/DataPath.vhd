library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 entity DataPath is port(
    Instr        : in std_logic_vector(31 downto 0);
    Reset        : in std_logic;
    clk          : in std_logic;
    ReadData     : in std_logic_vector(31 downto 0);
    RegWrite     : in std_logic;
    RegDst       : in std_logic_vector(1 downto 0);
    ALUSrc       : in std_logic;
    MemtoReg     : in std_logic;
    PCSrc        : in std_logic;
    ALUControl_U : in std_logic_vector(2 downto 0);
    ZEROFlag_U   : out std_logic;
    PCout        : out std_logic_vector(31 downto 0);
    ALUOut       : out std_logic_vector(31 downto 0);
    WriteData    : out std_logic_vector(31 downto 0)
);
end DataPath;

architecture ARCH of DataPath is
-------------------------------------------------------------
--                   COMPONENTS BEGIN                     --
-------------------------------------------------------------
    --component InstrMemory is port(
      --  address : in std_logic_vector(31 downto 0);
        --instr   : out std_logic_vector(31 downto 0)
    --);
    --end component;

    component RegisterFile is
        port(
            A1  : in std_logic_vector(4 downto 0);
            A2  : in std_logic_vector(4 downto 0);
            A3  : in std_logic_vector(4 downto 0);
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
            ALUResult   : out   std_logic_vector(31 downto 0)
        );
    end component;

    component MUX is
        port (
            Control : in    std_logic;
            InA    	: in    std_logic_vector(31 downto 0);
            InB    	: in    std_logic_vector(31 downto 0);
            OutputS : out   std_logic_vector(31 downto 0)
        );
    end component;

    component SignExt is
        port(
            value    : in std_logic_vector(15 downto 0);
            valueEXT : out std_logic_vector(31 downto 0)
        );
     end component;

    component MUX5 is
        port (
            Control_5 : in    std_logic_vector(1 downto 0);
            InA_5     : in    std_logic_vector(4 downto 0);
            InB_5     : in    std_logic_vector(4 downto 0);
            In31      : in    std_logic_vector(4 downto 0);
            OutputS_5 : out   std_logic_vector(4 downto 0)
        );
    end component;

    component PC is 
        port(
			pcin       : in std_logic_vector(31 downto 0);
			clk, reset : in std_logic;
			pcout      : out std_logic_vector(31 downto 0)
	    );
    end component;

    component Adder is
        port(
            InA    : in std_logic_vector(31 downto 0);
            InB    : in std_logic_vector(31 downto 0);
            Result : out std_logic_vector(31 downto 0)
        );
    end component;

    component ShiftLeft is
        port(
            InSll  : in std_logic_vector(31 downto 0);
            OutSll : out std_logic_vector(31 downto 0)
        );
    end component;
-------------------------------------------------------------
--                   END COMPONENTS                        --
-------------------------------------------------------------

--                   REGISTER SIGNALS                      --
    signal internal_RD1    : std_logic_vector(31 downto 0);
    signal internal_RD2    : std_logic_vector(31 downto 0);
    signal internal_A3     : std_logic_vector(4 downto 0);
    signal internal_Result : std_logic_vector(31 downto 0);

--                   INSTR. MEMORY SIGNALS                 --
    signal internal_Instr : std_logic_vector(31 downto 0);

--                   SIGN EXTEND SIGNALS                   --
    signal SignImm : std_logic_vector(31 downto 0);

--                   ALU SIGNALS                           --
    signal internal_SrcB      : std_logic_vector(31 downto 0);
    signal internal_ALUResult : std_logic_vector(31 downto 0);

--                   DATA MEMORY SIGNALS                   --
    signal internal_ReadData : std_logic_vector(31 downto 0);

--                   PC SIGNALS                            --
    signal PCplus4         : std_logic_vector(31 downto 0);
    signal internal_PCout  : std_logic_vector(31 downto 0);
    signal PC_branch       : std_logic_vector(31 downto 0);
    signal PC_in           : std_logic_vector(31 downto 0);
    signal internal_AdderB : std_logic_vector(31 downto 0);

    begin
-------------------------------------------------------------
--                   PC Logic                     --
-------------------------------------------------------------
        PCout <= internal_PCout;
        PC_inst : PC port map(
            pcin  => PC_in,
			clk   => clk,
            reset => Reset,
			pcout => internal_PCout
        );
        
        Adder_PC : Adder port map(
            InA    => internal_PCout,
            InB    => x"00000004",
            Result => PCplus4
        );

        Adder_Branch : Adder port map(
            InA    => internal_AdderB,
            InB    => PCplus4,
            Result => PC_branch
        );

        MUX_PC : MUX port map(
            Control  => PCSrc,
            InA    	 => PCplus4,
            InB    	 => PC_branch,
            OutputS  => PC_in
        );

        ShiftL_PC : ShiftLeft port map(
            InSll  => SignImm,
            OutSll => internal_AdderB
        );
-------------------------------------------------------------
--                   Instruction Logic                     --
-------------------------------------------------------------
     --   Instr_inst : InstrMemory  port map(
      --      address => internal_PCout,
        --    instr   => internal_Instr
        --);

-------------------------------------------------------------
--                   Register File Logic                   --
-------------------------------------------------------------
       
       WriteData <= internal_RD2;
        Reg_inst : RegisterFile port map(
            A1  => Instr(25 downto 21),
            A2  => Instr(20 downto 16),
            A3  => internal_A3,
            WD3 => internal_Result,
            WE3 => RegWrite,
            clk => clk,
            RD1 => internal_RD1,
            RD2 => internal_RD2 
        );

        MUX5_Register : MUX5 port map(
            Control_5 => RegDst,
            InA_5     => Instr(20 downto 16),
            InB_5     => Instr(15 downto 11),
            In31      => "11111",
            OutputS_5 => internal_A3
        );
-------------------------------------------------------------
--                   ALU Logic                             --
-------------------------------------------------------------
        Sign_Ext : SignExt port map(
            value    => Instr(15 downto 0),
            valueEXT => SignImm
        );

        MUX_ALU : MUX port map(
            Control  => ALUSrc,
            InA    	 => internal_RD2,
            InB    	 => SignImm,
            OutputS  => internal_SrcB
        ); 
        ALUOut <= internal_ALUResult;
        ALU_inst : ALU port map (
            ALUControl 	=> ALUControl_U,
            SrcA    	=> internal_RD1,
            SrcB    	=> internal_SrcB,
            ZEROFlag  	=> ZEROFlag_U,
            ALUResult	=> internal_ALUResult
        );
-------------------------------------------------------------
--                   Data Memory                           --
-------------------------------------------------------------
        internal_ReadData <= ReadData;
        MUX_DataMem : MUX port map(
            Control => MemtoReg,
            InA    	=> internal_ALUResult,
            InB    	=> internal_ReadData,
            OutputS => internal_Result
        );     
    end ARCH;