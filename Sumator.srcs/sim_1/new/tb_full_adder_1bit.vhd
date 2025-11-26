library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_full_adder_16bit is
end tb_full_adder_16bit;

architecture Behavioral of tb_full_adder_16bit is
    signal A, B : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Cin  : STD_LOGIC := '0';
    signal Sum  : STD_LOGIC_VECTOR(15 downto 0);
    signal Cout : STD_LOGIC;
    
    constant PERIOD : time := 20 ns;
    
begin
    DUT: entity work.full_adder_16bit
        port map (
            A => A,
            B => B,
            Cin => Cin,
            Sum => Sum,
            Cout => Cout
        );
    
    stimulus: process
    begin
        report "Starting 16-bit adder simulation..." severity note;
        
        -- Test 1: 1 + 2
        A <= x"0001"; B <= x"0002"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"0003" and Cout = '0'
        report "Test 1 failed: 1 + 2 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout)
        severity error;
        report "Test 1 passed: 1 + 2 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout) severity note;
        
        -- Test 2: 1 + 1 + Cin=1
        A <= x"0001"; B <= x"0001"; Cin <= '1';
        wait for PERIOD;
        assert Sum = x"0003" and Cout = '0'
        report "Test 2 failed: 1 + 1 + 1 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout)
        severity error;
        report "Test 2 passed: 1 + 1 + 1 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout) severity note;

        -- Test 3: 0 + 0
        A <= x"0000"; B <= x"0000"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"0000" and Cout = '0'
        report "Test 3 failed: 0 + 0 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout)
        severity error;
        report "Test 3 passed: 0 + 0 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout) severity note;

        -- Test 4: Overflow 0xFFFF + 1
        A <= x"FFFF"; B <= x"0001"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"0000" and Cout = '1'
        report "Test 4 failed: FFFF + 1 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout)
        severity error;
        report "Test 4 passed: FFFF + 1 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout) severity note;

        -- Test 5: FFFF + 0 + Cin=1
        A <= x"FFFF"; B <= x"0000"; Cin <= '1';
        wait for PERIOD;
        assert Sum = x"0000" and Cout = '1'
        report "Test 5 failed: FFFF + 0 + 1 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout)
        severity error;
        report "Test 5 passed: FFFF + 0 + 1 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout) severity note;

        -- Test 6: 0x1234 + 0x5678
        A <= x"1234"; B <= x"5678"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"68AC" and Cout = '0'
        report "Test 6 failed: 1234 + 5678 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout)
        severity error;
        report "Test 6 passed: 1234 + 5678 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout) severity note;

        -- Test 7: FFFF + FFFF
        A <= x"FFFF"; B <= x"FFFF"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"FFFE" and Cout = '1'
        report "Test 7 failed: FFFF + FFFF = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout)
        severity error;
        report "Test 7 passed: FFFF + FFFF = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout) severity note;

        -- Test 8: AAAA + 5555
        A <= x"AAAA"; B <= x"5555"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"FFFF" and Cout = '0'
        report "Test 8 failed: AAAA + 5555 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout)
        severity error;
        report "Test 8 passed: AAAA + 5555 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout) severity note;

        -- Test 9: 7FFF + 1
        A <= x"7FFF"; B <= x"0001"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"8000" and Cout = '0'
        report "Test 9 failed: 7FFF + 1 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout)
        severity error;
        report "Test 9 passed: 7FFF + 1 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout) severity note;

        -- Test 10: ABCD + 1234 + Cin=1
        A <= x"ABCD"; B <= x"1234"; Cin <= '1';
        wait for PERIOD;
        assert Sum = x"BE02" and Cout = '0'
        report "Test 10 failed: ABCD + 1234 + 1 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout)
        severity error;
        report "Test 10 passed: ABCD + 1234 + 1 = " & integer'image(to_integer(unsigned(Sum)))
               & ", Cout=" & std_logic'image(Cout) severity note;

        report "All 16-bit adder tests completed!" severity note;
        wait;
    end process;
end Behavioral;
