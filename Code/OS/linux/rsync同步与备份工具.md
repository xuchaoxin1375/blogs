[toc]



---

## 基础命令结构

```bash
rsync [选项] 源路径 目标路径
```

### 传输方向有2个

- 本地路径->远程路径
- 远程路径->本地路径

而在命令行参数中,是第一个路径传输到第二个路径上,注意书写顺序;

例如(本地推送到远程)

```bash
rsync -avPh -e "ssh -i /path/to/key" /local/zips/ user@remote:/backup/
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

rsync -avP "$remote_full_path" "$local_path" 
```

### 常用模板

```bash
# 定义不压缩的后缀(让z选项跳过效益低的文件类型)
SKIP_LIST="jpg/jpeg/png/gif/webp/zip/zst/lz4/gz/tgz/7z/xz/rar/bz2/mp4/mkv/mov/avi/mp3/pdf/docx/xlsx/pptx"

# 使用 GNU Parallel 启动并行传输
# --inplace: 减少临时文件创建，适合大文件更新
# -T: 防止 ssh 超时
ls -1 /src/ | parallel -j 4 \
    rsync -avz \
    --inplace \
    --skip-compress=$SKIP_LIST \
    -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no" \
    /src/{} user@remote_host:/dest/
```

```bash
find /src/ -maxdepth 1 -mindepth 1 -type d | xargs -n 1 -P 5 -I {} rsync -avz --skip-compress=... {} /dest/
```

rsync 传输大型压缩文件夹推荐方案

## 常用的串行传输命令模板

### 基础版

```bash
rsync -avP --no-compress -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no" /local/path/ user@remote:/remote/path/
```

#### 参数解释

| 参数                        | 作用                                                         |
| --------------------------- | ------------------------------------------------------------ |
| `-a`                        | 归档模式（保留权限、时间戳、符号链接等）                     |
| `-v`                        | 显示传输详情                                                 |
| `-P`                        | = `--partial --progress`，断点续传 + 显示进度                |
| `--no-compress`             | **关键：跳过 rsync 压缩**，已压缩文件再压缩浪费 CPU 且无收益 |
| `-T`                        | 禁用 SSH 伪终端分配，略微提升性能                            |
| `-c aes128-gcm@openssh.com` | 使用更快的加密算法（比默认快很多）                           |
| `-o Compression=no`         | 禁用 SSH 层压缩                                              |

#### 速度优化参数

| 参数                          | 作用               | 为什么更快             | 副作用 / 风险                                                |
| ----------------------------- | ------------------ | ---------------------- | ------------------------------------------------------------ |
| `--whole-file`                | 禁用 delta diff    | 不计算块差异           | 增量同步时流量暴增；公网小改动文件会浪费带宽                 |
| `--no-compress`               | 禁止 rsync 压缩    | 千兆/万兆下 CPU 更重要 | 低带宽公网会明显变慢                                         |
| `ssh -T`                      | 禁用 pseudo-tty    | 少一点 SSH 开销        | 某些依赖 tty 的远程 shell/profile 行为可能异常               |
| `Compression=no`              | 禁 SSH 压缩        | 极重要                 | 弱网/高延迟场景传输量增加                                    |
| `aes128-gcm@openssh.com`      | 更快 cipher        | CPU 更省               | 某些老旧 SSH/OpenSSH 不支持；ARM 某些设备未必最快            |
| `--info=progress2`            | 单进度条           | 比 `-P` 更轻量         | 没有断点续传信息显示；不如 `-P` 直观                         |
| `--size-only`                 | 仅比较文件大小     | 少算 checksum/stat     | 文件内容变了但大小没变会漏同步                               |
| `--inplace`                   | 原地写入           | 避免临时文件           | 传输中断可能留下损坏文件；无法原子替换（atomic replace）；不适合生产热文件 |
| `--ignore-times` (`-I`)       | 强制全部重传       | 跳过时间戳判断         | 会导致完全失去增量同步意义                                   |
| `--inplace --whole-file` 组合 | 极限写入性能       | 几乎纯顺序写           | 中断时目标文件可能半坏状态                                   |
| `--numeric-ids`               | 不解析用户名组名   | 少一次 uid/gid lookup  | 不同机器 uid/gid 不一致时权限可能错乱                        |
| `--delete-delay`              | 延后删除           | 减少 I/O 抖动          | 同步期间旧文件短暂存在                                       |
| `--omit-dir-times` (`-O`)     | 不同步目录时间     | 减少 metadata 更新     | 目录 mtime 不准确                                            |
| `--no-perms`                  | 不同步权限         | 减少 chmod 操作        | 目标权限可能不正确                                           |
| `--no-owner --no-group`       | 不同步属主属组     | 减少 chown 开销        | 权限体系可能失效                                             |
| `--checksum-choice=xxh128`    | 更快 checksum      | 比 md5/sha1 更快       | 老版本 rsync 不支持                                          |
| `--mkpath`                    | 自动创建远程目录   | 少一次 ssh mkdir       | 老 rsync 版本可能不支持                                      |
| `--blocking-io`               | 阻塞 IO            | 某些网络更稳定         | 高并发时可能反而慢                                           |
| `--bwlimit=0`                 | 不限速             | 跑满带宽               | 容易打爆业务网络                                             |
| `--partial`                   | 保留中断文件       | 避免重新传输           | 占用磁盘；可能留下垃圾 partial 文件                          |
| `--append`                    | 只追加文件尾部     | 大日志文件极快         | 文件中间修改会导致数据损坏                                   |
| `--append-verify`             | 追加+校验          | 比 append 安全         | 仍不适合普通文件                                             |
| `--sparse` (`-S`)             | 稀疏文件优化       | VM/DB 镜像更快更省空间 | 某些 FS 不支持 sparse                                        |
| `--preallocate`               | 预分配空间         | 降低碎片               | 可能瞬间占满磁盘空间                                         |
| `--delete-before`             | 先删除再同步       | 释放磁盘空间           | 同步失败可能导致数据缺失                                     |
| `--delete-excluded`           | 删除 excluded 文件 | 减少目标垃圾           | 配错 exclude 会误删                                          |

