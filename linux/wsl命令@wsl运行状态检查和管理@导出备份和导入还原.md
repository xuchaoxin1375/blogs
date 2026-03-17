[toc]

## abstract

[WSL 的基本命令 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/basic-commands)

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

```cmd
用于在适用于 Linux 的 Windows 子系统中管理分发版的参数:

    --export <Distro> <FileName> [选项]
        将分发版导出到 tar 文件。
        文件名可以是 - for stdout。

        选项:
            --format <Format>
                指定导出格式。支持的值: tar、tar.gz、tar.xz、vhd。

    --import <Distro> <InstallLocation> <FileName> [选项]
        将指定的 tar 文件作为新分发版导入。
        文件名可以是 - for stdin。

        选项:
            --version <Version>
                指定要用于新分发的版本。

            --vhd
                指定所提供的文件是 .vhdx 文件，而不是 tar 文件。
                此操作在指定的安装位置创建 .vhdx 文件的副本。

    --import-in-place <Distro> <FileName>
        将指定的 .vhdx 文件作为新分发版导入。
        必须使用 ext4 文件系统类型设置此虚拟硬盘的格式。
```



### 查看当前可用的wsl

```powershell
PS> wsl -l -v
  NAME      STATE           VERSION
* Ubuntu    Running         2
```

上面的例子说明当前可以备份的wsl系统是`Ubuntu`,如果是其他名字,则完整的拷贝下来

### 导出备份

可以首先想好要将备份存放到哪个目录,然后创建对应的目录(直接在wsl 中指定保存目录的话,如果中间目录不存在,会执行失败)

```powershell
PS> mkdir C:/wsl-imgs/

    Directory: C:\

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----           2025/10/3    17:43                wsl-imgs

```

或者可以像保存到本地,然后再将文件移动到指定目录中

### 检查状态

确保需要导出的wsl系统已经处于停止状态`stopped`,然后再执行导出命令

```cmd
 wsl -l -v
  NAME         STATE           VERSION
* archlinux    Stopped         2
  Alpine       Stopped         2
  ubuntu24     Stopped         2
```



#### 快速导出保存为tar文件

导出命令:`wsl --export <Distro> <FileName> [选项]`,要导出的**发行版名称**(通过`-l`可以查看可用名字)和wsl**保存路径(文件名)**两个参数必须指定.

例如:

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][17:43:51][UP:0.03Days]
PS> wsl --export Ubuntu C:/wsl-imgs/Ubuntu24.04-20251003.tar
正在导出，这可能需要几分钟时间。 (1444 MB)

操作成功完成。
```

```cmd
wsl --export archlinux C:/wsl-imgs/archlinux20260317.tar
```



#### 节约空间导出(带压缩导出)

指定导出格式`--format`为`tar.gz`或者`tar.xz`,直接一步到位,但是速度比较慢

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][17:44:07][UP:0.03Days]
PS> wsl --export Ubuntu C:/wsl-imgs/Ubuntu24.04-20251003.tar.gz --format tar.gz
正在导出，这可能需要几分钟时间。 (461 MB)

操作成功完成。
```



如果想要节约空间,也可以先快速导出为tar格式,然后手动压缩成其他格式,甚至在wsl提供的几个基本压缩格式之外的格式,就像压缩一个普通文件一样节约空间,比如使用7z,tar,zstd

#### 打包为zst格式

例如我使用快速压缩的zstd来节约备份占用的空间(需要zstd命令可用,推荐的zstd参数:`-5 -T0`然后跟上要压缩的tar文件,输出文件可以用`-o`指定,否则输出到当前目录)

```powershell
zstd -5 -T0 .\Ubuntu24.04-20251003.tar
```

这个过程很快,并且压缩效果很不错,但是导入备份的时候,尤其是在另一个设备上导入时,需要手动解压zst格式(较新版本的7z和windows系统都可以解压zstd格式的压缩包)

### 导入恢复

命令用法` wsl --import <Distro> <InstallLocation> <FileName> [选项]`

> 前三个参数必写,且`InstallLocation`应该是一个空目录或者尚不存在的目录(wsl会自动创建),否则会提示
>
> `提供的安装位置已在使用中。错误代码: Wsl/Service/RegisterDistro/ERROR_FILE_EXISTS`

例如:

```bash
 wsl --import ubuntu24 C:\wsl\ubuntu .\ubuntu\Ubuntu24.04-20251003.tar

```

