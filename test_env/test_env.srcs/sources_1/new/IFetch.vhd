library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IFetch is
    Port ( CLK, reset, enable : in  STD_LOGIC;
           MPG : in STD_LOGIC_VECTOR (1 downto 0);
           Jump, PCSrc, JmpR : in STD_LOGIC;
           Jump_Address, Branch_Address, JR_Address : in STD_LOGIC_VECTOR (31 downto 0);
           instruction : out STD_LOGIC_VECTOR (31 downto 0);
           PC_Plus_4 : out STD_LOGIC_VECTOR (31 downto 0));
end IFetch;

architecture Behavioral of IFetch is
    signal PC : STD_LOGIC_VECTOR (31 downto 0);
    signal Jump_Address_Reg : STD_LOGIC_VECTOR (31 downto 0);
    signal Branch_Address_Reg : STD_LOGIC_VECTOR (31 downto 0);
    signal JR_Address_Reg : STD_LOGIC_VECTOR (31 downto 0);
    signal Next_PC : STD_LOGIC_VECTOR (31 downto 0);
    signal Address : STD_LOGIC_VECTOR (4 downto 0);
    signal Instr : STD_LOGIC_VECTOR (31 downto 0);
begin
    -- Proces pentru registrul PC cu înc?rcare pe frontul ascendent
    process (CLK, reset)
    begin
        if reset = '1' then
            PC <= (others => '0'); -- Resetare PC
        elsif rising_edge(CLK) then
            if enable = '1' then -- Verific?m dac? activarea este permis?
                if Jump = '1' then
                    PC <= Jump_Address_Reg; -- Jump
                else
                    if PCSrc = '1' then
                        PC <= Branch_Address_Reg; -- Branch
                    else
                        if JmpR = '1' then
                            PC <= JR_Address_Reg; -- JR
                        else
                            PC <= Next_PC; -- PC+4
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Multiplexor pentru selectarea urm?toarei adrese a PC-ului
    process (PC, Jump_Address, Branch_Address, JR_Address)
    begin
        if Jump = '1' then
            Next_PC <= Jump_Address;
        elsif PCSrc = '1' then
            Next_PC <= Branch_Address;
        elsif JmpR = '1' then
            Next_PC <= JR_Address;
        else
            Next_PC <= PC + 4;
        end if;
    end process;

    -- Calcularea adresei pentru ROM
    Address <= PC(31 downto 2);

    -- Ie?irea memoriei ROM
    Instr <= ROM(to_integer(unsigned(Address)));

    -- Ie?irile instruc?iunii ?i PC+4
    instruction <= Instr;
    PC_Plus_4 <= PC + 4;

    -- Implementarea registrilor pentru adresele de salt
    process (CLK, reset)
    begin
        if reset = '1' then
            Jump_Address_Reg <= (others => '0');
            Branch_Address_Reg <= (others => '0');
            JR_Address_Reg <= (others => '0');
        elsif rising_edge(CLK) then
            if enable = '1' then
                Jump_Address_Reg <= Jump_Address;
                Branch_Address_Reg <= Branch_Address;
                JR_Address_Reg <= JR_Address;
            end if;
        end if;
    end process;
end Behavioral;
