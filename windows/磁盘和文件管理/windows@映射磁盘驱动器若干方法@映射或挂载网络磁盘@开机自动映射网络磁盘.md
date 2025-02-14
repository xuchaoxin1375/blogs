[toc]

## windows@映射网络磁盘驱动器

### 资源管理器中GUI方式创建

- windows 文档:[在 Windows 中映射网络驱动器 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/在-windows-中映射网络驱动器-29ce55d1-34e3-a7e2-4801-131475f9557d)

## 相关命令行

包括传统的net use命令和powershell提供的一系列相关敏老公

## net use

- [Net use | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/gg651155(v=ws.11))

- [How to Use the Net Use Command in Windows (lifewire.com)](https://www.lifewire.com/net-use-command-2618096)

- ```bash
  PS 🕰️20:40:38 [C:\Users\cxxu\Desktop] 🔋100%  net use ?
  此命令的语法是:
  
  NET USE
  [devicename | *] [\\computername\sharename[\volume] [password | *]]
          [/USER:[domainname\]username]
          [/USER:[dotted domain name\]username]
          [/USER:[username@dotted domain name]
          [/SMARTCARD]
          [/SAVECRED]
          [/REQUIREINTEGRITY]
          [/REQUIREPRIVACY]
          [/WRITETHROUGH]
          [/TRANSPORT:{TCP | QUIC} [/SKIPCERTCHECK]]
          [/REQUESTCOMPRESSION:{YES | NO}]
          [/GLOBAL]
          [[/DELETE] [/GLOBAL]]]
  
  NET USE {devicename | *} [password | *] /HOME
  
  NET USE [/PERSISTENT:{YES | NO}]
  ```

- `net use` 命令在 Windows 操作系统中用于管理网络连接。以下是该命令的语法以及各个选项的详细解释：

### 选项解析

- **`devicename`**：指定要连接的设备名称（如 `Z:`）。
- **`*`**：让系统自动选择下一个可用的设备名称。
- **`\\computername\sharename[\volume]`**：指定共享资源的网络路径。
- **`password | *`**：指定连接共享资源的密码。使用 `*` 表示提示用户输入密码。

#### 用户选项

- **`/USER:[domainname\]username`**：使用指定域和用户名的凭据进行连接。
- **`/USER:[dotted domain name\]username`**：使用点分域名格式的域和用户名。
- **`/USER:[username@dotted domain name]`**：使用 UPN 格式的用户名。

#### 安全选项

- **`/SMARTCARD`**：使用智能卡进行身份验证。
- **`/SAVECRED`**：保存用户凭据，以便下次连接时自动使用。
- **`/REQUIREINTEGRITY`**：要求连接使用数据完整性保护。
- **`/REQUIREPRIVACY`**：要求连接使用数据隐私保护。

#### 性能选项

- **`/WRITETHROUGH`**：确保所有写操作直接写入到服务器，而不是缓存。
- **`/TCPPORT:{0-65535}`**：指定用于连接的 TCP 端口号。
- **`/QUICPORT:{0-65535}`**：指定用于连接的 QUIC 端口号。
- **`/RDMAPORT:{0-65535}`**：指定用于连接的 RDMA 端口号。
- **`/TRANSPORT:{TCP | QUIC}`**：指定传输协议，TCP 或 QUIC。
- **`/SKIPCERTCHECK`**：跳过证书检查（与 QUIC 相关）。

#### 其他选项

- **`/REQUESTCOMPRESSION:{YES | NO}`**：请求连接使用压缩。
- **`/BLOCKNTLM`**：阻止 NTLM 认证。
- **`/GLOBAL`**：使连接对所有用户全局可见。
- **`/DELETE`**：断开指定连接。

#### 持久性选项

- **`/PERSISTENT:{YES | NO}`**：指定连接是否为持久连接。
- **`/HOME`**：将当前用户的主目录映射到网络驱动器。

### 示例

1. **连接到共享资源并保存凭据**

```shell
net use Z: \\Server\Share /user:Domain\Username /savecred
```

2. **连接到共享资源，指定端口和传输协议**

```shell
net use Z: \\Server\Share /user:Domain\Username /TCPPORT:8080 /TRANSPORT:TCP
```

3. **断开连接**

```shell
net use Z: /delete
```

4. **设置持久连接**

```shell
net use Z: \\Server\Share /user:Domain\Username /persistent:yes
```

通过这些选项，`net use` 命令可以灵活地管理网络连接，满足不同的安全和性能需求。

`/savecred` 和 `/persistent:yes` 是 `net use` 命令中的两个不同选项，它们的效果和用途有所不同。下面是对这两个选项的详细解释及其区别：

### 挂载持久化和保存凭证

#### `/savecred`

`/savecred` 选项用于保存用户凭据（用户名和密码）。

当您使用此选项连接到网络共享时，系统会提示您输入**用户和密码**并将作为一组完整的凭证保存。

下次您连接到相同的网络资源(例如链接到`\\CxxuColorful\share`这个UNC路径所指示的网络资源)时，系统会自动查找以往是否保存过该路径的访问凭证,如果凭证有效，而无需再次输入。

例如,将局域网内的`CxxuColorful`主机提供的`share`共享文件夹挂载为本地,把这个链接标记为持久化链接,并且记住凭证,盘符为`X:`网络驱动器

```powershell
#初次链接,会提示你输入密码(但是有时候有因为用户账户不安全或其他错误,可能直接提示报错,那么就需要在命令行中提前携带 /user:username password 凭证来尝试挂载)
PS> net use X: \\CxxuColorful\share /P:yes  /SAVECRED
为“CxxuColorful”输入用户名: cxxu
输入 CxxuColorful 的密码:
命令成功完成。
```

断开链接后重新尝试挂载(免密挂载)

```shell
PS☀️[BAT:100%][MEM:27.41% (2.15/7.85)GB][23:10:30]
# [cxxu@CXXUREDMIBOOK][C:\repos]
PS> net use X: /delete
X: 已经删除。


PS☀️[BAT:100%][MEM:23.91% (1.88/7.85)GB][23:16:19]
# [cxxu@CXXUREDMIBOOK][C:\repos]
PS> net use X: \\CxxuColorful\share
命令成功完成。
```

并且上述挂载命令用到了`/persistent:yes`,简写为`/p:yes`,也就是重启后自动挂载(如果资源可用的话,可能需要等待服务加载就绪,再打开资源管理器就可以看到自动连接好的网络驱动器盘)

经过试验,确实可以自动连接

开机之初过早打开可能看到的还是为连接成功的状态,可以过段时间刷新再看看)

