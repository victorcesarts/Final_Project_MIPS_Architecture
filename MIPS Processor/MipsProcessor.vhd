library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MipsProcessor is 
    port(
        clk : in std_logic;
        reset : in std_logic;
        ReadData_Mips : out std_logic_vector(31 downto 0);
        ALUout : out std_logic_vector(31 downto 0);
        WriteD : out std_logic_vector(31 downto 0);
		MemWrite : out std_logic
    );
    end entity;

    architecture MipsProcARCH of MipsProcessor is
        signal internal_instr : std_logic_vector(31 downto 0);
        signal internal_pc : std_logic_vector(31 downto 0);
		  signal internal_ReadData : std_logic_vector(31 downto 0);

        component MIPS is port(
            clk, reset : in std_logic;
            ReadData : in std_logic_vector(31 downto 0);
            Instr_mips : in std_logic_vector(31 downto 0);
            pc : out std_logic_vector(31 downto 0);
            ALUOut : out std_logic_vector(31 downto 0);
            WriteData : out std_logic_vector(31 downto 0);
            MemWrite : out std_logic
        );
    end component;

    component InstrMemory is port(
        address : in std_logic_vector(31 downto 0);
        instr : out std_logic_vector(31 downto 0)
    );
    end component;

    begin 

	
    MIPS_inst : MIPS port map(
        clk   => clk,
        reset => reset,
        ReadData => internal_ReadData,
        Instr_mips => internal_instr,
        pc => internal_pc,
        ALUOut => ALUout,
        WriteData => WriteD,
        MemWrite => MemWrite		  
    );

    InstrMem_inst : InstrMemory port map(
        address => internal_pc,
        instr => internal_instr
    );
    end MipsProcARCH;
    