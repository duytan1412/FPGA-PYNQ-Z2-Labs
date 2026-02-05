`timescale 1ns / 1ps

//=============================================================================
// Module: vending_machine
// Description: Smart Vending Machine Controller using Moore FSM
// Author: Bi Duy Tan - FPT Jetking Academy
//=============================================================================

module vending_machine(
    input        clk,           // System clock
    input        reset,         // Async reset (active high)
    input  [1:0] coin,          // Coin input: 01=5, 10=10, 11=20
    input  [1:0] item_sel,      // Item select: 01=A, 10=B, 11=C
    input        cancel,        // Cancel transaction
    output reg [7:0] balance,   // Current balance
    output reg [1:0] dispense,  // Item being dispensed
    output reg [7:0] change,    // Change to return
    output reg       error,     // Error flag (insufficient funds)
    output reg [2:0] state_out  // Current state (for debug)
);

    //=========================================================================
    // State Definition (Moore Machine - 6 states)
    //=========================================================================
    localparam IDLE      = 3'b000;  // Waiting for coin
    localparam ACCUMULATE = 3'b001; // Accumulating coins
    localparam SELECT    = 3'b010;  // Processing item selection
    localparam DISPENSE  = 3'b011;  // Dispensing item
    localparam CHANGE    = 3'b100;  // Returning change
    localparam ERROR_ST  = 3'b101;  // Error state (insufficient funds)

    //=========================================================================
    // Coin Value Definition
    //=========================================================================
    localparam COIN_5    = 2'b01;   // 5 units
    localparam COIN_10   = 2'b10;   // 10 units
    localparam COIN_20   = 2'b11;   // 20 units

    //=========================================================================
    // Item Definition
    //=========================================================================
    localparam ITEM_A    = 2'b01;   // Item A
    localparam ITEM_B    = 2'b10;   // Item B
    localparam ITEM_C    = 2'b11;   // Item C

    //=========================================================================
    // Price Definition
    //=========================================================================
    localparam PRICE_A   = 8'd15;   // Item A costs 15
    localparam PRICE_B   = 8'd25;   // Item B costs 25
    localparam PRICE_C   = 8'd30;   // Item C costs 30
    localparam MAX_BALANCE = 8'd99; // Overflow protection

    //=========================================================================
    // Internal Registers
    //=========================================================================
    reg [2:0] state, next_state;    // Current and next state
    reg [7:0] item_price;           // Selected item price
    reg [1:0] selected_item;        // Selected item ID

    //=========================================================================
    // State Register (Sequential Logic)
    //=========================================================================
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    //=========================================================================
    // Next State Logic (Combinational Logic)
    //=========================================================================
    always @(*) begin
        next_state = state;  // Default: stay in current state
        
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

    //=========================================================================
    // Output Logic (Sequential - Moore Machine)
    //=========================================================================
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all outputs
            balance <= 8'd0;
            dispense <= 2'b00;
            change <= 8'd0;
            error <= 1'b0;
            item_price <= 8'd0;
            selected_item <= 2'b00;
            state_out <= IDLE;
        end else begin
            state_out <= state;  // Debug output
            
            case (state)
                //-------------------------------------------------------------
                // IDLE State: Wait for coin insertion
                //-------------------------------------------------------------
                IDLE: begin
                    dispense <= 2'b00;
                    change <= 8'd0;
                    error <= 1'b0;
                    
                    // Add coin to balance
                    if (coin != 2'b00) begin
                        case (coin)
                            COIN_5:  if (balance + 8'd5 <= MAX_BALANCE) balance <= balance + 8'd5;
                            COIN_10: if (balance + 8'd10 <= MAX_BALANCE) balance <= balance + 8'd10;
                            COIN_20: if (balance + 8'd20 <= MAX_BALANCE) balance <= balance + 8'd20;
                        endcase
                    end
                end
                
                //-------------------------------------------------------------
                // ACCUMULATE State: Continue adding coins
                //-------------------------------------------------------------
                ACCUMULATE: begin
                    // Add more coins
                    if (coin != 2'b00) begin
                        case (coin)
                            COIN_5:  if (balance + 8'd5 <= MAX_BALANCE) balance <= balance + 8'd5;
                            COIN_10: if (balance + 8'd10 <= MAX_BALANCE) balance <= balance + 8'd10;
                            COIN_20: if (balance + 8'd20 <= MAX_BALANCE) balance <= balance + 8'd20;
                        endcase
                    end
                    
                    // Store selected item and price
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
                
                //-------------------------------------------------------------
                // SELECT State: Check if enough balance
                //-------------------------------------------------------------
                SELECT: begin
                    // Decision made in next_state logic
                end
                
                //-------------------------------------------------------------
                // DISPENSE State: Output the item
                //-------------------------------------------------------------
                DISPENSE: begin
                    dispense <= selected_item;
                    balance <= balance - item_price;  // Subtract price (ALU)
                end
                
                //-------------------------------------------------------------
                // CHANGE State: Return remaining balance
                //-------------------------------------------------------------
                CHANGE: begin
                    change <= balance;    // Return all balance as change
                    balance <= 8'd0;      // Clear balance
                    dispense <= 2'b00;    // Clear dispense
                end
                
                //-------------------------------------------------------------
                // ERROR State: Insufficient funds
                //-------------------------------------------------------------
                ERROR_ST: begin
                    error <= 1'b1;        // Set error flag
                    dispense <= 2'b00;    // No dispense
                end
            endcase
        end
    end

endmodule
