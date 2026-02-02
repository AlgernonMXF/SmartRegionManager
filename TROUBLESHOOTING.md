# 故障排除指南

## 安装错误

### install.bat 安装脚本报错

#### 错误：找不到 SmartRegionManager.lua

**症状：**
```
❌ 错误: 找不到 SmartRegionManager.lua
   请确保在 SmartRegionManager 文件夹中运行此安装脚本
```

**解决方法：**
1. 确认您在正确的文件夹中运行脚本
2. 确认文件 `SmartRegionManager.lua` 存在于当前目录
3. 如果是从 GitHub 下载的 ZIP 文件，确保解压了完整的文件夹结构

#### 错误：找不到 modules 文件夹

**症状：**
```
❌ 错误: 找不到 modules 文件夹
   请确保文件夹结构完整
```

**解决方法：**
1. 确认 `modules` 文件夹存在于当前目录
2. 检查文件夹结构应该是：
   ```
   SmartRegionManager/
   ├── SmartRegionManager.lua
   ├── modules/
   │   ├── config.lua
   │   ├── gui.lua
   │   ├── region_manager.lua
   │   └── render_engine.lua
   ├── install.bat
   └── ...
   ```

#### 错误：复制文件失败

**症状：**
```
❌ 错误: 复制主脚本失败
或
❌ 错误: 复制模块文件失败
```

**可能原因和解决方法：**

1. **文件权限问题**
   - 右键点击 `install.bat` → `以管理员身份运行`
   - 或者手动复制文件到目标目录

2. **目标目录被占用**
   - 关闭 REAPER（如果正在运行）
   - 检查是否有其他程序占用文件
   - 重新运行安装脚本

3. **磁盘空间不足**
   - 检查磁盘空间是否足够
   - 清理临时文件

4. **路径包含特殊字符**
   - 确保 REAPER 安装路径和用户目录路径不包含特殊字符
   - 如果用户名包含中文或特殊字符，可能需要手动安装

#### 错误：无法创建目录

**症状：**
```
❌ 错误: 无法创建 Scripts 目录
或
❌ 错误: 无法创建目标目录
```

**解决方法：**
1. 手动创建目录：
   - Windows: 按 `Win + R`，输入 `%APPDATA%\REAPER\Scripts`，回车
   - 如果 Scripts 文件夹不存在，手动创建
2. 检查文件夹权限：
   - 右键点击 Scripts 文件夹 → `属性` → `安全`
   - 确保当前用户有写入权限
3. 以管理员身份运行安装脚本

### ReaPack 安装错误

#### 错误：添加仓库失败

**症状：**
- 在 ReaPack 中添加仓库时提示错误
- 同步时失败

**解决方法：**
1. **检查网络连接**
   - 确保能访问 GitHub
   - 尝试在浏览器中打开：https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/Reaper/SmartRegionManager/index.xml

2. **检查链接地址**
   - 确保完整复制链接，没有多余空格
   - 链接应该是：
     ```
     https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/Reaper/SmartRegionManager/index.xml
     ```

3. **使用代理或 VPN**
   - 如果在中国大陆，可能需要使用代理访问 GitHub
   - 或者使用手动安装方法

#### 错误：同步后找不到脚本

**症状：**
- 添加仓库并同步后，在 Browse packages 中搜索不到

**解决方法：**
1. 确认同步成功：
   - `Extensions` → `ReaPack` → `Synchronize packages`
   - 查看是否有错误信息

2. 检查仓库是否正确添加：
   - `Extensions` → `ReaPack` → `Manage repositories`
   - 应该能看到 `SmartRegionManager` 仓库

3. 尝试不同的搜索关键词：
   - `Smart`
   - `Region Manager`
   - `SmartRegionManager`

4. 清除缓存并重新同步：
   - 删除仓库后重新添加
   - 再次同步

## 运行时错误

### 错误：Missing Dependency

**症状：**
```
This script requires ReaImGui extension.
```

**解决方法：**
1. 安装 ReaImGui：
   - `Extensions` → `ReaPack` → `Browse packages`
   - 搜索 `ReaImGui`
   - 安装并重启 REAPER

### 错误：脚本无法启动

**症状：**
- 运行脚本后没有任何反应
- 或出现错误提示

**解决方法：**
1. 检查 REAPER 版本：
   - 需要 REAPER 6.0 或更高版本
   - `Help` → `About REAPER` 查看版本

2. 检查脚本文件完整性：
   - 确认所有文件都已正确安装
   - 重新安装脚本

3. 查看 REAPER 控制台：
   - `View` → `Show console`
   - 查看是否有错误信息

### 错误：窗口不显示

**症状：**
- 脚本运行但没有窗口出现

**解决方法：**
1. 检查脚本是否真的在运行：
   - `Actions` → `Show action list`
   - 搜索脚本名称，确认状态

2. 尝试重新加载脚本：
   - 关闭脚本（如果已运行）
   - 重新从 Action List 运行

3. 检查屏幕分辨率：
   - 窗口可能显示在屏幕外
   - 尝试移动窗口位置

## 常见问题

### Q: 安装脚本一闪而过，看不到错误信息

**A:** 
1. 在命令提示符中运行：
   - 按 `Win + R`，输入 `cmd`，回车
   - 使用 `cd` 命令进入脚本所在目录
   - 运行 `install.bat`
   - 这样可以看到完整的错误信息

### Q: 安装后脚本找不到

**A:**
1. 确认安装位置：
   - Windows: `%APPDATA%\REAPER\Scripts\SmartRegionManager\`
   - 快速打开：按 `Win + R`，输入 `%APPDATA%\REAPER\Scripts`，回车

2. 手动加载脚本：
   - `Actions` → `Show action list`
   - `New action...` → `Load ReaScript...`
   - 浏览到安装目录，选择 `SmartRegionManager.lua`

### Q: 更新后脚本不工作

**A:**
1. 完全重启 REAPER（不是重新加载项目）
2. 清除脚本缓存：
   - 删除 `%APPDATA%\REAPER\Scripts\SmartRegionManager` 文件夹
   - 重新安装

### Q: 权限被拒绝错误

**A:**
1. 以管理员身份运行安装脚本
2. 或者手动复制文件到目标目录
3. 检查文件夹权限设置

## 获取帮助

如果以上方法都无法解决问题，请：

1. **收集错误信息**
   - 截图或复制完整的错误信息
   - 记录操作步骤

2. **检查环境信息**
   - REAPER 版本
   - 操作系统版本
   - 安装方式（ReaPack / 手动 / 脚本）

3. **提交 Issue**
   - 访问：https://github.com/AlgernonMXF/SmartRegionManager/issues
   - 提供详细的错误信息和环境信息

## 手动安装（最后的备选方案）

如果所有自动安装方法都失败，可以手动安装：

1. **下载文件**
   - 从 GitHub 下载最新版本
   - 解压文件

2. **手动复制**
   - 复制整个 `SmartRegionManager` 文件夹
   - 粘贴到：`%APPDATA%\REAPER\Scripts\`

3. **加载脚本**
   - 在 REAPER 中：`Actions` → `Show action list`
   - `New action...` → `Load ReaScript...`
   - 选择 `SmartRegionManager.lua`

---

**提示：** 大多数安装问题都与文件权限或网络连接有关。如果遇到问题，先尝试以管理员身份运行，或使用手动安装方法。
