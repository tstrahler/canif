`timescale 1 ns/10 ps

module top_soc_tb;

    //////// SYSTEM SIGNALS
    // Clock generation
    reg clk = 0'b1;
    parameter PERIOD_HALF = 10;
    always #PERIOD_HALF clk = ~clk;
    // De-assert reset after 2 clk periods
    reg rstn = 0'b1;
    parameter RESET_DELAY = 40;
    initial #RESET_DELAY rstn = 1'b1;

    //////// CAN INTERFACE SIGNALS & PARAMS
    // CAN RX & TX signals
    wire  [3:0] can_tx;
    reg   [3:0] can_rx;
    // CAN delay
    parameter CAN_LOOPBACK_DELAY = 10;


    //////////////// IMPLEMENTATION
    // CAN LOOPBACK
    always @ (can_tx)
        can_rx <= #CAN_LOOPBACK_DELAY can_tx;


    top_soc top_soc_inst (
        // System signals
        .i_clk(clk),
        .i_rstn(rstn),

        // CAN IF
        .i_can_rx(can_rx),
        .o_can_tx(can_tx)
    );

    
endmodule
