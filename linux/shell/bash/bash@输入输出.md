[toc]





## 输入和输出



Bash 脚本中的输入输出是一个复杂的主题，因为它的实现方式非常灵活。本章仅对其中的可能性进行浅尝辄止的介绍。

*输入*指的是程序接收（或读取）的任何信息。Bash 脚本的输入可以来自多个不同的地方：

- 命令行参数（放置在[位置参数](https://mywiki.wooledge.org/BashGuide/Parameters)中）
- 环境变量，继承自启动脚本的进程。
- 文件
- *文件描述符*还可以指向其他任何内容（管道、终端、套接字等）。这将在下文中讨论。

*输出*指的是程序生成（或写入）的任何信息。Bash 脚本的输出也可以发送到许多不同的位置：

- 文件
- 文件描述符可以指向的其他任何内容
- 传递给其他程序的命令行参数
- 传递给其他程序的环境变量

在 shell 脚本编程中，输入和输出至关重要。几乎所有脚本的核心要求都是：弄清楚输入来自哪里、输入是什么格式，以及为了产生所需的输出，必须对输入进行哪些处理。



------





## 1. 命令行参数



对于许多脚本来说，我们最关心的（或者说唯一关心的）输入是脚本从命令行接收的参数。正如我们在 [“参数”](https://mywiki.wooledge.org/BashGuide/Parameters) 章节中看到的，每个脚本都有一些*特殊参数*可以用来存储这些参数。这些参数被称为*位置参数* 。它们是一个非常简单的字符串数组，以数字索引排列（实际上，在 POSIX shell 中，它们是 shell *唯一的*数组）。第一个位置参数用 `$1` 表示；第二个用 `$2` 表示；依此类推。从第九个位置参数开始，必须使用花括号来引用它们： `${10}` 、 `${11}` 等。但在实践中，你几乎不需要这样做，因为有更好的方法来批量处理它们。

除了逐个引用位置参数之外，您还可以使用 ` `"$@"` ` 替换来引用所有位置参数。这里的双引号**至关重要** 。如果不使用双引号，每个位置参数都会被拆分成单词并进行通配符匹配。这是您不希望看到的。使用双引号可以告诉 Bash，您希望将每个参数保留为一个单独的单词。

处理位置参数的另一种方法是在使用后逐个删除它们。为此，程序内置了一个名为 `shift` 的特殊命令。当您发出 `shift` 命令时，第一个位置参数（ `$1` ）会被删除。第二个参数变为 `$1` ，第三个参数变为 `$2` ，依此类推。因此，如果您愿意，可以编写一个循环，不断重复使用 `$1` 。

在实际脚本中，通常会结合使用这些技术。循环处理以 `-` 开头的 `$1` ，以此来处理选项。然后，当所有选项都被处理并移出后，剩下的内容（在 `"$@"` 中）很可能就是我们要处理的文件名。

为简洁起见，此处不提供论证处理示例。相关示例请参见常见问题解答。



------



- **良好做法：
  在开始编写脚本之前，先确定输入数据的来源。如果可以自行设计脚本中的数据流，那么请选择一种适合所处理数据类型的方式。如果需要传递文件名，将其作为参数传递是一个绝佳的方法，因为每个文件名都被封装成一个单词，可以直接使用。**



------



- **常见问题解答中：
  [如何轻松地处理脚本的命令行参数（选项）？](https://mywiki.wooledge.org/BashFAQ/035)**



------





## 2. 环境



每个程序都会从其父进程继承某些信息、资源、权限和限制。（有关此主题的更深入讨论，请参阅[进程管理 ](https://mywiki.wooledge.org/ProcessManagement#theory)。）其中一种资源是一组称为*环境变量*的变量。

在 Bash 中，环境变量的工作方式与我们常用的 shell 变量非常相似。唯一的区别在于，它们在脚本启动时就已经设置好了；我们无需手动设置。

传统上，环境变量的名称全部由大写字母组成，例如 `PATH` 或 `HOME` 。这有助于避免创建与环境变量冲突的变量；只要你的变量都至少包含一个小写字母，就无需担心会意外地与环境变量发生冲突。（Bash 的特殊变量也全部由大写字母组成，例如 `PIPESTATUS` 。这样做也是出于完全相同的原因——为了避免你的变量被 Bash 覆盖。）

通过环境变量向程序传递信息在很多情况下都很有用。其中之一就是用户偏好。在类 Unix 系统上，并非每个用户对应用程序都有相同的喜好，而且在某些情况下，他们可能使用的语言也不尽相同。因此，如果用户能够告诉他们运行的*每个*应用程序他们最喜欢的编辑器（ `EDITOR` 环境变量）或他们使用的语言（构成用户[区域](https://mywiki.wooledge.org/locale)设置的各种环境变量），那就非常有用。环境变量可以设置在每个用户的 [DotFiles 文件](https://mywiki.wooledge.org/DotFiles)中，然后它们会自动传递给用户从登录会话开始运行的每个程序。

环境变量也可以非常方便地进行动态调整（比将相同信息存储在文件中要容易得多）。在 Bash 中运行命令时，您可以选择指定一个仅在该命令执行期间生效的临时环境变量更改。这可以通过在命令前加上 `VAR=value` 来实现。以下是一个示例：



```
$ ls /tpm
ls: no se puede acceder a /tpm: No existe el fichero o el directorio
$ LANG=C ls /tpm
ls: cannot access /tpm: No such file or directory
```



`LANG=C` 临时环境不会导致用户的区域设置发生改变，只会影响输入该环境的命令。

在脚本中，如果您知道某些信息存储在环境变量中，就可以像使用其他变量一样使用它：



```
if [[ $DISPLAY ]]; then
    xterm -e top
else
    top
fi
```



如果设置了环境变量 `DISPLAY` （且不为空），则运行 `xterm -e top` ；否则，运行 `top` 。

如果要将信息放入环境中供子进程继承，可以使用 `export` 命令：



```
export MYVAR=something
```



棘手之处在于，你对环境所做的更改只会传递给你的**子程序** 。你无法更改正在运行的程序或未运行的程序的环境。

切换环境后再运行其他程序是非常常见的做法。专门执行此操作的脚本称为[包装脚本（WrapperScript](https://mywiki.wooledge.org/WrapperScript) ）。



------



- **良好做法：
  脚本中不要使用全大写变量名，除非是环境变量。为了避免出错，请使用小写或大小写混合的变量名。**



------



- **常见问题解答中：
  [我正在尝试编写一个脚本来更改目录（或设置变量），但是脚本执行完毕后，我又回到了起点（或者我的变量没有被设置）！](https://mywiki.wooledge.org/BashFAQ/060)**



------





## 3. 文件描述符



*文件描述符* （简称 FD）是程序引用文件或其他类似文件资源（例如管道、设备、套接字或终端）的方式。FD 类似于指向数据源或数据写入位置的指针。当程序读取或写入某个 FD 时，数据实际上是从该 FD 所指向的资源读取或写入的。

默认情况下，每个新进程启动时都会打开三个文件描述符：

- *标准输入* （ `stdin` ）：文件描述符 0
- *标准输出* （ `stdout` ）：文件描述符 1
- *标准误差* （ `stderr` ）：文件描述符 2

在交互式 shell 或终端运行的脚本中， *标准输入 (Standard Input)* 用于接收 bash 从键盘输入的字符。 *标准输出 (Standard Output)* 用于发送程序的大部分常规信息，以便用户查看； *标准错误 (Standard Error* ) 用于发送程序的错误信息。

图形用户界面 (GUI) 应用程序也有这些文件描述符 (FD)，但它们通常无法直接使用。通常情况下，它们的所有用户交互都通过 GUI 完成，这使得 [BASH](https://mywiki.wooledge.org/BASH) 很难控制它们。因此，我们将只使用简单的终端应用程序。对于这些应用程序，我们可以轻松地通过标准输入向其输入数据，并通过标准输出和标准错误读取数据。

让我们把这些定义更具体地说明一下。下面演示一下标准输入和标准输出是如何工作的：



```
$ read -p "What is your name? " name; echo "Good day, $name.  Would you like some tea?"
What is your name? lhunath
Good day, lhunath.  Would you like some tea?
```



`read` 是一个命令，它从 `stdin` 读取信息并将其存储在一个变量中。我们指定 `name` 为该变量。 `read` 从 `stdin` 读取一行信息后，它会停止工作，并让 `echo` 显示一条消息。 `echo` 将其输出发送给 `stdout` 。 `stdin` 和 `stdout` 连接到您的终端。当程序从终端读取数据时，它会接收来自您键盘的按键；当程序向终端写入数据时，字符会显示在您的显示器上。因此，您可以输入您的名字，然后在显示器上看到一条友好的消息，例如邀请您喝杯茶。

那么 `stderr` 是什么呢？我们来演示一下：



```
$ rm secrets
rm: cannot remove `secrets': No such file or directory
```



除非当前目录下存在名为 `secrets` 的文件，否则 `rm` 命令将会失败，并显示一条错误信息解释出错原因。按照惯例，这类错误信息会显示在 `stderr` 中。

`stderr` is also connected to your terminal's output device, just like `stdout`. As a result, error messages display on your monitor just like the messages on `stdout`. However, the distinction between `stdout` and `stderr` makes it easy to keep errors separated from the application's normal messages. For example, a script might wish to log `stderr` messages in a special place for long-term storage. Some people also like to use wrappers to make all the output on `stderr` red, so that they can see the error messages more clearly. (This doesn't work as well as one might wish, but some people find it good enough for some tasks.)

In shell scripts, FDs are always referenced by number. In the next section, we will see some of the ways we can work with FDs using their numbers.



------



- **In the Manual: [The read builtin](http://www.gnu.org/software/bash/manual/bashref.html#index-read-142)**



------



- **Good Practice:
  Remember that when you create scripts, you should send your custom error messages to the `stderr` FD. This is a convention and it is very convenient when applications follow the convention. As such, so should you! You're about to learn redirection soon, but let me show you quickly how it's done:**

  ```
   echo "Uh oh.  Something went really bad.." >&2
  ```

  



------



- *File Descriptor*: A numeric index referring to one of a process's open files. Each command has at least three basic descriptors: FD 0 is `stdin`, FD 1 is `stdout` and FD 2 is `stderr`.



------





## 4. Redirection



The most basic form of input/output manipulation in BASH is *Redirection*. *Redirection* is used to change the data source or destination of a program's FDs. That way, you can send output to a file instead of the terminal, or have an application read from a file instead of from the keyboard.

Redirections are performed by BASH (or any other shell), *before* the shell runs the command to which the redirections are applied.



------



- **In The Manual: [Redirections](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Redirections)**



------



- *Redirection*: the practice of changing a FD to read its input from, or send its output to, a different location.



------





### 4.1. File Redirection



*File Redirection* involves changing a single FD to point to a file. Let's start with an output redirection:



```
$ echo "It was a dark and stormy night.  Too dark to write." > story
$ cat story
It was a dark and stormy night.  Too dark to write.
```



The `>` operator begins an *output redirection*. The redirection applies only to one command (in this case, an `echo` command). It tells BASH that when BASH runs the command, `stdout` should point to a file, rather than wherever it was pointing before.

As a result, the `echo` command will not send its output to the terminal; rather, the `> story` redirection **changes the destination of the `stdout` FD** so that it now points to a file called `story`. Be aware that this redirection occurs before the `echo` command is executed. By default, Bash doesn't check to see whether that file `story` exists first; it just opens the file, and if there was already a file by that name, its former contents are lost. If the file doesn't exist, it is created as an empty file, so that the FD can be pointed to it. This behaviour can be toggled with *Shell Options* (see later).

It should be noted that this redirection is in effect only for the single `echo` command it was applied to. Other commands executed after that will continue sending their output to the script's `stdout` location.

We then use the application `cat` to print out the contents of that file. `cat` is an application that reads the contents of all the files you pass it as arguments. It then writes each file one after another on `stdout`. In essence, it con**cat**enates the contents of all the files you pass it as arguments.

**Warning:** Far too many code examples and shell tutorials on the Internet tell you to use `cat` whenever you need to read the contents of a file. **This is not necessary!** `cat` only serves well to concatenate multiple files together, or as a quick tool on the shell prompt to see what's inside a file. You should **NOT** use `cat` to pipe files to commands in your scripts. Instead, you should use a redirection. Please keep this warning in mind. Useless use of `cat` will result in an extra process to create, and using a pipe instead of a redirection takes away an application's ability to skip back and forth inside the input file.

When we use `cat` without passing any kind of arguments, it obviously doesn't know what files to read. In this case, `cat` will just read from `stdin` instead of from a file (much like `read`). Since `stdin` is normally not a regular file, starting `cat` without any arguments will seem to do nothing:



```
$ cat
```



It doesn't even give you back your shell prompt! What's going on? `cat` is still reading from `stdin`, which is your terminal. Anything you type on your keyboard now will be sent to `cat` as soon as you hit the *Enter* key. With each line you type, `cat` will do what it normally does: display it reads on `stdout`, the same way as when it displayed our story on `stdout`.



```
$ cat
test?
test?
```



Why does it say `test?` twice now? First of all, terminals are actually more complicated than they appear; they have different modes of operation. The mode we are using in this example is called *canonical mode*, and in this mode, the terminal shows you each character as you type it, and lets you perform extremely simple editing (such as using the Backspace key) on your input. The stuff you type is not actually sent to the application until you press Enter.

As you type `test?`, you will see it echoed on the screen by the terminal itself. Once you press Enter, the whole line becomes available to the application (`cat`) that's reading from the terminal. `cat` reads the line from `stdin`, and then shows it on `stdout`, which is also your terminal; hence, the second line: `test?`.

You can press *Ctrl+D* to send your terminal the *End of File* character. That'll cause `cat` to think `stdin` has closed. It will stop reading, and terminate. BASH will see that `cat` has terminated, and return you to your prompt.

Now let's use an *input redirection* to attach a file to `stdin`, so that `stdin` is no longer reading from our keyboard, but instead, now reads from the file:



```
$ cat < story
The story of William Tell.

It was a cold december night.  Too cold to write.
```



The result of this is exactly the same as the result from our previous `cat story`; except this time, the way it works is a little different. In our first example, `cat` opened an FD to the file `story` and read its contents through that FD. In the second example, `cat` simply reads from `stdin`, just like it did when it was reading from our keyboard. However, this time, the `< story` operation has **modified** `cat`'s `stdin` so that its data source is the file `story` rather than our keyboard.

Redirection operators can be preceded by a number. That number denotes the FD that will be changed.

Let's summarize with some examples:

- **`command > file`**: Send the `stdout` of command to `file`.
- **`command 1> file`**: Send the `stdout` of command to `file`. Since `stdout` is FD 1, that's the number we put in front of the redirection operator. This is identical to the previous example, because FD 1 is the default for the **>** operator.
- **`command < file`**: Use the contents of `file` when `command` reads from `stdin`.
- **`command 0< file`**: Use the contents of `file` when `command` reads from `stdin`, exactly as in the previous example, since FD 0 (`stdin`) is the default for the **<** operator.

The number for the `stderr` FD is 2. So, let's try sending `stderr` to a file:



```
$ for homedir in /home/*
> do rm "$homedir/secret"
> done 2> errors
```



In this example, we're looping over each directory (or file) in `/home`. We then try to delete the file `secret` in each of them. Some `homedir`s may not have a secret, or we may not have permission to remove it. As a result, the `rm` operation will fail and send an error message on `stderr`.

You may have noticed that our redirection operator isn't on `rm`, but it's on that `done` thing. Why is that? Well, this way, the redirection applies to all output to `stderr` made inside the whole loop. Technically, what happens is BASH opens the file named `errors` and points `stderr` to it before the loop begins, then closes it when the loop ends. Any commands run inside the loop (such as `rm`) *inherit* the open FD from BASH.

Let's see what the result of our loop was:



```
$ cat errors
rm: cannot remove `/home/axxo/secret': No such file or directory
rm: cannot remove `/home/lhunath/secret': No such file or directory
```



Two error messages in our error log file. Two people that didn't have a `secret` file in their home directory.

If you're writing a script, and you expect that running a certain command may fail on occasion, but don't want the script's user to be bothered by the possible error messages that command may produce, you can silence a FD. Silencing it is as easy as normal *File Redirection*. We're just going to send all output to that FD into the system's black hole:



```
$ for homedir in /home/*
> do rm "$homedir/secret"
> done 2> /dev/null
```



The file `/dev/null` is **always** empty, no matter what you write to it or read from it. As such, when we write our error messages to it, they just disappear. The `/dev/null` file remains as empty as ever before. That's because it's not a normal file; it's a *virtual* device. Some people call `/dev/null` the *bit bucket*.

There is one last thing you should learn about *File Redirection*. It's interesting that you can make error log files like this to keep your error messages; but as I mentioned before, Bash destroys the existing contents of a file when it redirects to it. As a result, each time we run our loop to delete secret files, our log file will be truncated empty before we fill it up again with new error messages. What if we'd like to keep a record of any error messages generated by our loop? What if we don't want that file to be truncated each time we start our loop? The solution is achieved by doubling the redirection operator. `>` becomes `>>`. `>>` will not empty a file; it will just append new data to the end of it!



```
$ for homedir in /home/*
> do rm "$homedir/secret"
> done 2>> errors
```



Hooray!

By the way, the space between the redirection operator and the filename is optional. Some people write `> file` and some write `>file`. Both ways are correct.



------



- **Good Practice:
  It's a good idea to use redirection whenever an application needs file data and is built to read data from `stdin`. A lot of bad examples on the Internet tell you to pipe (see later) the output of `cat` into processes; but this is nothing more than a very \*bad\* idea.
  When designing an application that could be fed data from a variety of different sources, it is often best simply to have your application read from `stdin`; that way, the user can use redirection to feed it whatever data she wishes. An application that reads standard input in a generalized way is called a \*filter\*.**



------





### 4.2. File Descriptor Manipulation



Now that you know how to manipulate process input and output by sending it to and reading it from files, let's make it a little more interesting still.

It's possible to change the source and destination of FDs to point to or from files, as you know. It's also possible to copy one FD to another. Let's prepare a simple testbed:



```
$ echo "I am a proud sentence." > file
```



We've made a file called `file`, and written a proud sentence into it.

There's an application called `grep` that we've seen briefly in a previous chapter. `grep` is like duct tape: you can use it in almost any project (whether it's a good idea or not). It basically takes a *search pattern* as its first argument and maybe some filenames as extra arguments. Just like `cat`, `grep` also uses `stdin` if you don't specify any files. `grep` reads the files (or `stdin` if none were provided) and searches for the *search pattern* you gave it. Most versions of `grep` even support a `-r` switch, which makes it take directories as well as files as extra arguments, and then searches all the files and directories in those directories that you gave it. Here's an example of how `grep` can work:



```
$ ls house/
drawer  closet  dustbin  sofa
$ grep -r socks house/
house/sofa:socks
```



In this silly example we have a directory called `house` with several pieces of furniture in it as files. If we're looking for our `socks` in each of those files, we send `grep` to search the directory `house/`. `grep` will search everything in there, open each file and look through its contents. In our example, `grep` finds `socks` in the file `house/sofa`; presumably tucked away under a pillow. You want a more realistic example? Sure:



```
$ grep "$HOSTNAME" /etc/*
/etc/hosts:127.0.0.1       localhost Lyndir
```



Here we instruct `grep` to search for whatever `$HOSTNAME` expands to in whatever files `/etc/*` expands to. It finds my hostname, which is `Lyndir`, in the file `/etc/hosts`, and shows me the line in that file that contains the *search pattern*.

OK, now that you understand `grep`, let's continue with our *File Descriptor Manipulation*. Remember that we created a file called `file`, and wrote a proud sentence to it? Let's use `grep` to find where that proud sentence is now:



```
$ grep proud *
file:I am a proud sentence.
```



Good! `grep` found our sentence in `file`. It writes the result of its operation to `stdout` which is shown on our terminal. Now let's see if we can make `grep` send an error message, too:



```
$ grep proud file 'not a file'
file:I am a proud sentence.
grep: not a file: No such file or directory
```



This time, we instruct `grep` to search for the string `proud` in the files '`file`' and '`not a file`'. `file` exists, and the sentence is in there, so `grep` happily writes the result to `stdout`. It moves on to the next file to scan, which is '`not a file`'. `grep` can't open this file to read its content, because it doesn't exist. As a result, `grep` emits an error message on `stderr` which is still connected to our terminal.

Now, how would you go about silencing this `grep` statement completely? We'd like to send all the output that appears on the terminal to a file instead; let's call it `proud.log`:



```
# Not quite right....
$ grep proud file 'not a file' > proud.log 2> proud.log
```



Does that look about right? We first use `>` to send `stdout` to `proud.log`, and then use `2>` to send `stderr` to `proud.log` as well. Almost, but not quite. If you run this command (at least on some computers), and then look in `proud.log`, you'll see there's only an error message, not the output from `stdout`. We've created a very bad condition here. We've created two FDs that both point to the same file, independently of each other. The results of this are not well-defined. Depending on how the operating system handles FDs, some information written via one FD may clobber information written through the other FD.



```
$ echo "I am a very proud sentence with a lot of words in it, all for you." > file2
$ grep proud file2 'not a file' > proud.log 2> proud.log
$ cat proud.log
grep: not a file: No such file or directory
of words in it, all for you.
```



What happened here? `grep` opened `file2` first, found what we told it to look for, and then wrote our very proud sentence to `stdout` (FD 1). FD 1 pointed to `proud.log`, so the information was written to that file. However, we also had another FD (FD 2) pointed to this same file, and specifically, pointed to the *beginning* of this file. When `grep` tried to open '`not a file`' to read it, it couldn't. Then, it wrote an error message to `stderr` (FD 2), which was pointing to the beginning of `proud.log`. As a result, the second write operation overwrote information from the first one!

We need to prevent having two independent FDs working on the same destination or source. We can do this by *duplicating* FDs:



```
$ grep proud file 'not a file' > proud.log 2>&1
```



In order to understand these, you need to remember: always read file redirections from left to right. This is the order in which Bash processes them. First, `stdout` is changed so that it points to our `proud.log`. Then, we use the `>&` syntax to duplicate FD 1 and put this duplicate in FD 2.

A duplicate FD works differently from having two independent FDs pointing to the same place. Write operations that go through either one of them are exactly the same. There won't be a mix-up with one FD pointing to the start of the file while the other has already moved on.

Be careful not to confuse the order:



```
$ grep proud file 'not a file' 2>&1 > proud.log
```



This will duplicate `stdout` (which points to the terminal) and put the duplicate in `stderr`, and then `stdout` will be redirected to `proud.log`. As a result, `stdout`'s messages will be logged, but the error messages will still go to the terminal. *Oops.*

**Note:
For convenience, Bash also makes yet another form of redirection available to you. The `&>` redirection operator is actually just a shorter version of what we did here; redirecting both `stdout` and `stderr` to a file :**



```
$ grep proud file 'not a file' &> proud.log
```



This is the same as `> proud.log 2>&1`, but not portable to [BourneShell](https://mywiki.wooledge.org/BourneShell). It is not recommended practice, but you should recognize it if you see it used in someone else's scripts.

***TODO: Moving FDs and Opening FDs RW.***



------



- **In the FAQ:
  [How can I redirect the output of multiple commands at once?](https://mywiki.wooledge.org/BashFAQ/014)**
- **[How can I redirect the output of 'time' to a variable or file?](https://mywiki.wooledge.org/BashFAQ/032)**
- **[How do I use dialog to get input from the user?](https://mywiki.wooledge.org/BashFAQ/040)**
- **[How can I redirect stderr to a pipe?](https://mywiki.wooledge.org/BashFAQ/047)**
- **[Tell me all about 2>&1 -- what's the difference between 2>&1 >foo and >foo 2>&1, and when do I use which?](https://mywiki.wooledge.org/BashFAQ/055)**



------





### 4.3. Heredocs And Herestrings



Sometimes storing data in a file is overkill. We might only have a tiny bit of it -- enough to fit conveniently in the script itself. Or we might want to redirect the contents of a variable into a command, without having to write it to a file first.



```
$ grep proud <<END
> I am a proud sentence.
> END
I am a proud sentence.
```



This is a *Heredoc* (or *Here Document*). *Heredoc*s are useful if you're trying to embed short blocks of multi-line data inside your script. (Embedding larger blocks is bad practice. You should keep your logic (your code) and your input (your data) separated, preferably in different files, unless it's a small data set.)

In a *Heredoc*, we choose a word to act as a sentinel. It can be any word; we used `END` in this example. Choose one that won't appear in your data set. All the lines that follow the *first* instance of the sentinel, up to the *second* instance, become the `stdin` for the command. The second instance of the sentinel word has to be a line all by itself.

There are a few different options with *Heredocs*. Normally, you can't indent them -- any spaces you use for indenting your script will appear in the `stdin`. The terminator string (in our case `END`) must be at the beginning of the line.



```
echo "Let's test abc:"
if [[ abc = a* ]]; then
    cat <<END
        abc seems to start with an a!
END
fi
```



Will result in:



```
Let's test abc:
        abc seems to start with an a!
```



You can avoid this by temporarily removing the indentation for the lines of your *Heredoc*s. However, that distorts your pretty and consistent indentation. There is an alternative. If you use `<<-END` instead of `<<END` as your *Heredoc* operator, Bash removes any `tab` characters in the beginning of each line of your *Heredoc* content before sending it to the command. That way you can still use tabs (but not spaces) to indent your *Heredoc* content with the rest of your code. Those tabs will not be sent to the command that receives your *Heredoc*. You can also use tabs to indent your sentinel string.

Bash substitutions are performed on the contents of the *Heredoc* by default. However, if you quote the word that you're using to delimit your *Heredoc*, Bash won't perform any substitutions on the contents. Try this example with and without the quote characters, to see the difference:

```
$ cat <<'XYZ'
> My home directory is $HOME
> XYZ
My home directory is $HOME
```



The most common use of *Heredocs* is dumping documentation to the user:

```
usage() {
    cat <<EOF
usage: foobar [-x] [-v] [-z] [file ...]
A short explanation of the operation goes here.
It might be a few lines long, but shouldn't be excessive.
EOF
}
```



Now let's check out the very similar but more compact *Herestring*:



```
$ grep proud <<<"I am a proud sentence"
I am a proud sentence.
```



This time, `stdin` reads its information straight from the string you put after the `<<<` operator. This is very convenient to send data that's in variables into processes:



```
$ grep proud <<<"$USER sits proudly on his throne in $HOSTNAME."
lhunath sits proudly on his throne in Lyndir.
```



*Herestring*s are shorter, less intrusive and overall more convenient than their bulky *Heredoc* counterpart. However, they are not portable to the Bourne shell.

Later on, you will learn about pipes and how they can be used to send the output of a command into another command's `stdin`. Many people use pipes to send the output of a variable as `stdin` into a command. However, for this purpose, *Herestring*s should be preferred. They do not create a subshell and are lighter both to the shell and to the style of your shell script:



```
$ echo 'Wrap this silly sentence.' | fmt -t -w 20
Wrap this silly
   sentence.
$ fmt -t -w 20 <<< 'Wrap this silly sentence.'
Wrap this silly
   sentence.
```



Technically, *Heredocs* and *Herestrings* are themselves redirects just like any other. As such, additional redirections can occur on the same line, all evaluated in the usual order.

```
$ cat <<EOF > file
> My home dir is $HOME
> EOF
$ cat file
My home dir is /home/greg
```





------



- **Good Practice:
  Long heredocs are usually a bad idea because scripts should contain logic, not data. If you have a large document that your script needs, you should ship it in a separate file along with your script. Herestrings, however, come in handy quite often, especially for sending variable content (rather than files) to filters like `grep` or `sed`.**



------





## 5. Pipes



Now that you can effortlessly manipulate *File Descriptors* to direct certain types of output to certain files, it's time you learn some more ingenious tricks available through I/O redirection.

You can use *File Redirection* to write output to files or read input from files. But what if you want to connect the output of one application directly to the input of another? That way, you could build a sort of chain to process output. If you already know about `FIFO`s, you could use something like this to that end:



```
$ ls
$ mkfifo myfifo; ls
myfifo
$ grep bea myfifo &
[1] 32635
$ echo "rat
> cow
> deer
> bear
> snake" > myfifo
bear
```



We use the `mkfifo` command to create a new file in the current directory named '`myfifo`'. This is no ordinary file, however, but a `FIFO` (which stands for *First In, First Out*). `FIFO`s are special files that serve data on a `First In, First Out`-basis. When you read from a `FIFO`, you will only receive data as soon as another process writes to it. As such, a `FIFO` never really contains any data. So long as no process writes to it, any read operation on the `FIFO` will **block** as it waits for data to become available. The same works for writes to the `FIFO` -- they will block until another process reads from the `FIFO`.

In our example, the `FIFO` called `myfifo` is read from by `grep`. `grep` waits for data to become available on the `FIFO`. That's why we append the grep command with the `&` operator, which puts it in the background. That way, we can continue typing and executing commands while `grep` runs and waits for data. Our `echo` statement feeds data to the `FIFO`. As soon as this data becomes available, the running `grep` command reads it in and processes it. The result is displayed. We have successfully sent data from the `echo` command to the `grep` command.

But these temporary files are a real annoyance. You may not have write permissions. You need to remember to clean up any temporary files you create. You need to make sure that data is going in and out, or the `FIFO` might just end up blocking for no reason.

For these reasons, another feature is made available: *Pipes*. A pipe basically just connects the `stdout` of one process to the `stdin` of another, effectively *piping* the data from one process into another. The entire set of commands that are piped together is called a *pipeline*. Let's try our above example again, but using pipes:



```
$ echo "rat
> cow
> deer
> bear
> snake" | grep bea
bear
```



The pipe is created using the `|` operator between two commands that are connected with the pipe. The former command's `stdout` is connected to the latter command's `stdin`. As a result, `grep` can read `echo`'s output and display the result of its operation, which is `bear`.

Pipes are widely used as a means of post-processing application output. `FIFO`s are, in fact, also referred to as `named pipes`. They accomplish the same results as the pipe operator, but through a filename.

**Note:
The pipe operator creates a subshell environment for each command. This is important to know because any variables that you modify or initialize inside the second command will appear unmodified outside of it. Let's illustrate:**



```
$ message=Test
$ echo 'Salut, le monde!' | read message
$ echo "The message is: $message"
The message is: Test
$ echo 'Salut, le monde!' | { read message; echo "The message is: $message"; }
The message is: Salut, le monde!
$ echo "The message is: $message"
The message is: Test
```



Once the pipeline ends, so do the subshells that were created for it. Along with those subshells, any modifications made in them are lost. So be careful!



------



- **Good Practice:
  Pipes are a very attractive means of post-processing application output. You should, however, be careful not to over-use pipes. If you end up making a pipeline that consists of three or more applications, it is time to ask yourself whether you're doing things a smart way. You might be able to use more application features of one of the post-processing applications you've used earlier in the pipe. Each new command in a pipeline causes a new subshell and a new application to be loaded. It also makes it very hard to follow the logic in your script!**



------



- **In The Manual: [Pipelines](http://www.gnu.org/software/bash/manual/bashref.html#Pipelines)**



------



- **In the FAQ:
  [I set variables in a loop. Why do they suddenly disappear after the loop terminates? Or, why can't I pipe data to read?](https://mywiki.wooledge.org/BashFAQ/024)**
- **[How can two processes communicate using named pipes (fifos)?](https://mywiki.wooledge.org/BashFAQ/027)**
- **[How can I redirect stderr to a pipe?](https://mywiki.wooledge.org/BashFAQ/047)**
- **[How can I read a file line-by-line?](https://mywiki.wooledge.org/BashFAQ/001)**
- **[Tell me all about 2>&1 -- what's the difference between 2>&1 >foo and >foo 2>&1, and when do I use which?](https://mywiki.wooledge.org/BashFAQ/055)**



------





## 6. Miscellaneous Operators



Aside from the standard I/O operators, bash also provides a few more advanced operators that make life on the shell that much nicer.



### 6.1. Process Substitution



A cousin of the pipe is the *Process Substitution* operator, which comes in two forms: `<(cmd)` and `>(cmd)`. It's a convenient way to get the benefits of temporary files or named pipes without having to create them yourself. Whenever you think you need a temporary file to do something, process substitution might be a better way to handle it.

The `>()` form is relatively rare, and we won't cover it here, because it'll just confuse things. Once you understand how `<()` works, `>()` just does the same thing in reverse (writing instead of reading).

What `<()` does, is run the command inside the parentheses, and gives you a temporary filename that you can use to read the command's output. The advantage over pipes is that you can use the filename as an argument to a command that expects to see a filename.

For example, let's say you have two files that you'd like to `diff`, but they aren't sorted yet. You could generate two temporary files, to hold the sorted versions of your original files, and then run `diff` on those. Or, you could use process substitutions:



```
$ diff <(sort file1) <(sort file2)
```



With the `<()` operator, the command's output is sent through a named pipe (or something similar) that's created by bash. The operator itself in your command is replaced by the filename of that file. After your whole command finishes, the file is cleaned up.

The same thing can be done with any commands whose output you'd like to pass to `diff`. Imagine you want to see the difference between the output of two commands. Ordinarily, you'd have to put the two outputs in two files and `diff` those:



```
$ head -n 1 .dictionary > file1
$ tail -n 1 .dictionary > file2
$ diff -y file1 file2
Aachen                                                        | zymurgy
$ rm file1 file2
```



Using the process substitution operator, we can do all that with a one-liner and no need for manual cleanup:



```
$ diff -y <(head -n 1 .dictionary) <(tail -n 1 .dictionary)
Aachen                                                        | zymurgy
```



The `<(..)` part is replaced by the temporary FIFO created by bash, so `diff` actually sees something like this:



```
$ diff -y /dev/fd/63 /dev/fd/62
```



Here we see how bash runs `diff` when we use process substitution. It runs our `head` and `tail` commands, sending their respective outputs through the "files" `/dev/fd/63` and `/dev/fd/62`. Then it runs the `diff` command, passing those filenames where originally we had put the process substitution operators.

The actual implementation differs from system to system. In fact, you can see what the above would actually look like to `diff` on your box by putting an `echo` in front of our command:



```
box1$ echo diff -y <(head -n 1 .dictionary) <(tail -n 1 .dictionary)
diff -y /dev/fd/63 /dev/fd/62
```





```
box2$ echo <(cat /dev/null)
/var/tmp//sh-np-605454726
```



For examples using the `>()` form, see [ProcessSubstitution](https://mywiki.wooledge.org/ProcessSubstitution) and [Bash FAQ 106](https://mywiki.wooledge.org/BashFAQ/106).



------



- **Good Practice:
  Process Substitution gives you a concise way to create temporary FIFOs automatically. They're less flexible than creating your own named pipes by hand, but they're perfect for common short commands like `diff` that need filenames for their input sources.**