### 一次性传输加速参数(`--whole-file`)

`--whole-file`: 跳过增量算法，"首次"传输时直接整文件复制更快

但是该选项慎用(尤其是可能发生二次传输反而引起混乱)

除非明确不会再次运行,**或者再次运行时记得移除此选项**

```bash
# 完整优化版（大文件夹推荐）
rsync -avP \
  --no-compress \
  --whole-file \
  -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no" \
  /local/path/ user@remote:/remote/path/

```

### 常用场景补充

```bash
# 限速传输（避免占满带宽），单位 KB/s
rsync -avP --no-compress --bwlimit=50000 /local/path/ user@remote:/remote/path/

# 排除某些文件
rsync -avP --no-compress --exclude='*.log' --exclude='.git/' /local/path/ user@remote:/remote/path/

# 断点续传（中断后重新运行同一命令即可自动续传）
# -P 已包含 --partial，直接重跑命令就行

# 删除目标端多余文件（完全同步/镜像）
rsync -avP --no-compress --delete /local/path/ user@remote:/remote/path/
```

⚠️ 注意事项

```bash
# 源路径末尾的 / 很重要！
/local/path/   # ← 传输目录下的内容
/local/path    # ← 传输目录本身（会多一层目录）

# 建议先 dry-run 预览
rsync -avPn --no-compress /local/path/ user@remote:/remote/path/
#        ^ n = dry-run，不实际传输，只显示会做什么
```

> **核心原则**：文件已压缩（`.tar.gz`, `.zip`, `.mp4`, `.jpg` 等），务必关掉所有压缩层（rsync 层 + SSH 层），否则白白烧 CPU 还可能更慢。

## 并行化传输方案

rsync配置其他工具实现并行

或者直接采用并行传输工具而非rsync

### 方案一：xargs 并行（最简单实用）



```bash
# 先获取顶层目录列表，然后并行启动多个 rsync
ls /local/path/ | xargs -P 4 -I {} \
  rsync -avP --no-compress \
  -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no" \
  /local/path/{} user@remote:/remote/path/

# -P 4 表示 4 个并行进程
```

远程到本地:

```bash
# 先获取远程目录列表

ssh user@remote "ls /remote/path/" | xargs -P 4 -I {} \
  rsync -avP --no-compress \
  -e "ssh -T -c aes128-gcm@openssh.com -o Compression=no" \
  user@remote:/remote/path/{} /local/path/
```



### 方案二：GNU parallel（更灵活）

