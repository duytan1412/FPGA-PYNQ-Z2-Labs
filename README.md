# FPGA-PYNQ-Z2-Labs

A collection of FPGA lab projects developed on **Xilinx PYNQ-Z2** board using **Vivado**.

## Projects

| # | Project | Description | Skills Demonstrated |
|---|---------|-------------|---------------------|
| 01 | [LED Blink](./01_LED_Blink) | Running LED pattern | Clock divider, Shift register |
| 02 | [7-Segment Counter](./02_7Segment_Counter) | 0000-9999 auto counter | FSM, Multiplexing, BCD to 7-seg |
| 03 | [Button Up/Down Counter](./03_Button_UpDown_Counter) | Button-controlled hex counter | Debounce, Edge detection |
| 04 | [**Vending Machine**](./04_Vending_Machine) | **Moore FSM with Self-Check TB** | **Complex FSM, ALU, Verification** |


## Hardware

- **Board**: PYNQ-Z2 (Xilinx Zynq-7000)
- **Clock**: 100 MHz
- **Tools**: Vivado 2020.2+

## Project Structure

```
FPGA-PYNQ-Z2-Labs/
├── 01_LED_Blink/
│   ├── clk_divider.v      # Clock divider module
│   ├── led_blink.v        # Top module
│   ├── tb_led_blink.v     # Testbench
│   └── constraints.xdc    # Pin constraints
├── 02_7Segment_Counter/
│   ├── top.v              # Top module
│   ├── digits.v           # BCD counter
│   ├── seg7_control.v     # Display controller
│   ├── tenHz_gen.v        # Clock generator
│   └── constraints.xdc    # Pin constraints
├── 03_Button_UpDown_Counter/
│   ├── top.v              # Top module
│   ├── btn_debounce.v     # Button debounce
│   ├── counter_4bit.v     # 4-bit counter
│   ├── seg7_led.v         # 7-segment decoder
│   └── tb_*.v             # Testbenches
└── docs/
    └── interview_prep.md  # Interview preparation notes
```

## How to Use

1. Open Vivado and create a new project
2. Select PYNQ-Z2 board (xc7z020clg400-1)
3. Add design sources (.v files)
4. Add constraints (.xdc file)
5. Run Synthesis → Implementation → Generate Bitstream
6. Program the FPGA

## Author

**Bì Duy Tân** - FPT Jetking Academy  
Chip Design Technology - Semester 2 (2025-2027)

## License

MIT License - Free to use for educational purposes.
