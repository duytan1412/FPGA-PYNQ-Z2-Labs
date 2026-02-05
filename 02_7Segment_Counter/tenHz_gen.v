`timescale 1ns / 1ps

module tenHz_gen(
    input clk_100MHz,
    input reset,
    output reg clk_10Hz
);
    parameter HALF_PERIOD = 6_250_000;
    reg [25:0] counter;

    always @(posedge clk_100MHz) begin
        if (reset) begin
            counter <= 0;
            clk_10Hz <= 0;
        end else begin
            if (counter >= HALF_PERIOD - 1) begin
                counter <= 0;
                clk_10Hz <= ~clk_10Hz;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule
