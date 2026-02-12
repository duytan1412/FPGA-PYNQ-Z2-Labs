//=============================================================================
// UVM Monitor: Passively observes DUT outputs
//=============================================================================

class counter_monitor extends uvm_monitor;
    `uvm_component_utils(counter_monitor)

    virtual counter_if vif;
    uvm_analysis_port #(counter_seq_item) ap;  // Broadcast to scoreboard

    function new(string name = "counter_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db#(virtual counter_if)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "Failed to get virtual interface from config_db")
    endfunction

    task run_phase(uvm_phase phase);
        counter_seq_item item;
        forever begin
            @(posedge vif.clk);
            item = counter_seq_item::type_id::create("item");
            item.rst_n    = vif.monitor_cb.rst_n;
            item.enable   = vif.monitor_cb.enable;
            item.count    = vif.monitor_cb.count;
            item.overflow = vif.monitor_cb.overflow;
            ap.write(item);  // Broadcast to scoreboard
        end
    endtask

endclass
