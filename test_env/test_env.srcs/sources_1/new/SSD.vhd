library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity SSD is
    Port ( clk : in STD_LOGIC;
           digit : in STD_LOGIC_VECTOR (31 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0));
end SSD;

architecture Behavioral of SSD is

signal count: std_logic_vector(16 downto 0) := (others => '0');
signal sel: std_logic_vector(2 downto 0);
signal muxcat: std_logic_vector(3 downto 0);

begin
    process(clk)
    begin
        if rising_edge(clk) then
            count <= count + 1;
        end if;
    end process;
    
        process(sel)
    begin
        case sel is
            when "000" => an <= "11111110";
            when "001" => an <= "11111101";
            when "010" => an <= "11111011";
            when "011" => an <= "11110111";
            when "100" => an <= "11101111";
            when "101" => an <= "11011111";
            when "110" => an <= "10111111";
            when "111" => an <= "01111111";
            when others => an <= "11111110";
        end case;
    end process;
    
    sel <= count(16 downto 14);
    
    process(sel, digit)
    begin
        case sel is
            when "000" => muxCat <= digit(3 downto 0);
            when "001" => muxCat <= digit(7 downto 4);
            when "010" => muxCat <= digit(11 downto 8);
            when "011" => muxCat <= digit(15 downto 12);
            when "100" => muxCat <= digit(19 downto 16);
            when "101" => muxCat <= digit(23 downto 20);
            when "110" => muxCat <= digit(27 downto 24);
            when "111" => muxCat <= digit(31 downto 28);
            when others => muxCat <= "0000";
        end case;
    end process;
    

    
    with muxCat select
        cat <= "1111001" when "0001",   
               "0100100" when "0010",   
               "0110000" when "0011",   
               "0011001" when "0100",   
               "0010010" when "0101",   
               "0000010" when "0110",   
               "1111000" when "0111",   
               "0000000" when "1000",   
               "0010000" when "1001",   
               "0001000" when "1010",   
               "0000011" when "1011",   
               "1000110" when "1100",   
               "0100001" when "1101",   
               "0000110" when "1110",   
               "0001110" when "1111", 
               "1000000" when others;   
end Behavioral;
