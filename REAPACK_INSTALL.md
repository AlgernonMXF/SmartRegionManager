# ReaPack 安装指南

## 快速安装（4 步）

### 1. 添加仓库

1. 打开 REAPER
2. `Extensions` → `ReaPack` → `Import repositories...`
3. 粘贴以下地址：

   **标准地址：**
   ```
   https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/index.xml
   ```

   **带缓存刷新的地址（推荐）：**
   ```
   https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/index.xml?ts=20260204
   ```

   > 💡 **ts 参数说明：**
   > - `ts` = timestamp（时间戳）
   > - **作用**：绕过 GitHub Raw CDN 缓存，确保获取最新版本
   > - **格式**：`?ts=YYYYMMDD`（如 `?ts=20260204`）
   > - **原理**：每次更改 ts 值，CDN 会认为是新请求，从而返回最新内容
   > - **建议**：每次发布新版本后，更新 ts 值为当天日期

4. 点击 `OK`

### 2. 同步仓库

`Extensions` → `ReaPack` → `Synchronize packages`

### 3. 安装脚本

1. `Extensions` → `ReaPack` → `Browse packages`
2. 搜索：`Smart Region Manager`
3. 右键 → `Install`

### 4. 重启 REAPER

安装完成，重启 REAPER 即可使用。

---

## 常见问题

### 搜索不到脚本？

| 检查项 | 解决方法 |
|--------|----------|
| 未添加仓库 | 执行步骤 1 添加仓库 |
| 未同步 | 执行步骤 2 同步仓库 |
| 搜索词问题 | 尝试搜索 `Smart` 或 `Region` |

**验证仓库已添加：**
- `Extensions` → `ReaPack` → `Manage repositories`
- 应能看到 `SmartRegionManager` 条目

### 添加仓库失败？

**网络问题：**
- 在浏览器中打开 [index.xml 链接](https://raw.githubusercontent.com/AlgernonMXF/SmartRegionManager/main/index.xml)
- 如果无法打开，可能需要代理或 VPN
- 也可以使用[手动安装方式](INSTALLATION.md#方式三手动安装)

**链接错误：**
- 确保完整复制，没有空格
- 确保以 `https://` 开头，以 `.xml` 结尾

### 脚本无法运行？

**缺少 ReaImGui：**
1. `Extensions` → `ReaPack` → `Browse packages`
2. 搜索 `ReaImGui`
3. 安装并重启 REAPER

---

## 更新脚本

**自动更新：**
- `Extensions` → `ReaPack` → `Synchronize packages`
- 如有更新会自动下载

**设置自动同步：**
- `Extensions` → `ReaPack` → `Preferences`
- 勾选 `Auto-sync on startup`

---

## 只同步此仓库

如果你添加了多个仓库，只想更新 SmartRegionManager：

1. `Extensions` → `ReaPack` → `Browse packages`
2. 搜索 `Smart Region Manager`
3. 右键 → `Reinstall` 或 `Update`

---

## 获取帮助

- [完整安装指南](INSTALLATION.md)
- [故障排除](TROUBLESHOOTING.md)
- [GitHub Issues](https://github.com/AlgernonMXF/SmartRegionManager/issues)
