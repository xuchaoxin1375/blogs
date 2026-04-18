[toc]



# Git Remote 命令系统介绍

## 一、概念理解

`remote` 就是为**远程仓库 URL** 起的"**别名**"，方便引用

```
本地仓库 (Local)                    远程仓库 (Remote)
┌─────────────────┐          ┌──────────────────────────┐
│  Working Dir    │          │  origin → GitHub         │
│  Staging Area   │  ←————→  │  gitee  → Gitee          │
│  Local Repo     │          │  gitlab → GitLab         │
└─────────────────┘          └──────────────────────────┘


```

---

## 二、基础命令

### 1. 查看远程仓库

```bash
# 列出所有远程仓库名称
git remote

# 列出名称 + URL（最常用）
git remote -v
```

输出示例：
```
origin  https://github.com/user/repo.git (fetch)
origin  https://github.com/user/repo.git (push)
gitee   https://gitee.com/user/repo.git  (fetch)
gitee   https://gitee.com/user/repo.git  (push)
```

```bash
# 查看某个远程仓库的详细信息
git remote show origin
```

输出示例：
```
* remote origin
  Fetch URL: https://github.com/user/repo.git
  Push  URL: https://github.com/user/repo.git
  HEAD branch: main
  Remote branches:
    main    tracked
    develop tracked
  Local branches configured for 'git pull':
    main    merges with remote main
    develop merges with remote develop
  Local refs configured for 'git push':
    main    pushes to main    (up to date)
    develop pushes to develop (local out of date)
```

---

### 2. 添加远程仓库

```bash
git remote add <名称> <URL>
```

```bash
# 常见用法
git remote add origin  https://github.com/user/repo.git
git remote add gitee   https://gitee.com/user/repo.git
git remote add upstream https://github.com/original/repo.git  # fork 源

# 支持 SSH 协议
git remote add origin git@github.com:user/repo.git
```

> 💡 `origin` 是约定俗成的默认远程仓库名，`upstream` 通常指 fork 的上游仓库。

---

### 3. 删除远程仓库

```bash
git remote remove <名称>
# 或简写
git remote rm <名称>
```

```bash
git remote remove gitee
```

---

### 4. 重命名远程仓库

```bash
git remote rename <旧名称> <新名称>
```

```bash
git remote rename origin github
# origin → github，所有关联的跟踪分支自动更新
# origin/main → github/main
```

---

## 三、URL 管理

### 1. 修改远程仓库 URL

```bash
git remote set-url <名称> <新URL>
```

```bash
# HTTPS 切换为 SSH
git remote set-url origin git@github.com:user/repo.git

# 验证修改结果
git remote -v
```

### 2. 分别设置 fetch 和 push 的 URL

```bash
# 单独设置 push 地址（fetch 地址不变）
git remote set-url --push origin git@github.com:user/repo.git
```

应用场景：
```bash
# fetch 用 HTTPS（无需密钥），push 用 SSH（更安全）
git remote set-url origin https://github.com/user/repo.git         # fetch
git remote set-url --push origin git@github.com:user/repo.git      # push
```

### 3. 添加多个 push URL

```bash
git remote set-url --add --push <名称> <URL>
```

```bash
# 一次 push 推送到多个仓库
git remote set-url --add --push origin https://github.com/user/repo.git
git remote set-url --add --push origin https://gitee.com/user/repo.git

# 此时 git push origin main 会同时推送到两个地址
```

例如:

```bash
git remote set-url --add --push origin https://github.com/xuchaoxin1375/scripts.git
git remote set-url --add --push origin https://gitee.com/xuchaoxin1375/scripts.git
```



### 4. 删除某个 URL

```bash
git remote set-url --delete <名称> <URL正则>
```

```bash
git remote set-url --delete origin https://gitee.com/user/repo.git
```

---

## 四、数据同步命令

### 1. 获取远程数据

```bash
# 获取指定远程仓库的所有分支（不合并）
git fetch <remote>

# 获取所有远程仓库的数据
git fetch --all

# 获取并清理已删除的远程分支引用
git fetch --prune <remote>
# 或
git remote prune <remote>
```

### 2. 拉取并合并

```bash
git pull <remote> <branch>

# 等价于
git fetch <remote>
git merge <remote>/<branch>
```

