-- #################################################################################################
-- # << NEORV32 - Minimal setup with the bootloader enabled >>                                     #
-- # ********************************************************************************************* #
-- # BSD 3-Clause License                                                                          #
-- #                                                                                               #
-- # Copyright (c) 2022, Stephan Nolting. All rights reserved.                                     #
-- #                                                                                               #
-- # Redistribution and use in source and binary forms, with or without modification, are          #
-- # permitted provided that the following conditions are met:                                     #
-- #                                                                                               #
-- # 1. Redistributions of source code must retain the above copyright notice, this list of        #
-- #    conditions and the following disclaimer.                                                   #
-- #                                                                                               #
-- # 2. Redistributions in binary form must reproduce the above copyright notice, this list of     #
-- #    conditions and the following disclaimer in the documentation and/or other materials        #
-- #    provided with the distribution.                                                            #
-- #                                                                                               #
-- # 3. Neither the name of the copyright holder nor the names of its contributors may be used to  #
-- #    endorse or promote products derived from this software without specific prior written      #
-- #    permission.                                                                                #
-- #                                                                                               #
-- # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS   #
-- # OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF               #
-- # MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE    #
-- # COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,     #
-- # EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE #
-- # GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED    #
-- # AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING     #
-- # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED  #
-- # OF THE POSSIBILITY OF SUCH DAMAGE.                                                            #
-- # ********************************************************************************************* #
-- # The NEORV32 Processor - https://github.com/stnolting/neorv32              (c) Stephan Nolting #
-- #################################################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;

entity top_cpu is
    generic (
        g_can_if_count  : integer := 4;
    )
    port (
        -- System control signal
        i_clk       : in  std_logic;
        i_rstn      : in  std_logic;

        -- GPIO pins
        o_gpio      : out std_logic_vector(3 downto 0);

        -- MTIME Timestamp
        o_timestamp : out std_logic_vector(63 downto 0);

        -- Wishbone interface
        o_wb_we     : out std_logic;
        o_wb_stb    : out std_logic;
        o_wb_cyc    : out std_logic;
        i_wb_ack    : in std_logic;
        i_wb_err    : in std_logic;
        o_wb_addr   : out std_logic_vector(31 downto 0);
        o_wb_wdata  : out std_logic_vector(31 downto 0);
        i_wb_rdata  : in std_logic_vector(31 downto 0);

        -- External interrupt signals
        i_irq       : std_logic_vector(3 downto 0);

        -- UART interface
        o_uart_txd  : out std_logic;
        i_uart_rxd  : in  std_logic
    );
end entity;

architecture top_cpu_rtl of top_cpu is

    -- System signals   
    signal s_clk    : std_ulogic;
    signal s_rstn   : std_ulogic;

    -- MTIME timestamp
    signal s_timestamp  : std_ulogic_vector(63 downto 0);

    -- internal IO connection --
    signal s_gpio   : std_ulogic_vector(63 downto 0);

    -- Wishbone interface
    signal s_wb_we      : std_ulogic;
    signal s_wb_stb     : std_ulogic;
    signal s_wb_cyc     : std_ulogic;
    signal s_wb_ack     : std_ulogic;
    signal s_wb_err     : std_ulogic;
    signal s_wb_addr    : std_ulogic_vector(31 downto 0);
    signal s_wb_rdata   : std_ulogic_vector(31 downto 0);
    signal s_wb_wdata   : std_ulogic_vector(31 downto 0);

    -- External interrupt
    signal s_irq        : std_ulogic_vector(3 downto 0);

