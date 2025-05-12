library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram_wr_1st is
    Port (
        clk : in STD_LOGIC;
        we : in STD_LOGIC;
        addr : in STD_LOGIC_VECTOR (31 downto 0);
        di : in STD_LOGIC_VECTOR (31 downto 0);
        do : out STD_LOGIC_VECTOR (31 downto 0)
    );
end ram_wr_1st;

architecture Behavioral of ram_wr_1st is
    type ram_type is array(0 to 63) of std_logic_vector(31 downto 0);
    signal ram : ram_type := (
        0 => X"00000004",  -- Element 0 of array
        1 => X"00000009",  -- Element 1 of array
        2 => X"00000001",  -- Element 2 of array
        3 => X"00000020",  -- Element 3 of array (32 in decimal)
        4 => X"0000000C",  -- Element 4 of array (12 in decimal)
        5 => X"0000003C",  -- Element 5 of array (60 in decimal)
        6 => X"00000006",  -- 'n' (number of elements in array, 6)
        7 => X"00000000",  -- 'firstmax' initial value (0)
        8 => X"00000000",  -- 'secmax' initial value (0)
        9 => X"000003E8",  -- 'firstmin' initial value (1000 in decimal, written in hex)
        10 => X"000003E8", -- 'secmin' initial value (1000 in decimal, written in hex)
        11 => X"00000000", -- 'sum' initial value (0)
        12 => X"00000000", -- 'cnt' initial value (0)
        others => X"00000000"
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then 
                ram(conv_integer(addr)) <= di;  -- Write data into RAM
                do <= di;                        -- Output the data written
            else
                do <= ram(conv_integer(addr));  -- Read data from RAM
            end if;
        end if;
    end process;          

end Behavioral;
