# Установка fast-log-check

Инструкции по установке утилиты `fast-log-check` для анализа логов серверов.

## Проверка установки

```bash
fast-log-check --version
```

Если команда не найдена, выполни установку ниже.

---

## Linux / macOS

```bash
# Создать директорию для бинарников
mkdir -p ~/.local/bin

# Скачать последний релиз (замени linux-amd64 на darwin-amd64 для macOS)
curl -L -o ~/.local/bin/fast-log-check \
  "https://github.com/rsyuzyov/fast-log-check/releases/latest/download/fast-log-check-linux-amd64"

# Сделать исполняемым
chmod +x ~/.local/bin/fast-log-check

# Добавить в PATH (если ещё не добавлено)
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
fi
```

### Вариант для macOS (arm64/Apple Silicon)

```bash
curl -L -o ~/.local/bin/fast-log-check \
  "https://github.com/rsyuzyov/fast-log-check/releases/latest/download/fast-log-check-darwin-arm64"
chmod +x ~/.local/bin/fast-log-check
```

---

## Windows (PowerShell)

```powershell
# Создать директорию для бинарников
$binPath = "$env:USERPROFILE\.local\bin"
New-Item -ItemType Directory -Force -Path $binPath | Out-Null

# Скачать последний релиз
Invoke-WebRequest -Uri "https://github.com/rsyuzyov/fast-log-check/releases/latest/download/fast-log-check-windows-amd64.exe" `
  -OutFile "$binPath\fast-log-check.exe"

# Добавить в PATH пользователя (если ещё не добавлено)
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$binPath*") {
    [Environment]::SetEnvironmentVariable("Path", "$binPath;$currentPath", "User")
    Write-Host "Добавлено в PATH. Перезапустите терминал для применения."
}
```

---

## Проверка после установки

```bash
fast-log-check --version
```

При успешной установке команда выведет версию утилиты.
