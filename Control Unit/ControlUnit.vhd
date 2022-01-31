library IEEE;
use ieee.std_logic_1164.all;

entity ControlUnit is
    port(
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
end ControlUnit;

architecture structControlUnit of ControlUnit is

    --MainDecoder component--
    component MainDecoder is
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
    end component;

    --ALUDecoder component--
    component ALUDecoder is
        port(   
            FunctD      : in std_logic_vector(5 downto 0);
            ALUopD      : in std_logic_vector(1 downto 0);
            ALUControlD : out std_logic_vector(2 downto 0)
        );
    end component;
    
        signal ALUopcode : std_logic_vector(1 downto 0);
        signal internal_Branch : std_logic;
    begin
        -- Instantiating one MainDecoder --
        MainDec : MainDecoder port map(
            OPM => OP,
            MemToRegM => MemToReg,
            MemWriteM => MemWrite,
            BranchM => internal_Branch,
            AluSrcM => AluSrc,
            RegDstM => RegDst,
            RegWriteM => RegWrite,
            jumpM => Jump,
            ALUopM => ALUopcode
        );
        Pcsrc <= internal_Branch and Zero;
        -- Instantiating one ALUDecoder --
        ALUDec : ALUDecoder port map(
            FunctD => Funct,
            ALUopD => ALUopcode,
            ALUControlD => ALUControl
        );

end structControlUnit;
