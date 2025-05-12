----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2024 09:07:40 PM
-- Design Name: 
-- Module Name: DataMem - Behavioral
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

entity DataMem is
    Port ( clk : in std_logic; 
           MemWrite : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (31 downto 0));
end DataMem;

architecture Behavioral of DataMem is

component ram_wr_1st is
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (31 downto 0);
           di : in STD_LOGIC_VECTOR (31 downto 0);
           do : out STD_LOGIC_VECTOR (31 downto 0));
end component;

begin

Memorie : ram_wr_1st port map(clk,MemWrite,ALUResIn,RD2,MemData);

ALUResOut<=ALUResIn;


end Behavioral;
