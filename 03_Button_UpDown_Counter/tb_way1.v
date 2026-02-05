`timescale 1ns/1ps

//=============================================================================
// Testbench: tb_way1
// Description: Test counter_4bit trực tiếp (pulse detection trong counter)
// Không cần debounce module
//=============================================================================
module tb_way1;

    reg clk;
    reg rst_p;
    reg btn_up;
    reg btn_down;
    wire [3:0] count;
    
    // DUT - Device Under Test
    counter_4bit DUT (
        .clk(clk),
        .rst_p(rst_p),
        .btn_up(btn_up),
        .btn_down(btn_down),
        .count(count)
    );
    
    // Clock 10ns -> 100MHz
    always #5 clk = ~clk;
    
    initial begin
        // Initialize
        clk = 0;
        rst_p = 1;
        btn_up = 0;
        btn_down = 0;
        
        // Release reset
        #20;
        rst_p = 0;
        
        // ===== Nhấn nút UP (GIỮ LÂU) =====
        #20;
        btn_up = 1;     // nhấn
        #100;
        btn_up = 0;     // nhả
        
        // ===== Nhấn nút UP lần 2 =====
        #50;
        btn_up = 1;
        #100;
        btn_up = 0;
        
        // ===== Nhấn nút DOWN =====
        #50;
        btn_down = 1;
        #100;
        btn_down = 0;
        
        #200;
        $stop;
    end

endmodule
