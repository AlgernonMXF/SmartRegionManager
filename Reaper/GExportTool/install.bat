@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo   Region Channel Exporter 一键安装器
echo ========================================
echo.

:: 获取脚本所在目录
set "SCRIPT_DIR=%~dp0"
set "SOURCE_DIR=%SCRIPT_DIR%"

:: 检测 REAPER Scripts 目录
set "REAPER_SCRIPTS=%APPDATA%\REAPER\Scripts"

echo [1/4] 正在检测 REAPER Scripts 目录...
if not exist "%REAPER_SCRIPTS%" (
    echo.
    echo ⚠️  警告: 未找到 REAPER Scripts 目录
    echo    正在创建目录: %REAPER_SCRIPTS%
    mkdir "%REAPER_SCRIPTS%" 2>nul
    if errorlevel 1 (
        echo ❌ 错误: 无法创建 Scripts 目录
        echo    请手动创建目录: %REAPER_SCRIPTS%
        pause
        exit /b 1
    )
    echo ✅ Scripts 目录已创建
) else (
    echo ✅ 找到 Scripts 目录: %REAPER_SCRIPTS%
)

echo.
echo [2/4] 正在检查源文件...
set "TARGET_DIR=%REAPER_SCRIPTS%\GExportTool"

if not exist "%SOURCE_DIR%RegionChannelExporter.lua" (
    echo ❌ 错误: 找不到 RegionChannelExporter.lua
    echo    请确保在 GExportTool 文件夹中运行此安装脚本
    pause
    exit /b 1
)

if not exist "%SOURCE_DIR%modules" (
    echo ❌ 错误: 找不到 modules 文件夹
    echo    请确保文件夹结构完整
    pause
    exit /b 1
)

echo ✅ 源文件检查通过

echo.
echo [3/4] 正在复制文件到 REAPER Scripts 目录...

:: 如果目标目录已存在，询问是否覆盖
if exist "%TARGET_DIR%" (
    echo.
    echo ⚠️  目标目录已存在: %TARGET_DIR%
    set /p OVERWRITE="是否覆盖现有安装? (Y/N): "
    if /i not "!OVERWRITE!"=="Y" (
        echo 安装已取消
        pause
        exit /b 0
    )
    echo 正在删除旧版本...
    rmdir /s /q "%TARGET_DIR%" 2>nul
)

:: 创建目标目录
mkdir "%TARGET_DIR%" 2>nul
mkdir "%TARGET_DIR%\modules" 2>nul

:: 复制文件
echo 正在复制主脚本...
copy "%SOURCE_DIR%RegionChannelExporter.lua" "%TARGET_DIR%\" >nul
if errorlevel 1 (
    echo ❌ 错误: 复制主脚本失败
    pause
    exit /b 1
)

echo 正在复制模块文件...
copy "%SOURCE_DIR%modules\*.lua" "%TARGET_DIR%\modules\" >nul
if errorlevel 1 (
    echo ❌ 错误: 复制模块文件失败
    pause
    exit /b 1
)

:: 复制 README（如果存在）
if exist "%SOURCE_DIR%README.md" (
    copy "%SOURCE_DIR%README.md" "%TARGET_DIR%\" >nul
)

echo ✅ 文件复制完成

echo.
echo [4/4] 安装完成！
echo.
echo ========================================
echo   安装信息
echo ========================================
echo 安装位置: %TARGET_DIR%
echo.
echo 下一步操作:
echo 1. 打开 REAPER
echo 2. 菜单: Actions ^> Show action list
echo 3. 点击: New action... ^> Load ReaScript...
echo 4. 选择: %TARGET_DIR%\RegionChannelExporter.lua
echo 5. 运行脚本或设置快捷键
echo.
echo ========================================
echo.

pause
