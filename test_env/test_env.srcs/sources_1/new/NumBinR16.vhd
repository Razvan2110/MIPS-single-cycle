library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity NumBinR16 is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end NumBinR16;

architecture Behavioral of NumBinR16 is
signal count : std_logic_vector(15 downto 0) := (others=>'0');
signal q1,q2,q3 : std_logic;
signal en : std_logic;

begin

process(clk)
begin
    if rising_edge(clk)then
        count <= count + 1;
    end if;
    if count = B"1111111111111111" then
        en <= '1';
    else
        en <= '0';
    end if;
end process;

process (clk)
begin
    if rising_edge(clk) then 
    
        if en = '1' then
        
            q1 <= btn;
            
        end if;
        
    end if;
    
    
    if rising_edge(clk) then 
    
        q2 <= q1;
        
    end if;
    
    if rising_edge(clk) then
    
       q3<=q2;
       
    end if;
    
    if q3 ='0' and q2 ='1' then
    
        enable <= '1';
        
    else 
    
        enable <= '0';
        
    end if;
    
end process;



end Behavioral;