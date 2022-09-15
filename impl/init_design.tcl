## Adaptation of the generic Genus synthesis flow

# Set project root
set PROJECT_ROOT /cipuser/fphys/kw283/dev/canif-impl

# Define library path
set_db init_hdl_search_path [list \
    $PROJECT_ROOT/canif/rtl \
    $PROJECT_ROOT/canif/ip/neorv32/rtl/core \
    $PROJECT_ROOT/canif/ip/ctucanfd/src \
    $PROJECT_ROOT/canif/ip/ctucanfd/src/bus_sampling \
    $PROJECT_ROOT/canif/ip/ctucanfd/src/can_core \
    $PROJECT_ROOT/canif/ip/ctucanfd/src/common_blocks \
    $PROJECT_ROOT/canif/ip/ctucanfd/src/frame_filters \
    $PROJECT_ROOT/canif/ip/ctucanfd/src/interface \
    $PROJECT_ROOT/canif/ip/ctucanfd/src/interrupt_manager \
    $PROJECT_ROOT/canif/ip/ctucanfd/src/memory_registers \
    $PROJECT_ROOT/canif/ip/ctucanfd/src/packages \
    $PROJECT_ROOT/canif/ip/ctucanfd/src/prescaler \
    $PROJECT_ROOT/canif/ip/ctucanfd/src/rx_buffer \
    $PROJECT_ROOT/canif/ip/ctucanfd/src/tx_arbitrator \
    $PROJECT_ROOT/canif/ip/ctucanfd/src/txt_buffer \
]

# Source files for neorv32 library
set source_files_neorv32 [list \
    neorv32_application_image.vhd \
    neorv32_boot_rom.vhd \
    neorv32_bootloader_image.vhd \
    neorv32_bus_keeper.vhd \
    neorv32_busswitch.vhd \
    neorv32_cfs.vhd \
    neorv32_cpu.vhd \
    neorv32_cpu_alu.vhd \
    neorv32_cpu_bus.vhd \
    neorv32_cpu_control.vhd \
    neorv32_cpu_cp_bitmanip.vhd \
    neorv32_cpu_cp_cfu.vhd \
    neorv32_cpu_cp_fpu.vhd \
    neorv32_cpu_cp_muldiv.vhd \
    neorv32_cpu_cp_shifter.vhd \
    neorv32_cpu_decompressor.vhd \
    neorv32_cpu_regfile.vhd \
    neorv32_debug_dm.vhd \
    neorv32_debug_dtm.vhd \
    neorv32_dmem.entity.vhd \
    neorv32_fifo.vhd \
    neorv32_gpio.vhd \
    neorv32_gptmr.vhd \
    neorv32_icache.vhd \
    neorv32_imem.entity.vhd \
    neorv32_mtime.vhd \
    neorv32_neoled.vhd \
    neorv32_package.vhd \
    neorv32_pwm.vhd \
    neorv32_slink.vhd \
    neorv32_spi.vhd \
    neorv32_sysinfo.vhd \
    neorv32_top.vhd \
    neorv32_trng.vhd \
    neorv32_twi.vhd \
    neorv32_uart.vhd \
    neorv32_wdt.vhd \
    neorv32_wishbone.vhd \
    neorv32_xip.vhd \
    neorv32_xirq.vhd \
    neorv32_dmem.default.vhd \
    neorv32_imem.default.vhd \
]

# CTU-CAN library files
set source_files_ctucan [list \
    dff_arst.vhd \
    dff_arst_ce.vhd \
    inf_ram_wrapper.vhd \
    majority_decoder_3.vhd \
    mux2.vhd \
    parity_calculator.vhd \
    rst_sync.vhd \
    shift_reg.vhd \
    shift_reg_byte.vhd \
    shift_reg_preload.vhd \
    sig_sync.vhd \
    access_signaler.vhd \
    address_decoder.vhd \
    can_registers_pkg.vhd \
    cmn_reg_map_pkg.vhd \
    data_mux.vhd \
    memory_bus.vhd \
    memory_reg.vhd \
    can_config_pkg.vhd \
    can_constants_pkg.vhd \
    can_fd_frame_format.vhd \
    can_fd_register_map.vhd \
    drv_stat_pkg.vhd \
    unary_ops_pkg.vhd \
    clk_gate.vhd \
    dlc_decoder.vhd \
    rst_reg.vhd \
    control_registers_reg_map.vhd \
    test_registers_reg_map.vhd \
    can_types_pkg.vhd \
    id_transfer_pkg.vhd \
    bit_segment_meter.vhd \
    bit_time_cfg_capture.vhd \
    bit_time_counters.vhd \
    bit_time_fsm.vhd \
    segment_end_detector.vhd \
    synchronisation_checker.vhd \
    trigger_generator.vhd \
    rx_buffer_fsm.vhd \
    rx_buffer_pointers.vhd \
    rx_buffer_ram.vhd \
    priority_decoder.vhd \
    tx_arbitrator_fsm.vhd \
    txt_buffer_fsm.vhd \
    txt_buffer_ram.vhd \
    bit_err_detector.vhd \
    data_edge_detector.vhd \
    sample_mux.vhd \
    ssp_generator.vhd \
    trv_delay_meas.vhd \
    tx_data_cache.vhd \
    bit_destuffing.vhd \
    bit_stuffing.vhd \
    bus_traffic_counters.vhd \
    control_counter.vhd \
    crc_calc.vhd \
    err_counters.vhd \
    err_detector.vhd \
    fault_confinement_fsm.vhd \
    fault_confinement_rules.vhd \
    operation_control.vhd \
    protocol_control_fsm.vhd \
    reintegration_counter.vhd \
    retransmitt_counter.vhd \
    rx_shift_reg.vhd \
    trigger_mux.vhd \
    tx_shift_reg.vhd \
    endian_swapper.vhd \
    bit_filter.vhd \
    range_filter.vhd \
    int_module.vhd \
    memory_registers.vhd \
    prescaler.vhd \
    rx_buffer.vhd \
    tx_arbitrator.vhd \
    txt_buffer.vhd \
    bus_sampling.vhd \
    can_core.vhd \
    can_crc.vhd \
    fault_confinement.vhd \
    protocol_control.vhd \
    frame_filters.vhd \
    int_manager.vhd \
]

# Core VHDL source files
set source_files_vhdl [list \
    can_top_level.vhd \
    top_can.vhd \
    top_soc.vhd \
    top_cpu.vhd \
]

# Target technology search path
set_db init_lib_search_path [list \
    $PROJECT_ROOT/skywater-pdk/libraries/sky130_fd_sc_hd/latest/timing \
]

set_db library [list \
    sky130_fd_sc_hd__ss_100C_1v60.lib \
]

# Load target technology tech file
set_db lef_library [ list \
    $PROJECT_ROOT/skywater-pdk/libraries/sky130_fd_sc_hd/latest/tech/sky130_fd_sc_hd.tlef \
]
