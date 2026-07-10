[toc]



## Android 系统对磁盘的使用与管理

Android 基于 Linux 内核，因此底层仍使用块设备、分区、文件系统、挂载点和页缓存等 Linux 机制。

不过，Android 在此基础上增加了**面向移动设备的分区布局、安全校验、应用沙箱、加密存储和升级机制**，对磁盘的管理比传统 Linux **更封闭、自动化程度也更高**。

### 1. 存储设备与块设备

Android 设备通常使用 eMMC 或 UFS 作为内部存储介质。Linux 内核会将其识别为**块设备**，例如：

```text
/dev/block/mmcblk0
/dev/block/sda
```

实际系统中通常通过按分区名称生成的符号链接访问：

```text
/dev/block/by-name/system
/dev/block/by-name/vendor
/dev/block/by-name/userdata
```

这与 Linux 中的 `/dev/sda1`、`/dev/nvme0n1p1` 类似，但 Android 更倾向于使用固定的分区名称，而不是依赖设备编号，以适应不同厂商和不同存储控制器。

---

### 2. Android 的分区结构

传统 Linux 服务器或桌面系统通常只需要根分区、`/boot`、交换分区以及可选的 `/home`、`/var` 等分区。Android 的分区则更多，每个分区通常承担明确的系统职责。

常见分区包括：

| 分区          | 主要用途                         |
| ------------- | -------------------------------- |
| `boot`        | Linux 内核、ramdisk 和启动参数   |
| `vendor_boot` | 与厂商相关的启动 ramdisk         |
| `system`      | Android Framework 和系统应用     |
| `vendor`      | 芯片厂商驱动、HAL 和配置         |
| `product`     | 产品级应用和配置                 |
| `system_ext`  | 系统扩展组件                     |
| `odm`         | 设备制造商相关配置和组件         |
| `userdata`    | 用户数据和应用数据               |
| `metadata`    | 加密、虚拟 A/B 和快照相关元数据  |
| `recovery`    | 恢复系统，部分设备已合并到 boot  |
| `misc`        | 启动模式、恢复指令等少量控制信息 |
| `super`       | 动态分区的容器                   |

较新的 Android 设备通常采用“动态分区”。此时，`system`、`vendor`、`product` 等不一定是物理 GPT 分区，而是位于 `super` 分区内部的逻辑分区。

这种方式类似 Linux 中的 LVM：底层先划出一个较大的存储池，再从中创建多个逻辑卷。区别在于 Android 动态分区主要服务于系统镜像布局和 OTA 升级，并不是提供给用户自由调整的通用卷管理机制。

---

### 3. 文件系统与挂载

Android 常用的文件系统主要有：

* `ext4`：成熟、稳定，广泛用于系统和用户数据分区。
* `f2fs`：针对闪存优化，常用于 `userdata` 分区。
* `EROFS`：只读压缩文件系统，部分设备用于系统分区。
* `vfat`、`exFAT`：主要用于外置 SD 卡或移动存储设备。

Android 的挂载配置通常由设备的 `fstab` 文件定义，例如：

```text
/dev/block/by-name/userdata /data f2fs noatime,nosuid,nodev ...
```

与 Linux 的 `/etc/fstab` 类似，Android 的 fstab 也描述块设备、挂载点、文件系统和挂载选项。但 Android 还会加入很多专用参数，例如：

* `wait`：等待块设备出现；
* `check`：挂载前检查文件系统；
* `formattable`：挂载失败时允许格式化；
* `fileencryption`：启用文件级加密；
* `quota`：启用用户和项目配额；
* `logical`：表示动态逻辑分区；
* `avb`：启用 Android Verified Boot 校验。

Android 的早期挂载通常由 `init` 和 `fs_mgr` 完成，而可移动存储设备则主要由 `vold` 管理。

相比之下，普通 Linux 系统主要通过 systemd、mount、udev、udisks 等组件完成相应工作。

---

### 4. 系统分区以只读方式使用

传统 Linux 的根文件系统一般是可写的，管理员可以直接修改 `/usr`、`/etc` 等目录。Android 的系统分区通常以只读方式挂载，包括：

```text
/system
/vendor
/product
/system_ext
```

这样做主要有三个原因：

1. 防止系统组件被意外修改；
2. 保证系统镜像可以进行完整性校验；
3. 确保 OTA 增量升级有稳定的基础版本。

Android 通过 AVB，也就是 Android Verified Boot，对启动链和系统分区进行校验。底层通常使用 dm-verity 检查文件系统数据块。一旦系统分区内容被未授权修改，设备可能拒绝启动，或者显示系统完整性异常。

Linux 服务器也可以使用只读根文件系统、dm-verity 或 Secure Boot，但这些通常是可选配置；在 Android 设备中，它们往往是标准安全模型的一部分。

---

### 5. `/data` 分区与应用数据

Android 的大部分可变数据都保存在 `/data` 分区中，包括：

```text
/data/user/0/<package-name>
/data/app
/data/system
/data/misc
/data/media
```

其中：

