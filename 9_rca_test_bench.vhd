library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity rca_test_bench is
end rca_test_bench;

architecture  beh of rca_test_bench is
constant clk_period		: time := 100 ns;
constant Nbits			: positive := 8;

component rca 
generic ( Nbits : positive := 8 );
port
(
a_rca: in std_logic_vector(Nbits-1 downto 0) ;
b_rca: in std_logic_vector(Nbits-1 downto 0);
cin_rca: in std_logic;
f: out std_logic_vector(Nbits-1 downto 0);
cout_rca: out std_logic
);
end component ;


	signal clk : std_logic := '0';
	signal a_tb : std_logic_vector(Nbits-1 downto 0) := (others => '0');
	signal b_tb : std_logic_vector(Nbits-1 downto 0) := (others => '0');
	signal cin_tb : std_logic := '0';
	signal s_tb : std_logic_vector(Nbits-1 downto 0);
	signal cout_tb : std_logic;
	signal testing : boolean := true;


	begin
	clk <= not clk after clk_period/2 when testing else '0';
	
	dut:rca ---rca is changes to rcb
	generic map (
		Nbits=>Nbits
		)
	port map 
	(
	a_rca=>a_tb,
	b_rca=>b_tb,
	cin_rca=> cin_tb,
	f=>s_tb,
	cout_rca=>cout_tb
	); 

	stimulus:process
	begin
	a_tb <= (others => '0');
	b_tb <= (others => '0');
	cin_tb <= '0';
	wait for 200 ns;
	a_tb <= "00000110";
	b_tb <= "00100110";
	cin_tb <= '0';
	wait until rising_edge(clk);
	a_tb <= x"76";
	b_tb <= x"19";
	cin_tb <= '1';
	wait until rising_edge(clk);
	a_tb <= (others => '0');
	b_tb <= (others => '0');
	cin_tb <= '0';
	wait for 1008 ns;
	a_tb <= "11111111";
	b_tb <= "11111111";
	cin_tb <= '0';
	wait for 500 ns;
	testing <= false;
	
	end process;

	
end beh;

