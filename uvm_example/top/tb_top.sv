`timescale 1ns / 1ps
//=============================================================================
// Top-Level Testbench: Connects DUT to UVM environment
//=============================================================================
import uvm_pkg::*;
`include "uvm_macros.svh"

import counter_pkg::*;

module tb_top;

    //=========================================================================
    // Clock Generation
    //=========================================================================
    logic clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz
    end

    //=========================================================================
    // Interface Instance
    //=========================================================================
    counter_if cif(clk);

    //=========================================================================
    // DUT Instance
    //=========================================================================
    counter dut (
        .clk      (clk),
        .rst_n    (cif.rst_n),
        .enable   (cif.enable),
        .count    (cif.count),
        .overflow (cif.overflow)
    );

    //=========================================================================
    // UVM Configuration & Test Launch
    //=========================================================================
    initial begin
        // Pass virtual interface to UVM config_db
        uvm_config_db#(virtual counter_if)::set(null, "*", "vif", cif);

        // Dump waveforms (for debugging)
        $dumpfile("counter_tb.vcd");
        $dumpvars(0, tb_top);

        // Start UVM test
        run_test("counter_test");
    end

    // Timeout watchdog
    initial begin
        #100_000;
        `uvm_fatal("TIMEOUT", "Simulation timed out after 100us")
    end

endmodule
