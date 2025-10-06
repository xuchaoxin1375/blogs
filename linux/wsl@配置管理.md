[toc]



[WSL 中的高级设置配置 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/wsl/wsl-config#wslconfig)

```cmd
  --manage <Distro> <Options...>
        更改发行版特定选项。

        选项:
            --move <Location>
                将分发版移到新位置。

            --set-sparse, -s <true|false>
                将发行版的 vhdx 设置为稀疏，从而允许自动回收磁盘空间。

            --set-default-user <Username>
                设置分发版的默认用户。

            --resize <MemoryString>
                将分发版的磁盘大小调整为指定大小。
```

### 修改wsl指定发行版的默认启动用户

```powershell
# [cxxu@CXXUFIREBAT][~\Desktop][19:44:15] PS >
 wsl --manage archlinux --set-default-user cxxu
操作成功完成。
```

