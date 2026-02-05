# Smart Vending Machine Controller

A Moore FSM-based vending machine controller demonstrating complex state machine design.

## Features

- **6 States**: IDLE, ACCUMULATE, SELECT, DISPENSE, CHANGE, ERROR
- **3 Coin Types**: 5, 10, 20 units
- **3 Items**: A (15), B (25), C (30)
- **Overflow Protection**: Max balance 99
- **Cancel/Refund**: Return all coins

## State Diagram

```
         ┌─────────────────────────────────────┐
         │                                     │
         ▼                                     │
    ┌─────────┐     coin     ┌────────────┐    │
    │  IDLE   │─────────────▶│ ACCUMULATE │    │
    └────┬────┘              └─────┬──────┘    │
         │                         │           │
         │ cancel                  │ item_sel  │
         │                         ▼           │
         │                   ┌──────────┐      │
         │                   │  SELECT  │      │
         │                   └────┬─────┘      │
         │              ┌─────────┴─────────┐  │
         │              │                   │  │
         │     balance >= price     balance < price
         │              │                   │  │
         │              ▼                   ▼  │
         │        ┌──────────┐       ┌─────────┐
         │        │ DISPENSE │       │  ERROR  │
         │        └────┬─────┘       └────┬────┘
         │             │                  │    │
         │             ▼                  │    │
         │        ┌──────────┐            │    │
         └───────▶│  CHANGE  │◀───────────┘    │
                  └────┬─────┘                 │
                       │                       │
                       └───────────────────────┘
```

## I/O Signals

| Signal    | Width | Direction | Description              |
|-----------|-------|-----------|--------------------------|
| clk       | 1     | Input     | System clock             |
| reset     | 1     | Input     | Async reset              |
| coin      | 2     | Input     | 01=5, 10=10, 11=20       |
| item_sel  | 2     | Input     | 01=A, 10=B, 11=C         |
| cancel    | 1     | Input     | Cancel transaction       |
| balance   | 8     | Output    | Current balance          |
| dispense  | 2     | Output    | Item being dispensed     |
| change    | 8     | Output    | Change returned          |
| error     | 1     | Output    | Insufficient funds flag  |
| state_out | 3     | Output    | Current state for debug  |

## Testbench Scenarios

| # | Scenario                          | Expected Result        |
|---|-----------------------------------|------------------------|
| 1 | Insert 10, Buy A (15)             | Error (insufficient)   |
| 2 | Insert 20, Buy A (15)             | Dispense A, Change 5   |
| 3 | Insert 30, Buy C (30)             | Dispense C, Change 0   |
| 4 | Cancel with zero balance          | No change returned     |
| 5 | Insert 15, Cancel                 | Refund 15              |
| 6 | Rapid coin insertion              | Balance <= 99          |
| 7 | Select item without coin          | Error                  |
| 8 | Reset mid-transaction             | Balance cleared        |

## How to Simulate

1. Open Vivado
2. Create a simulation-only project
3. Add `vending_machine.v` and `tb_vending_machine.v`
4. Run Behavioral Simulation
5. Check console for PASS/FAIL results
