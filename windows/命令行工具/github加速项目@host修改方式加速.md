[toc]



## abstract

- [无念晓/GitHub520 (gitee.com)](https://gitee.com/ynqxg/GitHub520)

## 一键拉取最新host脚本

要将这个 Bash 脚本转换为 PowerShell 脚本，可以按照以下步骤实现每个部分的功能。

### Bash 脚本的功能简析：
1. **`mktemp`**：创建一个临时文件。
2. **`sed`**：删除 hosts 文件中包含特定标记之间的内容。
3. **`curl`**：下载远程内容并追加到临时文件中。
4. **`cat`**：将临时文件的内容覆盖到目标文件中。
5. **`rm`**：删除临时文件。

### PowerShell 实现：
```powershell
# 创建临时文件
$tempHosts = New-TemporaryFile

# 定义 hosts 文件路径和远程 URL
$hosts = "C:\Windows\System32\drivers\etc\hosts"
$remote = "https://raw.hellogithub.com/hosts"

# 定义正则表达式
$reg = '(?ms)^# GitHub520 Host Start.*?# Github520 Host End$'

# 读取 hosts 文件并删除指定内容
(Get-Content $hosts) -replace $reg, '' | Set-Content $tempHosts

# 下载远程内容并追加到临时文件
Invoke-WebRequest -Uri $remote -UseBasicParsing -OutFile tempRemoteFile
Add-Content -Path $tempHosts -Value (Get-Content tempRemoteFile)

# 将临时文件的内容覆盖到 hosts 文件
Get-Content $tempHosts | Set-Content $hosts

# 删除临时文件
Remove-Item $tempHosts
Remove-Item tempRemoteFile
# 刷新配置
ipconfig /flushdns
```

### 脚本各部分解释：
1. **`New-TemporaryFile`**：在 PowerShell 中创建一个临时文件。
2. **`-replace`**：用正则表达式匹配并删除内容（`(?ms)` 是用于匹配多行模式的选项）。
3. **`Invoke-WebRequest`**：下载远程文件内容，`-UseBasicParsing` 用于简化解析。
4. **`Add-Content`**：将下载的内容追加到临时文件。
5. **`Set-Content`**：将临时文件内容覆盖到目标 hosts 文件。

### 注意事项：
- PowerShell 脚本需要以管理员权限运行，因为它涉及对 `hosts` 文件的修改。
- `Invoke-WebRequest` 下载的文件内容需要存储在本地临时文件 `tempRemoteFile` 中，再追加到 `$tempHosts`。

这段 PowerShell 脚本与原始 Bash 脚本具有相同的功能，但使用了 PowerShell 的原生命令来实现。

要在 PowerShell 中创建一个计划任务，使其每隔1小时运行一次 `Update-githubHosts` 脚本，可以按照以下步骤进行。下面是完整的 PowerShell 脚本，以及详细的解释：

## 自动更新

### 创建计划任务的 PowerShell 脚本：

```powershell
# 定义计划任务的基本属性

$f = "$PSScriptRoot\fetch-github-hosts.ps1" #自行修改为你的脚本保存目录(我将其放在powershell模块中,可以用$PSScriptRoot来指定目录)

$f = 'C:\repos\scripts\PS\Deploy\fetch-github-hosts.ps1' #这是绝对路径的例子

$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-NoProfile -WindowStyle Hidden -File $f"

$trigger1 = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1)
$trigger2 = New-ScheduledTaskTrigger -AtStartup

# $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
# ettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# 创建计划任务
Register-ScheduledTask -TaskName 'Update-githubHosts' -Action $action -Trigger $trigger1, $trigger2 #-Settings $settings  -Principal $principal
```

- 使用命令行

  ```
  
  ```

  

### 解释：

1. **`New-ScheduledTaskAction`**:
   - **`-Execute "PowerShell.exe"`**：指定要运行的程序为 PowerShell。
   - **`-Argument "-NoProfile -WindowStyle Hidden -File `"$PSScriptRoot\Update-githubHosts.ps1`""`**：指定参数。  
     - `-NoProfile`：不加载用户配置文件，以减少启动时间。  
     - `-WindowStyle Hidden`：隐藏 PowerShell 窗口。  
     - `-File`：指定要执行的脚本路径。`$PSScriptRoot` 是 PowerShell 变量，表示当前脚本所在的目录。

2. **`New-ScheduledTaskTrigger`**:
   - **`-Hourly`**：设置任务触发器为每小时一次。
   - **`-RepetitionInterval (New-TimeSpan -Hours 1)`**：设置任务重复间隔为1小时。

3. **`New-ScheduledTaskPrincipal`**:
   - **`-UserId "SYSTEM"`**：将任务配置为使用 `SYSTEM` 帐户运行，以确保具有足够的权限来修改 `hosts` 文件。
   - **`-LogonType ServiceAccount`**：表示任务将作为服务帐户运行。
   - **`-RunLevel Highest`**：以最高权限运行任务。

4. **`New-ScheduledTaskSettingsSet`**:
   - **`-AllowStartIfOnBatteries`**：允许任务在电池电量状态下启动。
   - **`-DontStopIfGoingOnBatteries`**：当设备切换到电池电量状态时，不停止任务。
   - **`-StartWhenAvailable`**：如果任务错过了触发时间，系统下一次开机时尽快运行。

5. **`Register-ScheduledTask`**:
   - **`-TaskName "Update-githubHosts"`**：任务的名称。
   - **`-Action $action`**：设置任务的操作。
   - **`-Trigger $trigger`**：设置任务的触发器。
   - **`-Principal $principal`**：设置任务的用户权限配置。
   - **`-Settings $settings`**：设置任务的其他配置选项。

### 执行脚本：
将 `Update-githubHosts.ps1` 脚本放置在合适的目录下，然后运行上面的 PowerShell 脚本即可创建任务计划。此任务每小时会自动运行一次，确保 `hosts` 文件得到及时更新。

### 注意事项：
- 确保 PowerShell 脚本和计划任务都以管理员权限运行，特别是涉及到系统文件的修改时。
- 如果需要修改计划任务，可以使用 `Set-ScheduledTask` 命令来调整配置。