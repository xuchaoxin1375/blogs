[toc]



# mktemp 命令系统介绍

## 一、概述

`mktemp` 是一个用于**安全创建临时文件或临时目录**的命令。它通过生成唯一的、不可预测的文件名来避免竞态条件（race condition）和符号链接攻击，是 Shell 脚本中处理临时文件的最佳实践。

---

## 二、基本语法

```bash
mktemp [选项] [模板]
```

**模板规则：**
- 模板中至少包含 **3 个连续的 `X`**（通常用 6 个或更多）
- `X` 会被替换为随机的字母和数字
- 默认模板：`tmp.XXXXXXXXXX`

---

## 三、核心选项

| 选项                      | 说明                                            |
| ------------------------- | ----------------------------------------------- |
| `-d`                      | 创建临时**目录**而非文件                        |
| `-p DIR` / `--tmpdir=DIR` | 指定父目录（在该目录下创建临时文件）            |
| `-t`                      | 将模板解释为相对于 `$TMPDIR`（或 `/tmp`）的路径 |
| `-u`                      | 仅生成名称，不实际创建（不安全，不推荐）        |
| `-q`                      | 静默模式，出错时不输出错误信息                  |
| `--suffix=SUFF`           | 添加后缀（如 `.txt`）                           |

---

## 四、使用示例

### 1. 基本用法 — 创建临时文件

```bash
# 使用默认模板，在 /tmp 下创建
$ mktemp
/tmp/tmp.a4B9kLm2Xz

# 使用自定义模板
$ mktemp /tmp/myapp.XXXXXX
/tmp/myapp.3j8K2p
```

### 2. 创建临时目录

```bash
$ mktemp -d
/tmp/tmp.Rz4w7Qm1Yp

$ mktemp -d /tmp/myapp.XXXXXX
/tmp/myapp.9xN3kL
```

### 3. 指定父目录

```bash
# 使用 -p 指定目录
$ mktemp -p /var/run myapp.XXXXXX
/var/run/myapp.Ab3x9Z

# 使用 --tmpdir
$ mktemp --tmpdir=/home/user myfile.XXXXXX
/home/user/myfile.Kw8m2Q
```

### 4. 添加后缀

```bash
$ mktemp --suffix=.log /tmp/myapp.XXXXXX
/tmp/myapp.x9Km3Q.log

$ mktemp --suffix=.csv
/tmp/tmp.a4B9kLm2Xz.csv
```

### 5. 使用 `-t` 选项

```bash
# 在 $TMPDIR（或 /tmp）下创建
$ mktemp -t myapp.XXXXXX
/tmp/myapp.7Hj2kL
```

---

## 五、在脚本中的最佳实践

### 1. 标准用法：创建并清理

```bash
#!/bin/bash

# 创建临时文件，保存路径到变量
TMPFILE=$(mktemp /tmp/myscript.XXXXXXXXXX)

# 设置退出时自动清理（核心！）
trap "rm -f '$TMPFILE'" EXIT

# 使用临时文件
echo "processing data..." > "$TMPFILE"
cat "$TMPFILE"

# 脚本退出时，trap 会自动删除临时文件
```

### 2. 创建临时目录并清理

```bash
#!/bin/bash

TMPDIR=$(mktemp -d /tmp/myscript.XXXXXXXXXX)
trap "rm -rf '$TMPDIR'" EXIT

# 在临时目录中工作
cp source.txt "$TMPDIR/"
cd "$TMPDIR"
# ... 处理文件 ...
```

### 3. 错误处理

```bash
#!/bin/bash

TMPFILE=$(mktemp) || {
    echo "错误：无法创建临时文件" >&2
    exit 1
}
trap "rm -f '$TMPFILE'" EXIT

# 继续处理...
```

### 4. 多个临时文件的管理

```bash
#!/bin/bash

TMPDIR=$(mktemp -d) || exit 1
trap "rm -rf '$TMPDIR'" EXIT

INPUT="$TMPDIR/input.dat"
OUTPUT="$TMPDIR/output.dat"
LOG="$TMPDIR/process.log"

# 所有临时文件都在同一目录，退出时一次性清理
```

---

## 六、环境变量 `$TMPDIR`

`mktemp` 的行为受环境变量 `TMPDIR` 影响：

```bash
# 默认情况
$ mktemp
/tmp/tmp.XXXXXXXXXX

# 设置 TMPDIR
$ export TMPDIR=/var/tmp
$ mktemp
/var/tmp/tmp.XXXXXXXXXX
```

