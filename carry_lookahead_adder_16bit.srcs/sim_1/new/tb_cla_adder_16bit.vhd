library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_cla_adder_16bit is
end tb_cla_adder_16bit;

architecture Behavioral of tb_cla_adder_16bit is
    signal input_a : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal input_b : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal carry_in : STD_LOGIC := '0';
    signal sum_out : STD_LOGIC_VECTOR(15 downto 0);
    signal carry_out : STD_LOGIC;
    
    constant PERIOD : time := 20 ns;
    
begin
    dut: entity work.cla_adder_16bit
        port map (
            input_a => input_a,
            input_b => input_b,
            carry_in => carry_in,
            sum_out => sum_out,
            carry_out => carry_out
        );
    
    stimulus: process
    begin
        report "Starting 16-bit carry-lookahead adder simulation..." severity note;
        
        -- Test 1: 1 + 2 = 3
        input_a <= x"0001"; input_b <= x"0002"; carry_in <= '0';
        wait for PERIOD;
        assert sum_out = x"0003" and carry_out = '0'
        report "Test 1 failed: 1 + 2 produced sum " & integer'image(to_integer(unsigned(sum_out))) severity error;
        report "Test 1 passed: 1 + 2 = 3" severity note;
        
        -- Test 2: 1 + 1 + Cin=1 = 3
        input_a <= x"0001"; input_b <= x"0001"; carry_in <= '1';
        wait for PERIOD;
        assert sum_out = x"0003" and carry_out = '0'
        report "Test 2 failed: 1 + 1 + 1 produced sum " & integer'image(to_integer(unsigned(sum_out))) severity error;
        report "Test 2 passed: 1 + 1 + 1 = 3" severity note;

        -- Test 3: 0 + 0 = 0
        input_a <= x"0000"; input_b <= x"0000"; carry_in <= '0';
        wait for PERIOD;
        assert sum_out = x"0000" and carry_out = '0'
        report "Test 3 failed: 0 + 0 produced sum " & integer'image(to_integer(unsigned(sum_out))) severity error;
        report "Test 3 passed: 0 + 0 = 0" severity note;

        -- Test 4: Overflow 0xFFFF + 1 = 0 (Cout=1)
        input_a <= x"FFFF"; input_b <= x"0001"; carry_in <= '0';
        wait for PERIOD;
        assert sum_out = x"0000" and carry_out = '1'
        report "Test 4 failed: FFFF + 1 produced carry " & std_logic'image(carry_out) severity error;
        report "Test 4 passed: FFFF + 1 (Overflow)" severity note;

        -- Test 5: FFFF + 0 + Cin=1 = 0 (Cout=1)
        input_a <= x"FFFF"; input_b <= x"0000"; carry_in <= '1';
        wait for PERIOD;
        assert sum_out = x"0000" and carry_out = '1'
        report "Test 5 failed: FFFF + 0 + 1 produced carry " & std_logic'image(carry_out) severity error;
        report "Test 5 passed: FFFF + 0 + 1 (Overflow)" severity note;

        -- Test 6: 0x1234 + 0x5678 = 0x68AC (Propagare transport in grupuri)
        input_a <= x"1234"; input_b <= x"5678"; carry_in <= '0';
        wait for PERIOD;
        assert sum_out = x"68AC" and carry_out = '0'
        report "Test 6 failed: 1234 + 5678 produced sum " & integer'image(to_integer(unsigned(sum_out))) severity error;
        report "Test 6 passed: 1234 + 5678" severity note;

        -- Test 7: FFFF + FFFF = FFFE (Cout=1)
        input_a <= x"FFFF"; input_b <= x"FFFF"; carry_in <= '0';
        wait for PERIOD;
        assert sum_out = x"FFFE" and carry_out = '1'
        report "Test 7 failed: FFFF + FFFF produced sum " & integer'image(to_integer(unsigned(sum_out))) severity error;
        report "Test 7 passed: FFFF + FFFF" severity note;

        -- Test 8: AAAA + 5555 = FFFF (fara transport)
        input_a <= x"AAAA"; input_b <= x"5555"; carry_in <= '0';
        wait for PERIOD;
        assert sum_out = x"FFFF" and carry_out = '0'
        report "Test 8 failed: AAAA + 5555 produced sum " & integer'image(to_integer(unsigned(sum_out))) severity error;
        report "Test 8 passed: AAAA + 5555" severity note;

        -- Test 9: 7FFF + 1 = 8000 (test de bit cel mai semnificativ)
        input_a <= x"7FFF"; input_b <= x"0001"; carry_in <= '0';
        wait for PERIOD;
        assert sum_out = x"8000" and carry_out = '0'
        report "Test 9 failed: 7FFF + 1 produced sum " & integer'image(to_integer(unsigned(sum_out))) severity error;
        report "Test 9 passed: 7FFF + 1" severity note;
        
        -- Test 10: 1 + 0 + Cin=1 (cel mai mic test)
        input_a <= x"0000"; input_b <= x"0001"; carry_in <= '1';
        wait for PERIOD;
        assert sum_out = x"0002" and carry_out = '0'
        report "Test 10 failed: 0 + 1 + 1 produced sum " & integer'image(to_integer(unsigned(sum_out))) severity error;
        report "Test 10 passed: 0 + 1 + 1" severity note;


        report "All 16-bit carry-lookahead adder tests completed!" severity note;
        wait;
    end process;
end architecture Behavioral;