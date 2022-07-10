library ieee;
use ieee.std_logic_1164.all;

library canif;

entity tb_canif is
end entity;


architecture rtl of tb_canif is
    -- Constants for testbench configuration
    constant c_clock_period : time  := 10 ns;
    

    -- Testbench signals
    signal s_clk    : std_logic := '1';
    signal s_rst_n  : std_logic := '0';

    signal s_led    : std_logic;


begin

    canif_top_inst : entity canif.canif_top
    port map(
        i_clk   => s_clk,
        i_rst_n => s_rst_n,
        
        i_can_rx    => "0000",
        o_can_tx    => open,

        o_led   => s_led
    );

    -- Generate clock
    s_clk <= not s_clk after c_clock_period;

    -- Reset after 8 clock cycles
    s_rst_n <= '1' after c_clock_period * 8;

    -- Wait for led flashing
    process 
    begin
        
        wait until s_led = '1';
        report "LED is on!";

    end process;



end architecture;
