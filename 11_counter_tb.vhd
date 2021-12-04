library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity counter_tb is
	
end counter_tb;

architecture beh_cnt of counter_tb is

	constant clk_period		: time := 100 ns;
	constant Nbit			: positive := 4;

	component CNT is
		generic ( Nbit : positive := 3 ); 
        port
        (
            clk_c     : in std_logic;
            a_rst_n_c : in std_logic;
            en_c      : in std_logic;
            cnt_out: out std_logic_vector (Nbit-1 downto 0)
        );
	end component;
	
	signal clk : std_logic := '0';
	signal a_rst_n_c_ext : std_logic := '0';
	signal cnt_out_ext : std_logic_vector(Nbit-1 downto 0) := (others => '0');
	signal en_c_ext : std_logic := '1';
	signal testing : boolean := true;
	
	begin
		clk <= not clk after clk_period/2 when testing else '0';
		
		dut: CNT
		generic map (
			Nbit => Nbit
			)
		port map (
			clk_c => clk,
            a_rst_n_c => a_rst_n_c_ext,
            en_c => en_c_ext,
            cnt_out => cnt_out_ext
		);
		
		stimulus : process
			begin
				wait for 200 ns;
				wait until rising_edge(clk);
                a_rst_n_c_ext <= '1';
				
				wait for 2000 ns;
				en_c_ext <= '0';
				wait until rising_edge(clk);
				wait for 500 ns;
				testing <= false;
			end process;
	end beh_cnt;
