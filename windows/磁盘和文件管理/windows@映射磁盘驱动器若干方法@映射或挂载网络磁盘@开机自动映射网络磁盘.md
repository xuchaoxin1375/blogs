[toc]

## windows@映射网络磁盘驱动器

### 资源管理器中GUI方式创建

- windows 文档:[在 Windows 中映射网络驱动器 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/在-windows-中映射网络驱动器-29ce55d1-34e3-a7e2-4801-131475f9557d)

## 相关命令行

### net use

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

### powershell 系

- 相关命令(添加和移除不是那么好用)

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





