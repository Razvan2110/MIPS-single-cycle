library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using

use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity I_Fetch is
    Port ( clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           Jump_Adress : in STD_LOGIC_VECTOR (31 downto 0);
           Branch_Adress : in STD_LOGIC_VECTOR (31 downto 0);
           Jump: in std_logic;
           PCSrc : in std_logic;
           next_instr : out STD_LOGIC_VECTOR (31 downto 0);
           current_instr : out STD_LOGIC_VECTOR (31 downto 0)
           );
end I_Fetch;

architecture Behavioral of I_Fetch is

signal mux1 :  STD_LOGIC_VECTOR (31 downto 0);
signal mux2 :  STD_LOGIC_VECTOR (31 downto 0);
signal  PCinc : std_LOGIC_VECTOR(31 DOWNTO 0);
signal dig : std_logic_vector(31 downto 0);
signal en , rst : std_logic;
signal pcOut :std_logic_vector(31 downto 0):=X"00000000";
signal suma : std_logic_vector(31 downto 0);
----INSTRUCTIUNILE IN COD MASINA SI ASM
type tROM is array(0 to 511) of std_logic_vector(31 downto 0);
signal ROM :tROM:=(   --lw : 100011

 --t1 00001 , t2 00010 , t3 01000 
 --zero 11110
         B"100011_00000_00000_0000000000000000"  ,       -- lw $t0, array         --
         B"100011_00000_00001_0000000000000110"  ,       -- lw $t1, n  
         B"100011_00000_00010_0000000000001100"  ,       -- lw $t2, cnt         
         B"100011_00000_10000_0000000000000111"  ,       -- lw $s0, firstmax      
         B"100011_00000_10001_0000000000001000"  ,       -- lw $s1, secmax
         B"100011_00000_10010_0000000000001001"  ,        -- lw $s2, firstmin
         B"100011_00000_10011_0000000000001010"  ,         -- lw $s3, secmin
                --adr --reg                     --6
--loop                 
         B"000000_00010_00001_00100_00000_100010",       --sub $t4, $t2, $t1 
                   --T2 --T1   --T4                              
         B"000001_00000_00100_0000000000011110" ,         --bgez $t4 , end_loop
         B"100011_00000_00011_0000000000000000" ,        -- lw $t3, 0($t0)
                                                --9
         --compare and update minimum
         B"000000_00011_10010_00100_00000_101010"  ,     -- slt $t4, $t3, $s2 
         B"000101_00100_11110_0000000000001110" ,      -- bne $t4, $zero, update_firstmin
         B"000000_00011_10011_00100_00000_101010"  ,    --slt $t4, $t3, $s3  
         B"000101_00100_11110_0000000000010001" ,      -- bne $t4, $zero, update_secmin
                                                --13
            B"000010_00000000000000000000010010"   ,   --j contiune
 --update_firstmin
            B"000000_10010_11110_10011_00000_100000"  ,   -- add $s3, $s2, $zero     # secmin = firstmin
            B"000000_00011_11110_10010_00000_100000"  ,    --add $s2, $t3, $zero     # firstmin = current
            B"000010_00000000000000000000010010" ,     --j continue
                                                --17
--update_secmin:
            B"000000_00011_11110_10011_00000_100000" ,     -- add $s3, $t3, $zero -- $zero ii registrul 30 penultimul                                         
--continue
             B"000000_10000_00011_00100_00000_101010" ,      -- slt $t4, $s0, $t3       # Compare firstmax with current element
             B"000101_00100_11110_0000000000011001" ,      -- bne $t4, $zero, update_firstmax
             B"000000_10001_00011_00100_00000_101010" ,     -- slt $t4, $s1, $t3       # Compare secmax with current element
             B"000101_00100_11110_0000000000011100" ,     -- bne $t4, $zero, update_secmax                                                 --22
  --update_maxs:        
              B"100000_00000_00000_0000000000000100" ,        -- addi $t0, $t0, 4
              B"100000_00010_00010_0000000000000001" ,      -- addi $t2, $t2, 1       
              B"000010_00000000000000000000000110"   ,         --J LOOP
                                                    --25    
--update_firstmax:                                                                                  
             B"000000_10000_11110_10001_00000_100000" ,       --add $s1, $s0, $zero 
             B"000000_00011_11110_10000_00000_100000" ,        --add $s0, $t3, $zero
             B"000010_00000000000000000000010110"   ,   --j update_maxs
                                                    --28
--update_secmax:     
             B"000000_00011_11110_10001_00000_100000" ,     -- add $s1, $t3, $zero
             B"000010_00000000000000000000010110"   ,     --j update_maxs
                                                     --30   
 --end loop:                                        
            B"000000_10010_10011_00101_00000_100000" ,      --add $t5, $s2, $s3 
            B"000000_10000_10001_00110_00000_100000" ,     --add $t6, $s0, $s1 
            B"000000_00101_00110_00111_00000_100000"   ,     --add $t7, $t5, $t6 
                                                             ---sum is in t7
                         
   others => x"11111111"
);

begin
--PC 
process(clk, rst)
begin
    if rst = '1' then
        pcOut <= X"00000000";
    elsif rising_edge(clk) then
        if en = '1' then
            pcOut <= mux2;
        end if;
    end if;
end process;
current_instr<= ROM(conv_integer(pcOut));
suma <= pcOut + 1;

--mux1
process(PCSrc,  suma , Branch_Adress)
begin
if PCSrc='0' then
mux1<=suma;
else mux1 <= Branch_Adress;
end if;
end process;

--mux2

process(Jump,  suma , Branch_Adress)
begin
if Jump='1' then
    mux2<=Jump_Adress;
else 
    mux2 <= mux1;
end if;

end process;

end Behavioral;