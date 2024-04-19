[toc]

## abstract

- powershell@调用pwsh@pwsh的参数和选项@新窗口调用pwsh执行代码或脚本.md

- PowerShell（pwsh）命令行工具提供了一系列参数来控制其启动行为和执行脚本或命令的方式。


### pwsh命令行选项


1. -File: 执行指定的 PowerShell 脚本文件。
2. -Command: 执行指定的 PowerShell 命令或脚本块，并退出。如果命令中包含特殊字符，可以使用 Base64 编码的命令字符串。
3. -CommandWithArgs: 执行指定的 PowerShell 命令，并传递参数给命令。
4. -ConfigurationName: 指定运行 PowerShell 的配置端点名称。
5. -ConfigurationFile: 指定 PowerShell 会话配置文件路径。
6. -CustomPipeName: 指定用于调试的额外命名管道名称。
7. -EncodedCommand: 接受 Base64 编码的命令字符串。
8. -ExecutionPolicy: 设置默认的执行策略。
9. -InputFormat: 指定输入数据的格式。
10. -Interactive: 显示交互式提示符。
11. -Login: 以登录 shell 方式启动 PowerShell。
12. -MTA: 以多线程单元启动 PowerShell。
13. -NoExit: 执行命令后不退出。
14. -NoLogo: 隐藏启动时的横幅文本。
15. -NonInteractive: 以非交互方式启动 PowerShell。
16. -NoProfile: 不加载 PowerShell 配置文件。
17. -OutputFormat: 指定输出的格式。
18. -SettingsFile: 指定覆盖系统配置文件的会话配置文件。
19. -SSHServerMode: 用于在 sshd_config 中将 PowerShell 作为 SSH 子系统运行。
20. -STA: 以单线程单元启动 PowerShell。
21. -Version: 显示 PowerShell 版本。
22. -WindowStyle: 设置窗口样式。
23. -WorkingDirectory: 设置初始工作目录。
24. -Help: 显示帮助信息。

### 重点选项

这些内容总结自`pwsh -h`的输出内容

以下是对这些参数的简要翻译与总结：

1. **-File (-f)**：如果指定为 `-`，则从标准输入读取命令文本。不重定向标准输入时运行 `pwsh -File -` 会启动一个常规会话，相当于没有指定 `-File` 参数。当命令行中有值但没有其他参数时，默认使用此参数。该参数会导致脚本在本地作用域（即“点源”）中运行，创建的函数和变量在当前会话中可用。指定脚本文件路径及其参数，且 `-File` 必须是命令中的最后一个参数，因为在其后的所有字符都被解释为脚本文件路径及脚本参数。

   对于脚本开关参数，通常要么包含要么省略。例如，下面的命令使用了 `Get-Script.ps1` 脚本文件的 `All` 参数：`-File .\Get-Script.ps1 -All`
   
   在罕见情况下，可能需要为开关参数提供布尔值。在 `-File` 参数值中为开关参数提供布尔值时，应按正常方式跟随冒号和布尔值，例如：`-File .\Get-Script.ps1 -All:$False`
   
   传递给脚本的参数作为字面字符串传递，在当前shell进行解析后。例如，在cmd.exe中传入环境变量值时，应使用cmd.exe语法：`pwsh -File .\test.ps1 -TestParam%windir%`

2. **-Command (-c)**：执行指定的命令（以及任何参数），就像它们是在PowerShell命令提示符中键入的一样，并在未指定 `-NoExit` 参数时退出。`-Command` 的值可以是 `-`、脚本块或字符串。若值为 `-`，则从标准输入读取命令文本。

   当从非PowerShell主机调用 `pwsh` 时，只有识别到传递给 `Command` 的值为 `ScriptBlock` 类型时，才能接受脚本块执行。而在 cmd.exe 中不存在脚本块概念，传递给 `Command` 的值总是字符串。然而，可以在字符串内写入脚本块，但不会执行，而是像在PowerShell提示符中直接键入一样打印出脚本块的内容。要在字符串中执行内联脚本块，可以使用调用运算符 `&`：`pwsh -Command "&{Get-WinEvent -LogName security}"`

   如果 `Command` 的值为字符串，则 `Command` 必须是 `pwsh` 的最后一个参数，因为之后的所有参数都被视为要执行命令的一部分。在现有PowerShell会话内部调用时，结果以反序列化的XML对象形式返回给父shell，而非实时对象；对于其他类型的shell，结果以字符串形式返回。

3. **-CommandWithArgs (-cwa)**：[实验性] 执行带有参数的PowerShell命令。不同于 `-Command`，这个参数会填充 `$args` 内置变量，允许命令访问这些参数。第一个字符串被视为命令，后续由空格分隔的字符串是参数。例如：
   ```pwsh -CommandWithArgs '$args| %{"arg:$_"}' arg1 arg2```
   此例会产生输出："arg: arg1" 和 "arg: arg2"

