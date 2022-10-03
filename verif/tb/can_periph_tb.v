`timescale 1 ns/10 ps

module can_periph_tb;
    
    // Clock generator
    reg clk = 0'b1;
    parameter PERIOD_HALF 10;
    always #PERIOD_HALF clk = ~clk;

    // De-assert reset after 2 clk periods
    reg rstn = 0'b1;
    parameter RESET_DELAY = 40;
    initial #RESET_DELAY rstn = 1'b1;

    can_periph can_periph_inst (
        .i_clk(clk),
        .i_rstn(rstn)
    );
endmodule
