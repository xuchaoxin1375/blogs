[toc]

## 案例

vps 厂商分配2个ip(这里两个ip是随便写的,具体换成自己真ip)

- 192.1.1.1
- 192.2.2.2

现在我只看到了

```
eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
....
    inet 192.1.1.1/24 brd 1.... scope global eth0
       valid_lft forever preferred_lft forever
    inet6 2a..../64 scope global
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ffff:fe4d:5a5d/64 scope link
       valid_lft forever preferred_lft forever
```

这种情况在 VPS 上非常常见。虽然厂商分配了两个 IP，但很多时候系统镜像只默认配置了主 IP（`192.1.1.1`），第二个 IP（`192.2.2.2`）需要你**手动配置到系统的网卡上**才能生效。

由于这两个 IP 不在同一个网段（一个是 `185.247.224.x`，一个是 `185.165.171.x`），配置时需要特别注意**掩码**。通常 VPS 厂商在同网卡绑定不同网段 IP 时，第二个 IP 应该使用 `/32` 掩码（单 IP 掩码），这样它会直接复用主 IP 的网关，避免路由冲突。

请按照以下步骤在 Ubuntu 中将第二个 IP 绑定到 `eth0` 上：

### 第一步：确认你的网络管理器

Ubuntu 默认使用 **Netplan**。我们先看看你的 Netplan 配置文件叫什么：

```bash
ls /etc/netplan/
```

通常会看到一个类似 `50-cloud-init.yaml` 或 `01-netcfg.yaml` 的文件。

### 第二步：修改 Netplan 配置

1. 备份原配置文件（以防万一）：

   ```bash
sudo cp /etc/netplan/*.yaml /etc/netplan/backup.yaml.bak
   ```

2. 使用编辑器打开它（假设文件名是 `50-cloud-init.yaml`）：

   ```bash
sudo nano /etc/netplan/50-cloud-init.yaml
   ```

3. 找到 `addresses:` 这一行，你会看到里面已经有了 `192.1.1.1/24`。

4. 在下面追加第二个 IP，使用 **/32** 掩码。修改后的结构应该类似这样：

```yaml
network:
    version: 2
    ethernets:
        eth0:
            dhcp4: no  # 如果原本是 true，改为 no
            addresses:
                - 192.1.1.1/24
                - 192.2.2.2/32  # 加上这行，注意用空格缩进，不要用 Tab
            # 下面的 gateway4 或 routes 保持厂商默认的不要动
            routes:
                - to: default
                  via: 185.247.224.1  # 这行保持你文件里原本的网关即可
            nameservers:
                addresses:
                    - 8.8.8.8
                    - 1.1.1.1
```

> **注意**：YAML 格式对空格极其敏感，新加的 `- 192.2.2.2/32` 必须和上一行完全对齐。

### 第三步：安全应用配置

为了防止配置错误导致服务器断网失联，强烈建议使用 `try` 命令：

```bash
sudo netplan try
```

如果终端显示 `Configuration accepted.` 并且你没有断开连接，直接按 **Enter** 键确认应用。如果中断了，它会在 120 秒后自动恢复原状。

如果提示一切正常，也可以直接强制生效：

```bash
sudo netplan apply
```

### 第四步：验证是否成功

1. **检查网卡状态**：

   再次运行 `ip a show eth0`，如果成功，你应该能看到两个 `inet` 行：

   ```
   inet 192.1.1.1/24 scope global eth0
   inet 192.2.2.2/32 scope global eth0
   ```
   
2. **测试外部连通性**：

   在本地电脑（或者另一台服务器）上，分别去 `ping` 这两个 IP：

   ```bash
   ping 192.1.1.1
   ping 192.2.2.2
   ```

   如果都能 ping 通，说明第二个 IP 已经顺利上线！

*(注：如果配置后第二个 IP 无法出网，可以尝试将掩码从 `/32` 改为 `/24` 再次 `netplan apply`，因为极少数 VPS 厂商在不同网段也会要求提供独立的子网掩码。)*
