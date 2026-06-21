param(
    [ValidateSet('led','button','vending','all')]
    [string]$Lab = 'vending'
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
Set-Location $repo

function Require-Tool($name) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        throw "$name not found. Install Icarus Verilog and ensure it is on PATH."
    }
}

function Run-Iverilog($name, [string[]]$sources) {
    Require-Tool 'iverilog'
    Require-Tool 'vvp'
    $outDir = Join-Path $repo 'sim_results'
    New-Item -ItemType Directory -Force -Path $outDir | Out-Null
    $out = Join-Path $outDir "$name.vvp"
    $log = Join-Path $outDir "$name.log"
    & iverilog -g2012 -o $out @sources
    & vvp $out | Tee-Object -FilePath $log
}

if ($Lab -in @('led','all')) {
    Run-Iverilog 'led_blink' @('01_LED_Blink/clk_divider.v', '01_LED_Blink/led_blink.v', '01_LED_Blink/tb_led_blink.v')
}

if ($Lab -in @('button','all')) {
    Run-Iverilog 'button_way1' @('03_Button_UpDown_Counter/btn_debounce.v', '03_Button_UpDown_Counter/counter_4bit.v', '03_Button_UpDown_Counter/tb_way1.v')
    Run-Iverilog 'button_way2' @('03_Button_UpDown_Counter/debounce.v', '03_Button_UpDown_Counter/counter_4bit.v', '03_Button_UpDown_Counter/tb_way2.v')
}

if ($Lab -in @('vending','all')) {
    Run-Iverilog 'vending_machine' @('04_Vending_Machine/vending_machine.v', '04_Vending_Machine/tb_vending_machine.v')
}
