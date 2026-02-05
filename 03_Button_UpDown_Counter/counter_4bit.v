`timescale 1ns / 1ps

//=============================================================================
// Module: counter_4bit (IC3)
// Description: Counter 4-bit với PULSE DETECTION
// Logic: 1 lần nhấn = 1 xung (không tăng liên tục khi giữ nút)
// up_pulse = btn_up & ~btn_up_d → chỉ = 1 đúng 1 chu kỳ clock
//=============================================================================
module counter_4bit (
    input wire clk,
    input wire rst_p,
    input wire btn_up,
    input wire btn_down,
    output reg [3:0] count
);

    // Delayed button signals để phát hiện edge
    reg btn_up_d, btn_down_d;
    
    // Pulse detection: chỉ tạo xung 1 clock khi nút vừa được nhấn
    wire up_pulse   = btn_up   & ~btn_up_d;
    wire down_pulse = btn_down & ~btn_down_d;
    
    always @(posedge clk or posedge rst_p) begin
        if (rst_p) begin
            count <= 4'd0;
            btn_up_d <= 1'b0;
            btn_down_d <= 1'b0;
        end else begin
            // Lưu trạng thái button trước đó
            btn_up_d <= btn_up;
            btn_down_d <= btn_down;
            
            // Tăng/giảm chỉ khi có pulse (rising edge)
            if (up_pulse)
                count <= count + 1;  // Tự động wrap 15→0
            else if (down_pulse)
                count <= count - 1;  // Tự động wrap 0→15
        end
    end
    
endmodule
