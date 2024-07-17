[toc]



##  资源管理器挂载网络驱动器👺

- 对于共享文件夹(smb)协议(`\\server\sharefolder`)类型的连接可以直接挂载
- 对于https安全连接也可以挂载
- 但是对于http协议链接,新系统可能需要修改注册表,使得系统能够挂载http链接
- 这里给出一个命令行版本,操作更简单

### 挂载共享文件夹

- 挂载共享文件夹不需要修改注册表
- 并且有net use 和 powershell Mount-SmbMapping 等方法,详情另见它文
  - [windows@资源管理器中的地址栏@访问共享文件夹的各种方法@管理共享文件夹_windows 路径中的@-CSDN博客](https://cxxu1375.blog.csdn.net/article/details/140139320)
- 这里主要讨论webdav的挂载,尤其是局域网内http连接的webdav挂载

### 允许http链接映射为磁盘驱动器(命令行方式修改注册表)😊

- 下面的操作将是的windows能够将http链接映射为驱动器

- 首先,您需要使用**管理员方式**打开`cmd`或者`powershell`

- 如果目标明确,执行以下命令行

  - ```powershell
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel /t REG_DWORD /d 2 /f
    
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  FileSizeLimitInBytes /t REG_DWORD /d 0xffffffff /f
    
    # Restart-Service WebClient #如果是powershell,可以restart-service 代替下面的2个语句
    net stop WebClient
    net start WebClient
    
    ```
    
  
- 这里使用了`/f`参数强制修改,否则中途会让你确认,就是输入`yes`即可,如果那您不放心,可以去掉`/f`参数





### 演示(optional)

- 可以先**查询一下原来的值**

  ```cmd
  [BAT:78%][MEM:35.12% (11.13/31.70)GB][14:56:31]
  [~\Desktop]
  PS>reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthlevel
  
  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters
      BasicAuthlevel    REG_DWORD    0x1
  ```

  也可以用powershell来查看,可以分别用`gp`或`gpv`来查看,也可以用全称`get-itemproperty`和`get-itempropertyValue`

  ```powershell
  PS C:\Users\cxxu> Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\WebClient\Parameters' -Name BasicAuthLevel
  2
  PS C:\Users\cxxu> (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\WebClient\Parameters' -Name BasicAuthLevel).BasicAuthLevel
  2
  ```

- 用管理员权限修改

  ```bash
  [BAT:78%][MEM:35.07% (11.12/31.70)GB][14:56:52]
  [~\Desktop]
  PS>reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel /t REG_DWORD /d 2
  Value BasicAuthLevel exists, overwrite(Yes/No)? yes
  The operation completed successfully.
  
  ```

  


#### 可选更改:文件大小限制

- ```cmd
  reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  FileSizeLimitInBytes /t REG_DWORD /d 0xffffffff
  ```

- 实操

  ```bash
  #查询修改前的值
  [BAT:78%][MEM:35.89% (11.38/31.70)GB][15:01:25]
  [~\Desktop]
  PS>reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  FileSizeLimitInBytes
  
  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters
      FileSizeLimitInBytes    REG_DWORD    0x2faf080
  
  [BAT:78%][MEM:35.80% (11.35/31.70)GB][15:02:32]
  [~\Desktop]
  PS>reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  FileSizeLimitInBytes /t REG_DWORD /d 0xffffffff
  Value FileSizeLimitInBytes exists, overwrite(Yes/No)? yes
  The operation completed successfully.
  ```

#### 刷新使配置生效

- 可以通过重启计算机来刷新
- 也可以通过以下重启服务的方式刷新

#### 重启webclient服务

- 我们用管理员权限打开powershell操作:

  - 可选:`Get-Service webclient`查看服务详情
  - 再用`Restart-Service WebClient`重启服务

  ```bash
  [BAT:78%][MEM:34.73% (11.01/31.70)GB][15:04:40]
  [~\Desktop]
  PS>Get-Service WebClient
  
  Status   Name               DisplayName
  ------   ----               -----------
  Running  WebClient          WebClient
  
  
  [BAT:78%][MEM:34.73% (11.01/31.70)GB][15:04:44]
  [~\Desktop]
  PS>Restart-Service WebClient
  ```



## 基本网络盘映射和挂载操作

### 执行映射

- 关闭所有powershell(如果有的话),(离开管理员权限命令行窗口)打开另一个**普通**权限的命令行窗口),例如