```bash
# 安装
# apt install parallel / yum install parallel / brew install parallel

# 按顶层子目录并行
find /local/path/ -maxdepth 1 -mindepth 1 | \
  parallel -j 4 \
  rsync -avP --no-compress --whole-file \
  -e "'ssh -T -c aes128-gcm@openssh.com -o Compression=no'" \
  {} user@remote:/remote/path/{/}

# {/} = 只取basename
```

### 方案三：按文件列表分片（大量小文件最优）

```bash
#!/bin/bash
# parallel_rsync.sh

SRC="/local/path/"
DST="user@remote:/remote/path/"
JOBS=4
SSH_OPTS="ssh -T -c aes128-gcm@openssh.com -o Compression=no"

# 生成完整文件列表并分片
cd "$SRC"
find . -type f | sort > /tmp/all_files.txt
split -n l/$JOBS /tmp/all_files.txt /tmp/chunk_

# 每个分片启动一个 rsync
for chunk in /tmp/chunk_*; do
  rsync -avP --no-compress --whole-file \
    --files-from="$chunk" \
    -e "$SSH_OPTS" \
    "$SRC" "$DST" &
done

wait
echo "全部传输完成"
```

### 方案四：用专用工具

### parsync（rsync 并行封装）

```bash
# 安装
git clone https://github.com/hjmangalam/parsync.git
cd parsync

# 使用
./parsync -N 4 \
  --rsyncopts="--no-compress --whole-file" \
  /local/path/ user@remote:/remote/path/

# -N 4 = 4路并行，自动分片
```

rclone（内置并行）

```bash
# 安装: https://rclone.org/install/
# 配置远程（一次性）
rclone config
# 选 SFTP，配好 host/user/key

# 传输（内置多线程）
rclone copy /local/path/ myremote:/remote/path/ \
  --transfers 8 \
  --checkers 16 \
  --progress \
  --no-compress-file="*"

# --transfers 8  : 8个文件同时传
# --checkers 16  : 16个线程检查差异
```

性能对比

| 方案             | 复杂度 | 断点续传 | 适合场景             |
| ---------------- | ------ | -------- | -------------------- |
| xargs + rsync    | ⭐      | ✅        | 子目录数量适中       |
| parallel + rsync | ⭐⭐     | ✅        | 需要精细控制         |
| 文件列表分片     | ⭐⭐⭐    | ✅        | 海量小文件           |
| parsync          | ⭐⭐     | ✅        | 开箱即用             |
| rclone           | ⭐      | ✅        | 长期使用、大规模传输 |

⚠️ 注意事项

```bash
# 1. SSH 连接数限制 —— 远程 sshd 默认可能限制并发
# 修改远端 /etc/ssh/sshd_config:
MaxSessions 20
MaxStartups 20:30:60

# 2. 复用 SSH 连接（避免重复握手，强烈推荐）
# 本地 ~/.ssh/config 添加：
Host your-remote
    HostName 1.2.3.4
    User your-user
    ControlMaster auto
    ControlPath ~/.ssh/cm-%r@%h:%p
    ControlPersist 10m

# 3. 并行数不是越多越好
# 带宽瓶颈 → 并行数增加无意义
# 建议: 千兆网 4~8 路，万兆网 8~16 路

# 4. 验证完整性（传输完成后）
rsync -avnc /local/path/ user@remote:/remote/path/
# -c 校验checksum，-n dry-run 只检查不修改
```

> **个人推荐**：文件已压缩的场景，优先用 **方案一 xargs**（简单可靠），长期大规模传输考虑 **rclone**。

## 核心常用选项

在深入性能优化前，先掌握这些最基础的“组合拳”：

| **选项**            | **说明**                                                     |
| ------------------- | ------------------------------------------------------------ |
| **`-a` (archive)**  | 归档模式。等同于 `-rlptgoD`，保留权限、所有者、时间戳及软连接，是最常用的选项。 |
| **`-v` (verbose)**  | 详细输出。显示正在传输的文件名。                             |
| **`-z` (compress)** | **压缩传输**。在网络上传输时压缩数据，节省带宽，但会消耗 CPU。<br />如果传输的文件已经是压缩包（如 `.tar.gz`, `.zip`, `.7z`, `.mp4`, `.jpg` 等），使用 `-z` (compression) **通常不仅不会提升速度，反而会降低效率**。 |
| **`-P`**            | 等同于 `--partial --progress`。断点续传并显示传输进度。      |
| **`-h`**            | 以人类可读的格式（KB, MB, GB）输出数字。                     |
| **`--delete`**      | **慎用**。如果源端没有该文件，则删除目标端的文件，保持完全一致。 |

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

