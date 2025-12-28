[toc]

## abstract

当你从一个脚本调用另一个脚本时，**新脚本会继承原脚本的环境**，就像在 UNIX 系统中运行任何其他程序一样。

> 解释其具体含义超出了本指南的范围，但通常你可以将环境理解为**当前工作目录、打开的文件描述符和环境变量，你可以使用 `export` 命令查看这些信息**。

### 子进程方式运行脚本

当你运行的脚本（或者任何其他程序）**执行完毕后，它的环境会被丢弃**。第一个脚本的环境将**与调用第二个脚本之前的环境相同**

> 当然，bash 的一些**特殊参数可能会发生变化**（例如， `$?` 的值，即最近一次命令的返回值）。

这意味着，例如，你不能简单地运行一个脚本来更改当前工作目录。

### 读取脚本内容到当前shell中运行

不过,你可以*直接执行*脚本，而不是将其作为**子进程**运行。你可以使用 `.` （点）命令来实现这一点：

```bash
. ./myscript   #runs the commands from the file myscript in this environment
```



这*在脚本中通常被称为**点**(dotting) 。 `.` 告诉 [BASH](https://mywiki.wooledge.org/BASH) 读取 `./myscript` 中的命令并**在当前 shell 环境中执行它们**。由于这些命令在当前 shell 中执行，因此**它们可以更改当前 shell 的变量、工作目录、打开的文件描述符、函数等等**。

> 请注意，Bash 对此命令还有另一个名称 `source` ，但由于它与 `.` 命令的**工作方式完全相同**，因此最好忽略它，直接使用 `.` 命令，因为它在任何地方都有效。

### `source`(或`.`)命令

```bash
# cxxu@CxxuDesk 12:34:08> <~>
$ help source
source: source [-p path] filename [arguments]
    Execute commands from a file in the current shell.

    Read and execute commands from FILENAME in the current shell. If the
    -p option is supplied, the PATH argument is treated as a colon-
    separated list of directories to search for FILENAME. If -p is not
    supplied, $PATH is searched to find FILENAME. If any ARGUMENTS are
    supplied, they become the positional parameters when FILENAME is executed.

    Exit Status:
    Returns the status of the last command executed in FILENAME; fails if
    FILENAME cannot be read.

```



