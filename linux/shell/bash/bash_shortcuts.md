# bash_命令行编辑快捷键&技巧/shell job任务管理/job vs process

## reference

- [The Best Keyboard Shortcuts for Bash (aka the Linux and macOS Terminal) (howtogeek.com)](https://www.howtogeek.com/howto/ubuntu/keyboard-shortcuts-for-bash-command-shell-for-ubuntu-debian-suse-redhat-linux-etc/#:~:text=Working With Processes 1 Ctrl%2BC %3A Interrupt (kill),This is similar to running the exit command.)

  > - bash中的快捷键主要有`Ctrl/Alt`连个键打头
  > - 同样的快捷键在不同上下文中,可能表现出不同的功能!

  > - contents
  > - [Working With Processes](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#post-181)
  > - [Controlling the Screen](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-12)
  > - [Moving the Cursor](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-13)
  > - [Deleting Text](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-14)
  > - [Fixing Typos](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-15)
  > - [Cutting and Pasting](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-16)
  > - [Capitalizing Characters](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-17)
  > - [Tab Completion](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-18)
  > - [Working With Your Command History](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-19)
  > - [emacs vs. vi Keyboard Shortcuts](chrome-extension://afoibpobokebhgfnknfndkgemglggomo/popup.html#h5o-20)

-  bash(1) — Linux manual page

  [NAME](https://man7.org/linux/man-pages/man1/bash.1.html#NAME) |

   [SYNOPSIS](https://man7.org/linux/man-pages/man1/bash.1.html#SYNOPSIS) |

   [COPYRIGHT](https://man7.org/linux/man-pages/man1/bash.1.html#COPYRIGHT) | [DESCRIPTION](https://man7.org/linux/man-pages/man1/bash.1.html#DESCRIPTION) | [OPTIONS](https://man7.org/linux/man-pages/man1/bash.1.html#OPTIONS) | [ARGUMENTS](https://man7.org/linux/man-pages/man1/bash.1.html#ARGUMENTS) | [INVOCATION](https://man7.org/linux/man-pages/man1/bash.1.html#INVOCATION) | [DEFINITIONS](https://man7.org/linux/man-pages/man1/bash.1.html#DEFINITIONS) | [RESERVED WORDS](https://man7.org/linux/man-pages/man1/bash.1.html#RESERVED_WORDS) | 

  [SHELL GRAMMAR](https://man7.org/linux/man-pages/man1/bash.1.html#SHELL_GRAMMAR) | [COMMENTS](https://man7.org/linux/man-pages/man1/bash.1.html#COMMENTS) | [QUOTING](https://man7.org/linux/man-pages/man1/bash.1.html#QUOTING) | [PARAMETERS](https://man7.org/linux/man-pages/man1/bash.1.html#PARAMETERS) | [EXPANSION](https://man7.org/linux/man-pages/man1/bash.1.html#EXPANSION) | [REDIRECTION](https://man7.org/linux/man-pages/man1/bash.1.html#REDIRECTION) | [ALIASES](https://man7.org/linux/man-pages/man1/bash.1.html#ALIASES) | [FUNCTIONS](https://man7.org/linux/man-pages/man1/bash.1.html#FUNCTIONS) | [ARITHMETIC EVALUATION](https://man7.org/linux/man-pages/man1/bash.1.html#ARITHMETIC_EVALUATION) | [CONDITIONAL EXPRESSIONS](https://man7.org/linux/man-pages/man1/bash.1.html#CONDITIONAL_EXPRESSIONS) | [SIMPLE COMMAND EXPANSION](https://man7.org/linux/man-pages/man1/bash.1.html#SIMPLE_COMMAND_EXPANSION) | [COMMAND EXECUTION](https://man7.org/linux/man-pages/man1/bash.1.html#COMMAND_EXECUTION) | [COMMAND EXECUTION ENVIRONMENT](https://man7.org/linux/man-pages/man1/bash.1.html#COMMAND_EXECUTION_ENVIRONMENT) | [ENVIRONMENT](https://man7.org/linux/man-pages/man1/bash.1.html#ENVIRONMENT) | [EXIT STATUS](https://man7.org/linux/man-pages/man1/bash.1.html#EXIT_STATUS) | [SIGNALS](https://man7.org/linux/man-pages/man1/bash.1.html#SIGNALS) |

   [JOB CONTROL](https://man7.org/linux/man-pages/man1/bash.1.html#JOB_CONTROL) | [PROMPTING](https://man7.org/linux/man-pages/man1/bash.1.html#PROMPTING) | [READLINE](https://man7.org/linux/man-pages/man1/bash.1.html#READLINE) | [HISTORY](https://man7.org/linux/man-pages/man1/bash.1.html#HISTORY) | [HISTORY EXPANSION](https://man7.org/linux/man-pages/man1/bash.1.html#HISTORY_EXPANSION) | [SHELL BUILTIN COMMANDS](https://man7.org/linux/man-pages/man1/bash.1.html#SHELL_BUILTIN_COMMANDS) | [SHELL COMPATIBILITY MODE](https://man7.org/linux/man-pages/man1/bash.1.html#SHELL_COMPATIBILITY_MODE) | [RESTRICTED SHELL](https://man7.org/linux/man-pages/man1/bash.1.html#RESTRICTED_SHELL) | [SEE ALSO](https://man7.org/linux/man-pages/man1/bash.1.html#SEE_ALSO) | [FILES](https://man7.org/linux/man-pages/man1/bash.1.html#FILES) | [AUTHORS](https://man7.org/linux/man-pages/man1/bash.1.html#AUTHORS) | [BUG REPORTS](https://man7.org/linux/man-pages/man1/bash.1.html#BUG_REPORTS) | [BUGS](https://man7.org/linux/man-pages/man1/bash.1.html#BUGS) | [COLOPHON](https://man7.org/linux/man-pages/man1/bash.1.html#COLOPHON)

## 编辑快捷键Moving the Cursor

> Use the following shortcuts to quickly move the cursor around the current line while typing a command.

### 光标跳转

- **Ctrl+A** or **Home**: Go to the beginning of the line.
- **Ctrl+E** or **End**: Go to the end of the line.
- **Alt+B**: <u>Go left (back) one word.</u>
  - **Ctrl+B**: Go left (back) one character.
- **Alt+F**: Go right (forward) one word.
  - **Ctrl+F**: Go right (forward) one character.
- **Ctrl+XX**: Move between **the beginning of the lin**e and **the current position of the cursor.** 
  - This allows you to press Ctrl+XX to **return to the start of the line**, change something, and **then press Ctrl+XX to go back to your original cursor position**. 
  - To use this shortcut, <u>hold the Ctrl key and tap the X key twice.</u>

### 文本修改Capitalizing Characters

The bash shell can quickly convert characters to upper or lower case:

- **Alt+U**: Capitalize every character **from the cursor to the end of the current word**, converting the characters to upper case.
- **Alt+L**: **Uncapitalize** every character **from the cursor to the end of the current word**, converting the characters to lower case.
- **Alt+C**: Capitalize the character under the cursor. Your cursor will move to the end of the current word.
  - 可以用于将行内单词首字母大写化

## 进程管理快捷键

### 杀死当前进程(软杀)

- **Ctrl+C**: Interrupt (kill) the current foreground process running in in the terminal. 
  - This sends the [SIGINT](https://www.cloudsavvyit.com/11072/linux-signals-hacks-definition-and-more/) signal to the process, which is technically just a request—most processes will honor it, but some may ignore it.

### 挂起当前进程(暂停执行)

- **Ctrl+Z**: Suspend the current foreground process running in bash. This sends the SIGTSTP signal to the process. To return the process to the foreground later, use the `fg process_name` command.

### 关闭/离开当前shell

- > 注意,只有在全新的一行输入`Ctrl+D`才是关闭shell
  >
  > `Ctrl+D`在不同上下文有不同的功能含义
  >
  > - 在zsh中,出现在若干字符后,键入`Ctrl+D`表示要求zsh,提供补全建议
  > - 在光标处于某个字符下,`ctrl+D`表示删除该字符

- **Ctrl+D**: Close the bash shell. This sends an EOF (End-of-file) marker to bash, and bash exits when it receives this marker. This is similar to running the `exit `command.

  

### job vs process

-  [JOB CONTROL](https://man7.org/linux/man-pages/man1/bash.1.html#JOB_CONTROL)

> ```bash
>       Job control refers to the ability to selectively stop (suspend)
>        the execution of processes and continue (resume) their execution
>        at a later point.  A user typically employs this facility via an
>        interactive interface supplied jointly by the operating system
>        kernel's terminal driver and bash.
> 
>        The shell associates a job with each pipeline.  It keeps a table
>        of currently executing jobs, which may be listed with the jobs
>        command.  When bash starts a job asynchronously (in the
>        background), it prints a line that looks like:
> 
>               [1] 25647
> 
>        indicating that this job is job number 1 and that the process ID
>        of the last process in the pipeline associated with this job is
>        25647. 
>        All of the processes in a single pipeline are members of the same job.  
>        Bash uses the job abstraction as the basis for job control.
> ```

- ```bash
  ┌─[cxxu@CxxuWin11] - [~] - [2022-04-20 08:44:08]
  └─[0] <> jobs
  [1]  - 9315 suspended (tty output)  man column |
         9316 suspended (tty output)  less
  [2]  + 9361 suspended (tty output)  man ls |
         9362 suspended (tty output)  less
  ┌─[cxxu@CxxuWin11] - [~] - [2022-04-20 08:44:26]
  └─[0] <> fg %2
  [2]  - 9361 continued  man ls |
         9362 continued  less
         
  # cxxu @ CxxuWin11 in ~ [8:51:47]
  $ man ls|grep 'r'|less
  
  [1]  + 9760 done       man ls |
         9761 done       grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} 'r' |
         9763 suspended  less
  ```

  - 根据文档` All of the processes in a single pipeline are members of the same job.`可知,一个job可以包括管道符链接起来的多个进程,这些进程同属于一个job号



## Working With Your Command History

**RELATED:** [***How to Use Your Bash History in the Linux or macOS Terminal\***](https://www.howtogeek.com/howto/44997/how-to-use-bash-history-to-improve-your-command-line-productivity/)

You can quickly scroll through your recent commands, which are stored in your user account’s [bash history](https://www.howtogeek.com/howto/44997/how-to-use-bash-history-to-improve-your-command-line-productivity/) file:

- **Ctrl+P** or **Up Arrow**: Go to the previous command in the command history. Press the shortcut multiple times to walk back through the history.
- **Ctrl+N** or **Down Arrow**: Go to the next command in the command history. Press the shortcut multiple times to walk forward through the history.
- **Alt+R**: Revert any changes to a command you’ve pulled from your history if you’ve edited it.

Bash also has a special “recall” mode you can use to search for commands you’ve previously run:

- **Ctrl+R**: Recall the last command matching the characters you provide. Press this shortcut and start typing to search your bash history for a command.
- **Ctrl+O**: Run a command you found with Ctrl+R.
- **Ctrl+G**: Leave history searching mode without running a command.