library IEEE;
use IEEE.std_logic_1164.all;

entity counter is
	generic 
	(
	 counter_Nbit : positive := 12;
	 rca_Nbit     : positive := 12;
	 dff_Nbit     : positive := 12

	 ); 
	port
	(
        clk_c     : in std_logic;
        a_rst_n_c : in std_logic;
        en_c      : in std_logic;
        cnt_out: out std_logic_vector (counter_Nbit-1 downto 0)
	);
end counter;

architecture beh_counter of counter is

    component rca is
        generic ( rca_Nbit : positive := 12 ); 
        port
        (
            a_rca:	in std_logic_vector (rca_Nbit-1 downto 0);
            b_rca:	in std_logic_vector (rca_Nbit-1 downto 0);
            cin_rca: in std_logic;
            f_rca:		out std_logic_vector (rca_Nbit-1 downto 0);
            cout_rca: out std_logic
        );
    end component rca;

    component dff_n is
        generic( dff_Nbit : positive := 12);
        port (
            clk     : in std_logic;
            a_rst_n : in std_logic;
            en      : in std_logic;
            d       : in std_logic_vector(dff_Nbit - 1 downto 0);
            q       : out std_logic_vector(dff_Nbit - 1 downto 0)
        );
	end component;
    signal cnt_outs : std_logic_vector(counter_Nbit - 1 downto 0);
    constant zero : std_logic_vector(counter_Nbit -2 downto 0) := (others => '0');
    constant one : std_logic_vector(counter_Nbit - 1 downto 0) := zero & '1';
    signal di_s : std_logic_vector(counter_Nbit - 1 downto 0);
    begin

        RCA1: rca 
        generic map (
			rca_Nbit => rca_Nbit
			)
        port map
        (
            a_rca => one,
            b_rca => cnt_outs,
            cin_rca => '0',
            f_rca => di_s,
            cout_rca => open

        );
        
        DFF1: dff_n
        generic map (
			dff_Nbit => dff_Nbit
			)
        port map
        (
            clk => clk_c,
            d => di_s,
            q => cnt_outs,
            a_rst_n => a_rst_n_c,
            en => en_c

        );

        cnt_out <= cnt_outs;

    end beh_counter;

        




