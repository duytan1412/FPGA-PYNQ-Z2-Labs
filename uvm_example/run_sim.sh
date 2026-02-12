#!/bin/bash
#=============================================================================
# UVM Example: Run Simulation Script
# Supports: VCS (Synopsys), Questa (Mentor), XSIM (Vivado)
# Usage: bash run_sim.sh [vcs|questa|xsim]
#=============================================================================

TOOL=${1:-xsim}   # Default: Vivado XSIM (free, no license)

echo "================================================="
echo "  Mini-UVM Counter Verification"
echo "  Tool: $TOOL"
echo "================================================="

case $TOOL in
    vcs)
        echo "[VCS] Compiling with UVM-1.2..."
        vcs -sverilog -ntb_opts uvm-1.2 \
            rtl/counter.sv \
            tb/counter_if.sv \
            tb/counter_pkg.sv \
            top/tb_top.sv \
            -o simv -l compile.log
        echo "[VCS] Running simulation..."
        ./simv +UVM_TESTNAME=counter_test -l sim.log
        ;;

    questa)
        echo "[Questa] Compiling..."
        vlib work
        vlog -sv +incdir+$UVM_HOME/src \
            rtl/counter.sv tb/*.sv top/tb_top.sv
        echo "[Questa] Running simulation..."
        vsim -c tb_top +UVM_TESTNAME=counter_test -do "run -all; quit" -l sim.log
        ;;

    xsim)
        echo "[XSIM] Compiling (Vivado free simulator)..."
        xvlog -sv rtl/counter.sv tb/counter_if.sv tb/counter_pkg.sv top/tb_top.sv
        xelab tb_top -s sim_snapshot -debug typical
        echo "[XSIM] Running simulation..."
        xsim sim_snapshot -R -log sim.log
        ;;

    *)
        echo "Usage: bash run_sim.sh [vcs|questa|xsim]"
        exit 1
        ;;
esac

echo ""
echo "================================================="
echo "  Simulation complete. Check sim.log for results."
echo "================================================="