* `/data/app` 保存用户安装的 APK 和相关文件；
* `/data/user/0` 保存主用户的应用私有数据；
* `/data/system` 保存系统服务状态和系统配置；
* `/data/media` 保存用户可见的图片、视频、下载文件等；
* `/data/misc` 保存网络、密钥和部分系统组件的数据。

Android 为每个应用分配独立的 Linux UID。例如：

```text
u0_a123
```

应用私有目录的所有者就是该应用对应的 UID，其他普通应用不能直接访问。

这与 Linux 的多用户权限模型相似，但用途有所不同：

* Linux 通常为“人类用户”分配 UID；
* Android 主要为“应用程序”分配 UID；
* Android 的每个应用都可以看作一个受限制的 Linux 用户；
* Android 还使用 SELinux 对应用访问进行强制访问控制。

因此，Android 的磁盘隔离并不只依赖文件的 `rwx` 权限，还同时依赖 UID、SELinux、挂载命名空间、应用权限和系统服务接口。

---

### 6. 内部共享存储并非独立分区

用户看到的“内部存储空间”通常表现为：

```text
/storage/emulated/0
/sdcard
```

但它一般不是真正独立的 FAT 或 ext4 分区，而是 `/data/media/0` 的受控视图：

```text
/data/media/0
```

Android 通过 FUSE、`sdcardfs` 或系统存储服务，将该目录以不同权限重新暴露给应用。

因此：

```text
/storage/emulated/0
```

和：

```text
/data/media/0
```

可能指向相同的底层数据，但应用所看到的访问权限不同。

传统 Linux 通常会直接将一个磁盘分区挂载到 `/home`、`/mnt/data` 或 `/media`。Android 则在同一文件系统上构造“模拟外部存储”，主要是为了：

* 支持多用户；
* 控制应用能够看到的文件；
* 兼容历史上的 SD 卡路径；
* 在不使用 FAT 文件系统的情况下支持 Linux 权限、加密和配额。

---

### 7. Scoped Storage

早期 Android 应用在获得存储权限后，可以较自由地访问共享存储中的文件。新的 Android 版本采用 Scoped Storage，即分区存储。

应用通常只能直接访问：

* 自己的私有目录；
* 自己在共享存储中创建的媒体文件；
* 用户通过系统文件选择器授权的文件；
* 通过 MediaStore 等系统接口访问的公共媒体内容。

例如，应用不应再随意遍历整个：

```text
/storage/emulated/0
```

而应通过以下接口访问数据：

* `MediaStore`：图片、音频和视频；
* Storage Access Framework：用户主动选择的文件或目录；
* 应用专属外部目录；
* 系统提供的内容 URI。

传统 Linux 中，只要进程拥有足够的文件权限，就可以直接使用路径访问文件。Android 则把“路径访问”进一步转换为“系统授权后的内容访问”，从而降低应用批量读取用户文件的风险。

---

### 8. 磁盘加密

Android 普遍使用文件级加密，即 File-Based Encryption，简称 FBE。

FBE 可以针对不同目录或文件使用不同密钥。Android 通常将数据分成两类：

* Device Encrypted，简称 DE：设备启动后、用户解锁前即可访问；
* Credential Encrypted，简称 CE：必须在用户输入密码、PIN 或完成生物识别解锁后才能访问。

相关目录通常具有如下逻辑关系：

```text
/data/user_de/<user-id>
/data/user/<user-id>
```

这种设计支持 Direct Boot。设备重启但尚未解锁时，闹钟、电话和部分系统服务仍可以访问 DE 数据，而普通应用的敏感数据仍保持锁定。

Linux 传统上常使用 dm-crypt/LUKS 对整个磁盘或分区加密。整个加密卷解锁后，其中所有文件通常都可访问。Android 的文件级加密粒度更细，可以按用户、目录和启动阶段管理密钥。

---

### 9. 多用户存储

Android 支持主用户、访客用户、受限用户和工作资料等逻辑用户。不同用户的应用数据彼此隔离，例如：

```text
/data/user/0
/data/user/10
/data/media/0
/data/media/10
```

这里的用户 0 通常是设备的主用户，用户 10 可能是后续创建的用户。

Android 用户与底层 Linux UID 并不是简单的一一对应关系。Android 会将“用户编号”和“应用编号”组合成最终的 Linux UID，从而保证：

* 同一个应用在不同 Android 用户下拥有不同身份；
* 不同用户的数据相互隔离；
* 同一个 APK 可以在多个用户空间中分别保存数据。

传统 Linux 多用户系统也使用 UID 隔离用户目录，但 Android 在此基础上又叠加了应用维度。

---

### 10. 外置 SD 卡和 USB 存储

Android 的可移动存储主要由 `vold` 守护进程管理。它负责：

* 检测 SD 卡和 USB 存储设备；
* 识别文件系统；
* 执行挂载和卸载；
* 创建应用可见的存储路径；
* 根据用户和应用身份设置访问权限；
* 处理可移除存储设备状态变化。

Android 对外置存储主要有两种使用方式。

#### 便携式存储

