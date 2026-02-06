## PYNQ-Z2 Constraints File - Vending Machine FSM
## Project: 04_Vending_Machine - Moore FSM Controller
## Board: PYNQ-Z2 (Zynq xc7z020clg400-1)
## Purpose: Timing constraints for synthesis and implementation

##################################################
## Clock Signal - 125 MHz from Ethernet PHY
##################################################
set_property PACKAGE_PIN H16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Create clock constraint for 125 MHz (period = 8ns)
# This is REQUIRED for proper timing analysis!
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports clk]

##################################################
## Reset Button - BTN0 (Active High)
##################################################
set_property PACKAGE_PIN D19 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

##################################################
## Coin Input - Switches SW0, SW1
##################################################
set_property PACKAGE_PIN M20 [get_ports {coin[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {coin[0]}]

set_property PACKAGE_PIN M19 [get_ports {coin[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {coin[1]}]

##################################################
## Item Select - Switches SW2, SW3
##################################################
set_property PACKAGE_PIN P19 [get_ports {item_sel[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {item_sel[0]}]

set_property PACKAGE_PIN P20 [get_ports {item_sel[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {item_sel[1]}]

##################################################
## Cancel Button - BTN1
##################################################
set_property PACKAGE_PIN D20 [get_ports cancel]
set_property IOSTANDARD LVCMOS33 [get_ports cancel]

##################################################
## Output LEDs (for state_out debug)
##################################################
set_property PACKAGE_PIN R14 [get_ports {state_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state_out[0]}]

set_property PACKAGE_PIN P14 [get_ports {state_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state_out[1]}]

set_property PACKAGE_PIN N16 [get_ports {state_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state_out[2]}]

##################################################
## Error LED - LED3
##################################################
set_property PACKAGE_PIN M14 [get_ports error]
set_property IOSTANDARD LVCMOS33 [get_ports error]

##################################################
## NOTES
##################################################
# 1. Clock: PYNQ-Z2 uses 125MHz from Ethernet PHY on pin H16
#    - Period = 8ns, 50% duty cycle
#
# 2. After adding this constraint file to Vivado:
#    - Run Synthesis
#    - Run Implementation
#    - Run Report Timing Summary
#    - WNS should be POSITIVE (timing met)
#
# 3. If WNS is negative (timing violation):
#    - Consider reducing clock frequency
#    - Or add pipeline stages to critical path
