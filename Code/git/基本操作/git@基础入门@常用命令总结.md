[toc]

## abstract

下面提供一份详细的 Git 基础入门教程，并附上最实用 Git 命令的总结说明，帮助你从零开始掌握 Git 的基本用法，并了解如何在项目中进行版本管理和团队协作。

Git 是一种分布式版本控制系统（*Distributed Version Control System*），由 Linus Torvalds 开发。它能够跟踪文件（尤其是源代码）的修改历史，并支持多人协同开发。与集中式版本控制系统相比，Git 具有以下优点：

- **分布式存储（Distributed Storage）**：每个开发者的本地仓库（*Repository*）都包含完整的历史记录，即使网络断开也能工作。
- **速度快（Fast Performance）**：操作大多数在本地完成，提交（*Commit*）、分支（*Branch*）、合并（*Merge*）等操作非常迅速。
- **分支管理灵活（Flexible Branch Management）**：创建、合并和删除分支都非常简单，便于并行开发。

------

## Git 的安装

1. **Windows 系统：**

   - 下载地址：[Git for Windows](https://gitforwindows.org/)
   - 安装时可以选择 Git Bash 作为命令行工具。

2. **macOS 系统：**

   - 可以通过 Homebrew 安装：

     ```bash
     brew install git
     ```

   - 或者下载 [Git 官方安装包](https://git-scm.com/download/mac)。

3. **Linux 系统：**

   - 在 Debian/Ubuntu 上：

     ```bash
     sudo apt update
     sudo apt install git
     ```

   - 在 Fedora 上：

     ```bash
     sudo dnf install git
     ```

------

## Git 基本概念与命令

### **仓库（Repository）**

 Git 仓库是存放项目文件及其版本历史的地方。常见操作包括创建本地仓库和克隆远程仓库。

- 初始化本地仓库：

  ```bash
  git init
  ```

  *init：初始化*

- 克隆远程仓库：

  ```bash
  git clone https://github.com/username/project.git
  ```

  *clone：克隆*



#### 简易的命令行入门教程:

Git 全局设置:

```bash
git config --global user.name "xuchaoxin1375"
git config --global user.email "838808930@qq.com"
```

创建 git 仓库:

```bash
mkdir wp-site-build
cd wp-site-build
git init -b "main"
touch README.md
git add README.md
git commit -m "first commit"
git remote add origin https://gitee.com/xuchaoxin1375/demo.git
git push -u origin "main"
```

已有仓库?

```bash
cd existing_git_repo
git remote add origin https://gitee.com/xuchaoxin1375/demo.git
git push -u origin "main"
```

#### 初始化仓库git branch失效问题

如果用git init初始化某个目录为git仓库后,`git branch`这类命令可能无法正确工作,你需要创建必要内容(比如readme.md文件)并且通过`add`,`commit`命令完成第一次提交后才会变得可用或者具有非空白非错误的交互消息



### 其他

#### **跟踪和暂存文件**

- 查看当前状态：

  ```bash
  git status
  ```

  *status：状态*

- 添加文件到暂存区（*Staging Area*）：

  ```bash
  git add filename
  ```

  或添加所有修改的文件：

  ```bash
  git add .
  ```

  *add：添加*

1. **提交修改**

   - 提交暂存区中的文件到仓库：

     ```bash
     git commit -m "提交说明"
     ```

     commit：提交

2. **查看历史记录**

   - 查看提交记录：

     ```bash
     git log
     ```

     可以使用 

     ```
     --oneline
     ```

      参数简化显示：

     ```bash
     git log --oneline
     ```

     log：日志

3. **分支管理**

   分支（*Branch*）可以让你在不影响主分支（通常是 `master` 或 `main`）的情况下独立开发新功能。

   - 查看所有分支：

     ```bash
     git branch
     ```

     *branch：分支*

   - 创建新分支：

     ```bash
     git branch new-feature
     ```

   - 切换到新分支：

     ```bash
     git checkout new-feature
     ```

     或使用快捷命令同时创建并切换：

     ```bash
     git checkout -b new-feature
     ```

     *checkout：切换*

   - 合并分支到当前分支（例如，将 `new-feature` 合并到 `main`）：

     ```bash
     git merge new-feature
     ```

     *merge：合并*

4. **远程仓库操作**

   与远程仓库（*Remote Repository*）交互时常用的命令有：

   - 查看远程仓库地址：

     ```bash
     git remote -v
     ```

     *remote：远程*

   - 添加远程仓库：

     ```bash
     git remote add origin https://github.com/username/project.git
     ```

   - 从远程仓库拉取更新（*pull*）：

     ```bash
     git pull origin main
     ```

     *pull：拉取*

   - 推送本地提交到远程仓库（*push*）：

     ```bash
     git push origin main
     ```

     *push：推送*

------

## Git 工作流程示例

假设你正在开发一个新功能，可以按照以下步骤进行操作：

1. 在本地初始化仓库或克隆远程仓库。

   ```bash
   git clone https://github.com/username/project.git
   cd project
   ```

2. 创建并切换到新分支：

   ```bash
   git checkout -b new-feature
   ```

3. 修改代码后，查看状态：

   ```bash
   git status
   ```

4. 添加修改到暂存区：

   ```bash
   git add .
   ```

5. 提交修改：

   ```bash
   git commit -m "添加新功能：描述功能细节"
   ```

6. 与远程仓库同步更新（确保你所在分支与远程分支保持一致）：

   ```bash
   git pull origin new-feature --rebase
   ```

   *rebase（变基）：使提交历史更直线化*

7. 推送新分支到远程仓库：

   ```bash
   git push origin new-feature
   ```

8. 在 GitHub 或其他平台上发起 Pull Request，待代码审核后合并到主分支。

------

## 常用 Git 命令总结

下面用一张表格总结日常开发中最实用的 Git 命令：

| 命令                          | 描述                                             | 示例                                       |
| ----------------------------- | ------------------------------------------------ | ------------------------------------------ |
| `git init`                    | 初始化一个新的 Git 仓库                          | `git init`                                 |
| `git clone <repo_url>`        | 克隆一个远程仓库                                 | `git clone https://github.com/xxx/xxx.git` |
| `git status`                  | 查看当前工作区与暂存区的状态                     | `git status`                               |
| `git add <file>`              | 将文件添加到暂存区                               | `git add index.html`                       |
| `git commit -m "message"`     | 提交暂存区中的修改到仓库                         | `git commit -m "修复了 bug"`               |
| `git log`                     | 查看提交历史记录                                 | `git log --oneline`                        |
| `git branch`                  | 列出本地分支                                     | `git branch`                               |
| `git branch <branch_name>`    | 创建新分支                                       | `git branch feature-1`                     |
| `git checkout <branch>`       | 切换到指定分支                                   | `git checkout feature-1`                   |
| `git checkout -b <branch>`    | 创建并切换到新分支                               | `git checkout -b feature-1`                |
| `git merge <branch>`          | 合并指定分支到当前分支                           | `git merge feature-1`                      |
| `git remote -v`               | 查看远程仓库信息                                 | `git remote -v`                            |
| `git remote add <name> <url>` | 添加远程仓库                                     | `git remote add origin https://...`        |
| `git pull <remote> <branch>`  | 从远程仓库拉取并合并更新                         | `git pull origin main`                     |
| `git push <remote> <branch>`  | 推送本地提交到远程仓库                           | `git push origin main`                     |
| `git diff`                    | 查看工作区与暂存区、或暂存区与最新提交之间的差异 | `git diff`                                 |
| `git reset`                   | 撤销暂存区的更改或重置分支历史                   | `git reset HEAD <file>`                    |

------

## 进阶使用与常见问题

1. **回退操作**

   - 若需要撤销某次提交（

     commit

     ），可使用 

     ```
     git revert
     ```

      创建一个新的反向提交。

     ```bash
     git revert <commit_id>
     ```

2. **解决冲突**

   - 在分支合并或拉取（*pull*）操作时，可能会遇到冲突。解决冲突后，需使用 `git add` 将修改标记为已解决，然后提交。

3. **使用标签（Tag）管理版本**

   - 为重要版本打标签：

     ```bash
     git tag -a v1.0 -m "版本 1.0 发布"
     ```

   - 推送所有标签到远程仓库：

     ```bash
     git push origin --tags
     ```

4. **简化操作**

   - 可以通过配置别名（

     alias

     ）来缩短常用命令，例如：

     ```bash
     git config --global alias.co checkout
     git config --global alias.br branch
     git config --global alias.ci commit
     git config --global alias.st status
     ```

------

## 总结

本教程介绍了 Git 的基本概念、安装方法、常用命令以及典型工作流程。通过理解仓库（Repository）、提交（Commit）、分支（Branch）、合并（Merge）等关键概念，并熟练掌握常用命令，你可以高效管理项目版本并实现团队协作。

建议在实际项目中多练习、探索 Git 的更多高级功能，如变基（Rebase）、标签（Tag）、子模块（Submodule）等，从而不断提升版本管理和协作能力。