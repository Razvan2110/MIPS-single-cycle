
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_env is
    Port (
        clk : in STD_LOGIC;
        btn : in STD_LOGIC_VECTOR(4 downto 0);
        led : out STD_LOGIC_VECTOR (15 downto 0);
        sw : in STD_LOGIC_vector(7 downto 0);
        cat : out STD_LOGIC_VECTOR (6 downto 0);
        an : out STD_LOGIC_VECTOR (7 downto 0)
    );
end test_env;

architecture Behavioral of test_env is


component SSD is
    Port ( clk : in STD_LOGIC;
           digit : in STD_LOGIC_VECTOR (31 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component NumBinR16 is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;


component I_Fetch is
   Port (   clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           Jump_Adress : in STD_LOGIC_VECTOR (31 downto 0);
          Branch_Adress : in STD_LOGIC_VECTOR (31 downto 0);
           Jump: in std_logic;
           PCSrc : in std_logic;
           next_instr : out STD_LOGIC_VECTOR (31 downto 0);
           current_instr : out STD_LOGIC_VECTOR (31 downto 0)
           );
end component;


component UD is
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
end component;


component EX is
        Port ( RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (31 downto 0);
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOp : in STD_LOGIC_VECTOR(5 downto 0);
           PC_4 : in STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (31 downto 0);
           BranchAdress : out STD_LOGIC_VECTOR (31 downto 0));
end component;


component DataMem is
    Port ( clk : in std_logic; 
           MemWrite : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (31 downto 0));
end component;


component UC is
Port (
clk : in std_logic;
instr : in std_logic_vector(5 downto 0);
ALUop : out  std_logic_vector(5 downto 0);
ALUSrc : out std_logic;
Brench : out std_logic;
Jump : out std_logic;
ExtOperation : out std_logic;
MemtoReg: out std_logic;
MemWrite : out std_logic;
RegDst : out std_logic;
RegWrite : out std_logic
);
end component;

    signal enable : std_logic;
    signal count : std_logic_vector(15 downto 0);
    signal digit ,WD, Ext_Imm : std_logic_vector(31 downto 0);
    signal addr, func ,ALUop: std_logic_vector(5 downto 0);
    signal di : std_logic_vector(31 downto 0);
    signal do_ram, ALURes: std_logic_vector(31 downto 0);
    signal  Jump_Adress : STD_LOGIC_VECTOR (31 downto 0);
      signal    Branch_Adress ,MemData ,ALUResOut:  STD_LOGIC_VECTOR (31 downto 0);
      signal Jump , PCSrc, RegWrite, RegDst ,ExtOp,ALUSrc, Zero, MemWrite, MemtoReg, Brench:STD_LOGIC;
      signal next_instr,current_instr:  STD_LOGIC_VECTOR (31 downto 0);
      signal sa : std_logic_vector(4 downto 0); 
      signal RD1, RD2 :STD_LOGIC_VECTOR (31 downto 0);

 begin
   Jump_Adress<="000000" & current_instr(25 downto 0);
   
   MPG_BUTON: NumBinR16 port map(clk,btn(0),enable);
   SSDeticheta : SSD port map(clk , digit , cat , an);
   IF_et : I_Fetch port map(clk,enable,Jump_Adress, Branch_Adress,Jump,PCSrc,next_instr,current_instr);
   ID : UD port map(clk,current_instr(26 downto 0),RegWrite,RegDst,ExtOp,WD,func,sa,Ext_Imm,RD1,RD2);
   EX_Unit : EX port map(RD1,ALUSrc,RD2,Ext_Imm , sa , func , ALUOp ,next_instr , Zero , ALURes ,Branch_Adress );
   DataMemory : DataMem port map(clk,MemWrite,ALURes, RD2 , MemData , ALUResOut);
    ControlUnit : UC port map(clk , current_instr(31 downto 26) , ALUop , ALUsrc , Brench  , ExtOp , Jump , MemtoReg , MemWrite , RegDst , RegWrite);


PCsrc <= Brench AND zero;

--mux MemtoReg
process (MemData , ALUResOut, MemtoReg )
begin
    if MemtoReg = '1' then
        WD<=MemData;
    elsif MemtoReg = '0' then 
        WD<=ALUResOut;
    end if;
end process;


process(sw)
    begin
        case(sw(7 downto 5)) is
            when "000" => digit <= current_instr;
            when "001" => digit <= next_instr;
            when "010" => digit <= RD1;
            when "011" => digit <= RD2;
            when "100" => digit <= Ext_Imm;
            when "101" => digit <= ALURes;
            when "110" => digit <= MemData;
            when "111" => digit <= WD;
            when others => digit <= X"00000000";
        end case;
    end process;

end Behavioral;
    