[toc]

## abstract

windows上命令行@文件内容查看方案@行号显示@nlps@cat -n

本文给出的powershell函数`(Get-ContentNL)`支持管道符输入,文件名(数组)或者字符串本身都可以传入进行计数和内容显示

可以配合`ls`等命令传递需要查看的文件给`Get-ContentNL`,可以灵活使用

## refs



* [Use PowerShell to Format Strings with Composite Formatting - Scripting Blog (microsoft.com)](https://devblogs.microsoft.com/scripting/use-powershell-to-format-strings-with-composite-formatting/)
* MSDN:[Composite formatting | Microsoft Docs](https://docs.microsoft.com/en-us/dotnet/standard/base-types/composite-formatting?redirectedfrom=MSDN#code-examples)
* [Understanding PowerShell and Basic String Formatting - Scripting Blog (microsoft.com)](https://devblogs.microsoft.com/scripting/understanding-powershell-and-basic-string-formatting/)
* [command line - Windows equivalent to Linux `cat -n`? - Super User](https://superuser.com/questions/1302130/windows-equivalent-to-linux-cat-n)
* [Creating Pipeline-Aware Functions - powershell.one](https://powershell.one/powershell-internals/scriptblocks/support-pipeline#wrap-up)





## windows的cat -n(查看文件并显示行号)

### powershell:使用循环实现

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







###  powershell:编写成函数命令调用👺

```powershell

function Get-ContentNL
{
    <# 
.SYNOPSIS
该函数用于计数地输出文本内容:在每行的开头显示该行是文本中的第几行(行号),以及该行的内容
支持管道符输入被统计对象
#>
    <# 
.EXAMPLE
#常规用法,通过参数指定文本文件路径来计数地输出文本内容
Get-ContentNL -InputData .\r.txt
.EXAMPLE
rvpa .\r.txt |Get-ContentNL
.EXAMPLE
将一个三行的文本字符串作为管道输入，然后将其,显式指出将管道符内容视为字符串而不是路径字符串进行统计
#创建测试多行字符串变量
$mlstr=@'
line1
line2
line3
'@

$mlstr|Get-ContentNL -AsString

.EXAMPLE
计数一个多行字符串变量的行数
PS C:\repos\scripts\PS\Test> $mlstr=@'
>> line1
>> line2
>> line3
>> '@
PS C:\repos\scripts\PS\Test> $mlstr
line1
line2
line3
PS C:\repos\scripts\PS\Test> Get-ContentNL -InputData $mlstr -AsString
1:line1
2:line2
3:line3
.EXAMPLE
#跟踪文本文件内容的变化(每秒刷新一次内容);
Get-ContentNL -InputData .\log.txt -RepetitionInterval 1
.EXAMPLE
#在powershell新窗口中更新
Start-Process powershell -ArgumentList '-NoExit -Command Get-ContentNL -InputData .\log.txt -RepetitionInterval 1'
.EXAMPLE
ls传递给cat读取合并,然后在传给Get-ContentNL来计数处理

PS> ls ab*.cpp|cat|Get-ContentNL -AsString -Verbose
VERBOSE: Checking contents...
1:#include <iostream>
2:using namespace std;
3:int main()
4:{
5:
6:    int a, b, c;
7:    cin >> a >> b;
8:    c = a + b;
9:    cout << c << endl;
10:    return 0;
11:}
12:#include <iostream>
13:using namespace std;
14:int main()
15:{
16:
17:
18:    int a, b, c;
19:    cin >> a >> b >> c;
20:    cout << (a + b) * c << endl;
21:    return 0;
22:}
VERBOSE: 2024/9/14 22:03:43
 
.EXAMPLE
#从ls命令通过管道符传递多个文件进行读取
PS🌙[BAT:79%][MEM:48.16% (15.27/31.71)GB][22:03:52]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\scripts\Cpp\stars_printer]
PS> ls ab*.cpp|Get-ContentNL
# Start File(1) [C:\repos\scripts\Cpp\stars_printer\ab.cpp]:

1:#include <iostream>
2:using namespace std;
3:int main()
4:{
5:
6:    int a, b, c;
7:    cin >> a >> b;
8:    c = a + b;
9:    cout << c << endl;
10:    return 0;
11:}

# End File(1) [C:\repos\scripts\Cpp\stars_printer\ab.cpp]:

# Start File(2) [C:\repos\scripts\Cpp\stars_printer\abc.cpp]:

1:#include <iostream>
2:using namespace std;
3:int main()
4:{
5:
6:
7:    int a, b, c;
8:    cin >> a >> b >> c;
9:    cout << (a + b) * c << endl;
10:    return 0;
11:}

# End File(2) [C:\repos\scripts\Cpp\stars_printer\abc.cpp]:

.EXAMPLE
通过get-item命令(别名gi)获取字符串对应的文件
PS🌙[BAT:79%][MEM:48.52% (15.39/31.71)GB][22:04:07]
# [cxxu@CXXUCOLORFUL][<W:192.168.1.178>][C:\repos\scripts\Cpp\stars_printer]
PS> gi .\ab.cpp|Get-ContentNL
# Start File(1) [C:\repos\scripts\Cpp\stars_printer\ab.cpp]:

1:#include <iostream>
2:using namespace std;
3:int main()
4:{
5:
6:    int a, b, c;
7:    cin >> a >> b;
8:    c = a + b;
9:    cout << c << endl;
10:    return 0;
11:}

# End File(1) [C:\repos\scripts\Cpp\stars_printer\ab.cpp]:

.Notes
可以设置别名,比如pscatn,psnl
#>
    [CmdletBinding()]
    param(
        # 可以是一个表示文件路径的字符串，也可以是一个需要被统计行数并显示内容的字符串;后者需要追加 -AsString 选项
        [Parameter(
            Mandatory = $false, #这里如果使用这个参数的话，必须要指定非空值,为了增强兼容性,不适用改参数,或者指定为$false
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        # [string]
        [Alias('InputObject')]$InputData,
        
        # [Parameter(ParameterSetName = 'FilePath')]
        # [switch]$AsFilePath,

        # [Parameter(ParameterSetName = 'String')]
        [switch]$AsString,
        # 定时刷新查看文件内容的间隔时间（秒）,0表示一次性查看
        $RepetitionInterval = 0,
        [switch]$Clear,
        $LineSeparator = '#'
        # [switch]$NewShell #todo

    )

    begin
    {
        Write-Verbose 'Checking contents...'
        $itemNumber = 1
        $lineNumber = 0 #为了支持列表输入,对多个文件分别计数,此变量放到process块中
    }

    process
    {
        
        
        if ($AsString)
        # if ($PSCmdlet.ParameterSetName -eq 'String')
        {
            # 如果是字符串，则认为是直接传入的文件内容
            $InputData -split "`n" | ForEach-Object {
                $lineNumber++
                "${lineNumber}:$_"
            }
        }
        else
        {
            # 否则，认为是文件路径,但是还是要检查文件是否存在或者合法
            if(!(Test-Path $InputData -PathType Leaf)){
                Write-Error "File does not exist:$($InputData.Trim()) Do you want to consider the Input as a string?(use -AsString option ) "
                return
            }
            $lineNumber = 0

            Write-Host "$LineSeparator Start File($itemNumber) [$_]" -BackgroundColor Yellow -NoNewline
            Write-Host "`n"
            
            try
            {
                if (Test-Path $InputData -PathType Leaf)
                {
                    Get-Content $InputData | ForEach-Object {
                        $lineNumber++
                        "${lineNumber}:$_"
                    }
                }
                else
                {
                    Write-Error "File does not exist: $InputData"
                }
            }
            catch
            {
                Write-Error "An error occurred: $_"
            }

            Write-Host ''
            Write-Host "$LineSeparator End File($itemNumber) [$_]:"-BackgroundColor Blue -NoNewline
            Write-Host "`n"
            $itemNumber++

        }
        # 定时刷新查看指定文件内容
        if ($RepetitionInterval)
        {
            
            while (1)
            {
                # 清空屏幕(上一轮的内容会被覆盖)
                if ($Clear) { Clear-Host }

                # 这里使用递归调用(并且将此处调用的RepetitionInterval指定为不刷新(0),否则嵌套停不下来了)
                Get-ContentNL -InputData $InputData -RepetitionInterval 0
                # 也可以简单使用 
                # Get-Content $InputData
                Start-Sleep $RepetitionInterval
            }

        }
     

    }
    end
    {
        Write-Verbose (Get-DateTime)
    }
}

```

取别名,例如取为`nlps`,或者干脆把函数名设置为`nlps`或`catn`等缩写形式

```powershell
Set-Alias -Name nlps -Value Get-ContentNL
```



### 用例

* 此版本支持管道符的用法(更多用例详见函数定义内部的注释文档)

```powershell
PS>  ipconfig|select -Index (20..25)|nlps -AsString
1:   IPv4 地址 . . . . . . . . . . . . : 192.168.1.77
2:   子网掩码  . . . . . . . . . . . . : 255.255.255.0
3:   默认网关. . . . . . . . . . . . . : fe80::1%18
4:                                       192.168.1.1
5:
6:以太网适配器 蓝牙网络连接:
```



## FAQ

### 文件编码问题@(中文乱码)

- 通常,如果你的文本文件使用文字软件可以正确识读,但是使用`cat`(即`get-content`)却出现了乱码

- 这在某些国人编写的脚本文件中经常出现,比如批处理文件`.bat`里面的中文字符可能是`GBK`或`GB2312`编码

- powrshell的`cat`命令,默认用的流行编码`utf8`

- 这可能导致文本无法正常识读,您可以考虑修改`cat`的默认解读编码,通过`-encoding`选项指定为`GB2312`或者`GBK`再试一次

## 使用第三方工具👺

- [sharkdp/bat: A cat(1) clone with wings. (github.com)](https://github.com/sharkdp/bat)
  - 这是一个跨平台工具
