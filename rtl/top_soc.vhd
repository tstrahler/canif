library ieee;
use ieee.std_logic_1164.all;

library canif;
use canif.all;

entity top_soc is
    port(
        -- System control signals
        i_clk   : in std_logic;
        i_rstn  : in std_logic;

        -- CAN signals
        i_can_rx    : in std_logic_vector(3 downto 0);
        o_can_tx    : out std_logic_vector(3 downto 0)
    );

end entity;

architecture top_soc_rtl of top_soc is

    -- Wishbone interface
    signal s_wb_we      : std_logic;
    signal s_wb_stb     : std_logic;
    signal s_wb_cyc     : std_logic;
    signal s_wb_ack     : std_logic;
    signal s_wb_err     : std_logic;
    signal s_wb_addr    : std_logic_vector(31 downto 0);
    signal s_wb_wdata   : std_logic_vector(31 downto 0);
    signal s_wb_rdata   : std_logic_vector(31 downto 0);

    signal s_irq_can    : std_logic_vector(3 downto 0);
    signal s_timestamp  : std_logic_vector(63 downto 0);
begin

    can_periph_inst : entity canif.can_periph
    port map(
        -- System controls
        i_clk   => i_clk,
        i_rstn  => i_rstn,

        -- Wishbone interface
        i_wb_we     => s_wb_we,
        i_wb_stb    => s_wb_stb,
        i_wb_cyc    => s_wb_cyc,
        o_wb_ack    => s_wb_ack,
        o_wb_err    => s_wb_err,
        i_wb_addr   => s_wb_addr,
        i_wb_wdata  => s_wb_wdata,
        o_wb_rdata  => s_wb_rdata,

        -- CAN signals
        i_can_rx    => i_can_rx,
        o_can_tx    => o_can_tx,

        -- Interrupt signals
        o_irq => s_irq_can,
        
        -- Timestamp signal
        i_timestamp => s_timestamp        
    );

    mcu_inst : entity canif.mcu
    port map(
        i_clk   => i_clk,
        i_rstn  => i_rstn,

        o_gpio  => open,
        o_timestamp => s_timestamp,

        o_wb_we     => s_wb_we,
        o_wb_stb    => s_wb_stb,
        o_wb_cyc    => s_wb_cyc,
        i_wb_ack    => s_wb_ack,
        i_wb_err    => s_wb_err,
        o_wb_addr   => s_wb_addr,
        o_wb_wdata  => s_wb_wdata,
        i_wb_rdata  => s_wb_rdata,

        i_irq   => s_irq_can,

        o_uart_txd  => open,
        i_uart_rxd  => '0'
    );

    


end architecture;
