----------------------------------------------------------------------------------
-- Company: UPB
-- Engineer: Dani
-- 
-- Create Date: 11/12/2025 04:07:06 PM
-- Design Name: 
-- Module Name: full_adder_1bit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_1bit is
    Port (
        a   : in  STD_LOGIC;
        b   : in  STD_LOGIC;
        cin : in  STD_LOGIC;
        s   : out STD_LOGIC;
        p   : out STD_LOGIC;
        g   : out STD_LOGIC
    );
end entity full_adder_1bit;

architecture Behavioral of full_adder_1bit is
begin
    s <= (a xor b) xor cin;
    p <= a xor b;
    g <= a and b;
end architecture Behavioral;
