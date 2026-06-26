-- One-bit full adder used by the ripple-carry design.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity one_bit_full_adder is
    Port (
        input_a       : in  STD_LOGIC;
        input_b       : in  STD_LOGIC;
        carry_in      : in  STD_LOGIC;
        sum_out       : out STD_LOGIC;
        propagate_out : out STD_LOGIC;
        generate_out  : out STD_LOGIC
    );
end entity one_bit_full_adder;

architecture Behavioral of one_bit_full_adder is
begin
    sum_out <= (input_a xor input_b) xor carry_in;
    propagate_out <= input_a xor input_b;
    generate_out <= input_a and input_b;
end architecture Behavioral;