begin

    -- GPIO connector
    o_gpio <= std_logic_vector(s_gpio(3 downto 0));

    -- Wishbone connector
    o_wb_we     <= std_logic(s_wb_we);
    o_wb_stb    <= std_logic(s_wb_stb);
    o_wb_cyc    <= std_logic(s_wb_cyc);
    s_wb_ack    <= std_ulogic(i_wb_ack);
    s_wb_err    <= std_ulogic(i_wb_err);
    o_wb_addr   <= std_logic_vector(s_wb_addr);
    o_wb_wdata  <= std_logic_vector(s_wb_wdata);
    s_wb_rdata  <= std_ulogic_vector(i_wb_rdata);

    -- External interrupt
    s_irq       <= std_ulogic_vector(i_irq);

    -- MTIME timestamp signal
    o_timestamp <= std_logic_vector(s_timestamp);

  
    neorv32_inst: entity neorv32.neorv32_top
    generic map (
        -- General --
        CLOCK_FREQUENCY              => 100000000,  -- clock frequency of clk_i in Hz
        INT_BOOTLOADER_EN            => false, -- boot configuration: true = boot explicit bootloader; false = boot from int/ext (I)MEM
        HW_THREAD_ID                 => 0,     -- hardware thread id (32-bit)
    
        -- On-Chip Debugger (OCD) --
        ON_CHIP_DEBUGGER_EN          => false,  -- implement on-chip debugger?

        -- RISC-V CPU Extensions --
        CPU_EXTENSION_RISCV_C        => true,         -- implement compressed extension?
        CPU_EXTENSION_RISCV_E        => false,         -- implement embedded RF extension?
        CPU_EXTENSION_RISCV_M        => true,         -- implement mul/div extension?
        CPU_EXTENSION_RISCV_U        => false,         -- implement user mode extension?
        CPU_EXTENSION_RISCV_Zfinx    => false,     -- implement 32-bit floating-point extension (using INT regs!)
        CPU_EXTENSION_RISCV_Zicsr    => true,     -- implement CSR system?
        CPU_EXTENSION_RISCV_Zicntr   => true,                          -- implement base counters?
        CPU_EXTENSION_RISCV_Zifencei => false,  -- implement instruction stream sync.?

        -- Extension Options --
        FAST_MUL_EN                  => false,    -- use DSPs for M extension's multiplier
        FAST_SHIFT_EN                => false,  -- use barrel shifter for shift operations
        CPU_CNT_WIDTH                => 32,  -- total width of CPU cycle and instret counters (0..64)

        -- Physical Memory Protection (PMP) --
        PMP_NUM_REGIONS              => 0,       -- number of regions (0..16)
        PMP_MIN_GRANULARITY          => 8,   -- minimal region granularity in bytes, has to be a power of 2, min 8 bytes

        -- Hardware Performance Monitors (HPM) --
        HPM_NUM_CNTS                 => 0,          -- number of implemented HPM counters (0..29)
        HPM_CNT_WIDTH                => 1,         -- total size of HPM counters (1..64)

        -- Internal Instruction memory --
        MEM_INT_IMEM_EN              => true,       -- implement processor-internal instruction memory
        MEM_INT_IMEM_SIZE            => 64*1024,     -- size of processor-internal instruction memory in bytes

        -- Internal Data memory --
        MEM_INT_DMEM_EN              => true,       -- implement processor-internal data memory
        MEM_INT_DMEM_SIZE            => 64*1024,     -- size of processor-internal data memory in bytes

        -- Internal Cache memory --
        ICACHE_EN                    => false,             -- implement instruction cache
        ICACHE_NUM_BLOCKS            => 4,     -- i-cache: number of blocks (min 1), has to be a power of 2
        ICACHE_BLOCK_SIZE            => 64,     -- i-cache: block size in bytes (min 4), has to be a power of 2
        ICACHE_ASSOCIATIVITY         => 1,  -- i-cache: associativity / number of sets (1=direct_mapped), has to be a power of 2

        -- External memory interface --
        MEM_EXT_EN                   => true,       -- implement external memory bus interface?
        MEM_EXT_TIMEOUT              => 0,           -- cycles after a pending bus access auto-terminates (0 = disabled)

        -- External Interrupts Controller (XIRQ) --
        XIRQ_NUM_CH                  : natural := g_can_if_count;      -- number of external IRQ channels (0..32)
        XIRQ_TRIGGER_TYPE            : std_logic_vector(31 downto 0) := (others => '1') & "1111"; -- trigger type: 0=level, 1=edge
        XIRQ_TRIGGER_POLARITY        : std_logic_vector(31 downto 0) := (others => '1') & "1111"; -- trigger polarity: 0=low-level/falling-edge, 1=high-level/rising-edge

        -- Processor peripherals --
        IO_GPIO_EN                   => true,    -- implement general purpose input/output port unit (GPIO)?
        IO_MTIME_EN                  => true,   -- implement machine system timer (MTIME)?
        IO_UART0_EN                  => true,   -- implement primary universal asynchronous receiver/transmitter (UART0)?
        IO_UART1_EN                  => true,         -- implement secondary universal asynchronous receiver/transmitter (UART1)?
        IO_SPI_EN                    => false,         -- implement serial peripheral interface (SPI)?
        IO_TWI_EN                    => false,         -- implement two-wire interface (TWI)?
        IO_PWM_NUM_CH                => 0, -- number of PWM channels to implement (0..60); 0 = disabled
        IO_WDT_EN                    => true,     -- implement watch dog timer (WDT)?
        IO_TRNG_EN                   => false,         -- implement true random number generator (TRNG)?
        IO_CFS_EN                    => false,         -- implement custom functions subsystem (CFS)?
        IO_CFS_CONFIG                => x"00000000",   -- custom CFS configuration generic
        IO_CFS_IN_SIZE               => 32,            -- size of CFS input conduit in bits
        IO_CFS_OUT_SIZE              => 32,            -- size of CFS output conduit in bits
        IO_NEOLED_EN                 => false          -- implement NeoPixel-compatible smart LED interface (NEOLED)?
    )
    port map (
        -- Global control --
        clk_i       => i_clk,                        -- global clock, rising edge
        rstn_i      => i_rstn,                       -- global reset, low-active, async

        -- JTAG on-chip debugger interface (available if ON_CHIP_DEBUGGER_EN = true) --
        jtag_trst_i => '0',                          -- low-active TAP reset (optional)
        jtag_tck_i  => '0',                          -- serial clock
        jtag_tdi_i  => '0',                          -- serial data input
        jtag_tdo_o  => open,                         -- serial data output
        jtag_tms_i  => '0',                          -- mode select

        -- Wishbone bus interface (available if MEM_EXT_EN = true) --
        wb_tag_o    => open,                         -- request tag
        wb_adr_o    => s_wb_addr,                         -- address
        wb_dat_i    => s_wb_rdata,              -- read data
        wb_dat_o    => s_wb_wdata,                         -- write data
        wb_we_o     => s_wb_we,                         -- read/write
        wb_sel_o    => open,                         -- byte enable
        wb_stb_o    => s_wb_stb,                         -- strobe
        wb_cyc_o    => s_wb_cyc,                         -- valid cycle
        wb_ack_i    => s_wb_ack,                          -- transfer acknowledge
        wb_err_i    => s_wb_err,                          -- transfer error

        -- GPIO (available if IO_GPIO_EN = true) --
        gpio_o      => s_gpio,                   -- parallel output
        gpio_i      => (others => '0'),              -- parallel input

        -- primary UART0 (available if IO_UART0_EN = true) --
        uart0_txd_o => o_uart_txd,                   -- UART0 send data
        uart0_rxd_i => i_uart_rxd,                   -- UART0 receive data
        uart0_rts_o => open,                   -- hw flow control: UART0.RX ready to receive ("RTR"), low-active, optional
        uart0_cts_i => '0',                   -- hw flow control: UART0.TX allowed to transmit, low-active, optional

        -- SPI (available if IO_SPI_EN = true) --
        spi_sck_o   => open,                         -- SPI serial clock
        spi_sdo_o   => open,                         -- controller data out, peripheral data in
        spi_sdi_i   => '0',                          -- controller data in, peripheral data out
        spi_csn_o   => open,                         -- SPI CS

        -- System time --
        mtime_o     => s_timestamp,                         -- current system time from int. MTIME (if IO_MTIME_EN = true)
   
        -- External interrupts 
        xirq_i      => s_irq,

        -- Interrupts --
        mtime_irq_i => '0',                          -- machine timer interrupt, available if IO_MTIME_EN = false
        msw_irq_i   => '0',                          -- machine software interrupt
        mext_irq_i  => '0'                           -- machine external interrupt
      );

end architecture;
