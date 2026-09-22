<#
.SYNOPSIS
    Windows 中文系统下 opencode agent + pwsh 输出中文乱码的一键配置脚本。

.DESCRIPTION
    依据《opencode中文乱码修复指南.md》的分层方案自动完成四处工作:

    1. 环境检测  :检测当前输出编码是否为 GBK(936),并识别 pwsh 安装来源
                   (MSIX 别名 / MSI / scoop),提示已知坑;
    2. 手动终端  :在 $PROFILE 追加 UTF-8 输出编码设置(幂等,仅当缺失时追加),
                   修复你自己打开的 pwsh 终端;
    3. agent 命令:部署 opencode 插件 utf8-output.ts——opencode 以
                   -NoProfile 启动 pwsh,配置文件不生效,必须靠插件为每一条
                   bash 命令自动注入 [Console]::OutputEncoding=[UTF8] 前缀;
    4. 验证      :新开 pwsh 会话确认编码已是 utf-8,并给出最终操作提示。

    脚本幂等:重复执行不会产生重复配置;插件内容不一致时默认跳过(可用 -Force 覆盖)。

.PARAMETER Force
    插件文件已存在但内容与脚本内置版本不一致时,默认跳过不处理;
    加 -Force 后强制覆盖为脚本内置版本。

.PARAMETER SkipProfile
    跳过第 2 步($PROFILE 配置),仅处理 opencode 插件部分。

.PARAMETER SkipPlugin
    跳过第 3 步(opencode 插件部署),仅处理 $PROFILE 部分。

.NOTES
    文件    : opencode中文乱码修复一键配置.ps1
    依赖    : PowerShell 7(pwsh);opencode 已安装
    生效    : $PROFILE 对"新开的终端"生效;插件对"重启后的 opencode"生效
    兼容    : 脚本写出的 .ps1 文件用 UTF-8 BOM,Windows PowerShell 5.1 亦可正确读取
    对应指南: 《opencode中文乱码修复指南.md》第 3.1 / 3.2 节

.EXAMPLE
    .\opencode中文乱码修复一键配置.ps1

.EXAMPLE
    .\opencode中文乱码修复一键配置.ps1 -Force

.EXAMPLE
    .\opencode中文乱码修复一键配置.ps1 -SkipProfile
#>

[CmdletBinding()]
param(
    [switch]$Force,        # 覆盖内容不一致的已有插件文件
    [switch]$SkipProfile,  # 跳过 $PROFILE 配置
    [switch]$SkipPlugin    # 跳过 opencode 插件部署
)

# 任何环节报错即中止,避免"配到一半"的状态
$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------
# 关键:输出编码器在"首次输出"时即固定,之后再改 [Console]::OutputEncoding 均无效
# (实测:设置编码前只要写过一行 Write-Host,后续所有输出仍是 GBK)。
# 因此必须把编码开关放在脚本最顶部、任何输出之前。
# 原编码值先存进变量,供步骤 1 展示"配置前"的真实环境状态。
# ---------------------------------------------------------------
$originalOutputEncoding = [Console]::OutputEncoding.WebName
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ---------------------------------------------------------------
# 日志辅助:统一输出格式,便于一眼看出哪些是信息/完成/跳过
# ---------------------------------------------------------------
function Write-Info { param([string]$msg) Write-Host "[信息] $msg" -ForegroundColor Cyan }
function Write-Ok   { param([string]$msg) Write-Host "[完成] $msg" -ForegroundColor Green }
function Write-Warn { param([string]$msg) Write-Host "[跳过] $msg" -ForegroundColor Yellow }

Write-Info ''
Write-Info '=================================================='
Write-Info ' opencode + pwsh 中文乱码修复 一键配置脚本'
Write-Info '=================================================='

