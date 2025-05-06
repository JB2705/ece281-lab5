--+----------------------------------------------------------------------------
--| Testbench for 4-bit Ripple-Carry Adder
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ripple_adder_tb is
end ripple_adder_tb;

architecture test_bench of ripple_adder_tb is 
	
  -- declare the component of your top-level design unit under test (UUT)
  component ripple_adder is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (3 downto 0);
           Cout : out STD_LOGIC
       );
   end component ripple_adder;
  
 
	-- declare signals needed to stimulate the UUT inputs
	signal w_addends     : std_logic_vector(7 downto 0) := x"00"; -- the numbers being added
	signal w_sum         : std_logic_vector(3 downto 0) := x"0";
	signal w_Cin, w_Cout : std_logic;

begin
	-- PORT MAPS ----------------------------------------
	ripple_adder_uut : ripple_adder port map (
	   A    => w_addends(3 downto 0),
	   B    => w_addends(7 downto 4),
	   Cin  => w_Cin,
	   S    => w_sum,
	   Cout => w_Cout
	);
	
	-- PROCESSES ----------------------------------------	
	-- Test Plan Process
	-- Implement the test plan here.  Body of process is continuously from time = 0  
	test_process : process 
	begin
	
	   -- Test all zeros input
	   w_addends <= x"00"; w_Cin <= '0'; wait for 10 ns;
	       assert (w_sum = x"0" and w_Cout = '0') report "bad with zeros" severity failure;
       -- Test all ones input
       w_addends <= x"FF"; w_Cin <= '1'; wait for 10 ns;--addends is an 8 bit number from all the inputs, MSB to LSB, in hex. C in in the single cin bit. Make test cases according to digital. Sum is 4 bit num MSB to LSB of all S in hex. C out is the single Cout
	       assert (w_sum = x"F" and w_Cout = '1') report "bad with ones" severity failure;--wouldnt it be F for sum?
       -- TODO, a few other test cases
       --test only Cin input, s(0)=1, Cout=0
       w_addends <= x"00"; w_Cin <= '1'; wait for 10 ns;
	       assert (w_sum = x"1" and w_Cout = '0') report "bad with only cIn" severity failure;
	   --test in b0 b2, a1 a3, out s0, s1, s2, s3 if A3 is MSB and b0 LSB
	   w_addends <= x"A5"; w_Cin <= '0'; wait for 10 ns;
	       assert (w_sum = x"F" and w_Cout = '0') report "bad with alternating input" severity failure;
	   --test in B0-3 (10101010)+cin, out sum=0, cout=1
	   w_addends <= x"0F"; w_Cin <= '1'; wait for 10 ns;
	       assert (w_sum = x"0" and w_Cout = '1') report "bad with only B input" severity failure;
		wait; -- wait forever
	end process;	
	-----------------------------------------------------	
	
end test_bench;
