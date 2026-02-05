`timescale 1ns / 1ps

//=============================================================================
// Module: debounce (Way 2 - Modified for simulation)
// Description: Debounce với logic tạo xung 1 clock
// counter < 3 (RẤT NGẮN cho simulation - chỉ 3 cycles = 30ns)
// btn_out = 1 chỉ 1 chu kỳ clock khi button vừa ổn định
//=============================================================================
module debounce(
    input wire clk,
    input wire rst_p,
    input wire btn_in,
    output reg btn_out
);

    reg [20:0] counter;
    reg button_state;
    reg btn_sync_0, btn_sync_1;
    reg debounced;           // Trạng thái đã debounce
    reg debounced_prev;      // Trạng thái trước đó để phát hiện edge
    
    // Đồng bộ tín hiệu nút (chống metastability)
    always @(posedge clk) begin
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;
    end
    
    // Debounce logic
    always @(posedge clk or posedge rst_p) begin
        if (rst_p) begin
            counter <= 0;
            button_state <= 0;
            debounced <= 0;
            debounced_prev <= 0;
            btn_out <= 0;
        end else begin
            // Lưu trạng thái trước
            debounced_prev <= debounced;
            
            // Mặc định không có xung
            btn_out <= 0;
            
            if (btn_sync_1 != button_state) begin
                // Button đang thay đổi, reset counter
                counter <= 0;
                button_state <= btn_sync_1;
            end else begin
                // Button ổn định
                if (counter < 21'd3) begin  // Rút ngắn: chỉ 3 cycles = 30ns
                    counter <= counter + 1;
                end else begin
                    // Đã ổn định đủ lâu
                    debounced <= button_state;
                end
            end
            
            // Tạo xung 1 clock khi phát hiện rising edge
            if (debounced && !debounced_prev) begin
                btn_out <= 1'b1;
            end
        end
    end
    
endmodule
