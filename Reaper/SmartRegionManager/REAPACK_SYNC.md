# ReaPack 同步指南：只同步 SmartRegionManager

## 为什么需要选择性同步？

如果您添加了多个 ReaPack 仓库，`Synchronize packages` 会同步所有仓库，这可能：
- 耗时较长（特别是网络慢时）
- 更新很多不需要的包
- 占用带宽

## 方法一：在包浏览器中直接更新（最简单）

这是最直接的方法，只更新 Smart Region Manager 这一个包：

### 步骤：

1. **打开包浏览器**
   - `Extensions` → `ReaPack` → `Browse packages`

2. **搜索 Smart Region Manager**
   - 在搜索框中输入：`Smart Region Manager`
   - 或者：`Smart`、`Region Manager`

3. **右键点击包**
   - 找到 `Smart Region Manager` 条目
   - **右键点击**该条目

4. **选择操作**
   - 如果已安装：选择 `Reinstall`（重新安装最新版本）
   - 如果有更新：选择 `Update`（更新到新版本）
   - 如果未安装：选择 `Install`（安装）

5. **完成**
   - 这会只更新 Smart Region Manager，不会影响其他包

**优点：**
- ✅ 最简单直接
- ✅ 只更新需要的包
- ✅ 不需要同步其他仓库

## 方法二：临时禁用其他仓库

如果您想同步整个 SmartRegionManager 仓库（包括未来可能添加的其他包）：

### 步骤：

1. **打开仓库管理**
   - `Extensions` → `ReaPack` → `Manage repositories`
   - 会显示所有已添加的仓库列表

2. **禁用其他仓库**
   - 找到其他不需要同步的仓库
   - **取消勾选**（点击复选框）
   - 只保留 `SmartRegionManager` 仓库**勾选**（启用）

3. **执行同步**
   - `Extensions` → `ReaPack` → `Synchronize packages`
   - 现在只会同步 SmartRegionManager 仓库

4. **重新启用其他仓库**（可选）
   - 同步完成后，可以重新勾选其他仓库
   - 这样下次同步所有仓库时，它们会再次被同步

**优点：**
- ✅ 同步整个仓库（包括未来添加的包）
- ✅ 不影响已禁用的仓库

**缺点：**
- ⚠️ 需要手动启用/禁用仓库

## 方法三：使用仓库过滤器（高级）

ReaPack 的包浏览器支持按仓库过滤：

1. **打开包浏览器**
   - `Extensions` → `ReaPack` → `Browse packages`

2. **使用过滤器**
   - 查看是否有仓库过滤器选项
   - 选择只显示 `SmartRegionManager` 仓库的包

3. **批量操作**
   - 可以选中该仓库下的所有包
   - 批量更新

## 推荐方法

**对于日常使用：推荐方法一（包浏览器直接更新）**

- 最简单快捷
- 只更新需要的包
- 不需要管理仓库状态

**对于首次安装或需要同步整个仓库：使用方法二（临时禁用其他仓库）**

- 确保仓库中的所有包都是最新版本
- 适合仓库中有多个包的情况

## 常见问题

### Q: 为什么 `Synchronize packages` 会同步所有仓库？

**A:** 这是 ReaPack 的默认行为，设计用于保持所有已安装的包都是最新版本。如果您只想更新特定包，使用上面的方法一。

### Q: 禁用仓库会影响已安装的包吗？

**A:** 不会。禁用仓库只是阻止同步该仓库，已安装的包仍然可以正常使用。您可以随时重新启用仓库。

### Q: 如何知道 Smart Region Manager 有更新？

**A:** 
- 在包浏览器中，有更新的包会显示特殊标记
- 或者定期使用 `Synchronize packages` 检查（虽然会同步所有仓库）

### Q: 可以设置自动只同步 SmartRegionManager 吗？

**A:** ReaPack 不支持选择性自动同步。但您可以：
- 禁用其他仓库，只保留 SmartRegionManager 启用
- 然后启用 `Auto-sync on startup`（启动时自动同步）
- 这样每次启动 REAPER 时只会同步 SmartRegionManager

## 快速参考

| 操作 | 菜单路径 | 说明 |
|------|----------|------|
| 只更新 Smart Region Manager | `Browse packages` → 右键 → `Reinstall`/`Update` | 最简单，推荐 |
| 只同步 SmartRegionManager 仓库 | `Manage repositories` → 禁用其他 → `Synchronize packages` | 同步整个仓库 |
| 同步所有仓库 | `Synchronize packages` | 默认行为 |

---

**提示：** 对于大多数用户，方法一（包浏览器直接更新）是最实用的选择。