# ===============================================================
# 步骤 1/4:环境检测
#   1) 当前输出编码:gb2312/936 即命中乱码场景,utf-8 则已正常;
#   2) pwsh 安装来源:MSIX 别名(A 执行别名,零字节)可能让旧版
#      opencode 检测失败并静默回退 PowerShell 5.1,需提示用户。
# ===============================================================
Write-Info ''
Write-Info '== [1/4] 环境检测 =='
Write-Info ("PowerShell 版本      : " + $PSVersionTable.PSVersion)
Write-Info ("当前输出编码(配置前): " + $originalOutputEncoding)

# 找出 opencode 实际会调用的 pwsh 可执行文件(按 PATH 顺序取第一个)
$pwshCmd = Get-Command pwsh -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $pwshCmd) {
    # 理论上不可能走到:脚本本身就跑在 pwsh 里
    Write-Warn 'PATH 中未找到 pwsh 命令(异常情况,请检查安装)'
} else {
    Write-Info ("pwsh 位置            : " + $pwshCmd.Source)
    if ($pwshCmd.Source -like '*WindowsApps*') {
        # MSIX 版是 0 字节的 App Execution Alias,部分 opencode 版本 isFile() 校验失败
        Write-Warn '检测到 MSIX(商店)版 pwsh——旧版 opencode 可能静默回退到 PowerShell 5.1;'
        Write-Warn '        建议改用 MSI 版(C:\Program Files\PowerShell\7\pwsh.exe)或 scoop 版。'
    } else {
        # MSI / scoop / 自解压版均为真实 exe,不存在检测问题
        Write-Ok 'pwsh 为真实可执行文件,opencode 可正常发现(非 MSIX 别名)'
    }
}

# ===============================================================
# 步骤 2/4:修复"手动打开的终端" —— 修改 $PROFILE
#   原理:agent 场景无需此步,但你自己开的 pwsh 终端同样默认 GBK;
#        把编码设置写进 profile,每次新会话自动生效。
#   幂等:配置文件已含标记文本则跳过,不会重复追加。
#   编码:文件整体以 UTF-8 BOM 写回,Windows PowerShell 5.1 也能正确读取。
# ===============================================================
if (-not $SkipProfile) {
    Write-Info ''
    Write-Info '== [2/4] 配置手动终端($PROFILE) =='

    $profilePath = $PROFILE            # 当前用户当前主机 profile(Microsoft.PowerShell_profile.ps1)
    $marker      = '# UTF-8 输出编码(修复中文乱码)'   # 幂等检测标记,不可与正文重复

    # 将要在 profile 末尾追加的代码块(先拼好,校验后再写入)
    $profileBlock = @"

$marker
if ([Console]::OutputEncoding.WebName -ne 'utf-8') {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
}
"@

    # $PROFILE 文件可能尚不存在(首次配置),先保证父目录存在
    $profileDir = Split-Path -Parent $profilePath
    if (-not (Test-Path -LiteralPath $profileDir)) {
        New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
    }

    if (Test-Path -LiteralPath $profilePath) {
        # 按系统默认编码读原内容:保留原有中文/注释,避免把已有 GBK 内容读坏
        $originText = [IO.File]::ReadAllText($profilePath, [Text.Encoding]::Default)
        if ($originText.Contains($marker)) {
            Write-Warn "$profilePath 已包含 UTF-8 设置,无需重复配置"
        } else {
            [IO.File]::WriteAllText($profilePath, $originText + $profileBlock, [Text.UTF8Encoding]::new($true))
            Write-Ok "已向 $profilePath 追加 UTF-8 输出编码设置"
        }
    } else {
        # 文件不存在:直接创建(仅写入编码块 + 顶部注释)
        $header = "# 自动生成:opencode中文乱码修复一键配置.ps1`r`n"
        [IO.File]::WriteAllText($profilePath, $header + $profileBlock, [Text.UTF8Encoding]::new($true))
        Write-Ok "已创建 $profilePath 并写入 UTF-8 输出编码设置"
    }
} else {
    Write-Info '== [2/4] 已跳过 $PROFILE 配置(-SkipProfile) =='
}

