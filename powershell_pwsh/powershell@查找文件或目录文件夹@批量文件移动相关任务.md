[toc]



## 查找所有目录@文件

* 列出一个目录下所有层级子目录,而不显示文件

  * `ls -Recurse -Directory`

  * 可以指定字段,紧凑地显示`ls -Recurse -Directory|select name,FullName`

  * ```powershell
    PS 🕰️1:43:56 AM [C:\repos\scripts\ModulesByCxxu] 🔋100% ls -Recurse -Directory|select name,FullName
    
    Name                             FullName
    ----                             --------
    .vscode                          C:\repos\scripts\ModulesByCxxu\.vscode
    Aliases                          C:\repos\scripts\ModulesByCxxu\Aliases
    colorSettings                    C:\repos\scripts\ModulesByCxxu\colorSettings
    ```

* 列出一个目录下所有文件(而不显示子目录),是类似地

  * `ls -Recurse -File`
  * 紧凑显示(和目录的类似)`ls -Recurse -Directory|select FullName`

* 统计目录下子目录或文件的数量

  - 文件数量`ls -Recurse -Directory|Measure-Object |select count`
  - 目录数量类似

## 搜索文件(search files)

### 简单搜索

- 根据文件名搜索文件:通常使用`ls -file $pattern`即可扫描当前目录,如果需要递归扫描,带上`-R`参数

  - ```bash
    PS 🕰️9:37:10 PM [C:\repos\scripts] 🔋100% ls -file *.txt -Recurse
    
            Directory:
        C:\repos\scripts\linuxShellScripts\linuxShellScripts_bak\sedLearn
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         3/29/2022   6:26 PM             38 󰈙  coleridge.txt
    -a---         3/29/2022   6:26 PM            429 󰈙  data.txt
    
            Directory: C:\repos\scripts\linuxShellScripts\sedLearn
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         1/16/2024   2:32 PM             38 󰈙  coleridge.txt
    -a---         3/30/2022   8:22 PM           1149 󰈙  input.txt
    -a---         3/30/2022  11:54 PM            277 󰈙  output.txt
    ```

- 如果要扫描指定目录,使用`-path`参数

  - ```bash
    PS 🕰️9:40:50 PM [C:\repos\scripts] 🔋100% ls -file *.txt -R -path C:\repos\scripts\startup\
    
            Directory: C:\repos\scripts\startup\log
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         2/12/2024   1:38 PM            453 󰈙  log.txt
    -a---         2/12/2024  12:58 PM            500 󰈙  MapLog.txt
    ```

- 如果要将结果紧凑的展示,考虑用`select`(即`select-object`)来进一步处理

  - ```powershell
    PS 🕰️9:46:08 PM [C:\repos\scripts] 🔋100% ls -file *.txt -R|select name,FullName
    
    Name          FullName
    ----          --------
    coleridge.txt C:\repos\scripts\linuxShellScripts\linuxShellScripts_bak\se…
    data.txt      C:\repos\scripts\linuxShellScripts\linuxShellScripts_bak\se…
    coleridge.txt C:\repos\scripts\linuxShellScripts\sedLearn\coleridge.txt
    input.txt     C:\repos\scripts\linuxShellScripts\sedLearn\input.txt
    output.txt    C:\repos\scripts\linuxShellScripts\sedLearn\output.txt
    0.txt         C:\repos\scripts\pythonScripts\test_rename_dir\0.txt
    1.txt         C:\repos\scripts\pythonScripts\test_rename_dir\1.txt
    log.txt       C:\repos\scripts\startup\log\log.txt
    MapLog.txt    C:\repos\scripts\startup\log\MapLog.txt
    ```

    

### 显示输出格式控制函数版本

