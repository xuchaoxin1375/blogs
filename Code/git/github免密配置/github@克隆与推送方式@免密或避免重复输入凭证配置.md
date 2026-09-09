[toc]

## abstract

在 GitHub 上克隆项目时，通常有两种常见的克隆链接类型可供选择：**HTTPS** 和 **SSH**。两者各有优缺点，推荐选择哪种取决于你的需求和环境。

[关于远程仓库 - GitHub 文档](https://docs.github.com/zh/get-started/getting-started-with-git/about-remote-repositories)

### 1. HTTPS (推荐初学者及无需配置的场景)

   - **URL 示例**: `https://github.com/username/repository.git`
   - **优点**:
     - **无需复杂配置**：只要有 Git 和网络连接，你就可以立即使用 HTTPS 克隆仓库。
     - **适用性广**：即使在防火墙或代理服务器较为严格的环境下，HTTPS 也更容易通过。
     - **支持用户名/密码登录**：直接使用 GitHub 账号登录，适合初学者。
   - **缺点**:
     - **每次推送需要验证**：默认情况下，每次推送代码时都需要输入 GitHub 凭证。虽然可以使用 Git 凭证助手（Credential Helper）来避免反复输入密码，但这种方法还是不如 SSH 方便。

### 2. SSH (推荐开发者或频繁操作 GitHub 的用户)

   - **URL 示例**: `git@github.com:username/repository.git`
   - **优点**:
     - **更高的安全性**：SSH 密钥使用公钥-私钥认证机制，不需要每次输入密码。
     - **高效**：设置好 SSH 后，你可以不必重复输入用户名和密码，极大提升了工作效率。
     - **适合频繁操作的用户**：对于日常与 GitHub 频繁交互的开发者，SSH 是更方便的选择。
   - **缺点**:
     - **需要配置 SSH 密钥**：需要生成 SSH 密钥对，并将公钥添加到 GitHub 上，这对新手来说可能稍微复杂。

### 推荐选择

- 如果你是初学者或不想处理 SSH 配置，可以选择 **HTTPS**。
- 如果你经常推送和拉取代码，且希望提高安全性和效率，建议使用 **SSH**。

你可以根据自己的需求来选择适合的方式，如果你还未配置 SSH 密钥，推荐先从 HTTPS 开始，之后根据需要再切换到 SSH。

## git凭证助手和凭证管理器

查看git安装目录下的软件凭证相关的软件或文件

```powershell

PS C:\ProgramData\scoop\apps\git\2.46.0\mingw64\bin> ls *credential*

    Directory: C:\ProgramData\scoop\apps\git\2.46.0\mingw64\bin

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           2024/7/30     2:15          64486 git-credential-helper-selector.exe
-a---           2024/7/30     2:15          81344 git-credential-manager.exe
-a---           2024/7/30     2:15           2225 git-credential-manager.exe.config

```

你列出的这些软件文件都和 Git 的凭证管理（Credential Management）相关。以下是它们的详细介绍：

### 1. `git-credential-helper-selector.exe`

这个文件是 Git 的凭证助手选择器。它的主要作用是帮助用户选择哪个凭证助手（helper）来管理 Git 凭证。Git 支持不同的凭证管理方式，比如缓存凭证、存储在文本文件中，或者使用外部的凭证管理器（例如 Windows Credential Manager 或者 GCM）。这个程序可能用于根据用户环境或偏好来自动选择合适的凭证助手。

### 2. `git-credential-manager.exe`
这是 Git 凭证管理器（Git Credential Manager, 简称 GCM）。它是一个跨平台的工具，用来安全地存储和管理 Git 的认证信息（如用户名和密码，OAuth 令牌等）。`git-credential-manager.exe` 提供了一种集成式的方式来与 Git 服务（例如 GitHub、GitLab 和 Azure DevOps 等）进行交互，避免每次访问远程仓库时都需要手动输入用户名和密码。

GCM 通常支持以下几种功能：
- **自动保存凭证**：首次使用时，GCM 会要求用户输入凭证，并在后续访问时自动使用保存的凭证。
- **多平台支持**：支持 Windows、macOS 和 Linux 等多种操作系统。
- **高级认证方式**：支持 OAuth、Personal Access Token（PAT）等现代认证方式，增加安全性。
  

GCM 在 Git 操作（如 `git push`、`git fetch` 等）中使用，当需要认证信息时，它会自动提示用户输入凭证，并根据配置将其存储在系统安全存储中（如 Windows Credential Store 或 macOS Keychain）。

### 3. `git-credential-manager.exe.config`

这是 Git 凭证管理器的配置文件。`.config` 文件通常以 XML 格式存储，用于指定 `git-credential-manager.exe` 的一些启动参数和配置选项。它可以定义：
- **日志设置**：指定如何记录操作日志，便于调试或记录凭证管理器的活动。
- **凭证缓存或存储位置**：配置存储 Git 凭证的方式（如本地缓存、系统凭证存储等）。
- **行为参数**：比如是否提示用户输入新的凭证，或者如何处理现有的凭证等。

#### 总结

| 文件名称                             | 功能简述                                             |
| ------------------------------------ | ---------------------------------------------------- |
| `git-credential-helper-selector.exe` | Git 凭证助手选择器，帮助用户选择适当的凭证管理方式。 |
| `git-credential-manager.exe`         | Git 凭证管理器，安全管理 Git 认证信息。              |
| `git-credential-manager.exe.config`  | 配置文件，指定凭证管理器的启动参数和行为。           |

你可以根据需要选择适合你的凭证管理方式，GCM 是目前较为现代且安全的解决方案，尤其适合处理远程仓库认证。