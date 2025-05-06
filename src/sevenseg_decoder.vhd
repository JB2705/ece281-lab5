----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2025 10:30:48 AM
-- Design Name: 
-- Module Name: sevenseg_decoder - Behavioral
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

entity sevenseg_decoder is
    Port ( i_Hex : in STD_LOGIC_VECTOR (3 downto 0);
           o_seg_n : out STD_LOGIC_VECTOR (6 downto 0));
end sevenseg_decoder;

architecture Behavioral of sevenseg_decoder is

begin
--lay out all the rows from truth table, output when input
with i_Hex select
o_seg_n <=  "1000000" when "0000",
            --1
            "1111001" when "0001",
            --2
            "0100100" when "0010",
            --3
            "0110000" when "0011",
            --4
            "0011001" when "0100",
            --5
            "0010010" when "0101",
            --6
            "0000010" when "0110",
            --7
            "1111000" when "0111",
            --8
            "0000000" when "1000",
            --9
            "0011000" when "1001",
            --A
            "0001000" when "1010",
            --B
            "0000011" when "1011",
            --C
            "0100111" when "1100",
            --D
            "0100001" when "1101",
            --E
            "0000110" when "1110",
            --F
            "0001110" when "1111",
            
            --turn display off when else
            "1111111" when others;

end Behavioral;
