## PYNQ-Z2 Constraints File - 4-Digit 7-Segment Display Counter (0000-9999)
## Project: Exam - BCD Counter with 7-Segment Display
## Board: PYNQ-Z2 (Zynq xc7z020clg400-1)
## Display: 4-Digit 7-Segment (Common Cathode via inversion in logic)

##################################################
## Clock Signal - 125 MHz from Ethernet PHY
##################################################
set_property PACKAGE_PIN H16 [get_ports clk_100MHz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100MHz]
# Create clock constraint for 125 MHz (period = 8ns)
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports clk_100MHz]

##################################################
## Reset Button - BTN0
##################################################
set_property PACKAGE_PIN D19 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

##################################################
## 7-Segment Display - Segments (sseg[6:0])
## Bit order: sseg[6:0] = {g, f, e, d, c, b, a}
##################################################
# Segment A (bit 0)
set_property PACKAGE_PIN W14 [get_ports {sseg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg[0]}]
set_property DRIVE 12 [get_ports {sseg[0]}]
set_property SLEW FAST [get_ports {sseg[0]}]

# Segment B (bit 1)
set_property PACKAGE_PIN Y14 [get_ports {sseg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg[1]}]
set_property DRIVE 12 [get_ports {sseg[1]}]
set_property SLEW FAST [get_ports {sseg[1]}]

# Segment C (bit 2)
set_property PACKAGE_PIN T11 [get_ports {sseg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg[2]}]
set_property DRIVE 12 [get_ports {sseg[2]}]
set_property SLEW FAST [get_ports {sseg[2]}]

# Segment D (bit 3)
set_property PACKAGE_PIN T10 [get_ports {sseg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg[3]}]
set_property DRIVE 12 [get_ports {sseg[3]}]
set_property SLEW FAST [get_ports {sseg[3]}]

# Segment E (bit 4)
set_property PACKAGE_PIN V16 [get_ports {sseg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg[4]}]
set_property DRIVE 12 [get_ports {sseg[4]}]
set_property SLEW FAST [get_ports {sseg[4]}]

# Segment F (bit 5)
set_property PACKAGE_PIN W16 [get_ports {sseg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg[5]}]
set_property DRIVE 12 [get_ports {sseg[5]}]
set_property SLEW FAST [get_ports {sseg[5]}]

# Segment G (bit 6)
set_property PACKAGE_PIN V12 [get_ports {sseg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg[6]}]
set_property DRIVE 12 [get_ports {sseg[6]}]
set_property SLEW FAST [get_ports {sseg[6]}]

##################################################
## 7-Segment Display - Digit Select (digit[3:0])
## Active LOW after inversion in logic
##################################################
# Digit 0 (rightmost - ones)
set_property PACKAGE_PIN Y18 [get_ports {digit[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[0]}]

# Digit 1 (tens)
set_property PACKAGE_PIN Y19 [get_ports {digit[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[1]}]

# Digit 2 (hundreds)
set_property PACKAGE_PIN Y16 [get_ports {digit[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[2]}]

# Digit 3 (leftmost - thousands)
set_property PACKAGE_PIN Y17 [get_ports {digit[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {digit[3]}]

##################################################
## NOTES
##################################################
# 1. Clock: PYNQ-Z2 uses 125MHz, not 100MHz
#    - Adjust divider in tenHz_gen.v if using different clock
#
# 2. Display: Logic inverts internally to support common cathode
#    - 0 = segment ON, 1 = segment OFF (after inversion)
#
# 3. Counter: Increments every 1 second (0000 → 9999)
#
# 4. Refresh Rate: 1kHz (1ms per digit)
