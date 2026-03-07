[toc]



## 常见命令行接口描述语言识读

linux上的命令行 usage 语法主要基于以下标准/惯例：

- **POSIX 实用工具约定** (POSIX Utility Conventions) — IEEE Std 1003.1
- **GNU 编码标准** (GNU Coding Standards)
- **IEEE/Open Group 的 Utility Argument Syntax**

**docopt** 等现代工具也沿用了这套记法
1. [docopt—language for description of command-line interfaces](http://docopt.org/) 
2. [[docopt](https://github.com/docopt)](https://github.com/docopt/docopt)


---

### 典型实例

`tar`命令的用例:

```bash
# Traditional usage
       tar {A|c|d|r|t|u|x}[GnSkUWOmpsMBiajJzZhPlRvwo] [ARG...]
```

可以看到这里出现了`{}`和`|`以及`[]`和`...`;本文会讨论这些符号的含义,并提供真实的命令行工具的示例;

## 核心符号识读

###  方括号 `[ ]` — 可选项（Optional）

```bash
ls [OPTION]... [FILE]...
```
`[]`包裹的占位符(选项或参数)表示改部分可以省略;

这里`ls`命令的`OPTION`和`FILE`都可以省略

`[FILE...]` 表示`FILE`角色可以出现多次(`...`表示可重复)

例如`ls -l a.txt b.txt `这里指定了2个文件

---

###  尖括号包裹 `< >` — 必需的参数占位符（Required placeholder）

```bash
cp <source> <dest>
```
`<source>` 和 `<dest>` 是**必须提供的**，且需要用实际值替换。

> `<>`主要用于强调,如果某个占位符没有任何符号对包裹,一般也表示不可省略!

不可省略的情况包括不被`[]`包裹的参数占位符,也是必须提供的;

---

```bash
grep [OPTION]... PATTERNS [FILE]...

```
---

###  省略号 `...` — 可重复（One or more / repeatable）

```bash
cp [OPTION]... SOURCE... DEST
```
- `[OPTION]...` → 可以指定**零个或多个**选项
- `SOURCE...` → 可以指定**一个或多个**源文件

---



###  圆括号/花括号 `{ }` 和`|`— 分组（Grouping）

- `{ }` ,些地方用小括号`( )` ,通常表示**必选其一的分组**

```bash
cmd {start | stop | restart}
```

---

竖线 `|` — 互斥选择（Mutually exclusive / OR）

```bash
 tar {A|c|d|r|t|u|x} ...
```

`tar`命令中的基础动作部分的选项是互斥的,且不能都省略,必须要有且只有一个选中

```bash
git checkout ... [[-b|-B|--orphan] <new-branch>] [<start-point>]
```

**外层方括号 `[...]`**：表示这一整块内容是**可选的**。如果你不写，`git checkout` 就会尝试切换到一个已存在的分支。

**内层方括号 `[-b|-B|--orphan]`**：表示这三个参数是**互斥**的，你只能三选一。

**管道符 `|`**：代表“或者”（OR）。

###  双横线 `--` — 选项终止符

```bash
rm [OPTION]... -- <file>...
```
`--` 之后的所有内容都被视为**操作数（不再解析为选项）**，常用于处理以 `-` 开头的文件名。

---

## 综合示例解读

### ssh命令usage

```bash
   ssh
usage: ssh [-46AaCfGgKkMNnqsTtVvXxYy] [-B bind_interface]
           [-b bind_address] [-c cipher_spec] [-D [bind_address:]port]
           [-E log_file] [-e escape_char] [-F configfile] [-I pkcs11]
           [-i identity_file] [-J [user@]host[:port]] [-L address]
           [-l login_name] [-m mac_spec] [-O ctl_cmd] [-o option] [-p port]
           [-Q query_option] [-R address] [-S ctl_path] [-W host:port]
           [-w local_tun[:remote_tun]] destination [command [argument ...]]
```

---

这份 `ssh` 的 usage 描述是一个非常典型的 **POSIX 命令行标准格式**。它看起来极其复杂，是因为 `ssh` 拥有大量的可选配置（Options）。

这条命令可以被简化为三个核心部分： `ssh [所有的选项开关] destination [执行的命令]`

- **`[ ... ]`**: 整个 usage 中遍布方括号，意味着除了 `destination`（目的地），其他所有内容都是**可选的**。
- **`destination`**: 唯一没有括号包裹的项，说明它是**必填项**（通常是 `user@hostname`）。

#### 具体的符号识别

A. 集合选项：`[-46AaCfGgKkMNnqsTtVvXxYy]`

- **含义**：方括号内有一长串字符，表示这些是**不带参数**的 **布尔开关 (Flags)**。
- **规则**：你可以单独使用，也可以组合使用。
  - 例如：`ssh -4 -v` 等同于 `ssh -4v`。
  - `4` 代表强制用 IPv4，`v` 代表详细日志。

B. 带参数的选项：例如:`[-p port]` 或 `[-i identity_file]`

- **含义**：方括号包裹了“选项字母”和“占位符”。
- **规则**：如果你使用了这个字母，**必须**跟上对应的数据。
  - 示例：`ssh -p 2222`。这里 `-p` 是选项，`2222` 替换了占位符 `port`。

C. 嵌套的可选参数：`[-D [bind_address:]port]`

- **含义**：这表示双重可选。

- **规则**：

  1. `-D` 本身是可选的。
  2. 如果你用了 `-D`，`port` 是必须的。
  3. 但在 `port` 之前的 `bind_address:` 又是可选的。

  - 合法写法：`-D 8080` 或 `-D 127.0.0.1:8080`。

D. 递归的可选结尾：`[command [argument ...]]`

- **含义**：
  1. `command`：登录后想在远程服务器执行的命令（可选）。
  2. `[argument ...]`：传给该命令的参数。`...` 表示可以有**一个或多个**参数。
- **逻辑**：只有当你提供了 `command` 时，才能提供 `argument`。

### git push命令

```bash
git push [--all | --branches | --mirror | --tags] [--follow-tags] [--atomic] [-n | --dry-run] [--receive-pack=<git-receive-pack>]
           [--repo=<repository>] [-f | --force] [-d | --delete] [--prune] [-q | --quiet] [-v | --verbose]
           [-u | --set-upstream] [-o <string> | --push-option=<string>]
           [--[no-]signed|--signed=(true|false|if-asked)]
           [--force-with-lease[=<refname>[:<expect>]] [--force-if-includes]]
           [--no-verify] [<repository> [<refspec>…​]]
```

解读规则：

```bash
[--all | --mirror | --tags]   → 三者可选其一（也可不选）
[-n | --dry-run]              → 短格式和长格式等价，选一种写法
[-f | --force]                → 同上
[<repository> [<refspec>...]] → repository 可选；
                                 若给了 repository，后面可跟零或多个 refspec
```

其中` [--[no-]signed|--signed=(true|false|if-asked)]`是最复杂的部分:

> 可以分成两大部分`--[no-]signed`和`--signed=(true|false|if-asked)`
>
> 而前者可以等价于`--signed|--no-signed`

这个表达式告诉你：你可以简单地用 `--signed` 或 `--no-signed` 来开关，也可以通过 `--signed=` 后面接具体的单词来精细控制签名的触发条件。

---

## 速查表

| 符号                      | 含义               | 示例              |
| ------------------------- | ------------------ | ----------------- |
| `[ ]`                     | 可选               | `[-v]`            |
| `< >`                     | 必需参数（占位符） | `<file>`          |
| `...`                     | 可重复             | `<file>...`       |
| `|`(主要配合三种括号使用) | 互斥选择           | `-a | -b`         |
| `{}`或`( )`+`|`           | 必选分组           | `(-a | -b)`       |
| `[ ]` + `|`               | 可选分组           | `[-a | -b]`       |
| `UPPER`                   | 元变量/占位符      | `FILE`, `PATTERN` |
| `--`                      | 选项结束标记       | `-- <file>`       |
| 无括号的占位符单词        | 必需项             | `SOURCE DEST`     |
