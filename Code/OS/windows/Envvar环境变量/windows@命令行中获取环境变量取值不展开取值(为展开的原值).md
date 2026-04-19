[toc]

## 命令行中获取环境变量取值

* 这里主要讨论获取未展开的值
* 本来获取未展开的值应该作为默认选项,至少有合适的api方便直接调用,但是不知道微软怎么想的,让这个任务变得不直接

### 获取不展开的值

* 为了便于讨论和实验,下面假设环境变量都讨论的是当前用户级别的环境变量
* 意思是假设你的环境变量中有一个 `exes`变量,并假设对应的取值为 `C:\exes`
* 现在某个变量比如 `Path`,或者其他任何引用了 `exes`的环境变量(例如 创建环境变量 `testx`,可以通过语句 `setx testx %exes%`)
* 在使用命令行查询 `testx`时查询到的值不是 `%exes%`,而是其展开值 `C:\exes`,这会造成许多间接引用的路径发生更改后无法自动更新,造成灵活性下降,特别是通过命令行修改(尤其是添加)多取值环境变量的部分值的时候
  * 比如 `%exes%`被改为 `C:/new/exes`,但是由于添加新值前需要获取旧值,旧值中的 `%exes%`如果被替换为 `C:\exes`,那么在为 `testx`添加新值时丢失 `%exes%`,取而代之的是 `C:\exes`	,然而这个值不是我们想要的,因为它是死板的,不会随着 `%exes%`的更新而自动更新
* 此外,这里的不展开环境变量主要值的是记录着路径的环境变量)
* 总之,我们需要解决的问题是命令行获取不展开的值
* 目前的方法是通过访问注册表来获取不展开的值
* 相关注册表

  * ```cmd
    'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' #系统级
    'HKCU:\Environment' #当前用户级
    ```
* 相关命令

  * `reg query`
  * `Get-item`

### 具体实现

推荐powershell的`Get-item`,即(`gi`)命令来获取

```powershell
#以'HKCU:\Environment'为例
# 准备用语测试的一对值
setx exes 'C:\exes1'
setx testx %exes1%


#为了获取非展开的原值,可以直接用Get-Item访问'HKCU:\Environment',也可以分为两部分访问路径
#考虑到全局/用户级别环境变量路径都是以environment结尾,这样可以更灵活和选择判断全局还是用户级别
$Name='testx'
#$registerKeyParent=Get-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'
$registerKeyParent=Get-Item -Path 'HKCU:'#获取目标路径的父路径
$RegisterKey = $registerKeyParent.OpenSubKey('Environment')  #打开指定子键


$registryValueOption = [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames

$RegisterKey.GetValue($Name, $null, $registryValueOption)
```

相关api如下

