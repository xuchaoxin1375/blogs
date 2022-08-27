# powershell_linux install powershell

## refereces

- [Install PowerShell on Linux - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2)
  - [Alpine](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2#alpine)
  - [CentOS](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2#centos)
  - [Debian](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2#debian)
  - [Fedora](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2#fedora)



### Ubuntu/Debian install powershell7+

- [Installation via direct download](https://docs.microsoft.com/en-us/powershell/scripting/install/install-debian?view=powershell-7.2#installation-via-direct-download)
- [Installation on Debian 11 via Package Repository](https://docs.microsoft.com/en-us/powershell/scripting/install/install-debian?view=powershell-7.2#installation-on-debian-11-via-package-repository)
- [Installation on Debian 10 via Package Repository](https://docs.microsoft.com/en-us/powershell/scripting/install/install-debian?view=powershell-7.2#installation-on-debian-10-via-package-repository)
- [Installation on Debian 9 via Package Repository](https://docs.microsoft.com/en-us/powershell/scripting/install/install-debian?view=powershell-7.2#installation-on-debian-9-via-package-repository)

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

- 

### 运行安装脚本

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

