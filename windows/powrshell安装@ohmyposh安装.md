@[toc]

# powershell7

##  安装

### windows 应用商店安装

- 可以通过windows应用商店安装
  - 但是我不推荐
  - 会安装在个人用户目录中
  - 不利于多用户共享！
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210630070820601.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

#### 安装后所在目录(样式)

- `C:\Users\<your userame>\AppData\Local\Microsoft\WindowsApps\Microsoft.PowerShell_8wekyb3d8bbwe\pwsh.exe`

##  通过msi安装包安装😊

- 目前我采用此方式,比较符合我的管理习惯
- 推荐使用安装版:

- [Installing PowerShell on Windows - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2#msi)

##  配置样式默认值

- <img src="https://img-blog.csdnimg.cn/20210630071030496.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70" alt="在这里插入图片描述" style="zoom:50%;" />



## 乱码问题😊

- [vscode/windows terminal_oh my posh(基于pwsh字体乱码问题修复)](https://blog.csdn.net/xuchaoxin1375/article/details/118269272)

- 具体可以通过命令help posh 查看详情
  - （列举出可用地相关命令）![](https://img-blog.csdnimg.cn/20210102234637381.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

##  查看当前pwsh安装路径

- `$psHome`

- ```powershell
  PS C:\Users\cxxu> $PSHOME
  C:\Program Files\PowerShell\7
  ```

  

## terminal推荐

- powershell自带的窗口太过于简陋
- 在windwos端，推荐使用windows terminal
  - [Windows Terminal installation | Microsoft Learn](https://learn.microsoft.com/en-us/windows/terminal/install)

# Oh my Posh

##  oh my posh安装

- [Windows | Oh My Posh](https://ohmyposh.dev/docs/installation/windows)

### 基本使用

- Now that Oh My Posh is installed, you can go ahead and configure your terminal and shell to get the prompt to look exactly like you want.
  - install a [font](https://ohmyposh.dev/docs/installation/fonts)
  - configure your terminal/editor to use the installed font
  - configure your shell to [use Oh My Posh](https://ohmyposh.dev/docs/installation/prompt)
  - (optional) configure a theme or [custom prompt configuration](https://ohmyposh.dev/docs/installation/customize)

- [Change your prompt | Oh My Posh](https://ohmyposh.dev/docs/installation/prompt)

#### 启动oh-my-posh

- 不同的安装来源可能对应不同的启动方法和使用方法
  - scoop安装的
    - `oh-my-posh init pwsh | Invoke-Expression`
    - 浏览不同主题(在posh的状态下执行)
      - ` get-poshThemes `
  - powershell 自带安装工具安装的版本则要容易操作一些

#### 自定义主题

- [Customize | Oh My Posh](https://ohmyposh.dev/docs/installation/customize)

## Installation (my operation process)

###  prepare work:

- excute:
  - `Set-ExecutionPolicy RemoteSigned -scope CurrentUser`

- than

```bash
Install-Module oh-my-posh -Scope CurrentUser
```
### (optional) List all themes:

- You may meet the abnormal fonts display problems.if so ,reference to the link written in the top of the article.


==!!== you may need ***import the module*** before to test the command below
To display every available theme in the current directory, use the following cmdlet.
```bash
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
```
```bash
Import-Module oh-my-posh
```

```bash
Get-PoshThemes
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210613192857398.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

### (recommended) create the "$profile"

- execute:

  - `notepad $PRPFILE`
- this file just like the `.bashrc` file in linux bash shell.
- but they have different language syntaxs.

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210613193631255.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

##  write some content to the "$Profile"file):
according to your need,modify the lines beneth:
```bash
#import Module (recommended add the next line,but,of course ,you can  choose not  to add the item,if you do not use the git tools)
# Import-Module posh-git

# import posh
Import-Module oh-my-posh
#set theme
Set-poshPrompt paradox
#set tab auto completion(optional item)
#(the command line will try to offer you a list(candidated) when you press the `tab`key
#of course,if the current path have only one or even none can match what you want to match,it will just try to complete the current object name

Set-PSReadlineKeyHandler -Key Tab -Function Complete
```
generally ,the file will be saved in the default location ,like this:`C:\Users\cxxu\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
###  have troubles?

- if not ,please pass the part and go on（jump this step）

- if you modify the default the store location,you can run the `$Profile` to see the detail location of the $Profile file should be placed.
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/dd3c56169aad422b8e9b1c9fd1eca46d.png)
- this maybe also probably happend in the case that you set  you onedrive backup include the folder `documents` ,and onedrive sync folder is set in the disk which is not disk `C:`
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/888c08cf653b4095acaaa18f0a225ca1.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)



## (recommended) posh git

- [https://github.com/dahlbyk/posh-git/](https://github.com/dahlbyk/posh-git/)

### powershell 调用install-Module模块安装

- ```powershell
  # (A) You've never installed posh-git from the PowerShell Gallery
  Install-Module posh-git -Scope CurrentUser -Force
  ```

  

##  the configuration result:😊

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210613195329513.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

