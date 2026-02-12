`timescale 1ns / 1ps
//=============================================================================
// Interface: counter_if
// Description: Virtual interface for UVM testbench <-> DUT connection
//=============================================================================
interface counter_if (input logic clk);
    logic        rst_n;
    logic        enable;
    logic [3:0]  count;
    logic        overflow;

    // Driver clocking block (drives inputs)
    clocking driver_cb @(posedge clk);
        default input #1 output #1;
        output rst_n;
        output enable;
        input  count;
        input  overflow;
    endclocking

    // Monitor clocking block (samples outputs)
    clocking monitor_cb @(posedge clk);
        default input #1;
        input rst_n;
        input enable;
        input count;
        input overflow;
    endclocking

    // Modport for driver
    modport DRIVER (clocking driver_cb, input clk);
    // Modport for monitor
    modport MONITOR (clocking monitor_cb, input clk);

endinterface
