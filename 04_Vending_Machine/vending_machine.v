`timescale 1ns / 1ps

module vending_machine(
    input        clk,
    input        reset,
    input  [1:0] coin,
    input  [1:0] item_sel,
    input        cancel,
    output reg [7:0] balance,
    output reg [1:0] dispense,
    output reg [7:0] change,
    output reg       error,
    output reg [2:0] state_out
);

    localparam IDLE      = 3'b000;
    localparam ACCUMULATE = 3'b001;
    localparam SELECT    = 3'b010;
    localparam DISPENSE  = 3'b011;
    localparam CHANGE    = 3'b100;
    localparam ERROR_ST  = 3'b101;

    localparam COIN_5    = 2'b01;
    localparam COIN_10   = 2'b10;
    localparam COIN_20   = 2'b11;

    localparam ITEM_A    = 2'b01;
    localparam ITEM_B    = 2'b10;
    localparam ITEM_C    = 2'b11;

    localparam PRICE_A   = 8'd15;
    localparam PRICE_B   = 8'd25;
    localparam PRICE_C   = 8'd30;
    localparam MAX_BALANCE = 8'd99;

    reg [2:0] state, next_state;
    reg [7:0] item_price;
    reg [1:0] selected_item;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (coin != 2'b00)
                    next_state = ACCUMULATE;
                else if (cancel)
                    next_state = CHANGE;
            end
            ACCUMULATE: begin
                if (item_sel != 2'b00)
                    next_state = SELECT;
                else if (cancel)
                    next_state = CHANGE;
                else if (coin == 2'b00)
                    next_state = IDLE;
            end
            SELECT: begin
                if (balance >= item_price)
                    next_state = DISPENSE;
                else
                    next_state = ERROR_ST;
            end
            DISPENSE: begin
                next_state = CHANGE;
            end
            CHANGE: begin
                next_state = IDLE;
            end
            ERROR_ST: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            balance <= 8'd0;
            dispense <= 2'b00;
            change <= 8'd0;
            error <= 1'b0;
            item_price <= 8'd0;
            selected_item <= 2'b00;
            state_out <= IDLE;
        end else begin
            state_out <= state;
            case (state)
                IDLE: begin
                    dispense <= 2'b00;
                    change <= 8'd0;
                    error <= 1'b0;
                    if (coin != 2'b00) begin
                        case (coin)
                            COIN_5:  if (balance + 8'd5 <= MAX_BALANCE) balance <= balance + 8'd5;
                            COIN_10: if (balance + 8'd10 <= MAX_BALANCE) balance <= balance + 8'd10;
                            COIN_20: if (balance + 8'd20 <= MAX_BALANCE) balance <= balance + 8'd20;
                        endcase
                    end
                end
                ACCUMULATE: begin
                    if (coin != 2'b00) begin
                        case (coin)
                            COIN_5:  if (balance + 8'd5 <= MAX_BALANCE) balance <= balance + 8'd5;
                            COIN_10: if (balance + 8'd10 <= MAX_BALANCE) balance <= balance + 8'd10;
                            COIN_20: if (balance + 8'd20 <= MAX_BALANCE) balance <= balance + 8'd20;
                        endcase
                    end
                    if (item_sel != 2'b00) begin
                        selected_item <= item_sel;
                        case (item_sel)
                            ITEM_A: item_price <= PRICE_A;
                            ITEM_B: item_price <= PRICE_B;
                            ITEM_C: item_price <= PRICE_C;
                            default: item_price <= 8'd0;
                        endcase
                    end
                end
                SELECT: begin
                end
                DISPENSE: begin
                    dispense <= selected_item;
                    balance <= balance - item_price;
                end
                CHANGE: begin
                    change <= balance;
                    balance <= 8'd0;
                    dispense <= 2'b00;
                end
                ERROR_ST: begin
                    error <= 1'b1;
                    dispense <= 2'b00;
                end
            endcase
        end
    end

endmodule
