--Import the necessary  Libraries.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--entity of the test bench
entity ddf_tb is						
end ddf_tb;


--architecture behaviour
architecture beh of ddf_tb is
	constant clk_period : time 	  := 200 ns ; 
	constant fw_Nbit 	: positive := 12  ; --the input  of the DDFS  is a 12 bit frequency word.
	constant yq_Nbit 	: positive := 6   ; --the output of the DDFS  is a 6  bit result.


--component of the direct discrete synthesizer goes here.
component  ddf_n 
	generic 
		(
			fw_Nbit : positive := 12;
			yq_Nbit : positive := 6 

		);
	port
		(
			--clk						 : in std_logic;
			clk                      : in  std_logic;
			reset                    : in  std_logic;
			fw                       : in  std_logic_vector(fw_Nbit-1 downto 0); --frequency word, 12 bits
			yq                       : out std_logic_vector(yq_Nbit-1 downto 0) ---sin quantized, 6 bits	
		);
	
end component;

--declare the necessary signals to match the port of the ddfs
	signal clk_external		: std_logic := '0';
	signal resetn_external  	: std_logic := '0';
	signal fw_external		: std_logic_vector(fw_Nbit-1 downto 0) := (others => '0');
	signal yq_external		: std_logic_vector(yq_Nbit-1 downto 0);
	signal testing 		        : boolean := true;
	
-- Declare the DUT and do the mapping of the ddf_n and the testbench
	begin
		clk_external <= not clk_external after clk_period/2 when testing else '0';
		--clk_ext <= not clk_ext after clk_period/2 when testing else '0';
		DUT:ddf_n
		generic map
			(
			fw_Nbit=>fw_Nbit,
			yq_Nbit=>yq_Nbit --no simicolon here.
			)
		port map 
			(
			clk=>clk_external,
			reset=>resetn_external,
			fw=>fw_external,
			yq=>yq_external
		
			);
			
--the Process declaration goes here
	stimulus: process
	begin
	
	wait for 100 ns;
	
		wait for 100 ns;
		resetn_external<='1';
		fw_external<="000000000001";
		wait for 500000 ns;
		fw_external<= "000000000110";
		wait for 200000 ns;
		resetn_external<= '0';
		wait for 100000 ns;
		resetn_external<='1';
		wait for 500000 ns;
		wait until rising_edge(clk_external);
		testing<= false;
		
	
	end process;
end beh;