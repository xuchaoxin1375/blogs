[toc]

# vscode@powershellExtension配置和启用问题.md

## 文档

- [PowerShell editing with Visual Studio Code](https://code.visualstudio.com/docs/languages/powershell)
- [使用 Visual Studio Code 进行 PowerShell 开发 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/dev-cross-plat/vscode/using-vscode?view=powershell-7.3)

### 插件官网

- [PowerShell - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
  - This extension provides rich PowerShell language support for [Visual Studio Code](https://github.com/Microsoft/vscode) (VS Code). 
  - Now you can write and debug PowerShell scripts using the excellent IDE-like interface that VS Code provides.

### 工作组件

- This extension is powered by 
  -  **PowerShell language server**,
  -  [PowerShell Editor Services](https://github.com/PowerShell/PowerShellEditorServices). 
- This leverages the [Language Server Protocol](https://microsoft.github.io/language-server-protocol/) where `PowerShellEditorServices` is the server and `vscode-powershell` is the client.

###  vscode powershell插件支持的powershel版本

- [Changelog | Visual Studio Marketplace](https://marketplace.visualstudio.com/items/ms-vscode.PowerShell/changelog)
  - The extension *should* work anywhere VS Code itself and **PowerShell Core 7.2** or higher is [supported](https://docs.microsoft.com/en-us/powershell/scripting/powershell-support-lifecycle). 

  - For Windows PowerShell, only version 5.1 is supported. 

  - Please note that PowerShell Core 6 is end-of-life and so not supported
- PowerShell 7.4+ and Windows PowerShell 5.1 (on a best-effort basis) are now solely supported as 7.3 LTS and 7.2 are past end-of-support.

## 不同版本powershell对比🎈

- windows powershell 和powershell core 是差别巨大的不同版本的powershell
  - 前者是windows系统自带的版本
- 但他们统称为powershell
- 现在提到powershell时,通常指的是`powershell core`

### winodws自带的powershell和新powershell平台

- 新powershell平台是更受推荐的版本,windows自带的powershell全称是`windows powershell`,是专属于windows系统的powershell,它在windows中占用了`powershell`这个简写命令名
- 而新平台powershell的简写名称为`pwsh`,可以被安装到不同系统,以及自定义安装目录(尤其是便携版,可以不用安装而能直接运行)

### powershell命令不可用@找不到指定命令🎈

- 版本问题

  - 有些命令是windows 自带的powershell (v5)才有的命令

    - ```powershell
      PS C:\Windows\system32> $PSVersionTable
      
      Name                           Value
      ----                           -----
      PSVersion                      5.1.22621.963
      PSEdition                      Desktop
      PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
      BuildVersion                   10.0.22621.963
      CLRVersion                     4.0.30319.42000
      WSManStackVersion              3.0
      PSRemotingProtocolVersion      2.3
      SerializationVersion           1.1.0.1
      ```

  - 例:`Get-WinUserLanguageList`这个命令在powershell 7中找不到

    - ```powershell
      PS C:\Windows\system32> Get-WinUserLanguageList
      
      
      LanguageTag     : en-US
      Autonym         : English (United States)
      EnglishName     : English
      LocalizedName   : English (United States)
      ScriptName      : Latin
      InputMethodTips : {0409:00000409}
      Spellchecking   : True
      Handwriting     : False
      
      LanguageTag     : zh-Hans-CN
      Autonym         : 中文(中华人民共和国)
      EnglishName     : Chinese
      LocalizedName   : Chinese (Simplified, China)
      ScriptName      : Chinese (Simplified)
      InputMethodTips : {0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411F-A5AC-CA038EC515D7},
                        0804:{E7EA138E-69F8-11D7-A6EA-00065B844310}{E7EA138F-69F8-11D7-A6EA-00065B844311}}
      Spellchecking   : True
      Handwriting     : True
      ```

- 权限问题

  - 以不同权限运行的powershell可以看到和使用的命令也是不同的

  - 同时在powershell 5中需要以管理员方式运行的情况下才能找到该命令

## 添加自己的powershell客户端版本

- [将你自己的 PowerShell 路径添加到会话菜单|使用 Visual Studio Code 进行 PowerShell 开发 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/dev-cross-plat/vscode/using-vscode?view=powershell-7.4#adding-your-own-powershell-paths-to-the-session-menu)

- 英文文档更加易于比较和设置settings.json：[Using Visual Studio Code for PowerShell Development - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/vscode/using-vscode?view=powershell-7.4#adding-your-own-powershell-paths-to-the-session-menu)

- 你的计算机上可以存在多个powershell版本
  - 比如你可以通过winget或者msi安装包安装到(全局安装)默认路径(`C:\Program files\powershell`)
  - 或者通过其他安装工具比如scoop进行全局安装,那么路径为`C:\ProgramData\scoop`下的`apps`目录,而启动方式可以在`shims`目录下找到,那么可以在相应的vscode配置settings.json数组里面写入一行新条目(如果)

### Session Menu command

vscode中powershell插件可以使用和关联的powershell版本在`session menu command`中选择;

而通过编辑`PowerShell: PowerShell Additional Exe Paths`可以定义这个选择列表;

### settings.json中配置

```json
    "powershell.powerShellAdditionalExePaths": {
        "pwsh(scoop)": "C:\\ProgramData\\scoop\\shims\\pwsh.exe",
        "pwsh7.2.4(scoop)":"C:\\Users\\cxxu\\scoop\\apps\\powershell\\7.2.4\\pwsh.exe"
    }
```

### GUI可视化配置

- 在设置中搜索`powershell.powerShellAdditionalExePaths`

- 例如,我要添加名为`pwsh7.3`,且可执行文件绝对路径为`C:\Program Files\powershell\7\pwsh.exe`
- 通常推荐使用gui进行配置
  - 这是因为,配置的时候不需要定位到具体的json对象
  - 对于windows环境下路径不需要手动转移反斜杠
- 配置完,settings.json文件中的添加了如下内容

- ```bash
  "powershell.powerShellAdditionalExePaths": {
  	"pwsh7.3": "C:\\Program Files\\powershell\\7\\pwsh.exe"
  }
  ```

## powershell插件加载问题👺

最常见的是vscode powershell插件启动的powershell被阻塞(例如在vscode集成终端中又启动了一个交互式powershell会话,这会导致powershell插件的主要功能失效,直到退出新启动的交互式shell会话)

另一类可能是windows powershell(v5.1)的问题,考虑切换到powershell 7(pwsh)

- 系统powershell版本不符合vscode powershell插件的支持

- 配置的非默认powershell 版本的路径设置出现问题
  - 也可能是重装软件导致路径发生变更
  - 或者vscode软件/powershell extension版本更新导致接口更新,需要更新配置格式(需要查阅最新文档)

- `"powershell.powerShellAdditionalExePaths"`配置合适的pwsh版本
  
- command pallet: 输入`PowerShell.ShowSessionMenu`切换powershell版本

### 检查插件日志

- 在输出日志中检查异常报告(`Focus on output view`,例如:

  ```powershell
  8/23/2024 9:31:01 PM [WARNING] - The 'powerShellDefaultVersion' setting was 'Powershell (x64)' but this was not found! Instead using first available installation 'Windows PowerShell (x64)' at 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'!
  ```

- 注意,我们在vscode的集成终端的选项卡中点击OUTPUT选项卡,在右侧的下拉框中选择`Powershell Extension Logs`;或者通过`ctrl+shift+p`(command palette)中输入`powershell:show Powershell extension logs`来切换到输出日志

### vscode中的powershell不加载profile配置

PowerShell 的 profile（配置文件）本质是启动时自动执行的脚本，比如：

```
$PROFILE
```

它可能对应：

| 作用范围             | 路径示例                                                |
| -------------------- | ------------------------------------------------------- |
| 当前用户 + 当前 host | `Documents\PowerShell\Microsoft.VSCode_profile.ps1`     |
| 当前用户 + 所有 host | `Documents\PowerShell\Microsoft.PowerShell_profile.ps1` |

```powershell
(base) PS C:\repos\scripts> $PROFILE                                                                                                                                         
C:\Users\Administrator\Documents\PowerShell\Microsoft.VSCode_profile.ps1

(base) PS C:\repos\scripts> $PROFILE | select *     

AllUsersAllHosts       : C:\scoop\apps\powershell\current\profile.ps1
AllUsersCurrentHost    : C:\scoop\apps\powershell\current\Microsoft.VSCode_profile.ps1
CurrentUserAllHosts    : C:\Users\Administrator\Documents\PowerShell\profile.ps1
CurrentUserCurrentHost : C:\Users\Administrator\Documents\PowerShell\Microsoft.VSCode_profile.ps1
Length                 : 72
```

#### 关键原因：VS Code 使用的是特殊 Host

VS Code 插件并不是直接启动普通的 `pwsh`，而是用一个专用 host：

```
Visual Studio Code Host
```

所以它加载的是：

```
Microsoft.VSCode_profile.ps1
```

而不是你平时终端用的：

```
Microsoft.PowerShell_profile.ps1
```

这就是你“看起来 profile 没执行”的根本原因。

### VS Code 为什么不用普通 pwsh？

关键点：
 Visual Studio Code 并不是简单开一个终端，它需要一个**可控的 PowerShell 运行环境（host environment）**。

普通终端启动：

```
pwsh → 直接交互
```

VS Code 启动：

```
pwsh → VSCode Host → 语言服务（Language Server）→ 编辑器
```

### 核心原因一：需要语言服务（Language Server）

VS Code 的 PowerShell 插件（PowerShell extension for Visual Studio Code）要提供：

- 自动补全（IntelliSense）
- 语法检查（linting）
- 变量分析
- 调试（debugging）

这些功能依赖：`PowerShell Editor Services`

这个服务必须运行在一个“受控环境”里，而不是你随便一个 pwsh。

### 核心原因二：防止 profile 污染环境

如果直接加载你的 profile，会出现很多问题：

#### 举个真实例子

你的 profile 里可能有：

```
Import-Module oh-my-posh
Set-Alias ls ls -Force
cd D:\workspace
```

那会导致：

| 问题       | 结果             |
| ---------- | ---------------- |
| 修改 alias | 插件解析命令出错 |
| 自动 cd    | 工作目录混乱     |
| 输出内容   | 干扰语言服务通信 |
| 加载慢模块 | VS Code 卡顿     |

 所以 VS Code 必须“隔离环境（isolation）”。

### 隐藏powershell extesion terminal

让 VS Code 用“普通 pwsh 终端”，而不是 PowerShell 插件的集成 shell。

在 Visual Studio Code 里，其实有两套 PowerShell：

| 类型                         | 作用                       | 是否可见     |
| ---------------------------- | -------------------------- | ------------ |
| PowerShell Extension Session | 给插件用（语言服务、调试） | ❌ 不需要你用 |
| Integrated Terminal (pwsh)   | 给你用的终端               | ✅ 你看到的   |

如果启用了这个选项:`powershell.integratedConsole.showOnStartup`,则建议关闭

> 这不会从终端列表中隐藏`powershell extension`,只是默认shell是普通powershell(和powershell插件无关)
>
> 为了让powershell插件的功能生效,`powershell extension`这个shell必须保留在终端列表里,而不应该关闭;

不过vscode还提供了另一个彻底隐藏`powershell extension terminal`的选项:`powershell.integratedConsole.startInBackground`;这样终端列表中就看不见powershell extensioin 这个特殊terminal.


