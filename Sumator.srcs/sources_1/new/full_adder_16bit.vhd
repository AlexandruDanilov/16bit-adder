----------------------------------------------------------------------------------
-- Company: ACS UPB
-- Engineer: Dani, Patrick, Teodora 
-- 
-- Create Date: 11/23/2025 07:47:02 PM
-- Design Name: 16-bit Full Adder
-- Module Name: full_adder_16bit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity full_adder_16bit is
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           Cin : in STD_LOGIC;
           Sum : out STD_LOGIC_VECTOR (15 downto 0);
           Cout : out STD_LOGIC);
end full_adder_16bit;

architecture Behavioral of full_adder_16bit is

    component full_adder_1bit is
        Port (
            a   : in  STD_LOGIC;
            b   : in  STD_LOGIC;
            cin : in  STD_LOGIC;
            s   : out STD_LOGIC;
            p   : out STD_LOGIC;
            g   : out STD_LOGIC
        );
    end component;

    signal carry : STD_LOGIC_VECTOR (16 downto 0);
    signal p_internal : STD_LOGIC_VECTOR (15 downto 0);
    signal g_internal : STD_LOGIC_VECTOR (15 downto 0);
begin

    carry(0) <= Cin;

    gen_adder: for i in 0 to 15 generate
        
        adder_inst: full_adder_1bit
        port map (
            a   => A(i),
            b   => B(i),
            cin => carry(i),      -- Take carry from previous stage
            s   => Sum(i),        -- Output sum to the final vector
            p   => p_internal(i), 
            g   => g_internal(i)
        );

        carry(i+1) <= g_internal(i) or (p_internal(i) and carry(i));
        
    end generate gen_adder;

    Cout <= carry(16);

end Behavioral;
