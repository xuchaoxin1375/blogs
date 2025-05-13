[toc]

## 安装相关图片压缩工具

假设你要压缩jgp,web,分别要安装jpegoptim,web

```bash
sudo apt update
sudo apt install jpegoptim webp

```



## 可能遇到的问题

```bash
sudo apt update
sudo apt install jpegoptim webp

Hit:1 https://mirrors.tuna.tsinghua.edu.cn/ubuntu noble InRelease
Hit:2 https://mirrors.tuna.tsinghua.edu.cn/ubuntu noble-updates InRelease
Hit:3 https://mirrors.tuna.tsinghua.edu.cn/ubuntu noble-backports InRelease
Hit:4 http://security.ubuntu.com/ubuntu noble-security InRelease
Hit:5 https://ppa.launchpadcontent.net/zhangsongcui3371/fastfetch/ubuntu noble InRelease
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
141 packages can be upgraded. Run 'apt list --upgradable' to see them.
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
jpegoptim is already the newest version (1.4.7-1).
webp is already the newest version (1.3.2-0.4build3).
0 upgraded, 0 newly installed, 0 to remove and 141 not upgraded.
4 not fully installed or removed.
After this operation, 0 B of additional disk space will be used.
Do you want to continue? [Y/n]
Setting up mariadb-common (1:10.11.11-0ubuntu0.24.04.2) ...
update-alternatives: error: alternative path /etc/mysql/mariadb.cnf doesn't exist
dpkg: error processing package mariadb-common (--configure):
 installed mariadb-common package post-installation script subprocess returned error exit status 2
No apport report written because the error message indicates its a followup error from a previous failure.
                                                                                                          dpkg: dependency problems prevent configuration of libmariadb3:amd64:
 libmariadb3:amd64 depends on mariadb-common; however:
  Package mariadb-common is not configured yet.

dpkg: error processing package libmariadb3:amd64 (--configure):
 dependency problems - leaving unconfigured
dpkg: dependency problems prevent configuration of mariadb-client-core:
 mariadb-client-core depends on libmariadb3 (>= 10.5.4); however:
  Package libmariadb3:amd64 is not configured yet.
 mariadb-client-core depends on mariadb-common (>= 1:10.11.11-0ubuntu0.24.04.2); however:
  Package mariadb-common is not configured yet.

dpkg: error processing package mariadb-client-core (--configure):
 dependency problems - leaving unconfigured
dpkg: dependency problems prevent configuration of mariadb-client:
 mariadb-client depends on mariadb-client-core (>= 1:10.11.11-0ubuntu0.24.04.2); however:
  Package mariadb-client-core is not configured yet.

dpkg: error processing packNo apport report written because the error message indicates its a followup error from a previous failure.
                   No apport report written because MaxReports is reached already
                                                                                 age mariadb-client (--configure):
 dependency problems - leaving unconfigured
Errors were encountered while processing:
 mariadb-common
 libmariadb3:amd64
 mariadb-client-core
 mariadb-client
E: Sub-process /usr/bin/dpkg returned an error code (1)
```

你遇到的问题是由于 `mariadb-common` 包未能正确配置，导致依赖链断裂，最终使得 `apt` 无法继续安装或更新相关软件包。这类问题通常发生在以下情况：

- 系统升级中断
- 软件源异常或不可用
- 手动修改了系统文件（如 `/etc/mysql/mariadb.cnf`）
- 软件包损坏或冲突

---

## ✅ 解决方案

### 🔧 步骤 1：清理未完成的安装状态

```bash
sudo apt purge mariadb-common libmariadb3 mariadb-client-core mariadb-client
sudo apt autoremove
sudo apt clean
```

这将清除已损坏或部分安装的 MariaDB 组件。

---

### 🔄 步骤 2：重新安装 MariaDB 相关组件

```bash
sudo apt install mariadb-common
sudo apt install libmariadb3
sudo apt install mariadb-client-core mariadb-client
```

逐个安装可以更好地定位哪一步出错。(通常到这里就修复完成)

---

## 额外手段

### 📦 其他:修复依赖关系

如果仍然报错，尝试使用下面命令修复依赖：

```bash
sudo apt --fix-broken install
```

---

### 🧪 可选：手动创建缺失的配置文件

如果提示 `/etc/mysql/mariadb.cnf` 缺失，你可以尝试手动创建一个软链接或空文件（不推荐长期使用）：

```bash
sudo touch /etc/mysql/mariadb.cnf
```

或者查看是否可以从其他位置恢复默认配置文件，比如从 `mariadb-server` 包中提取：

```bash
sudo apt install --reinstall mariadb-server
```

---

### 🌐 检查软件源设置

你的输出中显示你使用了清华源和官方源：

- 清华源地址：https://mirrors.tuna.tsinghua.edu.cn/ubuntu
- Launchpad PPA：https://ppa.launchpadcontent.net/zhangsongcui3371/fastfetch/ubuntu

确保你的 `/etc/apt/sources.list` 和 `/etc/apt/sources.list.d/` 中的源是正确的，并且没有冲突的版本。

> 如果你不确定某个 PPA 是否必要，可以暂时注释掉它再试一次安装。

---

### 🧹 最后建议

- **备份重要数据**后再进行系统级操作。
- 如果你不需要 MariaDB，可以选择忽略这些错误（但可能会影响一些依赖它的应用）。
- 如果你正在运行的是服务器环境，建议在维护窗口内操作。

---

如果你需要我帮你写一个脚本来自动化处理这些问题，请告诉我 😊