#### `/persistent:yes`

`/persistent:yes` 选项用于设置网络连接的持久性。启用此选项后，即使计算机重新启动或用户注销，连接也会自动恢复。这个选项不会保存用户凭据，但会记住连接的路径和驱动器号。

示例

```shell
net use Z: \\Server\Share /user:Domain\Username Password /persistent:yes
```

执行此命令后，连接将被设置为持久连接，即使计算机重新启动或用户注销，网络驱动器 `Z:` 也会自动重新连接。

#### 区别

主要区别:

- /savecred 主要关注凭据的保存和重用。
- /persistent:yes 主要关注连接的自动重建立。

1. **功能**：
    - **`/savecred`**：保存用户名和密码，以便下次连接时自动使用。
    - **`/persistent:yes`**：设置连接为持久连接，使其在计算机重新启动或用户注销后自动恢复。

2. **适用场景**：
    - **`/savecred`**：适用于需要频繁连接同一网络资源且不希望每次都输入用户名和密码的场景。
    - **`/persistent:yes`**：适用于希望保持网络驱动器连接状态，即使在重新启动或注销后也不希望重新手动连接的场景。

3. **安全性**：
    - **`/savecred`**：会将凭据保存到系统中，可能带来安全风险，尤其是在共享或公共计算机上。
    - **`/persistent:yes`**：仅保存连接路径和驱动器号，不保存凭据，相对更加安全。
      - 假设最初挂载网络(比如`X: \\server\share`)时使用了`/persistent:yes`,但是没有使用`/savecred`,那么在重启打开资源管理器时,会发现待验证(密码)连接的驱动器

两者可以结合使用,以实现自动重连接并使用保存的凭据。例如:

```
net use Z: \\server\share /savecred /persistent:yes
```

