`timescale 1ns / 1ps

//=============================================================================
// Module: btn_debounce (IC1, IC2)
// Description: Loại bỏ nhiễu nút bấm
// Debounce time: 20ms @ 100MHz = 2,000,000 cycles
//=============================================================================
module btn_debounce(
    input wire clk,
    input wire rst_p,
    input wire btn_in,
    output reg btn_out
);

    reg [20:0] counter;
    reg button_state;
    reg btn_sync_0, btn_sync_1;
    
    // 2-stage synchronizer (chống metastability)
    always @(posedge clk) begin
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;
    end
    
    // Debounce logic với delay 20ms
    always @(posedge clk or posedge rst_p) begin
        if (rst_p) begin
            counter <= 0;
            button_state <= 0;
            btn_out <= 0;
        end else begin
            if (btn_sync_1 != button_state) begin
                counter <= 0;
                button_state <= btn_sync_1;
            end else begin
                if (counter < 21'd2_000_000)
                    counter <= counter + 1;
                else
                    btn_out <= button_state;
            end
        end
    end
    
endmodule
