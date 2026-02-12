//=============================================================================
// UVM Package: Imports all components
//=============================================================================

package counter_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "counter_seq.sv"
    `include "counter_driver.sv"
    `include "counter_monitor.sv"
    `include "counter_scoreboard.sv"
    `include "counter_env.sv"
    `include "counter_test.sv"
endpackage
