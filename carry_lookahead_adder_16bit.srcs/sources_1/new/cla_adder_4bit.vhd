library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla_adder_4bit is
    Port (
        input_a        : in STD_LOGIC_VECTOR(3 downto 0);
        input_b        : in STD_LOGIC_VECTOR(3 downto 0);
        carry_in       : in STD_LOGIC;

        sum_out        : out STD_LOGIC_VECTOR(3 downto 0);
        carry_out      : out STD_LOGIC;
        group_propagate : out STD_LOGIC;
        group_generate  : out STD_LOGIC
    );
end entity cla_adder_4bit;

architecture Structural of cla_adder_4bit is
    signal bit_propagate : STD_LOGIC_VECTOR(3 downto 0);
    signal bit_generate : STD_LOGIC_VECTOR(3 downto 0);
    signal carry_outs : STD_LOGIC_VECTOR(3 downto 0);
    signal carry_in_bits : STD_LOGIC_VECTOR(3 downto 0);

    component one_bit_full_adder is
        Port ( input_a, input_b, carry_in : in STD_LOGIC; sum_out, propagate_out, generate_out : out STD_LOGIC );
    end component;
    
    component carry_lookahead_unit_4bit is
        Port ( propagate_in, generate_in : in STD_LOGIC_VECTOR(3 downto 0);
               carry_in : in STD_LOGIC;
               carry_outs : out STD_LOGIC_VECTOR(3 downto 0);
               group_propagate, group_generate : out STD_LOGIC );
    end component;

begin
    lookahead_unit: carry_lookahead_unit_4bit
        port map (
            propagate_in   => bit_propagate,
            generate_in    => bit_generate,
            carry_in       => carry_in,
            carry_outs     => carry_outs,
            group_propagate => group_propagate,
            group_generate  => group_generate
        );
    
    
    carry_in_bits(0) <= carry_in;
    carry_in_bits(3 downto 1) <= carry_outs(2 downto 0);
    carry_out <= carry_outs(3);

    gen_adders: for bit_index in 0 to 3 generate
        FA_inst: one_bit_full_adder
            port map (
                input_a       => input_a(bit_index),
                input_b       => input_b(bit_index),
                carry_in      => carry_in_bits(bit_index),
                sum_out       => sum_out(bit_index),
                propagate_out => bit_propagate(bit_index),
                generate_out  => bit_generate(bit_index)
            );
    end generate gen_adders;

end architecture Structural;