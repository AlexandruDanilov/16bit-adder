library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_16bit is
    Port (
        A    : in  STD_LOGIC_VECTOR(15 downto 0);
        B    : in  STD_LOGIC_VECTOR(15 downto 0);
        Cin  : in  STD_LOGIC;
        Sum  : out STD_LOGIC_VECTOR(15 downto 0);
        Cout : out STD_LOGIC
    );
end entity full_adder_16bit;

architecture Structural of full_adder_16bit is
    signal p, g : STD_LOGIC_VECTOR(15 downto 0);
    signal c    : STD_LOGIC_VECTOR(16 downto 0);
begin
    c(0) <= Cin;

    gen_adder: for i in 0 to 15 generate
        FA: entity work.full_adder_1bit
            port map(
                a   => A(i),
                b   => B(i),
                cin => c(i),
                s   => Sum(i),
                p   => p(i),
                g   => g(i)
            );
        c(i+1) <= g(i) or (p(i) and c(i)); -- ripple carry
    end generate gen_adder;

    Cout <= c(16); -- carry final
end architecture Structural;
