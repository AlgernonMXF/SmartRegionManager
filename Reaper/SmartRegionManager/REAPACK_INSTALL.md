# ReaPack 安装详细指南（Windows 11 + REAPER 7.1.6）

## 前置检查

在开始之前，请确认：

1. ✅ **REAPER 版本**：7.1.6（已确认）
2. ✅ **ReaPack 已安装**：
   - 菜单栏应该有 `Extensions` 菜单
   - `Extensions` → `ReaPack` 应该存在
   - 如果没有，请先安装 ReaPack

## 完整安装步骤

### 步骤 1：添加仓库

1. **打开 REAPER 7.1.6**

2. **打开导入对话框**
   - 点击菜单：`Extensions` → `ReaPack` → `Import repositories...`
   - 会弹出一个对话框

3. **输入仓库地址**
   - 在输入框中**完整复制**以下地址（不要有空格）：
     ```
     https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/Reaper/SmartRegionManager/index.xml
     ```
   - **重要**：确保完整复制，包括 `https://` 开头

4. **确认添加**
   - 点击 `OK` 或 `Import` 按钮
   - 如果成功，通常不会有明显提示（这是正常的）

5. **验证仓库已添加**
   - `Extensions` → `ReaPack` → `Manage repositories`
   - 应该能看到类似 `SmartRegionManager` 或完整 URL 的条目
   - 如果看不到，说明添加失败，请查看下面的"常见错误"

### 步骤 2：同步仓库（重要！）

**这一步很关键，很多用户会跳过导致搜索不到！**

1. **打开同步对话框**
   - `Extensions` → `ReaPack` → `Synchronize packages`
   - 会显示同步进度

2. **等待同步完成**
   - 会显示 "Synchronizing..." 进度
   - 完成后会显示结果（成功/失败）

3. **检查同步结果**
   - 如果成功：会显示 "Synchronized X packages" 或类似信息
   - 如果失败：会显示错误信息（见下面的"常见错误"）

### 步骤 3：搜索并安装

1. **打开包浏览器**
   - `Extensions` → `ReaPack` → `Browse packages`

2. **搜索脚本**
   - 在搜索框中输入：`Smart Region Manager`
   - 或者尝试：`Smart`、`Region Manager`、`SmartRegionManager`

3. **安装脚本**
   - 找到后，右键点击 → `Install`
   - 或者双击条目进行安装

4. **确认安装**
   - 安装后，脚本会出现在列表中，状态显示为已安装

### 步骤 4：重启 REAPER

**重要**：安装完成后必须重启 REAPER，脚本才能生效。

## 常见错误和解决方案

### 错误 1：添加仓库时提示 "Invalid repository URL" 或 "Failed to fetch"

**可能原因：**
- 网络连接问题（无法访问 GitHub）
- URL 地址错误（有空格或缺少字符）
- GitHub 访问被阻止（某些地区）

**解决方法：**

1. **检查网络连接**
   - 在浏览器中打开：https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/Reaper/SmartRegionManager/index.xml
   - 如果浏览器能正常显示 XML 内容，说明网络正常
   - 如果无法打开，可能是网络问题

2. **检查 URL 地址**
   - 确保完整复制，没有多余空格
   - 确保以 `https://` 开头
   - 确保以 `.xml` 结尾

3. **使用代理或 VPN**（如果在中国大陆）
   - 如果无法访问 GitHub，可能需要使用代理
   - 或者使用手动安装方法（见下方）

4. **尝试使用 HTTPS 代理设置**
   - 如果 REAPER 有代理设置，检查是否正确配置

### 错误 2：同步时提示 "No packages found" 或 "Repository is empty"

**可能原因：**
- 仓库地址不正确
- XML 文件格式错误
- 同步时网络中断

**解决方法：**

1. **验证仓库地址**
   - 在浏览器中打开仓库地址
   - 应该能看到 XML 内容
   - 如果看到 404 错误，说明地址错误

2. **重新添加仓库**
   - `Extensions` → `ReaPack` → `Manage repositories`
   - 删除旧的 `SmartRegionManager` 条目
   - 重新添加仓库

3. **检查 XML 文件**
   - 在浏览器中打开仓库地址
   - 确认能看到完整的 XML 内容
   - 如果 XML 格式错误，需要修复

