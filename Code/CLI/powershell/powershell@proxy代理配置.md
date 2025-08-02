[toc]

## refs

- [Use the Az PowerShell module behind a proxy | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/azure/az-powershell-proxy?view=azps-11.3.0)
- [配置Powershell命令行代理 ](https://anuoua.github.io/2019/08/11/配置Powershell命令行代理/)

## 配置

- ```powershell
  
  function proxy_set_switcher
  {
     
      <# 
      .synopsis
      通过配置环境变量来设置powershell的代理(自动识别$env:http_proxy和$env:https_proxy)
      我们可以配置临时的环境变量,也可以配置永久的环境变量,这里用临时的就足够了
  
      通过配置$env:http_proxy和$env:https_proxy,只能让cmdlet走代理,有些应用不受上述配置项目的影响,例如ping,仍然无法走代理
      而curl再powershell中式invoke-webRequset,是可以走代理的
  
      如果想要ping也能走代理,就需要其他方案,例如cfw中安装服务模式并且启用tun;
      或者再其他设备配置代理,例如android设备安装every proxy将代理环境分享给其他设备,从底层走代理(这和局域网内系统代理有区别)
      这对于vscode中许多插件的下载加速是有用的,例如codeium插件
  
  
      .example
      PS 🕰️2:51:37 PM [C:\repos\scripts] 🔋100% proxy_set_switcher
      -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~
      use curl(invoke-webRequset) google to test the environment! ...
  
      PS 🕰️2:51:16 PM [C:\repos\scripts] 🔋100% $env:https_proxy
      http://localhost:10801
  
      .example
      PS 🕰️2:51:24 PM [C:\repos\scripts] 🔋100% proxy_set_switcher -switch_close
      PS 🕰️2:51:30 PM [C:\repos\scripts] 🔋100% $env:https_proxy
      #>
      param(
          [switch]$switch_close,
          #开关形选项,默认不使用改选项,表示开启代理,使用该选项表示关闭代理
          $port_opt = '10801',
          $localhost_opt = 'http://localhost'#这里假设走本地提供的代理服务,或者localhost通常就是127.0.0.1,如果是其他服务器,可以自己修改
  
      )
      $localhost = $localhost_opt
      $socket = "$localhost`:$port_opt"
      # Write-Output $socket
      if (!$switch_close)
      {
          
          set-item Env:http_proxy $socket  # 代理地址
          set-item Env:https_proxy $socket # 代理地址
          #也可用$env:https_proxy = $socket;$env:http_proxy = $socket代替上述set-item的用法
          #注意set-item和set-variable 是不同的
  
          # PrintBorder
          Write-Output "use curl(invoke-webRequset) google to test the environment! ..."
          Invoke-WebRequest www.google.com 
          # Invoke-WebRequest ddg.gg | nl
      }
      else
      {   
          Remove-Item Env:http_proxy
          Remove-Item Env:https_proxy
      }
      
  }
  ```

## 注册表相关

- cmd&powershell:` reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings"`

  - ```bash
    PS 🕰️3:14:47 PM [C:\repos\scripts] 🔋100%  reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    
    HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings
        CertificateRevocation    REG_DWORD    0x1
        DisableCachingOfSSLPages    REG_DWORD    0x0
    ...
        ProxyServer    REG_SZ    127.0.0.1:10801👺
        ProxyOverride    REG_SZ    localhost;127.*;10.*;172.16.*;172.17.*;172.18.*;172.19.*;172.20.*;172.21.*;172.22.*;172.23.*;172.24.*;172.25.*;172.26.*;172.27.*;172.28.*;172.29.*;172.30.*;172.31.*;192.168.*;<local>
        LockDatabase    REG_QWORD    0x1da5d74b78b73a2
    ```

    

- powrshell还可以执行:`Get-ItemProperty -Path "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings"`


## 代理异常(全部超时)

- 对于新买的笔记本,时区可能是不那么准,需要手动设置一下(可以打开自动校准开关),有时候仅仅差几分中,就会导致代理服务器超时(代理客户端判断超时的算法有关)
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/5c7ee08bae754958869be7ef8bf0b23d.png)

## 为Install-Module配置代理加速下载

- [Install-Module (PowerShellGet) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/powershellget/install-module?view=powershellget-3.x)

- 例如

  ```powershell
  Install-Module -Name BurntToast -AllowPrerelease -Proxy 'http://127.0.0.1:7890'
  ```

  