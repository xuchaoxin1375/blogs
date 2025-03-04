[toc]

## abstract

针对 Windows 用户，以下是一个完整的 SSH 免密推送 GitHub 的教程，涵盖从安装工具到推送代码的每一步。

### 说明

安装相关软件(git,ssh)步骤上简单,但是下载速度上可能比较慢,您可以从国内软件镜像加速下载

或者使用Scoop(国内加速版)来快速安装相关软件



### 第一步：安装 Git 和 SSH 工具

- 安装 Git for Windows  
   Windows 用户需要安装 Git 来使用 Git 命令行工具。可以从 [Git 官网](https://git-scm.com/download/win) 下载 Git for Windows，并进行安装。

   - 在安装过程中，可以选择 "Use Git from Git Bash only" 选项，方便以后通过 Git Bash 使用 Git。


   - 打开 Git Bash  :安装完成后，点击 **开始菜单**，搜索 "Git Bash"，并启动它。Git Bash 是一个命令行终端，包含了 Git 和 SSH 所需的工具。


#### 补充说明

- ssh工具:win10以上的系统自带ssh客户端相关工具,当然,您也可以选择scoop下载win32 ssh

- 事实上还有整合包可以选,在scoop中查询:

  - ```powershell
    PS> scoop-search openssh
    'aki' bucket:
        win32-openssh (9.5.0.0p1-Beta)
    
    'main' bucket:
        git-with-openssh (2.46.0.windows.1)
        mls-software-openssh (9.8p1-1)
        openssh (9.5.0.0p1)
    
    'scoop-cn' bucket:
        git-with-openssh (2.46.0.windows.1)
        git-without-openssh (2.46.0.windows.1)
        mls-software-openssh (9.8p1-1)
        openssh (9.5.0.0p1)
        openssh-msys (8.8p1-1)
    
    'spc' bucket:
        git-with-openssh (2.46.0.windows.1)
        git-without-openssh (2.46.0.windows.1)
        mls-software-openssh (9.8p1-1)
        openssh (9.5.0.0p1)
        openssh-msys (8.8p1-1)
        win32-openssh (9.5.0.0p1-Beta)
    
    'versions' bucket:
        git-without-openssh (2.46.0.windows.1)
        openssh-msys (8.8p1-1)
    
    ```

    


### 第二步：生成 SSH 密钥

SSH 密钥是一对公钥和私钥。你将私钥保存在本地，将公钥上传到 GitHub，推送代码时无需输入密码。

1. 在 Git Bash 中输入以下命令，开始生成 SSH 密钥：
   
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
   - `-t ed25519`：指定生成 `ed25519` 算法的密钥，这是比较新的、推荐的算法。
   - `-C "your_email@example.com"`：是用于标记此 SSH 密钥的注释，通常用你的 GitHub 注册邮箱。

   如果使用旧版本 Git Bash 不支持 `ed25519`，可以改用 RSA 算法：
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```

2. 接下来，系统会提示你选择保存密钥的位置，默认路径为：
   ```bash
   C:\Users\<your-username>\.ssh\id_ed25519
   ```
   按 **Enter** 键选择默认路径即可。

3. 系统会询问是否为密钥设置密码（passphrase）。如果你不想在每次使用 SSH 时都输入密码，可以直接按 Enter 跳过。

### 第三步：将 SSH 私钥添加到 SSH 代理

SSH 代理可以帮助你管理多个 SSH 私钥，避免每次都需要手动输入私钥密码。

#### git bash中操作

1. 在 Git Bash 中，启动 SSH 代理：
   
   ```bash
   eval "$(ssh-agent -s)"
   ```
   你将看到类似以下的输出，表示 SSH 代理已经运行：
   ```bash
   Agent pid 59566
   ```

2. 添加你的 SSH 私钥到 SSH 代理：
   ```bash
   ssh-add ~/.ssh/id_ed25519
   ```
   如果你使用的是 RSA 算法，命令为：
   ```bash
   ssh-add ~/.ssh/id_rsa
   ```

#### windows的shell命令行中操作

例如,您可以在powershell中执行相应的操作,详解参考后面的拓展章节



###  第四步：将 SSH 公钥添加到 GitHub

1. **复制公钥内容**  
   
   现在你需要将生成的 SSH 公钥复制到剪贴板。执行以下命令：
   
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
   如果你使用 RSA，则命令为：
   ```bash
   cat ~/.ssh/id_rsa.pub
   ```
   
   这会在终端中显示公钥内容，右键点击 Git Bash 窗口，选择 **Mark** 以标记并复制公钥。
   
2. **登录 GitHub 并添加公钥**  
   - 打开 [GitHub](https://github.com)，登录你的账户。
   - 点击右上角的头像，选择 **Settings**。
   - 在左侧菜单中找到 **SSH and GPG keys**，点击 **New SSH key**。
   - 在 **Title** 中输入一个名字（如 "My Laptop SSH Key"），然后将之前复制的公钥粘贴到 **Key** 框中。
   - 点击 **Add SSH key**。

### 第五步：配置仓库使用 SSH URL

1. **进入 Git 项目目录**  
   在 Git Bash 中，使用 `cd` 命令进入你要推送的 Git 项目目录：

   ```bash
   cd /path/to/your/repository
   ```

2. **修改远程仓库的 URL**  
   确保你使用的是 SSH URL 而不是 HTTPS URL。执行以下命令，查看当前的远程仓库 URL：

   ```bash
   git remote -v
   ```

   如果显示的 URL 是类似 `https://github.com/username/repo.git` 的 HTTPS 格式，**需要修改为 SSH 格式**：

   ```bash
   git remote set-url origin git@github.com:username/repo.git
   ```

   `username` 替换为你的 GitHub 用户名，`repo` 替换为仓库名。

### 第六步：测试 SSH 连接

为了确保 SSH 连接配置正确，可以运行以下命令测试与 GitHub 的连接

```bash
ssh -T git@github.com
```

如果一切正常，你会看到类似下面的信息：
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

如果遇到错误，可以检查 SSH 密钥是否正确添加到 GitHub，或者确保 `ssh-agent` 正在运行。

### 第七步：推送代码到 GitHub

现在你可以使用 Git SSH 免密推送代码了。比如，在完成代码提交后，运行以下命令：

```bash
git push origin main
```

### 常见问题

1. **如果提示 `git@github.com: Permission denied (publickey)`？**
   - 检查 SSH 公钥是否正确添加到 GitHub。
   - 检查 `ssh-agent` 是否正在运行并且已加载了正确的私钥。

2. **如何管理多个 SSH 密钥？**
   如果你需要为不同的服务（如 GitHub、GitLab 等）使用多个 SSH 密钥，可以通过修改 `~/.ssh/config` 文件来管理。例如：
   ```bash
   Host github.com
     HostName github.com
     User git
     IdentityFile ~/.ssh/id_ed25519_github
   
   Host gitlab.com
     HostName gitlab.com
     User git
     IdentityFile ~/.ssh/id_ed25519_gitlab
   ```

### 总结

通过上述步骤，Windows 用户可以成功使用 SSH 实现免密推送代码到 GitHub。主要步骤包括生成 SSH 密钥、将公钥添加到 GitHub、配置 Git 使用 SSH URL，并测试连接。

## powershell中设置ssh-agent

在 Windows 上，你可以使用 PowerShell 实现将 SSH 私钥添加到 `ssh-agent`。

这是完整的步骤：

### 第一步：启动 `ssh-agent`

1. **启动 PowerShell 作为管理员**  
   按 `Win + X` 打开菜单，选择 **Windows PowerShell (Admin)** 或 **Windows Terminal (Admin)**。

2. **确保 `ssh-agent` 已启动**  

   推荐设置:

   ```powershell
   set-service -Name ssh-agent -StartupType Automatic
   ```

   从powershell中启动被停止的服务有时候会遇到失败,这种情况下你可以尝试用`services.msc`设置,或者利用上面的powershell语句将启动类型设置为自动(automatic)或者手动(manual),已知前者成功率高,后者不确定

   

   使用以下命令启动 `ssh-agent` 服务：

   ```powershell
   Start-Service ssh-agent
   ```

3. **检查 `ssh-agent` 服务的状态**  
   确认 `ssh-agent` 是否已经运行：
   ```powershell
   Get-Service ssh-agent
   ```
   如果状态显示为 `Running`，则表示服务正常运行。如果服务未运行，请重新检查步骤或设置启动类型为手动或自动启动。

### 第二步：将 SSH 私钥添加到 `ssh-agent`

1. **将 SSH 私钥添加到 `ssh-agent`**
   使用 `ssh-add` 命令来将你的私钥添加到 `ssh-agent`。通常，默认的 SSH 私钥存放在 `C:\Users\<your-username>\.ssh\` 目录中。

   ```powershell
   ssh-add $HOME\.ssh\id_ed25519
   ```
   或者如果你使用 RSA 密钥，则使用：
   ```powershell
   ssh-add $HOME\.ssh\id_rsa
   ```

   如果你的 SSH 密钥存储在其他位置，替换路径即可。

2. **查看已经添加的密钥**  
   你可以使用以下命令来查看当前已经添加到 `ssh-agent` 的密钥列表：
   ```powershell
   ssh-add -l
   ```

   如果密钥成功添加，你将看到指纹信息。

### 自动添加私钥到ssh代理

- 如果你每次启动 PowerShell 都希望自动启动 `ssh-agent` 并添加 SSH 私钥，可以将这些命令放入你的 PowerShell 配置文件（通常是 `$PROFILE`）中，确保每次启动 PowerShell 时都自动执行。

  将以下命令添加到 `$PROFILE`：
  ```powershell
  Start-Service ssh-agent
  ssh-add $HOME\.ssh\id_ed25519
  ```

### 小结

使用 PowerShell 将 SSH 私钥添加到 `ssh-agent` 包括启动服务和使用 `ssh-add` 命令加载密钥。如果需要进一步自动化，也可以将这些命令集成到 PowerShell 配置文件中。

 

## 补充:ssh-agent的简单介绍



### 1. `ssh-agent` 的用途

| 用途           | 说明                                                        |
| -------------- | ----------------------------------------------------------- |
| 管理 SSH 私钥  | 通过内存管理 SSH 私钥，提供自动认证，无需每次手动输入密钥。 |
| 自动化身份验证 | 当需要 SSH 身份验证时，`ssh-agent` 自动提供对应私钥。       |
| 多密钥支持     | 支持管理多个 SSH 密钥，自动选择合适的密钥进行身份验证。     |

### 2. `ssh-agent` 的好处

| 好处             | 详细说明                                                     |
| ---------------- | ------------------------------------------------------------ |
| 提高安全性       | SSH 私钥仅在内存中存储，减少暴露的风险；同时可以避免在每次使用时输入密码。 |
| 简化身份验证流程 | 一次加载私钥后，`ssh-agent` 会自动处理所有后续的 SSH 认证，避免重复输入密码。 |
| 管理多个私钥     | 允许同时管理多个 SSH 私钥并自动选择合适的密钥，避免用户手动指定。 |
| 减少用户错误     | 避免频繁输入密码和密钥路径，减少由于人为操作带来的错误。     |
| 跨平台兼容性     | 支持 Windows、macOS 和 Linux 等多种操作系统，方便不同平台的用户使用。 |

### 3. 常见使用场景

| 使用场景       | 具体应用说明                                                 |
| -------------- | ------------------------------------------------------------ |
| Git 推送操作   | 用户通过 SSH 推送代码到 GitHub 或 GitLab 时，免去每次输入密码的麻烦，提升开发效率。 |
| 远程服务器管理 | 管理多个服务器时，`ssh-agent` 可以加载多个密钥，自动处理与不同服务器的认证。 |
| 自动化脚本     | 在自动化脚本中，避免每次连接服务器时手动输入密码，实现无干扰执行任务。 |

### 4. `ssh-agent` 的命令和功能

| 功能                  | PowerShell 命令                 | 说明                                      |
| --------------------- | ------------------------------- | ----------------------------------------- |
| 启动 `ssh-agent` 服务 | `Start-Service ssh-agent`       | 启动 `ssh-agent` 以管理 SSH 密钥。        |
| 添加 SSH 私钥         | `ssh-add $HOME\.ssh\id_ed25519` | 将生成的 SSH 私钥添加到 `ssh-agent`。     |
| 查看已添加密钥        | `ssh-add -l`                    | 查看当前已经加载到 `ssh-agent` 中的密钥。 |
| 停止 `ssh-agent` 服务 | `Stop-Service ssh-agent`        | 停止 `ssh-agent` 服务，如果不再需要使用。 |

### 小结

通过这些表格，可以更清晰地了解 `ssh-agent` 的用途、好处和使用场景，以及如何在实际操作中使用相关命令。