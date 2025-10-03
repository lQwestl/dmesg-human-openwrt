#!/bin/sh
# Перевод времени dmesg в человеческое время для OpenWrt (BusyBox)

# Получаем текущее время в секундах с 1970 года
CURRENT_TIME=$(date +%s)

# Получаем uptime системы в секундах (из /proc/uptime)
UPTIME=$(cat /proc/uptime | awk '{print int($1)}')

# Вычисляем время загрузки системы
BOOT_TIME=$((CURRENT_TIME - UPTIME))

dmesg | while IFS= read -r line; do
    # Извлекаем секунды из скобок [12345.678]
    SEC=$(echo "$line" | sed -n 's/^\[\s*\([0-9]\+\)\..*/\1/p')
    
    if [ -n "$SEC" ]; then
        # Вычисляем абсолютное время события
        EVENT_TIME=$((BOOT_TIME + SEC))
        
        # Конвертируем в человекочитаемый формат
        HUMAN=$(date -d "@$EVENT_TIME" +"%Y-%m-%d %H:%M:%S" 2>/dev/null)
        
        # Если date -d не сработал, пробуем альтернативный метод
        if [ -z "$HUMAN" ] || [ $? -ne 0 ]; then
            HUMAN=$(date -D "%s" -d "$EVENT_TIME" +"%Y-%m-%d %H:%M:%S" 2>/dev/null)
        fi
        
        # Если и это не сработало, используем простой формат
        if [ -z "$HUMAN" ]; then
            HUMAN=$(awk -v t="$EVENT_TIME" 'BEGIN{print strftime("%Y-%m-%d %H:%M:%S", t)}')
        fi
        
        # Удаляем старую timestamp и добавляем новую
        REST=$(echo "$line" | sed 's/^\[[^]]*\]//')
        echo "[$HUMAN]$REST"
    else
        echo "$line"
    fi
done
