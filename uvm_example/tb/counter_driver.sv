//=============================================================================
// UVM Driver: Converts sequence items to pin-level stimulus
//=============================================================================

class counter_driver extends uvm_driver #(counter_seq_item);
    `uvm_component_utils(counter_driver)

    virtual counter_if vif;

    function new(string name = "counter_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual counter_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "Failed to get virtual interface from config_db")
    endfunction

    task run_phase(uvm_phase phase);
        counter_seq_item item;
        forever begin
            seq_item_port.get_next_item(item);
            drive_item(item);
            seq_item_port.item_done();
        end
    endtask

    task drive_item(counter_seq_item item);
        repeat (item.num_cycles) begin
            @(posedge vif.clk);
            vif.driver_cb.rst_n  <= item.rst_n;
            vif.driver_cb.enable <= item.enable;
        end
        `uvm_info("DRV", $sformatf("Drove: %s", item.convert2string()), UVM_MEDIUM)
    endtask

endclass
