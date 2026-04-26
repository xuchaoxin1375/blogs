[toc]

## abstract

Lima 启动 Linux 虚拟机，并具有自动文件共享和端口转发功能（类似于 WSL2）。

- [lima-vm/lima: Linux virtual machines, with a focus on running containers](https://github.com/lima-vm/lima)
- [Lima: Linux Machines | Lima](https://lima-vm.io/docs/)

安装文档:[安装 | lima --- Installation | Lima](https://lima-vm.io/docs/installation/)

Lima（Linux Machines）的设计理念可以概括为：**“让 macOS 上的 Linux 体验像原生一样流畅”**。它不仅仅是一个虚拟机管理器，更像是一个为云原生开发者打造的 **“macOS 版 WSL2”**。

其核心设计理念主要体现在以下几个维度：

------

###  极致的透明性（Transparency）

Lima 的核心目标是让用户**感觉不到**虚拟机的存在。

- **自动端口转发：** 如果你在虚拟机（Guest）中启动了一个监听 `127.0.0.1:8080` 的服务，Lima 会自动在宿主机（Host）上建立映射。你只需在 Mac 浏览器输入 `localhost:8080` 即可访问，无需手动配置网络桥接。
- **自动文件共享：** 默认通过 `sshfs`（或更现代的 `virtiofs`）将用户的 `$HOME` 目录挂载到虚拟机中。这意味着你在 Mac 上写的代码，在虚拟机里能直接运行；在虚拟机里生成的产物，在 Mac 文件夹里立刻可见。

###  容器优先（Container-First）

Lima 在设计之初就是为了解决 **Docker Desktop** 的替代问题。

- 它内置了对 `containerd`、`nerdctl`、`Docker` 和 `Podman` 的深度支持。
- 它的理念是提供一个“极简的 Linux 运行时”，专门承载容器负载，而不是作为一个笨重的通用桌面虚拟机。

###  轻量化与高性能（Efficiency）

为了在 ARM (M1/M2/M3) 和 Intel 芯片上都能高效运行，Lima 采取了灵活的后端策略：

- **多后端支持：** 它可以调用 macOS 原生的 **Virtualization.framework**（VZ）以获得极致性能，也可以使用 **QEMU** 来支持跨架构模拟（如在 M1 Mac 上运行 x86_64 镜像）。
- **无 GUI 依赖：** 默认通过命令行操作，没有复杂的图形界面消耗资源，非常符合开发者的工作流。

###  声明式配置（Declarative Configuration）

Lima 遵循“基础设施即代码”的思想：

- 用户通过 **YAML 文件** 定义虚拟机的规格（CPU、内存、磁盘、镜像版本、预装插件）。
- 这种设计使得环境具有**可重复性**，开发者可以将配置文件分享给团队，确保每个人的开发环境完全一致。

------

### Lima 与常见方案的对比

| **特性**     | **Lima**                 | **Docker Desktop**   | **传统虚拟机 (VMware/VirtualBox)** |
| ------------ | ------------------------ | -------------------- | ---------------------------------- |
| **资源占用** | 极低                     | 中/高                | 高                                 |
| **开源程度** | 完全开源 (CNCF)          | 闭源商业             | 混合/闭源                          |
| **文件共享** | 自动、双向               | 自动、受限           | 手动配置共享文件夹                 |
| **主要用途** | 容器开发、Linux 环境模拟 | 容器编排、图形化管理 | 完整操作系统运行                   |

------

### 总结

Lima 的设计理念是 **“低摩擦”**。它移除掉传统虚拟机在网络、存储和交互上的各种屏障，让 Linux 命令行工具、容器和脚本能像 Mac 原生命令一样信手拈来。

## 安装启动linux虚拟机

分为简单的默认或预置方案,和自己写配置方案;

- [`limactl create`](https://lima-vm.io/docs/reference/limactl_create/)
- [`limactl start`](https://lima-vm.io/docs/reference/limactl_start/)
- [`limactl edit`](https://lima-vm.io/docs/reference/limactl_edit/)

### 默认安装

在网络条件好的情况下,启动一个虚拟机很简单,如果指定的虚拟机尚未安装,lima会自动下载并安装,如果所需订单系统已经安装,则可以直接启动;

运行 `limactl start <INSTANCE>` 创建并启动第一个实例。 `<INSTANCE>` 默认名称为"`default`"。

### 定制安装

要从模板“docker”创建实例“default”：

```bash
limactl create --name=default template:docker
limactl start default
```

这两条命令是使用 Lima 快速构建一个**完全兼容 Docker 环境**的 Linux 虚拟机的标准流程。它的核心价值在于通过简单的指令，在 macOS 上搭建出一个性能接近原生的容器开发环境。

以下是命令的详细拆解：

------

###  `limactl create --name=default template:docker`

这一步是**配置阶段**（类似于根据蓝图采购零件）。

- **`limactl create`**: 调用 Lima 的管理工具来创建一个新的虚拟机实例。此时并不会启动虚拟机，**只是生成相关的配置文件**。
- **`--name=default`**: 指定虚拟机的名称为 `default`。
  - *注：* 如果名称设为 `default`，后续运行 `limactl start` 时可以省略名称，非常方便。
- **`template:docker`**: 这是最关键的部分。**Lima 官方维护了一系列 YAML 模板**。
  - **含义：** 使用内置的 Docker 模板。这个模板会自动配置好 Linux 内核、安装 Docker 引擎、配置 `docker-rootless`（无根模式）或标准的 Docker Daemon，并设置好自动端口转发。

------

###  `limactl start default`

这一步是**执行与初始化阶段**（类似于组装并启动机器）。

当你执行这条命令时，Lima 会执行以下一系列复杂的自动化操作：

1. **下载镜像：** 如果本地没有对应的 Linux 发行版镜像（通常是 Ubuntu），它会自动从云端下载。

2. **启动虚拟机：** 启动底层后端（默认在 Mac 上是 QEMU 或 Apple 的 Virtualization.framework）。

3. **挂载文件系统：** 自动将你的 Mac 家目录（`/Users/你的用户名`）挂载到虚拟机内的相同路径，实现**文件实时同步**。

4. **初始化脚本：** 运行模板中定义的脚本，在虚拟机里安装并启动 Docker 服务。

5. **配置网络：** 设置 **用户态网络（slirp）** 和 **自动端口转发**。

6. **展示环境配置：** 启动完成后，它会提示你如何连接 Docker。例如，它会告诉你设置环境变量：

   `export DOCKER_HOST=unix:///Users/yourname/.lima/default/sock/docker.sock`

------

### 命令执行后的实际效果

一旦这两条命令运行成功，你将获得以下体验：

- **无感交互：** 你在 Mac 的终端输入 `docker ps`（前提是已安装 docker 客户端并配置了环境变量），操作的是虚拟机里的 Docker，但感觉就像 Docker 原生装在 Mac 上一样。
- **路径一致：** 你在 Mac 的 `~/Project` 下修改代码，虚拟机里的 Docker 容器可以直接通过 `-v` 挂载对应的路径，因为路径名在两端是完全一致的。
- **端口映射：** 如果你在容器里跑了一个 Nginx 映射到 80 端口，你直接在 Mac 浏览器访问 `localhost:80` 就能看到网页。

### 常用后续操作

- **查看状态：** `limactl list`
- **进入虚拟机命令行：** `lima` (或 `limactl shell default`)
- **停止虚拟机：** `limactl stop default`
- **删除虚拟机：** `limactl delete default`

**小贴士：** 如果你觉得手动配置 `DOCKER_HOST` 麻烦，很多人会配合 `colima` 使用，它是基于 Lima 封装的更简化的工具，只需一个 `colima start` 即可完成上述所有步骤。



## 配置模板

[Templates | Lima](https://lima-vm.io/docs/templates/)

## 安装非默认发行版linux

lima默认使用ubuntu方案,也可以手动指定其他发行版;

在 Lima 中，你可以通过修改模板或在创建时指定参数来自定义资源限制。

安装 Arch Linux 并限制内存为 **2GB** 的操作流程如下(可以分步也可以一行命令)：

### 分布操作

------

####  查找并准备 Arch Linux 模板

Lima 官方提供了一个内置的 Arch Linux 模板。你可以直接基于该模板进行修改。

[lima/templates/_images/archlinux.yaml at master · lima-vm/lima](https://github.com/lima-vm/lima/blob/master/templates/_images/archlinux.yaml)

内容示例:

```yaml
images:
# Try to use yyyyMMdd.REV image if available. Note that yyyyMMdd.REV will be removed after several months.

- location: "https://geo.mirror.pkgbuild.com/images/v20260415.515674/Arch-Linux-x86_64-cloudimg-20260415.515674.qcow2"
  arch: "x86_64"
  digest: "sha256:235506f370236a9688a9f8a4d58de5fd993c864a8af09519496eb8ee63ae0f40"
- location: https://github.com/mcginty/arch-boxes-arm/releases/download/v20220323/Arch-Linux-aarch64-cloudimg-20220323.0.qcow2
  arch: aarch64
  digest: sha512:27524910bf41cb9b3223c8749c6e67fd2f2fdb8b70d40648708e64d6b03c0b4a01b3c5e72d51fefd3e0c3f58487dbb400a79ca378cde2da341a3a19873612be8

# Fallback to the latest release image.
# Hint: run `limactl prune` to invalidate the cache

- location: https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2
  arch: x86_64
```

这部分会被引用于:

[lima/templates/archlinux.yaml at master · lima-vm/lima](https://github.com/lima-vm/lima/blob/master/templates/archlinux.yaml)

```yaml
minimumLimaVersion: 2.0.0

base:
- template:_images/archlinux
- template:_default/mounts
```



####  创建并配置虚拟机

推荐使用声明式的方式，先创建一个配置文件，这样可以精确控制内存。

**步骤 A：生成配置文件**

执行以下命令将默认的 Arch 模板导出为本地文件：

```bash
limactl create --name=arch-box template:archlinux --download-only
```

**步骤 B：修改内存限制**

找到该实例对应的配置文件（通常位于 `~/.lima/arch-box/lima.yaml`），或者在创建时通过编辑模式修改：

```bash
limactl edit arch-box
```

在打开的编辑器中，找到 `cpus` 和 `memory` 字段，将其修改为：



```yaml
# 核心配置：限制内存为 2GB
cpus: 2
memory: "2GiB"
```

####  启动安装流程

保存配置文件后，启动虚拟机：

```bash
limactl start arch-box
```

在启动过程中，Lima 会自动：

1. 下载 Arch Linux 的云镜像（Cloud Image）。
2. 根据你设定的 **2GiB** 限制分配宿主机资源。
3. 配置默认用户和 SSH 密钥。

------

###  通过命令行一行指令完成

如果你不想手动编辑 YAML，也可以利用 `limactl` 的参数直接覆盖默认配置：

```bash
limactl create --name=arch-box \
    --cpus=2 \
    --memory=2GiB \
    template:archlinux
```

###  验证配置

虚拟机启动后，进入系统查看内存分配是否生效：

```bash
lima -n arch-box free -h
```

你应该能在输出的 `Mem:` 一行看到总量接近 **2.0Gi**。

------

### 关键细节说明

- **内存单位：** 在 Lima 的 YAML 配置中，建议使用 `GiB`（二进制单位，即 $1024^3$ 字节）以确保精确。
- **Arch Linux 特点：** 相比于 Docker 模板，`template:archlinux` 是一个纯净的系统镜像。如果你需要在里面跑 Docker，进入 shell 后需要手动执行 `sudo pacman -S docker`。
- **磁盘大小：** 如果 2GB 内存是用于跑重型应用，建议同时也检查 `disk` 参数（默认通常是 100GiB），确保磁盘空间充足。

### 各个虚拟机实例的配置文件(lima.yaml)

不同linux实例都有一个专属的`lima.yaml`,例如:

```bash
# cxxu @ CxxuMac in ~/.lima [11:59:53]
$ fd lima.yaml
alpine/lima.yaml
default/lima.yaml
```

编辑lima虚拟机(实例)配置时需要关闭(stop)实例;

执行`lima edit INSTANCE`命令修改`INSTANCE`对应实例的配置

## 编写配置文件从本地镜像安装

以alpinelinux为例:

```yaml
# 使用本地镜像路径
# 文档: https://lima-vm.io/docs/
# 下载镜像(lima命令可以直接下载镜像,但是国内速度可能会很慢)
# 可以外部手动下载合适的镜像版本,例如从lima文档中参考镜像版本,然后指定本地镜像文件
# 例如使用aria2 下载:
# aria2c -k 16 -s 16 https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/cloud/nocloud_alpine-3.23.3-aarch64-uefi-cloudinit-r0.qcow2
# 基础命令:
# limactl start --name=alpine ~/lima-configs/alpine-local.yaml #
## 其中 --name 是虚拟机实例名称(可以自定义,比如采用系统发行版的名称): [limactl create] Override the instance name
# limactl edit apline #编辑配置
images:
  - location: "~/lima-configs/nocloud_alpine-3.23.3-aarch64-uefi-cloudinit-r0.qcow2"
    # 注意：如果是 Apple Silicon (M1/M2/M3)，arch 必须是 "aarch64"
    arch: "aarch64"

# 设置虚拟机资源
cpus: 4
memory: "1GiB"

# 挂载本地目录
mounts:
  - location: "~"
    writable: true

# 指定操作系统类型，以便 Lima 知道如何进行初始配置
# field `os` must be one of ["Linux" "Darwin" "FreeBSD"]
os: "Linux" 
containerd:
  system: false
  user: false
# 如果你使用的是 ISO，通常需要配置自启动脚本或确保它包含 cloud-init
# Alpine 的官方标准 ISO 不一定带 cloud-init，建议使用带有 "cloud-init" 字样的镜像
```

