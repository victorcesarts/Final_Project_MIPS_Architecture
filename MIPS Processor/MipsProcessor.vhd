library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MipsProcessor is 
    port(
        clk         : in std_logic;
        reset       : in std_logic;
        Instr       : out std_logic_vector(31 downto 0);
		ReadData    : out std_logic_vector(31 downto 0)
    );
    end entity;

    architecture MipsProcARCH of MipsProcessor is
        --              Internal signals InstrMem           --
        signal internal_instr : std_logic_vector(31 downto 0);
        signal internal_pc : std_logic_vector(31 downto 0);

        --              Internal signals DataMEM            --
        signal internal_alu : std_logic_vector(31 downto 0);
        signal internal_WD : std_logic_vector(31 downto 0);
        signal internal_WE : std_logic;
		signal internal_ReadData : std_logic_vector(31 downto 0);

        component MIPS is port(
            clk, reset  : in std_logic;
            Instruction : in std_logic_vector(31 downto 0);
            ReadData    : in std_logic_vector(31 downto 0);
            ALUOut      : out std_logic_vector(31 downto 0);
            PC          : out std_logic_vector(31 downto 0);
            WriteData   : out std_logic_vector(31 downto 0);
            MemWrite    : out std_logic
        );
    end component;

    component InstrMemory is port(
        address : in std_logic_vector(31 downto 0);
        instr : out std_logic_vector(31 downto 0)
    );
    end component;

    component DataMemory is 
	    port(
		    MemAddress  : in std_logic_vector (31 downto 0);
		    Datain		: in std_logic_vector (31 downto 0);
		    clk         : in std_logic;
		    WE	        : in std_logic;
		    ReadDataOut : out std_logic_vector(31 downto 0)
	    );
    end component;

    begin 

    MIPS_inst : MIPS port map(
        clk   => clk,
        reset => reset,
        ReadData => internal_ReadData,
        Instruction => internal_instr,
        PC => internal_pc,
        ALUOut => internal_alu,
        WriteData => internal_WD,
        MemWrite => internal_WE		  
    );
    
    InstrMem_inst : InstrMemory port map(
        address => internal_pc,
        instr => internal_instr
    );

    DataMEM_inst : DataMemory port map(
        MemAddress  => internal_alu,
		Datain		=> internal_WD,
		clk         => clk,
		WE	        => internal_WE,
		ReadDataOut => internal_ReadData
    );

    ReadData <= internal_ReadData;
    Instr <= internal_instr;
    end MipsProcARCH;
    