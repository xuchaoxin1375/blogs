[toc]



---

## 查找和搜索命令行工具选择思路

很多初学者会把“查找文件”和“搜索文件内容”混在一起。实际工作中最好先区分问题类型。

| 你要解决的问题                                     | 优先工具                        | 适合场景                               |
| -------------------------------------------------- | ------------------------------- | -------------------------------------- |
| 按文件名找文件，要求准确、实时                     | `find`                          | 服务器排障、脚本、按大小/时间/权限过滤 |
| 按文件名快速模糊查找，主要是交互式使用             | `fd`                            | 日常 SSH、项目目录、开发机             |
| 在整台机器上按文件名快速定位，可接受数据库不是最新 | `locate` / `plocate`            | 快速找路径、找安装位置                 |
| 在文件内容中搜字符串，要求传统兼容                 | `grep`                          | 脚本、最小系统、POSIX/GNU 工具环境     |
| 在项目或大量文本中高速递归搜索                     | `ripgrep` / `rg`                | 代码、配置、日志目录、Git 仓库         |
| 先按文件属性过滤，再搜内容                         | `find` + `grep`，或 `fd` + `rg` | “过去一天的日志里找 ERROR”这类任务     |

一个很实用的原则:

- **写脚本、写运维自动化**:优先 `find` + `grep`。
- **自己在终端交互式排查**:优先 `fd` + `rg`。
- **只记得文件名一部分，想全系统秒查**:用 `locate` / `plocate`。
- **要删除、改权限、批量移动**:先 `find` 或 `fd` 预览，再执行破坏性操作。

---

## 核心概念:文件名查找和内容查找不是一回事

### 文件名查找

文件名查找看的是**路径和文件元数据**，例如:

- 文件名:`nginx.conf`
- 后缀:`*.log`
- 类型:普通文件、目录、符号链接
- 大小:大于 1 GB
- 修改时间:最近 24 小时
- 权限:全局可写、SUID
- 属主:`root`、`www-data`
- 所在路径:`/etc`、`/var/log`

典型工具是:

```bash
find /etc -type f -name '*.conf'
fd -e conf . /etc
locate nginx.conf
```

### 文件内容查找

内容查找看的是**文件里面的文本内容**，例如:

- 哪个配置文件包含 `PermitRootLogin`
- 哪个日志文件出现 `timeout`
- 哪些代码里调用了 `eval`
- 哪些文件包含某个 IP 地址

典型工具是:

```bash
grep -RIn 'PermitRootLogin' /etc
rg -n 'timeout|refused|failed' /var/log
```

### Glob 和正则表达式要分清

这是初学者最容易混淆的点。

| 概念       | 英文术语                   | 常见工具                              | 示例           | 含义                       |
| ---------- | -------------------------- | ------------------------------------- | -------------- | -------------------------- |
| 通配符     | Glob pattern               | shell、`find -name`、`fd -g`、`rg -g` | `*.log`        | 匹配以 `.log` 结尾的文件名 |
| 正则表达式 | Regular expression / Regex | `grep`、`rg`、`fd` 默认模式           | `error|failed` | 匹配 `error` 或 `failed`   |
| 固定字符串 | Fixed string / Literal     | `grep -F`、`rg -F`                    | `192.168.1.1`  | 把点号等符号当普通字符     |

**重要规则**:凡是带 `*`、`?`、`[`、`]`、`!`、空格等特殊含义的模式，尽量用单引号包起来，例如 `find . -name '*.log'`。GNU `findutils` 文档也特别提醒，类似 `*.c` 这样的通配符应加引号，避免先被 shell 展开。

---

## 文件/目录查找:传统核心工具 find

`find` 是服务器管理员必须掌握的工具。它的优点是:

- 几乎所有 Unix/Linux 系统都有。
- 适合脚本和自动化。
- 条件非常丰富。
- 能直接对结果执行命令。
- 能处理复杂权限、时间、大小、属主等场景。

基本语法:

```bash
find [起始路径...] [条件表达式] [动作]
```

例如:

```bash
find /usr/src -name '*.c' -size +100k -print
```

这个命令从 `/usr/src` 开始，查找文件名以 `.c` 结尾且大于 100 KiB 的对象。GNU `findutils` 官方文档也使用类似示例说明 `find` 会从指定目录树向下搜索，并根据表达式筛选文件。

---

## find 的高频用法

### 按文件名查找

```bash
find . -name 'nginx.conf'
```

在当前目录及其子目录中查找文件名正好是 `nginx.conf` 的对象。

忽略大小写:

```bash
find . -iname 'readme.md'
```

查找所有 `.log` 文件:

```bash
find /var/log -type f -name '*.log'
```

查找名称中包含 `backup` 的文件:

```bash
find . -type f -iname '*backup*'
```

这里 `-name` 和 `-iname` 使用的是**文件名通配符**，不是正则表达式。

---

### 按类型查找

常用 `-type` 类型:

| 条件      | 含义     |
| --------- | -------- |
| `-type f` | 普通文件 |
| `-type d` | 目录     |
| `-type l` | 符号链接 |
| `-type s` | socket   |
| `-type p` | 命名管道 |
| `-type b` | 块设备   |
| `-type c` | 字符设备 |

示例:

```bash
find /etc -type f -name '*.conf'
```

只找普通配置文件。

```bash
find /var -type d -name 'cache'
```

只找名为 `cache` 的目录。

```bash
find /usr/bin -type l
```

只找符号链接。

---

### 限制搜索深度

只查当前目录，不递归太深:

```bash
find . -maxdepth 1 -type f
```

最多查两层目录:

```bash
find /etc -maxdepth 2 -type f -name '*.conf'
```

跳过起始目录本身，只查其下级:

```bash
find . -mindepth 1 -maxdepth 1 -type d
```

GNU `findutils` 文档说明，`-maxdepth 0` 表示只对命令行给出的起始路径本身应用测试，`-mindepth 1` 表示不处理起始路径本身。

---

### 按路径匹配

`-name` 只匹配**文件名本身**，不匹配完整路径。

例如:

```bash
find . -name '*.log'
```

会匹配 `./app/server.log`，但条件只看 `server.log` 这个 basename。

如果要按完整路径匹配，用 `-path`:

```bash
find . -path '*/nginx/sites-enabled/*'
```

排查时常用:

```bash
find /etc -path '*ssh*' -type f
```

---

### 排除目录

这是服务器上非常高频的需求，比如搜索项目时排除 `.git`、`node_modules`、`vendor`、`target`、`dist`。

传统 `find` 写法:

```bash
find . -path './node_modules' -prune -o -type f -name '*.js' -print
```

含义:

- `-path './node_modules' -prune`:遇到 `node_modules` 就剪枝，不再进入。
- `-o`:或者。
- `-type f -name '*.js' -print`:否则查找 JavaScript 文件并打印。

多个目录排除:

```bash
find . \
  \( -path './.git' -o -path './node_modules' -o -path './vendor' \) -prune \
  -o -type f -print
```

注意:

- `(` 和 `)` 对 shell 有特殊含义，所以通常写成 `\(` 和 `\)`。
- `-prune` 的位置很重要。
- 如果觉得难记，交互式场景建议直接用 `fd -E` 或 `rg -g`。

---

## 按时间查找:mtime、ctime、atime

这是运维排障非常常用的能力。

| 条件    | 英文术语          | 含义                                       |
| ------- | ----------------- | ------------------------------------------ |
| `mtime` | modification time | 文件内容最后修改时间                       |
| `ctime` | change time       | inode 元数据最后改变时间，不是创建时间     |
| `atime` | access time       | 文件最后访问时间，受挂载参数影响，未必可靠 |

### 最近 24 小时修改过的文件

```bash
find /etc -type f -mtime -1
```

### 过去 30 分钟修改过的文件

```bash
find /var/www -type f -mmin -30
```

### 很久没改的日志文件

```bash
find /var/log -type f -name '*.log' -mtime +30
```

### 按绝对日期查找

GNU `find` 支持 `-newermt`，很适合排障:

```bash
find /etc -type f -newermt '2026-09-01'
```

查找 2026-09-01 之后修改过的配置文件。

查找某个时间段内修改过的文件:

```bash
find /var/www -type f -newermt '2026-09-01' ! -newermt '2026-09-08'
```

含义是:

- 修改时间晚于 2026-09-01。
- 但不晚于 2026-09-08。

### `-mtime +7` 的小坑

`find` 的 `-mtime` 是按 24 小时为单位计算，并且有取整语义。实际工作中:

- `-mtime -1`:通常理解为最近 24 小时内。
- `-mtime 0`:也是 0 个完整 24 小时周期内。
- `-mtime +7`:不是简单的“超过 7 小时”或“超过 7 天一点点”，而是超过若干完整天数的判断。

如果你需要更精确，优先用:

```bash
find . -type f -mmin +10080
```

或:

```bash
find . -type f ! -newermt '7 days ago'
```

---

## 按大小查找

查找大于 1 GB 的文件:

```bash
sudo find /var -type f -size +1G
```

查找小于 1 KB 的文件:

```bash
find . -type f -size -1k
```

查找大小正好为 0 的空文件:

```bash
find . -type f -empty
```

查找空目录:

```bash
find . -type d -empty
```

服务器磁盘告警时非常常用:

```bash
sudo find /var -xdev -type f -size +500M -exec ls -lh {} +
```

这里 `-xdev` 表示不要跨越文件系统边界，适合避免误扫挂载的 NFS、备份盘、容器挂载点等。

---

## 按权限和属主查找

### 查找 root 拥有的 SUID 文件

```bash
sudo find / -xdev -type f -user root -perm -4000 -ls 2>/dev/null
```

这在安全审计中很常见。

### 查找全局可写文件

```bash
sudo find / -xdev -type f -perm -0002 -ls 2>/dev/null
```

### 查找全局可写目录

```bash
sudo find / -xdev -type d -perm -0002 -ls 2>/dev/null
```

### 查找某个用户拥有的文件

```bash
sudo find /var/www -user www-data -type f
```

### 查找不属于任何有效用户的文件

```bash
sudo find / -xdev -nouser -o -nogroup
```

更稳妥一点写成:

```bash
sudo find / -xdev \( -nouser -o -nogroup \) -ls 2>/dev/null
```

这类文件常见于用户删除后遗留的数据。

---

## find 的动作:打印、删除、执行命令

### 默认打印

很多情况下你不写动作，`find` 默认会打印匹配结果。但为了脚本可读性，建议显式写 `-print`:

```bash
find . -type f -name '*.log' -print
```

GNU `findutils` 文档说明，如果表达式里没有动作，默认会执行类似 `-print` 的输出行为；而 `-delete`、`-exec`、`-print0` 等动作会抑制默认打印。

---

### 批量执行命令:推荐 `-exec ... {} +`

给所有 `.conf` 文件显示详细信息:

```bash
find /etc -type f -name '*.conf' -exec ls -lh {} +
```

给一批文件改权限:

```bash
find /var/www -type f -name '*.php' -exec chmod 0644 {} +
```

这里的 `{}` 会被替换为找到的路径。

结尾有两种写法:

```bash
find . -type f -name '*.log' -exec gzip {} \;
```

和:

```bash
find . -type f -name '*.log' -exec gzip {} +
```

区别:

| 写法 | 含义                           | 适合                   |
| ---- | ------------------------------ | ---------------------- |
| `\;` | 每个文件执行一次命令           | 命令必须逐个处理时     |
| `+`  | 尽量把多个文件合并到一次命令中 | 大多数批量操作，更高效 |

GNU `findutils` 文档说明，`-exec ... {} +` 会构造更长的命令行并尽量减少命令启动次数，通常比逐文件执行更高效。

---

### 删除文件:务必先预览

危险操作必须先预览:

```bash
find /tmp -type f -name '*.tmp' -mtime +7 -print
```

确认无误后再删除:

```bash
find /tmp -type f -name '*.tmp' -mtime +7 -delete
```

更保守的做法:

```bash
find /tmp -type f -name '*.tmp' -mtime +7 -exec rm -i {} \;
```

实务建议:

- 永远先 `-print` 看结果。
- 尽量加 `-type f`，避免误删目录。
- 起始路径不要写错，尤其不要在 `/` 下直接做删除。
- 脚本里不要把变量为空的路径拼进 `find "$DIR"` 后直接删除，先校验变量。
- 如果路径可能包含空格、换行、特殊字符，优先用 `-exec ... {} +`，不要简单把结果塞进 `for f in $(find ...)`。

---

## 安全处理奇怪文件名:`-print0` 和 `xargs -0`

文件名可能包含空格、制表符甚至换行。因此，把 `find` 的输出交给其他命令时，传统换行分隔并不总是安全。

安全写法:

```bash
find . -type f -name '*.log' -print0 | xargs -0 grep -Hn 'ERROR'
```

这里:

- `-print0`:用 NUL 字符分隔路径。
- `xargs -0`:按 NUL 字符读取路径。

GNU `findutils` 文档建议，在文件名可能包含换行等特殊字符时使用 `-print0`；相关文档也说明 GNU `xargs` 的 `-0` / `--null` 可以处理这种 NUL 分隔输入。

不过在现代 `find` 中，很多时候可以不用 `xargs`，直接用:

```bash
find . -type f -name '*.log' -exec grep -Hn 'ERROR' {} +
```

这通常更简单、更安全。

---

## locate / plocate:基于数据库的快速文件名查找

`locate` 和现代实现 `plocate` 不是实时遍历磁盘，而是查数据库。因此它非常快，但结果可能不是最新的。

常用:

```bash
locate nginx.conf
```

忽略大小写:

```bash
locate -i ssh_config
```

只看 basename 匹配，减少路径中间项干扰:

```bash
locate -b '\sshd_config'
```

更新数据库:

```bash
sudo updatedb
```

`updatedb` 用来创建或更新 `locate` 使用的文件名数据库，很多系统会通过定时任务自动运行。 `plocate` 是现代 `locate` 实现，Debian 手册页说明它大体兼容 `mlocate` 参数，并且显著更快。

适合:

- 只记得文件名一部分。
- 想快速找安装位置。
- 不要求结果绝对实时。

不适合:

- 刚创建的文件。
- 刚删除的文件。
- 权限敏感的安全审计。
- 精确按时间、大小、权限过滤。

---

## 文件/目录查找:现代工具 fd

`fd` 是 `find` 的现代化替代品，适合交互式使用。它的特点是:

- 命令更短。
- 默认彩色输出。
- 默认使用智能大小写。
- 默认不搜索隐藏文件和隐藏目录。
- 默认尊重 `.gitignore`、`.fdignore` 等忽略规则。
- 支持按扩展名、类型、大小、时间、属主过滤。
- 支持并行执行命令。
- 默认模式是正则表达式，使用 `-g` 时才是 glob。`fd` 官方 README 明确说明，`fd [pattern] [path]` 中的 `pattern` 默认是正则表达式，除非使用 `--glob`；并列出了 `-H`、`-I`、`-t`、`-e`、`-S`、`--changed-within`、`-x`、`-X` 等常用选项。

---

## fd 高频用法

### 查找文件名包含某字符串

```bash
fd nginx
```

在当前目录递归查找文件名中包含 `nginx` 的对象。

指定搜索路径:

```bash
fd nginx /etc
```

---

### 按扩展名查找

查找 `.log` 文件:

```bash
fd -e log
```

在 `/var/log` 下找 `.log` 文件:

```bash
fd -e log . /var/log
```

这里的 `.` 是匹配所有名称的模式，`/var/log` 是搜索路径。

---

### 只找文件或目录

只找普通文件:

```bash
fd -t f nginx
```

只找目录:

```bash
fd -t d cache
```

只找符号链接:

```bash
fd -t l
```

`fd` 的 `-t` / `--type` 支持文件、目录、符号链接、可执行文件、空文件、socket、pipe、字符设备、块设备等类型。

---

### glob 精确匹配

`fd` 默认模式是正则表达式。如果你想用传统 glob 风格，使用 `-g`:

```bash
fd -g '*.conf'
```

查找名为 `nginx.conf` 的文件:

```bash
fd -g 'nginx.conf'
```

官方文档也说明，要按特定文件名模式查找可以使用 `-g` / `--glob`。

---

### 搜索隐藏文件

默认情况下，`fd` 不搜索隐藏目录，也不显示隐藏文件。要包含隐藏文件，用:

```bash
fd -H ssh
```

包含被 `.gitignore` 忽略的文件:

```bash
fd -I target
```

全部放开:

```bash
fd -u pattern
```

或者显式写:

```bash
fd -H -I pattern
```

`fd` 官方 README 说明，默认不搜索隐藏目录、不显示隐藏文件；在 Git 仓库中也默认不搜索被 `.gitignore` 匹配的内容。可以用 `-H` 搜隐藏文件，用 `-I` 不遵守 ignore 文件，或者用 `-u` / `--unrestricted` 全部放开。

---

### 按完整路径匹配

默认情况下，`fd` 只匹配文件名，不匹配完整路径。

例如:

```bash
fd nginx
```

主要匹配 basename。

如果要匹配完整路径:

```bash
fd -p 'sites-enabled/.+conf' /etc
```

或者:

```bash
fd --full-path 'nginx/sites'
```

`fd` 官方文档说明，默认只匹配文件名；使用 `--full-path` 或 `-p` 后才匹配完整路径。

---

### 排除目录或文件

排除 `.git`:

```bash
fd -H -E .git pattern
```

排除备份文件:

```bash
fd -E '*.bak' pattern
```

排除多个目录:

```bash
fd -E node_modules -E vendor -E target pattern
```

