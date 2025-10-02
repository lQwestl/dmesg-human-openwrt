#!/bin/sh
# Перевод времени dmesg в человеческое время для OpenWrt (BusyBox)
# Момент запуска системы (UNIX timestamp)
BOOT_TIME=$(date -d "$(uptime -s)" +%s)

dmesg | while read -r line; do
    # Извлекаем секунды из скобок [12345.678]
    SEC=$(echo "$line" | sed -n 's/^\[\([0-9]\+\)\..*/\1/p')
    if [ -n "$SEC" ]; then
        EVENT_TIME=$((BOOT_TIME + SEC))
        HUMAN=$(date -d "@$EVENT_TIME" +"%Y-%m-%d %H:%M:%S")
        echo "[$HUMAN] ${line#*]}"
    else
        echo "$line"
    fi
done
