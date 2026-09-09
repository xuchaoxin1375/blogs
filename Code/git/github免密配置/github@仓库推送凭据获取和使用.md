[toc]

# 获取推送凭证

---

## 一、首次配置（仅需一次）

### 1. 安装 Git 并配置身份
```bash
git config --global user.name "你的用户名"
git config --global user.email "你的邮箱@example.com"
```

### 2. 认证方式（二选一）

**方式A：HTTPS + Personal Access Token（推荐）**
- GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
- 生成新 token，勾选 `repo` 权限
- 复制 token（只显示一次！）

**方式B：SSH 密钥**
```bash
ssh-keygen -t ed25519 -C "你的邮箱@example.com"
cat ~/.ssh/id_ed25519.pub  # 复制内容
```
- GitHub → Settings → SSH and GPG keys → 粘贴保存

---

## 二、日常推送流程

### 1. 在 GitHub 上新建仓库（不要勾选 README）

### 2. 关联本地项目并推送
```bash
# 初始化本地仓库
git init

# 添加所有文件
git add .
git commit -m "首次提交"

# 添加远程仓库地址
git remote add origin https://github.com/用户名/仓库名.git
# 或 SSH：git remote add origin git@github.com:用户名/仓库名.git

# 推送（首次需设置上游分支）
git push -u origin main
# 或 master（看默认分支名）
```

### 3. 后续更新推送
```bash
git add .                          # 暂存修改
git commit -m "更新说明"           # 提交到本地
git pull origin main --rebase      # 拉取远程最新代码（避免冲突）
git push origin main               # 推送到远程
```

---

## 三、重要注意事项

### 1. 推送前先拉取
多人协作时，**务必先 `git pull`**，否则推送会被拒绝。

### 2. 强制推送（谨慎使用）
```bash
git push -f origin main   # 覆盖远程，会丢失他人提交
```

### 3. 查看远程地址
```bash
git remote -v
```

### 4. 修改远程地址
```bash
git remote set-url origin 新地址
```

---

## 四、常见报错解决

| 报错信息                              | 解决方法                                        |
| ------------------------------------- | ----------------------------------------------- |
| `Permission denied (publickey)`       | SSH 密钥未添加或错误，改用 HTTPS 方式           |
| `Authentication failed`               | 密码输错？改用 Token 代替密码                   |
| `failed to push some refs`            | 远程有新提交，先 `git pull` 再推送              |
| `src refspec main does not match any` | 本地没有 main 分支，检查分支名或先 `git commit` |

---

## Fine-grained personal access token 推送

 GitHub 官方现在推荐的方式。Fine-grained personal access token 完全可以用于 `git push`，比经典 token 更安全。

不过，要让它能正常推送，有**两个关键点**必须设置正确，否则会报 403 权限错误。

### 为什么容易遇到问题？
很多人在创建 fine-grained token 时，可能没有明确给这个 token 赋予 **仓库内容** 的写入权限，或者没有让它 **关联到你要操作的具体仓库**。因为 fine-grained token 的权限非常精确，少勾选一项就无法正常工作。

### 创建能推送的 Fine-Grained Token 步骤

为了成功推送，创建时请重点检查下面这几项设置：

1.  **进入创建页面**：在 GitHub 设置里，依次进入 `Developer settings` -> `Personal access tokens` -> `Fine-grained tokens`，然后点击生成新 token。
2.  **关键设置 ①：仓库访问权限 (Repository access)**
    *   默认的public仓库时read-only的(可以用来查询公开仓库的star数量),通常不是我们想要的.如果要推送仓库,务必选择下面两种选项之一.
    *   如果你只想让 token 操作特定的仓库，请选择 **`Only select repositories`**，然后在下方的列表里**明确勾选**你要推送的那个仓库。
    *   (如果选 `All repositories`，token 就能操作你名下所有仓库)。
3.  **关键设置 ②：仓库权限 (Repository permissions)**
    *   在长长的权限列表里，找到 **`Contents`** 这一项。
    *   将它的权限设置为 **`Read and write`**。这是让 token 能推送代码变更的核心权限。
4.  **生成并保存**：点击生成后，**立刻复制并保存好这个 token**，它只显示这一次。

### 如何使用这个 Token 推送

创建好 token 后，在命令行推送时使用它和之前回答里的流程完全一样。当 Git 提示你输入密码时，**粘贴这个新生成的 fine-grained token 作为密码**，用户名还是你的 GitHub 用户名。

```bash
git push origin main
# Username: 你的GitHub用户名
# Password: 粘贴你的 fine-grained token
```

### 特别提醒

*   **机构限制**：如果你的仓库属于某个组织 (Organization)，并且该组织启用了 SAML SSO，你可能需要在 token 旁边点击 `Authorize` 按钮进行额外授权。
*   **到期时间**：fine-grained token 通常会有有效期（默认可能较短），请注意设置或记得在到期前更新。

