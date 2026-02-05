`timescale 1ns / 1ps

module clk_divider #(
    parameter DIVISOR = 50_000_000
)(
    input  clk_100MHz,
    input  reset,
    output reg clk_out
);

    reg [31:0] counter;

    always @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            counter <= 32'd0;
            clk_out <= 1'b0;
        end else begin
            if (counter == DIVISOR - 1) begin
                counter <= 32'd0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule
