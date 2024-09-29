[toc]



[about_Functions_CmdletBindingAttribute - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-7.4#supportspaging)

[PagingParameters Class (System.Management.Automation) | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/api/system.management.automation.pagingparameters?view=powershellsdk-7.3.0&viewFallbackFrom=powershellsdk-7.0.0)

```powershell

function Get-Numbers
{
    <# 
    .SYNOPSIS
    演示SupportsPaging特性的方法,打印0~100的整数,并且支持跳过前若干个(跳过的最大数量不超过100)
    .DESCRIPTION
    对于更进一步的处理,可以使用|select -First/Last等通用方式处理
    .LINK
    
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-7.4#supportspaging
    .LINK
    https://learn.microsoft.com/zh-cn/dotnet/api/system.management.automation.pagingparameters?view=powershellsdk-7.3.0#properties
    #>
    [CmdletBinding(SupportsPaging)]
    param()

    # 确定要显示数据范围:第一个数据和和最后一个数据
    #其中FirstNumber应该是考虑到用户是否使用Skip参数,如果没有指定-skip参数,那么$PSCmdlet.PagingParameters.Skip默认取值为0
    # 和默认值100进行比较,也就是说如果用户使用Skip参数
    # 下面使用min()函数是为了防止用户指定的Skip参数值大于100,造成溢出边界的安全措施
    $FirstNumber = [Math]::Min($PSCmdlet.PagingParameters.Skip, 100)
    # 类似的,$PSCmdlet.PagingParameters.First 表示用户通过-First参数传入的数值,并且对于没有指定-First参数的情况做了默认处理,也就是取MaxValue(尽可能多的输出),本例子为了防止溢出,使用min()函数,当用户指定-First的数值超过100,就取100
    $LastNumber = [Math]::Min($PSCmdlet.PagingParameters.First +
        $FirstNumber - 1, 100)

    if ($PSCmdlet.PagingParameters.IncludeTotalCount)
    {
        $TotalCountAccuracy = 1.0
        $TotalCount = $PSCmdlet.PagingParameters.NewTotalCount(100,
            $TotalCountAccuracy)
        Write-Output $TotalCount
    }
    $FirstNumber .. $LastNumber | Write-Output
}
```

