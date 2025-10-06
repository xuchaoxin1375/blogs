[toc]

## abstract

[使用 WSL 访问网络应用程序 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/networking#identify-ip-address)

较新的系统(win11 22H2以及之后)的系统可以配置wsl2使用更先进的网络配置

wsl使用代理分为2种情况:

1. 在 **WSL（Windows Subsystem for Linux）** 中使用 **代理软件（通常运行在 Windows 主机上）** 作为代理，需要正确配置 WSL 的网络以通过 Windows 上的 代理软件代理访问互联网。
2. 或者在wsl中安装代理客户端直接使用代理服务器,而不依赖于windows上的代理软件

本文主要讨论第一种情况

---

## ✅ 前提条件

1. **代理软件已在 Windows 上运行**，并启用了 **HTTP/SOCKS5 代理**（默认端口通常是 `7890`（HTTP）和 `7891`（SOCKS5））。
2. **代理软件配置允许来自局域网（或本地）的连接**：
   - 在 代理软件配置文件（如 `config.yaml`）中，确保有：
     ```yaml
     external-controller: 0.0.0.0:9090  # 可选，用于控制面板
     allow-lan: true                    # ⚠️ 必须为 true
     bind-address: "*"                  # 或 "0.0.0.0"
     ```
   - 或在 代理软件(for Windows) 等 GUI 客户端中，勾选 **“允许局域网连接”**（Allow LAN）。

> 💡 WSL2 与 Windows 是**不同网络命名空间**，WSL2 通过虚拟 NAT 网络访问 Windows，因此必须开启 `allow-lan`，否则 WSL 无法连接到 Windows 上的代理。

---

## 🔧 步骤 1：获取 Windows 主机在 WSL 中的 IP 地址

在 **WSL 终端中**运行：

```bash
cat /etc/resolv.conf | grep nameserver | awk '{print $2}'
```

输出类似：
```
172.28.128.1
```

这个 IP 就是 **Windows 主机在 WSL2 网络中的网关地址**（每次重启 WSL 可能变化，但通常稳定）。

> 📌 记下这个 IP（例如 `172.28.128.1`），后续用它代替 `localhost`。

---

## 🔧 步骤 2：在 WSL 中配置代理

### 方法 A：临时设置（当前 shell 有效）

```bash
# 假设 代理软件HTTP 代理端口是 7890
export http_proxy="http://172.28.128.1:7890"
export https_proxy="http://172.28.128.1:7890"
export all_proxy="socks5://172.28.128.1:7891"  # 可选，用于支持 SOCKS5 的工具
```

> 替换 `172.28.128.1` 为你上一步查到的实际 IP。

测试：
```bash
curl -I https://www.google.com
```

### 方法 B：永久生效（推荐）

将代理设置写入 shell 配置文件（如 `~/.bashrc` 或 `~/.zshrc`）：

```bash
echo 'export host_ip=$(cat /etc/resolv.conf | grep nameserver | awk '\''{print $2}'\'')' >> ~/.bashrc
echo 'export http_proxy="http://${host_ip}:7890"' >> ~/.bashrc
echo 'export https_proxy="http://${host_ip}:7890"' >> ~/.bashrc
echo 'export all_proxy="socks5://${host_ip}:7891"' >> ~/.bashrc
```

然后重载配置：
```bash
source ~/.bashrc
```

> ✅ 这样每次启动 WSL 都会自动获取 Windows 的 IP 并设置代理。

---

## 🔧 步骤 3：配置 Git、APT、Conda 等工具（可选）

### Git
```bash
git config --global http.proxy http://172.28.128.1:7890
git config --global https.proxy http://172.28.128.1:7890
```

### APT（Debian/Ubuntu）
编辑 `/etc/apt/apt.conf.d/proxy.conf`：
```bash
echo 'Acquire::http::Proxy "http://172.28.128.1:7890";' | sudo tee /etc/apt/apt.conf.d/proxy.conf
echo 'Acquire::https::Proxy "http://172.28.128.1:7890";' | sudo tee -a /etc/apt/apt.conf.d/proxy.conf
```

### Conda
```bash
conda config --set proxy_servers.http http://172.28.128.1:7890
conda config --set proxy_servers.https http://172.28.128.1:7890
```

---

## 🚫 常见问题排查

### ❌ 无法连接代理？
- 检查 代理软件是否开启 **Allow LAN**。
- 在 Windows 上用浏览器访问 `http://172.28.128.1:7890`（应无法打开，但说明端口监听正常）。
- 在 WSL 中测试端口连通性：
  ```bash
  telnet 172.28.128.1 7890
  # 或
  nc -zv 172.28.128.1 7890
  ```

### ❌ WSL1 vs WSL2？
- **WSL1**：可以直接用 `localhost` 或 `127.0.0.1` 访问 Windows 服务。
- **WSL2**：**不能**用 `localhost`，必须用 `/etc/resolv.conf` 中的 nameserver IP。

> 大多数新安装的是 WSL2，所以务必用 `172.x.x.1` 这类 IP。

---

## ✅ 验证是否走代理

```bash
curl https://ip.cn
# 应显示你的代理出口 IP（而非本地公网 IP）
```

---

## 🧩 高级技巧：自动切换代理（带开关）

在 `~/.bashrc` 中添加函数：

```bash
proxy_on() {
    export host_ip=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
    export http_proxy="http://${host_ip}:7890"
    export https_proxy="http://${host_ip}:7890"
    export all_proxy="socks5://${host_ip}:7891"
    echo "Proxy enabled."
}

proxy_off() {
    unset http_proxy https_proxy all_proxy
    echo "Proxy disabled."
}
```

使用：
```bash
proxy_on   # 开启代理
proxy_off  # 关闭代理
```

---

## 总结

| 步骤 | 操作                                                         |
| ---- | ------------------------------------------------------------ |
| 1    | 确保 代理软件开启 **Allow LAN**                              |
| 2    | 在 WSL 中获取 Windows IP：`cat /etc/resolv.conf \| grep nameserver \| awk '{print $2}'` |
| 3    | 设置 `http_proxy` 等环境变量指向该 IP + 代理软件端口         |
| 4    | （可选）配置 Git/APT/Conda 等工具                            |

