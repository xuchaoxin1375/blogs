[toc]



在 Linux 系统上安装软件时，遵循一定的目录规范和最佳实践，有助于保持系统整洁、便于维护、提升安全性，并与其他工具（如备份、监控、权限管理）良好集成。以下从系统包管理器安装和手动安装软件两个方面，分别介绍安装目录规范及其原因。

---

## 系统包管理器安装

如 apt、yum、dnf、pacman 等.

### 1\. 安装目录规范

系统包管理器安装的软件通常遵循 Filesystem Hierarchy Standard (FHS)，主要目录包括：

|目录|用途|示例|
|-|-|-|
|`/bin`, `/sbin`|基本用户/系统命令（核心工具）部分系统下,`/bin,/sbin`分别是`/usr/bin,/usr/sbin`的链接|`ls`, `cp`, `init`|
|`/usr/bin`, `/usr/sbin`|非关键但常用的用户/系统命令|`gcc`, `nginx`, `docker`|
|`/usr/lib`, `/usr/lib64`|库文件;lib**含义**：**library**（库）的缩写,**具体指代**：程序库、函数库文件|`.so` 文件|
|`/usr/share`|与**架构无关**的共享数据（文档、图标、配置模板等）|man pages, locale files|
|`/etc`|系统和软件的**配置文件(etc是**Et Cetera的缩写)|`/etc/nginx/nginx.conf`|
|`/var/lib`|软件运行时产生的持久化数据（如数据库、状态）其中`var`是variable的缩写,表示可变或经常变化的,存放经常变化的文件，如日志、缓存、临时文件等,内容在系统运行期间会频繁改变;**library**（库）的另一种**引申含义**，指"数据集合"或"存储库"|`/var/lib/mysql`|
|`/var/log`|日志文件|`/var/log/nginx/access.log`|
|`/run` 或 `/var/run`|运行时临时文件（PID、socket 等）|`/run/nginx.pid`|

关于/usr目录,`/usr`  **全称**：Unix System Resources（Unix系统资源）或 User System Resources（用户系统资源）

关于/var中典型目录,例如:

* `/var/log/` - 系统日志文件

* `/var/cache/` - 应用程序缓存数据

* `/var/lib/` - **应用程序状态信息**

* `/var/tmp/` - 临时文件

* `/var/spool/` - 等待处理的任务队列

### 2\. 最佳实践与原因

- 不要手动修改包管理器安装的文件→ 原因：避免与后续系统更新冲突，导致升级失败或行为异常。

- 配置文件应放在 `/etc`，且尽量使用包提供的默认模板→ 原因：便于统一管理、审计和备份；符合 FHS 规范。

- 日志和数据分离存放(`/var/log` vs `/var/lib`) → 原因：便于设置不同权限、磁盘配额、备份策略。

- 依赖由包管理器自动解析 → 原因：避免“依赖地狱”，确保兼容性和安全性。

---

## 手动安装软件（源码编译、二进制分发包、脚本安装等）

### 1\. 安装目录规范

手动安装的软件不应污染系统标准目录（如 `/usr/bin`），推荐使用以下位置：

|目录|用途|说明|
|-|-|-|
|`/usr/local`|本地编译/手动安装的软件（FHS 官方推荐）|默认 `./configure` 的 prefix|
|`/opt`|opt表示optional,第三方商业或独立打包的软件（如 Oracle、JetBrains、自研工具）|每个软件应有独立子目录，如 `/opt/myapp`|
|`/home/<user>/local` 或 `~/.local`|用户级安装（非 root）|适用于无 sudo 权限场景|

关于`/opt`目录:**设计目的**

* 为**第三方软件**提供独立的安装目录

* 避免与系统原生软件产生冲突

* 便于软件管理和卸载

* 保持系统目录结构的整洁

#### 典型结构示例：

```bash
/usr/local/
├── bin/      # 可执行文件
├── lib/      # 库
├── share/    # 共享资源
└── etc/      # （可选）配置，但更推荐链接到 /etc

/opt/myapp/
├── bin/
├── conf/
├── logs/
└── data/
```

### 2\. 最佳实践与原因

