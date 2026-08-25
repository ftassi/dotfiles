#!/bin/sh
polybar-msg cmd quit >/dev/null 2>&1 || true
pkill -x polybar >/dev/null 2>&1 || true
sleep 1

log_dir=${XDG_STATE_HOME:-$HOME/.local/state}/polybar
mkdir -p "$log_dir"

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
