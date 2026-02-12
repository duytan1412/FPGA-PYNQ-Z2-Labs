# Tool: Report Timing & Utilization Script
# Usage: vivado -mode batch -source tools/report_timing.tcl -tclargs <project_name> <impl_run_name>
# Example: vivado -mode batch -source tools/report_timing.tcl -tclargs MyProject impl_1

if { $argc < 2 } {
    puts "Error: Missing arguments. Usage: vivado -mode batch -source tools/report_timing.tcl -tclargs <project_name> <impl_run_name>"
    exit 1
}

set project_name [lindex $argv 0]
set impl_run [lindex $argv 1]

puts "Opening project: $project_name..."
open_project ./$project_name.xpr

puts "Opening implementation run: $impl_run..."
open_run $impl_run

# Create a directory for reports if it doesn't exist
file mkdir reports

puts "Generating Timing Summary Report..."
report_timing_summary -file reports/timing_summary.rpt -delay_type min_max -max_paths 10 -input_pins -routable_nets -name timing_1

puts "Generating Utilization Report..."
report_utilization -file reports/utilization.rpt -name utilization_1

puts "Checking for Timing Violations..."
set wns [get_property STATS.WNS [get_runs $impl_run]]
set tns [get_property STATS.TNS [get_runs $impl_run]]

puts "--------------------------------------------------"
puts "Timing Check Results:"
puts "WNS (Worst Negative Slack): $wns ns"
puts "TNS (Total Negative Slack): $tns ns"

if { $wns < 0 } {
    puts "FAIL: Timing Violations Found!"
} else {
    puts "PASS: Timing Met!"
}
puts "--------------------------------------------------"

puts "Reports saved to: reports/timing_summary.rpt and reports/utilization.rpt"

close_project
exit
