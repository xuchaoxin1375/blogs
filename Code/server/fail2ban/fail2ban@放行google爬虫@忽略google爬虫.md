[toc]

## abstract

要让 **Fail2ban** 忽略 **Google 爬虫 (Googlebot)** 的封禁，最可靠的方法是利用 **Google 推荐的反向 DNS 查找 (Reverse DNS Lookup)** 机制，而不是尝试去列出其不断变化的 IP 地址范围。

以下是实现这一目标的主要步骤，通常通过配置 **`ignorecommand`** 来完成,而不是使用`ingoreip`：

### 1. 创建 IP 检查脚本

您需要一个脚本来执行反向 DNS 查找，并检查结果是否与 Googlebot 的域名匹配。

- **创建脚本文件：**

  Bash

  ```
  sudo touch /usr/local/bin/ignore_googlebot_ip.sh
  sudo chmod +x /usr/local/bin/ignore_googlebot_ip.sh
  ```

- 编辑脚本内容：

  使用 nano 或 vim 编辑该文件，并添加以下内容：

  Bash

  ```bash
  #!/bin/bash
  
  IP="$1"
  # 使用 host 命令进行反向 DNS 查找，-W 1 设置超时为 1 秒
  HOSTRESULT="$(host -W 1 ${IP})"
  
  # 匹配 host 命令的输出，看是否包含 googlebot.com. 或 google.com. 结尾的域名
  # Googlebot 的真实 IP 应该解析到一个以 .googlebot.com 或 .google.com 结尾的域名
  # 注意：这里的正则表达式可能需要根据您的系统 host 命令输出格式微调
  # 推荐使用：.*(googlebot\.com|google\.com)$
  REGEX='.*(googlebot\.com|google\.com)\.$' 
  
  # 检查 $HOSTRESULT 是否匹配 REGEX
  if [[ "$HOSTRESULT" =~ $REGEX ]]; then
      # 匹配成功，忽略 (退出代码 0)
      exit 0
  else
      # 匹配失败，不忽略 (退出代码 1)
      exit 1
  fi
  ```

  > **注意：** `host` 命令的输出在不同的 Linux 发行版上可能略有不同。`host` 命令返回的域名应以 `googlebot.com.` 或 `google.com.` 结尾（末尾有一个点）。

### 2. 配置 Fail2ban 的 `jail.local` 文件

修改您的 Fail2ban 配置文件，告诉它在封禁 IP 之前运行上述脚本进行检查。

- **编辑配置文件：**

  Bash

  ```
  sudo nano /etc/fail2ban/jail.local
  ```

- 在 [DEFAULT] 部分添加 ignorecommand：

  找到或添加 [DEFAULT] 部分。

  Ini, TOML

  ```
  [DEFAULT]
  # ... 其他设置 ...
  
  # 忽略的 IP 地址列表 (例如，您自己的 IP、本地回环等)
  # ignoreip = 127.0.0.1/8 ::1
  
  # 定义一个命令，用于检查 IP 地址是否应该被忽略
  # <ip> 是 fail2ban 传递给脚本的 IP 地址
  ignorecommand = /usr/local/bin/ignore_googlebot_ip.sh <ip>
  
  # ... 其他设置 ...
  ```

- 针对特定的 Jail 配置 ignorecommand (可选):

  如果您只想对特定的 Jail (例如 nginx-badbots 或 apache-dos) 启用此检查，则可以将 ignorecommand 配置在该特定的 Jail 部分下，它将覆盖 [DEFAULT] 中的设置。

  Ini, TOML

  ```
  [nginx-http-auth]
  enabled = true
  # ... 其他设置 ...
  ignorecommand = /usr/local/bin/ignore_googlebot_ip.sh <ip>
  ```

### 3. 重启 Fail2ban 服务

保存并关闭文件后，重启 Fail2ban 服务使更改生效。

Bash

```
sudo systemctl restart fail2ban
# 或者对于一些旧系统：
# sudo service fail2ban restart
```

### ❓ 为什么不直接用 `ignoreip`？

- **IP 变动:** Googlebot 的 IP 地址范围非常庞大且**经常变动**。手动维护这个列表几乎不可能，而且一旦 IP 发生变化，您就会开始封禁正常的爬虫。
- **官方推荐:** Google 官方**不推荐**通过 IP 范围来识别 Googlebot，而是建议通过执行反向 DNS 查找来验证。这个 `ignorecommand` 脚本就是实现了这个验证过程。

这个方法确保了只有那些**能够正确反向解析到 `\*.googlebot.com` 或 `\*.google.com`** 的 IP 才会被 Fail2ban 忽略，从而有效防止了误封 Google 爬虫。

------

