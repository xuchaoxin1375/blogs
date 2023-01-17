@[toc]
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

##  select-string过滤

- 缩写别名为`sls`


- [Select-String (Microsoft.PowerShell.Utility) - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-string?view=powershell-7.2)

- [reference link2](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-string?view=powershell-7.2#example-2--find-matches-in-text-files)
- 实例代码:

```ps1
生成演示素材文件:`Alias.txt` /`Command.txt`
Get-Alias | Out-File -FilePath .\Alias.txt
Get-Command | Out-File -FilePath .\Command.txt
# 利用sls进行多文件同时查找
Select-String -Path .\*.txt -Pattern 'File'
```
- 处理从文件中刷选满足条件的行,也可以通过管道符来使用`sls`
- sls相比于`where`更加灵活,也更加强大

### 例

####  多目录多文件中搜索指定内容模式串

```bash
PS D:\repos\scripts\ModulesByCxxu> sls -Path ./**/*.* -Pattern "git"

Aliases\aliases.ps1:134:gitCmdShell git-cmd
Aliases\aliases.ps1:135:gitBash git-cmd
Aliases\aliases.ps1:158:#  newGitCreationLink "https://gitee.com/projects/new/"
colorSettings\readme.md:4:    #the posh has its default theme(set by the oh-my-posh and
posh-git module!(the default(basic) theme take 1000ms about to load theme)),so even you
don't set the poshPrompt,it has its default theme and overhead(performance consume)
functionsByCxxu\functionsByCxxu.psm1:52:    Import-Module posh-git
functionsByCxxu\functionsByCxxu.psm1:57:    Remove-Module posh-git
functionsByCxxu\functionsByCxxu.psm1:76:function gitbook
functionsByCxxu\functionsByCxxu.psm1:382:function gitconfigEdit
functionsByCxxu\functionsByCxxu.psm1:384:    c $env:userProfile\.gitconfig
functionsByCxxu\functionsByCxxu.psm1:386:function git_initial_email_name
functionsByCxxu\functionsByCxxu.psm1:388:    git config --global user.email
'838808930@qq.com'
functionsByCxxu\functionsByCxxu.psm1:389:    git config --global user.name 'cxxu'
functionsByCxxu\functionsByCxxu.psm1:614:function git_clone_shallow
```


###  在管道符中使用sls

- 在管道符表达式中,管道符前的结果将默认作为`sls`的第一个参数(但是最好带上参数来指明各个`值`的含义

  - `ls |sls -Pattern "<your Match pattern string>"`

- 某种程度上进一步实现了`grep`的一些效果.



##  grep for windows

- `grep`是基于文本流的筛选工具
- 只需要考虑文本正则表达式的编写即可使用
- 在powershell中,可以通过安装第三方工具实现grep(用法于Linux上的有所区别)
- (可以通过`scoop`搜索相关工具并安装)

```powershell
PS C:\Users\cxxu_11> scoop search grep
'main' bucket:
    busybox (4487-gd239d2d52) --> includes 'egrep'
    gettext (0.21-v1.16) --> includes 'msggrep.exe'
    gow (0.8.0) --> includes 'egrep.exe'
    grep (2.5.4)
    nim (1.6.0) --> includes 'nimgrep.exe'
    pcregrep (10.20)
    ripgrep (13.0.0)
    rktools2k3 (1.0) --> includes 'qgrep.exe'
    ugrep (3.3.8)
    unxutils (2007.03.01) --> includes 'agrep.exe'
```
- 例如,可以安装第一个工具箱,内部就包含有grep工具

- ```bash
  PS D:\repos\scripts\ModulesByCxxu> grep --help
  BusyBox v1.36.0-FRP-4784-g5507c8744 (2022-11-09 08:26:33 GMT)
  
  Usage: grep [-HhnlLoqvsrRiwFE] [-m N] [-A|B|C N] { PATTERN | -e PATTERN... | -f FILE... } [FILE]...
  
  Search for PATTERN in FILEs (or stdin)
  
          -H      Add 'filename:' prefix
          -h      Do not add 'filename:' prefix
          -n      Add 'line_no:' prefix
          -l      Show only names of files that match
          -L      Show only names of files that don't match
          -c      Show only count of matching lines
          -o      Show only the matching part of line
          -q      Quiet. Return 0 if PATTERN is found, 1 otherwise
          -v      Select non-matching lines
          -s      Suppress open and read errors
          -r      Recurse
          -R      Recurse and dereference symlinks
          -i      Ignore case
          -w      Match whole words only
          -x      Match whole lines only
          -F      PATTERN is a literal (not regexp)
          -E      PATTERN is an extended regexp
          -m N    Match up to N times per file
          -A N    Print N lines of trailing context
          -B N    Print N lines of leading context
          -C N    Same as '-A N -B N'
          -e PTRN Pattern to match
          -f FILE Read pattern from file
  ```

  

- ```powershell
  PS C:\Users\cxxu_11> printenv | grep apps -i
  
  CPwindowsApps=C:\Program Files\windowsApps
  oneNote10Home=C:\Program Files\windowsApps\Microsoft.Office.OneNote_16001.14326.20458.0_x64__8wekyb3d8bbwe
  Path=D:\Program Files\PowerShell\7;C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.9.1942.0_x64__8wekyb3d8bbwe;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;
  ```



