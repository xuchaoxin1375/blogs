[toc]


#  linux 安装powershell

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

#  windwos msi包安装报错问题

## msi包无法安装问题🎈

- 报错内容:

  - ```cmd
    Windows Installer
        This installation package could not be
        opened.Contact the application vendor to
        verify that this is a valid Windows Installer
        package.
    ```

  - 然而,实际情况是包能够在虚拟机中安装,安装包没有问题.

- 这种情况下,您可能无法安装`wsl_update.msi`内核更新程序

- 办法1:😂

  - 可考虑将安装包复制一份到新建账户到桌面（可能和权限有关）

- 办法2:

  - 尝试创建一个新的本地管理员账户
  - 在新账户中尝试运行安装包
  - 重启到原账户
  - 如果依然不可用，🎈,重复方法1中复制安装包再安装