`fd` 的 `-E` / `--exclude` 接收 glob 模式，官方文档也说明可用 `.fdignore` 做持久忽略规则。

---

### 按修改时间查找

最近 24 小时修改过的文件:

```bash
fd . /etc -t f --changed-within 24h
```

7 天以前修改过的日志:

```bash
fd . /var/log -e log -t f --changed-before 7d
```

这类用法比 `find -mtime` 更直观，但在脚本中还是建议用 `find`，因为它更通用。

---

### 按大小查找

查找大文件:

```bash
fd . /var -t f --size +1G
```

查找空文件:

```bash
fd . -t e
```

或者更明确地用传统 `find`:

```bash
find . -type f -empty
```

---

### 执行命令:`-x` 和 `-X`

对每个结果执行一次命令:

```bash
fd -e log -x gzip
```

把所有结果一次性传给命令:

```bash
fd -g 'test_*.py' -X vim
```

区别:

| 选项 | 英文术语   | 含义                               |
| ---- | ---------- | ---------------------------------- |
| `-x` | exec       | 对每个搜索结果执行一次命令，可并行 |
| `-X` | exec-batch | 把所有结果作为参数，尽量一次性执行 |

`fd` 官方 README 说明，`-x` 会对每个结果运行外部命令，`-X` 会把所有搜索结果作为参数传给一次命令；它还支持 `{}`、`{.}`、`{/}` 等占位符。

示例:把所有 `.jpg` 转成 `.png`:

```bash
fd -e jpg -x convert {} {.}.png
```

示例:对 C/C++ 头文件和源文件格式化:

```bash
fd -e h -e cpp -x clang-format -i
```

---

## find 和 fd 的选择建议

| 场景                                   | 推荐                     |
| -------------------------------------- | ------------------------ |
| 生产脚本、定时任务、Ansible、救援环境  | `find`                   |
| 临时手工查找文件                       | `fd`                     |
| 需要严格 POSIX/GNU 兼容                | `find`                   |
| 希望自动忽略 `.gitignore` 中的目录     | `fd`                     |
| 要精确处理权限、SUID、属主、跨文件系统 | `find`                   |
| 项目目录里快速找源码、配置、测试文件   | `fd`                     |
| 要删除、改权限、移动系统文件           | 先用 `find` 预览，再执行 |

我个人建议初学者记住:

```bash
find /path -type f -name '*.log'
```

和:

```bash
fd -e log . /path
```

前者用于严肃运维，后者用于日常效率。

---

## 文件内容查找:传统核心工具 grep

`grep` 是文本搜索的基础工具。基本语法:

```bash
grep [选项] '模式' [文件...]
```

最简单:

```bash
grep 'root' /etc/passwd
```

显示行号:

```bash
grep -n 'root' /etc/passwd
```

忽略大小写:

```bash
grep -i 'error' app.log
```

递归搜索:

```bash
grep -R 'PermitRootLogin' /etc
```

GNU `grep` 手册说明，`grep` 有 POSIX 选项和 GNU 扩展选项；其中 `-r` / `--recursive` 和 `-R` / `--dereference-recursive` 都与递归搜索相关，但对符号链接和设备处理存在差异。

---

## grep 高频选项

| 选项            | 英文术语              | 用途                       |
| --------------- | --------------------- | -------------------------- |
| `-n`            | line number           | 显示行号                   |
| `-H`            | with filename         | 显示文件名                 |
| `-h`            | no filename           | 不显示文件名               |
| `-i`            | ignore case           | 忽略大小写                 |
| `-v`            | invert match          | 反向匹配，只显示不匹配的行 |
| `-w`            | word regexp           | 匹配完整单词               |
| `-x`            | line regexp           | 整行匹配                   |
| `-E`            | extended regexp       | 使用扩展正则               |
| `-F`            | fixed strings         | 固定字符串，不按正则解释   |
| `-r`            | recursive             | 递归搜索                   |
| `-R`            | dereference recursive | 递归并解引用符号链接       |
| `-l`            | files with matches    | 只列出包含匹配的文件名     |
| `-L`            | files without match   | 只列出不包含匹配的文件名   |
| `-c`            | count                 | 统计匹配行数               |
| `-o`            | only matching         | 只输出匹配部分             |
| `-A 3`          | after context         | 显示匹配行后 3 行          |
| `-B 3`          | before context        | 显示匹配行前 3 行          |
| `-C 3`          | context               | 显示匹配行前后各 3 行      |
| `--include`     | include glob          | 只搜索某类文件             |
| `--exclude`     | exclude glob          | 排除某类文件               |
| `--exclude-dir` | exclude directory     | 排除目录                   |
| `-I`            | ignore binary         | 忽略二进制文件             |
| `-a`            | text                  | 把二进制当文本处理         |

GNU `grep` 手册说明，`--include`、`--exclude`、`--exclude-dir` 用于文件和目录选择，正则表达式语法与 shell 的文件名 glob 语法不同；二进制文件处理也有专门选项。

---

## grep 高频用法示例

### 搜普通字符串

```bash
grep -n 'server_name' /etc/nginx/nginx.conf
```

### 搜固定字符串

如果模式里有点号、方括号、星号等正则特殊字符，建议用 `-F`:

```bash
grep -RFn '192.168.1.10' /etc
```

否则 `192.168.1.10` 里的点号会被当成“任意字符”。

---

### 搜多个关键词

用扩展正则:

```bash
grep -RInE 'error|failed|timeout' /var/log
```

也可以用多个 `-e`:

```bash
grep -RIn -e 'error' -e 'failed' -e 'timeout' /var/log
```

如果是固定字符串列表:

```bash
grep -RFn -e '192.168.1.10' -e '10.0.0.5' /etc
```

---

### 显示上下文

查日志时非常常用。

匹配行前后各 3 行:

```bash
grep -RInC 3 'panic' /var/log
```

匹配行之后 10 行:

```bash
grep -RInA 10 'Exception' /var/log
```

匹配行之前 5 行:

