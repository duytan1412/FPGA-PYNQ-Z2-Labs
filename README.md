# FPGA-PYNQ-Z2-Labs

A collection of FPGA lab projects developed on **Xilinx PYNQ-Z2** board using **Vivado**.

---

## 🎯 Highlight Project: Smart Vending Machine FSM

> **6-state Moore FSM Controller** with Self-Checking Testbench

**Key Features:**
- 6-state Moore FSM: `IDLE → ACCUMULATE → SELECT → DISPENSE → CHANGE → ERROR`
- Self-Checking Testbench with 8 corner case scenarios
- 100% logic verification via automated PASS/FAIL output

### Simulation Waveform (Vivado)
![Vending Machine Waveform](./04_Vending_Machine/docs/waveform_simulation.png)
*Testbench running all 8 scenarios: coin insertion, item selection, balance tracking, dispense, and change calculation*

### State Diagram (Moore FSM)

![Vending Machine State Diagram](./docs/fsm_diagram.svg)


**State Descriptions:**
| State | Function | Output |
|-------|----------|--------|
| `IDLE` | Wait for coin insertion | All outputs = 0 |
| `ACCUMULATE` | Add coins to balance | Update balance |
| `SELECT` | Check if balance >= price | - |
| `DISPENSE` | Activate motor, subtract price | dispense = item_code |
| `CHANGE` | Return remaining balance | change = balance |
| `ERROR` | Signal insufficient funds | error = 1 |

📂 [**View Vending Machine Code →**](./04_Vending_Machine)

---

## 📁 All Projects

| # | Project | Description | Skills Demonstrated |
|---|---------|-------------|---------------------|
| 01 | [LED Blink](./01_LED_Blink) | Running LED pattern | Clock divider, Shift register |
| 02 | [7-Segment Counter](./02_7Segment_Counter) | 0000-9999 auto counter | FSM, Multiplexing, BCD |
| 03 | [Button Up/Down](./03_Button_UpDown_Counter) | Button-controlled counter | Debounce, Edge detection |
| 04 | [**Vending Machine**](./04_Vending_Machine) | **Moore FSM Controller** | **Complex FSM, ALU, Verification** |

---

## 📊 Testbench Results (Self-Checking)

```
========== VENDING MACHINE TESTBENCH ==========

[PASS] Test 1: Insufficient funds for Item A
[PASS] Test 2: Buy Item A with change
[PASS] Test 3: Buy Item C exact change
[PASS] Test 4: Cancel with zero balance
[PASS] Test 5: Cancel and get refund
[PASS] Test 6: Overflow protection (bal<=99)
[PASS] Test 7: No coin, select item -> error
[PASS] Test 8: Reset clears balance

========== TEST SUMMARY ==========
Total Tests: 8
Passed: 8
Failed: 0
*** ALL TESTS PASSED! ***
```

---

## 🛠 Hardware

- **Board**: PYNQ-Z2 (Xilinx Zynq-7000, xc7z020clg400-1)
- **Clock**: 100 MHz
- **Tools**: Vivado 2020.2+

---

## 📂 Project Structure

```
FPGA-PYNQ-Z2-Labs/
├── 01_LED_Blink/
│   ├── clk_divider.v      # Clock divider module
│   ├── led_blink.v        # Top module (shift register pattern)
│   ├── tb_led_blink.v     # Testbench
│   └── constraints.xdc    # PYNQ-Z2 pin mapping
│
├── 02_7Segment_Counter/
│   ├── top.v              # Top module
│   ├── digits.v           # BCD counter (0-9999)
│   ├── seg7_control.v     # 4-digit multiplexer FSM
│   └── tenHz_gen.v        # Clock generator
│
├── 03_Button_UpDown_Counter/
│   ├── top.v              # Top module
│   ├── btn_debounce.v     # Button debounce logic
│   ├── counter_4bit.v     # 4-bit up/down counter
│   └── seg7_led.v         # Hex to 7-segment decoder
│
├── 04_Vending_Machine/     ★ HIGHLIGHT
│   ├── vending_machine.v  # 6-state Moore FSM
│   ├── tb_vending_machine.v # Self-checking testbench
│   └── README.md          # State diagram & test scenarios
│
└── docs/
    └── interview_prep.md  # Interview Q&A (Vietnamese)
```

---

## 🚀 How to Use

### Simulation (Vivado)
```
1. Create RTL Project in Vivado
2. Add vending_machine.v + tb_vending_machine.v
3. Run Behavioral Simulation
4. Check Console for PASS/FAIL results
```

### Hardware (PYNQ-Z2)
```
1. Add all .v files from project folder
2. Add .xdc constraints
3. Synthesis → Implementation → Generate Bitstream
4. Program Device
```

---

## 👤 Author

**Bì Duy Tân**  
FPT Jetking Academy - Chip Design Technology  
Semester 2 (2025-2027)

📧 duytan2903@gmail.com  
🔗 [LinkedIn](https://linkedin.com/in/bi-duy-tan) | [GitHub](https://github.com/duytan1412)

---

## 📄 License

MIT License - Free to use for educational purposes.
