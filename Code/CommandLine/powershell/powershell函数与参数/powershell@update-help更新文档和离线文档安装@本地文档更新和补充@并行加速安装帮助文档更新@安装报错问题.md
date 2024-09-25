[toc]



## powershell update-help 

- [Update-Help (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/update-help?view=powershell-7.4)

- 虽然powershell会为cmdlet或者用户自定义的powershell函数生成文档,但是基本上仅限于函数参数的类型和属性信息,对于参数的直观描述往往是缺乏的,而且无法生成,例如`ls -path`这里的`-Path`参数的帮助文档

  - ```
    -Path <System.String[]>
        Specifies a path to one or more locations. Wildcards are accepted. The default location is the current directory (`.`).
    
        Required?                    false
        Position?                    0
        Default value                Current directory
        Accept pipeline input?       True (ByPropertyName, ByValue)
        Accept wildcard characters?  true
    ```

  - 如果没有安装相应文档，那么中间的一段描述` Specifies a path to one or more locations. Wildcards are accepted. The default location is the current directory (`.`).`就没有

- 在powershell中直接使用update-help可能会失败,特别是非英文系统

- 建议使用必要的参数来更新powershell的帮助文档,或者使用离线的方式更新或着安装文档,尤其是多台设备共享

### 为所有可用模块更新文档

- 英文文档一定存在，所以报错机率比较小
- 使用`verbose`参数来查看安装进度,及早发现问题

```powershell
 update-help -Verbose -UICulture en-US
```



### 为指定模块更新帮助文档

- 比如我们为模块`Microsoft.Powershell.Management`更新文档

- ```powershell
  PS🌙[BAT:99%][MEM:63.5% (4.99/7.85)GB][1:10:04]
  # [cxxu@CXXUREDMIBOOK][<W:192.168.1.46>][~]
  PS> update-help -Module Microsoft.PowerShell.Management -Verbose
  VERBOSE: Resolving URI: "https://aka.ms/powershell73-help"
  VERBOSE: Your connection has been redirected to the following URI: "https://pshelpprod.blob.core.windows.net/cabinets/powershell-7.3/"
  VERBOSE: Postponing error and trying fallback cultures, will show as error if none of fallbacks are supported:
  The specified culture is not supported: zh-CN. Specify a culture from the following list: {en-US}.
  VERBOSE: Resolving URI: "https://aka.ms/powershell73-help"
  VERBOSE: Your connection has been redirected to the following URI:
  ....
  
  Update-Help: Failed to update Help for the module(s) 'Microsoft.PowerShell.Management' with UI culture(s) {zh-CN} : The specified culture is not supported: zh-CN. Specify a culture from the following list: {en-US}..
  English-US help content is available and can be installed using: Update-Help -UICulture en-US.
  
  
  
  PS🌙[BAT:99%][MEM:62.73% (4.92/7.85)GB][1:11:03]
  # [cxxu@CXXUREDMIBOOK][<W:192.168.1.46>][~]
  PS> update-help -UICulture en-US -Verbose -Module Microsoft.Powershell.Management
  VERBOSE: Resolving URI: "https://aka.ms/powershell73-help"
  VERBOSE: Your connection has been redirected to the following URI: "https://pshelpprod.blob.core.windows.net/cabinets/powershell-7.3/"
  VERBOSE: Performing the operation "Update-Help" on target "Microsoft.PowerShell.Management, Current Version: 0.0.0.0, Available Version: 7.3.0.0, UICulture: en-US".
  VERBOSE: Microsoft.PowerShell.Management: Updated C:\Users\cxxu\Documents\PowerShell\Help\en-US\Microsoft.PowerShell.Commands.Management.dll-Help.xml. Culture en-US Version 7.3.0.0
  ```

  

## 保存文档到本地(save-help)

[Save-Help (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/save-help?view=powershell-7.4)

你需要指定一个存在的目录作为`Save-Help`的参数,否则无法保存

```powershell
PS🌙[BAT:99%][MEM:53.45% (4.2/7.85)GB][1:30:55]
# [cxxu@CXXUREDMIBOOK][<W:192.168.1.46>][~\Desktop]
PS> Save-Help  -Verbose -UICulture en-US -DestinationPath C:\Share\

VERBOSE: Resolving URI: "https://aka.ms/powershell73-help"
VERBOSE: Your connection has been redirected to the following URI: "https://pshelpprod.blob.core.windows.net/cabinets/powershell-7.3/"
VERBOSE: CimCmdlets: Saved C:\Share\CimCmdlets_fb6cc51d-c096-4b38-b78d-0fed6277096a_en-US_HelpContent.cab. Culture en-US Version 7.3.0.0
VERBOSE: Resolving URI: "https://aka.ms/powershell73-help"
VERBOSE: Your connection has been redirected to the following URI: 
...
VERBOSE: Your connection has been redirected to the following URI: "https://pshelpprod.blob.core.windows.net/cabinets/powershell-7.3/"
VERBOSE: Microsoft.PowerShell.Core: Saved C:\Share\Microsoft.PowerShell.Core_00000000-0000-0000-0000-000000000000_en-US_HelpContent.cab. Culture en-US Version 7.3.0.0

PS🌙[BAT:99%][MEM:33.57% (2.64/7.85)GB][1:34:18]
# [cxxu@CXXUREDMIBOOK][<W:192.168.1.46>][~\Desktop]
```

安装了快5分钟才结束,总体积大约2~3MB

### 使用并行下载策略

```powershell
$modules = Get-Module -ListAvailable | Where-Object -Property HelpInfoUri

$Destination = 'C:\PsHelpx' #指定你想要的下载目录即可
New-Item -ItemType Directory -Path $Destination -Verbose -Force

$modules.Name | ForEach-Object -Parallel {
    # param($Destination)
    $Destination = $using:Destination
    #这里可以指定verbose观察输出，也可以不使用-Verbose详情，检查下载目录即可
    Save-Help -Verbose -Module $_ -DestinationPath $Destination -UICulture en-us -ErrorAction SilentlyContinue
} -ThrottleLimit 64 
```

耗时在10秒内

也可以用并发的方式在线安装

```powershell
$modules = Get-Module -ListAvailable | Where-Object -Property HelpInfoUri

$modules.Name | ForEach-Object -Parallel {
 
    #这里可以指定verbose观察输出，也可以不使用-Verbose详情，检查下载目录即可
    update-help -Verbose -Module $_  -UICulture en-us # -ErrorAction SilentlyContinue
} -ThrottleLimit 64 
```



### 分享给其他设备安装

- 局域网内可以使用smb等工具分享，也可以配合robocopy传输内容给对方

- 对方接受后执行`update-help`命令安装(注意仍然要指定`-UICulture en-us`),部分模块的文档会安装失败,这种情况下需要手动补充安装

  