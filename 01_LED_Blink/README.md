# LED Blink

Minimal PYNQ-Z2 RTL lab for clock division and LED output control.

## Recruiter Quick View

| Item | Link |
|---|---|
| Top RTL | [`led_blink.v`](./led_blink.v) |
| Clock divider | [`clk_divider.v`](./clk_divider.v) |
| Testbench | [`tb_led_blink.v`](./tb_led_blink.v) |
| Constraints | [`constraints.xdc`](./constraints.xdc) |

## What This Demonstrates

- Verilog module decomposition.
- Counter-based clock division.
- Basic self-checking simulation structure.
- PYNQ-Z2 pin constraint usage.

## Run

```powershell
..\scripts\run_sim.ps1 -Lab led
```
