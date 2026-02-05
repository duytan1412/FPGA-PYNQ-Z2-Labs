`timescale 1ns / 1ps

module top(
    input clk_100MHz,
    input reset,
    output [6:0] sseg,
    output [3:0] digit
);
    wire clk_1Hz;
    wire [3:0] w_ones, w_tens, w_hundreds, w_thousands;

    tenHz_gen clk_gen (
        .clk_100MHz(clk_100MHz), 
        .reset(reset), 
        .clk_10Hz(clk_1Hz)
    );
    
    digits counter (
        .clk_100MHz(clk_100MHz),
        .clk_1Hz(clk_1Hz), 
        .reset(reset), 
        .ones(w_ones), 
        .tens(w_tens), 
        .hundreds(w_hundreds), 
        .thousands(w_thousands)
    );
    
    seg7_control display (
        .clk_100MHz(clk_100MHz), 
        .reset(reset), 
        .ones(w_ones), 
        .tens(w_tens), 
        .hundreds(w_hundreds), 
        .thousands(w_thousands), 
        .sseg(sseg), 
        .digit(digit)
    );

endmodule
