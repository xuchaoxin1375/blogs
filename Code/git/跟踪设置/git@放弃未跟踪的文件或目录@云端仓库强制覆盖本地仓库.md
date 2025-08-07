[toc]

## abstract

- 假设用户有多个设备,这些设备中有一台主力设备,其他是辅助设备
- 我现在有一个仓库是保存笔记和博客的,我希望主力机上的最新版本能够同步到辅助设备上
- 通常使用`git pull <origin main/master>`这类语句即可
- 然而有时候我会在辅助设备的笔记仓库中编辑一些笔记,也可能不经意改动了某个笔记
- 这时候使用`git pull origin main`,就会报错(Abort/error)

## 基础的解决方案🎈

- 以下方案基础且暴力,需要谨慎使用

- 如果经过排查哪些引起pull失败的文件不再需要,则可以如下操作

  - ```bash
    git clean -fd #清除所有未跟踪文件
    git checkout .
    git reset --hard origin main #尝试拉取云端覆盖本地(这里假设远程的目标分支为main(早期默认为master分支))
    ```

## 补充

### 使用reset

- 如果你想放弃本地仓库的所有更改，包括暂存区和工作目录中的所有未提交更改，并使本地仓库与远程仓库的最新版本保持一致，可以按照以下步骤操作：

  1. **丢弃所有未提交的本地更改**：
     ```bash
     git reset --hard HEAD
     ```
     这个命令会丢弃所有未提交的本地更改，并使工作目录和当前HEAD指向的提交状态一致。

  2. **更新至远程仓库最新版本**：
     首先，获取远程仓库的最新变更列表：
     ```bash
     git fetch origin
     ```
     接着，根据需要，如果你想要切换到主分支并合并远程仓库的最新主分支：
     ```bash
     git checkout main
     git merge origin/main
     ```
     或者，如果你想直接把本地分支设置成与远程分支完全一样（即使本地有未合并的提交也会被丢弃）：
     ```bash
     git reset --hard origin/main
     ```
     上述命令会丢弃所有本地提交，并将当前分支指向远程仓库`origin`上的`main`分支的最新提交。

- 请确保在执行这些操作前，你对任何未提交的本地更改进行了必要的备份或记录，因为`git reset --hard`会永久丢弃未提交的改动。

### reset 不影响未跟踪的文件

- `git reset` 命令主要用于重置当前分支的HEAD引用到指定提交，或者更新暂存区与指定提交内容一致。对于未跟踪的文件（untracked files），`git reset` 命令通常不会直接影响它们，因为未跟踪的文件是指那些尚未被 Git 添加到版本控制下的文件。
- 当你执行 `git reset` 回退到某个提交时，Git会根据你使用的具体参数（如`--mixed`、`--soft`、`--hard`）来决定哪些内容会被回退，但无论哪种方式，未跟踪的文件始终不会被Git的 `reset` 命令触及。它们依然存在于你的工作目录中，保持未被Git管理的状态。

### 处理未被跟踪的文件(目录)

- 可以选择清除或者加入git跟踪

#### 清除

- 如果你想要清理未跟踪的文件，应该使用 `git clean` 命令而不是 `git reset`。例如，要删除所有未跟踪的文件，可以使用：

  ```bash
  git clean -f
  ```

  这里 `-f` 参数表示强制删除未跟踪的文件。同样，为了避免意外删除重要文件，可以先使用 `-n` 参数进行预览：

  ```bash
  git clean -n
  ```

#### 加入跟踪

- 利用`git add`将想要跟踪的文件(目录)添加为git跟踪文件

## FAQ

### 未跟踪文件和云端仓库的文件同路径但不同内容报错

- 错误信息 "error: The following untracked working tree files would be overwritten by merge" 是 Git 在尝试执行合并操作（比如 `git merge` 或 `git pull`）时遇到的一个问题。
- 当 Git 发现本地存在一些未被跟踪（untracked）的文件，而这些文件与即将合并进来的远程分支或 commit 中的文件路径相同(内容不同)，Git 会阻止这次合并操作，因为它不想未经用户同意就覆盖这些未被版本控制的文件。这可以理解为一种冲突

具体来说，这种情况的发生原因可能是：

1. 本地有一些新增的文件，你还没有通过 `git add` 加入到版本库中。
2. 远程仓库的相应分支上也有同样的文件名，且内容不同。

#### 方案

解决方法通常包括以下几个步骤：

- 如果这些未跟踪的文件是可以安全删除或覆盖的，那么可以手动删除这些文件，然后重新尝试合并操作。
- 如果你希望保留这些未跟踪文件的内容，并且它们应当被纳入版本控制，
  - 逐个比对造成冲突的文件内容
  - 将它们添加到暂存区 (`git add`) 并提交 (`git commit`)，然后再进行合并。

- 如果这些文件是临时文件或者不应该被纳入版本控制，可以直接移除它们，然后执行 `git merge` 或 `git pull`。

另外，也可以使用 `git clean` 命令来清除未跟踪的文件（请务必谨慎操作，以免丢失重要数据）：

```bash
# 先预览哪些文件会被删除
git clean -n

# 确认无误后删除未跟踪的文件
git clean -f
```

在执行 `git clean` 之前，最好先查看一下哪些文件会被影响，防止意外删除重要数据。如果你需要保留这些未跟踪文件，就需要采取其他策略，比如移动文件到别处，待合并完成后，再决定如何处理这些文件。

## 云端仓库强制覆盖本地仓库👺

有时候我们想要在主设备之外的副设备上部署新版仓库，那么旧版仓库中如果被污染,那么就无法直接顺利更新

```cmd
remote: Enumerating objects: 36, done.
remote: Counting objects: 100% (36/36), done.
remote: Compressing objects: 100% (29/29), done.
remote: Total 31 (delta 11), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (31/31), 2.18 MiB | 901.00 KiB/s, done.
From https://gitee.com/xuchaoxin1375/configs
 * branch            main       -> FETCH_HEAD
   ccaf71d..91daf0b  main       -> origin/main
#报错内容   
error: Your local changes to the following files would be overwritten by merge:
        wtConf.json
Please commit your changes or stash them before you merge.
error: The following untracked working tree files would be overwritten by merge:
        aria2.conf
Please move or remove them before you merge.
Aborting
Updating 17ca8cf..91daf0b
 was try to updated.
```


如果你想强制拉取远程分支并放弃本地的所有文件和修改，可以使用以下命令：

### 放弃本地所有未提交的更改🎈🎈

首先，你需要清除本地的所有更改和未追踪的文件。你可以使用以下命令：

```bash
git reset --hard HEAD
git clean -fd
```

- `git reset --hard HEAD` 会将你的工作目录和暂存区重置到最后一次提交的状态，放弃所有未提交的更改。
- `git clean -fd` 会删除所有未追踪的文件和目录（确保没有需要保留的文件，否则会丢失）。

### 强制拉取远程分支

然后，你可以使用 `git fetch` 和 `git reset` 来强制更新你的本地分支：

```bash
git fetch origin
git reset --hard origin/main
```

- `git fetch origin` 拉取远程仓库的更新。
- `git reset --hard origin/main` 强制将本地的 `main` 分支重置为远程仓库的 `main` 分支。

### 直接强制拉取👺

**如果你直接想用 `git pull` 强制拉取：**

你也可以直接执行以下命令来强制覆盖本地的更改：

```bash
git fetch origin
git reset --hard origin/main
git pull
```

这样可以确保你拉取到最新的远程分支，同时放弃本地的所有更改。

**注意**：以上操作会导致本地所有未提交的更改和未追踪的文件被永久删除，请确保你不再需要这些更改。
