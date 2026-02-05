`timescale 1ns / 1ps

module tb_vending_machine;

    reg        clk;
    reg        reset;
    reg  [1:0] coin;
    reg  [1:0] item_sel;
    reg        cancel;
    wire [7:0] balance;
    wire [1:0] dispense;
    wire [7:0] change;
    wire       error;
    wire [2:0] state_out;

    integer pass_count;
    integer fail_count;
    integer test_num;

    vending_machine uut (
        .clk(clk),
        .reset(reset),
        .coin(coin),
        .item_sel(item_sel),
        .cancel(cancel),
        .balance(balance),
        .dispense(dispense),
        .change(change),
        .error(error),
        .state_out(state_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task check_result;
        input [7:0] exp_balance;
        input [1:0] exp_dispense;
        input [7:0] exp_change;
        input       exp_error;
        input [255:0] test_name;
        begin
            #1;
            if (balance == exp_balance && dispense == exp_dispense && 
                change == exp_change && error == exp_error) begin
                $display("[PASS] Test %0d: %s", test_num, test_name);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] Test %0d: %s", test_num, test_name);
                $display("       Expected: bal=%0d, disp=%0d, chg=%0d, err=%0d", 
                         exp_balance, exp_dispense, exp_change, exp_error);
                $display("       Got:      bal=%0d, disp=%0d, chg=%0d, err=%0d", 
                         balance, dispense, change, error);
                fail_count = fail_count + 1;
            end
            test_num = test_num + 1;
        end
    endtask

    initial begin
        pass_count = 0;
        fail_count = 0;
        test_num = 1;
        
        reset = 1;
        coin = 2'b00;
        item_sel = 2'b00;
        cancel = 0;
        #20;
        reset = 0;
        #10;
        
        $display("\n========== VENDING MACHINE TESTBENCH ==========\n");

        $display("--- Test 1: Insert Coin 10, Buy Item A (15), Insufficient ---");
        coin = 2'b10; #10; coin = 2'b00; #10;
        item_sel = 2'b01; #10; item_sel = 2'b00; #20;
        check_result(0, 0, 0, 1, "Insufficient funds for Item A");
        #20;

        reset = 1; #10; reset = 0; #10;

        $display("--- Test 2: Insert 20, Buy Item A (15), Get Change 5 ---");
        coin = 2'b11; #10; coin = 2'b00; #10;
        item_sel = 2'b01; #10; item_sel = 2'b00; #30;
        check_result(0, 0, 5, 0, "Buy Item A with change");
        #20;

        reset = 1; #10; reset = 0; #10;

        $display("--- Test 3: Insert 10+10+10=30, Buy Item C (30), Exact ---");
        coin = 2'b10; #10; coin = 2'b00; #10;
        coin = 2'b10; #10; coin = 2'b00; #10;
        coin = 2'b10; #10; coin = 2'b00; #10;
        item_sel = 2'b11; #10; item_sel = 2'b00; #30;
        check_result(0, 0, 0, 0, "Buy Item C exact change");
        #20;

        reset = 1; #10; reset = 0; #10;

        $display("--- Test 4: Cancel with Zero Balance ---");
        cancel = 1; #10; cancel = 0; #20;
        check_result(0, 0, 0, 0, "Cancel with zero balance");
        #20;

        reset = 1; #10; reset = 0; #10;

        $display("--- Test 5: Insert 5+10=15, Cancel, Get Refund ---");
        coin = 2'b01; #10; coin = 2'b00; #10;
        coin = 2'b10; #10; coin = 2'b00; #10;
        cancel = 1; #10; cancel = 0; #30;
        check_result(0, 0, 15, 0, "Cancel and get refund");
        #20;

        reset = 1; #10; reset = 0; #10;

        $display("--- Test 6: Rapid Coin Insertion (Overflow Protection) ---");
        coin = 2'b11; #10;
        coin = 2'b11; #10;
        coin = 2'b11; #10;
        coin = 2'b11; #10;
        coin = 2'b11; #10;
        coin = 2'b00; #10;
        if (balance <= 99)
            $display("[PASS] Test %0d: Overflow protection (bal=%0d <= 99)", test_num, balance);
        else
            $display("[FAIL] Test %0d: Overflow detected (bal=%0d > 99)", test_num, balance);
        test_num = test_num + 1;
        #20;

        reset = 1; #10; reset = 0; #10;

        $display("--- Test 7: Select Item Without Inserting Coin ---");
        item_sel = 2'b10; #10; item_sel = 2'b00; #30;
        check_result(0, 0, 0, 1, "No coin, select item B -> error");
        #20;

        reset = 1; #10; reset = 0; #10;

        $display("--- Test 8: Reset Mid-Transaction ---");
        coin = 2'b11; #10; coin = 2'b00; #10;
        reset = 1; #10; reset = 0; #10;
        check_result(0, 0, 0, 0, "Reset clears balance");
        #20;

        $display("\n========== TEST SUMMARY ==========");
        $display("Total Tests: %0d", pass_count + fail_count);
        $display("Passed: %0d", pass_count);
        $display("Failed: %0d", fail_count);
        $display("==================================\n");

        if (fail_count == 0)
            $display("*** ALL TESTS PASSED! ***\n");
        else
            $display("*** SOME TESTS FAILED! ***\n");

        $finish;
    end

endmodule
