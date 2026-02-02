@echo off
chcp 65001 >nul
echo ========================================
echo   快速更新 Region Channel Exporter
echo ========================================
echo.
echo 正在更新脚本文件...
echo.

:: 获取脚本所在目录
set "SCRIPT_DIR=%~dp0"
set "REAPER_SCRIPTS=%APPDATA%\REAPER\Scripts\GExportTool"

if not exist "%REAPER_SCRIPTS%" (
    echo ❌ 错误: 未找到已安装的脚本
    echo    请先运行 install.bat 进行首次安装
    pause
    exit /b 1
)

echo 正在复制更新后的文件...
copy "%SCRIPT_DIR%RegionChannelExporter.lua" "%REAPER_SCRIPTS%\" >nul
if errorlevel 1 (
    echo ❌ 更新失败: 无法复制主脚本
    pause
    exit /b 1
)

copy "%SCRIPT_DIR%modules\*.lua" "%REAPER_SCRIPTS%\modules\" >nul
if errorlevel 1 (
    echo ❌ 更新失败: 无法复制模块文件
    pause
    exit /b 1
)

echo ✅ 文件更新完成！
echo.
echo 下一步：
echo 1. 在 REAPER 中关闭脚本窗口（如果已打开）
echo 2. 按 ? 打开 Action List
echo 3. 搜索并运行 "RegionChannelExporter"
echo 4. 脚本将使用最新版本
echo.
pause
