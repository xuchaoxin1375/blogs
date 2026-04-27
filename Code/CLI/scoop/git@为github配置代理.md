[toc]

## abstract

为了实现 **GitHub 走代理** 而 **Gitee（及国内站点）直连**，最优雅且推荐的方式是直接修改你的 `~/.gitconfig` 文件。

这种方法比设置系统全局环境变量更精准，不会误伤其他软件。

------

###  针对 GitHub 单独配置代理

你可以利用 Git 的 **URL 条件配置**。这种方法只会对包含 `github.com` 的请求生效，完全不影响 Gitee。

打开终端，直接执行以下命令（请根据你代理软件的实际端口修改）：



> **注意：** 这里使用的是 `http.https://github.com.proxy`，这是一种限定域名的写法。

#### 情况 A：如果你使用 SOCKS5 代理（推荐）

```bash
# 只针对 GitHub 域名进行配置（最优雅）
git config --global http.https://github.com.proxy socks5://127.0.0.1:端口号
git config --global https.https://github.com.proxy socks5://127.0.0.1:端口号
```

> 针对 `http `协议的 GitHub 地址（现在很少见，但为了兼容性）第一行也保留

#### 情况 B：如果你使用 HTTP/HTTPS 代理

```bash
git config --global http.https://github.com.proxy http://127.0.0.1:端口号
git config --global https.https://github.com.proxy http://127.0.0.1:端口号
```

------

###  验证配置是否成功

执行以下命令查看你的 `.gitconfig` 文件内容：

```bash
git config --global -e
```

你应该能看到类似这样的配置段落：

```ini
[http "https://github.com"]
    proxy = http://127.0.0.1:7890
```

只要配置文件里**没有**全局的 `[http] proxy = ...`，那么 Gitee 就会默认走直连，不会受到任何影响。

------

###  SSH 协议的特殊处理 (如果你用的是 git@github.com...)

如果你习惯使用 SSH 密钥而不是 HTTPS 链接，上面的 Git 配置是不生效的。你需要修改 SSH 的配置文件 `~/.ssh/config`（如果没有就创建一个）：

```ini
# GitHub 走代理
Host github.com
    HostName github.com
    User git
    # Windows 用户路径通常是: Connect.exe 的位置
    # macOS/Linux 用户通常使用 nc
    ProxyCommand nc -v -x 127.0.0.1:7890 %h %p

# Gitee 保持直连
Host gitee.com
    HostName gitee.com
    User git
```

------

### 💡 小贴士

- **检查端口：** 确保你的代理软件（如 Clash, v2ray 等）已经开启了“允许局域网”或确认监听端口号确实是 7890。

- **取消全局代理：** 如果你之前乱改过，建议先清理一下全局设置：

  `git config --global --unset http.proxy`

  `git config --global --unset https.proxy`