- 函数本身不长,主要是文档和用法说明占了大量篇幅(为了快速该掌握函数的用法)

  ```powershell
  function search_item
  {
      
      param(
          #这个参数传给ls 的-filter ,因此pattern变量也可以命名为filter,或filter_pattern
          $pattern = '',
          #指定要在哪个目录展开扫描    
          $path = '.',
  
          # 是否显示路径的类型,是一个开关式参数
          [switch]$PathType,
          
          #该参数可以接受ls 同样的参数[注意pattern,path两个参数比较常用,这里要放在外部单独传入]
          $args_ls = '',
  
          #该参数是select-object处理ls 管道传输过来的对象,常用的字段比如:FullName
          $args_select = ''
      )
      Write-Output "pattern:$pattern"
  
      $RelativePath = @{
          Name       = 'RelativePath';
          Expression = {
              '.' + ((Resolve-Path $_) -replace ($pwd -replace '\\', '\\'), '') 
          } 
          #这里自定义一个字段用来计算相对路径字段,这里用的是-replace,需要对正则有所了解;
          # 也可以用字符串方法定位和移除文件绝对路径的工作目录部分
      }
      #定义显示路径是文件还是文件夹的字段,比如也可以命名为FileOrDirectory,不要和参数$PathType混淆
      $Type = @{n = 'Type'; e = 
          {
              $_.PSIsContainer ? 'Directory' : 'File' 
          } 
      }
      #利用where过滤掉空字符串参数
      $fields = 'name', ($PathType ? $Type : ''), $RelativePath | Where-Object { $_ -ne '' }
      # Write-Output "[$($fields -join ',')]"
      #使用三元运算符,根据参数$args_select 是否来创建新数组,以便传递给select 筛选需要的字段
      $fields = $args_select -ne '' ? ($fields + $args_select):$fields
      "Get-ChildItem -filter $pattern  -R $args_ls" | Invoke-Expression | Select-Object $fields
      
  
      <# 
      .SYNOPSIS
      从当前目录开始递归查找具有指定名称的文件或者目录,尽可能以紧凑表格的方式列出,允许自定义文件信息字段
      如果指定的字段过多,比如总数达到5个或更多会变成列表式(Name,type,RelativePath)始终显示;也可以用管道符`|ft`强制为表格输出
      当然可以修改代码改变这一默认行为(例如在windows下往往没有后缀名的就是文件夹,显示路径类型可能有点鸡肋,
      但是有时还是有用的,比如我们希望排序,让文件列在前面而目录在后等)
      (需要对ls返回的对象有所了解,结合select 筛选需要的字段)
      显示找到的文件的名称,以及其相对于当前工作目录的路径,可以指定更多字段,当然也支持根据字段进行排序
  
      有的目录或文件格式往往不要扫描,例如node_modules,可以传入 -Exclude '*node_modules*'(或者配置为默认跳过)
  
      本函数主要是对ls所作的一个包装,将递归扫描的结果紧凑的显示出来,并且计算了相对路径(如果从当前目录开始扫描)
  
      .EXAMPLE
      PS 🕰️11:31:45 PM [C:\Users\cxxu\Desktop] 🔋100% search_item -pattern *.txt -args_select basename,fullname
      pattern:*.txt
  
      Name     RelativePath BaseName FullName
      ----     ------------ -------- --------
      demo.txt .\demo.txt   demo     C:\Users\cxxu\Desktop\demo.txt
      .EXAMPLE
      PS 🕰️12:29:58 PM [C:\repos\scripts] 🔋100% search_item *log -args_select fullname
      pattern:*log
  
      Name            RelativePath           FullName
      ----            ------------           --------
      aira.log        .\aria\aira.log        C:\repos\scripts\aria\aira.log
      log             .\data\log             C:\repos\scripts\data\log
      log.log         .\data\log\log.log     C:\repos\scripts\data\log\log.log
      20221223(0).log .\Logs\20221223(0).log C:\repos\scripts\Logs\20221223(0).log
      log             .\startup\log          C:\repos\scripts\startup\log
      .EXAMPLE
      PS 🕰️12:30:03 PM [C:\repos\scripts] 🔋100% search_item *log -args_select fullname -PathType
      pattern:*log
  
      Name            Type      RelativePath           FullName
      ----            ----      ------------           --------
      aira.log        File      .\aria\aira.log        C:\repos\scripts\aria\aira.log
      log             Directory .\data\log             C:\repos\scripts\data\log
      log.log         File      .\data\log\log.log     C:\repos\scripts\data\log\log.log
      20221223(0).log File      .\Logs\20221223(0).log C:\repos\scripts\Logs\20221223(0).log
      log             Directory .\startup\log          C:\repos\scripts\startup\log
  
      .EXAMPLE
      PS 🕰️12:31:08 PM [C:\repos\scripts] 🔋100% search_item *log -args_select fullname -PathType |sort type
  
      Name            Type      RelativePath           FullName
      ----            ----      ------------           --------
      log             Directory .\data\log             C:\repos\scripts\data\log
      log             Directory .\startup\log          C:\repos\scripts\startup\log
      aira.log        File      .\aria\aira.log        C:\repos\scripts\aria\aira.log
  
      .EXAMPLE
      PS 🕰️12:31:26 PM [C:\repos\scripts] 🔋100% search_item *log -args_select fullname -args_ls "-file"
      pattern:*log
  
      Name            RelativePath           FullName
      ----            ------------           --------
      aira.log        .\aria\aira.log        C:\repos\scripts\aria\aira.log
      log.log         .\data\log\log.log     C:\repos\scripts\data\log\log.log
      20221223(0).log .\Logs\20221223(0).log C:\repos\scripts\Logs\20221223(0).log
      
      .EXAMPLE
      #共有5个字段,因此会变成列表式输出(可能收powershell版本影响)
      PS 🕰️12:53:58 AM [C:\repos\scripts] 🔋100% search_item *log -args_select basename,fullname -pathType
      pattern:*log
  
      Name         : aira.log
      Type         : File
      RelativePath : .\aria\aira.log
      BaseName     : aira
      FullName     : C:\repos\scripts\aria\aira.log
  
      Name         : log
      Type         : Directory
      RelativePath : .\data\log
      BaseName     : log
      FullName     : C:\repos\scripts\data\log
  
      .EXAMPLE
      PS 🕰️12:33:54 PM [C:\repos\scripts] 🔋100% search_item *rename* -args_select basename,fullname -PathType|ft
      pattern:*rename*
  
      Name                    Type      RelativePath                               BaseName           FullName
      ----                    ----      ------------                               --------           --------
      rename_prefix.data.json File      .\.mypy_cache\3.12\rename_prefix.data.json rename_prefix.data C:\repos\scripts\.mypy…
      rename_prefix.meta.json File      .\.mypy_cache\3.12\rename_pre
      #>
  }
  
  ```