```bash
grep -RInB 5 'Out of memory' /var/log
```

---

### 只列出命中的文件名

```bash
grep -Rl 'PermitRootLogin' /etc
```

只列出没有命中的文件名:

```bash
grep -RL 'PermitRootLogin' /etc/ssh
```

注意:这个 `grep -L` 和后面 `rg -L` 不一样，`rg -L` 是跟随符号链接。

---

### 只搜索指定文件类型

只搜 `.conf`:

```bash
grep -RIn --include='*.conf' 'listen' /etc
```

只搜 `.log`:

```bash
grep -RIn --include='*.log' 'timeout' /var/log
```

排除压缩文件:

```bash
grep -RIn --exclude='*.gz' 'error' /var/log
```

排除目录:

```bash
grep -RIn --exclude-dir='.git' --exclude-dir='node_modules' 'TODO' .
```

---

### 配合 find 按元数据过滤后搜索内容

查找最近一天修改过的日志中是否有错误:

```bash
find /var/log -type f -name '*.log' -mtime -1 -exec grep -HnE 'ERROR|WARN|FATAL' {} +
```

查找 `/etc` 最近 7 天改过的配置里是否出现某个 IP:

```bash
find /etc -type f -mtime -7 -exec grep -HnF '10.0.0.5' {} +
```

查找大于 100 MB 的日志文件里是否包含 `timeout`:

```bash
find /var/log -type f -name '*.log' -size +100M -exec grep -Hn 'timeout' {} +
```

这种组合是传统运维排障中非常实用的模式:

```bash
find 条件 -exec grep 内容 {} +
```

---

## 文件内容查找:现代工具 ripgrep

`ripgrep` 的命令名通常是 `rg`。它是现代文本搜索工具中最常用的一个，特别适合代码仓库、配置目录、日志目录。

基本用法:

```bash
rg 'pattern'
```

这会在当前目录递归搜索。`ripgrep` 官方文档说明，`rg PATTERN` 会搜索当前目录及子目录，默认跳过隐藏文件、`.gitignore` 忽略项和二进制文件。

---

## rg 的核心默认行为

和 `grep` 相比，`rg` 的默认行为非常重要:

| 行为                   | `grep`                 | `rg`           |
| ---------------------- | ---------------------- | -------------- |
| 默认递归               | 否                     | 是             |
| 默认尊重 `.gitignore`  | 否                     | 是             |
| 默认跳过隐藏文件       | 否                     | 是             |
| 默认跳过很多二进制内容 | 有二进制处理，但不等同 | 是             |
| 默认模式               | 正则                   | 正则           |
| 适合脚本兼容           | 很适合                 | 需注意输出格式 |
| 适合项目搜索           | 一般                   | 很适合         |

`ripgrep` 官方指南说明，它默认会跳过隐藏文件、`.gitignore` 中的内容和二进制文件；如果怀疑过滤隐藏了结果，可以用 `-u`、`-uu`、`-uuu` 逐步放开限制。

---

## rg 高频选项

| 选项          | 英文术语           | 用途                   |
| ------------- | ------------------ | ---------------------- |
| `-n`          | line number        | 显示行号               |
| `-i`          | ignore case        | 忽略大小写             |
| `-S`          | smart case         | 智能大小写             |
| `-F`          | fixed strings      | 固定字符串搜索         |
| `-w`          | word regexp        | 匹配完整单词           |
| `-C 3`        | context            | 显示上下文             |
| `-A 3`        | after context      | 显示匹配行后文         |
| `-B 3`        | before context     | 显示匹配行前文         |
| `-l`          | files with matches | 只列出匹配文件         |
| `-c`          | count              | 统计匹配行数           |
| `-o`          | only matching      | 只输出匹配部分         |
| `-g`          | glob               | 用 glob 包含或排除路径 |
| `-t`          | type               | 只搜索某种文件类型     |
| `-T`          | type not           | 排除某种文件类型       |
| `--hidden`    | hidden             | 搜索隐藏文件           |
| `--no-ignore` | no ignore          | 不遵守 ignore 文件     |
| `-u`          | unrestricted       | 减少自动过滤           |
| `-a`          | text               | 把二进制当文本处理     |
| `-z`          | search zip         | 搜索压缩文件           |
| `--files`     | files              | 列出 rg 会搜索的文件   |
| `--debug`     | debug              | 解释为什么文件被忽略   |
| `--sort path` | sort path          | 按路径排序输出         |

`ripgrep` 官方指南列出了这些常用选项，包括 `-i`、`-S`、`-F`、`-w`、`-c`、`--files`、`-a`、`-U`、`-z`、`-C`、`--sort path`、`-L`、`--debug` 等；其中 `--sort path` 会强制按文件名排序，但可能变慢，因为会影响并行能力。

---

## rg 高频用法示例

### 搜当前目录

```bash
rg 'timeout'
```

### 搜指定目录

```bash
rg 'PermitRootLogin' /etc
```

### 忽略大小写

```bash
rg -i 'error' /var/log
```

### 智能大小写

```bash
rg -S 'error'
```

`-S` / `--smart-case` 的意思是:

- 模式全小写时忽略大小写。
- 模式中有大写字母时区分大小写。

`ripgrep` 官方指南也将 `-S` 描述为类似 `--ignore-case`，但当模式包含大写字母时会自动关闭忽略大小写。

---

### 固定字符串搜索

搜索 IP、URL、带点号的域名时，建议用 `-F`:

```bash
rg -nF '192.168.1.10' /etc
```

搜索完整单词:

```bash
rg -nw 'error' /var/log
```

`ripgrep` 官方指南说明，`-F` 会禁用正则，把模式当作字面字符串；`-w` 要求匹配出现在单词边界上。

---

### 搜多个关键词

```bash
rg -n 'error|failed|timeout' /var/log
```

注意:`rg` 默认模式就是正则表达式，所以不需要像 `grep` 那样额外写 `-E`。

多个 `-e` 也可以:

```bash
rg -n -e 'error' -e 'failed' -e 'timeout' /var/log
```

