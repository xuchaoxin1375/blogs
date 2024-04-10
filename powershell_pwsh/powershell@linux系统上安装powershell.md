# powershell_linux install powershell

## refereces

- [Install PowerShell on Linux - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2)
  - [Alpine](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2#alpine)
  - [CentOS](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2#centos)
  - [Debian](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2#debian)
  - [Fedora](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2#fedora)



### 安装文档

- [Install PowerShell on Linux - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2)

### 检查当前发行版

- `cat /etc/issue`

- ```
  
  LSB Version:    core-9.20170808ubuntu1-noarch:security-9.20170808ubuntu1-noarch
  Distributor ID: Ubuntu
  Description:    Ubuntu 18.04.6 LTS
  Release:        18.04
  Codename:       bionic
  Ubuntu 18.04.6 LTS \n \l
  ```

  

### 运行安装脚本

- 下面这段脚本是给Debian设计的脚本
- 我在ubuntu22上试过也可以安装(源是阿里源)

```
# Install system components
sudo apt update  && sudo apt install -y curl gnupg apt-transport-https

# Import the public repository GPG keys
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Register the Microsoft Product feed
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list'

# Install PowerShell
sudo apt update && sudo apt install -y powershell

# Start PowerShell
pwsh
```



### verify installation

- `cat /etc/shells|grep powershell`

```
# cxxu @ cxxuAli in ~ [11:04:44]
$ cat /etc/shells
# /etc/shells: valid login shells
/bin/sh
/bin/bash
/bin/rbash
/bin/dash
/bin/zsh
/usr/bin/zsh
/usr/bin/pwsh
/opt/microsoft/powershell/7/pwsh
```

