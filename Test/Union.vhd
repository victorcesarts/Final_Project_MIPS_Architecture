library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 entity Union is port(
        address_u : in std_logic_vector(31 downto 0);
        clk : in std_logic;
        RegWrite : in std_logic;
        ReadData : in std_logic_vector(31 downto 0);
        RD1_u : out std_logic_vector(31 downto 0);
        RD2_u : out std_logic_vector(31 downto 0)
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

    signal internal_PCcurrent : std_logic_vector(31 downto 0);
    signal internal_Instr : std_logic_vector(31 downto 0);
    
    begin
         Instr_inst : InstrMemory  port map(
            address => address_u,
            instr => internal_Instr
        );

        Reg_inst : RegisterFile port map(
            A1 => internal_Instr(25 downto 21),
            A2 => internal_Instr(20 downto 16),
            A3 => internal_Instr(20 downto 16),
            WD3 => ReadData,
            WE3 => RegWrite,
            clk => clk,
            RD1 => RD1_u,
            RD2 => RD2_u 
        );
    end ARCH;