- 优先使用 `/usr/local` 而非 `/usr`→ 原因：`/usr` 专用于系统包管理器；`/usr/local` 是 FHS 为本地安装保留的，避免与系统更新冲突。

- 使用 `/opt` 存放“黑盒式”独立软件包→ 原因：便于整体迁移、卸载（只需删除目录）；适合不遵循 Unix 拆分风格的集成式应用。

- 将配置文件符号链接到 `/etc`（可选但推荐）

  ```bash
  ln -s /usr/local/etc/myapp.conf /etc/myapp.conf
  ```

  → 原因：运维人员习惯在 `/etc` 查找配置；便于统一管理。

- 将可执行文件加入 `PATH`

  - 全局：在 `/etc/profile.d/` 添加脚本（如 `myapp.sh`）`/etc/profile.d` 是一个特殊的系统目录，用于存放**shell环境配置脚本**。

    * **用途**：存储系统级的环境变量和shell配置脚本

    * **执行时机**：用户登录时自动执行该目录下的所有脚本

      * **自动加载**：当用户通过登录shell启动时，系统会自动执行 `/etc/profile.d/` 目录下的所有 `.sh` 脚本

      * **文件格式**：通常以 `.sh` 扩展名命名

      * **执行顺序**：按字母顺序执行脚本文件

    * **配置范围**：影响所有用户的shell环境

  - 用户级：在 `~/.bashrc` 或 `~/.profile` 中添加 → 原因：确保命令可用，同时避免硬编码路径。

- 记录安装信息（版本、编译选项、依赖）→ 原因：便于日后升级、排查问题或卸载。

- 避免直接写入 `/bin`, `/sbin`, `/lib` 等系统目录 → 原因：破坏系统一致性，可能导致安全风险或系统不稳定。

## 自动执行脚本的配置

### **与其他配置文件的关系**

|文件/目录|类型|作用范围|加载时机|
|-|-|-|-|
|`/etc/profile`|文件|系统全局|登录时执行|
|`/etc/profile.d/`|目录|**系统全局**|**登录时自动执行**|
|`~/.bashrc`|文件|用户个人|每个shell会话|
|`~/.profile`|文件|用户个人|登录时执行|

---

## .d和d的含义

linux系统中,有一类目录名以`.d`结尾,而有一类文件(通常是可执行程序)以`d`结尾

它们有不同的含义:

- `.d`是directory(目录)

- `d`是daemon(守护进程)

#### **基本概念**

形如 `profile.d` 这样带有 `.d` 后缀的目录命名是一种**约定俗成的Unix/Linux系统设计模式**。

#### `.d` 的含义

* **全称**：**directory** 的缩写，表示"目录"

* **设计理念**：表示这是一个**包含多个配置文件或脚本**的目录集合

典型的`.d`目录

```bash
/etc/profile.d/     # shell环境配置脚本
/etc/cron.d/        # 定时任务配置文件
/etc/init.d/        # 系统服务启动脚本(早期linux)
/etc/rc.d/          # 系统运行级别配置
```

#### `d`的含义

对于可执行程序(文件),比如`sshd`,这里的`d`是daemon 的含义

* **全称**：**daemon**（守护进程）

* **作用**：在后台持续运行的服务程序

* **特点**：

  * 无需用户交互

  * 长期驻留在内存中

  * 响应特定请求或执行特定任务


另一种情况是`d`结尾的目录,比如`systemd`目录,`/etc/systemd/system`目录下配置`.service`文件定义自启服务

> 在 Linux 系统中，`/etc/systemd/` 是 systemd 初始化系统（init system）的**系统级配置目录**，用于存放系统范围内的 systemd 单元（units）和配置文件。
>
> 类似的,`/usr/lib/systemd/` 是 **systemd 初始化系统**在 Linux 中存放**默认单元文件（unit files）和系统级组件**的核心目录之一。它是 systemd 的“只读”或“软件包提供”的配置存储位置，与 `/etc/systemd/`（管理员可修改的配置）形成互补。

## 补充建议

- 容器化优先：对于复杂或临时软件，考虑使用 Docker/Podman，避免污染主机文件系统。

