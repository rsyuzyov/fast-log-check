@echo off
REM Скрипт установки зависимостей для Server Logs Analysis Tool
REM Windows Batch version

setlocal enabledelayedexpansion
chcp 65001 > nul
cls

echo ================================
echo Server Logs Analysis Tool
echo Установка зависимостей
echo ================================
echo.

REM Проверка и установка Python (если необходимо)
echo [1/4] Проверка Python...
echo.

REM Устанавливаем флаг, что скрипт вызван из install.bat
set "CALLED_FROM_PARENT=1"

REM Запускаем скрипт проверки/установки Python
call "%~dp0python-installer\install-python.bat"

REM Проверяем результат
if errorlevel 1 (
    echo.
    echo ❌ Не удалось настроить Python
    echo.
    pause
    exit /b 1
)

echo.
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo ✅ Python %PYTHON_VERSION% готов к работе
echo.

REM Проверка pip
echo [2/4] Проверка pip...

python -m pip --version > nul 2>&1
if errorlevel 1 (
    echo ❌ pip не найден
    echo.
    echo Установите pip: python -m ensurepip --upgrade
    pause
    exit /b 1
)

echo ✅ pip установлен
echo.

REM Установка зависимостей
echo [3/4] Установка зависимостей...

python -m pip install -q paramiko jinja2
if errorlevel 1 (
    echo ❌ Ошибка установки зависимостей
    echo.
    echo Попробуйте установить вручную:
    echo   python -m pip install paramiko jinja2
    pause
    exit /b 1
)

echo ✅ Зависимости установлены
echo.

REM Проверка установки
echo [4/4] Проверка установки...

python -c "import paramiko, jinja2" 2> nul
if errorlevel 1 (
    echo ❌ Ошибка импорта модулей
    pause
    exit /b 1
)

echo ✅ Все модули импортируются корректно
echo.

REM Создание директории для отчётов
if not exist "reports" (
    mkdir reports
    echo ✅ Создана директория .\reports\
)

echo ================================
echo ✅ Установка завершена успешно!
echo ================================
echo.
echo Примеры использования:
echo.
echo   # Базовая проверка
echo   python check_server_logs.py srv-hv1.ag.local
echo.
echo   # Несколько серверов
echo   python check_server_logs.py srv-hv1.ag.local srv-hv2.ag.local
echo.
echo Подробнее: см. README.md и USAGE.md
echo.

pause
