# Simulation Pass vs Timing Pass

## Core Difference

Simulation proves behavior under the written testbench. Timing pass proves the implemented netlist can meet clock and IO requirements after synthesis/place/route constraints.

## What Simulation Can Miss

- excessive combinational depth;
- high fanout control paths;
- unsafe CDC or reset release;
- missing IO constraints;
- board-level setup/hold assumptions;
- generated clock or clock-group mistakes.

## Evidence Flow

| Step | Artifact | Question |
|---|---|---|
| RTL simulation | testbench log/waveform | does intended behavior work? |
| constraint review | XDC | does tool know clocks and IO timing? |
| timing summary | WNS/TNS/path report | can implementation meet clock? |
| path triage | worst paths | logic depth, routing, fanout, CDC, false path? |
| fix | RTL or constraints | pipeline real logic; constrain only justified paths |

## Interview Answer Template

Simulation pass does not mean FPGA hardware pass. I also check constraints, timing summary, reset/CDC handling, IO timing, and board behavior. If timing fails, I first inspect WNS, logic levels, fanout, and clock crossings before changing RTL or constraints.
