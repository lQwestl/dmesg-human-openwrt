# dmesg-human-openwrt

> Скрипт для OpenWrt, который переводит вывод `dmesg` в человекочитаемый формат времени

## 📋 Описание

В OpenWrt команда `dmesg` из BusyBox не поддерживает ключ `-T` для отображения времени в человекочитаемом формате. Этот скрипт решает эту проблему, преобразуя время из секунд с момента загрузки системы в привычный формат даты и времени.

### До
```
[   18.090729] br-lan: port 3(lan3) entered blocking state
[   18.103864] br-lan: port 3(lan3) entered forwarding state
[18772654.532021] br-lan: port 1(lan1) entered disabled state
```

### После
```
[2025-10-03 12:15:18] br-lan: port 3(lan3) entered blocking state
[2025-10-03 12:15:18] br-lan: port 3(lan3) entered forwarding state
[2025-10-02 14:25:54] br-lan: port 1(lan1) entered disabled state
```

## 🚀 Установка

### Способ 1: Загрузка через wget

```sh
wget -O /root/dmesg_human.sh https://raw.githubusercontent.com/lQwestl/dmesg-human-openwrt/main/dmesg_human.sh
chmod +x /root/dmesg_human.sh
```

### Способ 2: Загрузка через curl

```sh
curl -o /root/dmesg_human.sh https://raw.githubusercontent.com/lQwestl/dmesg-human-openwrt/main/dmesg_human.sh
chmod +x /root/dmesg_human.sh
```

### Способ 3: Ручное создание файла

1. Создайте файл скрипта на роутере:
```sh
nano /root/dmesg_human.sh
```

2. Вставьте содержимое из файла dmesg_human.sh

3. Сделайте файл исполняемым:
```sh
chmod +x /root/dmesg_human.sh
```

## 💡 Использование

### Базовое использование

Показать все логи с человекочитаемым временем:
```sh
/root/dmesg_human.sh
```

### Фильтрация логов

Поиск по ключевому слову:
```sh
/root/dmesg_human.sh | grep lan1
```

Показать последние N строк:
```sh
/root/dmesg_human.sh | tail -n 50
```

Поиск по нескольким ключевым словам:
```sh
/root/dmesg_human.sh | grep -E "lan1|wifi|usb"
```

Инверсный поиск (исключить строки):
```sh
/root/dmesg_human.sh | grep -v "audit"
```

### Создание алиаса для удобства

Добавьте в `/etc/profile` или `~/.profile`:
```sh
alias dmesg-human='/root/dmesg_human.sh'
```

После этого перезагрузите профиль:
```sh
source /etc/profile
```

Теперь можно использовать просто:
```sh
dmesg-human
dmesg-human | grep error
```

### Сохранение логов в файл

```sh
/root/dmesg_human.sh > /tmp/dmesg_log.txt
```

## ⚙️ Как это работает

Скрипт выполняет следующие действия:

1. Получает текущее время системы в формате UNIX timestamp
2. Читает время работы системы (uptime) из `/proc/uptime`
3. Вычисляет момент загрузки системы: `boot_time = current_time - uptime`
4. Для каждой строки `dmesg`:
   - Извлекает секунды с момента загрузки
   - Прибавляет их к времени загрузки
   - Конвертирует результат в человекочитаемый формат

## 🔧 Требования

- **OpenWrt** (любая версия с BusyBox)
- Команда `date` с поддержкой формата `@timestamp`
- Доступ к `/proc/uptime`
- Стандартные утилиты: `sed`, `awk`, `cut`

## 📦 Совместимость

Скрипт протестирован на:
- OpenWrt 24.10.0 (BusyBox v1.36.1)

Должен работать на всех современных версиях OpenWrt с BusyBox.

## 🐛 Устранение неполадок

### Проблема: неправильное время в логах

**Решение:** Убедитесь, что на роутере настроен NTP и системное время корректно:

```sh
# Проверка текущего времени
date

# Включение NTP клиента
/etc/init.d/sysntpd enable
/etc/init.d/sysntpd start

# Или установка времени вручную
date -s "2025-10-03 12:00:00"
```

### Проблема: скрипт не запускается

**Решение:** Проверьте права доступа:

```sh
ls -la /root/dmesg_human.sh
chmod +x /root/dmesg_human.sh
```

### Проблема: ошибки в выводе

**Решение:** Проверьте, что все необходимые команды доступны:

```sh
which date sed awk cut
cat /proc/uptime
```

## 📝 Примечания

- Скрипт использует `/proc/uptime` для определения времени работы системы
- Точность зависит от корректности системного времени на роутере
- Для корректной работы рекомендуется настроить NTP
- Скрипт не изменяет оригинальный вывод `dmesg`, а только форматирует его

⭐ Если этот скрипт оказался полезным, поставьте звезду!
