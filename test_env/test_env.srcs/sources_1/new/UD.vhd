
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UD is
    Port ( clk : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (26 downto 0);  
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           WD : in STD_LOGIC_vector(31 downto 0);
           func : out STD_LOGIC_VECTOR (5 downto 0);
           sa : out STD_LOGIC_VECTOR (4 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (31 downto 0);
           RD1 : out STD_LOGIC_VECTOR(31 downto 0);
           RD2 : out STD_LOGIC_VECTOR(31 downto 0)
           );
end UD;

architecture Behavioral of UD is
signal mux : std_logic_vector(4 downto 0);
signal ra1 : std_logic_vector (4 downto 0);
signal ra2 :std_logic_vector (4 downto 0);
signal RegWr : std_logic;
signal wa : std_logic_vector (4 downto 0);


component reg_block is
    Port ( RA1 : in STD_LOGIC_VECTOR (4 downto 0);
           RA2 : in STD_LOGIC_VECTOR (4 downto 0);
           WA : in STD_LOGIC_VECTOR (4 downto 0);
           WD : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           RegWr : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (31 downto 0);
           RD2 : out STD_LOGIC_VECTOR (31 downto 0));
end component;

begin
reg_block_eticheta : reg_block port map(ra1, ra2 , wa ,WD ,clk  , RegWrite , RD1 , RD2 );

ra1<=instr(25 downto 21);
ra2<=instr(20 downto 16);
wa <=mux;

--MUX IF(RegDst)
process (instr , RegDst , mux)
begin
    if RegDst ='1' then 
     mux <=instr(15 downto 11);
    elsif RegDst ='0' then 
        mux<=instr(20 downto 16);
    end if;
end process;

--ext 
process(ExtOp)
begin
if ExtOp ='0' then 
    Ext_Imm<= x"0000" & instr(15 downto 0); 
elsif ExtOp='1' then
    Ext_Imm <= instr(15)&instr(15)& instr(15)& instr(15)& instr(15)&
     instr(15)& instr(15)& instr(15)& instr(15)& instr(15)& instr(15)& 
     instr(15)& instr(15)& instr(15)& instr(15)& instr(15)& instr(15 downto 0); 
end if;
end process;

func<= instr(5 downto 0);
sa <=instr(10 downto 6);


end Behavioral;
