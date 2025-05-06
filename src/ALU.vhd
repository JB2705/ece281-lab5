----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;


architecture Behavioral of ALU is

--add ripple adder component
component ripple_adder is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC; --
           S : out STD_LOGIC_VECTOR (3 downto 0);
           Cout : out STD_LOGIC);
end component ripple_adder;

--create signals
signal result: STD_LOGIC_VECTOR (7 downto 0) := "00000000";--create a signal for the result, default of 0
signal B_mux: STD_LOGIC_VECTOR (7 downto 0) := "00000000";--create a signal for the result of the B mux, default of 0
signal sum: STD_LOGIC_VECTOR (7 downto 0) := "00000000";--create a signal for the sum from the adder, default of 0
signal lower_carry, upper_carry : STD_LOGIC;
--signal diff: STD_LOGIC_VECTOR (7 downto 0) := "00000000";--create a signal for the diff from the adder, default of 0
signal zero: STD_LOGIC := '0';--signal for 0 flag
signal neg: STD_LOGIC := '0';--signal for negative plag
signal carry: STD_LOGIC := '0';--signal for carry flag
signal overf: STD_LOGIC := '0';--signal for overflow

begin

--logic for sum/adder
ripple_adder_lower: ripple_adder
    port map(
        A     => i_A(3 downto 0),
        B     => B_mux(3 downto 0),
        Cin   => i_op(0),--inital cin is i_op(0) according to drawing?   
        S     => sum(3 downto 0),
        Cout  => lower_carry
    );
ripple_adder_upper: ripple_adder
    port map(
        A     => i_A(7 downto 4),
        B     => B_mux(7 downto 4),
        Cin   => lower_carry,  
        S     => sum(7 downto 4),
        Cout  => upper_carry
    );

--MUX LOGIC FOR B AND OUTPUT
    B_mux <= i_B when i_op(0) = '0' else
             not i_B;

    result <= sum when i_op = "000" else--add
              sum when i_op = "001" else--sub
              (i_A AND i_B) when i_op = "010" else--and
              (i_A OR i_B) when i_op = "011" else--or
              "00000000";--default as 0?
    o_result <= result;

--logic for flags
zero <= '1' when (result = "00000000") else '0';
neg <= result(7);
carry <= ( (not i_op(1)) and upper_carry ); 
overf <= ( (not i_op(1)) and ( i_A(7) xor sum(7) ) and ( not (i_A(7) xor i_B(7) xor i_op(0)) ) );

--Flags output(order may be wrong)
    o_flags(0) <= overf;
    o_flags(1) <= carry;
    o_flags(2) <= zero;
    o_flags(3) <= neg;



end Behavioral;
