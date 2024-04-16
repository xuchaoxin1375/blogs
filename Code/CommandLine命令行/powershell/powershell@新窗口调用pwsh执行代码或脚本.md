[toc]





### 情形1

- 要在PowerShell中启动另一个PowerShell窗口并执行一段PowerShell代码，你可以使用 `Start-Process` cmdlet 结合 `-ArgumentList` 参数来传递你要执行的命令。下面是一个示例，假设我们要在新的PowerShell窗口中执行 `Get-Process` 命令：

```powershell
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-Command", "Get-Process"
```

- `-FilePath "powershell.exe"` 指定要启动的进程，这里是要启动新的PowerShell进程。
- `-NoExit` 参数表示新启动的PowerShell窗口在命令执行完毕后保持打开状态，不立即退出。
- `-Command` 参数后面跟的是要在新窗口中执行的PowerShell命令或脚本。

### 情形2

- 如果你想执行的是一段较长的脚本，你可以将脚本保存在一个.ps1文件中，然后在 `-Command` 参数中引用该文件：

```powershell
$scriptPath = "C:\path\to\your_script.ps1"
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-File", "$scriptPath"
```

注意，如果您的环境中启用了执行策略限制，那么在新启动的PowerShell窗口中执行脚本可能还需要符合相应的执行策略要求。例如，如果执行策略设置为 RemoteSigned，则需要本地创建的脚本文件经过签名或信任。如果执行策略阻止了脚本执行，请参照之前关于执行策略的解答来更改策略设置。



### 例

- 延迟关机

  ```powershell
   $shutdown_process = Start-Process -FilePath 'pwsh.exe' -ArgumentList '-NoProfile', '-Command', 
      @'
           $timer = 5 ;#赋值给变量timer
           #将每秒的倒计时过程显示出来
           foreach ($i in 0..($timer-1))
           {
               Write-Host $($timer - $i)
               Start-Sleep 1
          }
          write-host "shutting down!"
          sleep 1
          #stop-computer#关机
          #rundll32.exe powrprof.dll, SetSuspendState 0, 1, 0#睡眠
  '@
  ```

  