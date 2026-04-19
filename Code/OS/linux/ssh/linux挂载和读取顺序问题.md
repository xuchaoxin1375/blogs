[toc]

## abstract

硬盘挂载顺序和列出内容的操作顺序问题.

下面是一个看起来非常矛盾的现象，但它通常有一个非常明确的解释。

```bash
[root@sysrescue /mnt/recoversys]# mount /dev/nvme0n1p4 /mnt/recoversys
[root@sysrescue /mnt/recoversys]# ls
[root@sysrescue /mnt/recoversys]# ls /mnt/recoversys
bin    data       etc   lib32   lost+found  opt    repos  sbin  sys                          update_repos.sh  www
boot   deploy.sh  home  lib64   media       patch  root   snap  tmp                          usr
cdrom  dev        lib   libx32  mnt         proc   run    srv   update_nginx_vhosts_conf.sh  var

[root@sysrescue /mnt/recoversys]# pwd
/mnt/recoversys

[root@sysrescue /mnt/recoversys]# cd ..
[root@sysrescue /mnt]# cd recoversys/
[root@sysrescue /mnt/recoversys]# ls
bin    data       etc   lib32   lost+found  opt    repos  sbin  sys                          update_repos.sh  www
boot   deploy.sh  home  lib64   media       patch  root   snap  tmp                          usr
cdrom  dev        lib   libx32  mnt         proc   run    srv   update_nginx_vhosts_conf.sh  var
```



简单直接的回答是：**这不正常，说明你当前的 shell 环境对目录内容的认知出现了偏差，或者你挂载的分署层级超出了你的预期。**

### 为什么会出现这种“空”与“不空”的矛盾？

当你直接输入 `ls` 看到的是空的，而输入 `ls /mnt/recoversys` 却看到了完整的文件系统，通常由以下几种原因造成：

#### 1. 挂载顺序与“遮盖”问题 (最常见)

如果你先进入了 `/mnt/recoversys` 目录，**然后**才执行了挂载（mount）操作，就会发生这种情况。

- **现象：** 你的 shell 进程仍然握着挂载前的那个“空目录”的句柄。

- **证据：** 即使你挂载了硬盘到这个位置，当前的 shell 仍然停留在旧的、空的 inode 上。

- **解决方法：** 退出该目录再重新进入：

  Bash

  ```
  cd ..
  cd recoversys
  ls
  ```

#### 2. 路径别名或符号链接 (Symbolic Link)

你当前所在的 `/mnt/recoversys` 可能并不是你认为的那个物理路径。

- 你可以输入 `pwd -P`（物理路径）来查看你实际所在的位置。
- 如果 `/mnt/recoversys` 是一个指向其他地方的软链接，而你刚才挂载设备时使用的是真实的物理路径，就会导致你在进入链接路径时看不到新挂载的内容。

#### 3. 执行权限或特殊文件系统

虽然概率较低，但如果目录设置了特殊的权限，或者你处于一个受限的 Shell（Chroot 环境）中，可能会导致 `ls`（默认当前目录）和 `ls /path` 结果不一致。

------

### 建议的操作步骤

为了确认系统的真实状态，请按顺序执行以下命令：

1. **刷新目录引用：**

   Bash

   ```
   cd / && cd /mnt/recoversys && ls
   ```

   （这是解决该问题最有效的“重启”方式。）

2. **检查挂载情况：**

   Bash

   ```
   mount | grep recoversys
   ```

   确认设备是否真的挂载到了这个点上。

3. **对比目录内容：**

   Bash

   ```
   ls -id .
   ls -id /mnt/recoversys
   ```

   如果这两个命令输出的 **inode 号**（第一列数字）不一样，说明你现在的 `.`（当前目录）和物理上的 `/mnt/recoversys` 根本不是同一个东西。

**总结：** 这种情况通常发生在**先 `cd` 进目录，后 `mount` 设备**的情况下。只要 `cd /` 出来再回去，现象就会消失。

