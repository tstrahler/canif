library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
library ctu_can_fd_rtl;
library canif;

entity canif_top is
  port (
    i_clk   : in  std_logic;
    i_rst_n : in  std_logic;

    i_can_rx    : in std_logic_vector(0 to 3);
    o_can_tx    : out std_logic_vector(0 to 3);

    o_led       : out std_logic
  );
end entity;

architecture rtl of canif_top is
    
    -- Connectors for ctu can instance
    signal s_wb_we  : std_logic;
    signal s_wb_stb : std_logic;
    signal s_wb_cyc : std_logic;
    signal s_wb_ack : std_logic;
    signal s_wb_err : std_logic;
    signal s_wb_addr    : std_logic_vector(31 downto 0);
    signal s_wb_wdata   : std_logic_vector(31 downto 0);
    signal s_wb_rdata   : std_logic_vector(31 downto 0);


    -- Connectors for neorv32
    signal s_gpio_o : std_logic_vector(63 downto 0);
begin

    -- CTU CAN Wishbone interface
    wb_ctucan_inst : entity canif.wb_ctucan
        port map(
            i_clk   => i_clk,
            i_rst_n => i_rst_n,

            i_wb_we     => s_wb_we,
            i_wb_stb    => s_wb_stb,
            i_wb_cyc    => s_wb_cyc,
            o_wb_ack    => s_wb_ack,
            o_wb_err    => s_wb_err,
            i_wb_addr   => s_wb_addr,
            i_wb_wdata  => s_wb_wdata,
            o_wb_rdata  => s_wb_rdata,

            i_can_rx    => i_can_rx,
            o_can_tx    => o_can_tx
        );


    -- Soft CPU Instance
    neorv32_inst : entity neorv32.neorv32_top
        generic map (
            -- General --
            CLOCK_FREQUENCY                 => 12000000,    -- clock frequency of clk_i in Hz
            INT_BOOTLOADER_EN               => false,       -- boot configuration
            HW_THREAD_ID                    => 0,           -- hardware thread id (32-bit)

            -- On-Chip Debugger (OCD) --
            ON_CHIP_DEBUGGER_EN             => false,       -- implement on-chip debugger?

            -- RISC-V CPU Extensions --
            CPU_EXTENSION_RISCV_A           => false,       -- implement atomic extension?
            CPU_EXTENSION_RISCV_C           => false,       -- implement compressed extension?
            CPU_EXTENSION_RISCV_E           => false,       -- implement embedded RF extension?
            CPU_EXTENSION_RISCV_M           => false,       -- implement mul/div extension?
            CPU_EXTENSION_RISCV_U           => false,       -- implement user mode extension?
            CPU_EXTENSION_RISCV_Zfinx       => false,       -- implement 32-bit floating-point extension
            CPU_EXTENSION_RISCV_Zicsr       => true,        -- implement CSR system?
            CPU_EXTENSION_RISCV_Zicntr      => false,       -- implement base counters?
            CPU_EXTENSION_RISCV_Zifencei    => false,       -- implement instruction stream sync.?

            -- Extension Options --
            FAST_MUL_EN                     => false,       -- use DSPs for M extension's multiplier
            FAST_SHIFT_EN                   => false,       -- use barrel shifter for shift operations
            CPU_CNT_WIDTH                   => 34,          -- total width of CPU cycle and instret counters

            -- Physical Memory Protection (PMP) --
            PMP_NUM_REGIONS                 => 0,           -- number of regions (0..64)
            PMP_MIN_GRANULARITY             => 8*1024,      -- minimal region granularity in bytes

            -- Hardware Performance Monitors (HPM) --
            HPM_NUM_CNTS                    => 0,           -- number of implemented HPM counters (0..29)
            HPM_CNT_WIDTH                   => 40,          -- total size of HPM counters (1..64)

            -- Internal Instruction memory --
            MEM_INT_IMEM_EN                 => true,        -- implement processor-internal instruction memory
            MEM_INT_IMEM_SIZE               => 8*1024,      -- size of processor-internal instruction memory in bytes

            -- Internal Data memory --
            MEM_INT_DMEM_EN                 => true,        -- implement processor-internal data memory
            MEM_INT_DMEM_SIZE               => 8*1024,      -- size of processor-internal data memory in bytes

            -- Internal Cache memory --
            ICACHE_EN                       => false,       -- implement instruction cache
            ICACHE_NUM_BLOCKS               => 4,           -- i-cache: number of blocks (min 1)
            ICACHE_BLOCK_SIZE               => 64,          -- i-cache: block size in bytes (min 4)
            ICACHE_ASSOCIATIVITY            => 1,           -- i-cache: associativity / number of sets (1=direct_mapped)

            -- External memory interface --
            MEM_EXT_EN                      => true,        -- implement external memory bus interface?
            MEM_EXT_TIMEOUT                 => 0,           -- cycles after a pending bus access auto-terminates (0 = disabled)

            -- Processor peripherals --
            IO_GPIO_EN                      => true,        -- implement general purpose input/output port unit (GPIO)?
            IO_MTIME_EN                     => false,       -- implement machine system timer (MTIME)?
            IO_UART0_EN                     => false,       -- implement primary universal asynchronous receiver/transmitter (UART0)?
            IO_UART1_EN                     => false,       -- implement secondary universal asynchronous receiver/transmitter (UART1)?
            IO_SPI_EN                       => false,       -- implement serial peripheral interface (SPI)?
            IO_TWI_EN                       => false,       -- implement two-wire interface (TWI)?
            IO_PWM_NUM_CH                   => 0,           -- number of PWM channels to implement (0..60); 0 = disabled
            IO_WDT_EN                       => false,       -- implement watch dog timer (WDT)?
            IO_TRNG_EN                      => false,       -- implement true random number generator (TRNG)?
            IO_CFS_EN                       => false,       -- implement custom functions subsystem (CFS)?
            IO_CFS_CONFIG                   => x"00000000", -- custom CFS configuration generic
            IO_CFS_IN_SIZE                  => 32,          -- size of CFS input conduit in bits
            IO_CFS_OUT_SIZE                 => 32,          -- size of CFS output conduit in bits
            IO_NEOLED_EN                    => false        -- implement NeoPixel-compatible smart LED interface (NEOLED)?
        )
        port map (
            -- Global control --
            clk_i       => i_clk,                           -- global clock, rising edge
            rstn_i      => i_rst_n,                         -- global reset, low-active, async

            -- JTAG on-chip debugger interface (available if ON_CHIP_DEBUGGER_EN = true) --
            jtag_trst_i => '0',                             -- low-active TAP reset (optional)
            jtag_tck_i  => '0',                             -- serial clock
            jtag_tdi_i  => '0',                             -- serial data input
            jtag_tdo_o  => open,                            -- serial data output
            jtag_tms_i  => '0',                             -- mode select

            -- Wishbone bus interface (available if MEM_EXT_EN = true) --
            wb_tag_o    => open,                            -- request tag
            To_StdLogicVector(wb_adr_o) => s_wb_addr,       -- address
            wb_dat_i    => To_StdULogicVector(s_wb_rdata),   -- read data
            To_StdLogicVector(wb_dat_o) => s_wb_wdata,                      -- write data
            wb_we_o     => s_wb_we,                         -- read/write
            wb_sel_o    => open,                            -- byte enable
            wb_stb_o    => s_wb_stb,                        -- strobe
            wb_cyc_o    => open,                            -- valid cycle
            wb_lock_o   => open,                            -- exclusive access request
            wb_ack_i    => s_wb_ack,                            -- transfer acknowledge
            wb_err_i    => '0',                             -- transfer error

            -- Advanced memory control signals (available if MEM_EXT_EN = true) --
            fence_o     => open,                            -- indicates an executed FENCE operation
            fencei_o    => open,                            -- indicates an executed FENCEI operation

            -- GPIO (available if IO_GPIO_EN = true) --
            To_StdLogicVector(gpio_o)   => s_gpio_o,        -- parallel output
            gpio_i      => (others => '0'),                 -- parallel input

            -- primary UART0 (available if IO_UART0_EN = true) --
            uart0_txd_o => open,                            -- UART0 send data
            uart0_rxd_i => '0',                             -- UART0 receive data
            uart0_rts_o => open,                            -- hw flow control: UART0.RX ready to receive ("RTR"), low-active, optional
            uart0_cts_i => '0',                             -- hw flow control: UART0.TX allowed to transmit, low-active, optional

            -- secondary UART1 (available if IO_UART1_EN = true) --
            uart1_txd_o => open,                            -- UART1 send data
            uart1_rxd_i => '0',                             -- UART1 receive data
            uart1_rts_o => open,                            -- hw flow control: UART1.RX ready to receive ("RTR"), low-active, optional
            uart1_cts_i => '0',                             -- hw flow control: UART1.TX allowed to transmit, low-active, optional

            -- SPI (available if IO_SPI_EN = true) --
            spi_sck_o   => open,                            -- SPI serial clock
            spi_sdo_o   => open,                            -- controller data out, peripheral data in
            spi_sdi_i   => '0',                             -- controller data in, peripheral data out
            spi_csn_o   => open,                            -- SPI CS

            -- TWI (available if IO_TWI_EN = true) --
            twi_sda_io  => open,                            -- twi serial data line
            twi_scl_io  => open,                            -- twi serial clock line

            -- PWM (available if IO_PWM_NUM_CH > 0) --
            pwm_o       => open,                            -- pwm channels

            -- Custom Functions Subsystem IO --
            cfs_in_i    => (others => '0'),                 -- custom CFS inputs conduit
            cfs_out_o   => open,                            -- custom CFS outputs conduit

            -- NeoPixel-compatible smart LED interface (available if IO_NEOLED_EN = true) --
            neoled_o    => open,                            -- async serial data line

            -- System time --
            mtime_i     => (others => '0'),                 -- current system time from ext. MTIME (if IO_MTIME_EN = false)
            mtime_o     => open,                            -- current system time from int. MTIME (if IO_MTIME_EN = true)

            -- Interrupts --
            mtime_irq_i => '0',                             -- machine timer interrupt, available if IO_MTIME_EN = false
            msw_irq_i   => '0',                             -- machine software interrupt
            mext_irq_i  => '0'                              -- machine external interrupt
        );

        -- Connect GPIO to LED 
        o_led <= s_gpio_o(0);
end architecture;
