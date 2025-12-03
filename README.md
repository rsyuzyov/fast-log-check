# Fast log check tool

Инструмент для быстрой параллельной проверки логов на множестве linux-серверов.  
Пробегается по списку серверов и сорбирает ошибки из логов и создает html-отчет.  
Каждый раздел в отчете можно [развернуть до детальных записей](https://htmlpreview.github.io/?https://github.com/rsyuzyov/fastlogcheck/blob/main/docs/example-report.html)  
<a href="https://htmlpreview.github.io/?https://github.com/rsyuzyov/fastlogcheck/blob/main/docs/example-report.html"><img src="docs/screenshot-example.gif" alt="Пример отчета" width="40%"></a>

## Установка

**Linux:** ```./install.sh```

**Windows:** ```install.bat```

## Использование

Можно комбинировать указание серверов в командной строке и файле.  
Для авторизации по паролю используется флаг `--ask-password`.  
Все примеры для windows, линуксоиды и так все знают.  
```powershell
python .\check_server_logs.py server1.example.com server2.example.com
python .\check_server_logs.py --file servers.txt
python .\check_server_logs.py server1.example.com --file servers.txt --ask-password
```

**Подробности см. в [USAGE.md](USAGE.md)**

## Проверяемые источники логов

Инструмент проверяет следующие источники логов на каждом сервере:

1. **Системный журнал (критические)** - `journalctl --priority=err`
2. **Системный журнал (предупреждения)** - `journalctl --priority=warning`
3. **Лог аутентификации** - `/var/log/auth.log`
4. **Системные сообщения ядра** - `dmesg`
5. **Fail2ban (защита от брутфорса)** - `/var/log/fail2ban.log`
6. **Corosync кластер** - `journalctl -u corosync`
7. **PVE Proxy (HTTP доступ)** - `/var/log/pveproxy/access.log`
8. **Виртуальные машины (статус)** - `qm list`
9. **Хранилища (дисковое пространство)** - `pvesm status`
10. **Кластер Proxmox (кворум)** - `pvecm status`
11. **ZFS снимки** (опционально с автоочисткой) - `zfs list -t snapshot`

## Группировка событий

Инструмент автоматически группирует похожие события в логах для улучшения читаемости отчетов. Правила группировки определены в файле [`grouping_rules.json`](grouping_rules.json).

### Структура правил группировки

Каждое правило представляет собой пару "регулярное_выражение" : "параметры_группы", где:

- **Ключ** - регулярное выражение для поиска события в тексте лога
- **title** - человекочитаемое название группы для отображения в отчете
- **severity** - уровень важности события:
  - `error` - критические ошибки (красный цвет в отчете)
  - `warning` - предупреждения (желтый цвет в отчете)
  - `skip` - события, которые следует игнорировать и не включать в отчет

### Настройка группировки

Для добавления новых правил группировки:

1. Откройте файл `grouping_rules.json`
2. Добавьте новое правило в формате:
   ```json
   "регулярное_выражение_для_поиска": {
       "title": "Название группы",
       "severity": "error|warning|skip"
   }
   ```
3. Сохраните файл - изменения вступят в силу при следующем запуске проверки

События, не попадающие ни под одно правило, будут отображаться в отчете как отдельные несгруппированные записи.