如果模式本身以 `-` 开头，要用 `-e`:

```bash
rg -n -e '-Xmx' /opt/app
```

或者用 `--` 结束选项:

```bash
rg -n -- '-Xmx' /opt/app
```

---

### 只搜某类文件

只搜 Python:

```bash
rg -n -t py 'import requests'
```

只搜 Markdown:

```bash
rg -n -t md 'TODO'
```

排除 JavaScript:

```bash
rg -n -T js 'console.log'
```

`ripgrep` 支持文件类型过滤，例如官方 README 中给出的 `-tpy` 或 `-Tjs` 用法，表示只搜索 Python 文件或排除 JavaScript 文件；官方指南也说明可用 `--type` / `-t` 替代重复书写 glob。

---

### 用 glob 包含或排除路径

只搜 `.conf` 文件:

```bash
rg -n 'listen' /etc -g '*.conf'
```

排除 `.git`:

```bash
rg -n 'password' . -g '!.git/**'
```

排除多个目录:

```bash
rg -n 'TODO' . -g '!node_modules/**' -g '!vendor/**' -g '!target/**'
```

只搜 `nginx` 配置目录下的 `.conf`:

```bash
rg -n 'server_name' /etc/nginx -g '*.conf'
```

注意:

- `rg -g` 使用的是 glob。
- 排除模式一般写成 `-g '!pattern'`。
- 建议始终加引号，避免 shell 先解释。

---

### 搜隐藏文件和被忽略文件

搜索隐藏文件:

```bash
rg --hidden 'token'
```

不遵守 `.gitignore`:

```bash
rg --no-ignore 'target'
```

全部放开一部分限制:

```bash
rg -u 'pattern'
```

进一步包含隐藏文件:

```bash
rg -uu 'pattern'
```

进一步搜索二进制相关内容:

```bash
rg -uuu 'pattern'
```

官方指南说明，`-u` 等价于禁用 ignore 处理，`-uu` 还会搜索隐藏文件和目录，`-uuu` 还会搜索二进制文件；如果仍困惑为什么文件被忽略，可以用 `--debug` 查看原因。

---

### 显示上下文

```bash
rg -nC 3 'panic' /var/log
```

匹配后 10 行:

```bash
rg -nA 10 'Exception' /opt/app/logs
```

匹配前 5 行:

```bash
rg -nB 5 'OutOfMemory' /opt/app/logs
```

---

### 只列出包含匹配的文件

```bash
rg -l 'PermitRootLogin' /etc
```

注意迁移陷阱:

- `grep -L` 表示“列出不包含匹配的文件”。
- `rg -L` 表示“跟随符号链接”。

如果要用 `rg` 查不包含匹配的文件，使用:

```bash
rg --files-without-match 'PermitRootLogin' /etc/ssh
```

---

### 列出 rg 实际会搜索哪些文件

```bash
rg --files
```

这在排查 `.gitignore`、隐藏文件、忽略规则时很好用。

例如查看某个文件为什么没被搜到:

```bash
rg --debug 'pattern'
```

官方指南说明，`--files` 会打印 ripgrep 将要搜索的文件但不实际搜索，`--debug` 可用于理解为什么某文件被忽略或加载了哪些配置。

---

### 搜压缩文件

```bash
rg -z 'error' /var/log
```

`ripgrep` 的 `-z` / `--search-zip` 支持搜索 gzip、bzip2、xz、zstd 等压缩格式，但默认关闭。

传统方式则常用:

```bash
zgrep -Hn 'error' /var/log/*.gz
```

---

## grep 和 rg 的选择建议

| 场景                               | 推荐                     |
| ---------------------------------- | ------------------------ |
| 脚本、兼容性、最小 Linux 环境      | `grep`                   |
| Git 项目或源码搜索                 | `rg`                     |
| 搜 `/etc`、`/opt/app` 这类配置目录 | `rg` 或 `grep` 都可      |
| 搜大量日志并希望快                 | `rg`                     |
| 要严格复用老脚本                   | `grep`                   |
| 需要默认尊重 `.gitignore`          | `rg`                     |
| 不希望任何东西被自动忽略           | `grep`，或 `rg -uuu`     |
| 需要 GNU `grep -P` 这类 Perl 正则  | GNU `grep -P` 或 `rg -P` |

`rg` 的默认行为更像“项目搜索器”，而 `grep` 的默认行为更像“基础文本过滤器”。所以在服务器上要特别注意:如果你用 `rg` 没搜到，不一定真的没有，可能是文件被隐藏规则、ignore 规则或二进制过滤跳过了。

---

## find + grep:传统组合拳

这是服务器管理员最值得熟练掌握的组合。

### 最近一天日志中查错误

```bash
find /var/log -type f -name '*.log' -mtime -1 -exec grep -HnE 'ERROR|WARN|FATAL' {} +
```

### 查最近 30 分钟修改过的应用日志

```bash
find /opt/app/logs -type f -mmin -30 -exec grep -Hn 'timeout' {} +
```

### 查配置文件中的某个 IP

```bash
find /etc /opt/app -type f \( -name '*.conf' -o -name '*.yaml' -o -name '*.yml' \) \
  -exec grep -HnF '10.0.0.5' {} +
```

### 查大日志中的关键字

```bash
find /var/log -type f -size +100M -name '*.log' -exec grep -Hn 'connection refused' {} +
```

### 查某用户目录下包含私钥头的文件

```bash
sudo find /home -type f -exec grep -Il 'BEGIN OPENSSH PRIVATE KEY' {} +
```

这里:

- `-I`:忽略二进制。
- `-l`:只列文件名。
- `-H`:多文件时显示文件名，部分场景可加。

---

## fd + rg:现代组合拳

交互式排查时，`fd` + `rg` 很舒服。

### 只在 `.conf` 文件里搜配置项

```bash
fd . /etc -e conf -t f -X rg -n 'listen'
```

### 只在最近 24 小时改过的日志里搜错误