4. **-ConfigurationName (-config)**：指定运行PowerShell的配置端点，可以是本地计算机上注册的任意端点，包括默认PowerShell远程端点或具有特定用户角色功能的自定义端点。

5. **-ConfigurationFile**：指定一个会话配置文件（.pssc）的路径，配置文件中的设置将应用于PowerShell会话。

6. **-CustomPipeName**：用于调试和其他进程间通信的附加IPC服务器（命名管道）名称。在 PowerShell 6.2 版本引入，常与 `Enter-PSHostProcess` 命令一起使用，提供连接到其他 PowerShell 实例的可预测机制。

7. **-EncodedCommand (-e/-ec)**：接受命令的Base64编码版本，适用于需要复杂嵌套引用的命令提交。Base64表示必须是UTF-16编码的字符串。

8. **-ExecutionPolicy (-ex/-ep)**：为当前会话设置默认执行策略，并保存在 `$env:PSExecutionPolicyPreference` 环境变量中。此参数不影响持久配置的执行策略，只适用于Windows系统。

9. **-InputFormat (-inp/-if)**：描述发送至PowerShell的数据格式，有效值为 "Text"（文本字符串）或 "XML"（序列化CLIXML格式）。

10. **-Interactive (-i)**：向用户显示交互式提示，是非 `-NonInteractive` 参数的对立项。

11. **-Login (-l)**：在Linux和macOS上，以登录shell方式启动PowerShell，执行如 `/etc/profile` 和 `~/.profile` 这样的登录配置文件。在Windows上，此开关无效。注意在Linux和macOS上，若要作为登录shell启动，此参数必须位于第一位，否则会被忽略。

12. **-MTA**：此选项可能涉及线程模型，通常用于指定多线程 apartment (MTA)，在某些.NET应用中决定如何管理线程同步。不过具体在此处的作用并未详细说明。

### pwsh自带帮助文档原文

- 您可以使用`pwsh -h|out-host -paging`来分页阅读

- 也可以用`pwsh -h|scb`复制到剪切板,粘贴到word中来阅读,或者做后续的处理,比如笔记或着软件翻译

  ```powershell
  
  PS[BAT:77%][MEM:31.00% (9.83/31.70)GB][15:22:39]
  # [~\Desktop]
   pwsh -h|Out-Host -Paging
  
  Usage: pwsh[.exe] [-Login] [[-File] <filePath> [args]]
                    [-Command { - | <script-block> [-args <arg-array>]
                                  | <string> [<CommandParameters>] } ]
                    [-CommandWithArgs <string> [<CommandParameters>]
                    [-ConfigurationName <string>] [-ConfigurationFile <filePath>]
                    [-CustomPipeName <string>] [-EncodedCommand <Base64EncodedCommand>]
                    [-ExecutionPolicy <ExecutionPolicy>] [-InputFormat {Text | XML}]
                    [-Interactive] [-MTA] [-NoExit] [-NoLogo] [-NonInteractive] [-NoProfile]
                    [-NoProfileLoadTime] [-OutputFormat {Text | XML}]
                    [-SettingsFile <filePath>] [-SSHServerMode] [-STA]
                    [-Version] [-WindowStyle <style>]
                    [-WorkingDirectory <directoryPath>]
  
         pwsh[.exe] -h | -Help | -? | /?
  
  PowerShell Online Help https://aka.ms/powershell-docs
  
  All parameters are case-insensitive.
  
  -File | -f
  
      If the value of File is "-", the command text is read from standard input.
      Running "pwsh -File -" without redirected standard input starts a regular
      session. This is the same as not specifying the File parameter at all.
  
      This is the default parameter if no parameters are present but values are
      present in the command line. The specified script runs in the local scope
      ("dot-sourced"), so that the functions and variables that the script
      creates are available in the current session. Enter the script file path
      and any parameters. File must be the last parameter in the command, because
      all characters typed after the File parameter name are interpreted as the
      script file path followed by the script parameters.
  
      Typically, the switch parameters of a script are either included or
      omitted. For example, the following command uses the All parameter of the
      Get-Script.ps1 script file: "-File .\Get-Script.ps1 -All"
  
      In rare cases, you might need to provide a BOOLEAN value for a switch
      parameter. To provide a BOOLEAN value for a switch parameter in the value
  <SPACE> next page; <CR> next line; Q quit
      of the FILE parameter, Use the parameter normally followed immediately by a
  <SPACE> next page; <CR> next line; Q quit
  ```

  

## 应用

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

  