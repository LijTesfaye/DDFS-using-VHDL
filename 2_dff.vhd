---Importing the necessary libraries
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std;


----declaring the entity that we gonna build
entity dff_n is 

generic( dff_Nbit : positive := 12);

  port( 
    clk: in std_logic;
    a_rst_n : in std_logic;
    en : in std_logic;
    d  : in std_logic_vector(dff_Nbit - 1 downto 0);
    q  : out std_logic_vector(dff_Nbit - 1 downto 0)
	);
end dff_n;



---architecture of the entity 
architecture beh of dff_n is  
 begin
	ddf_n_proc: process(clk, a_rst_n)
		begin
			if(a_rst_n = '0') then
				q <= (others => '0');
			elsif(rising_edge(clk)) then
				if(en = '1') then
					q <= d;
				end if;
			end if;
		end process;

end beh; --end of architecture