```bash
fd . /var/log -e log -t f --changed-within 24h -X rg -n 'ERROR|WARN|FATAL'
```

### 只在 YAML 文件里搜某个 IP

```bash
fd . /opt/app -e yaml -e yml -t f -X rg -nF '10.0.0.5'
```

### 只在当前项目源码里搜函数调用

```bash
fd . -e py -e sh -e go -e rs -t f -X rg -n 'connect'
```

`fd` 官方 README 也展示了 `fd` 与 `rg` 联用的思路，例如先用 `fd` 找到一类源码文件，再用 `rg` 在这些文件中搜索内容。

---

## 常见服务器排障场景实战

### 场景:磁盘满了，找大文件

传统:

```bash
sudo find /var -xdev -type f -size +1G -exec ls -lh {} +
```

现代:

```bash
sudo fd . /var -t f --size +1G -x ls -lh
```

进一步排序可以配合 `du` / `sort`，但注意包含管道的复杂命令不要随手写进破坏性脚本。

---

### 场景:找最近被改过的配置文件

```bash
sudo find /etc -type f -mtime -1 -print
```

或更精确:

```bash
sudo find /etc -type f -newermt '2026-09-09 00:00:00'
```

现代:

```bash
sudo fd . /etc -t f --changed-within 24h
```

---

### 场景:找 nginx 配置里的 server_name

传统:

```bash
grep -RIn --include='*.conf' 'server_name' /etc/nginx
```

现代:

```bash
rg -n 'server_name' /etc/nginx -g '*.conf'
```

---

### 场景:查 SSH 是否允许 root 登录

```bash
sudo grep -RIn 'PermitRootLogin' /etc/ssh
```

现代:

```bash
sudo rg -n 'PermitRootLogin' /etc/ssh
```

如果要忽略注释行，可以用:

```bash
sudo rg -n '^\s*PermitRootLogin\s+' /etc/ssh
```

---

### 场景:查日志中的失败、超时、拒绝连接

```bash
sudo rg -n 'failed|timeout|refused|denied' /var/log
```

如果要忽略大小写:

```bash
sudo rg -ni 'failed|timeout|refused|denied' /var/log
```

传统:

```bash
sudo grep -RInE 'failed|timeout|refused|denied' /var/log
```

---

### 场景:查某个端口号出现在哪些配置里

例如查 `5432`:

```bash
sudo rg -nF '5432' /etc /opt
```

如果要避免匹配 `15432`、`54321`，可以用单词边界思路:

```bash
sudo rg -n '\b5432\b' /etc /opt
```

---

### 场景:查所有 `.service` 文件里是否有某个环境变量

```bash
sudo rg -n 'Environment=' /etc/systemd /usr/lib/systemd /lib/systemd -g '*.service'
```

传统:

```bash
sudo find /etc/systemd /usr/lib/systemd /lib/systemd -type f -name '*.service' \
  -exec grep -Hn 'Environment=' {} +
```

---

### 场景:找全局可写目录，排查安全风险

```bash
sudo find / -xdev -type d -perm -0002 -ls 2>/dev/null
```

通常还会特别关注没有 sticky bit 的全局可写目录:

```bash
sudo find / -xdev -type d -perm -0002 ! -perm -1000 -ls 2>/dev/null
```

---

### 场景:查被删除用户遗留文件

```bash
sudo find / -xdev \( -nouser -o -nogroup \) -ls 2>/dev/null
```

---

### 场景:查项目中所有 TODO

传统:

```bash
grep -RIn --exclude-dir='.git' --exclude-dir='node_modules' 'TODO' .
```

现代:

```bash
rg -n 'TODO'
```

在 Git 项目里，`rg` 默认尊重 `.gitignore`，所以通常无需手写排除 `node_modules`、`target`、`dist` 等目录。

---

## 正则表达式实用入门

### 常用正则符号

| 符号  | 含义                      | 示例               |
| ----- | ------------------------- | ------------------ |
| `.`   | 任意单个字符              | `a.c` 可匹配 `abc` |
| `*`   | 前一个元素重复 0 次或多次 | `ab*c`             |
| `+`   | 前一个元素重复 1 次或多次 | `ab+c`             |
| `?`   | 前一个元素可有可无        | `https?`           |
| `^`   | 行首                      | `^error`           |
| `$`   | 行尾                      | `done$`            |
| `[]`  | 字符集合                  | `[0-9]`            |
| `[^]` | 取反字符集合              | `[^0-9]`           |
| `()`  | 分组                      | `(error|warn)`     |
| `|`   | 或                        | `error|warn`       |
| `\b`  | 单词边界                  | `\berror\b`        |
| `\s`  | 空白字符，在 `rg` 中常用  | `^\s*#`            |

### grep 和 rg 的正则差异

`grep` 默认使用基本正则表达式，很多场景建议加 `-E`:

```bash
grep -E 'error|warn|fatal' app.log
```

`rg` 默认就支持常见的扩展正则写法:

```bash
rg 'error|warn|fatal' app.log
```

如果只是搜普通字符串，优先用固定字符串模式:

```bash
grep -F 'user.name@example.com' file.txt
rg -F 'user.name@example.com' file.txt
```

这样更不容易被正则特殊字符坑到。

---

## 容易踩坑的地方

### 不要滥用 `ls | grep`

很多人会写:

```bash
ls | grep '.log'
```

更好的文件名查找方式是:

```bash
find . -maxdepth 1 -type f -name '*.log'
```

或者:

```bash
fd -d 1 -e log
```

原因:

- `ls` 输出面向人类，不适合脚本解析。
- 文件名可能包含空格、换行、颜色控制字符。
- `find` / `fd` 才是专门做文件查找的工具。

---

### 不要写 `for f in $(find ...)`

错误示例:

```bash
for f in $(find . -name '*.log'); do
  gzip "$f"
done
```

文件名有空格时会出问题。

推荐:

```bash
find . -type f -name '*.log' -exec gzip {} +
```

或者:

