# Smart Region Manager 更新指南

本文档说明如何更新 Smart Region Manager 到最新版本。

## 更新方法（根据安装方式选择）

### 方法一：通过 ReaPack 更新（推荐）

如果您是通过 ReaPack 安装的，更新非常简单：

#### 首次安装（如果还未添加仓库）

1. 打开 REAPER
2. 菜单：`Extensions` → `ReaPack` → `Import repositories...`
3. 输入仓库地址：
   ```
   https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/Reaper/SmartRegionManager/index.xml
   ```
4. 点击 `OK`

#### 更新到最新版本

1. 打开 REAPER
2. 菜单：`Extensions` → `ReaPack` → `Synchronize packages`
3. ReaPack 会自动检查并下载更新
4. 如果有更新可用，会显示更新列表
5. 点击 `Apply` 应用更新
6. **重启 REAPER** 使更新生效

**提示：** 您也可以设置 ReaPack 自动同步：
- `Extensions` → `ReaPack` → `Preferences`
- 勾选 `Auto-sync on startup`（启动时自动同步）

### 方法二：使用更新脚本（Windows，手动安装用户）

如果您是手动安装的，可以使用更新脚本：

1. **下载最新版本**
   - 从 GitHub 下载最新版本：https://github.com/AlgernonMXF/SmartRegionManager
   - 解压到本地目录

2. **运行更新脚本**
   - 双击运行 `update.bat` 文件
   - 脚本会自动将新文件复制到 REAPER Scripts 目录

3. **重启脚本**
   - 在 REAPER 中关闭脚本窗口（如果已打开）
   - 按 `?` 打开 Action List
   - 搜索并运行 "SmartRegionManager"
   - 脚本将使用最新版本

### 方法三：手动更新（所有平台）

1. **下载最新版本**
   - 访问：https://github.com/AlgernonMXF/SmartRegionManager
   - 下载最新版本并解压

2. **备份当前版本（可选但推荐）**
   - 备份 `%APPDATA%\REAPER\Scripts\SmartRegionManager` 文件夹

3. **替换文件**
   - 将新版本的 `SmartRegionManager` 文件夹复制到：
     - Windows: `%APPDATA%\REAPER\Scripts\`
     - macOS: `~/Library/Application Support/REAPER/Scripts/`
     - Linux: `~/.config/REAPER/Scripts/`
   - 覆盖现有文件

4. **重启脚本**
   - 在 REAPER 中关闭脚本窗口（如果已打开）
   - 重新运行脚本

## 从旧版本（GExportTool）迁移

如果您之前使用的是 `GExportTool` 或 `Region Channel Exporter`，请按以下步骤迁移：

### 步骤 1：卸载旧版本

#### 如果通过 ReaPack 安装：
1. `Extensions` → `ReaPack` → `Browse packages`
2. 搜索 "Region Channel Exporter" 或 "GExportTool"
3. 右键 → `Uninstall`

#### 如果手动安装：
1. 删除旧文件夹：`%APPDATA%\REAPER\Scripts\GExportTool`

### 步骤 2：安装新版本

按照上面的"方法一：通过 ReaPack 安装"或"方法三：手动安装"进行安装。

### 步骤 3：迁移设置（可选）

旧版本的设置存储在项目文件中，新版本会自动读取兼容的设置。如果遇到问题：

1. 打开 REAPER 项目
2. 运行新的 Smart Region Manager
3. 重新配置 Region 声道设置（如果需要）

## 检查当前版本

### 通过 ReaPack 安装的用户

1. `Extensions` → `ReaPack` → `Browse packages`
2. 搜索 "Smart Region Manager"
3. 查看显示的版本号

### 手动安装的用户

查看 `SmartRegionManager.lua` 文件顶部的版本信息：
```lua
Version: 1.0.2
```

## 更新后验证

更新完成后，请验证：

1. ✅ 脚本可以正常启动
2. ✅ 窗口标题显示 "Smart Region Manager"
3. ✅ 所有功能正常工作
4. ✅ 没有错误提示

## 常见问题

### Q: 更新后脚本无法启动

**解决方法：**
1. 确认已安装 ReaImGui 扩展
2. 检查 REAPER 版本是否为 6.0+
3. 尝试重新安装脚本

### Q: 更新后设置丢失

**解决方法：**
- 设置存储在项目文件中，打开项目后会自动恢复
- 如果设置丢失，重新配置即可

### Q: ReaPack 显示"没有更新"

**可能原因：**
1. 您已经是最新版本
2. 仓库地址不正确
3. 需要手动同步

**解决方法：**
1. `Extensions` → `ReaPack` → `Synchronize packages`
2. 检查仓库地址是否正确

### Q: 更新后出现错误

**解决方法：**
1. 查看错误信息
2. 检查 REAPER 版本和依赖扩展
3. 访问 GitHub Issues 报告问题：https://github.com/AlgernonMXF/SmartRegionManager/issues

## 获取更新通知

- **GitHub**: 关注仓库获取更新通知
- **ReaPack**: 启用自动同步功能
- **版本历史**: 查看 `README.md` 中的版本历史部分

## 回退到旧版本

如果需要回退到旧版本：

### ReaPack 用户
1. `Extensions` → `ReaPack` → `Browse packages`
2. 搜索 "Smart Region Manager"
3. 右键 → `Previous version` → 选择要回退的版本

### 手动安装用户
1. 从 GitHub Releases 下载旧版本
2. 按照手动安装步骤重新安装

---

**提示：** 建议定期更新以获取最新功能和修复。通过 ReaPack 安装的用户可以设置自动同步，这样每次启动 REAPER 时都会自动检查更新。
