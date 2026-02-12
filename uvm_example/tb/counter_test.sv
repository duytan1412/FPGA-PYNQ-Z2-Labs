//=============================================================================
// UVM Test: Top-level test class
//=============================================================================

class counter_test extends uvm_test;
    `uvm_component_utils(counter_test)

    counter_env env;

    function new(string name = "counter_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = counter_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        counter_base_seq seq;

        phase.raise_objection(this, "Starting counter_test");

        seq = counter_base_seq::type_id::create("seq");
        seq.num_transactions = 50;  // 50 randomized transactions
        seq.start(env.driver.seq_item_port);

        // Allow pipeline to drain
        #100;

        phase.drop_objection(this, "Finished counter_test");
    endtask

endclass
