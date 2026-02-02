# Smart Region Manager for Reaper

管理 Region 声道设置并自动导出匹配格式音频的 Reaper 脚本工具。

## 功能特点

- 显示项目中所有 Region 列表，包含名称、时间、时长等信息
- 为每个 Region 单独设置声道模式（Mono/Stereo）
- 批量操作：全选、批量设置声道模式
- 一键渲染选中的 Region，自动应用对应的声道设置
- 可选命名后缀（如 `_Mono`、`_Stereo`）
- 深色/浅色主题支持（自动匹配 REAPER 主题）
- 设置自动保存在项目文件中

## 安装

### 前置要求

- **REAPER 6.0+**（推荐 7.0+）
- **ReaImGui 扩展**

### 通过 ReaPack 安装（推荐）

1. 打开 REAPER
2. 菜单：`Extensions` → `ReaPack` → `Import repositories...`
3. 输入仓库地址：
   ```
   https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/Reaper/SmartRegionManager/index.xml
   ```
4. 菜单：`Extensions` → `ReaPack` → `Browse packages`
5. 搜索 `Smart Region Manager`
6. 右键 → `Install`
7. 重启 REAPER

### 安装 ReaImGui（如果尚未安装）

1. 菜单：`Extensions` → `ReaPack` → `Browse packages`
2. 搜索 `ReaImGui`
3. 右键 → `Install`
4. 重启 REAPER

### 使用安装脚本（Windows）

1. 双击运行 `install.bat` 文件
2. 按照提示完成安装
3. 打开 REAPER，菜单：`Actions` → `Show action list`
4. 点击 `New action...` → `Load ReaScript...`
5. 选择 `Scripts\SmartRegionManager\SmartRegionManager.lua`

**更新脚本：**
- 运行 `update.bat` 快速更新到最新版本
- 详细更新指南请查看 [UPDATE_GUIDE.md](UPDATE_GUIDE.md)

### 手动安装（备用）

1. 将 `SmartRegionManager` 文件夹复制到 REAPER Scripts 目录：
   - Windows: `%APPDATA%\REAPER\Scripts\`
   - macOS: `~/Library/Application Support/REAPER/Scripts/`
   - Linux: `~/.config/REAPER/Scripts/`
2. 菜单：`Actions` → `Show action list`
3. 点击 `New action...` → `Load ReaScript...`
4. 选择 `SmartRegionManager.lua`

## 更新

### 通过 ReaPack 更新（推荐）

1. 打开 REAPER
2. 菜单：`Extensions` → `ReaPack` → `Synchronize packages`
3. 如果有更新可用，点击 `Apply`
4. 重启 REAPER

**提示：** 可以设置自动同步：`Extensions` → `ReaPack` → `Preferences` → 勾选 `Auto-sync on startup`

### 其他更新方法

- **Windows 用户**：运行 `update.bat` 脚本
- **手动更新**：下载最新版本并替换文件
- **详细指南**：查看 [UPDATE_GUIDE.md](UPDATE_GUIDE.md)

## 使用方法

1. 运行脚本（通过 Action List 或快捷键）
2. 在窗口中查看 Region 列表
3. 为每个 Region 选择声道模式
4. 勾选需要导出的 Region
5. 设置输出目录
6. 点击 "Render Selected"

## 故障排除

| 问题 | 解决方法 |
|------|----------|
| "Missing Dependency" 错误 | 安装 ReaImGui 扩展并重启 REAPER |
| 窗口不显示 | 在 Action List 中重新运行脚本 |
| 渲染无输出 | 确保选中了 Region 且输出目录有写入权限 |

## 版本历史

### v1.0.2
- 修复：Browse 按钮兼容性（不再依赖 JS_ReaScriptAPI）
- 修复：主题检测兼容性

### v1.0.1
- 修复：选择状态在自动刷新时保持不变
- 修复：启动时默认选中所有 Region
- 修复：关闭窗口时的兼容性错误
- 新增：深色/浅色主题支持

### v1.0.0
- 初始版本

## 许可证

MIT License
