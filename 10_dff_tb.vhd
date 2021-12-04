---Importing the necessary packages
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity dff_tb is 

end dff_tb;


architecture beh of dff_tb is

	constant clk_period		: time := 100 ns;
	constant Nbit			: positive := 8;

	component dff_n is
		generic( N : natural := 8);
		port(
			clk     : in std_logic;
			a_rst_n : in std_logic;
			en      : in std_logic;
			d       : in std_logic_vector(N - 1 downto 0);
			q       : out std_logic_vector(N - 1 downto 0)
		);
	end component;
	
	signal clk : std_logic := '0';
	signal d_ext : std_logic_vector(Nbit-1 downto 0) := (others => '0');
	signal q_ext : std_logic_vector(Nbit-1 downto 0) := (others => '0');
	signal en_ext : std_logic := '1';
        signal a_rst_n_ext : std_logic := '0';
	signal testing : boolean := true;
	
	begin
		clk <= not clk after clk_period/2 when testing else '0';
		
		dut: dff_n
		generic map (
			N => Nbit
			)
		port map (
			d => d_ext,
			q => q_ext,
			en => en_ext,
			a_rst_n => a_rst_n_ext,
			clk => clk
		);
		
		stimulus : process
			begin
			
				d_ext <= "00000110";
				wait for 200 ns;
                                a_rst_n_ext <= '1';
				wait until rising_edge(clk);
				d_ext <= "11000110";
				wait until rising_edge(clk);
				wait for 1008 ns;
				en_ext <= '0';
				wait for 500 ns;
				testing <= false;
			end process;

end beh;