- 使用版本管理工具：如 `pyenv`（Python）、`nvm`（Node.js）、`sdkman`（Java 工具链），它们自动管理 `~/.local` 或专用目录。

- 自动化脚本应遵循上述规范：尤其在部署脚本中，明确指定 `--prefix=/usr/local` 或安装到 `/opt`。

---

## 总结

|安装方式|推荐目录|核心原则|
|-|-|-|
|包管理器|`/usr`, `/etc`, `/var` 等（FHS 标准）|交由系统统一管理|
|手动安装|`/usr/local`（编译软件）、`/opt`（独立包）|隔离、可维护、不干扰系统|

遵循这些规范，不仅能提升系统可维护性，还能在团队协作、故障排查和安全审计中显著降低复杂度。

## 案例:安装ms-edit跨平台命令行文本编辑器

例如我通过以下命令行获取到可执行程序edit

```bash
curl -L https://github.com/microsoft/edit/releases/download/v1.2.1/edit-1.2.0-x86_64-linux-gnu.tar.zst -o ~/edit.tar.zst
zstd -d ~/edit.tar.zst -o ~/edit.tar
tar -xvf ~/edit*.tar -C ~
```

你已经通过下载并解压得到了 `edit` 可执行文件（位于你的家目录，例如 `~/edit` 或 `~/edit-1.2.0-x86_64-linux-gnu/edit`）。为了让系统在任何工作目录下都能识别并执行 `edit` 命令，你需要将该可执行文件所在目录加入系统的 `PATH` 环境变量。

以下是推荐的配置步骤（以 Ubuntu/Linux 为例）：

---

### 推荐做法：将 `edit` 放入推荐目录并确保该目录在 `PATH` 中

可以将程序文件放入 `~/.local/bin` 或者`/usr/local/bin`目录中

前者针对当前用户,且不需要特殊权限,后者会为系统上所有用户配置,系统管理员可能会倾向后者,普通用户使用前者

#### 步骤 1：创建 `~/.local/bin`（如果不存在）

```bash
mkdir -p ~/.local/bin
```

#### 步骤 2：将 `edit` 可执行文件移动或复制到该目录

假设你解压后得到的可执行文件路径是 `~/edit-1.2.0-x86_64-linux-gnu/edit`：

```bash
cp ~/edit-1.2.0-x86_64-linux-gnu/edit ~/.local/bin/
# 或直接移动
# mv ~/edit-1.2.0-x86_64-linux-gnu/edit ~/.local/bin/
```

> 💡 确保它是可执行的（通常下载的二进制已是可执行，但可再确认）：
>
> ```bash
> chmod +x ~/.local/bin/edit
> ```

#### 步骤 3：确认 `~/.local/bin` 在 `PATH` 中

在大多数 Ubuntu 桌面或较新版本中，`~/.profile` 或 `~/.bashrc` 已自动包含如下逻辑：

```bash
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
```

你可以手动检查：

```bash
echo $PATH | grep -o "$HOME/.local/bin"
```

如果没有输出，说明未加入。此时请编辑 shell 配置文件：

- 如果你使用 bash（默认）：

  ```bash
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
  ```

- 如果你使用 zsh：

  ```bash
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
  source ~/.zshrc
  ```

> 📝 注意：某些系统（如 Ubuntu Desktop）会在图形登录时读取 `~/.profile`，所以更稳妥的做法是加到 `~/.profile`（对所有 shell 生效）：
>
> ```bash
> echo '[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
> source ~/.profile
> ```

#### 步骤 4：验证

打开新终端或执行 `source ~/.bashrc`（或对应配置文件）后，运行：

```bash
which edit
# 应输出：/home/你的用户名/.local/bin/edit

edit --version
# 应正常显示版本信息
```

---

###  不推荐的做法（避免以下方式）

- 直接把 `edit` 放在家目录并加 `~/` 到 `PATH`→ 安全风险高（容易误执行恶意脚本），且不符合规范。

- 修改 `/usr/local/bin` 需要 `sudo`→ 虽然可行，但用户级软件无需提权，优先用 `~/.local/bin`。

- 每次用绝对路径调用 → 不便，违背“任意目录调用”的目标。

---



