----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2025 11:16:55 AM
-- Design Name: 
-- Module Name: sevenseg_decoder_tb - Behavioral
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

entity sevenseg_decoder_tb is
end sevenseg_decoder_tb;

architecture test_bench of sevenseg_decoder_tb is

    --declare component
    component sevenseg_decoder is
        Port ( i_Hex : in STD_LOGIC_VECTOR (3 downto 0);
               o_seg_n : out STD_LOGIC_VECTOR (6 downto 0));
    end component sevenseg_decoder;
    
    -- declare signals needed to stimulate the UUT inputs
    signal input     : std_logic_vector(3 downto 0);
    signal output    : std_logic_vector(6 downto 0);
    
begin
    -- PORT MAPS ----------------------------------------
    sevenseg_decoder_uut : sevenseg_decoder port map (
	  i_Hex => input(3 downto 0),
	  o_seg_n => output(6 downto 0)
	);

    -- Implement the test plan here.  Body of process is continuously from time = 0  
	test_process : process 
	begin
	--test all cases
	
	--0
	input <= "0000"; wait for 10 ns;
	   assert (output = "1000000") report "bad with zero" severity failure;
	--1
	input <= "0001"; wait for 10 ns;
	   assert (output = "1111001") report "bad with one" severity failure;
	--2
	input <= "0010"; wait for 10 ns;
	   assert (output = "0100100") report "bad with one" severity failure;
	--3-
	input <= "0011"; wait for 10 ns;
	   assert (output = "0110000") report "bad with one" severity failure;
	--4
	input <= "0100"; wait for 10 ns;
	   assert (output = "0011001") report "bad with one" severity failure;
	--5
	input <= "0101"; wait for 10 ns;
	   assert (output = "0010010") report "bad with one" severity failure;
	--6
	input <= "0110"; wait for 10 ns;
	   assert (output = "0000010") report "bad with one" severity failure;
	--7
	input <= "0111"; wait for 10 ns;
	   assert (output = "1111000") report "bad with one" severity failure;
	--8
	input <= "1000"; wait for 10 ns;
	   assert (output = "0000000") report "bad with one" severity failure;
	--9
	input <= "1001"; wait for 10 ns;
	   assert (output = "0011000") report "bad with one" severity failure;
	--A
	input <= "1010"; wait for 10 ns;
	   assert (output = "0001000") report "bad with one" severity failure;
	--B
	input <= "1011"; wait for 10 ns;
	   assert (output = "0000011") report "bad with one" severity failure;
	--C
	input <= "1100"; wait for 10 ns;
	   assert (output = "0100111") report "bad with one" severity failure;
	--D
	input <= "1101"; wait for 10 ns;
	   assert (output = "0100001") report "bad with one" severity failure;
	--E
	input <= "1110"; wait for 10 ns;
	   assert (output = "0000110") report "bad with one" severity failure;
	--F
	input <= "1111"; wait for 10 ns;
	   assert (output = "0001110") report "bad with one" severity failure;
	   
	   
	   wait; -- wait forever
	end process;

end test_bench;