# ===============================================================
# 步骤 3/4:修复"agent 的命令" —— 部署 opencode 插件
#   原理:opencode 以 `pwsh -NoLogo -NoProfile -NonInteractive -Command`
#         启动,`-NoProfile` 导致第 2 步对 agent 完全无效;
#         插件在 tool.execute.before 钩子里给每条 bash 命令自动注入
#         `[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; ` 前缀,
#         对所有命令(pwsh/git/Get-ChildItem)均无害。
#   幂等:文件已存在且内容一致则跳过;不一致默认跳过,加 -Force 覆盖。
#   生效:必须退出并重启 opencode(插件只加载一次)。
# ===============================================================
if (-not $SkipPlugin) {
    Write-Info ''
    Write-Info '== [3/4] 部署 opencode 插件(agent 命令修复) =='

    $pluginDir  = Join-Path $env:USERPROFILE '.config\opencode\plugin'
    $pluginFile = Join-Path $pluginDir 'utf8-output.ts'

    # 插件源代码(单引号 here-string:原样保留,不做任何变量展开)
    $pluginSource = @'
import type { Plugin } from "@opencode-ai/plugin"

export default (): Plugin => ({
  "tool.execute.before": async (input, output) => {
    if (input.tool === "bash" && typeof output.args?.command === "string") {
      if (!/Console\.OutputEncoding/.test(output.args.command)) {
        output.args.command = `[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; ${output.args.command}`
      }
    }
  },
})
'@

    # 插件目录不存在则创建(与指南一致:Linux/macOS 路径相同结构)
    if (-not (Test-Path -LiteralPath $pluginDir)) {
        New-Item -ItemType Directory -Force -Path $pluginDir | Out-Null
    }

    if (Test-Path -LiteralPath $pluginFile) {
        # 已存在:比较内容决定是跳过还是覆盖
        $existing = [IO.File]::ReadAllText($pluginFile)
        if ($existing -eq $pluginSource) {
            Write-Warn '插件已存在且内容一致,无需改动'
        } elseif ($Force) {
            [IO.File]::WriteAllText($pluginFile, $pluginSource, [Text.UTF8Encoding]::new($false))
            Write-Ok '插件内容不一致,已用内置版本覆盖(-Force)'
        } else {
            Write-Warn '插件已存在但内容与内置版本不一致,已跳过(如需覆盖请加 -Force)'
        }
    } else {
        [IO.File]::WriteAllText($pluginFile, $pluginSource, [Text.UTF8Encoding]::new($false))
        Write-Ok "已创建插件 $pluginFile"
    }
} else {
    Write-Info '== [3/4] 已跳过 opencode 插件部署(-SkipPlugin) =='
}

# ===============================================================
# 步骤 4/4:验证
#   单独开一个全新 pwsh 进程并加载 $PROFILE,确认编码已切到 utf-8;
#   若脚本曾在 GBK 环境下输出中文,此步输出本身可能乱码,只看编码值即可。
# ===============================================================
Write-Info ''
Write-Info '== [4/4] 验证 =='

$check = pwsh -NoLogo -NonInteractive -Command "& `"$PROFILE`" *> `$null; [Console]::OutputEncoding.WebName"
if ($check -match 'utf-8') {
    Write-Ok "新会话(加载 $PROFILE 后)输出编码:utf-8 —— 手动终端已修复"
} else {
    Write-Warn "新会话输出编码仍为:$( $check -join '' )(仅当 -SkipProfile 时属预期)"
}

Write-Info ''
Write-Ok '全部配置完成。最终生效步骤(必做):'
Write-Info '  1) 重启 opencode  —— 插件只在启动时加载一次;'
Write-Info '  2) 新开终端     —— $PROFILE 对新会话生效;'
Write-Info '  3) 在 opencode 里让 agent 执行:Write-Output "测试中文输出:网络适配器"'
Write-Info '     中文正常显示即修复成功;若仍乱码,见指南第 3.3 节系统级 UTF-8 方案。'
Write-Info '=================================================='