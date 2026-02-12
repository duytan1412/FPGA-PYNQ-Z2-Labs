//=============================================================================
// UVM Environment: Assembles all components
//=============================================================================

class counter_env extends uvm_env;
    `uvm_component_utils(counter_env)

    counter_driver      driver;
    counter_monitor     monitor;
    counter_scoreboard  scoreboard;

    // Functional Coverage
    covergroup counter_cg with function sample(logic [3:0] count, logic overflow);
        cp_count: coverpoint count {
            bins low    = {[0:3]};
            bins mid    = {[4:11]};
            bins high   = {[12:14]};
            bins max    = {15};
        }
        cp_overflow: coverpoint overflow {
            bins no_overflow = {0};
            bins overflow    = {1};
        }
        cross_count_overflow: cross cp_count, cp_overflow;
    endgroup

    function new(string name = "counter_env", uvm_component parent);
        super.new(name, parent);
        counter_cg = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver     = counter_driver::type_id::create("driver", this);
        monitor    = counter_monitor::type_id::create("monitor", this);
        scoreboard = counter_scoreboard::type_id::create("scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect monitor's analysis port to scoreboard
        monitor.ap.connect(scoreboard.ap);
    endfunction

    // Sample coverage when monitor observes transactions
    function void sample_coverage(logic [3:0] count, logic overflow);
        counter_cg.sample(count, overflow);
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("COVERAGE", $sformatf("Functional Coverage: %.1f%%",
                  counter_cg.get_coverage()), UVM_NONE)
    endfunction

endclass
