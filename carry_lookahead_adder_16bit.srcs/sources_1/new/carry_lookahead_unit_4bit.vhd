library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_lookahead_unit_4bit is
    Port (
        propagate_in   : in STD_LOGIC_VECTOR(3 downto 0);
        generate_in    : in STD_LOGIC_VECTOR(3 downto 0);
        carry_in       : in STD_LOGIC;

        carry_outs     : out STD_LOGIC_VECTOR(3 downto 0);
        group_propagate : out STD_LOGIC;
        group_generate  : out STD_LOGIC
    );
end entity carry_lookahead_unit_4bit;

architecture Behavioral of carry_lookahead_unit_4bit is
    signal carry_chain : STD_LOGIC_VECTOR(4 downto 0);
begin
    carry_chain(0) <= carry_in;

    carry_chain(1) <= generate_in(0) or (propagate_in(0) and carry_chain(0));
    carry_chain(2) <= generate_in(1) or (propagate_in(1) and carry_chain(1));
    carry_chain(3) <= generate_in(2) or (propagate_in(2) and carry_chain(2));
    carry_chain(4) <= generate_in(3) or (propagate_in(3) and carry_chain(3));

    carry_outs(0) <= carry_chain(1);
    carry_outs(1) <= carry_chain(2);
    carry_outs(2) <= carry_chain(3);
    carry_outs(3) <= carry_chain(4);

    group_propagate <= propagate_in(3) and propagate_in(2) and propagate_in(1) and propagate_in(0);

    group_generate <= generate_in(3) or
                      (propagate_in(3) and generate_in(2)) or
                      (propagate_in(3) and propagate_in(2) and generate_in(1)) or
                      (propagate_in(3) and propagate_in(2) and propagate_in(1) and generate_in(0));
end architecture Behavioral;