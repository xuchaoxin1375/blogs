[toc]

## abstract

在 GitHub 上克隆项目时，通常有两种常见的克隆链接类型可供选择：**HTTPS** 和 **SSH**。两者各有优缺点，推荐选择哪种取决于你的需求和环境。

[关于远程仓库 - GitHub 文档](https://docs.github.com/zh/get-started/getting-started-with-git/about-remote-repositories)

### 1. **HTTPS (推荐初学者及无需配置的场景)**
   - **URL 示例**: `https://github.com/username/repository.git`
   - **优点**:
     - **无需复杂配置**：只要有 Git 和网络连接，你就可以立即使用 HTTPS 克隆仓库。
     - **适用性广**：即使在防火墙或代理服务器较为严格的环境下，HTTPS 也更容易通过。
     - **支持用户名/密码登录**：直接使用 GitHub 账号登录，适合初学者。
   - **缺点**:
     - **每次推送需要验证**：默认情况下，每次推送代码时都需要输入 GitHub 凭证。虽然可以使用 Git 凭证助手（Credential Helper）来避免反复输入密码，但这种方法还是不如 SSH 方便。

### 2. **SSH (推荐开发者或频繁操作 GitHub 的用户)**
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