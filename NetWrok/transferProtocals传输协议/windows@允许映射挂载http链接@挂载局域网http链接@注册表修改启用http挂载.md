[toc]



##  资源管理器挂载网络驱动器👺

- 对于共享文件夹(smb)协议(`\\server\sharefolder`)类型的连接可以直接挂载
- 对于https安全连接也可以挂载
- 但是对于http协议链接,新系统可能需要修改注册表,使得系统能够挂载http链接
- 这里给出一个命令行版本,操作更简单



### 允许http链接映射为磁盘驱动器(命令行方式修改注册表)😊

- 下面的操作将是的windows能够将http链接映射为驱动器

- 首先,您需要使用**管理员方式**打开`cmd`或者`powershell`

- 如果目标明确,执行以下操作的命令

  - ```powershell
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel /t REG_DWORD /d 2 /f
    
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  FileSizeLimitInBytes /t REG_DWORD /d 0xffffffff /f
    
    # Restart-Service WebClient #如果是powershell,可以restart-service 代替下面的2个语句
    net stop WebClient
    net start WebClient
    
    
    ```
    

- 这里使用了`/f`参数强制修改,否则中途会让你确认,就是输入`yes`即可,如果那您不放心,可以去掉`/f`参数

- 然后可以尝试执行磁盘映射等操作,例如

  - 下面的指令尝试记住凭证,以便下次登录可以自动尝试挂载

    ```bat
    net use W: http://localhost:5244/dav /p:yes /savecred
    ```

- 如果映射命令提示执行成功,但是资源管理器中却没有看到新的磁盘,这就要**重启系统**后再查看是否能够映射(挂载)成功

- 检查挂载:直接执行`net use`,可以看到挂载列表,如果非空,说明有网络磁盘挂载上了

  

  

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

- 关闭所有powershell(如果有的话)

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
  
    


### powershell函数封装

- 这里用到的函数`set-AlistMobilePhone`是对`net use`的封装

  - ```powershell
    
    
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
        
    
    }
    ```

### 记住映射选项@自动映射

- `/p:yes /savecred `

  

### 取消映射

- ```bash
  [BAT:78%][MEM:37.94% (12.03/31.70)GB][15:27:58]
  [M:\]
  PS>net use M: /delete
  There are open files and/or incomplete directory searches pending on the connection to M:.
  
  Is it OK to continue disconnecting and force them closed? (Y/N) [N]: Y
  M: was deleted successfully.
  ```

  

## windows凭据查看

### 命令行中查看

可以使用cmdkey来查看凭证

```bash
PS> cmdkey -h

The command line parameters are incorrect.

The syntax of this command is:

CMDKEY [{/add | /generic}:targetname {/smartcard | /user:username {/pass{:password}}} | /delete{:targetname | /ras} | /list{:targetname}]

Examples:

  To list available credentials:
     cmdkey /list
     cmdkey /list:targetname

  To create domain credentials:
     cmdkey /add:targetname /user:username /pass:password
     cmdkey /add:targetname /user:username /pass
     cmdkey /add:targetname /user:username
     cmdkey /add:targetname /smartcard

  To create generic credentials:
     The /add switch may be replaced by /generic to create generic credentials

  To delete existing credentials:
     cmdkey /delete:targetname

  To delete RAS credentials:
     cmdkey /delete /ras

```



### 取消记住@凭据查看和管理

- 在开始菜单中搜索`credential manager`可以看到各类被windows记住的凭证
  - 例如远程桌面记住的登录密码
  - 网络磁盘映射的凭证
- 个别情况下我们需要删除凭证，例如映射webdav到本地磁盘，并且webdav服务器为不同的登录角色分配了不同权限，现在假设原来用来登录的用户权限是只读，现在我向管理员申请提高权限，追加可以上传的权限，管理员分配了一个uploader账户给用户使用，这时候我们就要修改或删除原来记住的凭证重新创建

