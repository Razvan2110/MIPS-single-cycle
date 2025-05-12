----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2024 08:25:09 PM
-- Design Name: 
-- Module Name: EX - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
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
end EX;

architecture Behavioral of EX is
signal mux ,result :std_logic_vector(31 downto 0);
signal ALUCtrl: std_logic_vector(5 downto 0);
begin

--mux
process(ALUSrc, RD2,Ext_Imm)
begin
    if ALUSrc='0' then
        mux<=RD2 ;
    elsif ALUSrc='1' then
        mux<=Ext_Imm;
    end if;
end process;

BranchAdress<=Ext_Imm;

process(ALUOp , func)
begin
    case ALUop is 
        when "000000" => ALUCtrl <= func;
        when "000001" => ALUCtrl <= "000001"; --bgez
        when "100011" => ALUCtrl <= "100011"; --lw
        when "101011" => ALUCtrl <= "101011"; --sw
        when "100000" => ALUCtrl <= "100000"; --addi
        when "000101" => ALUCtrl <= "000101"; --bne
        when "000010" => ALUCtrl <= "000010"; --jump
        when others => ALUCtrl <="XXXXXX";
    end case;

end process;

process (ALUCtrl)
begin
case (ALUCtrl) is
    when "000001"=>                 --BGEZ
        if RD1 = X"00000000" then 
            result <= X"00000000";
        else
            result<= X"11111111";
        end if; 
    when  "100011" =>               --lw
          result <= RD1+mux;
    when "101011" =>                 --sw
           result <= RD1+mux;
    when "001000" =>                 --addi
            result<=RD1+mux;
    when "000101" =>                  --bne
            if RD1 /=RD2 then              
            result <= X"00000000";
            else result <= X"11111111";
            end if;     
    when "011000" =>                    --add
            result <= RD1+mux;  
    when "111100" =>                    --sub
            result <= RD1-mux;        
    when "100001" =>                    --bitwise and 
            result <= RD1 AND mux;      
    when "010010"=>                      --bitwise or
            result <= RD2 OR mux;
    when others=>result<=X"11111111";        
end case;
end process;

Zero<='0' when result /= X"00000000" else '1';
ALURes<= result;
end Behavioral;
