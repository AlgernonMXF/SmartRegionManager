# ReaPack 安装指南

## 概述
ReaPack 是 REAPER 的包管理器扩展，允许您轻松安装和管理脚本、主题和其他扩展。

## 安装步骤

### 1. 找到 REAPER 的 UserPlugins 目录

根据您的操作系统，UserPlugins 目录位置如下：

- **Windows**: `%APPDATA%\REAPER\UserPlugins\`
  - 完整路径示例：`C:\Users\您的用户名\AppData\Roaming\REAPER\UserPlugins\`
  
- **macOS**: `~/Library/Application Support/REAPER/UserPlugins/`
  
- **Linux**: `~/.config/REAPER/UserPlugins/`

**快速打开方法（Windows）：**
1. 按 `Win + R` 打开运行对话框
2. 输入：`%APPDATA%\REAPER\UserPlugins`
3. 按回车

### 2. 复制 DLL 文件

将您下载的 `reaper_reapack-x64.dll` 文件复制到 UserPlugins 目录中。

**注意：**
- 确保文件名完全匹配：`reaper_reapack-x64.dll`
- 如果 REAPER 是 32 位版本，您需要下载 `reaper_reapack-x86.dll` 版本
- 不要将文件放在其他子文件夹中，直接放在 UserPlugins 目录的根目录

### 3. 重启 REAPER

关闭所有 REAPER 窗口，然后重新启动 REAPER。

### 4. 验证安装

启动 REAPER 后，检查菜单栏：

1. 查看菜单栏中是否出现了 **"Extensions"** 菜单
2. 点击 **Extensions** → 应该能看到 **"ReaPack"** 子菜单
3. 如果看到 ReaPack 菜单项，说明安装成功！

### 5. 首次配置（可选）

首次使用时，您可能需要：

1. 点击 **Extensions** → **ReaPack** → **Browse packages**
2. 或者点击 **Extensions** → **ReaPack** → **Manage repositories** 来添加自定义仓库

## 常见问题排查

### 问题：启动 REAPER 后看不到 Extensions 菜单

**可能原因：**
- DLL 文件放错了位置
- REAPER 版本不匹配（32位 vs 64位）
- DLL 文件损坏或不完整

**解决方法：**
1. 确认 DLL 文件在正确的 UserPlugins 目录中
2. 检查 REAPER 版本（32位或64位）
3. 重新下载 DLL 文件
4. 查看 REAPER 的启动日志（如果有错误信息）

### 问题：REAPER 提示 DLL 加载失败

**解决方法：**
1. 确认您下载的是与 REAPER 版本匹配的 DLL（x64 对应 64位，x86 对应 32位）
2. 检查文件权限，确保 REAPER 有读取权限
3. 尝试以管理员身份运行 REAPER

### 问题：找不到 UserPlugins 目录

**解决方法：**
1. 在 REAPER 中：**Options** → **Show REAPER resource path in explorer/finder**
2. 这会打开 REAPER 的资源目录
3. 如果 UserPlugins 文件夹不存在，手动创建一个

## 下一步：安装扩展

安装 ReaPack 后，您可以：

1. **浏览包库**：Extensions → ReaPack → Browse packages
2. **搜索扩展**：例如搜索 "ReaImGui" 来安装 GUI 扩展
3. **安装脚本**：右键点击包 → Install

## 相关资源

- ReaPack 官方网站：https://reapack.com/
- REAPER 官方论坛：https://forum.cockos.com/
- ReaPack 文档：https://github.com/cfillion/reapack

## 注意事项

- 确保 REAPER 版本为 5.0 或更高版本
- 定期更新 ReaPack 以获取最新功能和安全修复
- 备份您的 REAPER 配置文件夹（包含 UserPlugins）以便恢复

---

**安装完成后，您就可以使用 ReaPack 来管理 REAPER 扩展了！**
