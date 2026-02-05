`timescale 1ns / 1ps

module tb_led_blink;

    reg clk_100MHz;
    reg reset;
    wire [3:0] led;

    led_blink #() uut (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .led(led)
    );

    defparam uut.clk_div.DIVISOR = 5;

    initial begin
        clk_100MHz = 0;
        forever #5 clk_100MHz = ~clk_100MHz;
    end

    initial begin
        reset = 1;
        #20;
        reset = 0;
        #500;
        $finish;
    end

    initial begin
        $monitor("Time=%0t reset=%b led=%b", $time, reset, led);
    end

endmodule
