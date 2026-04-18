[toc]





# linux上的brew快速指南



## abstract

[macOS（或 Linux）缺失的软件包的管理器 — Homebrew](https://brew.sh/zh-cn/)

[Homebrew — The Missing Package Manager for macOS (or Linux)](https://brew.sh/)

[Homebrew on Linux — Homebrew Documentation](https://docs.brew.sh/Homebrew-on-Linux)

> 本文主要在网络较好的服务器行试验并记录(国外服务器),国内服务器可能需要解决额外的换源或网络问题
>
> 理想网络下安装brew的命令就1条,顶多注意使用非root用户(本文介绍快速创建非root用户以及安全防护的方案)以及shell配置文件中环境变量的添加

根据提供的 Homebrew on Linux 文档，以下是安装 Homebrew 的最佳实践：

1. **遵循官方推荐安装方式**：始终使用 Homebrew 官网首页提供的安装脚本来进行安装。这是获得最佳、受支持体验的唯一推荐方法。

2. **使用默认安装前缀**：安装脚本会将 Homebrew 安装到 `/home/linuxbrew/.linuxbrew` 目录（可能需要 `sudo` 权限）。**强烈建议不要更改此默认路径**。

    *   **原因**：使用默认前缀可以最大限度地利用预编译的二进制包（称为 "bottles"），这能显著加快安装速度并提高稳定性。
    *   **警告**：如果安装在其他位置（如个人家目录），绝大多数软件包都需要从源码编译，这会非常缓慢、耗能，且容易出错，官方对此不提供支持。在此情况下遇到问题，即使看似无关，提交的 Issue 也会被直接关闭。

3. **为无管理员权限的用户准备**：如果你没有管理员 (`sudo`) 权限，可以请求系统管理员创建一个名为 `linuxbrew` 的角色账户，并将其家目录设置为 `/home/linuxbrew`。这样你仍然可以受益于预编译的二进制包。

4. **安装系统依赖**：在运行 Homebrew 安装脚本前，确保系统已安装必要的构建工具。根据你的 Linux 发行版运行相应命令：
    *   **Debian 或 Ubuntu**: `sudo apt-get install build-essential procps curl file git`
    *   **Fedora**: `sudo dnf group install development-tools` 和 `sudo dnf install procps-ng curl file`
    *   **CentOS Stream 或 RHEL**: `sudo dnf group install 'Development Tools'` 和 `sudo dnf install procps-ng curl file`
    *   **Arch Linux**: `sudo pacman -S base-devel procps-ng curl file git`

5. **配置 Shell 环境**：安装完成后，**务必**按照安装脚本输出的 “Next steps” 指令，将 Homebrew 添加到你的 `PATH` 环境变量中。

    按照命令行(最新版请到brew首页查看)

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

    但是,更具体的,如果当前用户是root,运行上述命令会被拒绝安装(root下安装是高风险的)

    现在假设你创建了`linuxbrew`专用的非root用户来安全安装brew,则命令行可以具体为

    ```bash
     sudo -u linuxbrew /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

    这里使用` sudo -u linuxbrew`来指明使用非root用户linuxbrew来运行安装脚本

    结束后可以看看安装目录

    ```bash
    #( 09/14/25@10:48AM )( root@s2 ):~
       ls /home/linuxbrew/.linuxbrew
    bin  Caskroom  Cellar  etc  Frameworks  Homebrew  include  lib  opt  sbin  share  var
    ```

    通常需要将以下命令添加到你的 shell 配置文件（如 `~/.bashrc` 或 `~/.zshrc`）中：

    ```bash
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    ```
    然后重新加载配置文件（例如 `source ~/.bashrc`）或重启终端。

    

6. **验证安装**：完成上述步骤后，可以通过安装一个测试包来验证 Homebrew 是否正常工作：
    ```bash
    brew install hello
    ```
    首次在较旧的 Linux 发行版上安装软件包时，Homebrew 可能会自动为你安装新版的 `glibc` 和 `gcc`。

7. **使用 `brew doctor`**：如果遇到问题，运行 `brew doctor` 命令可以诊断并提示常见的配置问题。

8. **平台注意事项**：
    *   **ARM32 (如树莓派)**：可以运行，但属于 Tier 3 支持，因为没有预编译包，所有软件都需要从源码编译。可能需要自行通过系统包管理器或 `rbenv` 安装 Ruby。
    *   **32-bit x86**: **完全不支持**。
    *   **WSL 1**: 属于 Tier 3 支持，已知存在各种问题，**强烈建议升级到 WSL 2**。

**核心原则**：为了获得最佳体验，严格遵循官方默认设置，特别是安装路径。任何偏离都可能导致性能下降和失去官方支持。

## 创建linuxbrew用户🎈

```bash
username='linuxbrew' #根据需要更改要操作的用户名(homebrew,linuxbrew)
sudo useradd -m -s /bin/bash $username # 配置改用户默认使用bash
passwd $username
usermod -aG sudo $username

# 1. 创建一个包含新规则的临时文件
echo "$username ALL=(ALL) NOPASSWD: ALL" > /tmp/new_sudo_rule

# 2. 使用 visudo 验证临时文件的语法
if visudo -c -f /tmp/new_sudo_rule; then
    echo "语法正确，正在合并..."
    # 3. 将验证通过的规则追加到 /etc/sudoers.d/ 目录下的一个新文件中
    sudo install -m 440 /tmp/new_sudo_rule /etc/sudoers.d/alice_nopasswd
    echo "✅ 用户 alice 已被授予无密码 sudo 权限。"
else
    echo "❌ 语法错误！规则未被应用。"
    rm /tmp/new_sudo_rule
    exit 1
fi

# 4. 清理临时文件
rm /tmp/new_sudo_rule

```

### 安全性

为了提高安全性,如果使用`linuxbrew`这个用户名,可以禁止此专用用户(非普通用户使用的用户)的一些功能,比如禁止从远程登录(ssh)

> 如果是root用户,调用其他用户身份时不需要输入用户密码,这种情况下,安全起见,可以把linuxbrew密码设置的很复杂,因为不用输入密码就能借用身份,且root用户容易重置普通用户的密码,也不失方便.

或者取一个默认名以外的用户名比如不用`linuxbrew`而是用其他名字比如`bwuser`

#### 方案1

**修改用户的 shell 为 `/usr/sbin/nologin` 或 `/bin/false`**

这将阻止该用户通过 SSH 或任何交互式终端登录。这比较严格,可能会影响自己的使用,考虑方案2

#### 方案2

也可以仅从ssh上禁用特定用户的登录,即使用`DenyUsers <username>...`指令，可以指定1个或多个需要禁用ssh登录到用户名

> 注意添加到位置不是随意就可以,尤其是不能添加到任何Match块下方,放到其上方一般可以

```conf
DenyUsers linuxbrew
```

通常,sshd配置文件位于`/etc/ssh/sshd_config`

建议使用编辑器编辑(比如vim),比使用`echo `追加到尾部要更加可靠(而且直接追加还可能和已有的DenyUsers指令冲突,导致多次出现,配置不够集中和混乱)

```bash
#echo "DenyUsers linuxbrew" | sudo tee -a /etc/ssh/sshd_config #不建议使用此方案
sudo sed -i '/^#*Match /i\DenyUsers linuxbrew' /etc/ssh/sshd_config #如果确认原文件不存在DenyUsers语句,可以尝试此方案
sudo systemctl restart sshd

```

这会在配置文件中添加禁用`linuxbrew`的ssh登录的行到末尾,然后重启sshd服务

#### 配置效果检查

先尝试用`linuxbrew`角色登录,看是否出现`Permission denied, please try again.`的提示

如果是,则说明配置生效;

也可以观察ssh的日志

```bash
sudo tail -f /var/log/auth.log
```

然后重新尝试用`linuxbrew`登录,日志中会出现相关的登录尝试记录(这里可能包括一些肉机尝试爆破的登录尝试,我们主要关心被测试的用户名或者登录ip,ip可以通过[iP地址查询--手机号码查询归属地 | 邮政编码查询 | iP地址归属地查询 | 身份证号码验证在线查询网](https://www.ip138.com/)等网站查询)





## 工作目录问题

运行brew时,brew需要对当前工作目录具有读权限,如果惯用root用户的用户,需要注意当前目录的跳转

例如从root家目录切换用户时,使用`su - username`

```bash
Error: The current working directory must be readable to linuxbrew to run brew.
```

## 创建root用户可用的brew函数(bw)

由于brew的严格限制,对于习惯使用root的用户,可以通过以下函数调用来简化调用brew的过程

已ubuntu系统为例

其内部先切换当前工作目录到brew可用的目录,然后使用`sudo -u linuxbrew`借用非root用户`linuxbrew`(可能是你自定义的其他用户,这里使用本文默认创建的名字homebrew) 然后指定`brew`可执行文件(使用绝对路径会更加可靠,或者确保将brew添加到可以直接调用的目录中,比如`/usr/bin/brew`)

最后执行完毕后,会尝试回到原工作目录下

可以给函数取名为`bw`或其他名字

```bash
brew() {
    local ORIG_DIR="$PWD"
    echo "[INFO] Executing as user 'linuxbrew' in /home/linuxbrew: brew $*"
    cd /home/linuxbrew && sudo -u linuxbrew /home/linuxbrew/.linuxbrew/bin/brew "$@"
    local EXIT_CODE=$?
    cd "$ORIG_DIR" 2>/dev/null || echo "[WARN] Could not return to original directory: $ORIG_DIR"
    return $EXIT_CODE
}
```

```bash
>> ~/.zshrc << EOF
# brew command for root
brew() {
    local ORIG_DIR="$PWD"
    echo "[INFO] Executing as user 'linuxbrew' in /home/linuxbrew: brew $*"
    cd /home/linuxbrew && sudo -u linuxbrew /home/linuxbrew/.linuxbrew/bin/brew "$@"
    local EXIT_CODE=$?
    cd "$ORIG_DIR" 2>/dev/null || echo "[WARN] Could not return to original directory: $ORIG_DIR"
    return $EXIT_CODE
}

EOF
```

# 详解

---

##  安装前的准备（重要）

### 安装必要依赖

不同发行版需要安装不同的基础包：

#### Ubuntu / Debian：

```bash
sudo apt update
sudo apt install build-essential curl file git
```

#### CentOS / RHEL / Fedora：

```bash
# CentOS/RHEL 7/8/9
sudo yum groupinstall 'Development Tools'
sudo yum install curl file git

# 或者 Fedora / CentOS 8+ / RHEL 8+
sudo dnf groupinstall 'Development Tools'
sudo dnf install curl file git
```

> 💡 `build-essential` 或 `Development Tools` 提供了编译工具链（gcc、make 等），`curl` 和 `git` 是 brew 安装和更新所必需的。

---

##  官方推荐安装方式🎈



```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

> ⚠️ 注意：不要用 `sudo` 运行此脚本！Homebrew 设计为非 root 用户安装和使用。

---

##  安装后配置环境变量

安装脚本结束后，**终端会提示你需要手动添加环境变量**。请仔细阅读输出内容！



例如,brew安装引导会在最后提示你(专属当前运行环境(shell,常见的bash,zsh,...)的配置文件的编辑建议)

比如方面直接调用brew所需要的shell启动时自动加载的配置片段

```bash
echo >> /home/cxxu/.zshrc #不存在会创建空的同名文件,追加一个换行符
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/cxxu/.zshrc
#立刻激活当前shell环境
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

配套的提示内容参考

```bash
==> Next steps:
- Run these commands in your terminal to add Homebrew to your PATH:
    echo >> /home/cxxu/.zshrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/cxxu/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
- Install Homebrew's dependencies if you have sudo access:
    sudo apt-get install build-essential
  For more information, see:
    https://docs.brew.sh/Homebrew-on-Linux
- We recommend that you install GCC:
    brew install gcc
- Run brew help to get started
- Further documentation:
    https://docs.brew.sh
```

或手动添加(比如供其他用户使用)

> 本例中,我使用带有sudo权限的非root用户cxxu安装,安装位置是/home/linuxbrew

通常你需要将以下内容添加到你的 shell 配置文件中（如 `~/.bashrc`、`~/.zshrc`）：

先登录到指定用户shell会话,然后执行添加下面的语句

```bash
# 对于大多数 Linux 系统（x86_64）
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# 如果你安装在用户目录下（例如 ~/.linuxbrew），路径可能是：
# eval "$(/home/你的用户名/.linuxbrew/bin/brew shellenv)"
```

例如你使用bash和zsh,则:

```bash
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
#source ~/.bashrc 或 source ~/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

```

>  如果你用的是 `zsh`，请替换为 `~/.zshrc`



## brew shellenv

```bash
$ brew help  shellenv
Usage: brew shellenv [shell ...]

Valid shells: bash|csh|fish|pwsh|sh|tcsh|zsh

Print export statements. When run in a shell, this installation of Homebrew will
be added to your $PATH, $MANPATH, and $INFOPATH.

The variables $HOMEBREW_PREFIX, $HOMEBREW_CELLAR and $HOMEBREW_REPOSITORY
are also exported to avoid querying them multiple times. To help guarantee
idempotence, this command produces no output when Homebrew's bin and sbin
directories are first and second respectively in your $PATH. Consider adding
evaluation of this command's output to your dotfiles (e.g. ~/.bash_profile or
~/.zprofile on macOS and ~/.bashrc or ~/.zshrc on Linux) with e.g.:
  eval "$(brew shellenv zsh)" or eval "$(brew shellenv bash)"`

The shell should be specified explicitly with a supported shell name parameter
but will be detected automatically if not provided (but this may not be
correct). Unknown shells will output POSIX exports.

  -d, --debug                      Display any debugging information.
  -q, --quiet                      Make some output more quiet.
  -v, --verbose                    Make some output more verbose.
  -h, --help                       Show this message.
```

这段帮助文档是 Homebrew (Linuxbrew) 的核心配置说明。简单来说，`brew shellenv` 的作用是**生成一段能够让你的终端“认识” brew 命令的代码**。

------

### 1. 核心功能：环境变量初始化

当你运行 `brew shellenv` 时，它并不会改变任何系统设置，它只是在屏幕上**打印**出一系列 `export` 语句。

这些语句主要负责三件事：

- **修改 `$PATH`**：把 `brew` 的安装目录放到最前面，这样你输入 `brew` 或通过 brew 安装的软件（如 `node`, `python`）时，系统能找到它们。
- **设置帮助文档路径**：配置 `$MANPATH` 和 `$INFOPATH`，让你能用 `man brew` 查看文档。
- **定义内部变量**：设置 `$HOMEBREW_PREFIX`（安装根目录）等，减少后续运行时的查找开销，提高性能。

### 2. 关键特性：幂等性 (Idempotence)

文档中提到：

> "...this command produces no output when Homebrew's bin and sbin directories are first and second respectively in your $PATH."

**这意味着：** 如果你的环境变量已经配置好了，再次运行 `eval "$(brew shellenv)"` **不会有任何输出**。

- **好处：** 即使你在 `.zshrc` 里写了这行代码，你多次打开新的终端窗口，它也不会重复把路径堆叠在 `$PATH` 里，保证了配置的干净。

### 3. 参数详解：Shell 类型

```bash
Valid shells: bash|csh|fish|pwsh|sh|tcsh|zsh
```

- 不同的 Shell 语法不同（比如 `bash/zsh` 使用 `export`，而 `csh` 使用 `setenv`）。
- **建议：** 虽然它**可以自动检测**(不指定具体shell类型时自动检测,可能会出错)，所以最好显式指定，例如 `brew shellenv zsh`，这样更稳定。

内容参考(以`brew shellenv bash`为例)

```bash
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}";
```



### 4. 为什么必须使用 `eval`？

这是最让新手困惑的地方。为什么不是直接运行 `brew shellenv`？

- **直接运行：** 仅仅是在屏幕上显示一堆字符，对当前终端环境没有任何影响。
- **`eval "$(...)"`：** 这是一个组合拳。
  1. `$(...)` 先执行括号里的命令，拿到那一堆 `export` 代码。
  2. `eval` 将拿到的代码**当做真实的指令**在当前 Shell 中执行一遍。

------

### 总结：配置的最佳实践

根据文档建议，最标准、最稳健的 `.zshrc`(`.bashrc`) 修复方式是：

```bash
# 在 .zshrc 末尾添加这一行
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
# 如果是bash,将命令中的zsh替换为bash
```

**为什么用绝对路径？**

因为在执行这行代码之前，系统还没把 brew 加入 `PATH`，直接写 `brew` 系统会报错“command not found”。使用 `/home/linuxbrew/.linuxbrew/bin/brew` 这种完整路径可以确保万无一失。



---

##  验证安装

```bash
brew --version
```

如果输出版本号（如 `Homebrew x.x.x`），说明安装成功。

---

## 其他

###  安装路径

- 默认安装在 `/home/linuxbrew/.linuxbrew`（如果 `/home/linuxbrew` 不存在且你有 sudo 权限）
- 否则安装在 `~/.linuxbrew`

> 如果你想自定义安装路径，可以在运行安装脚本前设置环境变量：
> ```bash
> export HOMEBREW_PREFIX="/your/custom/path"
> ```



### 设置国内镜像源（可选，加速下载）

#### 中科大源

```bash
# 设置 brew 仓库源
git -C "$(brew --repo)" remote set-url origin https://mirrors.ustc.edu.cn/brew.git

# 设置 core 核心仓库
git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git

# 如果使用 bottles（预编译包）;将配置写入到shell(比如~/.bashrc)
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.bashrc
source ~/.bashrc

# 更新生效
brew update
```

> 🇨🇳 国内用户强烈建议设置镜像，否则从 GitHub 下载可能极慢或失败。

#### 清华源

[homebrew | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/)

注意文档中分为3个部分,三个小节适用于不同的情况

---

## 卸载 Homebrew

如果你需要卸载：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

然后手动删除环境变量配置。

---

## FAQ常见问题解决

###  `brew command not found`

- 检查是否添加了 `eval "$(...)"` 到 shell 配置文件
- 执行 `source ~/.bashrc`（或对应 shell 文件）
- 重启终端
- 尝试绝对路径访问`brew`

###  安装时提示权限错误

- 确保没有用 `sudo`
- 检查 `/home/linuxbrew/.linuxbrew` 或 `~/.linuxbrew` 是否属于当前用户

### 编译失败或缺少依赖

- 确保已安装 `build-essential` / `Development Tools`
- 运行 `brew doctor` 诊断问题

### brew安装目录因权限错乱拒绝运行

如果是root用户或者是sudo使用不当,可能导致brew目录权限不符合默认的安全检查;

> 通常是写权限(w)被滥用;

> 对于zsh的一些命令补全框架可能会检查加载的代码权限

例如:`Insecure completion-dependent directories detected:`

```bash
[oh-my-zsh] Insecure completion-dependent directories detected:
drwxr-xr-x 3 linuxbrew linuxbrew 4096 Sep 14  2025 /home/linuxbrew/.linuxbrew/share/zsh
drwxr-xr-x 2 linuxbrew linuxbrew 4096 Apr 17 16:52 /home/linuxbrew/.linuxbrew/share/zsh/site-functions
lrwxrwxrwx 1 linuxbrew linuxbrew   39 Sep 14  2025 /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_brew -> ../../../Homebrew/completions/zsh/_brew
lrwxrwxrwx 1 linuxbrew linuxbrew   58 Apr 17 16:52 /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_curl -> ../../../Cellar/curl/8.19.0/share/zsh/site-functions/_curl
lrwxrwxrwx 1 linuxbrew linuxbrew   54 Sep 14  2025 /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_fd -> ../../../Cellar/fd/10.3.0/share/zsh/site-functions/_fd
lrwxrwxrwx 1 linuxbrew linuxbrew   59 Sep 14  2025 /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_rg -> ../../../Cellar/ripgrep/14.1.1/share/zsh/site-functions/_rg

[oh-my-zsh] For safety, we will not load completions from these directories until
[oh-my-zsh] you fix their permissions and ownership and restart zsh.
[oh-my-zsh] See the above list for directories with group or other writability.



```

检查权限:借助`compaudit`和`xargs`,使用`ls -ld`查看相关目录的权限位.

```bash
compaudit|xargs ls -ld
There are insecure directories and files:
drwxr-xr-x 3 linuxbrew linuxbrew 4096 Sep 14  2025 /home/linuxbrew/.linuxbrew/share/zsh
drwxr-xr-x 2 linuxbrew linuxbrew 4096 Apr 17 16:52 /home/linuxbrew/.linuxbrew/share/zsh/site-functions
lrwxrwxrwx 1 linuxbrew linuxbrew   39 Sep 14  2025 /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_brew -> ../../../Homebrew/completions/zsh/_brew
lrwxrwxrwx 1 linuxbrew linuxbrew   58 Apr 17 16:52 /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_curl -> ../../../Cellar/curl/8.19.0/share/zsh/site-functions/_curl
lrwxrwxrwx 1 linuxbrew linuxbrew   54 Sep 14  2025 /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_fd -> ../../../Cellar/fd/10.3.0/share/zsh/site-functions/_fd
lrwxrwxrwx 1 linuxbrew linuxbrew   59 Sep 14  2025 /home/linuxbrew/.linuxbrew/share/zsh/site-functions/_rg -> ../../../Cellar/ripgrep/14.1.1/share/zsh/site-functions/_rg
```



- 警告处理`compaudit | xargs chmod g-w,o-w`,可以在末尾使用`--verbose`查看变更详情;
- 如果仍然无效,可以考虑设置环境变量`ZSH_DISABLE_COMPFIX=true`,禁用补全代码的检查(如果是写入配置文件中,此变量赋值语句的位置可能需要靠前(早于compaudit执行之前),否则可能无效!).

> 对于root用户,如果引入了linuxbrew目录相关代码,引发上述警告通常是因为相关代码的所有者混乱,普通的权限修改后可能会又被改回去;
>
> 可以考虑直接设置环境变量

```bash
[oh-my-zsh] To fix your permissions you can do so by disabling
[oh-my-zsh] the write permission of "group" and "others" and making sure that the
[oh-my-zsh] owner of these directories is either root or your current user.
[oh-my-zsh] The following command may help:
[oh-my-zsh]     compaudit | xargs chmod g-w,o-w

[oh-my-zsh] If the above didn't help or you want to skip the verification of
[oh-my-zsh] insecure directories you can set the variable ZSH_DISABLE_COMPFIX to
[oh-my-zsh] "true" before oh-my-zsh is sourced in your zshrc file.
```

