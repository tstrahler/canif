## Clock constraints for synthesis
# Create main clock freq and period in ps
set CLK     200000000
set CLK_PER [expr {1.0 / $CLK / 1e-12}]
define_clock -period $CLK_PER -name clk [get_port clk_i]

