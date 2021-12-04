library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ddf_n is 

	generic
		(
			fw_Nbit          : positive := 12; --the input  of the DDFS  is a 12 bit frequency word.
			yq_Nbit          : positive := 6; --the output of the DDFS  is a 6  bit result.
			
			counter_Nbit	 : positive := 12;
			
			
			lut_address_size : positive :=	12;
		        lut_out_size	 : positive :=	6;
			
			dff_Nbit	 : positive := 6
			
		);
	port 
		(
			clk                      : in  std_logic;
			reset                    : in  std_logic;
			fw                       : in  std_logic_vector(fw_Nbit-1 downto 0); --frequency word, 12 bits
			yq                       : out std_logic_vector(yq_Nbit-1 downto 0) ---sin quantized, 6 bits
		
		);
end ddf_n;


architecture rtl of ddf_n is   
--- only the counter the LUT and D-Flip Flop are enough, look at the diagram from the slide 13/20.
 
--component for the counter
	component counter is
		generic ( counter_Nbit : positive := 12 ); 
		port
		(
			clk_c    	  : in  std_logic;
			a_rst_n_c 	  : in  std_logic;
			en_c              : in  std_logic;
			cnt_out           : out std_logic_vector (counter_Nbit-1 downto 0)
		 );
	end component;


     
	component lut is 	--component for the LUT(the Look Up Table)
		generic 
		(
		lut_address_size	: positive :=	12;
		lut_out_size		: positive :=	6	
		
		); 	
		port
		(
			address : in  std_logic_vector(lut_address_size-1 downto 0);
			dds_out : out std_logic_vector(lut_out_size-1 downto 0)
		); 
	end component lut;
	
	---component for the D Flip Flop
	component dff_n is 
		generic (dff_Nbit : integer := 6); ---a six bit D Flip Flop 
			port
			(
				clk: in std_logic;
				a_rst_n : in std_logic; --asynchronous reset
				en : in std_logic;
				d  : in std_logic_vector(dff_Nbit - 1 downto 0);
				q  : out std_logic_vector(dff_Nbit - 1 downto 0)
			);
	
	end component dff_n;
	
	--signal declarations	
	signal cnt_outs : std_logic_vector(counter_Nbit - 1 downto 0);
	
	--constant zero : std_logic_vector(Nbit -2 downto 0) := (others => '0');
    --constant one : std_logic_vector(Nbit - 1 downto 0) := zero & '1';
    --signal di_s : std_logic_vector(Nbit - 1 downto 0);
	
	----for the LUT	
	signal enable_external : std_logic := '1';
	
	signal lut_address_external: std_logic_vector(lut_address_size-1 downto 0);
	signal lut_out_external: std_logic_vector(lut_out_size-1 downto 0);
	
	
	--for the D Flip Flop	
	signal d_flip_flop_out: std_logic_vector(dff_Nbit-1 downto 0);
	signal d_flip_flop_in:std_logic_vector(dff_Nbit-1 downto 0);
	
 

begin
--port mapping for the respective components.

--map the counter
COUNTER1:counter
	generic map
	(
	counter_Nbit=>counter_Nbit
	
	)
	port map
	(
		clk_c=>clk,
		a_rst_n_c=>reset,
		en_c  =>enable_external,
		cnt_out=>cnt_outs
	
	);
--map the LUT
LUT1: lut
	generic map 
		(
		lut_address_size=> lut_address_size,
		lut_out_size=>lut_out_size		
		
		)
		port map
		(
		address=>cnt_outs,
		dds_out=>lut_out_external		
		
		);
		

--map the register(D Flip Flop)
DFF1: dff_n

	generic map
		(
		dff_Nbit=>dff_Nbit
	
		)
		
	port map 
		(
		clk=>clk,
		a_rst_n =>reset,
		en =>enable_external,
		d => lut_out_external,	 -- the input of the DFF is the out-put of the LUT	
		q=> d_flip_flop_out
		
		);
--yq<=(LSB*(y(k)/LSB));
yq<=d_flip_flop_out; -- the output of the D Flip Flop is the same as the out put of the DDFS

end rtl;