### 错误 3：搜索不到脚本

**可能原因：**
- 没有执行同步步骤
- 搜索关键词不正确
- 仓库没有正确添加

**解决方法：**

1. **确认已同步**
   - `Extensions` → `ReaPack` → `Synchronize packages`
   - 等待同步完成

2. **尝试不同的搜索词**
   - `Smart`
   - `Region Manager`
   - `SmartRegionManager`
   - `Unicon`（作者名）

3. **检查仓库列表**
   - `Extensions` → `ReaPack` → `Manage repositories`
   - 确认 `SmartRegionManager` 仓库存在
   - 如果不存在，重新添加

4. **清除缓存**
   - 关闭 REAPER
   - 删除 ReaPack 缓存（通常不需要，但可以尝试）
   - 重新打开 REAPER 并同步

### 错误 4：安装后脚本无法运行

**可能原因：**
- 缺少依赖（ReaImGui）
- REAPER 版本不兼容
- 脚本文件损坏

**解决方法：**

1. **安装 ReaImGui**
   - `Extensions` → `ReaPack` → `Browse packages`
   - 搜索 `ReaImGui`
   - 安装并重启 REAPER

2. **检查 REAPER 版本**
   - `Help` → `About REAPER`
   - 确认版本为 6.0 或更高（您的是 7.1.6，应该没问题）

3. **重新安装脚本**
   - 卸载脚本
   - 重新同步并安装

## 详细诊断步骤

如果以上方法都无法解决问题，请按以下步骤诊断：

### 1. 检查 ReaPack 是否正常工作

1. 尝试安装其他脚本（如 ReaImGui）
2. 如果能正常安装其他脚本，说明 ReaPack 本身没问题
3. 如果其他脚本也安装不了，可能是 ReaPack 配置问题

### 2. 检查网络连接

在命令提示符中测试：

```cmd
ping raw.githubusercontent.com
```

如果无法 ping 通，说明网络有问题。

### 3. 检查仓库 URL

在浏览器中打开：
```
https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/Reaper/SmartRegionManager/index.xml
```

- ✅ 如果能看到 XML 内容：URL 正确
- ❌ 如果看到 404 错误：URL 错误或文件不存在
- ❌ 如果无法打开：网络问题

### 4. 查看 ReaPack 日志

1. `Extensions` → `ReaPack` → `Preferences`
2. 查看是否有错误日志
3. 检查同步历史记录

## 备选方案：手动安装

如果 ReaPack 安装一直失败，可以使用手动安装：

### Windows 11 手动安装步骤

1. **下载文件**
   - 访问：https://github.com/AlgernonMXF/SmartRegionManager
   - 点击绿色的 `Code` 按钮 → `Download ZIP`
   - 解压下载的文件

2. **打开 REAPER Scripts 目录**
   - 按 `Win + R`
   - 输入：`%APPDATA%\REAPER\Scripts`
   - 回车

3. **复制文件夹**
   - 找到解压后的 `Reaper/SmartRegionManager` 文件夹
   - 复制整个文件夹
   - 粘贴到 Scripts 目录中

4. **加载脚本**
   - 打开 REAPER
   - `Actions` → `Show action list`
   - `New action...` → `Load ReaScript...`
   - 浏览到 `Scripts\SmartRegionManager\SmartRegionManager.lua`
   - 选择并加载

## 验证安装

安装完成后，验证步骤：

1. ✅ 打开 REAPER
2. ✅ `Actions` → `Show action list`
3. ✅ 搜索 `Smart Region Manager`
4. ✅ 运行脚本
5. ✅ 应该能看到 "Smart Region Manager" 窗口

## 获取帮助

如果以上方法都无法解决问题，请提供以下信息：

1. **错误信息**：完整的错误提示（截图或文字）
2. **操作步骤**：您执行了哪些步骤
3. **环境信息**：
   - Windows 11（已确认）
   - REAPER 7.1.6（已确认）
   - ReaPack 版本（`Extensions` → `ReaPack` → `About`）

然后访问：https://github.com/AlgernonMXF/SmartRegionManager/issues 提交问题。

---

**提示**：大多数 ReaPack 安装问题都与网络连接或仓库地址有关。如果遇到问题，先尝试手动安装作为临时解决方案。
