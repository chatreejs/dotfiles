#!/bin/bash

# Report battery health: design vs. current full-charge capacity, cycle count,
# condition, temperature and charge state. Supports macOS and Linux.

print_row() {
    printf "  %-22s %s\n" "$1" "$2"
}

health_label() {
    local pct=$1
    if (( pct >= 80 )); then
        echo "Good"
    elif (( pct >= 60 )); then
        echo "Fair (worn)"
    else
        echo "Poor (consider replacement)"
    fi
}

check_macos() {
    local ioreg_out
    ioreg_out=$(ioreg -rn AppleSmartBattery 2>/dev/null)
    if [ -z "$ioreg_out" ]; then
        echo "No battery found."
        exit 1
    fi

    # Read a top-level key. Matching on the first field skips nested BatteryData keys.
    # ioreg starts each line with "|" tree characters, so strip them first.
    get_key() {
        echo "$ioreg_out" | sed 's/^[ |]*//' | awk -v k="\"$1\"" '$1 == k && $2 == "=" { print $3; exit }'
    }

    # Read a key from the nested BatteryData dict. Apple Silicon Macs report
    # DesignCapacity and FullChargeCapacity only there.
    get_data_key() {
        echo "$ioreg_out" | grep '"BatteryData" =' | grep -o "\"$1\"=[0-9]*" | head -n 1 | cut -d= -f2
    }

    local design max current cycles temp source state condition
    design=$(get_key DesignCapacity)
    [ -z "$design" ] && design=$(get_data_key DesignCapacity)
    max=$(get_key AppleRawMaxCapacity)
    [ -z "$max" ] && max=$(get_data_key FullChargeCapacity)
    current=$(get_key AppleRawCurrentCapacity)
    [ -z "$current" ] && current=$(get_data_key RemainingCapacity)
    cycles=$(get_key CycleCount)
    temp=$(get_key Temperature)
    # Power source / charging state come from pmset (IOPowerSources), which
    # updates as soon as the adapter is plugged in or removed. ioreg's
    # IsCharging/ExternalConnected are a periodic snapshot and lag behind.
    local pmset_out
    pmset_out=$(pmset -g batt 2>/dev/null)
    source=$(echo "$pmset_out" | awk -F"'" 'NR == 1 { print $2 }')
    state=$(echo "$pmset_out" | awk -F'; *' 'NR == 2 { print $2 }')
    condition=$(system_profiler SPPowerDataType 2>/dev/null | awk -F': ' '/Condition:/ { print $2; exit }')

    report "$design" "$max" "$current" "mAh" "$cycles"
    [ -n "$condition" ] && print_row "Condition (macOS):" "$condition"
    if [ -n "$temp" ]; then
        print_row "Temperature:" "$(awk -v t="$temp" 'BEGIN { printf "%.1f °C", t / 100 }')"
    fi
    print_row "Power source:" "${source:-Unknown}"
    print_row "Charging state:" "${state:-Unknown}"
}

check_linux() {
    local bat
    bat=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n 1)
    if [ -z "$bat" ]; then
        echo "No battery found."
        exit 1
    fi

    local design max current unit
    if [ -f "$bat/energy_full_design" ]; then
        design=$(cat "$bat/energy_full_design")
        max=$(cat "$bat/energy_full")
        current=$(cat "$bat/energy_now" 2>/dev/null)
        unit="mWh"
    else
        design=$(cat "$bat/charge_full_design" 2>/dev/null)
        max=$(cat "$bat/charge_full" 2>/dev/null)
        current=$(cat "$bat/charge_now" 2>/dev/null)
        unit="mAh"
    fi
    # sysfs reports µWh / µAh
    design=$(( ${design:-0} / 1000 ))
    max=$(( ${max:-0} / 1000 ))
    [ -n "$current" ] && current=$(( current / 1000 ))

    report "$design" "$max" "$current" "$unit" "$(cat "$bat/cycle_count" 2>/dev/null)"
    print_row "Status:" "$(cat "$bat/status" 2>/dev/null || echo Unknown)"
}

report() {
    local design=$1 max=$2 current=$3 unit=$4 cycles=$5

    echo "🔋 Battery Health"
    if [ -n "$design" ] && [ -n "$max" ] && (( design > 0 )); then
        local pct=$(( (max * 100 + design / 2) / design ))
        print_row "Design capacity:" "$design $unit"
        print_row "Full-charge capacity:" "$max $unit"
        print_row "Health:" "${pct}% — $(health_label "$pct")"
    else
        print_row "Health:" "Unavailable"
    fi
    if [ -n "$current" ] && [ -n "$max" ] && (( max > 0 )); then
        print_row "Current charge:" "$(( current * 100 / max ))% ($current $unit)"
    fi
    if [ -n "$cycles" ] && (( cycles > 0 )); then
        print_row "Cycle count:" "$cycles"
    fi
}

case "$(uname -s)" in
    Darwin) check_macos ;;
    Linux) check_linux ;;
    *) echo "Unsupported OS: $(uname -s)"; exit 1 ;;
esac
