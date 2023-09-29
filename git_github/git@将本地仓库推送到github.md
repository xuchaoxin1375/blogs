[toc]

## ref

- [GitHub Docs|ZH](https://docs.github.com/zh)@[GitHub Docs|EN](https://docs.github.com/en)
  - [GitHub 入门文档 - GitHub 文档](https://docs.github.com/zh/get-started)
  - [使用Git | GitHub 文档](https://docs.github.com/zh/get-started/getting-started-with-git/setting-your-username-in-git)
  - [关于 Git - GitHub 文档](https://docs.github.com/zh/get-started/using-git/about-git)
- 有关身份验证的部分
  - [创建存储库 - GitHub 文档](https://docs.github.com/zh/get-started/quickstart/create-a-repo)
  - [身份验证 - GitHub 文档](https://docs.github.com/zh/authentication)
  - [关于 SSH - GitHub 文档](https://docs.github.com/zh/authentication/connecting-to-github-with-ssh/about-ssh)
- 这里主要讨论
  - [新增 SSH 密钥到 GitHub 帐户 - GitHub 文档](https://docs.github.com/zh/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

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

## 初始化本地目录为可管理仓库

1. 首先需要一个能够被github管理的本地文件夹(用git bash进入到一个普通的文件夹,使用git init命令即可(特征是会生成.git(用
   ls -ah 可以看到)

2. (根据自己本地的情况,仓库中(待被推到github上的目录里)运行:

   - ```bash
     git add .
     git commit -m "your comments (if you need) "
     ```


## 使用ssh进行连接

- 生成新的 SSH 密钥
- 其添加到 ssh-agent

###  ssh密钥是什么?

- 可以使用 SSH（安全外壳协议）访问和写入 GitHub.com 上的存储库中的数据。 通过 SSH 进行连接时，使用本地计算机上的私钥文件进行身份验证。 有关详细信息，请参阅“[关于 SSH](https://docs.github.com/zh/authentication/connecting-to-github-with-ssh/about-ssh)”。

- 生成 SSH 密钥时，可以添加密码以进一步保护密钥。 每当使用密钥时，都必须输入密码。 

- **<u>如果密钥具有密码并且你不想每次使用密钥时都输入密码，则可以将密钥添加到 SSH 代理。</u>** 

- SSH 代理会管理 SSH 密钥并记住你的密码。

- 如果您还没有 SSH 密钥，则必须生成新 SSH 密钥用于身份验证。 如果不确定是否已经拥有 SSH 密钥，您可以检查现有密钥。 有关详细信息，请参阅“[检查现有 SSH 密钥](https://docs.github.com/zh/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys)”。

  如果要使用硬件安全密钥向 GitHub 验证，则必须为硬件安全密钥生成新的 SSH 密钥。 使用密钥对进行身份验证时，您必须将硬件安全密钥连接到计算机。 有关详细信息，请参阅 [OpenSSH 发行说明](https://www.openssh.com/txt/release-8.2)。

#### rsa

- RSA 是一种非对称加密算法，它的名称来自于它的发明者：Ron Rivest、Adi Shamir 和 Leonard Adleman。RSA 算法是一种公钥密码算法，它使用两个密钥，一个公钥和一个私钥，来加密和解密数据。

- 在 RSA 算法中，公钥用于加密数据，私钥用于解密数据。公钥可以自由地向他人公开，而私钥需要妥善保管。发送方使用接收方的公钥来加密数据，接收方使用自己的私钥来解密数据。由于只有接收方拥有私钥，因此只有接收方能够解密数据，保证了数据的安全性。
- RSA 算法基于数学原理，它的安全性建立在大数分解的困难性上。具体来说，RSA 算法通过选择两个大质数和一些其他参数来生成公钥和私钥，使得分解公钥中的大数因数成为一项困难的数学问题。因此，只有私钥的持有者才能够有效地解密数据，保证了 RSA 算法的安全性。
- RSA 算法被广泛应用于数字证书、数字签名、加密通信等领域，是一种非常重要的加密算法。

#### id_rsa @ id_rsa.pub

- `id_rsa` 和 `id_rsa.pub` 是 SSH 密钥对中的两个文件，分别用于存储私钥和公钥。
- `id_rsa` 是 SSH 密钥对中的私钥文件，用于身份验证和加密通信。私钥是一种保密的密钥，只有持有者才能访问它。在 SSH 协议中，私钥用于生成数字签名，以便在身份验证和数据传输过程中验证身份和保护数据的安全性。在 SSH 连接时，客户端会使用私钥对消息进行签名，而服务器会使用公钥来验证签名。因此，私钥需要妥善保管，不要泄露给他人。
- `id_rsa.pub` 是 SSH 密钥对中的公钥文件，用于在 SSH 连接时进行身份验证和加密通信。公钥是一种公开的密钥，可以自由地向他人公开。在 SSH 协议中，公钥用于验证身份和加密数据。在 SSH 连接时，客户端会向服务器发送公钥，服务器会使用公钥验证客户端的身份，并使用公钥加密数据，以便只有客户端能够解密数据。因此，公钥可以自由地向他人公开，而私钥需要妥善保管。
- 通常情况下，`id_rsa` 和 `id_rsa.pub` 文件会放在用户的 `~/.ssh/` 目录下，这是 SSH 默认的密钥对存放路径。在使用 SSH 进行身份验证或加密通信时，客户端会自动查找 `~/.ssh/` 目录下的密钥对文件。如果你需要使用其他的密钥对文件，可以在 SSH 客户端配置中指定密钥对文件的路径。

### 本地生成ssh key

- [生成新的 SSH 密钥并将其添加到 ssh-agent - GitHub 文档](https://docs.github.com/zh/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

- 创建本地的SSH KEY(以便完成push)

- 在bash中输入: 
	- `ssh-keygen -t rsa -C "youremail@example.com"`
	- 官方文档的做法是`ssh-keygen -t ed25519 -C "your_email@example.com"`
	- 注意,`-C`是大写的(不是小写选项).
	
- 完成上述操作后,会生成一个隐藏目录.ssh

  - 默认会在用户家目录的`.ssh`目录下

  - ```bash
    #这使用powershell查看
    #也可以用其他shell查看,例如git-bash或git-cmd查看
    
    PS C:\Users\cxxu> ls -l $ssh_home
    
            Directory: C:\Users\cxxu\.ssh
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         3/24/2023  11:20 AM           2602   id_rsa
    -a---         3/24/2023  11:20 AM            568   id_rsa.pub
    -a---         3/24/2023  12:36 PM           1204   known_hosts
    ```

  - 查看id_rsa.pub
    
    ```bash
    cat ~/.ssh/id_rsa.pub
    ```
    

### ssh-keygen

- [ssh-keygen - Wikipedia](https://en.wikipedia.org/wiki/Ssh-keygen)
- [ssh-keygen(1) - OpenBSD manual pages](https://man.openbsd.org/ssh-keygen.1)

- ```bash
  PS D:\repos\CCSER\SER> ssh-keygen --help
  unknown option -- -
  usage: ssh-keygen [-q] [-a rounds] [-b bits] [-C comment] [-f output_keyfile]
                    [-m format] [-N new_passphrase] [-O option]
                    [-t dsa | ecdsa | ecdsa-sk | ed25519 | ed25519-sk | rsa]
                    [-w provider] [-Z cipher]
         ssh-keygen -p [-a rounds] [-f keyfile] [-m format] [-N new_passphrase]
                     [-P old_passphrase] [-Z cipher]
         ssh-keygen -i [-f input_keyfile] [-m key_format]
   ...
         ssh-keygen -Y check-novalidate -n namespace -s signature_file
         ssh-keygen -Y sign -f key_file -n namespace file ...
         ssh-keygen -Y verify -f allowed_signers_file -I signer_identity
                    -n namespace -s signature_file [-r revocation_file]
  ```

  


### ssh-agent@SSH 密钥添加到 ssh-agent

- [ SSH 密钥添加到 ssh-agent - GitHub 文档](https://docs.github.com/zh/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent)

- 将 SSH 密钥添加到 ssh-agent 可以帮助你更方便地使用 SSH 密钥进行身份验证，而不需要每次都输入 SSH 密钥的密码。以下是将 SSH 密钥添加到 ssh-agent 的步骤：

  1. 打开终端（Linux 或 macOS）或 Git Bash（Windows）。

  2. 检查 ssh-agent 是否正在运行。在终端中输入以下命令：

     ```
     eval "$(ssh-agent -s)"
     如果 ssh-agent 没有运行，则会启动 ssh-agent，并输出 ssh-agent 的进程 ID。
     ```

  3. 将 SSH 密钥添加到 ssh-agent 中。在终端中输入以下命令：

     ```
     ssh-add /path/to/private/key
     ```

     - 其中，`/path/to/private/key` 是你的 SSH 私钥文件的路径。如果你的 SSH 私钥文件不在默认的路径（例如 `~/.ssh/id_rsa`），则需要将路径替换为你的 SSH 私钥文件的实际路径。

  4. 输入 SSH 密钥的密码，使其被添加到 ssh-agent 中。

- 现在，你的 SSH 密钥已经被添加到 ssh-agent 中。下次使用 SSH 进行身份验证时，ssh-agent 将会自动使用你的 SSH 密钥，而不需要你再次输入密码。如果你想要删除已经添加到 ssh-agent 中的 SSH 密钥，可以使用以下命令：

  ```
  ssh-add -d /path/to/private/key
  ```

  其中，`/path/to/private/key` 是你想要删除的 SSH 私钥文件的路径。

  注意，如果你使用的是 Windows，需要在 Git Bash 中执行以上步骤，而不是在 Windows 命令提示符或 PowerShell 中执行。

###  关联到云端

- [新增 SSH 密钥到 GitHub 帐户 - GitHub 文档](https://docs.github.com/zh/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

- 直达连接,设置您的github [SSH and GPG keys (github.com)](https://github.com/settings/keys)

### GPG vs SSH

- GPG（GNU Privacy Guard）是一个开源的加密软件，可以用于加密、签名和验证文件、电子邮件和其他数据。GPG 使用公钥加密和私钥解密的方式来保护数据的安全性，可以用于保护个人隐私、保护敏感数据等。
- 与 GPG 不同，SSH（Secure Shell）是一种网络协议，用于在网络上安全地远程登录到另一台计算机。SSH 使用公钥加密和私钥解密的方式来保护登录过程的安全性，可以用于远程管理、文件传输等。
- 虽然 GPG 和 SSH 都使用公钥加密和私钥解密的方式来保护数据的安全性，但它们的使用场景和目的有所不同。GPG 主要用于加密、签名和验证文件、电子邮件和其他数据，可以用于保护个人隐私、保护敏感数据等；而 SSH 主要用于远程登录和管理计算机，可以用于远程管理、文件传输等。
- 总的来说，GPG 和 SSH 都是保护数据安全性的工具，但它们的使用场景和目的有所不同，需要根据具体情况来选择使用哪种工具。



- 在 GitHub 中，SSH 和 GPG keys 是用于身份验证和安全性的重要工具，它们可以帮助你更安全地访问和管理你的 GitHub 账户和仓库。
- SSH keys 是一种用于通过 SSH 协议进行身份验证的加密密钥对。在 GitHub 上，你可以将你的公钥添加到你的账户中，这样就可以使用私钥来进行身份验证，使你能够更加安全地访问和管理你的 GitHub 仓库。要添加 SSH key，你需要生成一个密钥对，并将公钥添加到你的 GitHub 账户中。你可以在 GitHub 的设置页面中找到 SSH key 的选项。
- GPG keys 是一种用于加密、签名和验证数据的密钥对。在 GitHub 上，你可以将你的公钥添加到你的账户中，这样就可以使用私钥来加密、签名和验证提交的代码、合并请求等数据，使你的代码更加安全可靠。要添加 GPG key，你需要生成一个密钥对，并将公钥添加到你的 GitHub 账户中。你可以在 GitHub 的设置页面中找到 GPG key 的选项。
- 总的来说，SSH 和 GPG keys 都是非常重要的安全工具，可以帮助你更加安全地访问和管理你的 GitHub 账户和仓库。为了保护你的账户和代码的安全性，建议你在使用 GitHub 时添加 SSH 和 GPG keys。

##  粘贴公钥而非私钥👺

- 将ssh key粘贴到githus上的时候,不要把`私钥`张贴进去,而是`公钥`要粘贴进去
- 粘贴你的SSH公钥，通常包含在文件'~/.ssh/id_ed25519.pub'或'~/.ssh/id_rsa.pub' 中，并以“ssh-ed25519”或“ssh-rsa”开头。不要粘贴你的SSH私钥，因为这会泄漏你的身份信息。
- `私钥`的可能格式

  - ```bash
    PS C:\Users\cxxu\.ssh> cat .\id_rsa|select -First 2
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAA...BG5vbmUAAAAE
    ...
    awp63y2eFXbfsjAA...mN4eHVAQ3h4dVdpbjExAQIDBA==
    -----END OPENSSH PRIVATE KEY-----
    -----
    ```


  - 在powershell中,可以使用`cat ~/.ssh/id*pub|scb`直接将公钥内容复制到剪切板上

## 访问令牌作为验证密码



- 在命令行上使用 HTTPS URL 将 `git clone`、`git fetch`、`git pull` 或 `git push` 执行到远程存储库时，Git 将要求你提供 GitHub **用户名和密码**。 
- 当 Git 提示你输入密码时，请输入你的personal access token。 或者，可以使用 [Git 凭据管理器](https://github.com/GitCredentialManager/git-credential-manager/blob/main/README.md)等凭据帮助程序。
- Git 的基于密码的身份验证已被删除，以支持更安全的身份验证方法。有关详细信息，请参阅“[管理个人访问令牌](https://docs.github.com/zh/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)”。

## 本地的repository 首次推到github上
- 在Github上手动创建好一个1个与本地Git仓库对应的仓库之后,我们就可以和本地仓库进行关联了
- 根据创建好的Git仓库页面的提示，可以在本地输入:(形如)
- **push an existing repository from the command line:**
  - `git remote add origin https://github.com/xuchaoxin1375/learnGit.git`
  - `git branch -M main`(main一般默认为master,该部操作之前应当add,并且commit成功才行否则报错refname的错误)

- 另外链接的形式:形如
  - `git@github.com:xuchaoxin1375/linerAlgebra.git)`
  - `git push -u origin main(main根据自身情况,可能要改为master)`
  - 如果之前操作失误导致origin再次建立报错也没事,后面两条命令继续执行


- 推送完成后,刷新github界面



###  关于重复验证的问题:

- [git_避免重复验证/反复输入密码/免密push(通过https方式push到github)](https://blog.csdn.net/xuchaoxin1375/article/details/115600374)关于获取某个github仓库的https链接

##  可能遇到的问题@首次推送冲突

- 值得注意的是，如果我们在github端中新建repository时用默认分支（现在默认为main分支），如果从本地push 到云端时也指定为main分支（git push origin main),那么可能冲突
- 这主要是由于在创建新的github仓库是添加了`readme.md`等文件所造成



### 解决办法

- 可以用--allow-unrelated-histories选型进行pull
  - `git pull origin main --allow-unrelated-histories`
- 可以考虑在push的时候换一个分支名
- 也可以在github端将默认分支删除，然后再push
- 也可以将github端的分支内容fetch到本地，手动整合后重新push



## 使用wsl linux的Notice

- 如果ssh key 是windows 端上生成的, 那么子系统linux是无法直接利用这个身份
- 就是说,无法直接push ,需要在子系统中再操作一遍



​	