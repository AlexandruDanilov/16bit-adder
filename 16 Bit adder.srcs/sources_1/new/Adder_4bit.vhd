library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder_4bit is
    Port (
        A_in : in STD_LOGIC_VECTOR(3 downto 0);
        B_in : in STD_LOGIC_VECTOR(3 downto 0);
        Cin  : in STD_LOGIC;
        
        Sum_out : out STD_LOGIC_VECTOR(3 downto 0);
        Cout    : out STD_LOGIC;     -- Transportul de iesire din grup (C4)
        P_out   : out STD_LOGIC;     -- Group Propagate
        G_out   : out STD_LOGIC      -- Group Generate
    );
end entity Adder_4bit;

architecture Structural of Adder_4bit is
    signal p, g : STD_LOGIC_VECTOR(3 downto 0); 
    signal c_alu_out : STD_LOGIC_VECTOR(3 downto 0); 
    signal c_fa_in : STD_LOGIC_VECTOR(3 downto 0); 

    component full_adder_1bit is
        Port ( a, b, cin : in STD_LOGIC; s, p, g : out STD_LOGIC );
    end component;
    
    component CLA_Unit_4bit is
        Port ( p_in, g_in : in STD_LOGIC_VECTOR(3 downto 0); 
               Cin  : in STD_LOGIC;                    
               c_out : out STD_LOGIC_VECTOR(3 downto 0); 
               P_out, G_out : out STD_LOGIC );                     
    end component;

begin
    CLU_inst: CLA_Unit_4bit
        port map (
            p_in  => p,     -- P/G de la FA(0-3)
            g_in  => g,
            Cin   => Cin,   -- Transportul de intrare in grup (C0)
            c_out => c_alu_out, -- Transporturile generate (C1, C2, C3, C4)
            P_out => P_out, -- P de grup
            G_out => G_out  -- G de grup
        );
    
    
    c_fa_in(0) <= Cin;
    
    c_fa_in(3 downto 1) <= c_alu_out(2 downto 0); 
    
    Cout <= c_alu_out(3);

    gen_adders: for i in 0 to 3 generate
        FA_inst: full_adder_1bit
            port map (
                a   => A_in(i),
                b   => B_in(i),
                cin => c_fa_in(i), -- Transportul de intrare corect (c0, c1, c2, c3)
                s   => Sum_out(i),
                p   => p(i), 
                g   => g(i)  
            );
    end generate gen_adders;

end architecture Structural;