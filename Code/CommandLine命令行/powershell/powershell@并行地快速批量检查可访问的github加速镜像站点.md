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
    [switch]$Linearly
)

$GithubMirrors = @(
    # 注意,如果你的浏览器使用了代理,那么部分镜像站会和代理冲突,所以可能命令行中测试可以访问的链接在浏览器中确打不开镜像站,可以关闭代理或换个浏览器后重新验证该镜像站的可用性
    #搜集到的链接可以用gpt进行修改,将链接包裹引号(指令:为这些链接分别添加引号);或者自己粘贴到文件文件中然后编写脚本转换为数组格式
    'https://github.moeyy.xyz', # Moeyy - 提供 GitHub 文件的加速下载功能
    'https://ghproxy.cc',
    'https://ghproxy.net', # GitHub Proxy by GitHub99 - 提供 GitHub 文件的加速下载和克隆服务 #和用户自己的代理可能发生冲突
    'https://mirror.ghproxy.com',
    # 'https://github-mirror.us.kg',#请打开此网站找到可用的镜像站，直接使用此来链接不适合实际用途，仅允许小流量代理
    
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
$GithubMirrors = $GithubMirrors | ForEach-Object { $_.trim('/') } | Sort-Object
$GithubMirrors = $GithubMirrors | Get-Unique

function Test-LinksLinearly
{
    [cmdletbinding()]
    param (
        $Mirrors,
        $TimeOutSec
    )
    $availableMirrors = @()
    
    # foreach ($mirror in $Mirrors)
    $Mirrors | ForEach-Object {
        $mirror = $_
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
    } 
    return $availableMirrors
}
function Test-LinksParallel
{
    <# 
    .SYNOPSIS
    
    #>
    [CmdletBinding()]
    param (
        $Mirrors,
        $TimeOutSec,
        $ThrottleLimits = 16
    )
    $availableMirrors = @()
    # 为了能够让$TimeOutSec能够被传递到子进程,这里使用了$env:来扩大其作用域
    # $env:TimeOutSec = $TimeOutSec
    # powershell提供了更好的方式访问并行scriptblock外的变量,使用$using: 这个关键字
    # 并行执行链接测试
    $Mirrors | ForEach-Object -Parallel {
        $mirror = $_
        # Write-Debug "`$TimeOutSec=$env:TimeOutSec" -Debug #parallel 参数$DebugPreference无法起作用
        # if (Test-MirrorAvailability -Url $mirror -TimeoutSec $env:TimeOutSec)
        if (Test-MirrorAvailability -Url $mirror -TimeoutSec $using:TimeOutSec)
        {
            Write-Verbose "TimeOutSec=$using:TimeOutSec" # -Verbose
            Write-Output $mirror
        }
        else
        {
            Write-Verbose "$mirror is not available "
            Write-Host "`t $mirror." -ForegroundColor Red
        }
    } -ThrottleLimit $ThrottleLimits | ForEach-Object {
        $availableMirrors += $_
        Write-Verbose "$_ is available "
        Write-Host "`t $_" -ForegroundColor Green
    }
    return $availableMirrors
}
function Test-MirrorAvailability
{
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
    例如,两次执行期间,列出的顺序发生了变化,其中mirror.ghproxy.com和ghproxy.net排名发生了互换
    PS> Get-AvailableGithubMirrors -TimeOutSec 2
    Checking available Mirrors...
            https://github.moeyy.xyz
            https://gh.ddlc.top
            https://mirror.ghproxy.com
            https://ghproxy.net
            https://ghproxy.cc

    Available Mirrors:
    0: Use No Mirror
    1: https://github.moeyy.xyz
    2: https://gh.ddlc.top
    3: https://mirror.ghproxy.com
    4: https://ghproxy.net
    5: https://ghproxy.cc

    第二次执行
    PS> Get-AvailableGithubMirrors -TimeOutSec 2
    Checking available Mirrors...
            https://github.moeyy.xyz
            https://gh.ddlc.top
            https://ghproxy.net
            https://mirror.ghproxy.com
            https://ghproxy.cc

    Available Mirrors:
    0: Use No Mirror
    1: https://github.moeyy.xyz
    2: https://gh.ddlc.top
    3: https://ghproxy.net
    4: https://mirror.ghproxy.com
    5: https://ghproxy.cc

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
        # 是否启用线性试探镜像可访问性(默认是并行试探)
        [switch]$Linearly
    )
    
    # 检查镜像站的可用性
   

    Write-Host 'Checking available Mirrors...'
    $availableMirrors = $Mirrors
    # 检查可用的镜像列表
    if (!$SkipCheckAvailability)
    {
        if ($Linearly)
        {
            $availableMirrors = Test-LinksLinearly -Mirrors $Mirrors -TimeOutSec $TimeOutSec
        }
        else
        {
            $availableMirrors = Test-LinksParallel -Mirrors $Mirrors -TimeoutSec $TimeOutSec -ThrottleLimits $ThrottleLimits -Verbose:$VerbosePreference 
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


Get-AvailableGithubMirrors -ThrottleLimits $ThrottleLimits `
-TimeOutSec $TimeOutSec -PassThru:$PassThru -SkipCheckAvailability:$SkipCheckAvailability -Linearly:$Linearly
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

```
PS> .\GetMirrors.ps1 -Linearly
Checking available Mirrors...
         https://cf.ghproxy.cc
         https://gh-proxy.com
         https://gh.con.sh
         https://gh.ddlc.top
```

