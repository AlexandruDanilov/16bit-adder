library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla_adder_16bit is
    Port (
        input_a   : in  STD_LOGIC_VECTOR(15 downto 0);
        input_b   : in  STD_LOGIC_VECTOR(15 downto 0);
        carry_in  : in  STD_LOGIC;
        sum_out   : out STD_LOGIC_VECTOR(15 downto 0);
        carry_out : out STD_LOGIC
    );
end entity cla_adder_16bit;

architecture Structural of cla_adder_16bit is
    signal group_propagate : STD_LOGIC_VECTOR(3 downto 0);
    signal group_generate   : STD_LOGIC_VECTOR(3 downto 0);
    signal group_carries    : STD_LOGIC_VECTOR(3 downto 0);
    signal group_inputs     : STD_LOGIC_VECTOR(3 downto 0);

    component cla_adder_4bit is
        Port (
            input_a        : in STD_LOGIC_VECTOR(3 downto 0);
            input_b        : in STD_LOGIC_VECTOR(3 downto 0);
            carry_in       : in STD_LOGIC;
            sum_out        : out STD_LOGIC_VECTOR(3 downto 0);
            carry_out      : out STD_LOGIC;
            group_propagate : out STD_LOGIC;
            group_generate  : out STD_LOGIC
        );
    end component;

    component carry_lookahead_unit_4bit is
        Port (
            propagate_in   : in STD_LOGIC_VECTOR(3 downto 0);
            generate_in    : in STD_LOGIC_VECTOR(3 downto 0);
            carry_in       : in STD_LOGIC;
            carry_outs     : out STD_LOGIC_VECTOR(3 downto 0);
            group_propagate : out STD_LOGIC;
            group_generate  : out STD_LOGIC
        );
    end component;

begin
    group_inputs(0) <= carry_in;
    group_inputs(3 downto 1) <= group_carries(2 downto 0);
    carry_out <= group_carries(3);

    top_unit: carry_lookahead_unit_4bit
        port map (
            propagate_in    => group_propagate,
            generate_in     => group_generate,
            carry_in        => carry_in,
            carry_outs      => group_carries,
            group_propagate => open,
            group_generate  => open
        );

    gen_4bit_blocks: for group_index in 0 to 3 generate
        adder_4bit: cla_adder_4bit
            port map (
                input_a        => input_a(group_index * 4 + 3 downto group_index * 4),
                input_b        => input_b(group_index * 4 + 3 downto group_index * 4),
                carry_in       => group_inputs(group_index),
                sum_out        => sum_out(group_index * 4 + 3 downto group_index * 4),
                carry_out      => open,
                group_propagate => group_propagate(group_index),
                group_generate  => group_generate(group_index)
            );
    end generate gen_4bit_blocks;

end architecture Structural;