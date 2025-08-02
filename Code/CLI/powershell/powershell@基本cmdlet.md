[toc]
#  reference 
- [What does $_. mean in PowerShell? (techgenix.com)](https://techgenix.com/dollar-sign-underscore-dot/)

- [about Automatic Variables - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.2)
- [ForEach-Object (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/foreach-object?view=powershell-7.2#description)

##  sort 排序

### ls|sort按访问时间排序

- `ls * | sort {$_.LastaccessTime}`

- ```bash
  PS D:\repos\scripts> ls |sort{$_.LastAccessTime }
  
          Directory: D:\repos\scripts
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a---        11/29/2021   7:48 PM           2290   readme.md
  -a---         4/25/2022   9:11 AM             86   package-lock.json
  -a---          5/9/2022   7:32 PM           2387   jsScripts.zip
  -a---         4/25/2022   8:47 AM              3   package.json
  d----        12/23/2022  10:21 AM                  ModulesByCxxu
  d----         1/26/2022  12:56 AM                  testDir
  d----          5/9/2022   9:05 PM                  jsScripts
  ```

  


-------
##  where过滤

- [Where-Object (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/where-object?view=powershell-7.3)

- `$_`经常使用在管道符中,作为前一个变量的输出对象来作为下一个命令的输入

  - (您可以从中提取需要的属性完成一定的逻辑)
  - 譬如,在作为筛选工具对象的`where-object`的值表达式中经常会用的`$_`

  - ```powershell 
    
    PS D:\repos\scripts> Get-Process | Where-Object {$_.ProcessName -eq ‘dllhost’}
    
     NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
     ------    -----      -----     ------      --  -- -----------
          9     1.98       7.06       0.02   17516   4 dllhost
         23     5.09      12.32       0.16   22184   4 dllhost
    ```

  - 为了提取合适的字段,您或许需要利用其他cmdlet(`format-list`(简写为`fl`)/`get-member`(`gm`)来获取准确的字段.



## where表达式中的模糊字符(通配字符串)

###  使用-like参数
- [about Wildcards - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_wildcards?view=powershell-7.2)

- 这可以让where命令更加好用

  - 例:

  - ```bash
    PS D:\repos\scripts> gcm *git*|where{$_.Name -like "git*"}|sort CommandType
    
    CommandType     Name                                               Version    Source
    -----------     ----                                               -------    ------
    Alias           gitBash -> git-cmd.exe                             0.0        Aliases
    Alias           gitCmdShell -> git-cmd.exe                         0.0        Aliases
    Function        gitAdd                                             0.0        functionsBy…
    Function        gitbook                                            0.0        functionsBy…
    Function        gitconfigEdit                                      0.0        functionsBy…
    Function        gitLogGraphDetail                                  0.0        functionsBy…
    Function        gitLogGraphSingleLine                              0.0        functionsBy…
    Function        gitNoRepeatValidate                                0.0        functionsBy…
    Function        gitS                                               0.0        functionsBy…
    Function        gitUpdateReposSimply                               0.0        functionsBy…
    Function        git_clone_shallow                                  0.0        functionsBy…
    Function        git_initial_email_name                             0.0        functionsBy…
    Function        git_proxy_set                                      0.0        functionsBy…
    Application     git-bash.exe                                       2.34.1.1   D:\exes\por…
    Application     git-cmd.exe                                        2.34.1.1   D:\exes\por…
    Application     git.exe
    ```

    

###  自带筛选器的cmdlet
- 某些cmdlet自带筛选器,自带筛器一般具有更好的性能


```powershell
SYNOPSIS
    Selects objects from a collection based on their property values.


    --------------- Example 1: Get stopped services ---------------

    Get-Service | Where-Object {$_.Status -eq "Stopped"}
    Get-Service | where Status -eq "Stopped"


    -------- Example 2: Get processes based on working set --------

    Get-Process | Where-Object {$_.WorkingSet -GT 250MB}
    Get-Process | Where-Object WorkingSet -GT (250MB)


    -------- Example 3: Get processes based on process name --------

    Get-Process | Where-Object {$_.ProcessName -Match "^p.*"}
    Get-Process | Where-Object ProcessName -Match "^p.*"
```
- 除了`$_`可以帮助用来构建脚本块表达式来辅助where 执行筛选
- 还有`select-string`这个十分有用的cmdlet

## 文本过滤

- 另见它文