[RegistryKey.GetValue 方法 (Microsoft.Win32) | Microsoft Learn](https://learn.microsoft.com/zh-cn/dotnet/api/microsoft.win32.registrykey.getvalue?view=net-8.0)

```powershell
PS> $envRegisterKey.GetValue

OverloadDefinitions
-------------------
System.Object GetValue(string name)
System.Object GetValue(string name, System.Object defaultValue)
System.Object GetValue(string name, System.Object defaultValue,
Microsoft.Win32.RegistryValueOptions options)
```

### 注解

使用此重载指定检索到的值的特殊处理。 例如，可以在检索类型的[RegistryValueKind.ExpandString](https://learn.microsoft.com/zh-cn/dotnet/api/microsoft.win32.registryvaluekind?view=net-8.0#microsoft-win32-registryvaluekind-expandstring)注册表值时指定[RegistryValueOptions.DoNotExpandEnvironmentNames](https://learn.microsoft.com/zh-cn/dotnet/api/microsoft.win32.registryvalueoptions?view=net-8.0#microsoft-win32-registryvalueoptions-donotexpandenvironmentnames)检索字符串，而无需展开嵌入的环境变量。

`defaultValue`使用 参数指定要返回的值（如果`name`不存在）。

## 封装为函数

- 下面两个版本实现方式不同,注意参数不同,根据需要调整

### 版本1

来源于scoop中的函数`Get-EnvVar`

```powershell
function Get-EnvVarRawValue
{
    <#
    .SYNOPSIS
    Retrieve an environment variable value.

    .DESCRIPTION
    This function retrieves the value of the specified environment variable 
    from the registry. It can fetch both user-specific and system-wide variables.

    .PARAMETER Name
    The name of the environment variable.

    .PARAMETER Global
    Switch to indicate if the environment variable is global (system-wide).

    .EXAMPLE
    Get-EnvVar -Name "Path"
    #>
    param(
        [string]$Name,
        [switch]$Global
    )

    # Determine the appropriate registry key to use based on the Global flag
    # User scope uses the HKCU hive, while global (system-wide) uses the HKLM hive
    $registerKey = if ($Global)
    {
        # HKLM hive is used for system-wide environment variables
        # This is the same key used by the system Configuration Manager
        # when setting environment variables through the System Properties
        # control panel
        Get-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'
    }
    else
    {
        # HKCU hive is used for user-specific environment variables
        Get-Item -Path 'HKCU:'
    }

    # Open the Environment sub-key off the selected registry key
    $envRegisterKey = $registerKey.OpenSubKey('Environment')

    # Retrieve the value of the specified environment variable
    # The DoNotExpandEnvironmentNames option is used to prevent the registry
    # from expanding any environment variables it finds in the value
    # This is necessary because environment variables can be nested (e.g. %PATH%)
    # and we want to return the raw, unexpanded value
    $registryValueOption = [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames
    $envRegisterKey.GetValue($Name, $null, $registryValueOption)
}
```

### 版本2

```powershell

function Get-EnvVarRawValue
{
    <# 
    .SYNOPSIS
    从相应的注册表中读取指定环境变量的取值
    .DESCRIPTION

    # 不会自动转换或丢失%var%形式的Path变量提取
        # 采用reg query命令查询而不使用Get-ItemProperty 查询注册表, 因为Get-ItemProperty 会自动转换或丢失%var%形式的变量
        # 注册表这里也可以区分清楚用户级别和系统级别的环境变量
    #>
    [CmdletBinding()]
    param (
        [Alias('Name', 'Key')]$EnvVar = 'new', 
        [ValidateSet('Machine', 'User', 'Process')]
        $Scope = 'User'
    )
    $currentValue = [System.Environment]::getenvironmentvariable($EnvVar, $Scope)
    if ($CurrentValue)
    {
        if ($scope -eq 'User' -or $scope -eq 'Process')
        {

            $CurrentValueUser = reg query 'HKEY_CURRENT_USER\Environment' /v $EnvVar
            $currentValue = $CurrentValueUser
        }
        if ($scope -eq 'Machine' -or $scope -eq 'Process')
        {
            $currentValueMachine = reg query 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' /v $EnvVar
            $currentValue = $currentValueMachine

        }
        if ($Scope -eq 'process')
        {

            #recurse
            $U = Get-EnvVarRawValue -EnvVar $EnvVar -Scope 'User'
            $M = Get-EnvVarRawValue -EnvVar $EnvVar -Scope 'Machine'
            $currentValue = (@($U , $M) -join ';') -split ';' | Select-Object -Unique | Remove-RedundantSemicolon
            return $currentValue
            # $CurrentValue = $CurrentValueUser + $currentValueMachine
        }
        $CurrentValue = @($CurrentValue) -join '' #确保$CurrentValue是一个字符串
        # $CurrentValue -match 'Path\s+REG_EXPAND_SZ\s+(.+)'
        # $mts = [regex]::Matches($CurrentValue, $pattern)
        # return $mts
        if (

            $CurrentValue -match 'REG.*SZ\s+(.+)'

        )
        {

            $CurrentValue = $Matches[1] | Remove-RedundantSemicolon
            # 规范化
        }
    }
    if ($VerbosePreference)
    {
        Write-Verbose "RawValue of [$EnvVar]:"
        Write-Host ($currentValue -split ';' | Format-DoubleColumn | Out-String)
    }
    # 返回的是一个字符串,而不是;分隔的字符串数组
    return $currentValue 
}
```

