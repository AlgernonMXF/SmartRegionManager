# Smart Region Manager for REAPER

[![Version](https://img.shields.io/badge/version-1.1.2-blue.svg)](https://github.com/AlgernonMXF/SmartRegionManager)
[![REAPER](https://img.shields.io/badge/REAPER-6.0+-green.svg)](https://www.reaper.fm/)
[![License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE)

管理 Region 声道设置并批量导出音频的 REAPER 脚本工具。

| Light Theme | Dark Theme |
|:-----------:|:----------:|
| ![Light](screenshots/screenshot_light.png) | ![Dark](screenshots/screenshot_dark.png) |

## 功能特点

- **Region 管理** - 显示项目中所有 Region，包含名称、时间、时长等信息
- **快速重命名** - 双击 Region 名称直接重命名，支持撤销/重做
- **声道设置** - 为每个 Region 单独设置声道模式（Mono/Stereo）
- **批量操作** - 全选、批量设置声道模式
- **一键渲染** - 自动应用对应的声道设置导出音频
- **命名后缀** - 可选添加 `_Mono`、`_Stereo` 后缀
- **主题适配** - 自动匹配 REAPER 深色/浅色主题
- **设置持久化** - 自动保存在项目文件中

## 安装

### 前置要求

- REAPER 6.0+（推荐 7.0+）
- ReaImGui 扩展

### 通过 ReaPack 安装（推荐）

1. `Extensions` → `ReaPack` → `Import repositories...`
2. 粘贴地址（二选一）：
   ```
   https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/index.xml
   ```
   或使用带缓存刷新的地址（推荐）：
   ```
   https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/index.xml?ts=20260204
   ```
   > `?ts=YYYYMMDD` 参数用于绕过 CDN 缓存，确保获取最新版本
3. `Extensions` → `ReaPack` → `Synchronize packages`
4. `Extensions` → `ReaPack` → `Browse packages` → 搜索 `Smart Region Manager` → 安装
5. 重启 REAPER

> 详细说明：[REAPACK_INSTALL.md](REAPACK_INSTALL.md)

### 其他安装方式

- **Windows 用户**：运行 `install.bat`
- **手动安装**：复制到 REAPER Scripts 目录

> 完整指南：[INSTALLATION.md](INSTALLATION.md)

## 使用方法

1. 在 Action List 中运行 `Smart Region Manager`
2. 在窗口中查看 Region 列表
3. 为每个 Region 选择声道模式（Mono/Stereo）
4. 勾选需要导出的 Region
5. 设置输出目录
6. 点击 **Render Selected**

## 更新

### ReaPack 更新

```
Extensions → ReaPack → Synchronize packages
```

### 本地更新（Windows）

运行 `update.bat`

## 文档

| 文档 | 说明 |
|------|------|
| [INSTALLATION.md](INSTALLATION.md) | 完整安装指南 |
| [REAPACK_INSTALL.md](REAPACK_INSTALL.md) | ReaPack 安装详解 |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | 故障排除 |
| [DEVELOPMENT.md](DEVELOPMENT.md) | 开发者文档 |
| [CHANGELOG.md](CHANGELOG.md) | 版本历史 |

## 常见问题

| 问题 | 解决方法 |
|------|----------|
| "Missing Dependency" 错误 | 安装 ReaImGui 扩展并重启 REAPER |
| 窗口不显示 | 在 Action List 中重新运行脚本 |
| 渲染无输出 | 确保选中了 Region 且输出目录有写入权限 |

更多问题请查看 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## 反馈与支持

- **问题反馈**：[GitHub Issues](https://github.com/AlgernonMXF/SmartRegionManager/issues)
- **功能建议**：欢迎提交 Issue 或 PR

## 许可证

[MIT License](LICENSE)

## 致谢

- [ReaImGui](https://github.com/cfillion/reaimgui) - GUI 框架
- [ReaPack](https://reapack.com/) - 包管理器
- REAPER 社区
