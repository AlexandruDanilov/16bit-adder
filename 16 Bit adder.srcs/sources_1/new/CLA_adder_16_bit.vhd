library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLA_adder_16bit is
    Port (
        A    : in  STD_LOGIC_VECTOR(15 downto 0);
        B    : in  STD_LOGIC_VECTOR(15 downto 0);
        Cin  : in  STD_LOGIC;
        Sum  : out STD_LOGIC_VECTOR(15 downto 0);
        Cout : out STD_LOGIC
    );
end entity CLA_adder_16bit;

architecture Structural of CLA_adder_16bit is
    -- Semnale de Grup P si G de la cele 4 blocuri de 4 biti
    signal P_group : STD_LOGIC_VECTOR(3 downto 0); 
    signal G_group : STD_LOGIC_VECTOR(3 downto 0); 
    
    -- Transporturile generate de CLU-ul de nivel superior (C1, C2, C3, C4)
    -- C_group_internal(0)=C4, C_group_internal(1)=C8, C_group_internal(2)=C12, C_group_internal(3)=C16
    signal C_group_internal : STD_LOGIC_VECTOR(3 downto 0); 
    
    -- Transportul de intrare in fiecare grup (C0, C1, C2, C3)
    signal C_group_in : STD_LOGIC_VECTOR(3 downto 0); 
    
    -- !!! DECLARATIILE DE COMPONENTE SUNT CRITICE !!!
    component Adder_4bit is
        Port ( A_in, B_in : in STD_LOGIC_VECTOR(3 downto 0);
               Cin : in STD_LOGIC;
               Sum_out : out STD_LOGIC_VECTOR(3 downto 0);
               Cout : out STD_LOGIC; -- Neutilizat la acest nivel, dar portul trebuie conectat
               P_out : out STD_LOGIC;
               G_out : out STD_LOGIC );
    end component;
    
    component CLA_Unit_4bit is
        Port ( p_in, g_in : in STD_LOGIC_VECTOR(3 downto 0); 
               Cin  : in STD_LOGIC;                    
               c_out : out STD_LOGIC_VECTOR(3 downto 0); 
               P_out, G_out : out STD_LOGIC );                     
    end component;
    
begin
    -- 1. Configurarea transporturilor de intrare in grupuri (C0, C4, C8, C12)
    
    -- C0 (Cin) intra in grupul 0
    C_group_in(0) <= Cin;

    -- Conectarea transporturilor C1, C2, C3 (C4, C8, C12) generate de CLU-ul de top
    C_group_in(3 downto 1) <= C_group_internal(2 downto 0);

    -- Cout-ul final este C4 (C16)
    Cout <= C_group_internal(3);

    -- 2. Unitatea de Anticipare a Transportului de nivel superior (CLL Logic)
    CLA_Top: CLA_Unit_4bit
        port map (
            p_in  => P_group, -- P de grup (P3, P2, P1, P0)
            g_in  => G_group, -- G de grup (G3, G2, G1, G0)
            Cin   => Cin,     
            c_out => C_group_internal, -- C4, C8, C12, C16
            P_out => open,    -- P/G de nivel superior nu sunt necesare
            G_out => open
        );
        
    -- 3. Generarea celor 4 blocuri de Sumatoare pe 4 biți
    gen_4bit_blocks: for i in 0 to 3 generate
        
        Adder4: Adder_4bit
            port map (
                A_in  => A(i*4+3 downto i*4),
                B_in  => B(i*4+3 downto i*4),
                Cin   => C_group_in(i), -- C0, C4, C8, C12
                Sum_out => Sum(i*4+3 downto i*4),
                Cout    => open,        -- Cout-ul individual de 4 biți este ignorat
                P_out   => P_group(i),  -- P de grup trimis la CLU-ul de top
                G_out   => G_group(i)   -- G de grup trimis la CLU-ul de top
            );
    end generate gen_4bit_blocks;

end architecture Structural;