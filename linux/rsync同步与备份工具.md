[toc]



---

## 🧩 基础命令结构

```bash
rsync [选项] 源路径 目标路径
```

传输方向有2个:

- 本地路径->远程路径
- 远程路径->本地路径

例如

```bash
rsync -avz -e "ssh -i /path/to/key" /local/zips/ user@server-b:/backup/
```

---

从远程服务器拉取

```bash
user="root" #默认root
# 远程主机
remote_host=""
# 本地路径
local_path=""
# 远程路径
remote_path=""

#准备
authority="$user"@"$remote_host"
remote_full_path="$authority":"$remote_path"

mkdir -p "$local_path"

rsync -avzP "$remote_full_path" "$local_path" 
```



## 📚 核心常用参数详解（按你脚本中出现的）

###  `-a`（archive mode，归档模式）→ 最常用！

这个选项相当于一系列细粒度操作选项的简写,`-a`等价于：`-rlptgoD`

- `r` = recursive（递归子目录）
- `l` = copy symlinks as symlinks（保留软链接）
- `p` = preserve permissions（保留权限）
- `t` = preserve modification times（保留修改时间）
- `g` = preserve group（保留组）
- `o` = preserve owner（保留所有者）→ 需要 root 权限
- `D` = preserve device & special files（设备文件等，一般用不到）

> 💡 **对备份场景非常重要**：保留原始文件属性，避免每次同步都“重新传输”。

⚠️ 注意：`-a` 不包含 `-H`（硬链接）和 `-A`/`-X`（ACL/扩展属性），如需可额外添加。

---

###  `-v`（verbose，详细输出）

- 显示同步过程中的文件名
- 用于调试或日志记录
- 可叠加：`-vv` 更详细，`-vvv` 最详细

> 📝 你写入日志时建议保留 `-v`，方便排查哪些文件被传输了。

---

###  `-z`（compress，压缩传输）

- 传输过程中压缩数据，**节省带宽**
- 特别适合网络较慢或文件较大的情况
- 对已经压缩的文件（如 `.zip`, `.tar.gz`）效果有限，但仍会尝试压缩元数据

>  你备份的是压缩包，加 `-z` 仍有益（尤其网络慢时），不加也不影响功能。

---

###  `-e "ssh -i ..."`（指定远程 shell / SSH 参数）

- 默认 `rsync` 使用 `ssh` 连接远程
- `-e` 用于自定义 SSH 命令，比如指定私钥、端口等

示例：

```bash
-e "ssh -i /home/user/.ssh/id_rsa_backup -p 2222"
```

> 🔐 你使用密钥认证，必须通过 `-e` 指定私钥路径，否则会提示输入密码（导致 cron 失败）

---

##  其他非常有用的备份参数（推荐了解）

###  `--delete`（慎用！）

- 删除目标端“源端没有的文件”
- 用于“镜像同步”，保持两端完全一致
- ❗ 你**不需要**这个参数 —— 你只是备份，不是镜像！

###  `--dry-run` 或 `-n`（试运行）

- 模拟执行，不实际传输
- 用于测试命令是否按预期工作

```bash
rsync -avz -n /source/ user@host:/dest/
```

>  强烈建议首次运行前加 `-n` 测试！

---

###  `--include="*.zip" --exclude="*"`（文件过滤）

- `--include`：包含匹配模式的文件
- `--exclude`：排除匹配模式的文件
- 顺序敏感！先 include，再 exclude

你脚本中：

```bash
--include="*.zip" \
--include="*.tar.gz" \
--exclude="*" \
```

意思是：

1. 包含 `.zip`
2. 包含 `.tar.gz`
3. 排除其他所有文件 → **只同步压缩包**

>  非常适合你的场景！

---

###  `--progress`（显示传输进度）

- 用于手动执行时查看大文件传输进度
- 在 cron 脚本中一般不加（日志会太长）

---

###  `--bwlimit=KBPS`（限速）

- 限制传输带宽，避免影响线上服务
- 例如 `--bwlimit=1000` = 1MB/s

---

###  `--remove-source-files`（传输后删除源文件）

- 同步完成后删除本地文件
- ❗ 你**明确不要**这个 —— 你说“删除由你手动控制”

---

## 🧪 示例：完整备份命令（带注释）

```bash
rsync -avz \
    -e "ssh -i /home/ubuntu/.ssh/id_rsa_backup" \
    --include="*.zip" \
    --include="*.tar.gz" \
    --exclude="*" \
    /var/www/uploads/ \
    backup@192.168.1.100:/backup/site-packages/ \
    >> /var/log/backup.log 2>&1
```

📌 说明：

- 递归同步 `/var/www/uploads/` 下的 `.zip` 和 `.tar.gz`
- 通过指定私钥 SSH 到 `192.168.1.100`
- 备份到远程 `/backup/site-packages/`
- 输出日志到文件（stdout + stderr）

---

## 📊 rsync 通配符小贴士

| 模式    | 含义                       |
| ------- | -------------------------- |
| `*`     | 匹配任意字符（不含 `/`）   |
| `**`    | 匹配任意目录层级           |
| `*.zip` | 匹配所有 .zip 文件         |
| `dir/`  | 同步目录内容（末尾有 `/`） |
| `dir`   | 同步目录本身（含目录名）   |

>  你用 `SOURCE_DIR/`（带斜杠）是正确的 —— 同步的是目录内的内容，而不是目录本身。

---

##  总结：你当前脚本中的 rsync 参数含义

```bash
rsync -avz \
    -e "ssh -i $SSH_KEY" \
    --include="*.zip" \
    --include="*.tar.gz" \
    --exclude="*" \
    "$SOURCE_DIR/" \
    "$BACKUP_SERVER:$BACKUP_DIR/"
```

| 参数                            | 含义                                                |
| ------------------------------- | --------------------------------------------------- |
| `-a`                            | 保留权限、时间、递归同步等（归档模式）              |
| `-v`                            | 显示传输文件名（便于日志追踪）                      |
| `-z`                            | 传输时压缩数据（节省带宽）                          |
| `-e ...`                        | 使用指定私钥通过 SSH 连接 B 服务器                  |
| `--include="*.zip"`             | 只包含 zip 文件                                     |
| `--include="*.tar.gz"`          | 只包含 tar.gz 文件                                  |
| `--exclude="*"`                 | 排除其他所有文件（配合 include 实现“仅同步压缩包”） |
| `"$SOURCE_DIR/"`                | 同步该目录下的内容（不是目录本身）                  |
| `"$BACKUP_SERVER:$BACKUP_DIR/"` | 同步到远程服务器的指定目录                          |

---



