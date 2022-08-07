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
        g_wb_base   : std_logic_vector(31 downto 0) := x"A0000000";
        g_wb_width      : integer   := 12;
        g_wb_inst_width : integer   := 2;

        -- Set ammount of CAN interfaces - use 4 as default
        g_can_if_count  : integer   := 4
    );
    port(
        -- System control signals
        i_clk   : in std_logic;
        i_rstn  : in std_logic;

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
        i_can_rx    : in std_logic_vector(0 to g_can_if_count - 1);
        o_can_tx    : out std_logic_vector(0 to g_can_if_count - 1) 

        -- Interrupt generator
        o_irq   : out std_logic;

        -- Timestamp signal
        i_timestamp : in std_logic_vector(63 downto 0);
    );
end entity;

architecture rtl of wb_ctucan is
    signal s_rdy    : std_logic_vector(g_can_if_count - 1 downto 0);

    -- Wishbone signals
    signal s_addr   : std_logic_vector(15 downto 0);
    signal s_cs     : std_logic_vector(g_can_if_count - 1 downto 0);
    signal s_rd     : std_logic_vector(g_can_if_count - 1 downto 0);
    signal s_we     : std_logic_vector(g_can_if_count - 1 downto 0);
    signal s_ack    : std_logic_vector(g_can_if_count - 1 downto 0);
    -- Wishbone receive data
    type vector_array is array(integer range <>) of std_logic_vector(31 downto 0);
    signal s_wb_rdata   : vector_array(g_can_if_count - 1 downto 0);

    -- Reduced interrupt signal 
    signal s_irq    : std_logic_vector(g_can_if_count - 1 downto 0);
begin

    -- Generate for each CAN interface
    gen_can_if_mux : for i in 0 to g_can_if_count - 1 generate

        -- Generate CS signals
        p_cs_gen : process(i_wb_addr) begin
            -- Compare if base address matches
            if ( g_wb_base(31 downto g_wb_width + g_wb_inst_width) = i_wb_addr(31 downto g_wb_width + g_wb_inst_width) ) then
                -- Compare if device address matches
                if ( i_wb_addr(g_wb_width + g_wb_inst_width - 1 downto g_wb_width) = std_logic_vector(to_unsigned(i, g_wb_inst_width))) then
                    s_cs(i) <= '1';
                else
                    s_cs(i) <= '0';
                end if;
            else
                s_cs(i) <= '0';
            end if;
        end process;

        -- Remove highest bits from addr and pad for aligned access
        s_addr  <= "0000" & i_wb_addr(11 downto 2) & "00";

        -- Generate r/w signals
        s_we(i) <= s_cs(i) and i_wb_we and i_wb_stb;
        s_rd(i) <= s_cs(i) and not i_wb_we;
        
        -- Generate single clock cycle long ACK
        process(i_clk) begin
            if rising_edge(i_clk) then
                if ((s_we(i) or s_rd(i)) = '1') and (i_wb_stb = '1') and (s_ack(i) = '0') then
                    s_ack(i) <= '1';
                else
                    s_ack(i) <= '0';
                end if; 
            end if; 
        end process;
    end generate;

    -- Aggregate ACK signals
    g_ack_gen : process(s_ack)
        variable v_ack : std_logic;
    begin
        v_ack := '0';
        for i in 0 to g_can_if_count - 1 loop
            v_ack := v_ack or s_ack(i);
        end loop;
        o_wb_ack <= v_ack;
    end process;

    -- Aggregate IRQ sinals
    g_irq_gen : process(s_ack)
        variable v_irq : std_logic;
    begin
        v_irq := '0';
        for i in 0 to g_can_if_count - 1 loop
            v_irq := v_irq or s_irq(i);
        end loop;
        o_irq   <= v_irq;
    end process;

    -- Switch rdata via MUX
    g_rdata_mux : process(s_wb_rdata) begin
        for i in 0 to g_can_if_count - 1 loop
            if (s_cs(i) = '1') then
                o_wb_rdata <= s_wb_rdata(i); 
            end if;
        end loop;
    end process;

    -- Generate multiple CAN-FD instances
    gen_can_if : for i in 0 to g_can_if_count - 1 generate
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
            res_n_out   => s_rdy(i),

            scan_enable => '0',

            data_in     => i_wb_wdata,
            data_out    => s_wb_rdata(i),
            adress      => s_addr,
            scs         => s_cs(i), 
            srd         => s_rd(i),
            swr         => s_we(i),
            sbe         => "1111",

            int         => s_irq(i),
            
            can_tx      => o_can_tx(i),
            can_rx      => i_can_rx(i),

            test_probe  => open,

            timestamp   => i_timestamp
        );
    end generate;
end architecture;

