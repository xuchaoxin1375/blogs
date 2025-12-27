[toc]

## abstract

exec是bash中的一个内置的命令

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

### 核心行为：

> 1. Execute COMMAND, replacing this shell with the specified program. ARGUMENTS become the arguments to COMMAND. 
> 2. If COMMAND is not specified,any redirections take effect in the current shell.

- **替换当前 shell**
  当执行 `exec COMMAND` 时，当前 shell 进程会被 `COMMAND` 完全替换。

  - **不会 fork 子进程**：普通命令会在子进程中运行，而 `exec` 直接在当前进程中加载新程序。
  - **shell 终止**：执行后，原 shell 不复存在（除非在脚本中且有后续逻辑，但实际不会执行到）。
  - **参数传递**:所有跟在 `COMMAND` 后面的 `ARGUMENTS` 会作为该命令的参数传递。

- **无 COMMAND 时的作用**
  如果只写 `exec` 而不指定命令，则**仅应用重定向**到当前 shell：

  ```bash
  exec > output.log    # 后续所有命令的标准输出都重定向到 output.log,当前终端还是可以继续交互,不过输出都进入到output.log中
  exec 2> error.log    # 标准错误重定向(谨慎使用,当前shell接下来的所有操作都不会显示在终端上,而会将操作记录到error.log中)
  ```

我们可以再额外打开另外的终端,然后观察

对于第一种情况:在新终端(shell会话)中使用`tail -f output.log`查看原终端的命令执行结果(标准输出都被重定向到该文件中)

对于第二种情况:不仅是标准错误,连同标准输出都被重定向到`error.log`中,同样可以在新终端中使用`tail -f error.log`查看原终端中输入的任何内容,执行`exec 2> /dev/tty`可以将原终端重定向回到可交互的状态

### 为什么需要 exec

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

