[toc]



##  资源管理器挂载网络驱动器👺

- 对于共享文件夹(smb)协议(`\\server\sharefolder`)类型的连接可以直接挂载
- 对于https安全连接也可以挂载
- 但是对于http协议链接,新系统可能需要修改注册表,使得系统能够挂载http链接
- [修改注册表以支持连接 HTTP协议 的 WebDAV_注册表http属性-CSDN博客](https://blog.csdn.net/qq_36666115/article/details/105473156)
- 这里给出一个命令行版本,操作更简单



### 允许http链接映射为磁盘驱动器😊

- 下面的操作将是的windows能够将http链接映射为驱动器

- 首先,您需要使用**管理员方式**打开`cmd`或者`powershell`

- 如果目标明确,执行类似以下操作的命令

  - ```cmd
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel /t REG_DWORD /d 2
    ```

    

- 实操

  - 可以先查询一下原来的值

    ```bash
    [BAT:78%][MEM:35.12% (11.13/31.70)GB][14:56:31]
    [~\Desktop]
    PS>reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthlevel
    
    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters
        BasicAuthlevel    REG_DWORD    0x1
    ```

    

  - 用管理员权限修改

    ```bash
    [BAT:78%][MEM:35.07% (11.12/31.70)GB][14:56:52]
    [~\Desktop]
    PS>reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters /v  BasicAuthLevel /t REG_DWORD /d 2
    Value BasicAuthLevel exists, overwrite(Yes/No)? yes
    The operation completed successfully.
    
    ```

  - 然后要**重启系统**

- 重新检查是否可以映射!


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

### 刷新使配置生效

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

## 基本操作

### 执行映射

- 关闭所有powershell(如果有的话)

- 重新打开一个powershell进行驱动器映射(使用net use命令,详情另见它文)

- 下面的试验是我在手机,假设机型为iqoo10pro,在局域网内的ip为192.168.1.165

  ```bash
  PS>$iqoo10pro="192.168.1.165"
  PS>$iqoo10pro
  192.168.1.165
  #正式操作
  [BAT:78%][MEM:36.11% (11.45/31.70)GB][15:21:02]
  [~\Desktop]
  PS>set-AlistMobilePhone -MobilePhone $iqoo10pro -DriveLetter M
  Enter the user name for '192.168.1.165': admin
  Enter the password for 192.168.1.165:
  The command completed successfully.
  
  #映射结果检查
  [BAT:78%][MEM:36.19% (11.47/31.70)GB][15:21:12]
  [~\Desktop]
  PS>net use
  New connections will be remembered.
  
  
  Status       Local     Remote                    Network
  
  -------------------------------------------------------------------------------
               M:        \\192.168.1.165@5244\dav  Web Client Network
               W:        \\localhost@5244\dav      Web Client Network
  The command completed successfully.
  ```

- 这里用到的函数`set-AlistMobilePhone`是对`net use`的封装

  - ```
    function Set-AlistMobilePhone
    {
        <# 
        .SYNOPSIS
        $MobilePhone =$iqoo10pro
        net use W: "http://$MobilePhone:5244/dav" /p:yes /savecred 
        #>
        param(
            # 手机端ip地址
            $MobilePhone = $iqoo10pro,
            $DriveLetter = 'M'
        )
        net use "$($DriveLetter):" "http://$($MobilePhone):5244/dav" /p:yes /savecred 
        
        # >  %userprofile%/desktop/MapLog.txt 2> %userprofile%/desktop/MapErrLog.txt
    }
    ```

### 取消映射

- ```bash
  [BAT:78%][MEM:37.94% (12.03/31.70)GB][15:27:58]
  [M:\]
  PS>net use M: /delete
  There are open files and/or incomplete directory searches pending on the connection to M:.
  
  Is it OK to continue disconnecting and force them closed? (Y/N) [N]: Y
  M: was deleted successfully.
  ```

  