这样设置后,即使重启计算机,Z:驱动器也会自动重新连接,并使用之前保存的凭据。

### 区分大小写

- `net use`命令设置盘符时会区分大小写

  - ```cmd
    net use X: \\server\share 
    ```

  - ```cmd
    net use x: /delete
    ```

  这里第一条命令创建的网络设备(网络存储驱动器`X`) 无法被第二条命令移除映射(需要将小写`x`改写为`X`)



### net use造成冲突的选项组合👺

- net use 的语法和文档手册另见它文 

  - [Net use | Microsoft Learn](https://learn.microsoft.com/zh-cn/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/gg651155(v=ws.11))

  这个手册已经在2016年停止维护(更新)

- 以下用法是不可行的(造成选项冲突)

  - ```powershell
    
    net use X: \\server\share /user:Username passwordOfUser /p:yes /SAVECRED
    
    ```

    `/p:yes`不会和`/user:`冲突
    
  - ```
    
    PS☀️[BAT:100%][MEM:23.39% (1.84/7.85)GB][23:39:35]
    # [cxxu@CXXUREDMIBOOK][C:\repos]
    PS> net use S: \\cxxucolorful\share /user:smb 1 /p:yes  /savecred
    命令使用了冲突的选项。
    
    请键入 NET HELPMSG 3510 以获得更多的帮助。
    
    
    ```

#### 凭证覆盖问题👺

```cmd

PS☀️[BAT:100%][MEM:24.02% (1.89/7.85)GB][23:39:48]
# [cxxu@CXXUREDMIBOOK][C:\repos]
PS> net use S: \\cxxucolorful\share /user:smb 1 /p:yes
命令成功完成。


PS☀️[BAT:100%][MEM:24.02% (1.89/7.85)GB][23:39:51]
# [cxxu@CXXUREDMIBOOK][C:\repos]
PS> cmdkey /list

当前保存的凭据:

  ....

    目标: Domain:target=TERMSRV/CXXUCOLORFUL
    类型: 域密码
    用户: cxxu
    本地机器持续时间

....
    目标: Domain:target=CxxuColorful
    类型: 域密码
    用户: CxxuColorful\cxxu
```

本文的试验中,涉及两台机器,都启用了网络发现,两台主机可以不用ip来访问,用计算机名访问,分别时`CxxuColorful`,`CxxuRedmibook`

其中`CxxuColorful`提供了两个账号用来测试,`Cxxu`是高权限账号(适合设备主人使用),而`smb`是共享用的普通(受限)权限账号,适合共享给其他人分享资料使用

我先用组合拳:`/p:yes /savecred`记住了`Cxxu`凭证,进行了挂载试验(挂载到了`X:`盘,然后`net user X: /d`删除掉该挂载(但是不会删除凭证,因此重启后,计算机会自动挂载,但是盘符不会记录到凭证,到底挂载后盘符会是哪一个,取决于`Cxxucolorful`重启前被挂载为什么盘(使用了`/p:yes`选项会覆盖前面的自动挂载盘符))

而后我又用`smb`这个普通账户挂载为`S:`盘,使用了`/p:yes`,而没有使用`/savecred`选项,意味着重启后应该不会自动使用`smb`这个凭证

然而由于之前的`cxxu`凭证和`smb`都来自服务器`CxxuColorful`因此,重启后仍然会出现自动挂载的现象,不过凭据用的是之前保存的`Cxxu`而挂载的盘符不是`X:`而是`S:`,因为后者指定的盘符号覆盖掉了前者指定的盘符号

### 新凭证覆盖旧凭证

假设之前映射用的凭证是`smb`,密码为`1`,具有基本的权限(并且被(`/p:yes /savecred`记住了凭证)

```powershell
 net use X: \\cxxucolorful\share  /p:yes /savecred
 #输入smb用户的凭证
```

现在假设您是某个共享文件夹(所在计算机)的管理员或拥有者,我想要具有更高权限来访问它,比如访问共享文件夹中指向用户`cxxu`家目录中的某个文件(夹),那么需要覆盖掉低权限的smb,现删除掉原来的挂载

```powershell
net use X: /delete
```

这里在命令中携带需要用的凭证,防止使用默认的已保存的smb用户凭证

```powershell
 net use X: \\cxxucolorful\share /user:cxxu passwordOfCxxu /p:yes
```



### 禁止多重链接

```powershell
PS> net use S: \\cxxucolorful\share /user:smb 1 /p:yes
发生系统错误 1219。

不允许一个用户使用一个以上用户名与服务器或共享资源的多重连接。中断与此服务器或共享资源的所有连接，然后再试一次。

```

前面我对`\\cxxucolorful\share`用`server`上的用户名`cxxu`及其密码进行了链接

现在又进行了`server`服务器上的另一个上的用户名`smb`(第二个用户名)去链接就会遇到多重链接被拒绝



### powershell 系相关命令

- 相关命令(添加和移除不是那么好用),配合网络发现,使用被挂载的设备的计算机名来使用

  ```
  PS[BAT:77%][MEM:33.96% (10.77/31.70)GB][21:36:41]
  # [~\Desktop]
   gcm *drive* |?{$_.Source -match 'Microsoft.Powershell.Management'}
  
  CommandType     Name                                               Version    Source
  -----------     ----                                               -------    ------
  Cmdlet          Get-PSDrive                                        7.0.0.0    Microsoft.PowerShell.Management
  Cmdlet          New-PSDrive                                        7.0.0.0    Microsoft.PowerShell.Management
  Cmdlet          Remove-PSDrive                                     7.0.0.0    Microsoft.PowerShell.Management
  ```

  

## 命令行列出驱动器列表

### 查询网络驱动器

- 可以使用`net use`查询网络驱动器

  - ```bash
    PS 🕰️21:56:10 [C:\Users\cxxu\Desktop] 🔋100%  net use
    不记录新的网络连接。
    
    
    状态       本地        远程                      网络
    
    -------------------------------------------------------------------------------
                 A:        \\localhost@5244\dav\AliyunDrive
                                                    Web Client Network
                 Y:        \\localhost@5244\dav      Web Client Network
    OK           Z:        \\localhost\share         Microsoft Windows Network
    命令成功完成。
    ```

### 使用Get-PSDrive(新系统推荐)

- 较新系统可以用powershell

  - ```bash
    [BAT:78%][MEM:34.98% (11.09/31.70)GB][18:33:48]
    [~\Desktop]
    PS> Get-PSDrive|ft -AutoSize
    
    Name     Used (GB) Free (GB) Provider    Root
    ----     --------- --------- --------    ----
    Alias                        Alias
    C           268.22    674.72 FileSystem  C:\
    Cert                         Certificate \
    Env                          Environment
    Function                     Function
    HKCU                         Registry    HKEY_CURRENT_USER
    HKLM                         Registry    HKEY_LOCAL_MACHINE
    M           268.22    674.72 FileSystem  \\192.168.1.165@5244\DavWWWRoot\dav…
    Temp        268.22    674.72 FileSystem  C:\Users\cxxu\AppData\Local\Temp\
    Variable                     Variable
    W           268.22    674.72 FileSystem  \\localhost@5244\DavWWWRoot\dav…
    WSMan                        WSMan
    
    ```

  - 进一步过滤

  - ```bash
    [BAT:78%][MEM:33.30% (10.56/31.70)GB][18:37:42]
    [~\Desktop]
    PS> Get-PSDrive -PSProvider FileSystem | Where-Object { $_.DisplayRoot -like '\\*' }|ft -AutoSize
    
    Name Used (GB) Free (GB) Provider   Root
    ---- --------- --------- --------   ----
    M       268.21    674.72 FileSystem \\192.168.1.165@5244\DavWWWRoot\dav…
    W       268.21    674.72 FileSystem \\localhost@5244\DavWWWRoot\dav…
    
    ```


### 使用wmic


- 或者 `wmic` 命令（Window Management Instrumentation Command-line）来列出所有已映射的网络驱动器

- 执行:`wmic logicaldisk get caption,providername`

  - ```bash
    PS 🕰️20:49:10 [C:\Users\cxxu\Desktop] 🔋100%  wmic logicaldisk get caption,providername
    Caption  ProviderName
    A:       \\localhost@5244\DavWWWRoot\dav\AliyunDrive
    C:
    D:
    X:       \\localhost@5244\DavWWWRoot\dav\AliyunDrive
    Y:       \\localhost@5244\DavWWWRoot\dav
    Z:       \\localhost\share
    ```

  - 运行上述命令后，会显示所有逻辑磁盘（包括本地磁盘和网络映射的驱动器）的名称以及提供程序名称。
  - 对于网络映射的驱动器，ProviderName通常会显示为远程计算机或网络共享的位置。

- 查看更多信息:`wmic logicaldisk get caption,description,providername,volumename,size,freespace`

  - ```bash
    PS 🕰️21:05:14 [C:\Users\cxxu\Desktop] 🔋100%  wmic logicaldisk get caption,description,providername,volumename,size,freespace
    Caption  Description   FreeSpace     ProviderName                                 Size          VolumeName
    A:       网络连接      364817272832  \\localhost@5244\DavWWWRoot\dav\AliyunDrive  489019002880
    C:       本地固定磁盘  364817272832                                               489019002880
    D:       本地固定磁盘  15071293440                                                20971515904   20G系统镜像盘(mini)
    X:       网络连接      364817272832  \\localhost@5244\DavWWWRoot\dav\AliyunDrive  489019002880
    Y:       网络连接      364817272832  \\localhost@5244\DavWWWRoot\dav              489019002880
    Z:       网络连接      364817272832  \\localhost\share                            489019002880
    ```

- 另外，如果你只是想查看所有的驱动器（包括本地和网络映射），而不关心提供程序信息，可以简化命令为
  - `wmic logicaldisk get caption`

- 其他关于磁盘的命令行工具:diskpart (主要操作本地磁盘和驱动器)

### 使用Get-CimInstance(新系统推荐)

- ```powershell
  PS[BAT:78%][MEM:33.70% (10.68/31.70)GB][18:52:55]
  # [~\Desktop]
   Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object  Caption, ProviderName
  
  Caption ProviderName
  ------- ------------
  C:
  M:      \\192.168.1.165@5244\DavWWWRoot\dav
  W:      \\localhost@5244\DavWWWRoot\dav
  
  ```

- ```powershell
  PS[BAT:78%][MEM:33.69% (10.68/31.70)GB][18:55:06]
  # [~\Desktop]
   Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object  caption,description,providername,volumename,size,freespace|ft -AutoSize
  
  caption description        providername                        volumename          size    freespace
  ------- -----------        ------------                        ----------          ----    ---------
  C:      Local Fixed Disk                                       Windows    1012469329920 724471517184
  M:      Network Connection \\192.168.1.165@5244\DavWWWRoot\dav            1012469329920 724471517184
  W:      Network Connection \\localhost@5244\DavWWWRoot\dav                1012469329920 724471517184
  
  ```



## 添加网络驱动器磁盘映射@持久化配置映射👺

- 以借助alist挂载阿里云open为例

- 上述配置是一次性的,如果我们要永久化配置(例如注销后重新登录到windows或者重启后仍然保留网络驱动器)

- 为了挂载http链接,可能需要修改注册表,参考:[windows@允许挂载http链接@挂载局域网http链接](http://t.csdnimg.cn/p9NmO)

  - 简单说,就是以管理员身份运行命令行终端,然后输入(复制粘贴)以下内容回车执行

    ```
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel /t REG_DWORD /d 2
    ```

  - 执行成功的话会给提示

- 可以借助`/p:yes`选项,使得配置持久化

  - ```
    PS 🕰️22:11:07 [C:\Users\cxxu\Desktop] 🔋100%  net use W: http://localhost:5244/dav  /p:yes
    为“localhost”输入用户名: admin
    输入 localhost 的密码:
    命令成功完成。
    ```

- 追加使用`/savecred`选项,之后不用输入用户名和密码

  - ```bash
    PS 🕰️0:28:19 [C:\Users\cxxu\Desktop] 🔋100%  net use W: http://localhost:5244/dav  /p:yes /savecred
    
    命令成功完成。
    ```



### GUI操作

- 这对应于GUI操作勾选(默认勾选)登录时重新连接(目前仅保留资源管理器内的驱动器图标,需要手动确定连接)

#### 重新连结

- 当然也可以勾选使用其他凭据链接(具体作用暂未实验)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/7976774c64414092bc1039c5534563cb.png)


#### 记住凭证

- 重启后可能需要输入密码,点击记住凭证
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/fe8a153fd0ec4c8e8159043605294202.png)

- 注意密码一栏存在黑点字符,一般就是已经记住密码了,只不过黑点数量不一定和密码数量相等,直接点击确定就可以登录了(记住凭证这个选项在创建的时候勾选过一次就行,后续不需要反复勾选,直接确定登录)
- Note:记住凭证(密码)不表示会自动登录,仍然需要我们点击确定才会建立连接(如果是本地的共享文件夹,不需要密码时登录系统可以自定建立网路驱动器)

## 删除@取消映射

- 首先查询所有驱动器(分区),确定要删除的盘符(映射)

  - ```bash
    PS 🕰️20:49:10 [C:\Users\cxxu\Desktop] 🔋100%  wmic logicaldisk get caption,providername
    Caption  ProviderName
    A:       \\localhost@5244\DavWWWRoot\dav\AliyunDrive
    C:
    D:
    X:       \\localhost@5244\DavWWWRoot\dav\AliyunDrive
    Y:       \\localhost@5244\DavWWWRoot\dav
    Z:       \\localhost\share
    ```

  - 经过确认,假设我们要删除重复映射的`A,X`盘中的一个,比如我要删除`X`盘

- 执行删除:`net use [partition:] /delete`

  - 这里将`[partition]`替换为目标盘符`X`

    ```
    PS 🕰️21:07:34 [C:\Users\cxxu\Desktop] 🔋100%  
    net use X: /delete
    X: 已经删除。
    ```
    

- 再次检查分区列表

  ```bash
  
  PS 🕰️21:07:50 [C:\Users\cxxu\Desktop] 🔋100%  wmic logicaldisk get caption,providername
  Caption  ProviderName
  A:       \\localhost@5244\DavWWWRoot\dav\AliyunDrive
  C:
  D:
  Y:       \\localhost@5244\DavWWWRoot\dav
  Z:       \\localhost\share
  ```







## 开机自启@登录系统后自动挂载👺

#### 以alist webdav 挂载为例

#### 分析

- 可能是因为windows的bug,(我在win11下配置的)后来无论怎么点击**记住我的凭据**,都无法顺利映射(连接服务器),即便服务器已经启动好了
-  为了便于讨论,这里假设要将连接`http://localhost:5244/dav`挂载为`W`盘.`/p:yes`表示每次登录都保留这个连接(如果可以的话)
- 我尝试用命令行登录:`net use W: http://localhost:5244/dav  /p:yes`,结果系统让我输入密码(正如前面展示的那样)
- 考虑到之前保存过凭据,我追加`/savecred`,这次直接提示命令行执行完成(成功执行不报错);检查资源管理器中的映射网络分区处于已连接可用状态
  - Note:执行`net use W: http://localhost:5244/dav  /p:yes  /savecred`时,确保**windows安全中心**窗口已经被关闭了,否则会遇到执行错误(系统拒绝访问)
  - 其实在打开资源管理器或者访问挂载的网络分区之前,不会遇到拒绝错误(但是有可能遇到其他错误,比如网络和服务建立缓慢,而映射动作执行过早,就会遇到找不到目标的错误)



#### 对策

- 创建开机自启脚本(简单脚本,有时会因为网络和系统相应的原因,无法自动挂载,参考下一节延迟挂载)

  1. 先找到`startup`目录,里面可能有部分软件的快捷方式(系统会在开机时执行里面的软件或脚本)

  2. 在这个目录里创建一个文件(文本文件),内容为`net use W: http://localhost:5244/dav  /p:yes /savecred`,文件名任意,后缀为`bat`即可

  3. 注意将这里的`W:`和`http://local...`替换为自己的值即可

  4. 也可以考虑创建日志文件,用比较长的这一行代替`net use W: http://localhost:5244/dav  /p:yes /savecred >  %userprofile%/desktop/MapLog.txt 2> %userprofile%/desktop/MapErrLog.txt`(会在桌面生成2个日志文件,列出执行结果,如果MapErrLog.txt 为空,说明顺利执行了)

  5. 配置完是什么样的

     ```bash
     PS 🕰️1:16:43 [C:\Users\cxxu\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup] 🔋100%  ls
     
             Directory: C:\Users\cxxu\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
     
     
     Mode                LastWriteTime         Length Name
     ----                -------------         ------ ----
     la---         2024/1/16     13:55           1041   alist_startup.lnk
     -a---         2024/2/11      1:03            121   MapCloudDrive.bat
     -a---         2024/1/16      1:29           1355   Snipaste.lnk
     
     PS 🕰️1:16:44 [C:\Users\cxxu\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup] 🔋100%  cat .\MapCloudDrive.bat
     
     net use W: http://localhost:5244/dav  /p:yes /savecred
     
     
     ```

- 如果挂载了多个盘,可以做类似的操作(可以写在同一个文件中)

- 这样在网络顺畅等理想条件下,可以开机自动挂载好网络磁盘分区(驱动器)

  

#### 延迟挂载👺

- 如果设置了代理类软件开机自启,有可能会影响到网络磁盘的加载

- 由于网络磁盘的顺利挂载依赖于已经顺利联网的alist成功建立服务(访问云盘资源),这个过程可能受到网络能否在开机时及时连通,否则执行挂载的命令不会成功

- 这就是说,如果您经常遇到开机后无法自动挂载网路磁盘的情况,考虑在alist配置文件中配置**延迟启动**

- 然后再配置开机自启的脚本退后执行,比如开机30秒后或者1分钟后执行
  - powershell提供了停留若干时间的功能
  - cmd可以用ping 若干次模拟停留
  - 除了开机自启目录中放置脚本,还可以考虑用windows的计划任务来做延迟开机自启

- 配置挂载开关:如果愿意每次登录到系统后一段时间(比如30秒,确保alist服务,以及系统的相关服务完整启动就绪),然后手动执行映射也可以

  - 这里我们用powershell语言,同样将`net use W: http://localhost:5244/dav  /p:yes /savecred`配置成一个脚本(或快捷方式),或powershell函数(别名)

  - 但是加入了自动重试映射的逻辑,通常能在10秒内成功映射,但有时可能会60秒甚至超过1分钟(但一般不会超过2分钟,因此请耐心等待)

  - 同样的,下面这个版本可以加入开机自启脚本中自动调用并重试来映射网络磁盘,直到成功后,自动关闭任务窗口;该脚本经过我本地测试,能够良好地工作(系统是windows11)

    - ```bash
      
      Caption                  Version    OSArchitecture BuildNumber
      -------                  -------    -------------- -----------
      Microsoft Windows 11 Pro 10.0.22631 64-bit         22631
      ```
  

#### 相关脚本@函数

- 用powershell封装
  
  ```powershell
  
  function Set-AlistLocalhostDrive
  {
      param(
          $delay = 8
      )
      #根据需要自行修改盘符和端口号
      # net use W: http://localhost:5244/dav /p:yes /savecred
      Set-AlistDrive -host 'localhost' -DriveLetter 'W' -Port '5244'
  
      if (!$?)
      {
  
          Write-Host '映射失败,等一会再映射(或者检查alist 服务是否正常)
          #这里我假设配置好检查逻辑 Start-AlistHomePage 调用)'
          # Start-AlistHomePage
          Write-Host "try again after $delay s... enter stop auto retry! 👺"
          Start-Sleep $delay
          #递归调用来重试
          Set-AlistLocalhostDrive
  
      }
      #检查映射结果
      net use
  }
  
  function Set-AlistDrive
  {
      <# 
      .SYNOPSIS
      $HostAddress =$iqoo10pro
      .DESCRIPTION
      为了方便省事,这里记住密码，不用每次都输入密码
      net use W: "http://$HostAddress:5244/dav" /p:yes /savecred 
      .EXAMPLE
      [BAT:78%][MEM:37.64% (11.93/31.70)GB][15:31:09]
      [~]
      PS>Set-AlistDrive -host $iqoo10pro -DriveLetter M -Port 5244
      The command completed successfully.
  
      .EXAMPLE
      如果重复执行同一个映射,并且第一次执行操作成功,那么第二次会提示失败(盘符被占用)
      [BAT:78%][MEM:37.46% (11.87/31.70)GB][15:31:32]
      [~]
      PS>Set-AlistDrive -host $iqoo10pro -DriveLetter M -Port 5244
      System error 85 has occurred.
  
      The local device name is already in use.
      #>
      param(
          # 手机端ip地址
          $HostAddress = 'localhost',
          $DriveLetter = 'M',
          $Port = '5244'
      )
  
      
      net use "$($DriveLetter):" "http://$($HostAddress):$($Port)/dav" /p:yes /savecred 
      
      # >  %userprofile%/desktop/MapLog.txt 2> %userprofile%/desktop/MapErrLog.txt
  }
  
  ```

- 每次只需要双击即可挂载;或者在命令行中调用映射函数完成映射



#### Note



- 上述脚本会开机自动执行,会弹出一个cmd命令行窗口,可能会停留几秒钟,执行完毕会自动关闭
  - 不要手动关闭,除非它一直卡在哪里
  - 执行完打开资源管理器,顺利的话可以看到网络磁盘顺利挂载

## FAQ

### 挂载网络磁盘后资源管理器加载容易卡顿

- 如果您挂载的网络驱动器不稳定,或者意外断开,那么访问磁盘相关操作可能会卡顿甚至导致资源管理器重启,包括但不限于资源管理,以及`net use`以及`Get-Psdrive`等命令难以进行(甚至无法返回结果)

- 所以当您发现这些问题时,请及时

  - 检查网络磁盘(服务端)是否正常运行

  - 否则请断开导致问题的映射,利用`net use <DriveLetter>: \delete`进行删除映射

  - 例如,移除`W`盘

    - ```bash
      PS[BAT:77%][MEM:33.81% (10.72/31.70)GB][21:33:48]
      # [~\Desktop]
       remove-NetDrive -DriverLetter W
      W: was deleted successfully.
      
      ```

      


## 访问已经挂载网络磁盘分区👺

- 用命令行也可以直接访问已经挂载的网络磁盘分区,这里时linux风格的方式,区分字母大小写,并且无法使用路径补全提示

- ```bash
  PS 🕰️1:56:30 [W:\AliyunDrive] 🔋100%  ls
  
          Directory: W:\AliyunDrive
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  da---         2024/1/14     20:58                  .
  da---         2024/1/14     20:58                  ..
  d----          2024/2/3     19:39                  来自：通义听悟
  ```

  

### 连接到局域网手机alist webdav

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/d6f7841968474723ad1ec980e79fb598.png)

## 添加一个网络位置😊

- 在Windows操作系统中添加网络位置的步骤如下，这里以Windows 10系统为例：

  1. **打开文件资源管理器**：
     - 点击桌面左下角的“开始”按钮或按下键盘上的`Win+E`键打开“文件资源管理器”。

  2. **启动添加网络位置向导**：
     - 在“文件资源管理器”窗口左侧的导航窗格中找到并点击“此电脑”或者直接在地址栏上方点击“计算机”图标。
     - 右键点击空白区域，然后选择“添加一个网络位置”选项。

  3. **按照向导操作**：
     - 弹出的“添加网络位置向导”会引导你完成后续步骤。
     - 点击“下一步”继续。
     - 在接下来的界面中，选择“自定义网络位置”。

  4. **输入网络位置地址**：
     - 当提示你指定网络位置时，输入你要连接的网络共享、FTP站点或其他网络资源的URL或UNC路径（例如，对于网络共享可能是 `\\server\sharename`）。

  5. **完成配置**：
     - 根据向导提示设置名称（可选），点击“下一步”后，最后确认信息无误，点击“完成”按钮创建网络位置快捷方式。

  创建完成后，新添加的网络位置将出现在“此电脑”或“网络位置”列表中，方便你快速访问该网络资源。

## 网络驱动器和网络文件夹(位置)区别

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/10751b99651b4243aff962a1e2ee6feb.png)

## 小结

- 使用命令行工具`net use`来创建网络磁盘驱动器操作简单,但是理解`net use`的语法需要花点功夫
- 例如创建永久性映射,有相应的记住凭证的选项





