# Load design configuration
source ../init_design.tcl

# Read neorv32 files and core files
read_hdl -language vhdl -library neorv32 $source_files_neorv32
read_hdl -language vhdl -library ctu_can_fd_rtl $source_files_ctucan
read_hdl -language vhdl $source_files_vhdl

# Elaborate RTL definition
elaborate top

# Read constraints
read_sdc synth_constraints.sdc

# Do synthesis
syn_generic
syn_map
syn_opt
