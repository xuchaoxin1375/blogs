[toc]



## abstract

- 在国内,为了提高访问github的成功率,以及下载相关资源的成功率或速度,可以考虑使用代理镜像
- 本文提供了一个可以批量检测许多开发者分享的加速站点是否能够响应请求(不保证百分百可靠),或者站点的响应是否达到预期
- 这些加速镜像的实现大多来自于开源项目:[hunshcn/gh-proxy: github release、archive以及项目文件的加速项目](https://github.com/hunshcn/gh-proxy),而具体的加速站点由更多人贡献

- 感谢这些为爱发电的贡献者,注意合理使用相关资源

## powershell 脚本内容

- 推荐使用powershell 7来运行,windows powershell 5无法兼容并行特性,并且对于代码排版的兼容性也不好

```powershell

[CmdletBinding()]
param(
    $Mirrors = $GithubMirrors,
    $ThrottleLimits = 16,
    $TimeOutSec = 3,
    [switch]$ListView,
    [switch]$PassThru,
    [switch]$SkipCheckAvailability,
    # 是否启用线性试探镜像可访问性(默认是并行试探)
    [switch]$Linearly,
    # First是为串行测试准备的,对于并行测试，是多余的参数
    [parameter(ParameterSetName = 'First')]
    $First = 5,
    [parameter(ParameterSetName = 'All')]
    [Alias('Full')]
    [switch]
    $All
)

$GithubMirrors = @(
    # 注意,如果你的浏览器使用了代理,那么部分镜像站会和代理冲突,所以可能命令行中测试可以访问的链接在浏览器中确打不开镜像站,可以关闭代理或换个浏览器后重新验证该镜像站的可用性
    #搜集到的链接可以用gpt进行修改,将链接包裹引号(指令:为这些链接分别添加引号);或者自己粘贴到文件文件中然后编写脚本转换为数组格式
    'https://github.moeyy.xyz', # Moeyy - 提供 GitHub 文件的加速下载功能
    'https://ghproxy.cc',
    'https://ghproxy.net', # GitHub Proxy by GitHub99 - 提供 GitHub 文件的加速下载和克隆服务 #和用户自己的代理可能发生冲突
    'https://mirror.ghproxy.com',
    
    # 'https://ghproxy.com/bad/demo', #虚假镜像,用来测试代码是否能够正确处理不可用的镜像链接
    'https://ghproxy.homeboyc.cn/',
    'https://gh-proxy.com/',
    
    'https://gh.ddlc.top',
    'https://github.ur1.fun/',

    '' #空字符串收尾
)
$GithubMirrorsTest = @(
    'https://gh-proxy.com/',
    'https://ghps.cc/',
    'https://ghproxy.net/',
    'https://github.moeyy.xyz/',
    'https://gh.ddlc.top/',
    'https://slink.ltd/',
    'https://gh.con.sh/',
    'https://hub.gitmirror.com/',
    'https://sciproxy.com/',
    'https://cf.ghproxy.cc/',
    'https://gh.noki.icu/',

    ''#收尾
)
$GithubMirrors = $GithubMirrors + $GithubMirrorsTest
$GithubMirrors = $GithubMirrors | Where-Object { $_ }#移除空串
$GithubMirrors = $GithubMirrors | ForEach-Object { $_.trim('/') } | Sort-Object #统一链接风格(去除末尾的`/`如果有的话)
$GithubMirrors = $GithubMirrors | Get-Unique #移除重复条目

function Test-LinksLinearly
{
    <# 
    .SYNOPSIS
    线性地(串行地)测试链接是否能够在指定时间内响应,为powershell5 设计
    .NOTES
    链接数量多的话会造成测试时间很长,尽量使用并行方案(pwsh7),或者考虑设置小的$timeoutSec=1
    #>
    [cmdletbinding(DefaultParameterSetName = 'First')]
    param (
        $Mirrors = $GithubMirrors,
        $TimeOutSec = 4,
        [parameter(ParameterSetName = 'First')]
        $First = 5,
        [parameter(ParameterSetName = 'All')]
        [Alias('Full')]
        [switch]
        $All
    )
    $availableMirrors = @()
    
    foreach ($mirror in $Mirrors)
    {
        # $Mirrors | ForEach-Object {
        # $mirror = $_

        # Write-Verbose "Testing $mirror..."
        if (Test-MirrorAvailability -Url $mirror -TimeoutSec $TimeOutSec)
        {
            Write-Verbose "$mirror is available "
            Write-Host "`t $mirror" -ForegroundColor Green
            # 插入到数组中(这里如果foreach用了-parallel,就会导致无法访问外部的$availableMirros)
            $availableMirrors += $mirror
        }
        else
        {
            Write-Verbose "$mirror is not available "
            Write-Host "`t $mirror " -ForegroundColor Red
        }

        if ($pscmdlet.ParameterSetName -eq 'First')
        {

            if (($availableMirrors.Count -ge $First))
            {
                break #在foreach-object中会直接停止函数的运行,而使用传统foreach则是正常的
            }
        }
    } 
    if ($availableMirrors.Count -eq 0)
    {
        throw 'No mirrors are available!'
    }
    return $availableMirrors
}
function Test-LinksParallel
{
    <# 
    .SYNOPSIS
    为powershell 7+设计的并行测试链接是否能够在指定时间内响应
    #>
    [CmdletBinding()]
    param (
        $Mirrors = $GithubMirrors,
        $TimeOutSec = 2,
        $ThrottleLimits = 16
        # $First = 5
    )
    # 如果不是powershell 7报错
    if ($host.Version.Major -lt 7)
    {
        Throw 'PowerShell 7 or higher is required to run parallel foreach!'
        # return 
    }
    $availableMirrors = @()
    # 为了能够让$TimeOutSec能够被传递到子进程,这里使用了$env:来扩大其作用域
    # $env:TimeOutSec = $TimeOutSec
    # powershell提供了更好的方式访问并行scriptblock外的变量,使用$using: 这个关键字
    #然而这个关键字引用的变量无法更改(只读),可以考虑用.Net线程安全容器,或者用$env:来实现共享局部环境变量
    # $Envbak = $env:StopLoop
    # $env:StopLoop = 0
    # 创建线程安全容器(队列)
    $mirs = [System.Collections.Concurrent.ConcurrentQueue[Object]]::new()
    # $mirs.Enqueue('First_Demo')
    # Write-Host $mirs
    # 并行执行链接测试
    $Mirrors | ForEach-Object -Parallel {
        # if ([int]$env:StopLoop)
        # {
        #     return
        # }
        # Write-verbose $_
        #引用外部变量,并且赋值给简化的临时变量,方便后续引用(直接在-Parallel中引用外部变量是不合期望的)
        $mirs = $using:mirs
        $TimeOutSec = $using:TimeOutSec
        # $First = $using:First
        #  并行方案里用First参数指定前n个意义不大,而且会让代码变得复杂
        # Write-Verbose "mirs.cout=$($mirs.Count)" -Verbose
        # if ($mirs.Count -ge $First)
        # {
        #     # Write-Host $First
        #     Write-Verbose "The available links enough the $First !" -Verbose
        #     return
        # }
         

        $mirror = $_
        # Write-Debug "`$TimeOutSec=$env:TimeOutSec" -Debug #parallel 参数$DebugPreference无法起作用
        # if (Test-MirrorAvailability -Url $mirror -TimeoutSec $env:TimeOutSec)
        # 测试链接是否可用
        if (Test-MirrorAvailability -Url $mirror -TimeoutSec $using:TimeOutSec)
        {
            Write-Verbose "TimeOutSec=$using:TimeOutSec" # -Verbose
            Write-Host "`t $_" -ForegroundColor Green
            # Write-Output $mirror

            #写入队列
            $mirs.Enqueue($mirror)
            # 查看$mirs队列长度
            # $mirs.Count, $mirs

        }
        else
        {
            Write-Verbose "$mirror is not available "
            Write-Host "`t $mirror." -ForegroundColor Red
        }

    } -ThrottleLimit $ThrottleLimits 

    $availableMirrors = $mirs #.ToArray()
    if ($availableMirrors.Count -eq 0)
    {
        throw 'No mirrors are available!'
    }
    return $availableMirrors
}
function Test-MirrorAvailability
{
    <# 
    .SYNOPSIS
    测试指定链接是否在规定时间内相应
    .NOTES
    此函数主要用来辅助Test-LinksLinearly和Test-LinksParallel调用
    .DESCRIPTION
    如果及时正确相应,将链接打印为绿色,否则打印为红色
    #>
    [CmdletBinding()]
    param (
        [string]$Url,
        $TimeoutSec = 3
    )

    try
    {
        # 使用 Invoke-WebRequest 检查可用性
        $response = Invoke-WebRequest -Uri $Url -Method Head -TimeoutSec $TimeOutSec -ErrorAction Stop
        
        $availability = $response.StatusCode -eq 200
    }
    catch
    {
        $availability = $false
    }
    if ($VerbosePreference)
    {

        if ($availability)
        {

            Write-Host "Mirror $Url is available" -ForegroundColor Green
        }
        else
        {

            Write-Host "Mirror $Url is not available" -ForegroundColor Red
        }
    }
    return   $availability
}
function Get-AvailableGithubMirrors
{
    <#
    .SYNOPSIS
    列出流行的或可能可用的 GitHub 加速镜像站。
    列表中的镜像站可能会过期，可用性不做稳定性和可用性保证。

    .DESCRIPTION
    这里采用了多线程的方式来加速对不同镜像链接的可用性进行检查
    并且更容易获取其中相应最快的可用的镜像站,这是通过串行检查无法直接达到的效果
    .EXAMPLE
    

 .NOTES
    推荐使用 aria2 等多线程下载工具来加速下载，让镜像加速效果更加明显。
 
    .LINK
    # 镜像站搜集和参考
    https://github-mirror.us.kg/
    https://github.com/hunshcn/gh-proxy/issues/116
    #>
    [CmdletBinding()]
    param(
        $Mirrors = $GithubMirrors,
        $ThrottleLimits = 16,
        $TimeOutSec = 3,
        [switch]$ListView,
        [switch]$PassThru,
        [switch]$SkipCheckAvailability,
        # 是否启用串行地试探镜像可访问性(默认是并行试探)
        [switch]
        # [parameter(ParameterSetName = 'Serial')]
        [Alias('Serial')]$Linearly,
        # [parameter(ParameterSetName = 'Serial')]
        $First = 5
    )
    
    # 检查镜像站的可用性
   

    Write-Host 'Checking available Mirrors...'
    $availableMirrors = $Mirrors
    # 检查可用的镜像列表
    if (!$SkipCheckAvailability)
    {
        $psVersion = $host.Version.Major 
        # 默认尝试并行测试
        if ($psVersion -lt 7 -and !$Linearly)
        {

            Write-Host 'PowerShell 7 or higher is required to run parallel foreach!' -ForegroundColor Red
            Write-Host 'Testing Links Linearly...'
            $Linearly = $true
        }
        if ($Linearly ) #-or $PSVersion -lt 7
        {
            $availableMirrors = Test-LinksLinearly -Mirrors $Mirrors -TimeOutSec $TimeOutSec -First $First -Verbose:$VerbosePreference
        }
        else
        {
        
            $availableMirrors = Test-LinksParallel -Mirrors $Mirrors -TimeOutSec $TimeOutSec -ThrottleLimits $ThrottleLimits -Verbose:$VerbosePreference 
        }
    } 

    # Start-Sleep $TimeOutSec
    # 显示可用的镜像
    Write-Host "`nAvailable Mirrors:"
    # 空白镜像保留(作为返回值)
    $availableMirrors = @('') + $availableMirrors

    # 按序号列举展示
    Write-Host ' 0: Use No Mirror' -NoNewline
    $index = 1
    $availableMirrors | ForEach-Object {
        # $index = [array]::IndexOf($availableMirrors, $_)
        # if($availableMirrors[$index] -eq ""){continue}
        if ($_.Trim())
        {

            Write-Host " ${index}: $_" -NoNewline
            $index += 1
        }
   
        
        Write-Host ''
    }

    if ($PassThru)
    {
        return $availableMirrors
    }
}