- 重新打开一个powershell进行驱动器映射(使用net use命令,详情另见它文)

  - powershell

    ```bash
    $DriveLetter='W'
    # $HostAddress='127.0.0.1'
    $HostAddress='192.168.1.178'#局域网内的另一个主机示例
    $Port=5244
    net use "$($DriveLetter):" "http://$($HostAddress):$($Port)/dav" /p:yes /savecred 
    
    
    ```
  
  - cmd
  
    ```bash
    @echo off
    set DriveLetter=W
    set HostAddress=127.0.0.1
    set Port=5244
    
    net use "%DriveLetter%:" "http://%HostAddress%:%Port%/dav" /p:yes /savecred
    ```
  



### Note



- 挂载完毕后检查是否挂载成功

- 如果映射命令提示执行成功,但是资源管理器中却没有看到新的磁盘,需要打开新的普通权限的命令行窗口重新执行

  - ```bash
    net use #检查挂载情况(如果没有成功列出空列表,那么重新执行挂载命令)
    ```

    ```powershell
    #再执行挂载之前,打开一个普通权限的命令行窗口(挂载不需要管理员权限,不需要时就尽量不要用管理员权限来执行命令,遵循权限最小原则可以减少将来访问文件权限时遇到不必要权限问题的麻烦
    
    PS C:\Users\cxxu> net use W: http://192.168.1.178:5244/dav /p:yes /savecred
    为“192.168.1.178”输入用户名: admin
    输入 192.168.1.178 的密码:(如果有密码,则输入密码,字符是透明的,不要输错)
    命令成功完成。
    
    #虽然命令行提示执行成功,但是需要手动检查实际上是否挂载,本例子中,如果成功,应该可以找到W:盘
    
    ```

    如果返回提示空的语句,参考下面

    ```powershell
    #下面是检查列表为空的情况,这时候我们需要打开新的命令行窗口重新执行一遍上面的挂载命令
    PS C:\Users\cxxu> net use
    会记录新的网络连接。
    
    列表是空的。
    # 尝试重新挂载(可以再打开一个新的命令行窗口,挂载不需要管理员权限)
    PS C:\Users\cxxu> net use W: http://192.168.1.178:5244/dav /p:yes /savecred
    命令成功完成。
    
    PS C:\Users\cxxu> net use
    会记录新的网络连接。
    
    
    状态       本地        远程                      网络
    
    -------------------------------------------------------------------------------
                 W:        \\192.168.1.178@5244\dav  Web Client Network
    命令成功完成。
    ```

    

  - 如果还是不行,尝试**重启系统**后再查看是否能够映射(挂载)成功

- 检查挂载:直接执行`net use`,可以看到挂载列表,如果非空,说明有网络磁盘挂载上了

  


### powershell函数封装

