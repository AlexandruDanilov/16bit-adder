library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ripple_adder_16bit is
    Port (
        input_a   : in  STD_LOGIC_VECTOR(15 downto 0);
        input_b   : in  STD_LOGIC_VECTOR(15 downto 0);
        carry_in  : in  STD_LOGIC;
        sum_out   : out STD_LOGIC_VECTOR(15 downto 0);
        carry_out : out STD_LOGIC
    );
end entity ripple_adder_16bit;

architecture Structural of ripple_adder_16bit is
    signal bit_propagate : STD_LOGIC_VECTOR(15 downto 0);
    signal bit_generate : STD_LOGIC_VECTOR(15 downto 0);
    signal carry_chain : STD_LOGIC_VECTOR(16 downto 0);
begin
    carry_chain(0) <= carry_in;

    gen_adder: for bit_index in 0 to 15 generate
        bit_adder: entity work.one_bit_full_adder
            port map(
                input_a       => input_a(bit_index),
                input_b       => input_b(bit_index),
                carry_in      => carry_chain(bit_index),
                sum_out       => sum_out(bit_index),
                propagate_out => bit_propagate(bit_index),
                generate_out  => bit_generate(bit_index)
            );
        carry_chain(bit_index + 1) <= bit_generate(bit_index) or (bit_propagate(bit_index) and carry_chain(bit_index));
    end generate gen_adder;

    carry_out <= carry_chain(16);
end architecture Structural;
