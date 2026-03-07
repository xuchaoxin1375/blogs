[toc]



## 遵循的标准

linux上的命令行 usage 语法主要基于以下标准/惯例：

- **POSIX 实用工具约定** (POSIX Utility Conventions) — IEEE Std 1003.1
- **GNU 编码标准** (GNU Coding Standards)
- **IEEE/Open Group 的 Utility Argument Syntax**
- **docopt** 等现代工具也沿用了这套记法
  1. [docopt—language for description of command-line interfaces](http://docopt.org/) 
  2. [[docopt](https://github.com/docopt)](https://github.com/docopt/docopt)


---

## 核心符号识读

### 1. 方括号 `[ ]` — 可选项（Optional）

```
ls [-l] [-a] [file...]
```
`-l` 和 `-a` 都是**可以省略**的。

`[file...]` 表示`file`角色可以出现多次(`...`表示可重复)

例如`ls -l a.txt b.txt `这里指定了2个文件

---

### 2. 尖括号包裹 `< >` — 必需的参数占位符（Required placeholder）

```
cp <source> <dest>
```
`<source>` 和 `<dest>` 是**必须提供的**，且需要用实际值替换。

另一种是大写或者不被`[]`包裹的参数占位符,也是必须提供的;

---

```
grep [OPTION]... PATTERNS [FILE]...
kill [-s sigspec | -n signum | -sigspec] pid | jobspec ... or kill -l [sigspec]
```
---

### 4. 省略号 `...` — 可重复（One or more / repeatable）

```
cp [OPTION]... SOURCE... DEST
```
- `[OPTION]...` → 可以指定**零个或多个**选项
- `SOURCE...` → 可以指定**一个或多个**源文件

---

### 5. 竖线 `|` — 互斥选择（Mutually exclusive / OR）

```
git checkout [-b | -B] <branch>
```
`-b` 和 `-B` **二选一**，不能同时使用。

---

### 6. 圆括号/花括号 `( )` 或 `{ }` — 分组（Grouping）

```
usage: cmd (-a | -b) <file>
```
- `( )` 通常表示**必选其一的分组**
- `{ }` 有些文档中也表示必选分组

```
cmd {start | stop | restart}
```

---

### 7. 双横线 `--` — 选项终止符

```
rm [OPTION]... -- <file>...
```
`--` 之后的所有内容都被视为**操作数（不再解析为选项）**，常用于处理以 `-` 开头的文件名。

---

## 综合示例解读

```
usage: tar [-cxtvf] [-C <dir>] [-f <archive>] [--exclude=PATTERN]... [file...]
```

| 片段                     | 含义                                    |
| ------------------------ | --------------------------------------- |
| `[-cxtvf]`               | 这些单字母选项都是可选的                |
| `[-C <dir>]`             | 可选；若使用 `-C`，后面必须跟一个目录   |
| `[-f <archive>]`         | 可选；若使用 `-f`，后面必须跟归档文件名 |
| `[--exclude=PATTERN]...` | 可选，且可多次使用                      |
| `[file...]`              | 可以指定零个或多个文件                  |

---

## 一个更复杂的真实示例

```
usage: git push [--all | --mirror | --tags] [--follow-tags] [--atomic]
               [-n | --dry-run] [--receive-pack=<git-receive-pack>]
               [--repo=<repository>] [-f | --force] [-v | --verbose]
               [<repository> [<refspec>...]]
```

解读规则：

```
[--all | --mirror | --tags]   → 三者可选其一（也可不选）
[-n | --dry-run]              → 短格式和长格式等价，选一种写法
[-f | --force]                → 同上
[<repository> [<refspec>...]] → repository 可选；
                                 若给了 repository，后面可跟零或多个 refspec
```

---

## 速查表

| 符号        | 含义               | 示例              |
| ----------- | ------------------ | ----------------- |
| `[ ]`       | 可选               | `[-v]`            |
| `< >`       | 必需参数（占位符） | `<file>`          |
| `...`       | 可重复             | `<file>...`       |
| `|`         | 互斥选择           | `-a | -b`         |
| `( )`       | 必选分组           | `(-a | -b)`       |
| `[ ]` + `|` | 可选分组           | `[-a | -b]`       |
| `UPPER`     | 元变量/占位符      | `FILE`, `PATTERN` |
| `--`        | 选项结束标记       | `-- <file>`       |
| 无括号      | 必需项             | `SOURCE DEST`     |