function Get-SelectedMirror
{
    [CmdletBinding()]
    param (
        
        $Default = 1, # 默认选择第一个(可能是响应最快的)
        [switch]$Linearly,
        [switch]$Silent # 是否静默模式,不询问用户,返回第$Default个链接($Default默认为1)
    )
    $Mirrors = Get-AvailableGithubMirrors -PassThru -Linearly:$Linearly

    if (!$Silent)
    {
        # 交互模式
        $numOfMirrors = $Mirrors.Count
        $range = "[0~$($numOfMirrors-1)]"
        $num = Read-Host -Prompt "Select the number of the mirror you want to use $range ?(default: $default)"
        # $mirror = 'https://mirror.ghproxy.com'
        $n = $num -as [int] #可能是数字或者空$null
        if ($VerbosePreference)
        {
            
            Write-Verbose "`$n=$n"
            Write-Verbose "`$num=$num"
            Write-Verbose "`$numOfMirrors=$numOfMirrors"
        }
   
        #  如果输入的是空白字符,则默认设置为0
        if ( $num.trim().Length -eq 0)
        {
            Write-Host 'choose the Default 1'
            $n = $default
        }
        elseif ($n -notin 0..($numOfMirrors - 1))
        {
            Throw " Input a number within the range! $range"
        } 
    }
    else
    {
        $n = $default
    }
    if ($n -gt 0)
    {
        # 用户选择了一个合法的镜像代号(0表示不使用镜像)
        Write-Host "Selected mirror:[$n : " -NoNewline
        Write-Host "$($Mirrors[$n])" -BackgroundColor Gray -NoNewline
        Write-Host ']'#打印一个空行
    }
    $mirror = $Mirrors[$n]
    return $mirror
}


