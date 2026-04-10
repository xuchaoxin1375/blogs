\[toc\]

## abstract

和windows系统不同的是

在 Linux 系统中，`bin` 和 `sbin` 是两个历史悠久且具有特定语义的目录，它们的命名源自 Unix 传统，含义如下：

---

### 1 `bin`（Binary）

* 全称：Binary（可执行二进制文件）
* 用途：存放所有用户（包括普通用户和 root）都可以使用的基本命令和程序。
* 典型路径：
  * `/bin`：系统启动和修复所需的核心用户命令（如 `ls`, `cp`, `mv`, `cat`, `bash`）。
  * `/usr/bin`：非关键但常用的用户级应用程序（如 `git`, `python3`, `curl`, `gcc`）。

> ✅ 关键点：`/bin` 中的命令在单用户模式或系统最小环境中也必须可用（因此通常位于根文件系统，不依赖 `/usr` 挂载）。

---

### 2 `sbin`（System Binary）

* 全称：System Binary（系统管理二进制文件）
* 用途：存放系统管理员（通常是 root）使用的系统管理命令，普通用户一般不需要直接调用。
* 典型路径：
  * `/sbin`：系统启动、维护和修复所需的关键管理命令（如 `fdisk`, `ifconfig`, `iptables`, `init`, `reboot`）。
  * `/usr/sbin`：非核心但常用的系统管理工具（如 `sshd`, `nginx`, `useradd`, `crond`）。

> ✅ 关键点：这些命令通常需要 root 权限才能有效执行，且对系统运行至关重要。

---

### 📁 目录结构演进（现代 Linux 的变化）

早期 Unix 将所有核心命令放在 `/bin` 和 `/sbin`，而 `/usr/bin` 和 `/usr/sbin` 用于“非必需”程序。但随着系统复杂度增加，这种区分逐渐模糊。

#### 现代趋势（如 systemd 和 FHS 3.0+）：

* `/bin` 是 `/usr/bin` 的符号链接
* `/sbin` 是 `/usr/sbin` 的符号链接

例如在 Ubuntu 22.04+ 或 Fedora 中：

```bash
$ ls -l /bin
lrwxrwxrwx 1 root root 7 Apr 10  2023 /bin -> usr/bin

$ ls -l /sbin
lrwxrwxrwx 1 root root 8 Apr 10  2023 /sbin -> usr/sbin
```

> 💡 原因：简化系统结构，统一管理，避免重复。但语义保留：
>
> * 用户命令 → `/usr/bin`
> * 系统管理命令 → `/usr/sbin`

---

### 🔐 权限与 PATH 的关系

普通用户的 `PATH` 通常包含：

但许多发行版默认不将 `sbin` 目录加入普通用户的 PATH（出于安全考虑）。

root 用户的 `PATH` 通常包含所有 `sbin` 目录，例如：

> 🛡️ 安全意义：防止普通用户误用或滥用系统管理命令。

---

### ✅ 总结对比


| 目录        | 全称               | 用户类型   | 典型命令                      | 是否需要 root |
| ------------- | -------------------- | ------------ | ------------------------------- | --------------- |
| `/bin`      | Binary             | 所有用户   | `ls`, `cp`, `bash`            | 否            |
| `/sbin`     | System Binary      | 系统管理员 | `fdisk`, `ifconfig`, `reboot` | 通常是        |
| `/usr/bin`  | User Programs      | 所有用户   | `git`, `python3`, `curl`      | 否            |
| `/usr/sbin` | System Admin Tools | 系统管理员 | `sshd`, `useradd`, `nginx`    | 通常是        |

> 📌 记忆口诀：
>
> * bin = basic/user binaries
> * sbin = system/admin binaries

但是主要区分在于bin和sbin两个缩写上,至于前面是否带有 `/usr`的区别已经逐渐不重要了

## local/bin和local/sbin

在 Linux 系统中，`/usr/local/bin` 和 `/usr/local/sbin` 是 本地安装软件（即非系统包管理器安装的软件）的标准存放位置，它们是 FHS（Filesystem Hierarchy(层次结构/体系) Standard，文件系统层次结构标准）明确定义的一部分。

