`timescale 1ns / 1ps

module led_blink(
    input  clk_100MHz,
    input  reset,
    output [3:0] led
);

    wire clk_1Hz;

    clk_divider #(.DIVISOR(50_000_000)) clk_div (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .clk_out(clk_1Hz)
    );

    reg [3:0] led_pattern;

    always @(posedge clk_1Hz or posedge reset) begin
        if (reset) begin
            led_pattern <= 4'b0001;
        end else begin
            led_pattern <= {led_pattern[2:0], led_pattern[3]};
        end
    end

    assign led = led_pattern;

endmodule
