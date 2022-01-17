library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MIPS is 
port(
    clk, reset  : in std_logic;
    Instruction : in std_logic_vector(31 downto 0);
    ReadData    : in std_logic_vector(31 downto 0);
    ALUOut      : out std_logic_vector(31 downto 0);
    PC          : out std_logic_vector(31 downto 0);
    WriteData   : out std_logic_vector(31 downto 0);
    MemWrite    : out std_logic
);
end MIPS;

architecture ARCH of MIPS is

    component DataPath is port(
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
	 end component;

    component ControlUnit is port(
        OP          : in std_logic_vector (5 downto 0);
        Funct       : in std_logic_vector (5 downto 0);
        MemToReg    : out std_logic;
        MemWrite    : out std_logic;
        Zero        : in std_logic;
        PCsrc       : out std_logic;
        ALUControl  : out std_logic_vector(2 downto 0);
        AluSrc      : out std_logic;
        RegDst      : out std_logic_vector(1 downto 0);
        RegWrite    : out std_logic;
        Jump        : out std_logic
    );
	 end component;

    signal internal_RegWrite   : std_logic;
    signal internal_RegDST     : std_logic_vector(1 downto 0);
    signal internal_ALUSrc     : std_logic;
    signal internal_MemToReg   : std_logic;
    signal internal_PCsrc      : std_logic;
    signal internal_ALUControl : std_logic_vector(2 downto 0);   
	signal internal_Zero       : std_logic;
    signal internal_jump       : std_logic;
    begin
        DataPath_inst : DataPath port map(
        Instr        => Instruction,   
        Reset        => reset,
        clk          => clk,
        ReadData     => ReadData,
        RegWrite     => internal_RegWrite,
        RegDst       => internal_RegDST, 
        ALUSrc       => internal_ALUSrc,
        MemtoReg     => internal_MemToReg,
        PCSrc        => internal_PCsrc,
        ALUControl_U => internal_ALUControl,
        PCout        => PC,
        ZEROFlag_U   => internal_Zero,
        ALUOut       => ALUOut,
        WriteData    => WriteData
        );

        ControlUnit_inst : ControlUnit port map(
            OP          => Instruction(31 downto 26),
            Funct       => Instruction(5 downto 0),
            MemToReg    => internal_MemToReg,
            MemWrite    => MemWrite,
            Pcsrc       => internal_PCsrc,
            ALUControl  => internal_ALUControl,
            AluSrc      => internal_ALUSrc,
            RegDst      => internal_RegDST,
            RegWrite    => internal_RegWrite,
            Jump        => internal_jump,
			Zero        => internal_Zero
        );
    end ARCH;