[toc]

## abstract

- 这里的老和新是相对而言的
- 到了一定时间这里所谓的新可能会也会变成"老"

### 老版本checkout

**老版 `git checkout` 特性**：

在Git的老版本中（尤其是2.23版本以前），`git checkout` 命令具有多种功能：

1. **切换分支**：
   ```bash
   git checkout <branch>
   ```
   这个命令可以用来切换当前工作目录和索引到指定分支，更新工作目录以反映目标分支的最新提交。

2. **恢复文件**：
   ```bash
   git checkout <commit> -- <file>
   ```
   可以用于恢复单个文件到指定提交的状态，从而丢弃工作目录中对此文件的未提交更改。

3. **检出提交**：
   ```bash
   git checkout <commit-hash>
   ```
   将HEAD指向特定提交，但不会自动创建新的分支，而是进入DETACHED HEAD模式，此时的工作目录反映了该提交时的状态。

4. **创建新分支并切换**：
   ```bash
   git checkout -b <new-branch>
   ```
   创建并立即切换到一个新分支，新分支基于当前HEAD位置创建。

### 新版checkout

**新版 `git checkout` 使用调整与新命令**：

自Git 2.23版本开始，`git checkout` 的功能被拆分为两个新命令，以提高清晰度和安全性：

- **`git switch`**：
   专门用于切换分支，避免了原来`git checkout`命令在切换分支时可能引发的混淆情况。
   ```bash
   git switch <branch>
   ```
   或者创建并切换到新分支：
   ```bash
   git switch -c <new-branch>
   ```

- **`git restore`**：
   专门用于恢复文件或暂存区域的状态，以取代`git checkout`在恢复文件方面的功能。
   ```bash
   git restore <file>
   ```
   恢复工作目录中的文件到最近一次提交的状态（丢弃未提交的更改）：
   ```bash
   git restore --source=HEAD --staged --worktree <file>
   ```

### 小结

- 这样改进后的命令结构让开发者更容易理解每个命令的具体用途，降低了误操作的可能性，尤其是在处理不同场景时。
- 不过，尽管有新命令的推荐使用方式，老版的`git checkout`命令在很多情况下仍能正常使用，只是其多用途特性可能导致在某些复杂场景下不够直观。



