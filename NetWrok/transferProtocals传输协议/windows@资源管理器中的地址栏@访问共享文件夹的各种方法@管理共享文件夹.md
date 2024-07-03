[toc]



## 资源管理器中的地址栏

### 认识资源管理器

- 资源管理器或者文件管理是操作系统中最常用的功能之一,无论使用第三方文件管理器还是系统自带的文件管理器,但一般以自带的为主,自带的资源管理器是很多应用让用户选择目录或文件要调用的跳转接口

- 资源管理器可以做很多的自定义设置,甚至可以安装一些插件扩展功能,比如为win10系统安装Clover、ExTab、百叶窗、QTTabBar 和 TotalCommander等di'san'fang
- [Win10/Win11学院：玩转 Windows 文件资源管理器 - IT之家 (ithome.com)](https://www.ithome.com/0/589/240.htm)

### 打开地址栏的快捷键

您可以使用鼠标,但是快捷键会更加便捷

在Windows系统中，可以使用快捷键`windows+E`打开**资源管理器**,并且可以用以下快捷键快速打开资源管理器（File Explorer）的**地址栏**。选择其中未被其他应用冲突或占用的键：

1. **`Alt + D`**：这是最常用的快捷键，能够直接将焦点切换到地址栏。
2. **`Ctrl + L`**：同样可以将焦点切换到地址栏。
3. **`F4`**：此键不仅可以将焦点切换到地址栏，还会显示地址栏的历史记录。

通过这些快捷键，你可以快速地输入或编辑文件路径，从而提高工作效率。

### 地址栏可以访问什么

在Windows资源管理器的地址栏中，您可以输入多种格式的内容：

1. 文件路径：如 `C:\Users\YourName\Documents`

2. UNC路径：如 `\\ServerName\SharedFolder`

3. 网络地址：如 `ftp://ftp.example.com` 或 `http://www.example.com`

4. 特殊文件夹名称：如 `Downloads, Desktop, Documents,Network`

5. Shell命令：如 `shell:RecycleBinFolder`（打开回收站）

6. GUID路径：如 `::{20D04FE0-3AEA-1069-A2D8-08002B30309D}`（打开"我的电脑"）

在命令行中，有类似的命令可以实现相同的功能：

1. 打开文件夹：

   ```
   start explorer C:\Users\YourName\Documents
   ```

2. 打开特殊文件夹：

   ```
   start shell:Downloads
   ```

3. 使用GUID打开特定位置：

   ```
   explorer shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}
   ```

4. 打开网络位置：

   ```
   start \\ServerName\SharedFolder
   ```

5. 打开网页：

   ```
   start http://www.example.com
   ```

这些命令可以在命令提示符（cmd）或PowerShell中使用。它们提供了与资源管理器地址栏类似的灵活性，允许您快速访问各种本地和网络资源。



## 访问共享文件夹👺

### UNC路径

介绍访问方法前,先提一下UNC路径

[Windows 系统中的文件路径格式 | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/standard/io/file-path-formats#unc-paths)

例如,访问`redmibookpc`的`C:`盘的UNC网络路径:`\\redmibookpc\C$`,这里用到网络发现功能,即便该`C:`没有被共享,但是如果有凭证就可以访问

### 资源管理器打开共享文件夹

本机外的其他windows用户访问smb服务器的方法

首先要确定被访问的共享文件夹在网络中的哪一台机器,我们称这个被访问的机器为`server`,它可以是**计算机名**,也可以是一个**ip地址**(前者需要网络内的机器相互都已经打开网络发现,一般android设备上相关软件可以直接扫描已经打开的网络发现主机,并且用计算机名标识出来);

其中查询计算机名和ip地址的方式很简单,到系统信息或设置里面查看,或者自行搜索详细步骤

- 对于windows系统,访问共享文件夹(smb服务器,不需要写协议名,直接用`\\`代替表示smb协议)
  1. 可以按下**win+r**启动"运行"窗口(Run),输入`\\server\FolderName`格式的链接回车运行
  2. 或者在命令行中执行`start \\server\FolderName`的形式来访问
  3. 如果启用了**网络发现**,则可以在资源管理器的网络页面中找到相应的计算机图标
     - 如果您发现网络页是空的或者没有想要的计算机设备图标,请重新检查共享文件夹计算机是否开启网络发现(可能会被以外关闭,比如第三方软件,尤其是优化管家卫士类)
     - 但是某些windows版本在这方面存在bug,可能即便在同一网络内的设备即便都开启了网络发现也不保证移动会出现在资源管理器网络页面中,尽管直接用计算机名可以访问到
  4. 使用`net use`命令或`New-PSDrive`挂载共享文件夹为(网络)驱动器
  5. 资源管理器中提供的GUI方式添加网络位置或者映射共享文件夹,在弹出窗口的地址栏中输入`\\Server\FolderName`来挂载
  6. 资源管理器中的地址栏中输入`\\server\FolderName`来访问
- 上述几种方式最终都是在**资源管理器**内浏览共享文件夹的(如果需要输入凭据请输入验证再访问)
- 有些方法可能会提示您是否记住凭证或自动登录,根据需要勾选;或者可以创建快捷方式以便后续访问;命令行有的有永久化选项或者记住凭证的参数



### 纯命令行方式访问共享文件夹

- 访问共享文件夹的方法处理借助资源管理器,还可以仅在命令行中进行访问操作

- 参考powershell中提供的各种`Cmdlet`,或者用上节介绍的挂载方法挂载共享文件夹为盘符后,`cmd`也可以访问

- 可以操作目录的命令通常也可以用于共享文件夹的UNC目录路径

  - `ls \\server\sharefolder`(powershell)

  - 或者`dir \\server\share`(cmd)这类命令

- 以powershell为主,我们可以用`New-SmbMapping`来将共享文件夹挂载到`powershell`(资源管理器中可能无法直接查看挂载结果,但是net use 和 cmd 等工具中可见),用一个powershell可见的盘符来代替长串的路径

- 比如,您将某个共享文件夹`\\server\share`用`New-SmbMapping`挂载为`T:`盘符,当您在命令行中使用`explorer T:`,这会调用资源管理器打开`T`盘内容,此时`T`盘就被**临时**挂载到了资源管理器中

- 若要下次开机后自动搜索并挂载,使用永久选项:`-Persistent $true`

- 若要使关机之前稳定存在于资源管理器中,则需要手动彻底重启资源管理器(如果使用了永久选项,则重启后也自动挂载到资源管理器):

  ```powershell
  stop-process -Name explorer ; explore
  ```

例

```powershell
PS> new-smbmapping -LocalPath 'T:' -RemotePath '\\redmibookpc\share' -Persistent $true

Status Local Path Remote Path
------ ---------- -----------
OK     T:         \\redmibookpc\share

```

驱动器列表检查

用`net use`可以检查到

```
PS> net use
New connections will be remembered.


Status       Local     Remote                    Network

-------------------------------------------------------------------------------
OK           Q:        \\redmibookpc\share       Microsoft Windows Network
OK           R:        \\redmibookpc\share       Microsoft Windows Network
OK           T:        \\redmibookpc\share       Microsoft Windows Network
The command completed successfully.
```

用`Get-PSDrive`也可以检测到

```powershell
PS> Get-PSDrive

Name           Used (GB)     Free (GB) Provider      Root                                               CurrentLocation
----           ---------     --------- --------      ----                                               ---------------
Alias                                  Alias
C                 323.03        619.91 FileSystem    C:\                                             Users\cxxu\Desktop
Cert                                   Certificate   \
Env                                    Environment
Function                               Function
HKCU                                   Registry      HKEY_CURRENT_USER
HKLM                                   Registry      HKEY_LOCAL_MACHINE
Q                                      FileSystem    \\redmibookpc\share
R                 114.22        361.73 FileSystem    \\redmibookpc\share…
T                 114.22        361.73 FileSystem    \\redmibookpc\share…
Temp              323.03        619.91 FileSystem    C:\Users\cxxu\AppData\Local\Temp\
Variable                               Variable
WSMan                                  WSMan

```



## 共享文件夹相关操作

### 查看所有已经共享的文件夹👺

- 有如下方式可以检查

  - 在资源管理器中的地址栏输入`\\localhost`
  - 或者命令行中输入`start \\localhost`

- 也可以使用命令行查看(这种方法不再维护)

  - ```powershell
    PS> net share
    
    Share name   Resource                        Remark
    
    -------------------------------------------------------------------------------
    IPC$                                         Remote IPC
    share        C:\share                        ColorfulCxxuShare
    The command completed successfully.
    ```

    

### 停止某个文件的共享

- 方法0:使用命令行停止/移除共享文件

  - 可以使用`net share`来移除,命令行格式为:

    - ` NET SHARE sharename \\computername /DELETE` 其中小写单词需要替换为具体的值

  - 检查文件夹共享情况

    ```powershell
    PS>  net share
    
    Share name   Resource                        Remark
    
    -------------------------------------------------------------------------------
    IPC$                                         Remote IPC
    DemoShare    C:\sharePlus                    demo share
    DemoShareFC  C:\share1                       share folder grant everyone
    share        C:\share                        ColorfulCxxuShare
    Users        C:\Users
    The command completed successfully.
    ```

    实际操作示例

    ```powershell
    PS☀️[BAT:70%][MEM:36.47% (11.56/31.71)GB][20:00:24]
    #⚡️[cxxu@COLORFULCXXU][C:\]
    PS> net share Demoshare \\colorfulcxxu /delete
    Demoshare was deleted successfully.
    
    #检查效果
    PS> net share
    
    Share name   Resource                        Remark
    
    -------------------------------------------------------------------------------
    IPC$                                         Remote IPC
    DemoShareFC  C:\share1                       share folder grant everyone
    share        C:\share                        ColorfulCxxuShare
    Users        C:\Users
    The command completed successfully.
    #发现确实移除了DemoShare的共享
    ```

    

- 方法1:图形界面操作

  - |                                                              |                                                              |
    | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/3bd52fc15c50499b8615f8231e2a12bd.png) | 右键目标文件夹,选择高级设置,将取消勾选分享次文件夹(share this folder);把保存修改即可 |

- 方法2:从资源管理器中找到目标文件夹,右键更改访问权限,选择移除访问权限(remove access),但是不一定所有文件夹都能找到移除按钮

## 共享文件夹的访问控制补充

### 匿名访问问题😊

免登录访问共享文件夹问题

- [SMB2 和 SMB3 中的来宾访问被禁用 - Windows Server | Microsoft Learn](https://learn.microsoft.com/zh-cn/troubleshoot/windows-server/networking/guest-access-in-smb2-is-disabled-by-default)

  - SMB1默认支持匿名访问,对于较新系统,需要到控制面板中启动相关windows功能
    - 仅当需要兼容老设备或者实在想要匿名登录时考虑这么做(todo)
  - 新系统配置匿名smb访问比较麻烦,我们可以建立一个简单的windows用户(账号密码很短)来逼近匿名访问的体验
  - 事实上,smb协议的客户端通常由保存链接记录的功能,只要设置一次,后续就不需要输入账号密码,如果是一个人或很少人用,就更不用纠结了,配置一次就不需要再输入账号密码了(顶多smb服务器ip发生变换,但如果真的需要改ip无论是否匿名访问都要改,并不会造成更多麻烦,而且提高了一定的安全性)

### 强制启用匿名访问

- 以下设置可能是无效的

  - 修改策略组

  - 或命令行修改注册表

    - ```bash
      PS C:\Users\cxxu\Desktop> reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters /v "AllowInsecureGuestAuth" /d 1 /t REG_DWORD
      
      The operation completed successfully.
      
      PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters
      
      HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters
          EnablePlainTextPassword    REG_DWORD    0x0
          EnableSecuritySignature    REG_DWORD    0x1
          RequireSecuritySignature    REG_DWORD    0x0
          ServiceDll    REG_EXPAND_SZ    %SystemRoot%\System32\wkssvc.dll
          ServiceDllUnloadOnStop    REG_DWORD    0x1
          AllowInsecureGuestAuth    REG_DWORD    0x1
      ```

- 可以考虑启用smb v1,似乎可以匿名访问,但不建议使用,可以简单创建一个专门访问共享文件夹的简单用户即可

### 协议相关信息参考

- [使用 Windows Server 中的 SMB 3 协议的文件共享概述 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/storage/file-server/file-server-smb-overview)

