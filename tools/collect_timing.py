#!/usr/bin/env python3
import sys
import re
import os

def parse_timing_report(report_path):
    """Parses Vivado timing summary report to extract WNS and TNS."""
    if not os.path.exists(report_path):
        print(f"Error: Report file '{report_path}' not found.")
        return

    wns = None
    tns = None
    
    with open(report_path, 'r') as f:
        content = f.read()
        
        # Regex to find WNS and TNS in the summary section
        # Format usually looks like:
        # WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  ...
        # 3.889        0.000    0                      8                        0.123        0.000    ...
        
        # Taking a simpler approach driven by keywords often found in the text report
        wns_match = re.search(r'Worst Negative Slack \(WNS\):\s+([-\d.]+)\s+ns', content)
        if not wns_match:
             # Try alternative format 
             wns_match = re.search(r'WNS\(ns\)\s+TNS\(ns\)\s+.*\n\s+([-\d.]+)\s+([-\d.]+)', content)
             if wns_match:
                 wns = float(wns_match.group(1))
                 tns = float(wns_match.group(2))
        else:
            wns = float(wns_match.group(1))
            tns_match = re.search(r'Total Negative Slack \(TNS\):\s+([-\d.]+)\s+ns', content)
            if tns_match:
                tns = float(tns_match.group(1))

    print("-" * 40)
    print(f"Timing Report Summary: {report_path}")
    print("-" * 40)
    
    if wns is not None:
        print(f"WNS (Worst Negative Slack): {wns} ns")
        status = "PASS" if wns >= 0 else "FAIL"
        print(f"Status: {status}")
    else:
        print("WNS not found in report.")
        
    if tns is not None:
        print(f"TNS (Total Negative Slack): {tns} ns")

    print("-" * 40)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python collect_timing.py <path_to_timing_summary.rpt>")
        sys.exit(1)
    
    report_file = sys.argv[1]
    parse_timing_report(report_file)
