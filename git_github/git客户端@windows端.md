[toc]

## git软件

### 免安装版本(portableGit)

- [Git - Downloading Package (git-scm.com)](https://git-scm.com/download/win)

- How to start using PortableGit

  If you are comfortable with a Unix-like shell, just launch 'git-bash.exe'.

  If not, just launch 'git-cmd.exe'.

  Alternatively, you can execute these commands to modify the %path%
  variable temporarily:

          set gitdir=c:\portablegit
          set path=%gitdir%\cmd;%path%

  Adjust the 'gitdir' according to your setup.  As long as you do not
  close the command window, you can now simply type "git" or "gitk" to
  really call "c:\portablegit\cmd\git.exe" or "c:\portablegit\cmd\gitk.exe".

### 目录结构(level 2)

- ```bash
  PS D:\exes\PortableGit> tree_lsd -depth_opt 2
   .
  ├──  bin
  │   ├──  bash.exe
  │   ├──  git.exe
  │   └──  sh.exe
  ├──  cmd
  │   ├──  git-gui.exe
  │   ├──  git.exe
  │   ├──  gitk.exe
  │   ├──  start-ssh-agent.cmd
  │   └──  start-ssh-pageant.cmd
  ├──  dev
  ...
  ├──  etc
  │   ├──  bash.bash_logout
  │   ├──  bash.bashrc
  │   ├──  DIR_COLORS
  ....
  │   ├──  ssh
  │   ├──  tigrc
  │   └──  vimrc
  ├──  git-bash.exe
  ├──  git-cmd.exe
  ├──  LICENSE.txt
  ├──  mingw64
  │   ├──  bin
  │   ├──  doc
  │   ├──  etc
  │   ├──  lib
  │   ├──  libexec
  │   ├──  share
  │   └──  ssl
  ├──  README.portable
  ├──  tmp
  └──  usr
      ├──  bin
      ├──  etc
      ├──  lib
      ├──  libexec
      ├──  share
      └──  ssl
  ```

### gitk

- `gitk.exe` 是 Git 自带的一个可视化工具，它用于查看 Git 仓库的提交历史和分支结构等信息。`gitk.exe` 可以在 Windows 系统下运行，并且与 Git Bash 或 Git CMD 一样，是 Git 命令行工具的一部分。

  使用 `gitk` 命令启动 `gitk.exe`，它将打开一个图形化界面，显示当前 Git 仓库的提交历史和分支结构。你可以通过界面上的各种选项和按钮来查看、比较、合并和管理提交历史和分支。例如，你可以：

  - 查看提交历史：在 `gitk.exe` 界面中，你可以看到当前分支的提交历史，每个提交都有一个唯一的 SHA-1 标识符、提交消息和提交时间等信息。
  - 比较提交：你可以选择两个提交，然后比较它们之间的差异，`gitk.exe` 将会显示这些差异。
  - 合并分支：你可以选择两个分支，然后将它们合并成一个新的分支，`gitk.exe` 将会帮助你完成合并操作。
  - 管理标签：你可以创建、删除、重命名和推送标签等。

  总的来说，`gitk.exe` 是一个非常实用的 Git 可视化工具，可以帮助你更好地理解和管理 Git 仓库的提交历史和分支结构。虽然它比较简单，但对于快速查看 Git 仓库的提交历史和分支结构来说，非常方便实用。

### git-cmd vs git-bash(非核心部分)

- Git Bash 和 Git CMD 都是 Windows 上的 Git 命令行工具。它们都提供了基本的 Git 命令行功能，可以让你在 Windows 上使用 Git。

  Git Bash 是一个基于 MinGW64 的终端模拟器，它提供了一个类 Unix 的命令行环境，包括 Bash shell、GNU 工具和 Git 命令行工具等。它的界面类似于 Linux 终端，可以使用类 Unix 的命令和语法。

  Git CMD 是一个基于 Windows 命令提示符（cmd.exe）的命令行工具，它提供了一个 Windows 命令行环境，包括 Windows 命令行工具和 Git 命令行工具等。它的界面类似于 Windows 命令提示符，可以使用 Windows 命令和语法。

  虽然 Git Bash 和 Git CMD 都可以在 Windows 上使用 Git，但它们的界面和使用方式有所不同。Git Bash 更接近于 Unix 环境，可以使用类 Unix 的命令和语法，如果你已经熟悉 Linux 或 macOS 等 Unix 系统，那么使用 Git Bash 可能更加方便。Git CMD 更接近于 Windows 环境，可以使用 Windows 命令和语法，如果你已经熟悉 Windows 系统，那么使用 Git CMD 可能更加方便。

  总的来说，选择使用 Git Bash 还是 Git CMD 取决于你的个人偏好和使用习惯。如果你已经熟悉 Unix 环境，那么使用 Git Bash 可能更容易上手；如果你已经熟悉 Windows 环境，那么使用 Git CMD 可能更容易上手。

- 不过,您不一定非要用这两个shell,它们都可以被其他shell代替,比如powershell或再posix 系统上的bash等shell

### 将git中bash添加windows terminal中运行

- [Adding Git-Bash to Windows Terminal | Tim Schaeps](https://www.timschaeps.be/post/adding-git-bash-to-windows-terminal/)

- 另外,如果您使用`windows terminal`这类终端管理程序,从当前shell启动`git-bash`会单独创建一个窗口
  - 而启动`git-cmd`则原地切换`git-cmd`环境
- 不过在git安装目录下,处理`git-bash.exe`还有一个目录`bin\`中存在一个`bash.exe`
  - 我们可以将`bin\bash.exe`添加到windows terminal中,并且不会单独弹出一个窗口

### bin/git.exe vs cmd/git.exe

- `bin/git.exe` 和 `cmd/git.exe` 都是 Git 命令行工具的可执行文件，但它们分别位于不同的目录中，且用途不同。
- `bin/git.exe` 是 Git 命令行工具的主要可执行文件，它包含了 Git 的核心功能，例如 Git 的基本命令、版本控制、分支管理、合并等等。这个可执行文件通常位于 Git 安装目录的 `bin` 子目录中。当你在 Git Bash 或者其他 Unix 环境下使用 Git 命令时，实际上就是在运行这个可执行文件。
- `cmd/git.exe` 是 Git 命令行工具的 Windows 版本可执行文件，它是为了在 Windows 命令提示符下使用 Git 命令而设计的。这个可执行文件通常位于 Git 安装目录的 `cmd` 子目录中。如果你在 Windows 系统下使用 Git 命令，则可能需要使用这个可执行文件。
- 总的来说，`bin/git.exe` 和 `cmd/git.exe` 是 Git 命令行工具的不同版本，它们分别用于不同的环境和操作系统。如果你在 Unix 环境下使用 Git 命令，则应该使用 `bin/git.exe`；如果你在 Windows 环境下使用 Git 命令，则应该使用 `cmd/git.exe`。不过，对于大多数用户来说，Git Bash 已经包含了 Git 的主要功能，因此不需要单独使用 `cmd/git.exe`。