----------------------------------------------------------------------------------
-- Company: UPB
-- Engineer: Dani
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_1bit is
    Port ( 
        a   : in  STD_LOGIC;
        b   : in  STD_LOGIC;
        cin : in  STD_LOGIC;
        s   : out STD_LOGIC;
        p   : out STD_LOGIC;
        g   : out STD_LOGIC
    );
end entity full_adder_1bit;

architecture Behavioral of full_adder_1bit is
    
    signal p_internal : STD_LOGIC; 

begin
    p_internal <= a xor b;
    g <= a and b;
    
    p <= p_internal;
    
    s <= p_internal xor cin;
    
end architecture Behavioral;