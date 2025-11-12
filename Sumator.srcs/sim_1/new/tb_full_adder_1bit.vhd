library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_full_adder_1bit is
-- testbench nu are porturi
end tb_full_adder_1bit;

architecture sim of tb_full_adder_1bit is
    -- semnale pentru conectarea la sumator
    signal a, b, cin : std_logic := '0';
    signal s, p, g   : std_logic;
begin
    -- instanțiere sumator
    uut: entity work.full_adder_1bit
        port map (
            a   => a,
            b   => b,
            cin => cin,
            s   => s,
            p   => p,
            g   => g
        );

    -- proces de test manual
    stim_proc: process
    begin
        -- combinație 0+0+0
        a <= '0'; b <= '0'; cin <= '0';
        wait for 10 ns;

        -- combinație 0+0+1
        a <= '0'; b <= '0'; cin <= '1';
        wait for 10 ns;

        -- combinație 0+1+0
        a <= '0'; b <= '1'; cin <= '0';
        wait for 10 ns;

        -- combinație 0+1+1
        a <= '0'; b <= '1'; cin <= '1';
        wait for 10 ns;

        -- combinație 1+0+0
        a <= '1'; b <= '0'; cin <= '0';
        wait for 10 ns;

        -- combinație 1+0+1
        a <= '1'; b <= '0'; cin <= '1';
        wait for 10 ns;

        -- combinație 1+1+0
        a <= '1'; b <= '1'; cin <= '0';
        wait for 10 ns;

        -- combinație 1+1+1
        a <= '1'; b <= '1'; cin <= '1';
        wait for 10 ns;

        wait; -- oprește simularea după ultimele teste
    end process;
end architecture sim;