**优先级链：**
```
命令行指定的路径 > $TMPDIR > /tmp（默认）
```

---

## 七、安全性分析

### 为什么不能用简单方法？

```bash
# ❌ 危险！存在竞态条件
TMPFILE="/tmp/myapp.$$"          # PID 可预测
TMPFILE="/tmp/myapp.$RANDOM"     # RANDOM 范围小，可预测

# ❌ 危险！先检查再创建 = 竞态条件（TOCTOU）
if [ ! -f "/tmp/myfile" ]; then
    echo "data" > /tmp/myfile    # 攻击者可在检查和创建之间插入符号链接
fi

# ✅ 安全！mktemp 原子性地创建文件
TMPFILE=$(mktemp)                # 创建和检查是原子操作
```

### mktemp 的安全保障

| 特性               | 说明                                   |
| ------------------ | -------------------------------------- |
| **原子操作**       | 检查不存在 + 创建是一步完成的          |
| **不可预测**       | 使用加密级随机数生成文件名             |
| **严格权限**       | 创建的文件权限为 `600`（仅属主可读写） |
| **创建的目录权限** | `700`（仅属主可访问）                  |

---

## 八、不同系统的差异

### GNU/Linux 版本（coreutils）
```bash
mktemp --suffix=.txt -p /var/tmp myapp.XXXXXX
# 功能最全，支持 --suffix、-p 等
```

### BSD/macOS 版本
```bash
mktemp -t myapp                  # -t 用法不同，自动追加 .XXXXXXXX
mktemp /tmp/myapp.XXXXXX         # 模板写法兼容
```

### 跨平台兼容写法
```bash
# 最大兼容性的写法
TMPFILE=$(mktemp /tmp/myapp.XXXXXX)
TMPDIR=$(mktemp -d /tmp/myapp.XXXXXX)
```

---

## 九、实际应用场景

### 场景 1：安全地编辑管道中间结果

```bash
#!/bin/bash
TMPFILE=$(mktemp) || exit 1
trap "rm -f '$TMPFILE'" EXIT

# 将排序结果暂存，避免管道无法回溯
sort input.txt > "$TMPFILE"
join "$TMPFILE" reference.txt > output.txt
```

### 场景 2：原子性文件更新

```bash
#!/bin/bash
CONFIG="/etc/myapp.conf"
TMPFILE=$(mktemp "$CONFIG.XXXXXX") || exit 1

# 写入临时文件
generate_config > "$TMPFILE"

# 原子性替换（mv 在同一文件系统上是原子操作）
mv "$TMPFILE" "$CONFIG"
```

### 场景 3：构建隔离环境

```bash
#!/bin/bash
BUILD_DIR=$(mktemp -d) || exit 1
trap "rm -rf '$BUILD_DIR'" EXIT

cd "$BUILD_DIR"
git clone "$REPO_URL" .
make && make test
# 退出时自动清理整个构建目录
```

### 场景 4：并行脚本互不干扰

```bash
#!/bin/bash
# 多个实例同时运行也不会冲突
WORKDIR=$(mktemp -d /tmp/worker.XXXXXX)
trap "rm -rf '$WORKDIR'" EXIT

process_data --output "$WORKDIR/result.dat"
```

---

## 十、常见错误与注意事项

```bash
# ❌ 模板中 X 不足 3 个
mktemp /tmp/myapp.XX              # 报错：too few X's in template

# ❌ 忘记引号，文件名含空格时出错
rm $TMPFILE                       # 危险
rm "$TMPFILE"                     # ✅ 正确

# ❌ 忘记清理临时文件
TMPFILE=$(mktemp)
# ... 脚本结束但未删除 ...      # /tmp 会逐渐积累垃圾文件

# ✅ 始终使用 trap 清理
trap "rm -f '$TMPFILE'" EXIT

# ❌ 使用 -u（不安全）
mktemp -u                         # 仅返回名称，不创建，存在竞态风险
```

---

## 十一、总结

```
┌─────────────────────────────────────────┐
│            mktemp 使用要点              │
├─────────────────────────────────────────┤
│  1. 始终用 mktemp 创建临时文件/目录     │
│  2. 始终用 trap ... EXIT 确保清理       │
│  3. 变量引用加双引号 "$TMPFILE"          │
│  4. 检查 mktemp 返回值                  │
│  5. 模板至少包含 3 个 X（建议 6+）       │
│  6. 避免使用 -u 选项                     │
│  7. 跨平台时使用完整路径模板             │
└─────────────────────────────────────────┘
```