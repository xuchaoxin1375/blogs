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

PowerShell

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

