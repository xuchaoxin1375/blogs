[toc]



[WSL 的基本命令 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands)

1. [安装](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#install)
2. [列出可用的 Linux 发行版](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#list-available-linux-distributions)
3. [列出已安装的 Linux 发行版](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#list-installed-linux-distributions)
4. [将 WSL 版本设置为 1 或 2](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#set-wsl-version-to-1-or-2)
5. [设置默认 WSL 版本](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#set-default-wsl-version)
6. [设置默认 Linux 发行版](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#set-default-linux-distribution)
7. [将目录更改为主页](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#change-directory-to-home)
8. [通过 PowerShell 或 CMD 运行特定的 Linux 发行版](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#run-a-specific-linux-distribution-from-powershell-or-cmd)
9. [更新 WSL](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#update-wsl)
10. [检查 WSL 状态](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#check-wsl-status)
11. [检查 WSL 版本](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#check-wsl-version)
12. [Help 命令](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#help-command)
13. [以特定用户的身份运行](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#run-as-a-specific-user)
14. [更改发行版的默认用户](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#change-the-default-user-for-a-distribution)
15. [关闭](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#shutdown)
16. [Terminate](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#terminate)
17. [标识 IP 地址](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#identify-ip-address)
18. [导出分发版](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#export-a-distribution)
19. [导入分发版](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#import-a-distribution)
20. [就地导入发行版](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#import-a-distribution-in-place)
21. [注销或卸载 Linux 发行版](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#unregister-or-uninstall-a-linux-distribution)
22. [装载磁盘或设备](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#mount-a-disk-or-device)
23. [卸载磁盘](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#unmount-disks)
24. [已弃用的 WSL 命令](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands#deprecated-wsl-commands)

## 列出已安装的 Linux 发行版

```powershell
wsl --list --verbose
```

查看安装在 Windows 计算机上的 Linux 发行版列表，其中包括状态（发行版是正在运行还是已停止）和运行发行版的 WSL 版本（WSL 1 或 WSL 2）。 [比较 WSL 1 和 WSL 2](https://learn.microsoft.com/zh-cn/windows/wsl/compare-versions)。 此命令也可输入为：`wsl -l -v`。 可与 list 命令一起使用的其他选项包括：`--all`（列出所有发行版）、`--running`（仅列出当前正在运行的发行版）或 `--quiet`（仅显示发行版名称）。

```powershell

#⚡️[Administrator@CXXUDESK][~\Desktop][22:57:15][UP:3.17Days]
PS> wsl --list --verbose
  NAME            STATE           VERSION
* Ubuntu-24.04    Stopped         2
  Ubuntu          Stopped         2

#⚡️[Administrator@CXXUDESK][~\Desktop][22:57:23][UP:3.17Days]
PS> wsl --list --running
没有正在运行的分发。
```

## wsl 导出备份和导入备份

### 查看当前可用的wsl

```powershell
PS> wsl -l -v
  NAME      STATE           VERSION
* Ubuntu    Running         2
```

上面的例子说明当前可以备份的wsl系统是`Ubuntu`,如果是其他名字,则完整的拷贝下来

### 备份

可以首先想好要将备份存放到哪个目录,然后创建对应的目录(直接在wsl 中指定保存目录的话,如果中间目录不存在,会执行失败)

```powershell
PS> mkdir C:/wsl-imgs/

    Directory: C:\

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----           2025/10/3    17:43                wsl-imgs

```

或者可以像保存到本地,然后再将文件移动到指定目录中

### 快速导出保存为tar文件

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][17:43:51][UP:0.03Days]
PS> wsl --export Ubuntu C:/wsl-imgs/Ubuntu24.04-20251003.tar
正在导出，这可能需要几分钟时间。 (1444 MB)

操作成功完成。
```

如果想要节约空间,也可以先快速导出为tar格式,然后手动压缩成其他格式,甚至在wsl提供的几个基本压缩格式之外的格式,就像压缩一个普通文件一样节约空间,比如使用7z,tar,zstd

例如我使用快速压缩的zstd来节约备份占用的空间(需要zstd命令可用,推荐的zstd参数:`-5 -T0`然后跟上要压缩的tar文件,输出文件可以用`-o`指定,否则输出到当前目录)

```powershell
zstd -5 -T0 .\Ubuntu24.04-20251003.tar
.\Ubuntu24.04-20251003.tar : 29.71%   (  1.41 GiB =>    430 MiB, .\Ubuntu24.04-20251003.tar.zst)
```

这个过程很快,并且压缩效果很不错,但是导入备份的时候,尤其是在另一个设备上导入时,需要手动解压zst格式(较新版本的7z和windows系统都可以解压zstd格式的压缩包)

### 节约空间导出

指定导出格式`--format`为`tar.gz`或者`tar.xz`,直接一步到位,但是速度比较慢

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][17:44:07][UP:0.03Days]
PS> wsl --export Ubuntu C:/wsl-imgs/Ubuntu24.04-20251003.tar.gz --format tar.gz
正在导出，这可能需要几分钟时间。 (461 MB)

操作成功完成。
```



