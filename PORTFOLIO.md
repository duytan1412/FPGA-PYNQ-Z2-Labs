# Scholarship Portfolio Summary

## IC Design Relevance
This repository demonstrates RTL design fundamentals, self-checking simulation, FPGA constraints, and Vivado timing-closure analysis. It supports an IC Design / Design Verification application by showing practical Verilog implementation and timing-debug discipline.

## Project Scope
- Board target: Xilinx PYNQ-Z2 / Zynq-7000 flow.
- Primary showcased design: `04_Vending_Machine`, a 6-state Moore FSM controller.
- Verification: self-checking Verilog testbench with 8 pass/fail scenarios.
- Timing evidence: Vivado timing summary with WNS = +3.889 ns, WHS = +0.152 ns, and 0 failing endpoints.
- Automation: Tcl timing/utilization report generation and Python timing-report parsing.

## Evidence Map
| Evidence | File |
| --- | --- |
| FSM RTL | `04_Vending_Machine/vending_machine.v` |
| Self-checking testbench | `04_Vending_Machine/tb_vending_machine.v` |
| Timing report screenshot | `docs/timing_report.png` |
| Timing parser | `tools/collect_timing.py` |
| Vivado Tcl report flow | `tools/report_timing.tcl` |
| Timing-debug notes | `HOW_I_DEBUG_TIMING.md` |

## Scholarship Positioning
For Synopsys IC Design Scholarship review, this project should be presented as foundational RTL and timing-closure evidence. It complements the AMBA APB and AXI4-Lite UVM repositories by showing that the applicant understands synthesizable RTL, constraints, timing reports, and waveform-driven debugging.

## Current Limitation
Hardware bring-up is documented as FPGA-targeted, but final scholarship claims should emphasize simulation, Vivado reports, and timing evidence unless physical PYNQ-Z2 board measurements are available.
