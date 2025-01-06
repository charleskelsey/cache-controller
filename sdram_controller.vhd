----------------------------------------------------------------------------------
-- Company: 		 
-- Engineer: 		 
-- 
-- Create Date:    
-- Design Name: 
-- Module Name:    sdram_controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sdram_controller is
    port (
        clk     : in std_logic; 
        memstrb : in std_logic; 
        wea     : in std_logic_vector(0 downto 0); 
        address : in std_logic_vector(11 downto 0); 
        d_in    : in std_logic_vector(7 downto 0); 
        d_out   : out std_logic_vector(7 downto 0)
    ); 
end sdram_controller;

architecture Behavioral of sdram_controller is

    -- Signal declarations without 'in' or 'out'
    signal sdram_rd_wr    : std_logic_vector(0 downto 0);  
    signal sdram_add_sig  : std_logic_vector(11 downto 0);  
    signal sdram_din_sig  : std_logic_vector(7 downto 0);
    signal sdram_dout_sig : std_logic_vector(7 downto 0);

    signal empty          : std_logic := '0'; 
    signal counter        : std_logic_vector(11 downto 0) := "000000000000";

    -- SDRAM component declaration
    component sdram
        port (
            clka  : in std_logic; 
            wea   : in std_logic_vector(0 downto 0); 
            addra : in std_logic_vector(11 downto 0); 
            dina  : in std_logic_vector(7 downto 0); 
            douta : out std_logic_vector(7 downto 0)
        );
    end component; 

begin
    -- Instantiate the SDRAM component and map signals correctly
    sys_sdram : sdram 
        port map (
            clka  => clk,             -- Clock signal mapping
            wea   => sdram_rd_wr,     -- Write enable signal
            addra => sdram_add_sig,   -- Address signal
            dina  => sdram_din_sig,   -- Data input signal
            douta => sdram_dout_sig   -- Data output signal
        );

    -- Main process for controlling SDRAM read/write
    main_process : process(clk)
    begin
        if rising_edge(clk) then
            -- Assign address signal
            sdram_add_sig <= address;

            -- Memory strobe logic
            if memstrb = '1' then
                -- If write enable is low, it's a read operation
                if wea(0) = '0' then
                    sdram_rd_wr(0) <= '0';  -- Read mode
                    d_out <= sdram_dout_sig; -- Output data from SDRAM
                else
                    -- Write operation
                    sdram_rd_wr(0) <= '1';  -- Write mode
                    sdram_din_sig <= d_in;  -- Input data to SDRAM
                end if;
            end if;
        end if;
    end process;

end Behavioral;