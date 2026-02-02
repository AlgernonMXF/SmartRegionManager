# Smart Region Manager 开发文档

## 项目结构

```
SmartRegionManager/
├── SmartRegionManager.lua     # 主入口脚本
├── modules/
│   ├── config.lua             # 配置管理、设置持久化
│   ├── gui.lua                # ReaImGui 界面实现
│   ├── region_manager.lua     # Region 数据管理
│   └── render_engine.lua      # 渲染引擎、音频导出
├── screenshots/               # 截图
├── index.xml                  # ReaPack 包描述文件
├── install.bat                # Windows 安装脚本
├── update.bat                 # Windows 更新脚本
├── README.md
├── INSTALLATION.md
├── REAPACK_INSTALL.md
├── TROUBLESHOOTING.md
├── DEVELOPMENT.md
├── CHANGELOG.md
└── LICENSE
```

## 技术栈

- **Lua 5.4** - REAPER 脚本语言
- **ReaImGui** - 即时模式 GUI 库（必需依赖）
- **REAPER API** - 音频处理和渲染

## 模块说明

### SmartRegionManager.lua
主入口文件，负责：
- 加载依赖模块
- 检查 ReaImGui 可用性
- 初始化并启动 GUI 循环

### modules/config.lua
配置管理模块，负责：
- 用户偏好设置
- 项目内数据持久化（使用 ExtState）
- Region 声道模式存储

### modules/gui.lua
界面模块，负责：
- ReaImGui 窗口创建和渲染
- 主题检测（深色/浅色）
- 用户交互处理

### modules/region_manager.lua
Region 管理模块，负责：
- 读取项目 Region 数据
- 同步 Region 变化
- 管理选择状态

### modules/render_engine.lua
渲染引擎模块，负责：
- 配置渲染参数
- 执行批量渲染
- 处理声道模式（Mono/Stereo）

## 开发环境设置

### 1. 克隆仓库

```bash
git clone https://github.com/AlgernonMXF/SmartRegionManager.git
cd SmartRegionManager/Reaper/SmartRegionManager
```

### 2. 设置开发环境

**方式 A：符号链接（推荐）**

Windows（管理员 PowerShell）：
```powershell
$ReaperScripts = "$env:APPDATA\REAPER\Scripts"
New-Item -ItemType SymbolicLink -Path "$ReaperScripts\SmartRegionManager" -Target "$(Get-Location)"
```

macOS/Linux：
```bash
ln -s "$(pwd)" ~/Library/Application\ Support/REAPER/Scripts/SmartRegionManager
```

**方式 B：运行 install.bat**

直接运行 `install.bat` 复制文件到 Scripts 目录。

### 3. 加载脚本

1. 打开 REAPER
2. `Actions` → `Show action list`
3. `New action...` → `Load ReaScript...`
4. 选择 `SmartRegionManager.lua`

### 4. 调试

- 使用 REAPER 内置控制台查看输出：`View` → `Show console`
- 使用 `reaper.ShowConsoleMsg()` 输出调试信息

## 发布流程

### 1. 更新版本号

需要同步更新以下位置：
- `index.xml` - `<version name="x.x.x">`
- `README.md` - 版本历史
- 可选：`CHANGELOG.md`

### 2. 更新 index.xml

```xml
<version name="1.0.3" author="Unicon" time="2026-02-02T12:00:00Z">
  <changelog><![CDATA[
v1.0.3:
- 新功能/修复内容
]]></changelog>
  <source main="main">SmartRegionManager.lua</source>
  <source file="modules/config.lua">modules/config.lua</source>
  <source file="modules/gui.lua">modules/gui.lua</source>
  <source file="modules/region_manager.lua">modules/region_manager.lua</source>
  <source file="modules/render_engine.lua">modules/render_engine.lua</source>
</version>
```

### 3. 测试

- [ ] 测试 ReaPack 安装
- [ ] 测试 install.bat 安装
- [ ] 测试 update.bat 更新
- [ ] 测试核心功能
- [ ] 测试 ReaImGui 依赖检测

### 4. 提交并推送

```bash
git add .
git commit -m "Release v1.0.x: 功能描述"
git push origin main
```

### 5. 验证 ReaPack

推送后，用户可以通过 `Synchronize packages` 获取更新。

## ReaPack 包规范

### index.xml 格式

```xml
<?xml version="1.0" encoding="utf-8"?>
<index version="1" name="SmartRegionManager">
  <category name="Region Tools">
    <reapack name="Smart Region Manager" type="script" desc="描述">
      <metadata>
        <description><![CDATA[详细描述]]></description>
        <link rel="website">GitHub 链接</link>
      </metadata>
      <version name="版本号" author="作者" time="ISO时间">
        <changelog><![CDATA[更新日志]]></changelog>
        <source main="main">主脚本.lua</source>
        <source file="相对路径">模块文件.lua</source>
      </version>
    </reapack>
  </category>
</index>
```

### 注意事项

- `time` 使用 ISO 8601 格式：`2026-02-02T12:00:00Z`
- `<source main="main">` 标记主入口文件
- 其他文件使用 `<source file="相对路径">`

## 代码规范

### Lua 风格

```lua
-- 模块定义
local ModuleName = {}

-- 私有函数使用 local
local function privateHelper()
end

-- 公开函数挂载到模块表
function ModuleName.publicMethod()
end

return ModuleName
```

### 命名约定

- 模块名：PascalCase（如 `RegionManager`）
- 函数名：camelCase（如 `getRegionList`）
- 常量：UPPER_SNAKE_CASE（如 `DEFAULT_CHANNEL_MODE`）
- 局部变量：camelCase

## 依赖管理

### ReaImGui

- 必需依赖
- 通过 ReaPack 安装：搜索 `ReaImGui`
- API 文档：https://github.com/cfillion/reaimgui

### JS_ReaScriptAPI（可选）

- 已移除强制依赖（v1.0.2）
- 文件浏览对话框有内置后备方案

## 问题排查

### 常见开发问题

1. **脚本不更新**
   - REAPER 可能缓存脚本，尝试重启 REAPER
   
2. **模块加载失败**
   - 检查 `package.path` 是否包含模块目录
   - 确认文件路径正确

3. **ReaImGui 报错**
   - 确认 ReaImGui 版本兼容
   - 查看 REAPER 控制台错误信息

## 贡献指南

1. Fork 仓库
2. 创建功能分支
3. 提交 Pull Request
4. 等待审核

## 许可证

MIT License