SD 卡作为普通移动存储使用，通常采用 exFAT 或 FAT 文件系统。它可以在手机、计算机和其他设备之间移动。

#### 内部存储扩展

部分设备支持 Adoptable Storage，即把 SD 卡格式化并加密后作为内部存储的一部分使用。采用这种方式后，SD 卡会与当前设备绑定，通常不能再直接插入其他设备读取。

传统 Linux 中，插入存储设备后一般由 udev 和桌面环境自动挂载，管理员也可以直接执行 `mount`。Android 普通应用不能自行挂载块设备，必须通过系统服务完成。

---

### 11. 磁盘空间统计与配额

Android 不仅通过文件系统统计剩余空间，还可以启用用户配额和项目配额，对不同应用及不同类型的数据进行统计。

应用占用空间通常分为：

* APK 和安装文件；
* 应用私有数据；
* 缓存；
* 编译生成的代码；
* 外部存储中的应用专属数据。

系统可以通过 `StorageStatsManager` 等接口查询这些信息。

Android 允许系统在空间不足时删除应用缓存，但应用不能假设缓存文件会永久存在。常见缓存目录包括：

```text
/data/user/0/<package-name>/cache
```

传统 Linux 也支持用户配额和组配额，但通常需要管理员显式配置。Android 的配额更偏向应用级统计和自动空间管理。

需要注意，界面中显示的“应用大小”可能不完全等同于执行 `du` 得到的结果，因为系统还可能计算共享文件、硬链接、稀疏文件、编译产物及配额统计数据。

---

### 12. 闪存维护

移动设备使用 NAND 闪存，不能像机械硬盘那样直接覆盖数据。Android 需要配合闪存控制器进行垃圾回收和块整理。

常见机制包括：

* TRIM 或 DISCARD：通知存储设备哪些数据块已经无效；
* `fstrim`：定期回收未使用的文件系统块；
* F2FS 垃圾回收；
* 写放大控制；
* 空闲空间保留；
* I/O 调度和后台维护任务。

Android 通常在设备空闲、充电或满足特定条件时执行存储维护，以降低对性能和电池的影响。

Linux 也使用 `fstrim` 和 discard，但服务器通常由管理员或 systemd 定时器控制；Android 则更多由系统框架统一调度。

---

### 13. A/B 分区和 OTA 升级

许多 Android 设备采用 A/B 启动槽，例如：

```text
boot_a
boot_b
vendor_boot_a
vendor_boot_b
```

设备当前从 A 槽启动时，OTA 可以在后台更新 B 槽。更新完成后，重启并切换到 B 槽。如果新系统无法正常启动，还可以回滚到旧槽。

较新的设备通常结合动态分区和虚拟 A/B 技术。系统升级时不一定完整复制所有分区，而是通过快照和写时复制记录变化。

这与 Linux 发行版中通过包管理器直接替换系统文件的方式明显不同。Android OTA 更接近不可变系统镜像的整体升级：

* 系统分区通常只读；
* 更新以镜像或块级差异形式提供；
* 更新前后进行完整性验证；
* 支持启动失败回滚；
* 普通用户和应用不能修改升级目标。

Linux 也可以借助 OSTree、Btrfs 快照或双系统分区实现类似功能，但传统发行版通常仍以文件或软件包升级为主。

---

## Android 与传统 Linux 的主要对比

| 方面         | Android                               | 传统 Linux                    |
| ------------ | ------------------------------------- | ----------------------------- |
| 底层模型     | Linux 块设备和 VFS                    | Linux 块设备和 VFS            |
| 分区目的     | 系统组件、厂商组件、安全启动和 OTA    | 根目录、用户数据、服务数据    |
| 根文件系统   | 通常只读并进行完整性验证              | 通常可写                      |
| 存储管理主体 | `init`、`fs_mgr`、`vold` 和 Framework | systemd、mount、udev、udisks  |
| 权限主体     | 主要以应用 UID 为中心                 | 主要以用户和服务 UID 为中心   |
| 强制访问控制 | 通常强制启用 SELinux                  | 取决于发行版和配置            |
| 用户文件访问 | Scoped Storage、MediaStore、内容 URI  | 主要通过文件路径和 Unix 权限  |
| 加密         | 文件级加密，区分解锁前后数据          | 常见为 LUKS/dm-crypt 块级加密 |
| 系统升级     | 镜像式 OTA、A/B、快照                 | 软件包升级或文件替换          |
| 多用户隔离   | 用户与应用两个维度组合隔离            | 主要按用户 UID 隔离           |
| 外置磁盘挂载 | 由系统服务集中控制                    | 用户或管理员可直接挂载        |
| 空间回收     | 应用缓存管理、配额、系统自动清理      | 通常由用户或管理员维护        |

总体而言，Android 并没有抛弃 Linux 的磁盘管理方式，而是把 Linux 的块设备、文件系统、挂载和权限机制封装在更严格的系统策略之下。传统 Linux 强调管理员对文件系统的直接控制；Android 更强调系统镜像不可变、应用数据隔离、用户隐私、启动完整性和无感 OTA 升级。