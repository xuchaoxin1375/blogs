[toc]

# powershell@格式化字符串@文件内容查看



## refs



* [Use PowerShell to Format Strings with Composite Formatting - Scripting Blog (microsoft.com)](https://devblogs.microsoft.com/scripting/use-powershell-to-format-strings-with-composite-formatting/)
* MSDN:[Composite formatting | Microsoft Docs](https://docs.microsoft.com/en-us/dotnet/standard/base-types/composite-formatting?redirectedfrom=MSDN#code-examples)
* [Understanding PowerShell and Basic String Formatting - Scripting Blog (microsoft.com)](https://devblogs.microsoft.com/scripting/understanding-powershell-and-basic-string-formatting/)
* [command line - Windows equivalent to Linux `cat -n`? - Super User](https://superuser.com/questions/1302130/windows-equivalent-to-linux-cat-n)
* [Creating Pipeline-Aware Functions - powershell.one](https://powershell.one/powershell-internals/scriptblocks/support-pipeline#wrap-up)

## 字符串和操作符🎈

- [about Operators - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2#format-operator--f)

> Format operator `-f`

* Formats strings by using the format method of string objects.
* Enter the format string on the left side of the operator and the objects to be formatted on the right side of the operator.

* ```bash
  PS C:\Users\cxxu\Desktop> "text" -f
  and           cle           csplit        ilike         isnot         notlike
  as            clike         eq            ilt           isplit        notmatch
  band          clt           f             imatch        join          or
  bnot          cmatch        ge            in            le            replace
  bor           cne           gt            ine           like          shl
  bxor          cnotcontains  icontains     inotcontains  lt            shr
  ccontains     cnotin        ieq           inotin        match         split
  ceq           cnotlike      ige           inotlike      ne            xor
  cge           cnotmatch     igt           inotmatch     not
  cgt           contains      iin           ireplace      notcontains
  cin           creplace      ile           is            notin
  
  Logical and. Returns TRUE when both statements are TRUE.
  ```

## powershell字符串对齐(Using the alignment component)

* To provide for the formatting of output within “cells,” I use the alignment component of the format item.
  * The alignment component is optional, as seen in the three earlier examples that did not include the alignment component.
  * The alignment is `a signed integer`that specifies the preferred `field width`.
* If the value of the alignment is smaller than ` the actual length of the formatted string`, the value of the alignment component ` is ignored`.
* Alignment to the right takes place if the value of the integer is positive. Alignment to the left takes place if the integer is negative. The following examples illustrate various ways of using the alignment component.
* ```powershell
  PS D:\repos\blogs> $attendee="Ed Wilson";
  PS D:\repos\blogs> "{0} attended `r`n{1,18:d}" -f $attendee,(Get-Date)
  Ed Wilson attended
           2023/2/22
  ```

  

- ```powershell
  PS D:\repos\blogs> "{0:yyyy}" -f (Get-Date)
  2023
  ```

  


```bash

## 查看指定范围的行(内容)

> 譬如,结合`sls`和`select`来查找网关;

```powershell
PS D:\repos\configs> ipconfig|sls gateway
InputStream:23:   Default Gateway . . . . . . . . . : fe80::38c8:62ff:fe6c:e5c3%15
InputStream:32:   Default Gateway . . . . . . . . . :

PS D:\repos\configs> ipconfig|select -Index (20..25)
   IPv4 Address. . . . . . . . . . . : 192.168.43.165
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : fe80::38c8:62ff:fe6c:e5c3%15
                                       192.168.43.1

Ethernet adapter vEthernet (Default Switch):

```

## powershell cat (get-content)文档

- powershell中输入`help cat -online`查看在线文档(调用浏览器打开文档)
- `help cat`本地文档

## windows的cat -n(查看文件并显示行号)

- 方案1:

  - ```powershell
    	 
    # 关键在于格式化'{0,5} {1}' -f
      Get-Content $FileName | ForEach-Object { '{0,-5} {1}' -f $_.ReadCount, $_ }
    ```

- 或者:

  - ```powershell
     $file="file.ext"; $counter = 0; get-content $file  | % { $counter++; echo "`t$counter` $_" }
    ```

- 其中`%`是`foreach-object`的别名

  - ```powershell
    PS D:\repos\blogs> gal %|fl
    
    DisplayName       : % -> ForEach-Object
    CommandType       : Alias
    Definition        : ForEach-Object
    ReferencedCommand : ForEach-Object
    ResolvedCommand   : ForEach-Object
    ```

### 文件编码问题@(中文乱码)

- 通常,如果你的文本文件使用文字软件可以正确识读,但是使用`cat`(即`get-content`)却出现了乱码

- 这在某些国人编写的脚本文件中经常出现,比如批处理文件`.bat`里面的中文字符可能是`GBK`或`GB2312`编码

- powrshell的`cat`命令,默认用的流行编码`utf8`

- 这可能导致文本无法正常识读,您可以考虑修改`cat`的默认解读编码,通过`-encoding`选项指定为`GB2312`或者`GBK`再试一次

  

### 管道符版catn

```powershell

function catn
{
    <# 
    .Synopsis
    Mimic Unic / Linux tool nl number lines
   
    .Description
    Print file content with numbered lines no original nl options supported
   
    .Example
     nl .\food.txt
    #>
    param (
        $Path = '',
        [Parameter(ValueFromPipeline)]
        [String]
        $content
        # $FileName
 
    )
    begin
    {
        $i = 0;
    }    process
    {

        if ($path -eq '')
        {
            $content | ForEach-Object {
                $i++;
                '{0,-5} {1} ' -f $i, $_ ;
        
            }
        }
        else
        {
            # $content = (Get-Content $Path)
            Get-Content $Path | ForEach-Object {
                $i++;
                '{0,-5} {1} ' -f $i, $_ ;
        
            }
        }
    }
}
```

### 例

* 此版本支持管道符的用法

```powershell
PS C:\Users\cxxu> ipconfig|select -Index (20..25)|catn
1        IPv4 Address. . . . . . . . . . . : 192.168.43.165
2        Subnet Mask . . . . . . . . . . . : 255.255.255.0
3        Default Gateway . . . . . . . . . : fe80::38c8:62ff:fe6c:e5c3%15
4                                            192.168.43.1
5
6     Ethernet adapter vEthernet (Default Switch):
```

### 查看特定行

- 创建测试文件

  - ```powershell
    1..100|%{"line "+$_>>linesFile}
    ```

  - ```powershell
    #查看第10行
    (cat -Path .\linesFile -TotalCount -1)[10]
    ```

  - ```powershell
    #查看最后一行
    (cat -Path .\linesFile -TotalCount -1)[-1]
    ```

### 查看指定行区间内容

- ```powershell
  #查2值4行(从0计数)
  PS D:\repos\blogs> (cat -Path .\linesFile -TotalCount -1)[1..3]
  line 2
  line 3
  line 4
  ```

  

## 输出格式控制🎈

### refs

- [powershell - How do I use Format-Table without truncation of values? - Stack Overflow](https://stackoverflow.com/questions/49122925/how-do-i-use-format-table-without-truncation-of-values)
- [Format-Table (Microsoft.PowerShell.Utility) - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/format-table?view=powershell-7.3)

### select@ft@fl获取对象的完整属性

- 常用的输出格式控制
- `select`
  - `select *`可以获取对象的所有字段

- `format-table	`(`ft`) 
- `format-list`(`fl`) 

#### 例

#### 进程对象的所有字段以及取值

- ```bash
  PS D:\repos\scripts>  ps|select *   -First 1
  
  Name                       : AggregatorHost
  Id                         : 7548
  PriorityClass              :
  FileVersion                :
  HandleCount                : 152
  WorkingSet                 : 8859648
  PagedMemorySize            : 2752512
  PrivateMemorySize          : 2752512
  VirtualMemorySize          : 70791168
  TotalProcessorTime         :
  SI                         : 0
  ....节约篇幅
  
  UserProcessorTime          :
  ProcessName                : AggregatorHost
  MainWindowHandle           : 0
  MainWindowTitle            :
  Responding                 : True
  Site                       :
  Container                  :
  ```

  

#### 将内容输出为csv文件🎈

- 这种方法是推荐的,有利于后期的处理

- 可以借助于excel查看数据

- ```bash
  PS D:\repos\scripts> ps|select * -First 3|Export-Csv testTable.csv
  PS D:\repos\scripts> cat .\testTable.csv
  "Name","Id","PriorityClass","FileVersion","HandleCount","WorkingSet","PagedMemorySize","PrivateMemorySize","VirtualMemorySize","TotalProcessorTime","SI","Handles","VM","WS","PM","NPM","Path","CommandLine","Parent","Company","CPU","ProductVersion","Description","Product","__NounName","SafeHandle","Handle","BasePriority","ExitCode","HasExited","StartTime","ExitTime","MachineName","MaxWorkingSet","MinWorkingSet","Modules","NonpagedSystemMemorySize64","NonpagedSystemMemorySize","PagedMemorySize64","PagedSystemMemorySize64","PagedSystemMemorySize","PeakPagedMemorySize64","PeakPagedMemorySize","PeakWorkingSet64","PeakWorkingSet","PeakVirtualMemorySize64","PeakVirtualMemorySize","PriorityBoostEnabled","PrivateMemorySize64","ProcessorAffinity","SessionId","StartInfo","Threads","VirtualMemorySize64","EnableRaisingEvents","StandardInput","StandardOutput","StandardError","WorkingSet64","Synchronizi
  省略篇幅....
  "ChsIME","1460",,,"144","7938048","1576960","1576960","99606528","00:00:00","4","144","2203417829376","7938048","1576960","8816",,,,,"0",,,,"Process",,,"8",,"False","12/30/2022 9:45:48 AM",,".",,,,"8816","8816","1576960","129576","129576","1757184","1757184","8839168","8839168","2203420975104","102752256",,"1576960",,"4",,"System.Diagnostics.ProcessThreadCollection","2203417829376","False",,,,"7938048",,,"00:00:00","00:00:00","ChsIME","0","","True",,
  ```

#### format-list

- 效果和`select *`类似,但是提供了groupby的操作

- ```bash
  PS D:\repos\scripts> ps|select * -First 1|fl
  
  Name                       : AggregatorHost
  Id                         : 7548
  PriorityClass              :
  FileVersion                :
  HandleCount                : 152
  WorkingSet                 : 8847360
  PagedMemorySize            : 2723840
  PrivateMemorySize          : 2723840
  VirtualMemorySize          : 70266880
  TotalProcessorTime         :
  SI                         : 0
  Handles                    : 152
  VM                         : 2203388489728
  WS                         : 8847360
  PM                         : 2723840
  NPM                        : 9440
  节约篇幅............
  ```

  