它们与 `/bin`、`/sbin`、`/usr/bin`、`/usr/sbin` 的关系，本质上是 “系统级” vs “本地/用户自定义” 的区分。

---

### 一、目录含义与用途


| 目录              | 全称/含义             | 用途说明                                                                                      |
| ------------------- | ----------------------- | ----------------------------------------------------------------------------------------------- |
| `/usr/local/bin`  | Local user binaries   | 本地编译或手动安装的普通用户可执行程序（如你自己编译的`nginx`、下载的 `edit`、`go` 工具链等） |
| `/usr/local/sbin` | Local system binaries | 本地安装的系统管理类程序（如自定义监控脚本、私有版本的`dockerd` 等，需 root 权限运行）        |

> ✅ 核心原则：`/usr/local/` 是为系统管理员（或用户）在本地安装软件而保留的，不会被系统包管理器（如 `apt`、`yum`）修改或覆盖。

---

### 二、与系统目录的对应关系


| 系统标准目录           | 本地扩展目录      | 语义对应     |
| ------------------------ | ------------------- | -------------- |
| `/bin` → `/usr/bin`   | `/usr/local/bin`  | 用户级命令   |
| `/sbin` → `/usr/sbin` | `/usr/local/sbin` | 系统管理命令 |

> 📌 注意：现代系统中 `/bin` 和 `/sbin` 通常是 `/usr/bin` 和 `/usr/sbin` 的符号链接，但 `/usr/local/bin` 和 `/usr/local/sbin` 始终独立存在，且不受系统更新影响。

---

### 三、典型使用场景

#### ✅ 场景 1：从源码编译安装软件（推荐指定 `--prefix=/usr/local`）

```
./configure --prefix=/usr/local
make && sudo make install
```

* 可执行文件 → `/usr/local/bin/`
* 配置文件 → `/usr/local/etc/`（注意：不是 `/etc`！）
* 库文件 → `/usr/local/lib/`
* 文档 → `/usr/local/share/doc/`

#### ✅ 场景 2：手动部署第三方二进制工具（如你下载的 `edit`）

```
sudo cp edit /usr/local/bin/
```

这样所有用户都能使用 `edit` 命令（前提是 `/usr/local/bin` 在 `PATH` 中）。

#### ✅ 场景 3：部署自研系统工具

* 你写了一个需要 root 权限的日志清理工具 `mylogcleaner`，可放入：

---

### 四、PATH 环境变量中的位置

大多数 Linux 发行版（包括 Ubuntu）默认将 `/usr/local/bin` 和 `/usr/local/sbin` 加入 `PATH`：

普通用户 的 `PATH` 通常包含：

（但不一定包含 `/usr/local/sbin`，出于安全考虑）

root 用户 的 `PATH` 通常包含：

> 🔍 验证方法：
>
> ```
> echo $PATH
> ```

---

### 五、与 `~/.local/bin` 的区别


| 目录             | 作用范围             | 权限要求        | 典型用途                                                    |
| ------------------ | ---------------------- | ----------------- | ------------------------------------------------------------- |
| `/usr/local/bin` | 系统全局（所有用户） | 需要`sudo` 写入 | 管理员部署的本地软件                                        |
| `~/.local/bin`   | 当前用户专属         | 无需`sudo`      | 用户自己安装的工具（如`pip install --user` 的 Python 脚本） |

> 💡 建议：
>
> * 如果你是唯一用户或无 sudo 权限 → 用 `~/.local/bin`
> * 如果你要为所有用户安装工具 → 用 `/usr/local/bin`

---

### 六、最佳实践总结

1. 手动安装的软件优先放入 `/usr/local/`，符合 FHS 规范；
2. 不要将自定义程序放入 `/usr/bin` 或 `/bin`，会被系统更新覆盖或冲突；
3. 确保 `/usr/local/bin` 在 `PATH` 中（现代系统默认已包含）；
4. 系统管理类工具放 `sbin`，普通工具放 `bin`，保持语义清晰；
5. 普通用户通常不需要访问 `/usr/local/sbin`，除非明确需要。

---
