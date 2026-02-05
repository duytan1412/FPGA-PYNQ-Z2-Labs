`timescale 1ns / 1ps

module digits(
    input clk_100MHz,
    input clk_1Hz,
    input reset,
    output reg [3:0] ones,
    output reg [3:0] tens,
    output reg [3:0] hundreds,
    output reg [3:0] thousands
);
    reg clk_1Hz_d1, clk_1Hz_d2;
    wire clk_1Hz_posedge;
    
    always @(posedge clk_100MHz) begin
        clk_1Hz_d1 <= clk_1Hz;
        clk_1Hz_d2 <= clk_1Hz_d1;
    end
    
    assign clk_1Hz_posedge = clk_1Hz_d1 & ~clk_1Hz_d2;
    
    always @(posedge clk_100MHz) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else if (clk_1Hz_posedge) begin
            if (thousands == 4'd1 && hundreds == 4'd0 && tens == 4'd0 && ones == 4'd0) begin
                ones <= 4'd0;
                tens <= 4'd0;
                hundreds <= 4'd0;
                thousands <= 4'd0;
            end else begin
                if (ones == 4'd9) begin
                    ones <= 4'd0;
                    if (tens == 4'd9) begin
                        tens <= 4'd0;
                        if (hundreds == 4'd9) begin
                            hundreds <= 4'd0;
                            thousands <= thousands + 1;
                        end else
                            hundreds <= hundreds + 1;
                    end else
                        tens <= tens + 1;
                end else
                    ones <= ones + 1;
            end
        end
    end
endmodule