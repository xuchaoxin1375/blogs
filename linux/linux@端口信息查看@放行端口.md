[toc]



## 查看防火墙放行的端口

```bash
sudo ufw status verbose
```

例如

```bash
$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
20/tcp                     ALLOW IN    Anywhere
21/tcp                     ALLOW IN    Anywhere
22/tcp                     ALLOW IN    Anywhere
80/tcp                     ALLOW IN    Anywhere
443/tcp                    ALLOW IN    Anywhere
888/tcp                    ALLOW IN    Anywhere
18444/tcp                  ALLOW IN    Anywhere
39000:40000/tcp            ALLOW IN    Anywhere
22022/tcp                  ALLOW IN    Anywhere
20/tcp (v6)                ALLOW IN    Anywhere (v6)
21/tcp (v6)                ALLOW IN    Anywhere (v6)
22/tcp (v6)                ALLOW IN    Anywhere (v6)
80/tcp (v6)                ALLOW IN    Anywhere (v6)
443/tcp (v6)               ALLOW IN    Anywhere (v6)
888/tcp (v6)               ALLOW IN    Anywhere (v6)
18444/tcp (v6)             ALLOW IN    Anywhere (v6)
39000:40000/tcp (v6)       ALLOW IN    Anywhere (v6)
22022/tcp (v6)             ALLOW IN    Anywhere (v6)
```



### Linux 端口常用命令速查表

| 任务类别               | 命令                       | 示例                                                 | 说明                                                   |
| :--------------------- | :------------------------- | :--------------------------------------------------- | :----------------------------------------------------- |
| **查看本机监听端口**   | `ss -tunlp`                | `sudo ss -tunlp`                                     | **（推荐）** 查看所有监听中的 TCP/UDP 端口及进程信息。 |
|                        | `netstat -tunlp`           | `sudo netstat -tunlp`                                | **（经典）** 功能同 `ss`，但速度较慢，逐渐被取代。     |
| **查找占用端口的进程** | `lsof -i :<端口号>`        | `sudo lsof -i :80`                                   | 精确查看特定端口被哪个进程占用。                       |
| **测试远程端口连通性** | `nc -zv <主机> <端口>`     | `nc -zv example.com 443`                             | **（推荐）** 快速测试 TCP 端口是否开放。               |
|                        | `telnet <主机> <端口>`     | `telnet example.com 22`                              | **（经典）** 测试 TCP 端口连通性，交互式界面。         |
|                        | `nmap -p <端口> <主机>`    | `nmap -p 80,443 192.168.1.1`                         | **（专业）** 功能强大的端口扫描，可批量扫描。          |
| **防火墙管理（简单）** | `ufw allow <端口>`         | `sudo ufw allow 8080`                                | 开放端口（Ubuntu/Debian 常用）。                       |
|                        | `ufw deny <端口>`          | `sudo ufw deny 3306`                                 | 关闭端口访问。                                         |
|                        | `ufw status`               | `sudo ufw status`                                    | 查看防火墙状态和规则。                                 |
| **防火墙管理（高级）** | `firewall-cmd`             | `sudo firewall-cmd --add-port=80/tcp --permanent`    | CentOS/RHEL/Fedora 系统默认防火墙管理工具。            |
|                        | `iptables`                 | `sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT` | 底层的防火墙规则配置工具。                             |
| **通过服务管理端口**   | `systemctl stop <服务名>`  | `sudo systemctl stop nginx`                          | **停止服务**，从而关闭其监听的端口。                   |
|                        | `systemctl start <服务名>` | `sudo systemctl start nginx`                         | **启动服务**，从而打开其监听的端口。                   |

---

### 常用相关工具特点总结

| 工具               | 主要用途                               | 特点与定位                                                   | 备注                                                         |
| :----------------- | :------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| **`ss`**           | 查看本地网络连接和监听端口。           | **现代、高效、推荐**。直接从内核获取信息，速度极快，输出简洁。是 `netstat` 的替代品。 | **系统管理员日常诊断的首选工具。**                           |
| **`netstat`**      | 查看本地网络连接和监听端口。           | **经典、全面、但过时**。功能强大，但速度慢于 `ss`。在某些旧系统中可能仍是默认选择。 | 了解即可，新环境中应优先使用 `ss`。                          |
| **`lsof`**         | 列出被进程打开的文件（包括网络端口）。 | **功能强大、定位精准**。不仅能看网络，还能查看文件、目录等被谁占用。语法与其他工具略有不同。 | 当需要精确查找“某个文件/端口被谁占用”时的终极武器。          |
| **`nc` (netcat)**  | 网络工具的“瑞士军刀”。                 | **灵活、轻量、脚本友好**。可用于端口测试、端口扫描、文件传输、甚至作为简单的网络服务器/客户端。`-zv` 组合是端口测试的黄金标准。 | **网络调试和脚本编写的利器。**                               |
| **`telnet`**       | 远程登录（旧式）和端口测试。           | **简单、直观、专用于TCP**。几乎所有操作系统都默认可用（但现在许多 Linux 发行版需手动安装）。输出信息直观，是测试 TCP 端口连通性的经典方法。 | 对于初学者来说非常直观，但功能单一。                         |
| **`nmap`**         | 网络发现和安全审计（端口扫描）。       | **专业、强大、全面**。能进行主机发现、端口扫描、服务版本探测、操作系统识别等。功能远超简单端口测试。 | **注意：未经授权扫描他人网络可能是非法的。** 用于审计自己的网络。 |
| **`ufw`**          | 简化 iptables 防火墙配置。             | **简单、易用、人性化**。为 iptables 提供了一个用户友好的命令行接口。特别适合桌面用户和防火墙初学者。 | Ubuntu 系统的默认防火墙配置工具。                            |
| **`firewall-cmd`** | 配置 firewalld 动态防火墙。            | **强大、灵活、基于区域**。CentOS/RHEL/Fedora 等系统的默认防火墙管理工具。使用“区域”和“服务”的概念，管理更高级。 | 红帽系列发行版的标准工具。                                   |
| **`iptables`**     | 配置 Linux 内核内置的防火墙规则。      | **底层、强大、复杂**。是 Linux 防火墙的基石，`ufw` 和 `firewalld` 都是它的前端。直接使用它需要对网络有较深理解。 | 学习它可以深入理解 Linux 防火墙的工作原理。                  |

### 核心要点总结

1.  **诊断流程**：先 `ss`（查本地） -> 再 `nc`（测远程）。
2.  **端口管理本质**：端口开关由**服务进程**（`systemctl`）和**防火墙**（`ufw`/`firewall-cmd`）共同决定。
3.  **工具选择**：
    *   **日常快速检查**：`ss` + `nc`。
    *   **精准问题定位**：`lsof`。
    *   **简单防火墙配置**：`ufw`（Debian/Ubuntu）或 `firewall-cmd`（RHEL/CentOS）。
    *   **专业网络探测**：`nmap`。



## 常用命令速查表

以3306端口为例

| 操作                 | 命令                                                |
| -------------------- | --------------------------------------------------- |
| 查看端口监听         | `ss -tulnp \| grep 3306`                            |
| 测试远程端口         | `telnet IP 3306` 或 `nc -zv IP 3306`                |
| 开放防火墙（Ubuntu） | `sudo ufw allow 3306/tcp`                           |
| 开放防火墙（CentOS） | `sudo firewall-cmd --add-port=3306/tcp --permanent` |
| 重启 MySQL           | `sudo systemctl restart mysql`                      |
| 查看日志             | `sudo tail -f /var/log/mysql/error.log`             |

---



