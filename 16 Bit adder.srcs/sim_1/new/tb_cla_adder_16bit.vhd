library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Necesara pentru to_integer si unsigned

entity tb_cla_adder_16bit is
end tb_cla_adder_16bit;

architecture Behavioral of tb_cla_adder_16bit is
    -- Declararea porturilor DUT-ului (Device Under Test)
    signal A, B : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Cin  : STD_LOGIC := '0';
    signal Sum  : STD_LOGIC_VECTOR(15 downto 0);
    signal Cout : STD_LOGIC;
    
    constant PERIOD : time := 20 ns;
    
begin
    -- Instantierea Sumatorului CLA pe 16 biți (DUT)
    DUT: entity work.CLA_adder_16bit 
        port map (
            A => A,
            B => B,
            Cin => Cin,
            Sum => Sum,
            Cout => Cout
        );
    
    stimulus: process
    begin
        report "Starting 16-bit CLA adder simulation..." severity note;
        
        -- Test 1: 1 + 2 = 3
        A <= x"0001"; B <= x"0002"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"0003" and Cout = '0'
        report "Test 1 failed: 1 + 2 resulted in Sum=" & integer'image(to_integer(unsigned(Sum))) severity error;
        report "Test 1 passed: 1 + 2 = 3" severity note;
        
        -- Test 2: 1 + 1 + Cin=1 = 3
        A <= x"0001"; B <= x"0001"; Cin <= '1';
        wait for PERIOD;
        assert Sum = x"0003" and Cout = '0'
        report "Test 2 failed: 1 + 1 + 1 resulted in Sum=" & integer'image(to_integer(unsigned(Sum))) severity error;
        report "Test 2 passed: 1 + 1 + 1 = 3" severity note;

        -- Test 3: 0 + 0 = 0
        A <= x"0000"; B <= x"0000"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"0000" and Cout = '0'
        report "Test 3 failed: 0 + 0 resulted in Sum=" & integer'image(to_integer(unsigned(Sum))) severity error;
        report "Test 3 passed: 0 + 0 = 0" severity note;

        -- Test 4: Overflow 0xFFFF + 1 = 0 (Cout=1)
        A <= x"FFFF"; B <= x"0001"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"0000" and Cout = '1'
        report "Test 4 failed: FFFF + 1 (Overflow) resulted in Cout=" & std_logic'image(Cout) severity error;
        report "Test 4 passed: FFFF + 1 (Overflow)" severity note;

        -- Test 5: FFFF + 0 + Cin=1 = 0 (Cout=1)
        A <= x"FFFF"; B <= x"0000"; Cin <= '1';
        wait for PERIOD;
        assert Sum = x"0000" and Cout = '1'
        report "Test 5 failed: FFFF + 0 + 1 (Overflow) resulted in Cout=" & std_logic'image(Cout) severity error;
        report "Test 5 passed: FFFF + 0 + 1 (Overflow)" severity note;

        -- Test 6: 0x1234 + 0x5678 = 0x68AC (Propagare transport in grupuri)
        A <= x"1234"; B <= x"5678"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"68AC" and Cout = '0'
        report "Test 6 failed: 1234 + 5678 resulted in Sum=" & integer'image(to_integer(unsigned(Sum))) severity error;
        report "Test 6 passed: 1234 + 5678" severity note;

        -- Test 7: FFFF + FFFF = FFFE (Cout=1)
        A <= x"FFFF"; B <= x"FFFF"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"FFFE" and Cout = '1'
        report "Test 7 failed: FFFF + FFFF resulted in Sum=" & integer'image(to_integer(unsigned(Sum))) severity error;
        report "Test 7 passed: FFFF + FFFF" severity note;

        -- Test 8: AAAA + 5555 = FFFF (fara transport)
        A <= x"AAAA"; B <= x"5555"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"FFFF" and Cout = '0'
        report "Test 8 failed: AAAA + 5555 resulted in Sum=" & integer'image(to_integer(unsigned(Sum))) severity error;
        report "Test 8 passed: AAAA + 5555" severity note;

        -- Test 9: 7FFF + 1 = 8000 (test de bit cel mai semnificativ)
        A <= x"7FFF"; B <= x"0001"; Cin <= '0';
        wait for PERIOD;
        assert Sum = x"8000" and Cout = '0'
        report "Test 9 failed: 7FFF + 1 resulted in Sum=" & integer'image(to_integer(unsigned(Sum))) severity error;
        report "Test 9 passed: 7FFF + 1" severity note;
        
        -- Test 10: 1 + 0 + Cin=1 (cel mai mic test)
        A <= x"0000"; B <= x"0001"; Cin <= '1';
        wait for PERIOD;
        assert Sum = x"0002" and Cout = '0'
        report "Test 10 failed: 0 + 1 + 1 resulted in Sum=" & integer'image(to_integer(unsigned(Sum))) severity error;
        report "Test 10 passed: 0 + 1 + 1" severity note;


        report "All 16-bit CLA adder tests completed!" severity note;
        wait;
    end process;
end architecture Behavioral;