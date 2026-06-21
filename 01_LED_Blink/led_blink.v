`timescale 1ns / 1ps

module led_blink(
    input  clk_125MHz,
    input  reset,
    output [3:0] led
);

    wire clk_1Hz;

    clk_divider #(.DIVISOR(62_500_000)) clk_div (
       .clk_125MHz(clk_125MHz),
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
