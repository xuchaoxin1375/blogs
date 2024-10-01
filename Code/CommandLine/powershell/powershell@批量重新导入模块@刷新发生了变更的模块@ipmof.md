[toc]



## abstract

- 由于同一个会话下,powershell无法自动更新已经导入但发生变化的模块,这时候用户有两个选择:
  - 重新执行pwsh,或者使用ipmo(Import-Module) 配合-Force参数强制重载相应的模块
    - 前者重载得彻底,但是会无法继承父级会话中的环境,比如定义的变量在新开的pwsh中无法访问,而且开销比较大,速度慢
    - 后者一种方法更加轻量,由于不会创建新的pwsh进程,不会造成环境变量丢失,但是一个个检查模块然后重新加载对于开发者来说不方便
- 为此编写了以下函数,可以直接重载已经加载了的模块,方便了这一个刷新变更了的模块的过程
- NOTES
  - 一个有意思的现象是,如果自动导入模块的路径$PsModulePath下的模块如果在当前powershell会话中没有加载,例如某个函数x在模块test中
  - 而当前shell环境没有调用x,也没有调用模块test中的任意函数,或定义的东西,此时对此摸块做了更改后,不需要刷新,在当前会话shell中调用test的变更的内容是自动更新的,也就是说会自动刷新
- 总结:可以重载已经加载了的模块,对于开发测试powershell模块很有用

```powershell

function Import-ModuleForce
{
    <# 
    .SYNOPSIS
    默认重载已经加载了的模块,而不是重载所有模块来加快操作速度
    #>
    [CmdletBinding()]
    param (
        # [switch]$PassThru
    )

    # 获取当前 已经加载了的模块
    $modules = Get-Module | Select-Object -ExpandProperty Name

    $res = @()
    foreach ($module in $modules)
    {
        # 跳过某些模块的重载(如果这个模块比较特殊的话,比如包含注册补全的模块，这个模块就要谨慎重载,默认跳过,可以根据自己的情况调整)
        # Remove-Module $module -ErrorAction SilentlyContinue -Force
        # if ($module -like '*completion*')
        # { 
        #     Write-Warning "Skipping $module"
        #     continue 
        # }

        # Import-Module $module -Force -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        $exp = "Import-Module $module -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue"
        $res += $exp
        Write-Verbose "Imported $module "
    }
    # if ($PassThru)
    # {

    #     return $res -join "`n"
    # }
    return $res -join "`n"
}
function ipmof
{
    <# 
    .SYNOPSIS
    作为Import-ModuleForce的别名
    由于同一个会话下,powershell无法自动更新已经导入但发生变化的模块,这时候用户有两个选择:
    重新执行pwsh,或者使用ipmo(Import-Module) 配合-Force参数强制重载相应的模块
    前者重载得彻底,但是会无法继承父级会话中的环境,比如定义的变量在新开的pwsh中无法访问,而且开销比较大,速度慢
    后者一种方法更加轻量,由于不会创建新的pwsh进程,不会造成环境变量丢失,但是一个个检查模块然后重新加载对于开发者来说不方便
    为此编写了此函数,可以直接重载已经加载了的模块,方便了这一个刷新变更了的模块的过程
    .NOTES
    一个有意思的现象是,如果自动导入模块的路径$PsModulePath下的模块如果在当前powershell会话中没有加载,例如某个函数x在模块test中
    而当前shell环境没有调用x,也没有调用模块test中的任意函数,或定义的东西,此时对此摸块做了更改后,不需要刷新,在当前会话shell中调用test的变更的内容是自动更新的,也就是说会自动刷新
    可以重载已经加载了的模块,对于开发测试powershell模块很有用
    .Notes
    本函数调用要配合iex,效果比较稳定,如果你的模块比价简单,那么可以更改import-ModuleForce内部让其直接执行强制导入
    .EXAMPLE
    重载已经加载了的模块:
    ipmof|iex
    .ExAMPLE
    Import-ModuleForce -verbose|iex

    #>
    param (
    )
    # Import-Module PSReadLine -Force
    Import-ModuleForce
    
}

```

