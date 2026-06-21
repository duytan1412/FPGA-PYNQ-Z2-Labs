# 7-Segment Counter

PYNQ-Z2 7-segment display lab demonstrating multiplexing, digit extraction, and a slow tick generator.

## Recruiter Quick View

| Item | Link |
|---|---|
| Top RTL | [`top.v`](./top.v) |
| Segment controller | [`seg7_control.v`](./seg7_control.v) |
| Digit logic | [`digits.v`](./digits.v) |
| Tick generator | [`tenHz_gen.v`](./tenHz_gen.v) |
| Constraints | [`constraints_pynq_z2.xdc`](./constraints_pynq_z2.xdc) |

## What This Demonstrates

- Display multiplexing and timing control.
- Modular RTL composition.
- FPGA board I/O constraints.

## Run

This lab is board-oriented and does not currently include a committed testbench. Use Vivado for synthesis/implementation and board bring-up.
