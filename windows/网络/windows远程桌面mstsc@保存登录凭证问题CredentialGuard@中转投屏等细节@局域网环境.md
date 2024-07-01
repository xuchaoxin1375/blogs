

[toc]

## refs

- 官方文档简练地介绍了远程连接的条件和方法[如何使用远程桌面 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/如何使用远程桌面-5fe128d5-8fb1-7a23-3b8a-41e636865e8c#ID0EDD=Windows_10)
- 本文介绍一些使用过程中的细节



##  试验环境
- 两台主机均被设置了用户和密码,被控机器登录的账户是Microsoft账户(不同于本地账户,影响远程登录时的用户名+密码)
- 都是windows专业版以上的
- 这里试验的两台机器都是同一局域网下的主机
##  相关常识
- 一台计算机(host)上可能不止一个用户(user)
- 特别是用户名要加以区别

### 两类账户

- windows本地账户
  - 仅限windows系统本地登录使用计算机用途,也可以供其他机器远程控制作为登录身份使用windows计算机的资源
  - 不具有联网功能,无法同步设置,也无法登录其他微软(Microsoft)产品,主打离线使用,不需要上互联网(顶多是局域网)
- Microsoft账户(云账户)
  - 功能更加强大,可以备份设置,除了用来登录和管理windows,还可以用来登录其他Microsoft产品,因此成为Microsoft账号,而不是单单windows账号

### 三个码

- windows本地账户和Microsoft账户的密码是独立的
- 另外如果用户密码比较长,登录windows时可以设置一个简单的字符串作为pin来登录(pin的形式有多种,pin码也可以用来登录windows,但是其功能是受限,只是方便输入,甚至可以用指纹来代替字符串,但是当前主机的pin无法被其他主机用来登录当前主机,所以如果对方无法直接接触你的机器,即便pin泄露,其他人依然无法登录您的机器)
- 这和手机验证码登录账号的方式有相同也有不同点,比如验证码一般都是6位或者8位的数字,而密码我们可以很复杂很长,但是验证码是不能泄露的,pin码一般不怕泄露,除非这个人有机会接触到你的机器(因此指纹或人脸pin会更安全和更快捷,多年前就有指纹解锁的电脑了,和手机上的指纹解锁一样方便高效)

### pin特点👺

- Windows上的PIN码（Personal Identification Number）是一种便捷的**本地身份验证方法**，类似于手机锁屏时使用的数字密码。
- 在Windows 10及更高版本的操作系统中，用户可以设置PIN码作为替代传统的密码来快速登录到设备。PIN码有以下特点：
  1. **便捷性**：PIN码通常由4到6位数字组成，但也可能包含字母和其他字符，根据Windows设置允许，这使得用户能够更快速地输入和解锁设备。
  2. **本地绑定**：PIN码是与特定设备绑定的，这意味着你**在一台设备上设置的PIN码不能在另一台设备上使用**。这对于保护用户隐私和安全有一定的好处，**即使PIN码被知道，攻击者也无法远程登录到其他设备**。
  3. **安全机制**：尽管PIN码看起来简单，但Windows系统中的PIN码实际上是经过加密处理的，并且与用户的Microsoft账户关联，即便PIN码泄露，也不能直接用来访问云端服务或从远程位置登录。
  4. **双因素认证支持**：在某些情况下，PIN码结合了Windows Hello等生物识别技术（如指纹识别或面部识别）提供双重身份验证，进一步提升安全性。
  5. **设置与管理**：用户可以通过Windows设置来创建、更改或删除PIN码。通常路径是在“设置”->“账户”->“登录选项”中找到PIN码相关设置。

- 总之，Windows PIN码旨在提供一种平衡安全性和便利性的登录方式，**特别适合那些希望快速解锁个人电脑而又不想频繁输入复杂密码的用户**。
- 最后,切记pin码无法用于远程登录,除非您的密码和pin码设置的一样(但一般pin码比较简短)



## 被控机的设置👺

### 获取windows主机名或地址

- 在局域网下,可以通过唯一的**用户名**或**私有ip**两种方式来确定一台计算机
- 详情另见它文:[windows@查看主机名@查看IP地址](http://t.csdnimg.cn/erYwP)



###  获取要被远程登录用户名(userName)
- 快速的方法就是用`whoami`查询

- 例如

  - ```bash
    PS>whoami
    colorfulcxxu\cxxu
    ```

  - 其中colorfulcxxu是我的主机名,可以用ipv4地址代替这个名字

  - `\`后面是用户名,表示其他机器要以哪一个用户的身份登录到这被控的机器

- 为什么要主机名(ip)和用户名才行?省略掉用户名环节不行?

  - 因为不同用户具有的权限可能不同,登录为管理员账户权限当然就大
  - 另一方面是隐私和安全,如果机器上有多个用户,远程登录到任意用户,显然不安全也不合理

- 我们也可以设立一个专门用来共享登录的用户,比如用户名share,然后登录密码公开给需要登录的用户

- 注意,多个其他设备的用户无法同时远程登录到被控主机的同一个账户,多的用户会下线掉



##  主控机的设置👺

###  微软的mstsc软件

- [mstsc | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/mstsc)
- "mstsc"是微软远程桌面连接（Microsoft Terminal Services Client）的命令行程序名称，主要用于Windows操作系统中远程连接到另一台计算机。
- 在命令提示符窗口中输入“mstsc”并运行，将会打开远程桌面连接界面，用户可以输入远程计算机的IP地址或计算机名以建立远程桌面连接。

### 打开mstsc

- 具体使用方法如下：

  1. 打开“运行”（快捷键Win+R）；
  2. 输入“mstsc”后回车；
  3. 在弹出的远程桌面连接窗口中输入远程计算机的IP地址和登录凭据（用户名和密码），然后点击“连接”即可进行远程控制。

- 此外，你也可以直接在Windows搜索框中输入“远程桌面连接”来启动该程序。

###  主控机上输入被控机以及登录身份信息
- 首先输入被控主机名(或者ip)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/be22b1dbfd434a269237681978e2e983.png)

- 注意第一个界面输入的用户名可能在第二个界面被修改(改成了全名描述,既不是本地用户,也不是Microsoft账户名),可以点击更多选项,重新输入用户名和对应的登录密码
- 如果计算机那一栏填写用的是ip地址,则第二个界面的用户名不会被修改
- 即使显示的是本地用户的名字,但是如果设置了Microsoft云同步,则登录密码要输入Microsoft的密码,而不是本地账户的密码(除非两个密码是一样的),更不是PIN码
- 如果忘记账户密码,可以到设置里更改或重置)

- 这里试验的两台机器都是同一局域网下的主机

------
###  登录到远程主机的本地账户


![在这里插入图片描述](https://img-blog.csdnimg.cn/9e4040c6b03249768b3071a316214c08.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_10,color_FFFFFF,t_70,g_se,x_16)
>最好设置登录密码,否则可能无法远程登录失败
>###  修改本地用户的登录密码
>注意,这不同于PIN码
>




## FAQ

### 提示密码错误

- 用户可能会遇到登录到被控机过程中的输入要登陆的用户身份和凭证(密码)时遇凭证无效的问题,即便我们被控机上的用户名密码都是确保正确的(但其实用户名这个东西有欺骗性)

- 在较新的windows版本,比如win10之后的系统,微软强调用(推荐)microsoft账户(联网的云账户)来登录windows

  - 云账户确实有好处,可以在其他设备同步自己的一些系统设置等
  - 但是有的用户还是习惯使用本地账户,毕竟本地账户不需要联网,而且使用起来更加简单

- 由于这两中类型的账户的存在,就会导致一些不必要的混乱

  - 查询当前机器的所有用户可以用`lusrmgr.msc`查看(用命令行打开)

  - 检查当前用户的用户名还可以查看家目录的名字,命令行中输入`cd`后的路径返回的就是用户家目录

  - 或者使用whoami查看主机名和当前用户名

    - ```cmd
      C:\Users\cxxu>whoami
      colorfulcxxu\cxxu
      ```

  - 尽管这看起来像是本地用户,但是我们还是要打开设置,看看是否处于本地账户登录状态

    - ![请添加图片描述](https://img-blog.csdnimg.cn/direct/c3508922da194f0fb7cd6e60fcad96b6.png)

  - 如果发现账户设置一栏有改用本地账户登录的字样,就说明当前账户受到云账户控制,使用pin码登录虽然能够在被控机上登录,但却无法被用以远程登录的凭证

- 现在有两个选择,使用本地账户的密码(而非pin码,特别是密码和pin码不同的时候,通常pin码串可能会简单一些,比如只有数字);另一个选择是用云账户的密码来登录

### 更改账户密码

- [更改或重置 Windows 密码 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/更改或重置-windows-密码-8271d17c-9f9e-443f-835a-8318c8f68b9c)
- 对于云账户密码修改:[Microsoft account | Security](https://account.microsoft.com/security?lang=en-US&refd=account.microsoft.com)

### 账户尝试登录次数过多而被锁定

- 有一次我像往常一样想用mstsc做局域网内的远程桌面登录,但是提示我账户被锁定了
- 这应该是被链接的主机发生了错误或者是网络环境的设备出现错误
- 我们可以尝试为被链接的主机断开并重新链接,或者切换网络环境后重新尝试(我用手机热点试了一下,用手机端的远程桌面(RD客户端),发现之前用的Microsoft账户密码登不上了,于是我尝试用本地账户的密码登上了,估计是网络故障引起的功能异常)
- 接着我把网络重新切换会最初的网络
- 回到另一台主机上,重新尝试链接,发现登录密码又变回Microsoft账户密码

## 记住登录凭证@下次免密登录

- 这部分设置不是那么直观,需要梳理一下:

  - 记住密码可能不是您想象的那么直接有效
  - 记住凭证:需要连接并成功登录进去,才能够记住凭证,如果只是连接到登录界面,但是没有首次输入登录密码,那么是无法产生有效的登录凭证,那么下次登录仍然需要你手动输入密码

- 当您的凭证失效,则建议您删除旧有的凭证,然后mstsc界面会切换到最初的界面,可以勾选允许记住凭证


### 凭证被禁用问题@Credential Guard

- [配置 Credential Guard - Windows Security | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/security/identity-protection/credential-guard/configure?tabs=intune)

- mstsc远程桌面登录选项有一个记住密码或凭证的选项,按理说记住密码或凭证后下次登录就不需要再输入密码了
  - 然而windows引入了credential guard安全机制,并且在较新的专业版系统上默认启用了这个功能
  - 这可能导致一定程度上的使用不便,尽管提升了安全性,但是这并不总是符合我们的需要
  - 下面介绍该功能以及配置,以下给出了可以复制粘贴一键的运行脚本
- 根据windows系统版本的不同,有些用户记住密码功能的使用上很顺利,但是有些用户则需要额外的配置
  - 非pro版系统,或者默认不启用credential guard功能的系统不会遇到credential guard 阻碍记住密码的使用
- 根据用户账户类型,也有不同的效果
  - 如果是local account,登录时可能不会遇到credential guard问题,即便credential guard 功能已经被启用了
  - 如果是Microsoft acccount,那么记住的凭证无法用于登录



### 检查是否启用了Credential Guard

- powershell脚本

  ```powershell
  (Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard).SecurityServicesRunning
  ```

- 返回1表示启用,返回0表示未启用

- 如有其他疑问,参考上述文档链接

### Credential Guard禁用

- 以下脚本需要以**管理员权限**运行，它会创建或修改指定的注册表键值，以达到禁用与Credential Guard相关的设置目的。请确保在执行之前评估此操作对系统安全性的影响，并在必要时进行系统备份。
- 从powershell/cmd的版本二选一

#### 脚本

- powershell禁用Credential Guard

  ```powershell
  # 确保以管理员权限运行PowerShell
  if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
      Write-Warning "请以管理员身份运行此脚本。"
      Exit
  }
  
  # 设置注册表项以禁用Credential Guard相关设置
  
  # 第一个注册表路径和值
  $regPath1 = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
  $regName1 = "LsaCfgFlags"
  $regValue1 = 0
  
  # 第二个注册表路径和值
  $regPath2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
  $regName2 = "LsaCfgFlags"
  $regValue2 = 0
  
  # 设置第一个注册表项
  New-ItemProperty -Path $regPath1 -Name $regName1 -Value $regValue1 -PropertyType DWord -Force | Out-Null
  
  # 设置第二个注册表项
  New-ItemProperty -Path $regPath2 -Name $regName2 -Value $regValue2 -PropertyType DWord -Force | Out-Null
  
  Write-Host "注册表项已设置完成。"
  Write-Host "请重启计算机以使更改生效。"
  Pause
  ```

- cmd脚本(不要在powershell中执行,会报错)

  ```bash
  @echo off
  echo 正在设置注册表项以禁用Credential Guard相关设置...
  
  :: 设置第一个注册表项
  reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v LsaCfgFlags /t REG_DWORD /d 0 /f
  
  :: 设置第二个注册表项
  reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v LsaCfgFlags /t REG_DWORD /d 0 /f
  
  echo 设置完成。
  echo 请重启计算机以使更改生效。
  pause
  ```

#### 检查相关的值是否设置正确(optional)

- 任选其一进行检查

- cmd

  - ```bash
    reg query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LsaCfgFlags
    reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v LsaCfgFlags
    
    ```

- powershell

  - ```powershell
    # 使用PowerShell方式检查第一个注册表项
    $value = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name LsaCfgFlags -ErrorAction SilentlyContinue
    Write-Host "LsaCfgFlags in 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa': $($value.LsaCfgFlags)"
    
    # 使用PowerShell方式检查第二个注册表项
    $value = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" -Name LsaCfgFlags -ErrorAction SilentlyContinue
    Write-Host "LsaCfgFlags in 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard': $($value.LsaCfgFlags)"
    ```

    

## 硬件调节受限问题

### 远程桌面控制的投屏问题

- 远程登录到被控主机,可能无法设置被控主机的显示器行为,这一点要注意

### 亮度调节被卡住👺

- 远程控制的情况下,我们也不能够调整被控制的机器的屏幕亮度
  - 不仅如此,还可能导致被控机器的控制中心出现故障,比如亮度条无法调整(灰色)
  - 那么控制机无法调整被控机的亮度,那就向将被控机的窗口缩小,然后调整主控机的亮度
  - 同理,投影也是一样的,可以向把主控机投屏设置好,然后被控机窗口全屏即可
    - 比如说,办公室有一台比较重的高性能工作站,教室有一台轻薄本,自然希望获得工作站的性能和笔记本的轻便
    - 如果两个机器处在同一局域网下,那么利用轻薄本远程连接到工作站(两台都是windows 专业版,至少工作站机器得是专业版以上的windows,才提供被连接的功能)，利用轻薄本远程到工作站,再把轻薄本上的画面投屏到大屏幕上,非常完美(考虑到windows的个别地方的限制,可以先投影轻薄本画面,调整亮度,然后远程工作站的画面全屏即可)

- windows自带的控制中心(win+A)启动,依赖于资源管理器,因此如果某些功能异常,可以考虑重启资源管理

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/fc03653850124d73b999f02ce8180180.png)

- 重启资源管理器解决:

  - cmd/powershell:` taskkill /f /im explorer.exe  & start explorer.exe`

    - 注意`taskkill /f /im explorer.exe`是单纯杀死资源管理器(依赖于资源管理器的系统组件将无法工作)

      - 通常这个语句不要单独执行

      - 如果您不小心执行了这一个语句而没有接着启动`explorer`,请在命令行窗口内追加explorer即可

      - ```bash
        Microsoft Windows [Version 10.0.22631.3296]
        (c) Microsoft Corporation. All rights reserved.
        
        C:\Users\cxxu>taskkill /f /im explorer.exe
        SUCCESS: The process "explorer.exe" with PID 18648 has been terminated.
        
        C:\Users\cxxu>explorer
        ```

        

    - 因此我们还需要进一步最佳执行`start explorer`或直接`explorer`

    - cmd下执行,不能在powershell下执行,下面是实操

      ```bash
      Microsoft Windows [Version 10.0.22631.3296]
      (c) Microsoft Corporation. All rights reserved.
      
      C:\Users\cxxu>@echo off
      taskkill /f /im explorer.exe & start explorer.exe
      SUCCESS: The process "explorer.exe" with PID 22784 has been terminated.
      ```

  - powershell可以直接执行即可:`Stop-Process -Name explorer`

    - 如果不放心的话可以追加一下下一行`explorer`



##  总结(必看)👺

- 我们这里谈到了两类账户(windows本地账户和Microsoft账户和3个码

- 登录时,使用账户的**登录密码**`而不是pin码`(除非pin码和账户的密码是一样的)

- 无论是microsoft账户还是本地账户,都用各自配置的密码来作为远程登录的入口凭证

  

