# Button Up/Down Counter

PYNQ-Z2 button-controlled counter lab with debouncing and 7-segment display output.

## Recruiter Quick View

| Item | Link |
|---|---|
| Top RTL | [`top.v`](./top.v) |
| Counter | [`counter_4bit.v`](./counter_4bit.v) |
| Debounce options | [`btn_debounce.v`](./btn_debounce.v), [`debounce.v`](./debounce.v) |
| Display driver | [`seg7_led.v`](./seg7_led.v) |
| Testbenches | [`tb_way1.v`](./tb_way1.v), [`tb_way2.v`](./tb_way2.v) |

## What This Demonstrates

- Button synchronization/debounce design.
- Counter control logic.
- Alternative implementation comparison through two testbenches.

## Run

```powershell
..\scripts\run_sim.ps1 -Lab button
```
