library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity full_adder_tb is
end full_adder_tb;
	
architecture beh of full_adder_tb is

	constant clk_period		: time 		  := 100 ns;
	
	component full_adder
	port (
	a_adder: in std_logic;	
	b_adder: in std_logic;

	cin_adder: in std_logic;

	sum_adder:out std_logic;
	cout_adder:out std_logic
		);
	end component;
	
	signal clk	    : std_logic := '0';
	signal a_ext	  : std_logic := '0';
	signal b_ext	  : std_logic := '0';
	signal c_in_ext : std_logic := '0';
	signal s_ext	  : std_logic;
	signal c_out_ext: std_logic;
	signal testing  : boolean := true;
	
	begin
	clk <=  not clk after clk_period/2 when testing else '0';

	dut: full_adder 
		port map(
			a_adder	   => a_ext,	
			b_adder	   => b_ext,	
			cin_adder	 => c_in_ext,	
			sum_adder	   => s_ext,	
			cout_adder => c_out_ext
			);
		
----Now let's try to implement the truth table of a full adder
		stimulus : process 
			begin
			a_ext 	 <= '0';
			b_ext 	 <= '0';
			c_in_ext <= '0';
			wait for 200 ns;
			a_ext 	 <= '0';
			b_ext 	 <= '0';
			c_in_ext <= '1';
			wait until rising_edge(clk);---wait for 200 ns; 
			a_ext 	 <= '0';
			b_ext 	 <= '1';
			c_in_ext <= '0';
			wait until rising_edge(clk);---wait for 200 ns; 
			a_ext    <='0';
			b_ext 	 <= '1';
			c_in_ext <= '1';
			wait until rising_edge(clk);

			---wait for 200 ns;
			a_ext 	 <= '0';
			b_ext 	 <= '1';
			c_in_ext <= '1';

			wait until rising_edge(clk);---wait for 200 ns;
			a_ext 	 <= '1';
			b_ext 	 <= '0';
			c_in_ext <= '0';
			wait until rising_edge(clk);---wait for 500 ns;
			a_ext 	 <= '1';
			b_ext 	 <= '0';
			c_in_ext <= '0';
			wait until rising_edge(clk);---wait for 200 ns;

			a_ext 	 <= '1';
			b_ext 	 <= '1';
			c_in_ext <= '0';

			wait for 1008 ns;
			a_ext 	 <= '1';
			b_ext 	 <= '1';
			c_in_ext <= '1';
			wait for 500 ns;
		testing  <= false;
		end process;
end beh;
	