- 查看帮助文档和用例

  ```
  PS 🕰️11:41:19 PM [C:\Users\cxxu\Desktop] 🔋100% help search_item
  
  NAME
      search-item
  
  SYNOPSIS
     ....
  
  SYNTAX
      searchFiles_tight [[-pattern] <Object>] [[-path] <Object>] [[-args_ls] <Object>] [[-args_select] <Object>]
      [<CommonParameters>]
  ```

### TODO

- 函数进一步加入管道符的支持

## 批量文件移动

### 含有文件名特征集合

- 当前目录下关于`powershell`的笔记散落在各个不同子目录中

  ```bash
  PS BAT [11:07:53 PM] [C:\repos\blogs]
  [🔋 100%] MEM:47.65% [3.74/7.85] GB |ls -R -File -Filter *powershell*
  
          Directory: C:\repos\blogs\editorSkills
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a---          3/4/2023   3:36 PM          15788   powershell@输入法管理.md
  
          Directory: C:\repos\blogs\editorSkills\vscode
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a---          3/5/2023   8:07 PM           6519   vscode@powershellExtension配置和启用问题.md
  
          Directory: C:\repos\blogs\linux
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a---         2/15/2024   5:58 PM          20320   powershell@windows@linux环境变量查询.md
  -a---         2/14/2024   8:14 PM           1699   powershell@从脚本文件中导入函数.md
  -a---         2/15/2024  11:01 PM           2028   powershell@文字转语音.md
  
          Directory: C:\repos\blogs\linux\powershell
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a---         11/5/2022   6:36 PM           2747   powershell_linux.md
  -a---          6/6/2022  10:25 AM              0   powershell_进程任务管理.md
  -a---         5/24/2023   9:36 PM          26243   powershellbash硬链接Hardlink@软连接(符号链接)创建@linux符号链接检查.md
  
          Directory: C:\repos\blogs\powershell_pwsh
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a---         2/25/2023   2:59 PM          14728   powershell_管道符函数pipelineSupport.md
  -a---          3/5/2023   4:14 PM          10281   powershell_配置文件与脚本编写(模板字符串插值@运算符与表达式@函数参数@控制流).md
  -a---          3/1/2023   2:05 PM           7102   powershell@CLI命令行创建和修改windows快捷方式@shortcut.md
  -a---         2/12/2024   3:20 PM           3807   powershell@proxy代理配置.md
  -a---         2/14/2024   7:31 PM           9111   powershell@setx环境变量配置@env_permanently.md
  -a---         2/15/2024  12:08 PM          11029   powershell@使用指南与入门命令@starter@beginner.md
  -a---         9/25/2023   8:47 AM          14439   powershell@别名@命令异常排查.md
  -a---         1/11/2024   3:44 PM           5292   powershell@基本cmdlet.md
  -a---        12/30/2022   3:04 PM           3216   powershell@控制流@continue和foreach.md
  -a---         2/13/2024  12:38 PM          10880   powershell@查找文件或目录文件夹.md
  -a---         2/14/2024   4:54 PM           3138   powershell@根据文件内容查找文件.md
  -a---         2/25/2023   2:47 PM          11099   powershell@格式化字符串@管道符函数编写@powershell类似cat
                                                   -n(查看文件显示行号)@powershell查看文件指定范围的行@输出格式化format-table.md
  -a---         2/12/2024  12:52 PM            682   powershell@获取脚本文件自身所在路径.md
  -a---         1/10/2024   2:03 PM          15577   powershell@进程与服务管理.md
  -a---          2/9/2024  11:54 AM          13767   powershell@通配符和正则匹配like@match@字符串替换.md
  -a---         3/31/2023  11:21 AM           4405   查看powershell自定义函数的源代码@形参Parameter@实参Argument.md
  
          Directory: C:\repos\blogs\windows
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a---         2/14/2024  11:53 PM          10472   powershell@posh主题设置和自定义@动态补全配置.md
  -a---          2/9/2024  12:06 PM            756   powershell@配置文件和onedrive的冲突.md
  -a---          2/9/2024  12:07 PM           1983   powershell7安装.md
  -a---         2/13/2024  10:26 PM           7911   powershell命令行提示符样式配置自定义@ohmyposh安装@卸载.md
  -a---         3/28/2023  10:13 AM          10120   windows更改显示语言@powershell帮助文档更新问题.md
  
  ```

