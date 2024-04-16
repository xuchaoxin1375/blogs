[toc]

## 定时刷新

要在 PowerShell 启动后即在后台执行一个每5秒自动更新 `$env:LastUpdate` 环境变量的函数，您可以创建一个后台任务或者使用计时器来定期执行。

下面是一个使用 PowerShell Jobs 示例：

```powershell
# 定义更新环境变量的函数
Function Update-TimeStamp {
    $env:LastUpdate = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
}

# 创建一个后台作业，每5秒运行一次更新函数
$jobName = "UpdateTimeStampJob"
$timerInterval = 5 # 每5秒执行一次
$jobTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Seconds $timerInterval)
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-Command &{Update-TimeStamp}"
Register-ScheduledTask -TaskName $jobName -Trigger $jobTrigger -Action $action -RunLevel Highest -Force

# 启动定时任务
Start-ScheduledTask -TaskName $jobName

# 如果你想在当前 PowerShell 会话中也能立即看到更新的结果，可以添加一个循环来持续读取环境变量的值
while($true){
    Write-Host "Current TimeStamp: $($env:LastUpdate)"
    Start-Sleep -Seconds $timerInterval
}

# 注：为了在长时间运行的会话中保持环境变量更新可见，上述代码包含了一个无限循环，
# 在实际应用中，你可能需要根据实际情况调整，比如仅在必要时查询或仅运行一段时间后停止。
```

**注意**：上面的示例使用的是 `Register-ScheduledTask` 和 `Start-ScheduledTask` cmdlet 来模拟后台任务，它们是用于 Windows Task Scheduler 的，而不是直接创建 PowerShell Job。这是因为 PowerShell Jobs 在默认情况下不会持久化环境变量更改至全局作用域。

如果是在 PowerShell 会话内直接创建后台 job，并希望环境变量更改对当前会话可见，这种需求在 PowerShell 中不太容易实现，因为 job 内部的环境变量更改不会直接影响父进程的环境变量。为此，你可能需要设计一个不同方案，例如使用事件或队列在 job 和主会话之间传递更新的信息。 

然而，如果你只是希望在一个长期运行的 PowerShell 脚本中记录时间戳，可以直接在脚本内部使用一个循环而非创建后台任务或 job：

```powershell
while($true){
    $env:LastUpdate = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    # 可选：在此处执行任何需要基于时间戳的操作
    Start-Sleep -Seconds 5
}
```

但请注意，这样的脚本将会持续运行直到被手动停止，它适用于控制台应用程序，而不适合于设置为系统级别的后台服务或任务计划程序的任务。