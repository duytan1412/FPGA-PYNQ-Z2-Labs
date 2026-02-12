//=============================================================================
// UVM Sequence Item & Sequence for Counter
//=============================================================================

class counter_seq_item extends uvm_sequence_item;
    `uvm_object_utils(counter_seq_item)

    // Randomized fields
    rand bit        rst_n;
    rand bit        enable;
    rand int        num_cycles;   // How many cycles to apply this stimulus

    // Observed fields (filled by monitor)
    logic [3:0]     count;
    logic           overflow;

    // Constraints
    constraint c_cycles  { num_cycles inside {[1:10]}; }
    constraint c_reset   { rst_n dist {1 := 90, 0 := 10}; }  // 10% chance of reset
    constraint c_enable  { enable dist {1 := 80, 0 := 20}; }  // 80% enabled

    function new(string name = "counter_seq_item");
        super.new(name);
    endfunction

    function string convert2string();
        return $sformatf("rst_n=%0b enable=%0b cycles=%0d count=%0h overflow=%0b",
                         rst_n, enable, num_cycles, count, overflow);
    endfunction
endclass


//=============================================================================
// Basic Test Sequence: Apply random stimulus
//=============================================================================
class counter_base_seq extends uvm_sequence #(counter_seq_item);
    `uvm_object_utils(counter_base_seq)

    int num_transactions = 20;

    function new(string name = "counter_base_seq");
        super.new(name);
    endfunction

    task body();
        counter_seq_item item;

        // Initial reset
        item = counter_seq_item::type_id::create("item");
        start_item(item);
        item.rst_n = 0;
        item.enable = 0;
        item.num_cycles = 2;
        finish_item(item);

        // Random stimulus
        repeat (num_transactions) begin
            item = counter_seq_item::type_id::create("item");
            start_item(item);
            assert(item.randomize()) else `uvm_fatal("SEQ", "Randomization failed!")
            finish_item(item);
        end
    endtask
endclass
