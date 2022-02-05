library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library ctu_can_fd_rtl;
use ctu_can_fd_rtl.id_transfer_pkg.all;
use ctu_can_fd_rtl.can_constants_pkg.all;
use ctu_can_fd_rtl.can_types_pkg.all;
use ctu_can_fd_rtl.drv_stat_pkg.all;
use ctu_can_fd_rtl.unary_ops_pkg.all;
use ctu_can_fd_rtl.can_config_pkg.all;
use ctu_can_fd_rtl.CAN_FD_register_map.all;
use ctu_can_fd_rtl.CAN_FD_frame_format.all;
use ctu_can_fd_rtl.can_registers_pkg.all;

library canif;

entity wb_ctucan is
    generic(
        -- Default address is 0xA0000000 - from 0b 1010 0000 0000 0000 0000 0000 0000 0000
        --                                   to 0b 1010 0000 0000 0000 0000 1111 1111 1111
        g_wb_base   : std_logic_vector(31 downto 0) := x"A0000000"
    );
    port(
        -- System control signals
        i_clk   : in std_logic;
        i_rst_n : in std_logic;

        -- Wishbone interface
        i_wb_we     : in std_logic;    -- Write enable input
        i_wb_stb    : in std_logic;    -- Data strobe
        i_wb_cyc    : in std_logic;    -- Cycle valid

        o_wb_ack    : out std_logic;    -- Acknowledge
        o_wb_err    : out std_logic;    -- Error

        i_wb_addr   : in std_logic_vector(31 downto 0);    -- Address input
        i_wb_wdata  : in std_logic_vector(31 downto 0);    -- Data input
        o_wb_rdata  : out std_logic_vector(31 downto 0);    -- Data output
       
        -- CAN signals
        i_can_rx    : in std_logic;
        o_can_tx    : out std_logic 
    );
end entity;

architecture rtl of wb_ctucan is
    signal s_rdy    : std_logic;
    signal s_ts     : std_logic_vector(63 downto 0);

    signal s_addr   : std_logic_vector(15 downto 0);
    signal s_cs     : std_logic;
    signal s_rd     : std_logic;
    signal s_we     : std_logic;
    signal s_ack    : std_logic := '0';
begin
    -- Generate CS signal if base address bits match
    s_cs    <= '1' when (g_wb_base(31 downto 11) = i_wb_addr(31 downto 11)) else '0'; 
    -- Remove highest bits from addr and pad for aligned access
    s_addr  <= "0000" & i_wb_addr(11 downto 2) & "00";
    -- Generate r/w signals
    s_we    <= s_cs and i_wb_we and i_wb_stb;
    s_rd    <= s_cs and not i_wb_we;
    
    -- Assign ACK signal
    o_wb_ack    <= s_ack;
    -- Generate single clock cycle long ACK
    process(i_clk) begin
        if rising_edge(i_clk) then
            if ((s_we or s_rd) = '1') and (i_wb_stb = '1') and (s_ack = '0') then
                s_ack <= '1';
            else
                s_ack <= '0';
            end if; 
        end if; 
    end process;
    

    -- Timestamp generator instance
    ts_gen_inst : entity canif.ts_gen
    port map(
        i_clk   => i_clk,
        i_rst_n => i_rst_n,
        o_ts    => s_ts
    );

    -- CAN-FD interface instance
    can_top_level_inst : entity ctu_can_fd_rtl.can_top_level
    generic map(
        rx_buffer_size      => 32,
        txt_buffer_count    => 2,
        sup_filtA           => false,
        sup_filtB           => false,
        sup_filtC           => false,
        sup_range           => false,
        sup_test_registers  => false,
        target_technology   => C_TECH_FPGA
    )
    port map(
        clk_sys     => i_clk,
        res_n       => i_rst_n,
        res_n_out   => s_rdy,

        scan_enable => '0',

        data_in     => i_wb_wdata,
        data_out    => o_wb_rdata,
        adress      => s_addr,
        scs         => s_cs, 
        srd         => s_rd,
        swr         => s_we,
        sbe         => "1111",

        int         => open,
        
        can_tx      => o_can_tx,
        can_rx      => i_can_rx,

        test_probe  => open,

        timestamp   => s_ts
    );
end architecture;
