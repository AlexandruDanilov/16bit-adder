library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLA_Unit_4bit is
    Port (
        p_in : in STD_LOGIC_VECTOR(3 downto 0); 
        g_in : in STD_LOGIC_VECTOR(3 downto 0); 
        Cin  : in STD_LOGIC;                    
        
        c_out : out STD_LOGIC_VECTOR(3 downto 0); 
        P_out : out STD_LOGIC;                    
        G_out : out STD_LOGIC                     
    );
end entity CLA_Unit_4bit;

architecture Behavioral of CLA_Unit_4bit is 
    signal c : STD_LOGIC_VECTOR(4 downto 0); 
begin
    c(0) <= Cin; -- c0

    c(1) <= g_in(0) or (p_in(0) and c(0)); -- c1
    c(2) <= g_in(1) or (p_in(1) and c(1)); -- c2
    c(3) <= g_in(2) or (p_in(2) and c(2)); -- c3
    c(4) <= g_in(3) or (p_in(3) and c(3)); -- c4

    c_out(0) <= c(1);
    c_out(1) <= c(2);
    c_out(2) <= c(3);
    c_out(3) <= c(4); 

    P_out <= p_in(3) and p_in(2) and p_in(1) and p_in(0);

    G_out <= g_in(3) or 
             (p_in(3) and g_in(2)) or
             (p_in(3) and p_in(2) and g_in(1)) or
             (p_in(3) and p_in(2) and p_in(1) and g_in(0));
             
end architecture Behavioral;