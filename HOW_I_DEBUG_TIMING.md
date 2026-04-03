# My Notes: Fixing Timing Violations

When I run into timing issues in Vivado (WNS < 0), here's the workflow I use to debug and fix them.

## 1. Checking the Evidence
First, I verify the violation isn't a one-off tool glitch by resetting the runs.
- **Tools:** Use **Timing Summary Report** or Tcl:
```tcl
report_timing_summary -max_paths 10 -nworst 1 -file reports/timing_debug.rpt
```
- **What to look for:**
  - **WNS (Worst Negative Slack):** Magnitude of the violation.
  - **Logic Levels:** Anything > 10-12 levels for 100MHz+ usually needs pipelining.
  - **Fanout:** High fanout nets can cause routing congestion.

## 2. Common Root Causes
I usually check these three areas first:

| Issue | Tool to use |
|-------|-------------|
| **Logic Depth** | `report_design_analysis -logic_level_distribution` |
| **Congestion** | `report_utilization -hierarchical` |
| **CDC / Constraints** | `report_methodology` |

Example: If a path has 15+ LUTs between registers, it won't meet timing at 125MHz.

## 3. How to Fix

### A. Vivado Implementation Strategies
For small violations (WNS > -0.5ns), the tool might find a solution with better directives:
```tcl
set_property DIRECTIVE Explore [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
```

### B. Constraints (False Paths / Multi-cycle)
If it's a cross-clock domain (CDC) path or a static config register, I apply a false path constraint:
```tcl
set_false_path -from [get_pins {config_reg[*]}] -to [get_pins {data_reg[*]}]
```

### C. RTL Changes (Pipelining)
This is the most common fix for real logic depth issues. I break the long combinatorial path by adding a register stage.
```verilog
// Long path
always @(posedge clk) out <= (a * b) + c;

// Pipelined (2 cycles)
always @(posedge clk) begin
    mult_res <= a * b;
    out <= mult_res + c;
end
```

## 4. Useful Tcl Snippets

**List 10 worst failing paths:**
```tcl
get_timing_paths -max_paths 10 -slack_lesser_than 0
```

**Check clock crossings:**
```tcl
report_clock_interaction -delay_type min_max
```
