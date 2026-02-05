`timescale 1ns / 1ps

//=============================================================================
// Module: top
// Description: Top module kết nối tất cả các thành phần
// Diagram:
//   btn_up  → [IC1: debounce] → btn_up_t   ↘
//   btn_down→ [IC2: debounce] → btn_down_t → [IC3: counter_4bit] → count_t
//   clk, rst_p                                   ↓
//                              [IC4: seg7_led] ← count_t → digit, ssegt
//=============================================================================
module top (
    input clk, 
    input rst_p,
    input btn_up, 
    input btn_down,
    output [3:0] digit,
    output [6:0] ssegt
);

    wire btn_up_t;
    wire btn_down_t;
    wire [3:0] count_t;
    
    // IC1: Debounce cho nút UP
    btn_debounce IC1 (
        .clk(clk),
        .rst_p(rst_p),
        .btn_in(btn_up),
        .btn_out(btn_up_t)
    );
    
    // IC2: Debounce cho nút DOWN
    btn_debounce IC2 (
        .clk(clk),
        .rst_p(rst_p),
        .btn_in(btn_down),
        .btn_out(btn_down_t)
    );
    
    // IC3: Counter 4-bit với pulse detection
    counter_4bit IC3 (
        .clk(clk),
        .rst_p(rst_p),
        .btn_up(btn_up_t),
        .btn_down(btn_down_t),
        .count(count_t)
    );
    
    // IC4: 7-segment LED display
    seg7_led IC4 (
        .count(count_t),
        .digit(digit),
        .ssegt(ssegt)
    );
    
endmodule
