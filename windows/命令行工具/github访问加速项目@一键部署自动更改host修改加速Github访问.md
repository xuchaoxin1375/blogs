[toc]

## abstract

- 尽管这里实现了一键部署自动更新hosts的脚本,但是可用性仍然取决于原项目提供的hosts是否可用
- 主要用来加速访问github网站，用来直接查看原github项目链接的,对于资源下载效果不大,这方面的需要可以用加速镜像来加速下载或克隆,或者cgit等工具

## powershell 版本的一键更新hosts文件

- [GitHub520: :kissing_heart: 让你“爱”上 GitHub，解决访问时图裂、加载慢的问题。（无需安装）](https://github.com/xuchaoxin1375/GitHub520/tree/main)

### 更新Hosts

这部分对应于git-bash脚本

```bash
_hosts=$(mktemp /tmp/hostsXXX)
hosts=/c/Windows/System32/drivers/etc/hosts
remote=https://raw.hellogithub.com/hosts
reg='/# GitHub520 Host Start/,/# Github520 Host End/d'

sed "$reg" $hosts > "$_hosts"
curl "$remote" >> "$_hosts"
cat "$_hosts" > "$hosts"

rm "$_hosts"
```

## 操作步骤

- 如果你不想了解细节，直接跳转到后面的一键运行整合脚本一节


### 准备:设置powershell执行策略

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy bypass
```

结束之后,如果不放心,可以将`bypass`重新设置为`default`

详情:[Set-ExecutionPolicy (Microsoft.PowerShell.Security) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.4#-executionpolicy)

### powrshell脚本

```powershell

function Update-githubHosts
{
    <# 
    .SYNOPSIS
    函数会修改hosts文件，从github520项目获取快速访问的hosts
    .DESCRIPTION
    需要用管理员权限运行
    原项目提供了bash脚本,这里补充一个powershell版本的,这样就不需要打开git-bash
    .Notes
    与函数配套的,还有一个Deploy-githubHostsAutoUpdater,它可以向系统注册一个按时执行此脚本的自动任务(可能要管理员权限运行),可以用来自动更新hosts
    .NOTES
    可以将本函数放到powershell模块中,也可以当做单独的脚本运行
    .LINK
    https://github.com/521xueweihan/GitHub520
    .LINK
    https://gitee.com/xuchaoxin1375/scripts/tree/main/PS/Deploy
    #>
    [CmdletBinding()]
    param (
        # 可以使用通用的powershell参数(-verbose)查看运行细节
        $hosts = 'C:\Windows\System32\drivers\etc\hosts',
        $remote = 'https://raw.hellogithub.com/hosts'
    )
    # 创建临时文件
    # $tempHosts = New-TemporaryFile

    # 定义 hosts 文件路径和远程 URL

    # 定义正则表达式
    $reg = '(?s)# GitHub520 Host Start.*?# GitHub520 Host End'


    # 读取 hosts 文件并删除指定内容,再追加新内容
    # $content = (Get-Content $hosts) 
    $content = Get-Content -Raw -Path $hosts
    # Write-Host $content
    #debug 检查将要替换的内容

    #查看将要被替换的内容片段是否正确
    # $content -match $reg
    $res = [regex]::Match($content, $reg)
    Write-Verbose '----start----'
    Write-Verbose $res[0].Value
    Write-Verbose '----end----'

    # return 
    $content = $content -replace $reg, ''

    # 追加新内容到$tempHosts文件中
    # $content | Set-Content $tempHosts
    #也可以这样写:
    #$content | >> $tempHosts 

    # 下载远程内容并追加到临时文件
    # $NewHosts = New-TemporaryFile
    $New = Invoke-WebRequest -Uri $remote -UseBasicParsing #New是一个网络对象而不是字符串
    $New = $New.ToString() #清理头信息
    #移除结尾多余的空行,避免随着更新,hosts文件中的内容有大量的空行残留
       
    # 将内容覆盖添加到 hosts 文件 (需要管理员权限)
    # $content > $hosts
    $content.TrimEnd() > $hosts
    ''>> $hosts #使用>>会引入一个换行符(设计实验:$s='123',$s > example;$s >> example就可以看出引入的换行),这里的策略是强控,即无论之前Github520的内容和前面的内容之间隔了多少个空格,
    # 这里总是移除多余(全部)空行,然后手动插入一个空行,再追加新内容(Gith520 hosts)
    $New.Trim() >> $hosts

    
    Write-Verbose $($content + $NewContent)
    # 刷新配置
    ipconfig /flushdns
    
}
Update-githubHosts
```

您可以将上述脚本复制粘贴到一个文本文件中（.txt),然后保存修改,并将文件重命名为`fetch-github-hosts.ps1`

建议单独创建一个文件夹来存放该文件,比如`C:\GithubHostUpdate`,或简单点的`C:\GHU`

```
PS C:\GHU> ls

    Directory: C:\GHU

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           2024/8/19    16:57           2517 fetch-github-hosts.ps1

```

后续计划任务会定期执行这里的脚本文件

你也可以考虑创建这个文件的快捷方式，指定不同的powershell版本（比如powershell7)来执行`.ps1`,而不是系统帮你选择

### 注册计划任务定期自动执行上述操作

下面的代码可以作为一次性的代码,可以保存到powershell配置文件或某个模块中

- ```powershell
  
  param(
      $f = "$PSScriptRoot\fetch-github-hosts.ps1",
      [ValidateSet('pwsh', 'powershell')]$shell = 'powershell',
      [switch]$verbose
  )
  function Deploy-GithubHostsAutoUpdater
  {
      <# 
      .SYNOPSIS
      向系统注册自动更新GithubHosts的计划任务
      .DESCRIPTION
      如果需要修改触发器，可以自行在源代码内调整，或者参考Microsoft相关文档；也可以使用taskschd.msc 图形界面来创建或修改计划任务
  
      .NOtes
      移除计划任务：
      unregister-ScheduledTask -TaskName  Update-GithubHosts
      #>
      [CmdletBinding()]
      param (
          
          [ValidateSet('pwsh', 'powershell')]$shell = 'powershell',
          # 需要执行的更新脚本位置
          $f = '' #自行指定
      )
      # 检查参数情况
      Write-Verbose 'Checking parameters ...'
      $PSBoundParameters | Format-Table   
  
      # 开始注册
      Write-Host 'Registering...'
      Start-Sleep 3
      # 定义计划任务的基本属性
      if (! $f)
      {
      
          $f = "$PSScriptRoot\fetch-github-hosts.ps1" #自行修改为你的脚本保存目录(我将其放在powershell模块中,可以用$PSScriptRoot来指定目录)
         
          # $f = 'C:\repos\scripts\PS\Deploy\fetch-github-hosts.ps1' #这是绝对路径的例子(注意文件名到底是横杠（-)还是下划线(_)需要分清楚
      }
  
      $action = New-ScheduledTaskAction -Execute $shell -Argument " -ExecutionPolicy ByPass -NoProfile -WindowStyle Hidden -File $f"
      # 定义两个触发器
      $trigger1 = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1)
      $trigger2 = New-ScheduledTaskTrigger -AtStartup
      # 任务执行角色设置
      $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
      $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
  
      # 创建计划任务
      Register-ScheduledTask -TaskName 'Update-githubHosts' -Action $action -Trigger $trigger1, $trigger2 -Settings $settings -Principal $principal
  }
  
  Deploy-GithubHostsAutoUpdater -f $f -shell $shell -Verbose:$verbose
  ```

  如同上一步的手法，将这一段代码保存到脚本文件`C:\GHU\Autofetch.ps1`

  可以用管理员方式运行它，或者在管理powershell中执行：

  ```powershell
  # cd C:\GHU
  #调用它(可以传参,也可以不穿,使用默认参数) #号后面是传参示例
  C:\GHU\AutoFetch.ps1  # -f C:\GHU\fetch-github-hosts.ps1 -shell powershell
  ```

  

### 相关目录结构

```powershell
PS C:\Users\cxxu\Desktop> ls C:\GHU\


    目录: C:\GHU


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2024/8/19     17:45           2155 AutoFetch.ps1
-a----         2024/8/19     16:57           2517 fetch-github-hosts.ps1
```

## 其他方法获取相关脚本

从[PS/Deploy/GithubHostsUpdater · xuchaoxin1375/scripts - 码云 - 开源中国 (gitee.com)](https://gitee.com/xuchaoxin1375/scripts/tree/main/PS/Deploy/GithubHostsUpdater)下载两个文件

gitee没有提供下载按钮,可以点击查看原始数据(或者直接点击下面的链接,然后分别保存,保存的时候后缀改为`.ps1`,而不是`.txt`)

- [gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/GithubHostsUpdater/AutoFetch.ps1](https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/GithubHostsUpdater/AutoFetch.ps1)
- [gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/GithubHostsUpdater/fetch-github-hosts.ps1](https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/GithubHostsUpdater/fetch-github-hosts.ps1)

或者从本仓库的GHU目录下载

## 一键运行整合脚本🤖🐽

上面的步骤也许不是你关心的,那么一键运行了解以下

下面的代码自动下载需要的脚本文件,自动执行并注册到计划任务

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy bypass 
$files = ('AutoFetch.ps1', 'fetch-github-hosts.ps1')
$files | ForEach-Object {
    Invoke-RestMethod https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Deploy/GithubHostsUpdater/$_ > $home\desktop\$_ 
}

$GHU = 'C:\GUH'
if (! (Test-Path $GHU) )
{ 
    mkdir $GHU
}
Set-Location $home\desktop

$files | ForEach-Object {
    Move-Item "$home/desktop/$_" $GHU -Force -Verbose
}
#调用它(可以传参,也可以不穿,使用默认参数) #号后面是传参示例
powershell -f  "$GHU\AutoFetch.ps1 " # -f $GHU\fetch-github-hosts.ps1 -shell powershell

```

管理员方式打开powershell,然后复制粘贴上述代码,运行即可

## 检查

- 你可以通过以下命令来立即触发更新host的任务，看看是否生效

  ```powershell
  start-scheduledTask -TaskName Update-githubhosts
  
  sleep 5 #等待5秒钟，让更新操作完成
  # 检查hosts文件修改情况(上一次更改时间)
  $hosts = 'C:\Windows\System32\drivers\etc\hosts'
  ls $hosts|select LastWriteTime
  cat $hosts|select -Last 5 #查看hosts文件的最后5行信息
  # Notepad $hosts 查看整个hosts文件
  ```

- 例如

  ```
  PS> $hosts = 'C:\Windows\System32\drivers\etc\hosts'
  
  PS☀️[BAT:77%][MEM:23.37% (7.41/31.71)GB][10:23:35]
  #⚡️[cxxu@CXXUCOLORFUL][192.168.1.178][C:\tmp\scoop-cn\Deploy-ScoopForCNUser]
  PS> ls $hosts|select LastWriteTime
  
  LastWriteTime
  -------------
  2024/8/21 10:14:25
  ```

  