`timescale 1ns/1ps

//=============================================================================
// Testbench: tb_way2
// Description: Test với debounce module (debounce tạo xung 1 clock)
// Debounce → Counter (counter dùng if(btn_up) thay vì pulse detection)
//=============================================================================
module tb_way2;

    reg clk;
    reg rst_p;
    reg btn_up_raw;
    reg btn_down_raw;
    wire btn_up_pulse;
    wire btn_down_pulse;
    wire [3:0] count;
    
    // Debounce tạo xung
    debounce DB_UP (
        .clk(clk),
        .rst_p(rst_p),
        .btn_in(btn_up_raw),
        .btn_out(btn_up_pulse)
    );
    
    debounce DB_DOWN (
        .clk(clk),
        .rst_p(rst_p),
        .btn_in(btn_down_raw),
        .btn_out(btn_down_pulse)
    );
    
    // Counter - nhận pulse từ debounce
    counter_4bit DUT (
        .clk(clk),
        .rst_p(rst_p),
        .btn_up(btn_up_pulse),
        .btn_down(btn_down_pulse),
        .count(count)
    );
    
    // Clock
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst_p = 1;
        btn_up_raw = 0;
        btn_down_raw = 0;
        
        #20;
        rst_p = 0;
        
        // ===== Nhấn UP (giữ lâu) =====
        #20;
        btn_up_raw = 1;
        #100;
        btn_up_raw = 0;
        
        // ===== Nhấn UP lần 2 =====
        #50;
        btn_up_raw = 1;
        #100;
        btn_up_raw = 0;
        
        // ===== Nhấn DOWN =====
        #50;
        btn_down_raw = 1;
        #100;
        btn_down_raw = 0;
        
        #200;
        $stop;
    end

endmodule
