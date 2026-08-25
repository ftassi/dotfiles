#!/bin/sh
polybar-msg cmd quit >/dev/null 2>&1 || true
pkill -x polybar >/dev/null 2>&1 || true
sleep 1

log_dir=${XDG_STATE_HOME:-$HOME/.local/state}/polybar
mkdir -p "$log_dir"

# hwmon indexes are not stable across machines or boots: resolve by name
HWMON_CPU=""
HWMON_NVME=""
for h in /sys/class/hwmon/hwmon*; do
    case "$(cat "$h/name" 2>/dev/null)" in
        k10temp|coretemp) HWMON_CPU="$h/temp1_input" ;;
        nvme) HWMON_NVME="$h/temp1_input" ;;
    esac
done
export HWMON_CPU HWMON_NVME

monitors=$(polybar --list-monitors)
primary_monitor=$(printf "%s\n" "$monitors" | awk -F"[:x]" "BEGIN { max = -1 } { width = \$2 + 0; if (width > max) { max = width; monitor = \$1 } } END { print monitor }")

printf "%s\n" "$monitors" | while IFS= read -r line; do
    monitor=${line%%:*}
    resolution=${line#*: }
    width=${resolution%%x*}

    if [ "${width:-0}" -ge 3000 ]; then
        bar=main-4k
    else
        bar=main-fhd
    fi

    if [ "$monitor" = "$primary_monitor" ]; then
        bar=${bar}-tray
    fi

    log_file=$log_dir/${monitor}.log
    : > "$log_file"
    nohup env MONITOR="$monitor" polybar "$bar" >> "$log_file" 2>&1 &
done
