[toc]

# vscode@powershellExtension配置和启用问题.md

## refs

- [PowerShell editing with Visual Studio Code](https://code.visualstudio.com/docs/languages/powershell)
- [使用 Visual Studio Code 进行 PowerShell 开发 - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/dev-cross-plat/vscode/using-vscode?view=powershell-7.3)

### 插件官网

- [PowerShell - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
  - This extension provides rich PowerShell language support for [Visual Studio Code](https://github.com/Microsoft/vscode) (VS Code). 
  - Now you can write and debug PowerShell scripts using the excellent IDE-like interface that VS Code provides.

#### 工作组件

- This extension is powered by 
  -  **PowerShell language server**,
  -  [PowerShell Editor Services](https://github.com/PowerShell/PowerShellEditorServices). 
- This leverages the [Language Server Protocol](https://microsoft.github.io/language-server-protocol/) where `PowerShellEditorServices` is the server and `vscode-powershell` is the client.

####  Platform Support

- [Changelog | Visual Studio Marketplace](https://marketplace.visualstudio.com/items/ms-vscode.PowerShell/changelog)

- 截至2022年最后一个版本的情况如下:

  - The extension *should* work anywhere VS Code itself and **PowerShell Core 7.2** or higher is [supported](https://docs.microsoft.com/en-us/powershell/scripting/powershell-support-lifecycle). 

  - For Windows PowerShell, only version 5.1 is supported. 

  - Please note that PowerShell Core 6 is end-of-life and so not supported

- powershell Core 7.2以及之后的版本都支持
  - powershell core 6不再支持

### 不同版本powershell对比🎈

- windows powershell 和powershell core 是差别巨大的不同版本的powershell
  - 前者是windows系统自带的版本
- 但他们统称为powershell
- 现在提到powershell时,通常指的是`powershell core`

#### winodws powershell 

- ```powershell
  PS D:\repos\scripts> $PSVersionTable
  
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

#### powershell core 7.2+

- 

  ```powershell
  PS D:\repos\scripts> $psVersionTable
  
  Name                           Value
  ----                           -----
  PSVersion                      7.3.1
  PSEdition                      Core
  GitCommitId                    7.3.1
  OS                             Microsoft Windows 10.0.2…
  Platform                       Win32NT
  PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0…}
  PSRemotingProtocolVersion      2.3
  SerializationVersion           1.1.0.1
  WSManStackVersion              3.0
  ```



## 添加自己的powershell客户端版本

- [adding-your-own-powershell-paths-to-the-session-menu | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/scripting/dev-cross-plat/vscode/using-vscode?view=powershell-7.3#adding-your-own-powershell-paths-to-the-session-menu)

### 可视化配置

- 在设置中搜索`powershell.powerShellAdditionalExePaths`
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/f610cdf201ed4319acb6b68a911776ea.png)

#### 添加powershell版本

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

## powershell插件加载问题

- 如果您的系统powershell版本不符合vscode powershell插件的支持

- 或者配置的非默认powershell 版本的路径设置出现问题
  - 也可能是重装软件导致路径过期
  - 或者vscode软件/powershell extension版本更新导致接口更新,需要更新配置格式(需要查阅最新文档)

