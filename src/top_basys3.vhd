--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
    port(
        -- inputs
        clk     :   in std_logic; -- native 100MHz FPGA clock
        sw      :   in std_logic_vector(7 downto 0); -- operands and opcode
        btnU    :   in std_logic; -- reset
        btnC    :   in std_logic; -- fsm cycle
        
        -- outputs
        led :   out std_logic_vector(15 downto 0);
        -- 7-segment display segments (active-low cathodes)
        seg :   out std_logic_vector(6 downto 0);
        -- 7-segment display active-low enables (anodes)
        an  :   out std_logic_vector(3 downto 0)
    );
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- COMPONENTS ------------------------------------------
    component controller_fsm is 
        port (
           i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component controller_fsm;
    
    component ALU is
        Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
               i_B : in STD_LOGIC_VECTOR (7 downto 0);
               i_op : in STD_LOGIC_VECTOR (2 downto 0);
               o_result : out STD_LOGIC_VECTOR (7 downto 0);
               o_flags : out STD_LOGIC_VECTOR (3 downto 0));
    end component ALU;
    
    component clock_divider is
        generic ( constant k_DIV : natural := 2	); -- How many clk cycles until slow clock toggles
                                                   -- Effectively, you divide the clk double this 
                                                   -- number (e.g., k_DIV := 2 --> clock divider of 4)
        port ( 	i_clk    : in std_logic;
                i_reset  : in std_logic;		   -- asynchronous
                o_clk    : out std_logic		   -- divided (slow) clock
        );
    end component clock_divider;
    
    component twos_comp is
        port (
            i_bin: in std_logic_vector(7 downto 0);
            o_sign: out std_logic;
            o_hund: out std_logic_vector(3 downto 0);
            o_tens: out std_logic_vector(3 downto 0);
            o_ones: out std_logic_vector(3 downto 0)
        );
    end component twos_comp;
    
    component TDM4 is
        generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
        Port ( i_clk		: in  STD_LOGIC;
               i_reset		: in  STD_LOGIC; -- asynchronous
               i_D3 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D2 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D1 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D0 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_data		: out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_sel		: out STD_LOGIC_VECTOR (3 downto 0)	-- selected data line (one-cold)
        );
    end component TDM4;
    
    component sevenseg_decoder is
        Port ( i_Hex : in STD_LOGIC_VECTOR (3 downto 0);
               o_seg_n : out STD_LOGIC_VECTOR (6 downto 0));
    end component sevenseg_decoder;
    
    -- SIGNALS ------------------------------------------
    signal w_cycle: STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal w_div_clk: STD_LOGIC := '0';
    signal w_A, w_B, w_ALU_result, w_ALU_MUX_result: STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal w_ALU_flags: STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal w_sign_2s: STD_LOGIC := '0';
    signal w_sign: STD_LOGIC_VECTOR (6 downto 0) := "00000000";
    signal w_D2, w_D1, w_D0, w_TDM_data, w_TDM_sel: STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal w_seg_n: STD_LOGIC_VECTOR (6 downto 0) := "00000000";--might want to change to 1s default?
    signal w_sevenseg_MUX_result: STD_LOGIC_VECTOR (6 downto 0) := "00000000";--might want to change to 1s default?
 

  
begin
	-- PORT MAPS ----------------------------------------
    controller_fsm_1:controller_fsm
        port map(
            i_reset => btnU,
            i_adv => btnC,
            o_cycle => w_cycle
        );
     
     clk_div:clock_divider
        generic map ( k_DIV => 50000  )--1khz clock from 100mhz, 100mhz/100 khz = 1 khz. 50 khz (50 000) since the value is doubled
        port map(
            i_clk => clk,
            i_reset => btnU, --may need to be changed
            o_clk => w_div_clk
        );
        
      top_ALU:ALU
        port map(
            i_A => w_A,
            i_B => w_B,
            i_op => sw(2 downto 0),
            o_result => w_ALU_result,
            o_flags => w_ALU_flags
        );
      
      top_twos_comp: twos_comp
        port map(
            i_bin => w_ALU_MUX_result,
            o_sign => w_sign_2s,--may need to change
            o_hund => w_D2,
            o_tens => w_D1,
            o_ones => w_D0
        );
      
      top_TDM4: TDM4
        port map(
            i_reset => btnU, --may need to change
            i_clk => w_div_clk,
            i_D3 => "0000", --may need to change
            i_D2 => w_D2,
            i_D1 => w_D1,
            i_D0 => w_D0,
            o_data => w_TDM_data,
            o_sel => w_TDM_sel
        );
        
        top_sevenseg: sevenseg_decoder
            port map(
                i_hex => w_TDM_data,
                o_seg_n => w_seg_n
            );
      
	
	-- CONCURRENT STATEMENTS ----------------------------
	
	--sevenseg MUX
	--w_sign <= ( (not w_sign_2s) and "11111111" );
	seg <= w_sevenseg_MUX_result;
	
	
end top_basys3_arch;