[toc]

## abstract

`rsync` 是一个功能强大的文件同步工具，广泛用于本地或远程的增量备份和文件传输。其中，`-e` 选项是控制 **远程传输时所使用的传输协议（即远程 shell）** 的关键参数。

---

### **`-e` 选项详解**

#### **作用**

`-e` 选项用于指定 `rsync` 在进行远程同步时使用的远程 shell 命令，例如 `ssh`、`rsh`、`plink` 等。  
**默认情况下，`rsync` 使用 `ssh` 作为远程传输协议**，所以如果你不指定 `-e`，它等价于 `-e ssh`。

#### **语法**

```bash
rsync -e 'remote_shell' [其他选项] 源 目标
```

---

### **常见用法示例**

#### ✅ 1. 显式使用 SSH（默认行为）

```bash
rsync -e ssh /local/path/ user@remote:/remote/path/
```

等价于：

```bash
rsync /local/path/ user@remote:/remote/path/
```

> 虽然默认就是 `ssh`，但显式使用 `-e ssh` 可以更清晰或用于后续扩展。

---

#### ✅ 2. 使用指定 SSH 私钥（结合 `-i`）

```bash
rsync -e 'ssh -i /path/to/private_key' /local/file user@remote:/remote/path/
```

> 这是最常见的场景：通过密钥认证进行安全同步。

**示例**：

```bash
rsync -e 'ssh -i ~/.ssh/id_rsa_aws.pem' -avz ~/docs/ ubuntu@192.168.1.100:/home/ubuntu/docs/
```

---

#### ✅ 3. 指定 SSH 端口（非默认 22 端口）

```bash
rsync -e 'ssh -p 2222' -avz /local/ user@remote:/remote/
```

> 注意：这里的 `-p 2222` 是 `ssh` 的选项，不是 `rsync` 的。

---

#### ✅ 4. 使用其他远程 shell（较少见）

```bash
# 使用 rsh（不推荐，不安全）
rsync -e rsh /local/ user@remote:/remote/

# 使用 plink（Windows 下 PuTTY 工具集）
rsync -e 'plink -ssh -i key.ppk' /local/ user@remote:/remote/
```

---

#### ✅ 5. 结合压缩和归档模式完整同步

```bash
rsync -e 'ssh -i ~/.ssh/id_rsa' -avz -P /source/ user@remote:/destination/
```

- `-a`: 归档模式（保留权限、时间、符号链接等）
- `-v`: 显示详细信息
- `-z`: 压缩传输数据
- `-P`: 显示进度并保留部分传输的文件

---

### **注意事项**

1. **引号使用**：

   - 当 `-e` 后面的命令包含多个参数时，必须用引号括起来：

     ```bash
     -e 'ssh -i key.pem -p 2222'   # 正确
     -e ssh -i key.pem              # 错误（会被当作 rsync 的选项）
     ```

2. **与 `rsync://` 协议的区别**：

   - `-e` 用于 **通过远程 shell（如 SSH）同步**。
   - 如果使用 `rsync://`（rsync daemon 模式），则不使用 `-e`，而是直接连接 rsync 服务端口。

3. **性能与安全**：

   - 推荐始终使用 `ssh` 作为传输方式（默认且安全）。
   - 避免使用 `rsh`、`rlogin` 等不加密的协议。

---

### **总结**

| 用法                                             | 说明                           |
| ------------------------------------------------ | ------------------------------ |
| `rsync -e ssh ...`                               | 显式使用 SSH（默认）           |
| `rsync -e 'ssh -i key.pem' ...`                  | 使用指定私钥进行认证           |
| `rsync -e 'ssh -p 2222' ...`                     | 指定非标准 SSH 端口            |
| `rsync -e 'ssh -o StrictHostKeyChecking=no' ...` | 自动接受主机密钥（脚本中慎用） |

---

### **实用技巧：配置 `~/.ssh/config` 简化命令**

你可以通过配置 SSH 客户端来避免重复使用 `-e` 和复杂参数：

```bash
# ~/.ssh/config
Host myserver
    HostName 192.168.1.100
    User ubuntu
    Port 2222
    IdentityFile ~/.ssh/id_rsa_aws.pem
    StrictHostKeyChecking no
```

然后 rsync 命令可以简化为：

```bash
rsync -av /local/ myserver:/remote/
```



