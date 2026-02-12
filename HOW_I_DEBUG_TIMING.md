# 🐛 How I Debug Timing Violations

> **Philosophy:** "Systematic Triage" — derived from medical diagnosis: Reproduce → Analyze Evidence → Root Cause → Treatment (Fix) → Monitor (Verify).

---

## 1. Reproduce (The Setup)
First, I ensure the violation is real and reproducible, not a tool glitch.
- **Action:** Re-run Synthesis & Implementation with a fresh run directory.
- **Command:** `reset_run impl_1` then `launch_runs impl_1`

## 2. Evidence (The Triage)
I gather data to understand the severity.
- **WNS (Worst Negative Slack):** How bad is the violation? (e.g., -2.5ns on Setup)
- **TNS (Total Negative Slack):** Is it one path or the whole design?
- **Path Topology:** How many logic levels? High fanout?

**Tooling:**
Open **Vivado Timing Summary Report** or use Tcl:
```tcl
report_timing_summary -file reports/debug_timing.rpt -delay_type min_max -max_paths 10
```

## 3. Root Cause Analysis (The Diagnosis)
I categorize the violation into one of three buckets:

| Category | Symptoms | Investigation Tool |
|----------|----------|-------------------|
| **Logic Depth** | Too many LUTs/Levels between registers (e.g., > 15 levels for 125MHz). | `report_design_analysis -logic_level_distribution` |
| **Congestion** | High fanout nets, tangled routing in small area. | `report_utilization -hierarchical` |
| **Constraints** | Missing False Path, CDC, or over-constrained clock. | `report_methodology` |

**Example Finding:**
*“Path from `ctrl_FSM/state_reg` to `alu_mod/result_reg` has 18 logic levels. Target period is 8ns (125MHz). Slack is -1.2ns.”*

## 4. Fix (The Treatment)
Apply the least invasive fix first.

**Strategy A: Constraint Fix (If applicable)**
If it's a CDC path or static config register:
```tcl
set_false_path -from [get_pins {config_reg[*]}] -to [get_pins {target_logic[*]}]
```

**Strategy B: Implementation Strategy**
Let the tool try harder (Good for small violations warnings < -0.5ns:
```tcl
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
set_property DIRECTIVE Explore [get_runs impl_1]
```

**Strategy C: RTL Code Change (The Surgery)**
For Logic Depth issues (The most common real issue):
- **Pipelining:** Insert a register stage to break the long combo path.
  ```verilog
  // Before
  always @(posedge clk) result <= (a * b) + c;
  
  // After (2-stage pipeline)
  always @(posedge clk) begin
      mult_reg <= a * b;
      result <= mult_reg + c;
  end
  ```

## 5. Verify (The Discharge)
Re-run implementation and check Timing Summary again.
- **Goal:** WNS > 0.000ns.
- **Final Check:** `report_timing_summary` returns "Assessment: PASSED".

---

### 🧰 My Debug Toolkit (Tcl Snippets)

**Get failing paths:**
```tcl
get_timing_paths -max_paths 10 -nworst 1 -slack_lesser_than 0
```

**Check clock interaction (CDC):**
```tcl
report_clock_interaction -delay_type min_max
```
