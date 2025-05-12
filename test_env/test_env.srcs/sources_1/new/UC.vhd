----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2024 05:30:53 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
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
end UC;

architecture Behavioral of UC is

begin

process(instr)
begin
case instr is 
---FIECARE INSTRUCTIUNE DIN IFETCH
    when "000000" =>    -- tip R
        RegDst <= '1'; 
        RegWrite <= '1';
         ALUSrc <= '0';
         ExtOperation <= '0';
         ALUOp<="000000";  
          MemWrite <='0';
         MemtoReg <= '0';
         Brench <= '0';
         Jump <= '0'; 
         
         when "000001" =>    --bgez   -- tip I
         RegDst <= 'X'; 
         RegWrite <= '0';
         ALUSrc <= '0';
         ExtOperation <= '1';
         ALUOp<="000001";  
          MemWrite <='0';
         MemtoReg <= 'X';
         Brench <= '1';
         Jump <= '0';     
       
         when "100011" =>   --lw -- tip I
         RegDst <= '0'; 
         RegWrite <= '1';
         ALUSrc <= '1';
         ExtOperation <= '0';
         ALUOp<="100011";  
         MemWrite <='0';
         MemtoReg <= '1';
         Brench <= '0';
         Jump <= '0';    
         
        when "101011" =>    --SW  -- tip I
         RegDst <= '0'; 
         RegWrite <= '0';
         ALUSrc <= '1';
         ExtOperation <= '0';
         ALUOp<="101011";  
         MemWrite <='1';
         MemtoReg <= '0';
         Brench <= '0';
         Jump <= '0'; 
         
         
         when "001000" =>    --ADDI  -- tip I
         RegDst <= '0'; 
         RegWrite <= '1';
         ALUSrc <= '0';
         ExtOperation <= '0';
         ALUOp<="001000";  
         MemWrite <='0';
         MemtoReg <= '0';
         Brench <= '0';
         Jump <= '0';
         
         when "000101" =>    --BNE  -- tip I
         RegDst <= '0'; 
         RegWrite <= '0';
         ALUSrc <= '0';
         ExtOperation <= '0';
         ALUOp<="000101";  
         MemWrite <='0';
         MemtoReg <= '0';
         Brench <= '1';
         Jump <= '0';
         
       
         
         when "000010" =>    --j  -- tip J
         RegDst <= 'X'; 
         RegWrite <= '0';
         ALUSrc <= 'X';
         ExtOperation <= 'X';
         ALUOp<="0000XX";  
         MemWrite <='0';
         MemtoReg <= 'X';
         Brench <= 'X';
         Jump <= '1';
         
        
         
      
         
--     when "" =>
--         ALUOp<="XXXXXX"; 
--         RegDst <= 'X'; 
--         ExtOperation <= 'X';
--         ALUSrc <= 'X';
--         Brench <= 'X';
--         Jump <= 'X';
--         MemWrite <='X';
--         MemtoReg <= 'X';
--         RegWrite <= 'X';
     
    when others =>
        ALUOp<="XXXXXX"; 
         RegDst <= 'X'; 
         ExtOperation <= 'X';
         ALUSrc <= 'X';
         Brench <= 'X';
         Jump <= 'X';
         MemWrite <='X';
         MemtoReg <= 'X';
         RegWrite <= 'X';
end case;
end process;

end Behavioral;
