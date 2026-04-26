[toc]

`compgen` 是 Bash 的一个强大内置命令，全称是 **Completion Generation**（补全生成）。

它的核心用途是：**根据特定的过滤规则，列出当前 Shell 环境中匹配的对象**。它是 Bash 自动补全功能（Tab 键补全）背后的底层引擎，但也被广泛用于脚本开发。

------

##  常用参数

`compgen` 通过不同的选项（Action）来指定要列出的对象类型：

| **选项**      | **描述**                                                     | **示例**              |
| ------------- | ------------------------------------------------------------ | --------------------- |
| `-v`          | 列出所有**变量名**                                           | `compgen -v`          |
| `-a`          | 列出所有**别名 (alias)**                                     | `compgen -a`          |
| `-b`          | 列出所有**内置命令 (built-ins)**                             | `compgen -b`          |
| `-c`          | 列出所有**可执行命令** (包括别名、函数、内置命令、PATH中的命令) | `compgen -c`          |
| `-d`          | 列出所有**目录**                                             | `compgen -d`          |
| `-f`          | 列出所有**文件**                                             | `compgen -f`          |
| `-k`          | 列出所有 **Bash 关键字** (如 `if`, `while`)                  | `compgen -k`          |
| `-u`          | 列出所有**用户**                                             | `compgen -u`          |
| `-A function` | 列出所有**函数名**                                           | `compgen -A function` |

------

##  核心用法详解

### A. 前缀匹配（过滤输出）

`compgen` 的基本语法是 `compgen [选项] [前缀]`。它会返回所有以该前缀开头的匹配项。

```bash
# 列出所有以 "GI" 开头的变量
compgen -v GI
# 输出示例: 
# GIT_EDITOR
# GIO_LAUNCHED_DESKTOP_FILE

# 列出所有以 "ls" 开头的可执行命令
compgen -c ls
# 输出示例:
# ls
# lscpu
# lsmod
```

### B. 在自动补全脚本中使用

当你编写自定义的补全脚本（`complete` 命令）时，`compgen` 是必不可少的。

```bash
# 假设你有一个脚本 myapp，它只接受 "start", "stop", "restart" 三个参数
# 使用 -W (Word list) 参数
compgen -W "start stop restart" -- "s"
# 输出:
# start
# stop
```

------

##  与 `set` 或 `env` 的区别

很多初学者容易把 `compgen -v` 和 `set` 混淆：

1. **输出内容**：`set` 会输出 `变量名=变量值`，而 `compgen -v` **只输出变量名**。

2. **纯净度**：`compgen` 的输出非常干净，没有多余的格式，非常适合作为 `for` 循环的输入：

 ```bash
# 打印所有以 USER 开头的变量值
 for var in $(compgen -v USER); do
     echo "${!var}"
 done
 ```

------

##  注意事项

- **性能**：`compgen -c` 可能非常慢，因为它会扫描 `$PATH` 下的所有可执行文件。
- **空结果**：如果没有匹配项，`compgen` 会返回非零的退出状态码（可以使用 `$?` 检查）。
- **引号处理**：如果文件名包含空格，`compgen -f` 的原始输出可能需要结合 `read` 或数组来正确处理。

