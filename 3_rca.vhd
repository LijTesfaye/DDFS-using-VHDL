library IEEE;
use IEEE.std_logic_1164.all;


entity rca is
	generic ( rca_Nbit : positive := 12 ); 
	port
	(
		a_rca:	in std_logic_vector (rca_Nbit-1 downto 0);
		b_rca:	in std_logic_vector (rca_Nbit-1 downto 0);
		cin_rca: in std_logic;
		f_rca:		out std_logic_vector (rca_Nbit-1 downto 0);
		cout_rca: out std_logic
	);
end rca;

architecture beh_rca of rca is

component full_adder is
	port (
		a: in std_logic;
		b: in std_logic;
		cin: in std_logic;
		s: out std_logic;
		cout: out std_logic
		);
	end component full_adder;

	signal int : std_logic_vector (rca_Nbit-1 downto 1);
	
	begin
	
	GEN: for i in 1 to rca_Nbit generate
		FIRST: if i = 1 generate
			FA1: full_adder port map 
				(
					a => a_rca(i-1),
					b => b_rca(i-1),
					cin => cin_rca,
					s => f_rca(i-1),
					cout => int(i)
				);
			end generate FIRST;
		INTERNAL: if i > 1 and i < rca_Nbit generate
			FAI: full_adder port map
				(
					a => a_rca(i-1),
					b => b_rca(i-1),
					cin => int(i-1),
					s => f_rca(i-1),
					cout => int(i)
				);
			end generate INTERNAL;
		LAST: if i = rca_Nbit generate 
			FAN: full_adder port map
				(
					a => a_rca(i-1),
					b => b_rca(i-1),
					cin => int(i-1),
					s => f_rca(i-1),
					cout => cout_rca
				);
			end generate LAST;
	end generate GEN;
end beh_rca;
