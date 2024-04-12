[toc]

## abstract

在PowerShell中挂载镜像文件通常是指挂载ISO或VHD等磁盘镜像到一个虚拟磁盘驱动器，以便能够像操作物理磁盘一样访问其中的内容。以下是几种不同类型的镜像文件在PowerShell中的挂载方式：

## 挂载



### 挂载ISO镜像文件：

[Mount-DiskImage (Storage) | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/storage/mount-diskimage?view=windowsserver2022-ps)

`Mount-DiskImage` 是 PowerShell 中的一个 cmdlet，主要用于挂载 ISO 镜像文件或其他磁盘映像到 Windows 系统中作为一个虚拟磁盘驱动器。它允许用户如同操作物理驱动器那样访问和操作映像文件内的内容，这对于安装软件、从 ISO 进行恢复操作或者处理虚拟硬盘 (VHD 或 VHDX) 文件等情况非常有用。

**基本语法：**

```powershell
Mount-DiskImage -ImagePath "<完整路径到磁盘映像文件>"
```

**参数详解：**

- `-ImagePath`: 必需参数，指定了要挂载的磁盘映像文件的完整路径。例如 `"C:\Downloads\myIsoFile.iso"`。

   ```powershell
   Mount-DiskImage -ImagePath "C:\Downloads\en_sql_server_2017_enterprise_x64_dvd_11293666.iso"
   ```

- `-StorageType`: 可选参数，定义了映像文件的存储类型，默认通常是 `ISO`，但在某些情况下也可能需要指定 `VHD` 或 `VHDX`。

- `-NoDriveLetter`: 可选参数，如果设置，则不会分配驱动器号给挂载的磁盘映像。

- `-PassThru`: 可选参数，当设置时，cmdlet 将返回一个代表已挂载磁盘对象的 `Microsoft.Management.Infrastructure.CimInstance`，这可用于后续的自动化任务，比如获取分配给磁盘的驱动器号。

- `-ReadOnly`: 只读模式挂载映像。

**示例用法：**

1. 挂载 ISO 并获取挂载后的磁盘对象：

   ```powershell
   $mountResult = Mount-DiskImage -ImagePath "C:\path\to\image.iso" -PassThru
   ```

2. 挂载 ISO 并以只读方式挂载：

   ```powershell
   Mount-DiskImage -ImagePath "C:\path\to\image.iso" -ReadOnly
   ```

3. 卸载已挂载的磁盘映像：

   ```powershell
   Dismount-DiskImage -ImagePath "C:\path\to\image.iso"
   ```

在挂载映像之后，你可以在资源管理器中看到新增的虚拟驱动器，可以像对待普通驱动器一样浏览、复制或运行其中的内容。卸载映像后，虚拟驱动器会被移除，系统不再显示该驱动器及其内容。

#### Note

- 使用绝对路径来描述镜像路径,否则可能会报错

  

### 挂载VHD或VHDX虚拟硬盘文件：

[Mount-VHD (Hyper-V) | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/hyper-v/mount-vhd?view=windowsserver2022-ps)

对于虚拟硬盘文件，你可以使用以下命令将其挂载：

```powershell
$disk = Mount-VHD -Path "C:\path\to\your.vhd" -Passthru
Initialize-Disk -Number $disk.DiskNumber -PartitionStyle GPT # 对于新的VHD，可能需要初始化磁盘和创建分区
New-Partition -DiskNumber $disk.DiskNumber -UseMaximumSize | Format-Volume -FileSystem NTFS -Confirm:$false # 创建并格式化新分区
```

## 解挂载@取消已挂载镜像

- [Dismount-DiskImage (Storage) | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/storage/dismount-diskimage?view=windowsserver2022-ps)

分被挂载镜像是ISO还是VHD/VHDX，当你完成操作后，可以通过以下命令来解除挂载：

```powershell
Dismount-DiskImage -ImagePath "C:\path\to\your.iso"
Dismount-VHD -Path "C:\path\to\your.vhd"
```

## 挂载结果检查

- [Get-PSDrive (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/get-psdrive?view=powershell-7.4)

- ```bash
  PS [C:\Users\cxxu] Get-PSDrive -PSProvider FileSystem|?{$_.Name -ne 'Temp'}
  
  Name           Used (GB)     Free (GB) Provider      Root
  ----           ---------     --------- --------      ----
  C                 186.51        756.42 FileSystem    C:\
  ```

  - ```
    ┌─[BAT:100%][MEM:49.18% (15.59/31.70)GB]
    ├─[2024-04-12][15:29:33]
    ├─[cxxu@COLORFULCXXU][C:\Users]
    └─PS>
    ```

    

## 相关命令汇总

```bash
PS BAT [8:45:05] [D:\]
[🔋 100%] MEM:46.28% [14.67/31.70] GB |gcm *mount*|where{$_.CommandType -eq "Cmdlet"}

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Clear-WindowsCorruptMountPoint                     3.0        Dism
Cmdlet          Dismount-AppxVolume                                2.0.1.0    Appx
Cmdlet          Dismount-VHD                                       2.0.0.0    Hyper-V
Cmdlet          Dismount-VMHostAssignableDevice                    2.0.0.0    Hyper-V
Cmdlet          Dismount-WindowsImage                              3.0        Dism
Cmdlet          Mount-AppxVolume                                   2.0.1.0    Appx
Cmdlet          Mount-VHD                                          2.0.0.0    Hyper-V
Cmdlet          Mount-VMHostAssignableDevice                       2.0.0.0    Hyper-V
Cmdlet          Mount-WindowsImage                                 3.0        Dism
```









