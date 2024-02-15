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











