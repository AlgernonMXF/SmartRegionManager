# Git工作流程指南

本文档描述了本地项目与GitHub之间的最佳工作流程。

## 快速开始

### 日常开发工作流程（简单模式）

```
1. 开始工作前：git pull（拉取最新代码）
2. 进行修改：编辑文件
3. 查看更改：git status, git diff
4. 暂存更改：git add .
5. 提交更改：git commit -m "描述性提交信息"
6. 推送到GitHub：git push
```

## 详细说明

### 1. 开始工作前

在开始任何修改之前，先拉取最新的代码：

```bash
git pull
```

这确保你的本地代码与GitHub上的最新版本同步。

### 2. 进行修改

正常编辑你的文件。可以使用任何编辑器。

### 3. 查看更改

在提交之前，查看你做了哪些更改：

```bash
# 查看工作区状态
git status

# 查看未暂存的更改详情
git diff

# 查看已暂存的更改
git diff --staged
```

### 4. 暂存更改

将更改添加到暂存区：

```bash
# 暂存所有更改
git add .

# 或者暂存特定文件
git add <文件名>
```

### 5. 提交更改

提交暂存的更改：

```bash
git commit -m "描述性提交信息"
```

#### 提交信息规范

使用清晰、描述性的提交信息：

- **格式**：`<类型>: <简短描述>`
- **类型示例**：
  - `feat` - 新功能
  - `fix` - 修复bug
  - `docs` - 文档更新
  - `style` - 代码格式（不影响功能）
  - `refactor` - 重构代码
  - `test` - 测试相关
  - `chore` - 构建过程或辅助工具的变动

- **示例**：
  - `feat: 添加深色主题支持`
  - `fix: 修复Region选择状态问题`
  - `docs: 更新README安装说明`
  - `refactor: 重构GUI模块代码结构`

### 6. 推送到GitHub

将本地提交推送到GitHub：

```bash
git push
```

首次推送后，后续推送不需要指定分支名。

## 常用命令速查

### 查看状态和历史

```bash
# 查看工作区状态
git status

# 查看提交历史（简洁版）
git log --oneline

# 查看提交历史（详细版）
git log

# 查看未暂存的更改
git diff

# 查看已暂存的更改
git diff --staged
```

### 基本操作

```bash
# 暂存所有更改
git add .

# 暂存特定文件
git add <文件路径>

# 提交更改
git commit -m "提交信息"

# 推送到GitHub
git push

# 从GitHub拉取更新
git pull
```

### 撤销操作

```bash
# 撤销工作区的更改（未暂存）
git restore <文件>

# 取消暂存（保留工作区更改）
git restore --staged <文件>

# 修改最后一次提交信息
git commit --amend -m "新的提交信息"

# 撤销最后一次提交（保留更改在工作区）
git reset --soft HEAD~1
```

### 分支操作（可选）

如果需要实验性功能，可以创建临时分支：

```bash
# 创建并切换到新分支
git checkout -b feature/新功能名称

# 或者使用新语法
git switch -c feature/新功能名称

# 切换回main分支
git checkout main
# 或
git switch main

# 合并分支到main
git merge feature/新功能名称

# 删除已合并的分支
git branch -d feature/新功能名称
```

## 冲突处理

如果推送时遇到冲突：

1. **先拉取最新代码**：
   ```bash
   git pull
   ```

2. **解决冲突**：
   - Git会标记冲突的文件
   - 手动编辑文件解决冲突
   - 查找 `<<<<<<<`, `=======`, `>>>>>>>` 标记

3. **标记冲突已解决**：
   ```bash
   git add <解决冲突的文件>
   ```

4. **完成合并**：
   ```bash
   git commit
   ```

5. **推送**：
   ```bash
   git push
   ```

## 最佳实践

### 提交频率

- ✅ **小步提交**：每完成一个小功能或修复就提交
- ❌ **避免大提交**：不要累积大量更改后一次性提交
- ✅ **提交前测试**：确保代码可以正常运行

### 提交信息

- ✅ **清晰描述**：提交信息应该清楚地说明做了什么
- ✅ **使用中文**：项目使用中文，提交信息也用中文
- ❌ **避免无意义信息**：不要写"更新"、"修改"等模糊信息

### 工作流程

- ✅ **先拉取再推送**：推送前先 `git pull` 确保同步
- ✅ **定期提交**：不要长时间不提交代码
- ✅ **重要更改前备份**：可以创建备份分支

## 远程仓库信息

- **仓库地址**：`https://github.com/AlgernonMXF/SmartRegionManager.git`
- **主分支**：`main`
- **查看远程仓库**：`git remote -v`

## 故障排除

### 推送被拒绝

如果推送被拒绝，通常是因为远程有新的提交：

```bash
# 先拉取并合并
git pull

# 解决可能的冲突后
git push
```

### 忘记提交某些文件

如果提交后发现漏了文件：

```bash
# 添加遗漏的文件
git add <文件>

# 修改最后一次提交（不创建新提交）
git commit --amend --no-edit
```

### 撤销错误的提交

如果提交了错误的代码：

```bash
# 撤销最后一次提交（保留更改）
git reset --soft HEAD~1

# 或者完全撤销（丢弃更改）
git reset --hard HEAD~1
```

**注意**：`--hard` 会永久删除更改，请谨慎使用！

## 参考资源

- [Git官方文档](https://git-scm.com/doc)
- [GitHub Guides](https://guides.github.com/)
- [Pro Git Book](https://git-scm.com/book)
