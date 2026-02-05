`timescale 1ns / 1ps

//=============================================================================
// Module: seg7_led (IC4)
// Description: Chuyển đổi hex (0-F) sang 7-segment
// Output: ssegt[6:0] = {g,f,e,d,c,b,a} - Active LOW (0=sáng)
//         digit[3:0] = 4'b1110 - Chỉ bật digit 0 (active low)
//=============================================================================
module seg7_led (
    input [3:0] count,
    output [3:0] digit,
    output reg [6:0] ssegt
);

    // Chỉ bật 1 digit (digit 0) - Active LOW
    assign digit = 4'b1110;
    
    // 7-segment encoding: {g,f,e,d,c,b,a} - Active LOW
    always @(*) begin
        case (count)
            4'b0000: ssegt = 7'b1000000; // 0
            4'b0001: ssegt = 7'b1111001; // 1
            4'b0010: ssegt = 7'b0100100; // 2
            4'b0011: ssegt = 7'b0110000; // 3
            4'b0100: ssegt = 7'b0011001; // 4
            4'b0101: ssegt = 7'b0010010; // 5
            4'b0110: ssegt = 7'b0000010; // 6
            4'b0111: ssegt = 7'b1111000; // 7
            4'b1000: ssegt = 7'b0000000; // 8
            4'b1001: ssegt = 7'b0010000; // 9
            4'b1010: ssegt = 7'b0001000; // A
            4'b1011: ssegt = 7'b0000011; // b
            4'b1100: ssegt = 7'b1000110; // C
            4'b1101: ssegt = 7'b0100001; // d
            4'b1110: ssegt = 7'b0000110; // E
            4'b1111: ssegt = 7'b0001110; // F
            default: ssegt = 7'b1111111; // Off
        endcase
    end
    
endmodule