- 这里用到的函数`Mount-NetDrive`是对`net use`的封装

  - ```powershell
    
    function Mount-NetDrive
    {
        <# 
    	.SYNOPSIS
        挂载http链接形式的网络驱动器,通常用于局域网挂载
        这里是对net use 的一个封装,而Powershell 的New-PSDrive命令并不那么好用,链接识别有一定问题
        $HostAddress =$iqoo10pro
        .DESCRIPTION
        为了方便省事,这里记住密码，不用每次都输入密码
        net use W: "http://$HostAddress:5244/dav" /p:yes /savecred 
        目前已知New-PSDrive有挂载问题是,报错如下
        New-PSDrive: The specified drive root "\\192.168.1.178:5244\dav" either does not exist, 	or it is not a folder.
    
        .EXAMPLE
        # 挂载共享文件夹
        PS C:\repos\scripts> mount-NetDrive -HostAddress 127.0.0.1 -DriveLetter V  -Mode Smb -Remember
        Net Drive Mode: Smb
        Enter shared folder(Directory) BaseName(`share` is default): share
        \\127.0.0.1\share
        The command completed successfully.
    
        Drive V: successfully mapped to \\127.0.0.1\share
        New connections will be remembered.
    
    
        Status       Local     Remote                    Network
    
        -------------------------------------------------------------------------------
        Unavailable  M:        http://192.168.1.165:5244/dav
                                                        Web Client Network
                    Q:        \\127.0.0.1@5244\dav      Web Client Network
        OK           V:        \\127.0.0.1\share         Microsoft Windows Network
        Unavailable  W:        http://localhost:5244/dav Web Client Network
        The command completed successfully.
        .EXAMPLE
        #挂载webdav(之前已经记录过凭证)
        PS C:\repos\scripts> mount-NetDrive -HostAddress 127.0.0.1 -DriveLetter V  -Mode Webdav -Remember
        Net Drive Mode: Webdav
        http://127.0.0.1:5244/dav
        The command completed successfully.
    
        Drive V: successfully mapped to http://127.0.0.1:5244/dav
        New connections will be remembered.
    
    
        Status       Local     Remote                    Network
    
        -------------------------------------------------------------------------------
        Unavailable  M:        http://192.168.1.165:5244/dav
                                                        Web Client Network
                    Q:        \\127.0.0.1@5244\dav      Web Client Network
                    V:        \\127.0.0.1@5244\dav      Web Client Network
        Unavailable  W:        http://localhost:5244/dav Web Client Network
        The command completed successfully.
        
        #>
        param(
            # 可以用于webdav链接中ip地址填充,也可以用于共享文件夹
            [string]$HostAddress = 'localhost',
            # 比如用于共享文件夹的链接,比如\\192.168.1.178\share
            [string]$CompleteUri = '',
            [ValidateSet('Smb', 'Webdav', 'Others')]$Mode = 'Smb',
            # 挂载的分区盘符
            [string]$DriveLetter = 'M',
            # Alist 默认端口库
            [string]$Port = '5244',
            # 用户名是可选的,如果您使用匿名登录不上,则考虑使用次参数,密码会在执行后要求你填入,这样密码不会明文显示在命令行中
            [string]$UserName = '',
            #是否记住凭证(和 -UserName 一起使用时可能会有冲突!)
            [switch]$Remember
    
        )
    
        Write-Host "Net Drive Mode: $Mode" -ForegroundColor Magenta
    
        $credString = ''#默认没有凭证,匿名访问/挂载
        # 如果提供了用户,则要求用户输入密码(这样密码不会在命令行中明文显示)
        if ($UserName)
        {
            $password = Read-Host "Enter password For $UserName" -AsSecureString
            $credential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)
            $plainCred = $credential.GetNetworkCredential()
    
            $credString = $plainCred.UserName + ' ' + $plainCred.Password
        }
        # 构造URI(if语句可以类似于三元运算符来使用)
        $Uri = if ($CompleteUri)
        {
            $CompleteUri 
        }
        else
        {  
    
            switch ($Mode)
            {
                # 记得使用break来退出switch
                'Webdav'
                { 
                    
                    "http://${HostAddress}:${Port}/dav"; break
                }
                'Smb'
                {
                    $ShareDir = Read-Host 'Enter shared folder(Directory) BaseName(`share` is default)'
                    $ShareDir = if ($ShareDir) { $ShareDir } else { 'share' }
                    "\\${HostAddress}\$ShareDir" ; break
                }
                Default { '' }
            }
        } 
    
        Write-Host -ForegroundColor Blue $Uri
    
        # 构造net use命令参数
        $netUseArguments = "${DriveLetter}: $uri"
        #考虑到可能需要用户名和密码,必要时添加凭据字符串
        if ($credString -ne '')
        {
            $netUseArguments += " /user:$credString"
        }
    
        # 是否记住凭据
        if ($Remember)
        {
            $netUseArguments += ' /persistent:yes /savecred'
        }
    
        # 映射网络驱动器
        $expression = "net use $netUseArguments"
        #debug
        # Write-Host $expression -BackgroundColor Green
    
        Invoke-Expression $expression
    
        # 检查映射结果
        if ($LASTEXITCODE -eq 0)
        {
            Write-Host "Drive ${DriveLetter}: successfully mapped to $uri"
        }
        else
        {
            Write-Error "Failed to map drive ${DriveLetter}: with error code $LASTEXITCODE"
        }
    
        # 显示现有映射
        net use
    }
    
    ```

### 记住登录密码@自动映射选项

- `/savecred `保存登录凭证

- `/p:yes `永久记住

  

### 取消映射

- 使用`net use <DriverName:> /delete`来取消映射

- ```bash
  [BAT:78%][MEM:37.94% (12.03/31.70)GB][15:27:58]
  [M:\]
  PS>net use M: /delete
  There are open files and/or incomplete directory searches pending on the connection to M:.
  
  Is it OK to continue disconnecting and force them closed? (Y/N) [N]: Y
  M: was deleted successfully.
  ```

- 封装成powershell函数

  ```powershell
  
  function Remove-NetDrive
  {
      <#
      .SYNOPSIS
      This function removes a network drive mapping.
  
      .DESCRIPTION
      This function uses the `net use` command to remove a network drive mapping. The drive letter to be removed is specified as a parameter. If no drive letter is provided, the default is 'M'.
  
      .PARAMETER DriverLetter
      The drive letter of the network drive to be removed. Default is 'M'.
  
      .EXAMPLE
      Remove-NetDrive -DriverLetter 'Z'
  
      This command removes the network drive mapping associated with the drive letter 'Z'.
  
      .NOTES
      This function does not require administrative privileges to remove a network drive mapping.
      #>
      param (
          $DriverLetter = 'M'
      )
      net use "${DriverLetter}:" /delete
  }
  ```

  

## 取消记住密码(凭证管理)

- 另见它文关于`Credential Manager`的使用
