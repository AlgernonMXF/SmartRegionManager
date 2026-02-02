# Smart Region Manager 安装指南

## 关于链接地址

**重要：** 链接 `https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/Reaper/SmartRegionManager/index.xml` 是：

- ✅ **给 ReaPack 使用的** - 复制这个链接，粘贴到 ReaPack 的 "Import repositories" 对话框中
- ❌ **不是给浏览器打开的** - 虽然在浏览器中可以看到 XML 内容，但这不是正确的使用方式

## 为什么搜索不到？

**原因：** ReaPack 不会自动发现 GitHub 上的所有脚本。您需要先手动添加这个仓库，然后才能搜索到。

ReaPack 只会在以下仓库中搜索：
1. 默认的官方仓库（如 ReaTeam Scripts）
2. **您手动添加的自定义仓库**

## 完整安装流程

### 方法一：通过 ReaPack 安装（推荐）

#### 步骤 1：添加仓库

1. 打开 REAPER
2. 点击菜单：`Extensions` → `ReaPack` → `Import repositories...`
3. 会弹出一个对话框，标题类似 "Import repositories"
4. 在输入框中**复制粘贴**以下地址：
   ```
   https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/Reaper/SmartRegionManager/index.xml
   ```
5. 点击 `OK` 或 `Import` 按钮

**验证：** 添加成功后，通常不会有明显提示，但您可以验证：
- `Extensions` → `ReaPack` → `Manage repositories`
- 应该能看到 `SmartRegionManager` 或类似的条目

#### 步骤 2：同步仓库

1. 菜单：`Extensions` → `ReaPack` → `Synchronize packages`
2. 等待同步完成（会显示进度和结果）
3. 同步完成后，ReaPack 会下载并索引仓库中的所有脚本

#### 步骤 3：搜索并安装

1. 菜单：`Extensions` → `ReaPack` → `Browse packages`
2. 在搜索框中输入：`Smart Region Manager`
3. 应该能看到搜索结果
4. 右键点击 → `Install`
   - 或者双击条目进行安装

#### 步骤 4：重启 REAPER

安装完成后，重启 REAPER 使脚本生效。

### 方法二：手动安装（如果 ReaPack 不工作）

如果 ReaPack 安装遇到问题，可以使用手动安装：

1. **下载文件**
   - 访问：https://github.com/AlgernonMXF/SmartRegionManager
   - 点击绿色的 `Code` 按钮 → `Download ZIP`
   - 解压下载的文件

2. **复制文件夹**
   - 找到 `Reaper/SmartRegionManager` 文件夹
   - 复制整个文件夹到 REAPER Scripts 目录：
     - **Windows**: `%APPDATA%\REAPER\Scripts\`
       - 快速打开：按 `Win + R`，输入 `%APPDATA%\REAPER\Scripts`，回车
     - **macOS**: `~/Library/Application Support/REAPER/Scripts/`
     - **Linux**: `~/.config/REAPER/Scripts/`

3. **加载脚本**
   - 打开 REAPER
   - 菜单：`Actions` → `Show action list`
   - 点击 `New action...` → `Load ReaScript...`
   - 浏览到 `Scripts\SmartRegionManager\SmartRegionManager.lua`
   - 选择并加载

### 方法三：使用安装脚本（仅 Windows）

1. 下载项目文件
2. 进入 `SmartRegionManager` 文件夹
3. 双击运行 `install.bat`
4. 按照提示完成安装

## 常见问题

### Q: 为什么在 ReaPack 中搜索不到？

**A:** 因为您还没有添加仓库。请按照"步骤 1：添加仓库"操作。

### Q: 添加仓库后还是搜索不到？

**A:** 请确认：
1. ✅ 已执行"步骤 2：同步仓库"
2. ✅ 同步时没有错误提示
3. ✅ 尝试搜索关键词：`Smart` 或 `Region`
4. ✅ 检查仓库列表：`Extensions` → `ReaPack` → `Manage repositories`

### Q: 链接在浏览器中打开显示 XML 代码，正常吗？

**A:** 正常！这是正确的行为。这个链接是给 ReaPack 读取的，不是给用户浏览的。您只需要复制这个链接，粘贴到 ReaPack 的对话框中即可。

### Q: 添加仓库时提示错误？

**可能原因：**
- 网络连接问题
- 链接地址错误（请确保完整复制）
- GitHub 访问问题

**解决方法：**
- 检查网络连接
- 确认链接地址完全正确
- 尝试使用手动安装方法

### Q: 安装后找不到脚本？

**A:** 
- 确认已重启 REAPER
- 检查脚本是否正确安装：`Actions` → `Show action list` → 搜索 `SmartRegionManager`
- 如果找不到，尝试手动加载：`Actions` → `Show action list` → `New action...` → `Load ReaScript...`

## 前置要求

在安装 Smart Region Manager 之前，请确保：

1. **REAPER 版本**
   - REAPER 6.0 或更高版本（推荐 7.0+）

2. **ReaImGui 扩展**（如果使用 ReaPack）
   - 菜单：`Extensions` → `ReaPack` → `Browse packages`
   - 搜索 `ReaImGui`
   - 安装并重启 REAPER

## 验证安装

安装完成后，验证步骤：

1. ✅ 打开 REAPER
2. ✅ `Actions` → `Show action list`
3. ✅ 搜索 `Smart Region Manager`
4. ✅ 运行脚本
5. ✅ 应该能看到 "Smart Region Manager" 窗口

## 下一步

安装完成后，请查看：
- [README.md](README.md) - 使用说明
- [UPDATE_GUIDE.md](UPDATE_GUIDE.md) - 更新指南

---

**需要帮助？** 如果遇到问题，请访问：https://github.com/AlgernonMXF/SmartRegionManager/issues