- 通过合适的命令将这些文件移动到同一个目录下

  ```bash
  PS BAT [11:08:32 PM] [C:\repos\blogs]
  [🔋 100%] MEM:47.84% [3.76/7.85] GB |ls -R -File -Filter *powershell*|mv -Destination C:\repos\blogs\powershell_pwsh\
  
  ```

- 检查结果

  ```bash
  
  PS BAT [11:09:00 PM] [C:\repos\blogs]
  [🔋 100%] MEM:47.49% [3.73/7.85] GB |ls -R -File -Filter *powershell*
  
          Directory: C:\repos\blogs\powershell_pwsh
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a---         11/5/2022   6:36 PM           2747   powershell_linux.md
  -a---         2/25/2023   2:59 PM          14728   powershell_管道符函数pipelineSupport.md
  -a---          6/6/2022  10:25 AM              0   powershell_进程任务管理.md
  -a---          3/5/2023   4:14 PM          10281   powershell_配置文件与脚本编写(模板字符串插值@运算符与表达式@函数参数@控制流).md
  -a---          3/1/2023   2:05 PM           7102   powershell@CLI命令行创建和修改windows快捷方式@shortcut.md
  -a---         2/14/2024  11:53 PM          10472   powershell@posh主题设置和自定义@动态补全配置.md
  -a---         2/12/2024   3:20 PM           3807   powershell@proxy代理配置.md
  -a---         2/14/2024   7:31 PM           9111   powershell@setx环境变量配置@env_permanently.md
  -a---         2/15/2024   5:58 PM          20320   powershell@windows@linux环境变量查询.md
  -a---         2/14/2024   8:14 PM           1699   powershell@从脚本文件中导入函数.md
  -a---         2/15/2024  12:08 PM          11029   powershell@使用指南与入门命令@starter@beginner.md
  -a---         9/25/2023   8:47 AM          14439   powershell@别名@命令异常排查.md
  -a---         1/11/2024   3:44 PM           5292   powershell@基本cmdlet.md
  -a---        12/30/2022   3:04 PM           3216   powershell@控制流@continue和foreach.md
  -a---         2/15/2024  11:01 PM           2028   powershell@文字转语音.md
  -a---         2/13/2024  12:38 PM          10880   powershell@查找文件或目录文件夹.md
  -a---         2/14/2024   4:54 PM           3138   powershell@根据文件内容查找文件.md
  -a---         2/25/2023   2:47 PM          11099   powershell@格式化字符串@管道符函数编写@powershell类似cat
                                                   -n(查看文件显示行号)@powershell查看文件指定范围的行@输出格式化format-table.md
  -a---         2/12/2024  12:52 PM            682   powershell@获取脚本文件自身所在路径.md
  -a---          3/4/2023   3:36 PM          15788   powershell@输入法管理.md
  -a---         1/10/2024   2:03 PM          15577   powershell@进程与服务管理.md
  -a---          2/9/2024  11:54 AM          13767   powershell@通配符和正则匹配like@match@字符串替换.md
  -a---          2/9/2024  12:06 PM            756   powershell@配置文件和onedrive的冲突.md
  -a---          2/9/2024  12:07 PM           1983   powershell7安装.md
  -a---         5/24/2023   9:36 PM          26243   powershellbash硬链接Hardlink@软连接(符号链接)创建@linux符号链接检查.md
  -a---         2/13/2024  10:26 PM           7911   powershell命令行提示符样式配置自定义@ohmyposh安装@卸载.md
  -a---          3/5/2023   8:07 PM           6519   vscode@powershellExtension配置和启用问题.md
  -a---         3/28/2023  10:13 AM          10120   windows更改显示语言@powershell帮助文档更新问题.md
  -a---         3/31/2023  11:21 AM           4405   查看powershell自定义函数的源代码@形参Parameter@实参Argument.md
  
  PS BAT [11:09:11 PM] [C:\repos\blogs]
  ```

  

### 其他

- 比如相同文件扩展名文件分类移动,例如`txt`,`png`等文件归类移动到不同文件夹,可以用类似d





