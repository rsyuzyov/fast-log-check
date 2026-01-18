@echo off
chcp 65001 >nul
setlocal

echo ============================================================
echo  Fast Log Check - Сборка EXE
echo ============================================================
echo.

REM Проверяем наличие Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ОШИБКА] Python не найден! Установите Python и добавьте в PATH.
    pause
    exit /b 1
)

REM Проверяем наличие PyInstaller
pip show pyinstaller >nul 2>&1
if errorlevel 1 (
    echo [INFO] PyInstaller не установлен. Устанавливаю...
    pip install pyinstaller
    if errorlevel 1 (
        echo [ОШИБКА] Не удалось установить PyInstaller!
        pause
        exit /b 1
    )
)

REM Проверяем зависимости
echo [INFO] Проверка зависимостей...
pip install -r requirements.txt --quiet
if errorlevel 1 (
    echo [ОШИБКА] Не удалось установить зависимости!
    pause
    exit /b 1
)

REM Очищаем предыдущие сборки
echo [INFO] Очистка предыдущих сборок...
if exist "build" rmdir /s /q "build"
if exist "dist" rmdir /s /q "dist"
if exist "*.spec" del /q *.spec 2>nul

REM Собираем exe
echo [INFO] Сборка EXE...
echo.

python -m PyInstaller ^
    --onefile ^
    --name fast-log-check ^
    --add-data "templates;templates" ^
    --add-data "grouping_rules.json;." ^
    --hidden-import=paramiko ^
    --hidden-import=jinja2 ^
    --console ^
    run.py

if errorlevel 1 (
    echo.
    echo [ОШИБКА] Сборка не удалась!
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  Сборка завершена успешно!
echo  EXE файл: dist\fast-log-check.exe
echo ============================================================
echo.

REM Копируем grouping_rules.json в dist для удобства
copy /y "grouping_rules.json" "dist\" >nul 2>&1

echo [INFO] Файлы в папке dist:
dir /b dist

echo.
pause
