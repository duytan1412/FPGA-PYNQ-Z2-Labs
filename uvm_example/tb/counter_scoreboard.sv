//=============================================================================
// UVM Scoreboard: Reference model + automated checking
//=============================================================================

class counter_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(counter_scoreboard)

    uvm_analysis_imp #(counter_seq_item, counter_scoreboard) ap;

    // Reference model state
    logic [3:0] expected_count;
    int pass_count;
    int fail_count;

    function new(string name = "counter_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        expected_count = 4'b0000;
        pass_count = 0;
        fail_count = 0;
    endfunction

    // Called every time monitor broadcasts a transaction
    function void write(counter_seq_item item);
        if (!item.rst_n) begin
            // Reset: clear reference model
            expected_count = 4'b0000;
            `uvm_info("SCB", "Reset detected. Counter cleared.", UVM_MEDIUM)
            return;
        end

        if (item.enable) begin
            // Reference model: predict next count
            if (item.count == expected_count) begin
                `uvm_info("SCB", $sformatf("PASS: Expected=%0h, Got=%0h",
                          expected_count, item.count), UVM_MEDIUM)
                pass_count++;
            end else begin
                `uvm_error("SCB", $sformatf("FAIL: Expected=%0h, Got=%0h",
                           expected_count, item.count))
                fail_count++;
            end

            // Update reference model for next cycle
            expected_count = (expected_count == 4'hF) ? 4'h0 : expected_count + 1;
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCB", $sformatf("\n========== SCOREBOARD SUMMARY =========="), UVM_NONE)
        `uvm_info("SCB", $sformatf("  Total Checks: %0d", pass_count + fail_count), UVM_NONE)
        `uvm_info("SCB", $sformatf("  Passed:       %0d", pass_count), UVM_NONE)
        `uvm_info("SCB", $sformatf("  Failed:       %0d", fail_count), UVM_NONE)
        `uvm_info("SCB", $sformatf("=========================================="), UVM_NONE)
    endfunction

endclass
