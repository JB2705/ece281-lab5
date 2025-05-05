----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:42:49 PM
-- Design Name: 
-- Module Name: controller_fsm - FSM
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

entity controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture FSM of controller_fsm is
-- create register signals with default state blank (0001, 1 hot encoding)
	signal s,sn: STD_LOGIC_VECTOR (3 downto 0) := "0001";

begin
--Next state logic
sn(0) <= ( not(s(3)) AND not(s(2)) AND not(s(1)) AND s(0) AND not(i_adv) ) OR ( s(3) AND not(s(2)) AND not(s(1)) AND not(s(0)) AND i_adv );
sn(1) <= ( not(s(3)) AND not(s(2)) AND not(s(1)) AND s(0) AND i_adv ) OR ( not(s(3)) AND not(s(2)) AND s(1) AND not(s(0)) AND not(i_adv) );
sn(2) <= ( not(s(3)) AND not(s(2)) AND s(1) AND not(s(0)) AND i_adv ) OR ( not(s(3)) AND s(2) AND not(s(1)) AND not(s(0)) AND not(i_adv) );
sn(3) <= ( not(s(3)) AND s(2) AND not(s(1)) AND not(s(0)) AND i_adv ) OR ( s(3) AND not(s(2)) AND not(s(1)) AND not(s(0)) AND not(i_adv) );
--Output logic
o_cycle <= "0001" when s = "0001" else --s1 blank
           "0010" when s = "0010" else --s2 LA
           "0100" when s = "0100" else --s3 LB
           "1000" when s = "1000" else --s4 Display
           "0001";--default
           --probably shouldve done this style with next state logic?
           
           
-- PROCESSES --------------------------------------------------------------------
    -- state memory w/ asynchronous reset ---------------
	register_proc : process (i_adv, i_reset)
	begin
		if i_reset = '1' then
        s <= "0001";        -- reset state is blank off (state 1/0001)
        elsif (i_adv = '1') then
            s <= sn;    -- next state becomes current state
        end if;
	end process register_proc;
         
           

end FSM;