### 3. 推送

```bash
git push <remote> <branch>

# 推送并设置上游跟踪
git push -u <remote> <branch>

# 推送所有分支
git push <remote> --all

# 推送标签
git push <remote> --tags
```

---

## 五、分支跟踪管理

```bash
# 查看本地分支与远程分支的跟踪关系
git branch -vv
```

输出示例：
```
* main    a1b2c3d [origin/main] Latest commit message
  develop d4e5f6g [origin/develop: ahead 2] Some work
  feature h7i8j9k [gitee/feature: behind 3] Feature branch
```

```bash
# 设置当前分支跟踪指定远程分支
git branch --set-upstream-to=origin/main

# 取消跟踪
git branch --unset-upstream
```

---

## 六、`git remote update`

```bash
# 更新所有远程仓库的引用（等价于 git fetch --all）
git remote update

# 更新时清理无效引用
git remote update --prune
```

---

## 七、查看底层配置

所有 remote 配置都存储在 `.git/config` 中：

```ini
[remote "origin"]
    url = https://github.com/user/repo.git
    fetch = +refs/heads/*:refs/remotes/origin/*

[remote "gitee"]
    url = https://gitee.com/user/repo.git
    fetch = +refs/heads/*:refs/remotes/gitee/*
    pushurl = https://gitee.com/user/repo-mirror.git

[branch "main"]
    remote = origin
    merge = refs/heads/main
```

> 可以直接编辑此文件，效果与命令行相同。

---

## 八、完整命令速查表

```
┌──────────────────────────────────────────┬────────────────────────────────────────┐
│              命令                        │              说明                      │
├──────────────────────────────────────────┼────────────────────────────────────────┤
│ git remote                               │ 列出所有远程仓库名                    │
│ git remote -v                            │ 列出远程仓库名 + URL                  │
│ git remote show <name>                   │ 查看远程仓库详细信息                  │
├──────────────────────────────────────────┼────────────────────────────────────────┤
│ git remote add <name> <url>              │ 添加远程仓库                          │
│ git remote remove <name>                 │ 删除远程仓库                          │
│ git remote rename <old> <new>            │ 重命名远程仓库                        │
├──────────────────────────────────────────┼────────────────────────────────────────┤
│ git remote set-url <name> <url>          │ 修改远程仓库 URL                      │
│ git remote set-url --push <name> <url>   │ 单独设置 push URL                     │
│ git remote set-url --add --push <n> <u>  │ 添加额外 push URL                     │
│ git remote set-url --delete <name> <url> │ 删除某个 URL                          │
├──────────────────────────────────────────┼────────────────────────────────────────┤
│ git remote prune <name>                  │ 清理无效的远程分支引用                │
│ git remote update                        │ 更新所有远程仓库引用                  │
├──────────────────────────────────────────┼────────────────────────────────────────┤
│ git fetch <name>                         │ 获取远程数据（不合并）                │
│ git fetch --all                          │ 获取所有远程仓库数据                  │
│ git push <name> <branch>                 │ 推送到指定远程仓库                    │
│ git push -u <name> <branch>              │ 推送并设置上游跟踪                    │
└──────────────────────────────────────────┴────────────────────────────────────────┘
```

---

## 九、典型工作流示例

### 场景：Fork 项目协作

```bash
# 1. clone 自己 fork 的仓库
git clone https://github.com/myuser/project.git
cd project

# 2. 添加上游原始仓库
git remote add upstream https://github.com/original/project.git

# 3. 查看配置
git remote -v
# origin   https://github.com/myuser/project.git   (fetch)
# origin   https://github.com/myuser/project.git   (push)
# upstream https://github.com/original/project.git  (fetch)
# upstream https://github.com/original/project.git  (push)

# 4. 同步上游最新代码
git fetch upstream
git merge upstream/main
# 或
git rebase upstream/main

# 5. 推送到自己的仓库
git push origin main
```

### 场景：多平台同步镜像

```bash
# 配置一次 push 同步到 GitHub + Gitee + GitLab
git remote set-url --add --push origin https://github.com/user/repo.git
git remote set-url --add --push origin https://gitee.com/user/repo.git
git remote set-url --add --push origin https://gitlab.com/user/repo.git

# 日常操作，一条命令全部同步
git push origin main
```