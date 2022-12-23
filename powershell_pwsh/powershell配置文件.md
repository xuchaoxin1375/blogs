@[toc]

#  powershell配置文件

- [refs](https://docs.microsoft.com/zh-cn/learn/modules/script-with-powershell/2-introduction-scripting)

### 配置文件类型

- PowerShell支持多个配置文件。可以按如下所示在不同级别应用它们：

- | 说明               | 路径                                                         |
  | ------------------ | ------------------------------------------------------------ |
  | 所有用户，所有主机 | `$PSHOME\Profile.ps1`                                        |
  | 所有用户，当前主机 | `$PSHOME\Microsoft.PowerShell_profile.ps1`                   |
  | 当前用户，所有主机 | `$Home[My]Documents\PowerShell\Profile.ps1`                  |
  | 当前用户，当前主机 | `$Home[My]Documents\PowerShell\Microsoft.PowerShell_profile.ps1` |

  - 这里有两个变量：`$PSHOME`和`$Home.SPSHOME`指向PowerShel‖的安装目录。
  - `$Home`为当前用户的主目录。
  - 其他程序也支持配置文件，如Visual Studio Code.

### 创建档案

- 首次安装PowerShell时，没有任何配置文件。
  - 但有一个`$Profile`变量。
  - 它是一个对象，指向应放置每个要应用的配置文件的路径。

#### 创建配置文件：

- 1.确定要创建配置文件的级别。
  - 可运行`$Profi1e|Select-object *`来查看配置文件类型以及与它们关联的路径。
- 2.使用如下所示的命令选择配置文件类型并在其位置创建文本文件：
  - `New-Item-Path $Profile.CurrentUserCurrentHost`
- 3.将自定义项添加到文本文件并保存。
  - 下一次启动会话时，将应用所做的更改

#### 查看所有配置文件目录操作效果

- `$profile|sls *`

```powershell
PS C:\Users\cxxu> $pshome
C:\Program Files\PowerShell\7
PS C:\Users\cxxu> $PROFILE
D:\usersByCxxu\DocumentsAll\PowerShell\Microsoft.PowerShell_profile.ps1

PS C:\Users\cxxu> $PROFILE|select *

AllUsersAllHosts       : C:\Program Files\PowerShell\7\profile.ps1
AllUsersCurrentHost    : C:\Program Files\PowerShell\7\Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : D:\usersByCxxu\DocumentsAll\PowerShell\profile.ps1
CurrentUserCurrentHost : D:\usersByCxxu\DocumentsAll\PowerShell\Microsoft.PowerShell_profile.ps1
Length                 : 71

```


#  获取对象属性
- `<object> | select-object *`
  - 例如
  - `$Profile | Select-Object *`

#  插值
- 在==双引号==中可以插值


## 简单值:
`$<expression>`
### 简单插值示例
```powershell
PS D:\repos\blogs> "$PROFILE"
C:\Users\cxxu\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```




##  较复杂值:
- 通用方式

  - 插值可以嵌套!

  - `$(<complex expression>)`

### 复杂插值eg1.
```powershell
Write-Host "Created backup at $( $DestinationPath + 'backup-' + $date).zip"
```
> 单引号无法插值！
* 示例2：获取当前目录下存在的符号链接
```ps1
function getLinks {
    param (
    )
    $step = (Get-ChildItem | Sort-Object -Property target -Descending | Select-Object name, linktype, target | Where-Object target -ne "")
    Write-Output $step "-------------"

    Write-Output "itemsCount: $($step.count)"

}
```
### 引用对象成员的插值示例
![在这里插入图片描述](https://img-blog.csdnimg.cn/277b8bb625ec4437b112e4c42ddfd8f9.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

#  参数
- 分为脚本参数和函数参数
  - 编写规则大致相同,但是在使用的时候需要注意,函数需要导入(或者说,导入函数所在的模块)
  - 相关文档可以参考模块与脚本部分(而不仅仅时函数编写部分)

## 参数声明(basic)
```powershell
param(
	# your  parameter list
)
```
## 分配类型:
分配类型。 例如，如果为参数分配类型，你可以指定该参数只接受字符串，而不接受布尔值。 这样，用户就知道了期望结果。 可以在参数前面加上类型（用括号括住），为该参数分配类型：


```powershell
Param(
 	# the parameter has been set the default parameters
  [string]$Path = './app',
  [string]$DestinationPath = './'
)
```

## 参数说明(with `parameter[]`)
实验环境不同,效果可能也不同(在vscode中的powershell插件控制下的PowerShell Integrated Console (v2021.10.2) 就无法使用`!?`提示`
以下是powerhsell7.1中的结果
![在这里插入图片描述](https://img-blog.csdnimg.cn/d0276432a7d4412ab68bbc4b33da64a3.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
test code:
```powershell
<# the more effective and popular method is to use the parameter[] #>
Param(
    # to show the helpMessage tips,just type `!?`
    #  Mandatory=$true is optional.
    [Parameter(Mandatory=$true,HelpMessage = "input your valid path(for demonstrate,I will just output to show the path.")]
    # [Parameter(Mandatory, HelpMessage = "Please provide a valid path")] 
    $path
)
# the logic of your script,in the script ,I just use it to out put a sentence 
Write-Output $path

```
###  head.ps1
```powershell
param(
	[int]$lines=5,
	[parameter(mandatory, HelpMessage = "input a valid fileName")]
	$fileName
	
)	
Get-Content $fileName | Select-Object -First $lines 
```

#  控制流
## overview
[流控制 - Learn | Microsoft Docs](https://docs.microsoft.com/zh-cn/learn/modules/script-with-powershell/6-flow-control)
## operators
[所有运算符 - PowerShell | Microsoft Docs](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2)
### overview:
* [简短说明](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2#short-description)
* [长说明](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2#long-description)
* [算术运算符](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2#arithmetic-operators)
* [赋值运算符](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2#assignment-operators)
* [比较运算符](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2#comparison-operators)
* [逻辑运算符](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2#logical-operators)
* [重定向运算符](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2#redirection-operators)
* [拆分运算符和联接运算符](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2#split-and-join-operators)
* [类型运算符](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2#type-operators)
* [一元运算符](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2#unary-operators)
* [特殊运算符](https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2#special-operators)

##  表达式
这是重要的一块内容,在编写`where`语句高级条件的时候,比较有用

* [7.1 Primary expressions](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-07?view=powershell-7.2#71-primary-expressions)
* [7.2 Unary operators](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-07?view=powershell-7.2#72-unary-operators)
* [7.3 Binary comma operator](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-07?view=powershell-7.2#73-binary-comma-operator)
* [7.4 Range operator](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-07?view=powershell-7.2#74-range-operator)
* [7.5 Format operator](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-07?view=powershell-7.2#75-format-operator)
* [7.6 Multiplicative operators](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-07?view=powershell-7.2#76-multiplicative-operators)
* [7.7 Additive operators](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-07?view=powershell-7.2#77-additive-operators)
* [7.8 Comparison operators](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-07?view=powershell-7.2#78-comparison-operators)
* [7.9 Bitwise operators](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-07?view=powershell-7.2#79-bitwise-operators)
* [7.10 Logical operators](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-07?view=powershell-7.2#710-logical-operators)
* [7.11 Assignment operators](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-07?view=powershell-7.2#711-assignment-operators)
* [7.12 Redirection operators](https://docs.microsoft.com/en-us/powershell/scripting/lang-spec/chapter-07?view=powershell-7.2#712-redirection-operators)