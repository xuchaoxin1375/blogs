[toc]

## abstract

git@ssh和github@个人访问令牌@将本地仓库推送到github

## ref



- 有关身份验证的部分
  - [创建存储库 - GitHub 文档](https://docs.github.com/zh/get-started/quickstart/create-a-repo)
  - [身份验证 - GitHub 文档](https://docs.github.com/zh/authentication)
  - [关于 SSH - GitHub 文档](https://docs.github.com/zh/authentication/connecting-to-github-with-ssh/about-ssh)
- 这里主要讨论
  - [新增 SSH 密钥到 GitHub 帐户 - GitHub 文档](https://docs.github.com/zh/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)



## 使用ssh进行连接github

- 生成 SSH 密钥
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

### 本地生成ssh key👺

- [生成新的 SSH 密钥并将其添加到 ssh-agent - GitHub 文档](https://docs.github.com/zh/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

- 创建本地的SSH KEY(以便完成push)

- 在bash中输入: (把邮箱换成自己的邮箱)
	- `ssh-keygen -t rsa -C "youremail@example.com"`
	- 官方文档的做法是:`ssh-keygen -t ed25519 -C "your_email@example.com"`
	- 注意,`-C`是大写的(不是小写选项).
	
- 完成上述操作后,会生成一个隐藏目录.ssh

  - 默认会在用户家目录的`.ssh`目录下

  - ```bash
    PS> ls ~/.ssh/*pub
    
            Directory: C:\Users\cxxu\.ssh
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---          2024/7/9     21:20             99   id_ed25519.pub
    ```
    
  - 查看`id_*.pub`,例如`id_ed25519.pub`,也可以用更一般的语句查看` cat ~/.ssh/id_*.pub`
    
    ```powershell
    PS> cat ~/.ssh/id_*.pub
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAQy01dBJgEV4E5mJ4GBSZPAgI4nLIuIHXru2SowH8FR 8xxxx@qq.com
    ```
    

#### ssh-keygen

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

  


#### ssh-agent@SSH 密钥添加到 ssh-agent

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

- 文档:[新增 SSH 密钥到 GitHub 帐户 - GitHub 文档](https://docs.github.com/zh/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

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

##  Note 粘贴公钥而非私钥👺

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

## 访问令牌作为验证密码👺



- 在命令行上使用 HTTPS URL 将 `git clone`、`git fetch`、`git pull` 或 `git push` 执行到远程存储库时，Git 将要求你提供 GitHub **用户名和密码**。 
- 当 Git 提示你输入密码时，请输入你的personal access token。 或者，可以使用 [Git 凭据管理器](https://github.com/GitCredentialManager/git-credential-manager/blob/main/README.md)等凭据帮助程序。
- Git 的基于密码的身份验证已被删除，以支持更安全的身份验证方法。有关详细信息，请参阅“[管理个人访问令牌](https://docs.github.com/zh/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)”。

### Github设置

#### 使用GitHub账户的密码直接登录的方式已经被废弃

- ```bash
  Username for 'https://github.com': xuxxxxxx
  Password for 'https://xuxxxxxx@github.com':
  remote: Support for password authentication was removed on August 13, 2021.
  remote: Please see https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls for information on currently recommended modes of authentication.
  fatal: Authentication failed for 'https://github.com/xuxxxxxx/blogs.git/'
  ```

  

#### token令牌设置和获取👺

- token令牌设置和获取直达链接[Personal Access Tokens (Classic) (github.com)](https://github.com/settings/tokens)
- token样例:`ghp_oufguiiiulL3n2DvCDxtQmpnbqnbbqnbUAAbb`



### gitee 设置

- [SSH 公钥设置 | Gitee 产品文档](https://help.gitee.com/base/account/SSH公钥设置/)

- 直达连接:「[添加公钥](https://gitee.com/profile/sshkeys)」