```bash
find . -type f -name '*.log' -print0 | xargs -0 gzip
```

---

### `rg` 没搜到不代表没有

因为 `rg` 默认会跳过:

- 隐藏文件。
- `.gitignore` 忽略的文件。
- 一些二进制文件。

排查时可以逐步放开:

```bash
rg --hidden 'pattern'
rg --no-ignore 'pattern'
rg -uu 'pattern'
rg --debug 'pattern'
```

---

### `fd` 没找到也可能是被忽略了

类似地，`fd` 默认不搜索隐藏文件，也默认尊重 ignore 文件。可以使用:

```bash
fd -H pattern
fd -I pattern
fd -u pattern
```

官方 README 明确说明 `fd` 默认跳过隐藏文件和 ignore 规则，可用 `-H`、`-I`、`-u` 改变行为。

---

### `grep -R` 要小心符号链接

在系统目录下乱用 `grep -R`、`find -L`、`rg -L` 可能导致:

- 扫进意外的挂载点。
- 符号链接形成循环。
- 扫描范围远大于预期。
- 扫到 `/proc`、`/sys`、容器挂载、NFS。

系统级搜索建议加边界:

```bash
sudo find / -xdev -type f -name '*.conf' -print
```

或者明确搜索路径:

```bash
sudo rg -n 'pattern' /etc /opt/app /usr/local/etc
```

不要一上来就全盘:

```bash
sudo rg -n 'pattern' /
```

除非你明确知道后果。

---

### 二进制文件不要随便当文本输出

`grep -a` 或 `rg -a` 会把二进制当文本处理，可能输出控制字符，导致终端显示异常。`ripgrep` 官方指南也提醒，搜索二进制为文本可能向终端输出不良控制字符。

更安全:

```bash
grep -RI 'pattern' /path
rg 'pattern' /path
```

需要搜索压缩日志时优先用:

```bash
zgrep -Hn 'pattern' /var/log/*.gz
```

或:

```bash
rg -z 'pattern' /var/log
```

---

## 推荐记忆的最小命令集

如果你是初学者，先把下面这些练熟。

### 文件/目录查找

```bash
find . -type f -name '*.log'
```

```bash
find /etc -type f -name '*.conf'
```

```bash
find /var/log -type f -mtime -1
```

```bash
find /var -xdev -type f -size +1G
```

```bash
find . -type f -name '*.tmp' -print
```

```bash
find . -type f -name '*.tmp' -delete
```

```bash
fd -e log
```

```bash
fd nginx /etc
```

```bash
fd -H -I pattern
```

```bash
locate nginx.conf
```

---

### 文件内容查找

```bash
grep -n 'pattern' file.txt
```

```bash
grep -RIn 'pattern' /etc
```

```bash
grep -RIn --include='*.conf' 'listen' /etc
```

```bash
grep -RInC 3 'error' /var/log
```

```bash
rg 'pattern'
```

```bash
rg -nF '192.168.1.10' /etc
```

```bash
rg -n 'error|failed|timeout' /var/log
```

```bash
rg -n 'server_name' /etc/nginx -g '*.conf'
```

```bash
rg -uu 'pattern'
```

---

## 推荐别名和函数

谨慎一点，只给交互式 shell 用，不要依赖在脚本里。

```bash
# fd: 如果系统上叫 fdfind，可自行启用
command -v fdfind >/dev/null && alias fd='fdfind'

# rg: 常用搜索别名
alias rgi='rg -n -i'
alias rgf='rg -nF'
alias rgu='rg -n -uu'

# find: 常用安全预览
alias find-large='sudo find . -xdev -type f -size +500M -exec ls -lh {} +'
```

如果你经常在代码仓库中用 `rg`，可以考虑配置 `RIPGREP_CONFIG_PATH`，但初学阶段不建议过早定制默认行为，否则在别的服务器上会产生“为什么这台机器搜索结果不一样”的困惑。

---

## 一套实用排查流程

当你不知道该用什么时，可以按这个顺序想:

### 你知道文件名吗？

知道:

```bash
fd name
```

或者严谨一点:

```bash
find /path -name '*name*'
```

不知道，但知道内容:

```bash
rg 'known content' /path
```

---

### 你关心的是最近变化吗？

查最近修改的文件:

```bash
find /path -type f -mtime -1
```

再搜内容:

```bash
find /path -type f -mtime -1 -exec grep -Hn 'pattern' {} +
```

现代写法:

```bash
fd . /path -t f --changed-within 24h -X rg -n 'pattern'
```

---

### 你怀疑工具忽略了文件吗？

对 `rg`:

```bash
rg --files
rg --debug 'pattern'
rg -uu 'pattern'
```

对 `fd`:

```bash
fd -H -I pattern
```

---

### 你准备删除或修改文件吗？

先预览:

```bash
find /path -type f -name '*.tmp' -print
```

再执行:

```bash
find /path -type f -name '*.tmp' -delete
```

或者更保守:

```bash
find /path -type f -name '*.tmp' -exec rm -i {} \;
```

---

## 最后的选型总结

| 工具                 | 你应该怎么记                                   |
| -------------------- | ---------------------------------------------- |
| `find`               | 最可靠、最通用、最适合脚本的文件查找工具       |
| `fd`                 | 更友好、更快、更适合人手动使用的文件查找工具   |
| `locate` / `plocate` | 用数据库秒查文件名，但结果可能滞后             |
| `grep`               | 最传统、最兼容的文本搜索工具                   |
| `rg`                 | 更快、更现代、更适合项目和大量文本搜索的工具   |
| `xargs`              | 把路径列表转成命令参数，但要配合 `-0` 安全使用 |

对服务器管理员来说，建议形成这两套肌肉记忆:

传统可靠组合:

```bash
find /path -type f -name '*.conf' -exec grep -Hn 'pattern' {} +
```

现代高效组合:

```bash
fd . /path -e conf -t f -X rg -n 'pattern'
```

前者适合脚本和严肃运维，后者适合交互式排查和日常效率。