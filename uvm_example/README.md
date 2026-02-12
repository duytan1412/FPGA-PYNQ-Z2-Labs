# Mini-UVM Example: 4-bit Counter Verification

A minimal but complete **UVM (Universal Verification Methodology)** testbench demonstrating industry-standard verification flow.

---

## 🎯 Purpose

This example proves understanding of the **UVM framework** used by Synopsys, Cadence, and Mentor tools for chip verification. It contains:

- **DUT**: Simple 4-bit up-counter (`counter.sv`)
- **UVM Testbench**: Complete environment with Driver, Monitor, Scoreboard
- **Coverage**: Functional coverage for all counter values
- **Constrained Random**: Randomized reset sequences

---

## 📂 Structure

```
uvm_example/
├── rtl/
│   └── counter.sv          # Design Under Test (4-bit counter)
├── tb/
│   ├── counter_pkg.sv      # UVM package (all components)
│   ├── counter_if.sv       # Virtual interface
│   ├── counter_seq.sv      # Sequence & Sequence Item
│   ├── counter_driver.sv   # UVM Driver
│   ├── counter_monitor.sv  # UVM Monitor
│   ├── counter_scoreboard.sv # UVM Scoreboard (self-checking)
│   ├── counter_env.sv      # UVM Environment
│   └── counter_test.sv     # UVM Test (top-level)
├── top/
│   └── tb_top.sv           # Top-level testbench module
├── run_sim.sh              # VCS/Questa run script
└── README.md               # This file
```

---

## 🚀 How to Run

### Using VCS (Synopsys)
```bash
vcs -sverilog -ntb_opts uvm-1.2 \
    rtl/counter.sv \
    tb/counter_if.sv tb/counter_pkg.sv \
    top/tb_top.sv \
    -o simv
./simv +UVM_TESTNAME=counter_test
```

### Using Questa (Mentor)
```bash
vlog -sv +incdir+$UVM_HOME/src rtl/counter.sv tb/*.sv top/tb_top.sv
vsim -c tb_top +UVM_TESTNAME=counter_test -do "run -all"
```

### Using Vivado XSIM (Free - No license needed)
```bash
xvlog -sv rtl/counter.sv tb/*.sv top/tb_top.sv
xelab tb_top -s sim_snapshot
xsim sim_snapshot -R
```

> **Note:** This example is designed to compile and run on any SystemVerilog simulator. UVM library is included with VCS/Questa. For Vivado XSIM, simplified self-checking (non-UVM) mode is also supported.

---

## 📊 Expected Output

```
UVM_INFO @ 0: reporter [RNTST] Running test counter_test...
UVM_INFO @ 10: uvm_test_top.env.scoreboard [SCB] Reset detected. Counter cleared.
UVM_INFO @ 50: uvm_test_top.env.scoreboard [SCB] PASS: Expected=1, Got=1
UVM_INFO @ 70: uvm_test_top.env.scoreboard [SCB] PASS: Expected=2, Got=2
...
UVM_INFO @ 330: uvm_test_top.env.scoreboard [SCB] PASS: Expected=15, Got=15
UVM_INFO @ 350: uvm_test_top.env.scoreboard [SCB] PASS: Rollover Expected=0, Got=0
UVM_INFO @ 500: reporter [COVERAGE] Functional Coverage: 100%

--- UVM Report Summary ---
** Report counts by severity
UVM_INFO :   48
UVM_WARNING :    0
UVM_ERROR :    0
UVM_FATAL :    0
** Report counts by id
[SCB]     32
[COVERAGE]  1
*** UVM TEST PASSED ***
```

---

## 💡 Key Concepts Demonstrated

| UVM Concept | Implementation | Why It Matters |
|-------------|---------------|----------------|
| **Virtual Interface** | `counter_if.sv` | Connects TB to DUT without hardcoding |
| **Sequence Item** | `counter_seq.sv` | Transaction-level modeling (TLM) |
| **Driver** | `counter_driver.sv` | Converts transactions to pin wiggles |
| **Monitor** | `counter_monitor.sv` | Passive observation of DUT signals |
| **Scoreboard** | `counter_scoreboard.sv` | Automated checking (reference model) |
| **Coverage** | `counter_env.sv` | Proves completeness of verification |
| **Factory** | `counter_test.sv` | Run-time test selection |
