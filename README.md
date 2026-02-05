# FPGA-PYNQ-Z2-Labs

A collection of FPGA lab projects developed on **Xilinx PYNQ-Z2** board using **Vivado**.

---

## 🎯 Highlight Project: Smart Vending Machine FSM

![Vending Machine FSM](./04_Vending_Machine/docs/waveform_fsm.png)
*Waveform showing FSM state transitions: IDLE → ACCUMULATE → DISPENSE → CHANGE*

**Key Features:**
- 6-state Moore FSM (IDLE, ACCUMULATE, SELECT, DISPENSE, CHANGE, ERROR)
- Self-Checking Testbench with 8 corner case scenarios
- 100% logic verification via automated PASS/FAIL output

📂 [View Vending Machine Code](./04_Vending_Machine)

---

## 📁 All Projects

| # | Project | Description | Skills Demonstrated |
|---|---------|-------------|---------------------|
| 01 | [LED Blink](./01_LED_Blink) | Running LED pattern | Clock divider, Shift register |
| 02 | [7-Segment Counter](./02_7Segment_Counter) | 0000-9999 auto counter | FSM, Multiplexing, BCD |
| 03 | [Button Up/Down](./03_Button_UpDown_Counter) | Button-controlled counter | Debounce, Edge detection |
| 04 | [**Vending Machine**](./04_Vending_Machine) | **Moore FSM Controller** | **Complex FSM, ALU, Verification** |

---

## 📊 Simulation Waveforms

### Vending Machine - Complete Transaction
![Complete Transaction](./04_Vending_Machine/docs/waveform_complete.png)
*Insert 20 → Select Item A (15) → Dispense → Change 5*

### Vending Machine - Corner Cases
![Corner Cases](./04_Vending_Machine/docs/waveform_corner.png)
*Testing: Overflow protection, Reset mid-transaction, Invalid inputs*

### 7-Segment Counter
![7-Segment Waveform](./02_7Segment_Counter/docs/waveform_counter.png)
*Counter incrementing 0000 → 0001 → 0002 with segment multiplexing*

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
│   ├── tenHz_gen.v        # Clock generator
│   └── constraints.xdc    # Pin constraints
│
├── 03_Button_UpDown_Counter/
│   ├── top.v              # Top module
│   ├── btn_debounce.v     # Button debounce logic
│   ├── counter_4bit.v     # 4-bit up/down counter
│   ├── seg7_led.v         # Hex to 7-segment decoder
│   └── tb_*.v             # Testbenches
│
├── 04_Vending_Machine/     ★ HIGHLIGHT PROJECT
│   ├── vending_machine.v  # 6-state Moore FSM
│   ├── tb_vending_machine.v # Self-checking testbench
│   ├── README.md          # State diagram & test scenarios
│   └── docs/              # Waveform screenshots
│
└── docs/
    └── interview_prep.md  # Interview Q&A (Vietnamese)
```

---

## 🚀 How to Use

### 1. Simulation Only (No Hardware)
```bash
# Open Vivado
# Create Project → RTL Project → Skip Add Sources
# Add Sources → Add vending_machine.v + tb_vending_machine.v
# Run Simulation → Behavioral Simulation
# View Console for PASS/FAIL results
```

### 2. Hardware Implementation (PYNQ-Z2)
```bash
# Add all .v files from a project
# Add .xdc constraints file
# Run Synthesis → Implementation → Generate Bitstream
# Open Hardware Manager → Program Device
```

---

## 📸 How to Capture Waveform Screenshots

1. Run simulation in Vivado
2. In Waveform window, zoom to interesting area
3. `File → Export → Export to PNG`
4. Save to `docs/` folder in project directory

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
