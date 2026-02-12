// SystemVerilog Testbench for 4-bit Counter
// verification/top_tb.sv

`timescale 1ns / 1ps

module top_tb;

    // Signals
    logic clk;
    logic rst_n;
    logic en;
    logic [3:0] count;

    // Device Under Test (DUT) Instantiation
    // Assuming a simple counter module exists: module counter_4bit (clk, rst_n, en, count);
    // If not, this serves as a template/demonstration of verification skills.
    counter_4bit dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .count(count)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Coverage Group
    covergroup cg_counter @(posedge clk);
        cp_count: coverpoint count {
            bins low = {[0:5]};
            bins mid = {[6:10]};
            bins high = {[11:15]};
            bins overflow = {15};
        }
        cp_en: coverpoint en;
        cross cp_count, cp_en;
    endgroup

    cg_counter cg_inst = new();

    // Assertions
    property p_counter_step;
        @(posedge clk) disable iff (!rst_n)
        (en && count != 4'hF) |=> (count == $past(count) + 1);
    endproperty

    assert_counter_step: assert property (p_counter_step)
        else $error("Assertion Failed: Counter did not increment correctly!");

    property p_counter_hold;
        @(posedge clk) disable iff (!rst_n)
        (!en) |=> (count == $past(count));
    endproperty

    assert_counter_hold: assert property (p_counter_hold)
        else $error("Assertion Failed: Counter did not hold value!");

    // Test Sequence
    initial begin
        // Initialize
        rst_n = 0;
        en = 0;
        
        // Reset
        #20;
        rst_n = 1;
        $display("[%0t] Reset released", $time);

        // Verification Scenario 1: Basic Counting
        en = 1;
        repeat(20) @(posedge clk); // Allow overflow
        
        // Verification Scenario 2: Enable Toggle
        en = 0;
        repeat(5) @(posedge clk);
        en = 1;
        repeat(5) @(posedge clk);

        // End Simulation
        #100;
        $display("Verification Complete. Coverage: %0.2f%%", cg_inst.get_inst_coverage());
        $finish;
    end

endmodule

// Dummy DUT for compilation if the actual one isn't linked
module counter_4bit (
    input logic clk,
    input logic rst_n,
    input logic en,
    output logic [3:0] count
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0;
        end else if (en) begin
            count <= count + 1;
        end
    end
endmodule
