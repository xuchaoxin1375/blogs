[toc]

## abstract

exec是bash中的一个内置的命令(其他shell例如zsh也有类似的命令)

```bash
$ help exec
exec: exec [-cl] [-a name] [command [argument ...]] [redirection ...]
    Replace the shell with the given command.

    Execute COMMAND, replacing this shell with the specified program. ARGUMENTS become the arguments to COMMAND. 
    If COMMAND is not specified,any redirections take effect in the current shell.

    Options:
      -a name   pass NAME as the zeroth argument to COMMAND
      -c        execute COMMAND with an empty environment
      -l        place a dash in the zeroth argument to COMMAND

    If the command cannot be executed, a non-interactive shell exits, unless
    the shell option `execfail' is set.

    Exit Status:
    Returns success unless COMMAND is not found or a redirection error occurs.
```

## 核心行为：

> 1. Execute COMMAND, replacing this shell with the specified program. ARGUMENTS become the arguments to COMMAND. 
> 2. If COMMAND is not specified,any redirections take effect in the current shell.

### 有COMMAND时替换当前 shell

当执行 `exec COMMAND` 时，当前 shell 进程会被 `COMMAND` 完全替换。

- **不会 fork 子进程**：普通命令会在子进程中运行，而 `exec` 直接在当前进程中加载新程序。
- **shell 终止**：执行后，原 shell 不复存在（除非在脚本中且有后续逻辑，但实际不会执行到）。
- **参数传递**:所有跟在 `COMMAND` 后面的 `ARGUMENTS` 会作为该命令的参数传递。

### 无 COMMAND 时执行重定向



- 如果只写 `exec` 而不指定命令，则**仅应用重定向**到当前 shell：

- | **语法**       | **类型**   | **作用**           | **结果**                                 |
  | -------------- | ---------- | ------------------ | ---------------------------------------- |
  | `exec > file`  | 输出重定向 | 修改 FD 1 (stdout) | 后续所有输出都进文件。                   |
  | `exec >> file` | 追加重定向 | 修改 FD 1 (stdout) | 后续所有输出追加到文件末尾。             |
  | `exec n< file` | 自定义输入 | 创建新的 FD `n`    | 建立一个独立的读取通道，不影响屏幕输入。 |
  | `exec n>&-`    | 关闭 FD    | 释放资源           | 断开 FD 与文件的连接，释放系统资源。     |

我们可以再额外打开另外的终端,然后观察

### 重定向输出

```bash
exec > output.log    # 后续所有命令的标准输出都重定向到 output.log,当前终端还是可以继续交互,不过输出都进入到output.log中
exec 2> error.log    # 标准错误重定向(谨慎使用,当前shell接下来的所有操作都不会显示在终端上,而会将操作记录到error.log中)
```

对于第一种情况:在新终端(shell会话)中使用`tail -f output.log`查看原终端的命令执行结果(标准输出都被重定向到该文件中)

> | **特性**           | **exec > file**                    | **exec >> file**                     |
> | ------------------ | ---------------------------------- | ------------------------------------ |
> | **重定向符号**     | `>` (覆盖重定向)                   | `>>` (追加重定向)                    |
> | **如果文件存在**   | **清空**原文件内容，从头开始写入。 | **保留**原文件内容，在末尾继续写入。 |
> | **如果文件不存在** | 创建新文件。                       | 创建新文件。                         |
> | **文件指针位置**   | 指向文件开头（Offset 0）。         | 指向文件末尾（EOF）。                |
>
> 这里强调的是每次执行`exec >file`时会清空原来的内容,执行`exec >file`后执行其他命令(非`>`重定向的命令)输出的内容都会进入到`file`中,不会覆盖前一条命令的输入.

对于第二种情况`exec 2> error.log`:错误输出都被重定向到`error.log`中,同样可以在新终端中使用`tail -f error.log`查看原终端中输入的任何内容,执行`exec 2> /dev/tty`可以将原终端重定向回到可交互的状态;

> 注意,进行此情况试验前建议新开一个bash会话,清空之前`exec`的设置干扰.
>
> 可以发现,在执行`exec 2> error.log`后,bash的命令提示符并不会返回,并且输入的字符不会回显(都会进入到文件`error.log`中,这个可以通过另外窗口开新的shell查看`error.log`验证,可以使用`tail -f error.log`跟踪你在旧bash会话中的输入;有意思的是,命令提示符也会被输入到`error.log`中,对于美化着色过的提示符,error.log用文本编辑器查看可能会含有大量的转义序列)
>
> 但是命令输入完回车后,命令结果中正常信息会在当前bash输出,而不会送入`error.log`,而错误输出会进入到`error.log`.关于此现象的原因,下一节说明

> `exec > script.log 2>&1`  # 将标准输出和标准错误全部转到 log 文件

### bash中的标准错误(stderr)

 Bash 在处理 **交互式 Shell（Interactive Shell）** 时的重定向行为。

之所以会出现“提示符消失”和“输入不回显”的现象,是bash想要保持标准输出尽可能简洁,而**标准错误(stderr)**承担部分提示性信息的设计使然.

------

#### 1. 为什么提示符和输入都会“消失”？

在 Linux 中，标准错误（stderr，即文件描述符 `2`）不仅用于输出报错信息，在交互式 Bash 中，它还承担了**交互界面**的部分职责：

- **命令提示符（PS1）：** Bash 默认将命令提示符发送到 `stderr` 而不是 `stdout`。这样做是为了确保当你重定向正常输出（例如 `ls > file.txt`）时，**提示符不会也被存进文件里，从而保持终端界面的可用性**。
- **回显（Echo）：** 当**你在终端敲击键盘时，你看到的字符其实是 Shell 接收到输入后，实时“回显”到 `stderr` 上的**。

当你执行 `exec 2> error.log` 时，你告诉 Shell：“从现在起，所有发往 stderr 的内容都直接写入 error.log(所有不属于stdin的内容都发往stderr)”。

因此：

1. **提示符**被写进了文件。
2. **你输入的每一个字符**（回显）也被写进了文件。
3. 终端屏幕看上去就像“卡死”了一样，因为原本该显示在屏幕上的交互反馈都被导流走了。

------

#### 2. 为什么命令结果（stdout）还能正常显示？

这是因为你只重定向了 `2`（stderr），而没有动 `1`（stdout）。

- 当你输入一个命令（比如 `ls`）并按下回车，该命令的标准输出依然指向原来的终端设备（`/dev/tty` 或虚拟终端）。
- 所以，命令运行成功的正常结果会跳过 `error.log`，直接出现在你的屏幕上。

------

#### 3. 如何“盲操”恢复现场？

如果你在实验中发现自己陷入了这种“看不见”的状态，可以通过以下命令将 `stderr` 重新定向回当前的终端（通常是 `/dev/tty`）：

```bash
exec 2> /dev/tty
```

一旦执行这个命令，你会发现提示符和回显立刻就回来了。

------

#### 4. 关于“转义序列”的小知识

你提到的 `error.log` 中充满转义序列（Escape Sequences），这正是因为你的提示符（PS1）带有颜色或格式。

- 例如，`\e[32m` 是绿色的代码。
- 当这些代码在终端显示时，终端驱动会解析它们并变色；
- 但当它们被写入普通文件时，它们只是原始的字节，文本编辑器（如 `vim` 或 `cat`）会将它们显示为 `^[[32m` 之类的乱码。

#### 总结对照表

| **现象**         | **路径 (执行 exec 2> error.log 后)** | **原因**                                  |
| ---------------- | ------------------------------------ | ----------------------------------------- |
| **键入的字符**   | 写入 `error.log`                     | Shell 的回显机制利用了 stderr             |
| **命令提示符**   | 写入 `error.log`                     | Bash 将 PS1 输出到 stderr 以防干扰 stdout |
| **命令正常输出** | **显示在屏幕上**                     | stdout (fd 1) 保持不变                    |
| **命令错误输出** | 写入 `error.log`                     | stderr (fd 2) 已被显式重定向              |



### 重定向输入

`exec`除了重定向输出,还可以打开文件描述符`n`设置**重定向输入**

`exec n<file` (打开输入文件描述符).这条命令的作用是：**打开文件 `file` 以供读取，并将其分配给文件描述符 `n`（通常 n 取 3 到 9 之间的数字）。**

**效果**：它建立了一个从文件到指定编号 `n` 的持久连接。你可以随时通过 `read -u n` 来读取这个文件的内容，而不会干扰标准输入。

**常用场景**：多文件处理、防止循环内 `stdin` 冲突（如前面提到的 `ssh` 案例）。

```bash
$ cat config.txt
line1
line2
line3
# cxxu@CxxuDesk 16:19:14> <~>
$ exec 3< config.txt

# cxxu@CxxuDesk 16:19:29> <~>
$ read -u 3 -r line   # 从编号 3 中读取一行
echo "读取到的内容是: $line"
读取到的内容是: line1

# cxxu@CxxuDesk 16:19:45> <~>
$ exec 3<&-           # 关闭编号 3 的连接
```

## 恢复默认重定向行为

如果你已经执行了 `exec > out.log`，当前 Shell 的所有标准输出（stdout）都指向了文件。要将其恢复到默认（即恢复到屏幕显示），主要有以下两种方法：

### 方法 1：直接重定向回终端（最简单、最常用）

在大多数交互式 Linux 环境中，`/dev/tty` 代表当前的控制终端（屏幕）。

```bash
exec > /dev/tty
```

**效果：** 执行后，后续的 `echo` 等命令的输出将重新显示在屏幕上。

------

### 方法 2：使用备份的文件描述符

如果你在写脚本，直接指定 `/dev/tty` 有时会失效（例如脚本在后台运行或没有控制终端时）。最健壮的方法是在重定向**之前**先备份标准输出。

**操作步骤：**

1. **备份：** 将当前的屏幕输出（FD 1）保存到另一个编号（如 FD 3）。
2. **重定向：** 执行你的文件写入。
3. **恢复：** 将 FD 1 指向备份的 FD 3。

```bash
# 1. 备份：让 3 号指向现在的屏幕 (1号)
exec 3>&1

# 2. 修改：让 1 号指向文件
exec > out.log
echo "这条信息在文件里"

# 3. 恢复：让 1 号重新指向 3 号（即屏幕）
exec 1>&3

# 4. 关闭不需要的 3 号
exec 3>&-

echo "这条信息回到了屏幕！"
```

------

### 原理解析

- **`1`**：代表标准输出（stdout）。
- **`2`**：代表标准错误（stderr）。
- **`>&`**：是文件描述符的复制操作。
- **`/dev/tty`**：是一个特殊文件，始终指向当前工作的终端窗口。

### 常见问题

如果我执行了 exec > out.log 2>&1，该如何同时恢复？

如果你把错误输出也一起重定向了，恢复时需要把 1 和 2 都接回来：

```bash
exec > /dev/tty 2>&1
```

### 使用tee

如果你希望**同时**把输出打印到屏幕并保存到文件，而不是完全切换，建议使用 `tee` 命令配合进程替换，这样就不需要考虑“恢复”问题了：



```bash
# 这种方式不会改变 Shell 的全局指向
echo "数据" | tee -a out.log

# 或者在脚本开头使用 exec 配合 tee (高阶技巧)
exec > >(tee -a out.log) 2>&1
```

**你是在交互式终端里操作，还是在编写需要反复切换输出目标的脚本？**

## 为什么需要 exec

先看一个对比：

```bash
echo hello > out.txt
```

这条命令的特点是：

- 重定向 **只对这一条命令有效**
- 执行完，shell 的 stdout 仍然是终端

而：

```bash
exec > out.txt
```

特点完全不同：

- 修改的是 **当前 shell 本身**
- 后面所有命令的 stdout 都会进 `out.txt`
- 直到你再改回来或 shell 退出

这就是 exec 的“长期生效”特性。

------

### exec 和“文件描述符”的关系

`exec` 常用形式是：

```bash
exec [n]<>something
```

此时它**不执行外部命令**，而是：

> 直接在当前 shell 中操作 FD（file descriptor）

可以理解为：
**`exec` 是 shell 内部的“FD 管理工具”**

------

### 最常见用途一：永久重定向 stdout / stderr

#### 把脚本的所有输出写入文件

```bash
exec > all.log
```

等价于：

- stdout（FD 1） → all.log

之后：

```bash
echo "step 1"
ls /
echo "step 2"
```

全部进 `all.log`

------

#### 同时重定向 stdout 和 stderr

```bash
exec > all.log 2>&1
```

含义：

- stdout → all.log
- stderr → 复制 stdout → all.log

这是**写脚本日志（logging）**的标准做法。

------

### 常见用途二：临时保存并恢复标准输入/输出

这是 `exec` **最经典、最重要的实战用法**。

------

### 保存当前 stdout

```bash
exec 3>&1
```

含义：

- FD 3 = 当前 stdout 的副本

此时：

| FD   | 指向 |
| ---- | ---- |
| 1    | 终端 |
| 3    | 终端 |

------

### 重定向 stdout 到文件

```bash
exec > out.txt
```

现在：

- FD 1 → out.txt
- FD 3 → 终端（备用）

------

### 恢复 stdout

```bash
exec 1>&3
exec 3>&-
```

解释：

- `1>&3`：stdout 复制回原来的终端
- `3>&-`：关闭临时 FD，防泄漏（good practice）

------

### 一个完整示例

```bash
#!/bin/bash

exec 3>&1          # 保存 stdout
exec > out.txt     # 重定向 stdout

echo "写入文件"
ls /no/such/path   # 错误信息仍在终端

exec 1>&3          # 恢复 stdout
exec 3>&-

echo "回到终端"
```

------

### 常见用途三：抑制输出（silence）

#### 丢弃所有标准输出

```bash
exec > /dev/null
```

之后的 `echo`、`ls` 都不会显示。

------

#### 丢弃所有错误输出

```bash
exec 2> /dev/null
```

------

#### 丢弃全部输出

```bash
exec > /dev/null 2>&1
```

这在自动化脚本、cron 任务中非常常见。

------

### 常见用途四：重定向标准输入

```bash
exec < input.txt
```

之后：

```bash
read line
```

读的就是 `input.txt`，而不是键盘。

------

### 常见用途五：用 exec 打开“长期存在”的 FD

```bash
exec 3< data.txt
```

然后：

```bash
while read -u 3 line; do
    echo "$line"
done
```

优势：

- 文件只打开一次
- 不反复 fork 子进程
- 在复杂脚本中性能更好

------

### exec 的另一种含义（必须知道，但不常用）

```bash
exec ls
```

含义是：

- 用 `ls` **替换当前 shell 进程**
- shell 不会回来

你会看到：

- ls 执行完
- 终端直接结束（或脚本直接终止）

这在 shell 交互中几乎不用，但在 init、容器、守护进程中很重要。

------

### 对比总结

| 用法               | 作用                  |
| ------------------ | --------------------- |
| `exec > file`      | 永久重定向 stdout     |
| `exec 2>&1`        | 合并 stderr 到 stdout |
| `exec 3>&1`        | 备份 stdout           |
| `exec 1>&3`        | 恢复 stdout           |
| `exec < file`      | 改变 stdin            |
| `exec > /dev/null` | 静默输出              |
| `exec command`     | 替换当前进程          |

------

## 初学者心法总结

记住三句话就够了：

- **没有命令名的 exec，是在“动 FD”**
- **exec 的重定向影响当前 shell 及其后续**
- **凡是需要“保存—修改—恢复”，一定用 exec**

