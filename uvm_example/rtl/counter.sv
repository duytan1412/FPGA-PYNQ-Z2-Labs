`timescale 1ns / 1ps
//=============================================================================
// DUT: 4-bit Up Counter
// Description: Simple synchronous counter for UVM verification demo
//=============================================================================
module counter (
    input  logic        clk,
    input  logic        rst_n,     // Active-low reset
    input  logic        enable,
    output logic [3:0]  count,
    output logic        overflow   // Pulses when counter wraps 15->0
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count    <= 4'b0000;
            overflow <= 1'b0;
        end else if (enable) begin
            if (count == 4'hF) begin
                count    <= 4'b0000;
                overflow <= 1'b1;
            end else begin
                count    <= count + 1'b1;
                overflow <= 1'b0;
            end
        end else begin
            overflow <= 1'b0;
        end
    end

endmodule
