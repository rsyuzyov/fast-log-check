# Интеграция с AI-ассистентами

`fast-log-check` поставляется с готовым **навыком (skill)** для AI-ассистентов на базе Claude. После установки вы сможете анализировать логи серверов прямо из чата.

## Поддерживаемые инструменты

| Инструмент                                                                                 | Поддержка | Папка навыков       |
| ------------------------------------------------------------------------------------------ | --------- | ------------------- |
| [Claude Code](https://marketplace.visualstudio.com/items?itemName=anthropics.claude-code)  | ✅        | `~/.claude/skills/` |
| [Roo Code](https://marketplace.visualstudio.com/items?itemName=RooVeterinaryInc.roo-cline) | ✅        | `~/.claude/skills/` |
| [Kilo-Code](https://marketplace.visualstudio.com/items?itemName=kilocode.kilocode)         | ✅        | `~/.claude/skills/` |

Все три инструмента читают навыки из одной папки `~/.claude/skills/`.

---

## Установка

### Шаг 1: Установить бинарник в PATH

#### Linux / macOS

```bash
# Создать директорию для бинарников (если не существует)
mkdir -p ~/.local/bin

# Скачать бинарник (замените URL на актуальный из Releases)
# Для Linux:
curl -L https://github.com/rsyuzyov/fastlogcheck/releases/latest/download/fast-log-check-linux-amd64 \
  -o ~/.local/bin/fast-log-check

# Для macOS Intel:
curl -L https://github.com/rsyuzyov/fastlogcheck/releases/latest/download/fast-log-check-darwin-amd64 \
  -o ~/.local/bin/fast-log-check

# Для macOS Apple Silicon:
curl -L https://github.com/rsyuzyov/fastlogcheck/releases/latest/download/fast-log-check-darwin-arm64 \
  -o ~/.local/bin/fast-log-check

# Сделать исполняемым
chmod +x ~/.local/bin/fast-log-check

# Добавить в PATH (если ~/.local/bin ещё не в PATH)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc  # или ~/.zshrc
source ~/.bashrc
```

#### Windows (PowerShell)

```powershell
# Создать директорию для бинарников
$BinPath = "$env:USERPROFILE\.local\bin"
New-Item -Path $BinPath -ItemType Directory -Force

# Скачать бинарник
$Url = "https://github.com/rsyuzyov/fastlogcheck/releases/latest/download/fast-log-check-windows-amd64.exe"
Invoke-WebRequest -Uri $Url -OutFile "$BinPath\fast-log-check.exe"

# Добавить в PATH (для текущего пользователя)
$CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($CurrentPath -notlike "*$BinPath*") {
    [Environment]::SetEnvironmentVariable("PATH", "$CurrentPath;$BinPath", "User")
}

# Перезапустите терминал для применения PATH
```

#### Проверка установки

```bash
fast-log-check --version
```

---

### Шаг 2: Установить навык

Выберите один из вариантов:

#### Вариант A: Глобальная установка (рекомендуется)

Навык будет доступен во **всех проектах**.

**Linux / macOS:**

```bash
mkdir -p ~/.claude/skills/log-checker
curl -L https://raw.githubusercontent.com/rsyuzyov/fastlogcheck/main/.claude/skills/log-checker/SKILL.md \
  -o ~/.claude/skills/log-checker/SKILL.md
```

**Windows (PowerShell):**

```powershell
$SkillPath = "$env:USERPROFILE\.claude\skills\log-checker"
New-Item -Path $SkillPath -ItemType Directory -Force
Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/rsyuzyov/fastlogcheck/main/.claude/skills/log-checker/SKILL.md" `
  -OutFile "$SkillPath\SKILL.md"
```

#### Вариант B: Установка в проект

Навык будет доступен только в **конкретном проекте**.

```bash
# В корне вашего проекта
mkdir -p .claude/skills/log-checker
curl -L https://raw.githubusercontent.com/rsyuzyov/fastlogcheck/main/.claude/skills/log-checker/SKILL.md \
  -o .claude/skills/log-checker/SKILL.md
```

> 💡 **Совет:** Проектная установка полезна, если вы хотите версионировать навык вместе с проектом или использовать модифицированную версию.

---

### Шаг 3: Активация

После установки навыка AI-ассистент должен его подхватить:

| Инструмент      | Действие                                                                     |
| --------------- | ---------------------------------------------------------------------------- |
| **Claude Code** | Перезапустите VS Code или выполните команду `/refresh` в чате                |
| **Roo Code**    | Откройте новый чат или перезагрузите окно (`Ctrl+Shift+P` → `Reload Window`) |
| **Kilo-Code**   | Откройте новый чат или перезагрузите окно (`Ctrl+Shift+P` → `Reload Window`) |

---

## Использование

После установки просто попросите AI-ассистента проверить сервер:

```
Проверь состояние сервера myhost.example.com
```

```
Найди ошибки в логах на srv1, srv2 за последние 48 часов
```

```
Проанализируй логи на production-server с минимальным уровнем info
```

AI автоматически использует навык и выполнит соответствующую команду `fast-log-check`.

---

## Структура навыка

```
~/.claude/
└── skills/
    └── log-checker/
        └── SKILL.md      # Инструкции для AI
```

Файл `SKILL.md` содержит:

- Описание навыка (когда его применять)
- Команды для выполнения
- Параметры и примеры
- Формат вывода

---

## Обновление навыка

Для обновления навыка до последней версии повторите команды из **Шага 2** — файл будет перезаписан.

---

## Удаление

```bash
# Удалить навык
rm -rf ~/.claude/skills/log-checker

# Удалить бинарник
rm ~/.local/bin/fast-log-check
```

Windows:

```powershell
Remove-Item -Path "$env:USERPROFILE\.claude\skills\log-checker" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\.local\bin\fast-log-check.exe" -Force
```

---

## Устранение неполадок

### Навык не активируется

1. Проверьте, что файл `SKILL.md` находится в правильной папке
2. Убедитесь, что YAML frontmatter (блок `---`) в начале файла корректен
3. Перезапустите VS Code / IDE

### Команда fast-log-check не найдена

1. Проверьте, что бинарник в PATH: `which fast-log-check` (Linux/macOS) или `where fast-log-check` (Windows)
2. Перезапустите терминал для применения изменений в PATH
3. Попробуйте указать полный путь в навыке

### Ошибки подключения SSH

Навык использует SSH для подключения к серверам. Убедитесь, что:

- SSH-ключи настроены (`~/.ssh/id_rsa` или `~/.ssh/id_ed25519`)
- Ключи добавлены на целевые серверы
- Или используйте флаг `--ask-password` для ввода пароля
