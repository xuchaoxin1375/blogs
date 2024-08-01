[toc]



## windows终端应用程序

Windows Console Host（conhost.exe）与Windows Terminal是Microsoft提供的两款不同的命令行接口工具，在Windows操作系统中扮演着不同的角色：

## Windows Console Host (conhost.exe)

- 这是Windows系统内建的传统命令行界面后台处理程序，负责管理和显示控制台窗口，包括CMD、PowerShell以及各种命令行应用等。
- 在功能上相对基础，支持基本的文本输出、颜色设置、字体大小调整等，但用户体验和视觉效果较为传统，不支持现代化的UI设计和高级定制。

## Windows Terminal

[An overview on Windows Terminal | Microsoft Learn](https://learn.microsoft.com/en-us/windows/terminal/)

- 是微软在2019年推出的一款全新的、现代化的命令行终端应用程序，旨在提供更强大的功能和更好的用户体验。
- **优势**：
    - **多标签页支持**：用户可以在一个窗口内打开多个命令行会话，如CMD、PowerShell、WSL等多个环境，并通过标签页进行切换。
    - **Fluent Design System**：采用现代UI设计语言，支持半透明背景、自定义主题和样式。
    - **高DPI支持**：在高分辨率显示器上有更好的缩放和清晰度表现。
    - **配置灵活性**：支持JSON配置文件，允许深度定制外观、快捷键、启动目录等。
    - **性能改进**：对底层的Console Host进行了重写和优化，提高了性能和稳定性。
    - **Unicode和富文本支持**：支持更多的字符集和图形符号，以及更好的字体渲染。

### 终端shell prompt美化

- 相比早期,windows Terminal的功能和文档越来越完善,并且与时俱进给出了美化指南	
  - [Windows 终端自定义提示符设置 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/terminal/tutorials/custom-prompt-setup) 
    - 这份文档提到了oh my posh这一第三方shell prompt 美化模块
    - 还包括文件图标模块terminal-icons

### 终端通用外观美化

- [Windows 终端自定义配色方案指南 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/terminal/custom-terminal-gallery/custom-schemes)
  - 指导用户使用毛玻璃效果的terminal 背景
  - 对于普通的透明度调节,早已不是新鲜事物
  - windows terminal 使用亚克力模糊效果,让背景模糊更具特色

### 模糊与透明设置不生效

- 通常是笔记本端可能会遇到这类问题,特别是对于浅色主题的情况
- 新版本windows(比如win11 24h2)对省电模式进行了改进,使得通电情况下依然能够启用省电模式
- 省电模式启用后,会将一些模糊效果或半透明效果停用(这一影响包括Edge 浏览器中的某些设置窗口背景呈现灰色而不是半透明模糊效果)

## 小结

- 总结来说，Windows Terminal是对传统Windows Console Host的重大升级和替代品，提供了更多高级特性以满足开发者和高级用户的需要，同时也保持了向后兼容性，能够继续运行原有的命令行工具和脚本。


## 非应用商店直装版本

### scoop 方式安装

```powershell
#添加bucket可能失败,这里开了steam++(watt toolkit)加速服务,可能导致一些问题
PS C:\Users\cxxu> scoop bucket add extras
Checking repo... ERROR 'https://github.com/ScoopInstaller/Extras' doesn't look like a valid git repository

Error given:
fatal: unable to access 'https://github.com/ScoopInstaller/Extras/': SSL certificate problem: unable to get local issuer certificate
#我们关闭重试
PS C:\Users\cxxu> scoop bucket add extras
Checking repo... OK
The extras bucket was added successfully.
PS C:\Users\cxxu> scoop install windows-terminal
Installing 'windows-terminal' (1.20.11781.0) [64bit] from 'extras' bucket
Microsoft.WindowsTerminal_1.20.11781.0_x64.zip (11.0 MB) [===================] 100%
Checking hash of Microsoft.WindowsTerminal_1.20.11781.0_x64.zip ... ok.
Extracting Microsoft.WindowsTerminal_1.20.11781.0_x64.zip ... done.
Running pre_install script...done.
Running installer script...done.
Linking ~\scoop\apps\windows-terminal\current => ~\scoop\apps\windows-terminal\1.20.11781.0
Creating shim for 'WindowsTerminal'.
Making C:\Users\cxxu\scoop\shims\windowsterminal.exe a GUI binary.
Creating shim for 'wt'.
Making C:\Users\cxxu\scoop\shims\wt.exe a GUI binary.
Creating shortcut for Windows Terminal (WindowsTerminal.exe)
Persisting .portable
Persisting settings
Running post_install script...done.
'windows-terminal' (1.20.11781.0) was installed successfully!
Notes
-----
Add Windows Terminal as a context menu option by running `reg import
"C:\Users\cxxu\scoop\apps\windows-terminal\current\install-context.reg"`
'windows-terminal' suggests installing 'extras/vcredist2022'.
```

