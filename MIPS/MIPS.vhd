library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MIPS is 
port(
    clk, reset : in std_logic;
    ReadData : in std_logic_vector(31 downto 0);
    Instr : in std_logic_vector(31 downto 0);
    pc : out std_logic_vector(31 downto 0);
    ALUOut : out std_logic;
    WriteData : out std_logic_vector(31 downto 0)
);
end MIPS;

architecture ARCH of MIPS is

    component DataPath is port(
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
        RegDst      : out std_logic;
        RegWrite    : out std_logic;
        Jump        : out std_logic
    );
	 end component;

    signal internal_Instr : std_logic_vector(31 downto 0);
    signal internal_PCsrc : std_logic;
    signal internal_ReadData : std_logic_vector(31 downto 0);
    signal internal_WriteData : std_logic_vector(31 downto 0);
    signal internal_pc : std_logic_vector(31 downto 0);
    signal internal_exception : std_logic;
    signal internal_MemToReg : std_logic;
    signal internal_RegWrite : std_logic;
    signal internal_ALUSrc : std_logic;
    signal internal_ALUControl : std_logic_vector(2 downto 0);
    signal internal_RegDST : std_logic;
    signal internal_jump : std_logic;
    signal internal_MemWrite : std_logic;
	 signal internal_Zero : std_logic;

    begin
        DataPath_inst : DataPath port map(
            clk => clk,
            reset => reset,
       -- MemWrite : in std_logic;
            MemToReg => internal_MemToReg,
            RegWrite => internal_RegWrite,
            ALUSrc => internal_ALUSrc,
            ALUControl => internal_ALUControl,
            RegDST => internal_RegDST,
            Jump => internal_jump,
            Instr => Instr,
            Pcsrc => internal_PCsrc,
            ReadData => ReadData,
            WriteData => WriteData,
            PC_OUT => pc,
            Zero => internal_Zero,
            Excpetion => internal_exception,
            ALUOut => ALUOut
        );

        ControlUnit_inst : ControlUnit port map(
            OP          => Instr(31 downto 26),
            Funct       => Instr(5 downto 0),
            MemToReg    => internal_MemToReg,
            MemWrite    => internal_MemWrite,
            Pcsrc      => internal_PCsrc,
            ALUControl  => internal_ALUControl,
            AluSrc      => internal_ALUSrc,
            RegDst      => internal_RegDST,
            RegWrite    => internal_RegWrite,
            Jump        => internal_jump,
			Zero        => internal_Zero
        );
    end ARCH;