# dmesg-human-openwrt

> Скрипт для OpenWrt, который переводит вывод `dmesg` в человекочитаемый формат времени

## 📋 Описание

В OpenWrt команда `dmesg` из BusyBox не поддерживает ключ `-T` для отображения времени в человекочитаемом формате. Этот скрипт решает эту проблему, преобразуя время из секунд с момента загрузки системы в привычный формат даты и времени.

### До
```
[18772654.532021] br-lan: port 1(lan1) entered disabled state
```

### После
```
[2025-10-02 14:25:54] br-lan: port 1(lan1) entered disabled state
```

## 🚀 Установка

### Способ 1: Прямое создание файла

1. Создайте файл скрипта на роутере:
```sh
nano /root/dmesg_human.sh
```

2. Вставьте следующее содержимое:
```sh
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
```

3. Сделайте файл исполняемым:
```sh
chmod +x /root/dmesg_human.sh
```

### Способ 2: Загрузка через wget/curl

```sh
wget -O /root/dmesg_human.sh https://raw.githubusercontent.com/ваш-username/dmesg-human-openwrt/main/dmesg_human.sh
chmod +x /root/dmesg_human.sh
```

## 💡 Использование

### Показать все логи с человекочитаемым временем
```sh
/root/dmesg_human.sh
```

### Фильтрация по ключевому слову
```sh
/root/dmesg_human.sh | grep lan1
```

### Показать последние N строк
```sh
/root/dmesg_human.sh | tail -n 50
```

### Поиск по нескольким ключевым словам
```sh
/root/dmesg_human.sh | grep -E "lan1|wifi|usb"
```

### Создание алиаса для удобства

Добавьте в `/etc/profile` или `~/.profile`:
```sh
alias dmesg-human='/root/dmesg_human.sh'
```

Теперь можно использовать просто:
```sh
dmesg-human
```

## ⚙️ Требования

- **OpenWrt** (протестировано на версиях с BusyBox v1.36.1)
- Команда `date` с поддержкой `-d @timestamp` (присутствует в стандартной сборке OpenWrt)
- Команда `uptime` с ключом `-s`

## 🔧 Совместимость

Скрипт протестирован на:
- OpenWrt 24.10.0
- BusyBox v1.36.1

## 📝 Примечания

- Скрипт использует время загрузки системы (`uptime -s`) для расчета абсолютного времени событий
- Точность зависит от корректности системного времени на роутере
- Для корректной работы убедитесь, что на роутере настроен NTP