# 记住凭据避免重复验证

---

## 方法一：Git 凭证管理器（最推荐）

Git 官方自带的凭证管理器，会在系统钥匙串/凭据管理器中安全存储。

### Windows（Git for Windows 默认自带）
```bash
# 开启凭证管理器（通常默认已开启）
git config --global credential.helper manager-core
# 或旧版本用
git config --global credential.helper manager

# 首次输入后，凭证会永久保存在 Windows 凭据管理器中
# 控制面板 → 用户账户 → 凭据管理器 → Windows 凭据 → 可查看/删除
```

### macOS（钥匙串）
```bash
git config --global credential.helper osxkeychain
# 凭证会保存在 Mac 的"钥匙串访问"中
```

### Linux（需要额外安装）
```bash
# Ubuntu/Debian
sudo apt-get install git-credential-libsecret
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret

# 或者用更简单的缓存方式（见方法二）
```

---

## 方法二：缓存模式（临时记住）

凭证会在内存中缓存一段时间（默认 15 分钟），适合临时使用。

```bash
# 记住 1 小时（3600 秒）
git config --global credential.helper 'cache --timeout=3600'

# 永久缓存（不推荐，不安全）
git config --global credential.helper 'cache --timeout=9999999'
```

**优点**：无需安装额外工具  
**缺点**：重启电脑后需要重新输入；明文存内存

---

## 方法三：在 URL 中嵌入 Token（最方便但稍不安全）

直接让 Git 记住你的 token，适合个人开发环境：

```bash
# 方式 A：修改远程地址（推荐，更干净）
git remote set-url origin https://用户名:你的token@github.com/用户名/仓库名.git

# 例如：
git remote set-url origin https://zhangsan:ghp_xxxxxx@github.com/zhangsan/my-repo.git

# 方式 B：全局配置
git config --global credential.helper 'store --file ~/.git-credentials'
# 然后手动编辑 ~/.git-credentials 文件
# 格式：https://用户名:token@github.com
```

**注意**：用 `git remote -v` 查看远程地址时，token 会明文显示，有泄露风险。建议仅在不公开的私人电脑上使用。

---

## 方法四：SSH 密钥（最安全，免输密码）

用 SSH 协议替代 HTTPS，配合 ssh-agent 一次性加载密钥：

```bash
# 1. 生成密钥（如果还没有）
ssh-keygen -t ed25519 -C "你的邮箱"

# 2. 添加到 ssh-agent（输入一次密码，持续记住）
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 3. 将公钥添加到 GitHub（见之前的回答）

# 4. 修改远程地址为 SSH 格式
git remote set-url origin git@github.com:用户名/仓库名.git

# 5. 后续推送无需任何密码
git push origin main
```

**优点**：最安全；配合 ssh-agent 可免密  
**缺点**：首次配置稍复杂；多台设备需分别添加公钥

---

## 方法对比速查表

| 方法                | 安全性 | 持久性               | 适用场景         |
| ------------------- | ------ | -------------------- | ---------------- |
| **凭证管理器**      | ⭐⭐⭐⭐⭐  | 永久（直到手动删除） | **最推荐，通用** |
| **缓存模式**        | ⭐⭐⭐    | 按时间（默认15分钟） | 临时使用         |
| **URL 嵌入 Token**  | ⭐⭐     | 永久                 | 个人开发机       |
| **SSH + ssh-agent** | ⭐⭐⭐⭐⭐  | 永久（重启需重加载） | 安全要求高的环境 |

---

## 针对你的 Fine-Grained Token 的操作建议

**最省心方案**（Windows + macOS）：
```bash
# 开启系统凭证管理器
git config --global credential.helper manager-core   # Windows
# 或
git config --global credential.helper osxkeychain    # macOS

# 然后推送时输入一次用户名和 token，以后就自动记住了
git push origin main
# Username: 你的GitHub用户名
# Password: 粘贴你的 fine-grained token（只输这一次！）
```

以后打开命令行，直接 `git push` 就行，再也不用输入任何东西了 🎉

---

## 如何查看/删除已保存的凭证

**Windows**：
- 控制面板 → 用户账户 → 凭据管理器 → Windows 凭据
- 找到 `git:https://github.com` 点击删除/编辑

**macOS**：
- 打开"钥匙串访问" → 搜索 `github` → 删除对应条目

**命令行**：
```bash
# 清除缓存
git config --global --unset credential.helper
git config --global credential.helper manager-core  # 重新开启

# 或者直接重置所有
git config --global --unset-all credential.helper
```

---

选择最适合你的方式吧！如果配置过程中遇到报错，把命令和提示贴给我，我帮你排查 😊