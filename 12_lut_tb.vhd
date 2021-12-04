library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity lut_test is
	
end lut_test;


architecture beh of lut_test is

    component lut is
        port (
            address : in  std_logic_vector(11 downto 0);
            dds_out : out std_logic_vector(5 downto 0) 
        );
    end component;

    signal kfw : std_logic_vector(11 downto 0) := (others => '0');
    signal outp : std_logic_vector(5 downto 0) := (others => '0');
    signal testing : boolean := true;

    begin

        dut: lut
            port map(
                address => kfw,
                dds_out => outp
            );

        stimulus : process
		begin

            wait for 200 ns;
            kfw <= "000000100011";
            wait for 200 ns;
            kfw <= "000000001011";
            wait for 200 ns;
            testing <= false;

        end process;
    end beh;
        

