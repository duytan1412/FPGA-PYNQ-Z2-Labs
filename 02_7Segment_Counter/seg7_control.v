`timescale 1ns / 1ps

module seg7_control(
    input clk_100MHz,
    input reset,
    input [3:0] ones,
    input [3:0] tens,
    input [3:0] hundreds,
    input [3:0] thousands,
    output reg [6:0] sseg,
    output reg [3:0] digit
);

    reg [1:0] digit_select;
    reg [16:0] counter;
    reg [3:0] current_digit;
    
    function [6:0] bcd_to_seg;
        input [3:0] bcd;
        begin
            case(bcd)
                4'd0: bcd_to_seg = 7'b1000000;
                4'd1: bcd_to_seg = 7'b1111001;
                4'd2: bcd_to_seg = 7'b0100100;
                4'd3: bcd_to_seg = 7'b0110000;
                4'd4: bcd_to_seg = 7'b0011001;
                4'd5: bcd_to_seg = 7'b0010010;
                4'd6: bcd_to_seg = 7'b0000010;
                4'd7: bcd_to_seg = 7'b1111000;
                4'd8: bcd_to_seg = 7'b0000000;
                4'd9: bcd_to_seg = 7'b0010000;
                default: bcd_to_seg = 7'b1111111;
            endcase
        end
    endfunction
    
    always @(posedge clk_100MHz) begin
        if (reset) begin
            counter <= 0;
            digit_select <= 0;
        end else begin
            if (counter >= 124999) begin
                counter <= 0;
                digit_select <= digit_select + 1;
            end else begin
                counter <= counter + 1;
            end
        end
    end
    
    always @(posedge clk_100MHz) begin
        if (reset) begin
            digit <= 4'b1111;
            sseg <= 7'b1111111;
            current_digit <= 4'd0;
        end else begin
            case(digit_select)
                2'b00: begin
                    digit <= 4'b1110;
                    current_digit <= thousands;
                end
                2'b01: begin
                    digit <= 4'b1101;
                    current_digit <= hundreds;
                end
                2'b10: begin
                    digit <= 4'b1011;
                    current_digit <= tens;
                end
                2'b11: begin
                    digit <= 4'b0111;
                    current_digit <= ones;
                end
            endcase
            sseg <= bcd_to_seg(current_digit);
        end
    end

endmodule