Get-AvailableGithubMirrors -ThrottleLimits $ThrottleLimits `
    -TimeOutSec $TimeOutSec -PassThru:$PassThru -SkipCheckAvailability:$SkipCheckAvailability `
     -Linearly:$Linearly -First $First 
     
```

## 使用示例

```powershell
PS> .\GetMirrors.ps1 -PassThru -TimeOutSec 5 #参数补全列表
Mirrors                TimeOutSec             SkipCheckAvailability
ThrottleLimits         ListView               Linearly

```

默认使用并行检查,需要powershell7+

```
PS> .\GetMirrors.ps1  -TimeOutSec 5
Checking available Mirrors...
         https://gh.ddlc.top
         https://gh.con.sh
         https://github.moeyy.xyz
         https://cf.ghproxy.cc
         https://hub.gitmirror.com
         https://ghproxy.homeboyc.cn
         https://github.ur1.fun
         https://gh-proxy.com
         https://sciproxy.com
         https://ghps.cc
         https://ghproxy.net
         https://ghproxy.cc
         https://gh.noki.icu.
         https://mirror.ghproxy.com.
         https://slink.ltd.
....

Available Mirrors:
 0: Use No Mirror
 1: https://gh.ddlc.top
 2: https://gh.con.sh
 3: https://github.moeyy.xyz
 4: https://cf.ghproxy.cc
 5: https://hub.gitmirror.com
 6: https://ghproxy.homeboyc.cn
 7: https://github.ur1.fun
 8: https://gh-proxy.com
 9: https://sciproxy.com
 10: https://ghps.cc
 11: https://ghproxy.net
 12: https://ghproxy.cc
```

线性检查(支持powershell v5)

这里指定找出2个可用链接就结束查找(默认找5个)

```powershell
PS C:\Users\cxxu\Desktop> .\TL.ps1 -Linearly -First 2
Checking available Mirrors...
         https://cf.ghproxy.cc
         https://gh.con.sh

Available Mirrors:
 0: Use No Mirror
 1: https://cf.ghproxy.cc
 2: https://gh.con.sh
```

powershell5中不指定`Linearly`参数也不会报错,自动切换为Linearly模式

```
PS C:\Users\cxxu\Desktop> .\GetMirrors.ps1 -First 2
Checking available Mirrors...
PowerShell 7 or higher is required to run parallel foreach!
Testing Links Linearly...
         https://cf.ghproxy.cc
         https://gh.con.sh

Available Mirrors:
 0: Use No Mirror
 1: https://cf.ghproxy.cc
 2: https://gh.con.sh
```

