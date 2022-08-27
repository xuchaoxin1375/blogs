@[toc]

# powershell_格式化字符串(composite formating)/windows的类似cat -n(查看文件显示行号)/powershell查看文件指定范围的行

* [Use PowerShell to Format Strings with Composite Formatting - Scripting Blog (microsoft.com)](https://devblogs.microsoft.com/scripting/use-powershell-to-format-strings-with-composite-formatting/)
* MSDN:[Composite formatting | Microsoft Docs](https://docs.microsoft.com/en-us/dotnet/standard/base-types/composite-formatting?redirectedfrom=MSDN#code-examples)
* [Understanding PowerShell and Basic String Formatting - Scripting Blog (microsoft.com)](https://devblogs.microsoft.com/scripting/understanding-powershell-and-basic-string-formatting/)
* [command line - Windows equivalent to Linux `cat -n`? - Super User](https://superuser.com/questions/1302130/windows-equivalent-to-linux-cat-n)

## 字符串和操作符

- [about Operators - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.2#format-operator--f)

> Format operator `-f`

* Formats strings by using the format method of string objects.
* Enter the format string on the left side of the operator and the objects to be formatted on the right side of the operator.

  ![1646725819200.png](https://img-blog.csdnimg.cn/img_convert/e198f0956b598829b9c7188e1b181405.png)
  ![1646726052166.png](https://img-blog.csdnimg.cn/img_convert/012d8741b6e93c5c324759739bb30887.png)

## powershell字符串对齐(Using the alignment component)

* To provide for the formatting of output within “cells,” I use the alignment component of the format item.
  * The alignment component is optional, as seen in the three earlier examples that did not include the alignment component.
  * The alignment is `a signed integer`that specifies the preferred `field width`.
* If the value of the alignment is smaller than ` the actual length of the formatted string`, the value of the alignment component ` is ignored`.
* Alignment to the right takes place if the value of the integer is positive. Alignment to the left takes place if the integer is negative. The following examples illustrate various ways of using the alignment component.
* ![1646724530856.png](https://img-blog.csdnimg.cn/img_convert/3c5f3199297c56060e638ebad7edc10b.png)


```## 简单的示例(字符串格式化)

![1646722436409.png](https://img-blog.csdnimg.cn/img_convert/24caa74bfbd50ef30f2da0b8811f233d.png)

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

### catn


## windows的cat -n(查看文件并显示行号)

```powershell
 
# 关键在于格式化'{0,5} {1}' -f
  Get-Content $FileName | ForEach-Object { '{0,-5} {1}' -f $_.ReadCount, $_ }
```
#### 管道符版catn

```powers
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

### 结合catn查看

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
