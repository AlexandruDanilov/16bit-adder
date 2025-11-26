library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_full_adder_16bit is
end tb_full_adder_16bit;

architecture sim of tb_full_adder_16bit is

    signal A, B  : STD_LOGIC_VECTOR(15 downto 0);
    signal Sum   : STD_LOGIC_VECTOR(15 downto 0);
    signal Cin   : STD_LOGIC := '0';
    signal Cout  : STD_LOGIC;

    signal Expected : unsigned(16 downto 0);

begin

    -- instanțierea UUT (unit under test)
    UUT: entity work.full_adder_16bit
        port map (
            A    => A,
            B    => B,
            Cin  => Cin,
            Sum  => Sum,
            Cout => Cout
        );

    -- proces de testare
    stim_proc: process
    begin

        -- Test 1
        A <= x"AAAA"; B <= x"5555"; Cin <= '0';
        wait for 10 ns;
        Expected <= unsigned(A) + unsigned(B);
        report "Test 1 = " &
               (if (unsigned(Sum)=Expected(15 downto 0) and Cout=Expected(16))
                then "PASS" else "FAIL" end if);

        -- Test 2
        A <= x"FFFF"; B <= x"0001"; Cin <= '0';
        wait for 10 ns;
        Expected <= unsigned(A) + unsigned(B);
        report "Test 2 = " &
               (if (unsigned(Sum)=Expected(15 downto 0) and Cout=Expected(16))
                then "PASS" else "FAIL" end if);

        -- Test 3
        A <= x"7FFF"; B <= x"0001"; Cin <= '1';
        wait for 10 ns;
        Expected <= unsigned(A) + unsigned(B) + 1;
        report "Test 3 = " &
               (if (unsigned(Sum)=Expected(15 downto 0) and Cout=Expected(16))
                then "PASS" else "FAIL" end if);

        -- Test 4
        A <= "1010001111001101"; B <= "0011001100110011"; Cin <= '1';
        wait for 10 ns;
        Expected <= unsigned(A) + unsigned(B) + 1;
        report "Test 4 = " &
               (if (unsigned(Sum)=Expected(15 downto 0) and Cout=Expected(16))
                then "PASS" else "FAIL" end if);

        -- Test 5
        A <= x"FFFF"; B <= x"FFFF"; Cin <= '1';
        wait for 10 ns;
        Expected <= unsigned(A) + unsigned(B) + 1;
        report "Test 5 = " &
               (if (unsigned(Sum)=Expected(15 downto 0) and Cout=Expected(16))
                then "PASS" else "FAIL" end if);

        wait;
    end process;

end sim;
