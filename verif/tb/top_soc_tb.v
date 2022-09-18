`timescale 1 ns/10 ps

module top_soc_tb;
    
    // Clock generation
    reg clk = 0'b1;
    parameter PERIOD_HALF = 10;
    always #PERIOD_HALF clk = ~clk;

    // De-assert reset after 2 clk periods
    reg rstn = 0'b1;
    parameter RESET_DELAY = 40;
    initial #RESET_DELAY rstn = 1'b1;

    top_soc top_soc_inst (
        .i_clk(clk),
        .i_rstn(rstn)
    );
endmodule
