[toc]



## powershell操作环境变量

- 所作修改长期有效,重启仍然有效
- 关于查看环境变量,[另见它文](https://blog.csdn.net/xuchaoxin1375/article/details/121435951)

### 安全声明

- 环境变量是重要的,因此操作前建议备份环境变量
- 详情另见它文

### 范围说明

- 以下函数支持用户级别和系统级别的更改
- 默认更改用户级别,系统级别的更改需要以管理员方式运行shell才行
- 总的来说,这些函数调用简单有效,能够自动更新当前powershell中的环境变量

## 相关powershell函数

### 移除多余的分号

- ```powershell
  
  function Remove-RedundantSemicolon
  {
      <# 
      .SYNOPSIS
      #清理可能多余的分号
  
      #>
      param (
          $String
      )
      $String = $String -replace '(;+)\s*;', '$1'
  
      return $String.trim(';')
  }
  ```

  

### 增加环境变量或增加已有环境变量值

- ```powershell
  
  function Add-EnvVar
  {
      <# 
  .SYNOPSIS
  添加环境变量(包括创建新变量及其取值,为已有变量添加取值),并且立即更新所作的更改
  这里我们利用$expression | Invoke-Expression等方法来手动立即更新当前powershell上下文的环境变量,实现不需要重启更新环境变量
  虽然本函数能够刷新当前powershell上下文的环境变量,但是其他shell进程却不会跟着刷新,可以手动调用Update-EnvVarFromSysEnv来更新当前shell的环境变量
  
  当对一个已经存在变量添加值时,会在头部插入新值;(有些时候末尾会带有分号,导致查询出来的值可能存在2个来连续的分号)
  这时候可以判断移除最后一个分号,然后再添加新值,头插方式也行
  .EXAMPLE
  PS BAT [10:58:25 PM] [C:\Users\cxxu\Desktop]
  [🔋 100%] MEM:72.79% [5.71/xx] GB |add-envVar -EnvVar new2 -NewValue v2
  v2
  .EXAMPLE
  PS BAT [10:58:33 PM] [C:\Users\cxxu\Desktop]
  [🔋 100%] MEM:72.74% [5.71/xx] GB |add-envVar -EnvVar new2 -NewValue v3 -V
  $env:new2 = 'v2;v3'
  v2;v3
  .EXAMPLE
  以管理员权限运行powershell,可以配置系统级别的环境变量
  PS BAT [11:16:24 PM] [C:\Users\cxxu\Desktop]
  [🔋 100%] MEM:73.80% [5.79/xx] GB |add-envVar -EnvVar new -NewValue v1 -Scope Machine
  v1
  .EXAMPLE
  PS>(Get-EnvVar -Key Path -Scope U|select -ExpandProperty value) -split ';'
  C:\Program Files\PowerShell\7
  C:\Users\cxxu\scoop\shims
  C:\Users\cxxu\AppData\Local\Programs\oh-my-posh\bin
  C:\Users\cxxu\.dotnet\tools
  
  PS>Add-EnvVar -EnvVar Path -Scope User -NewValue NewValueDemo
  NewValueDemo;C:\Program Files\PowerShell\7;C:\Users\cxxu\scoop\shims;C:\Users\cxxu\AppData\Local\Programs\oh-my-posh\bin;C:\Users\cxxu\.dotnet\tools;
  PS>(Get-EnvVar -Key Path -Scope U|select -ExpandProperty value) -split ';'
  NewValueDemo
  C:\Program Files\PowerShell\7
  C:\Users\cxxu\scoop\shims
  C:\Users\cxxu\AppData\Local\Programs\oh-my-posh\bin
  C:\Users\cxxu\.dotnet\tools
  
  #>
      param (
          
          $EnvVar = 'new',
          $NewValue = 'demo_new',
  
          # choose User or Machine,the former is default(no need for Administrator priviledge)
          # the Machine scope need Administrator priviledge
          [ValidateSet('Machine', 'User')]
          $Scope = 'User',
  
          [Alias('V')][switch]$Verbose,
          [switch]$Query = $false
      )
      # 同步环境变量
      Update-EnvVarFromSysEnv -Scope $Scope
      # 先获取当前用户或机器级别的环境变量值
      $CurrentValue = [Environment]::GetEnvironmentVariable($EnvVar, $Scope)
  
      #查询当前值,能够区分不同Scope的环境变量(例如用户变量和系统变量都有Path,如果只想插入一个新值到用户Path,就要用上述方法访问)
   
      # $CurrentValue = "`$env:$EnvVar" | Invoke-Expression #无法区分用户和系统的path变量
  
      # 添加新路径到现有 Path
      #$CurrentValue如果没有提前设置值,则返回null,而不是'',不能用$CurrentValue -ne '' 判断是否新变量,直接用$CurrentValue 即可
      $NewValueFull = $CurrentValue  ? "$NewValue;$CurrentValue" : $NewValue 
      # Write-Output $NewValue
      
      # 查看即将进行的更改,如果启用了$V或$Query,则会打印出更改的表达式,如果是后者还会进一步询问
      if ($V -or $Query)
      {
  
          # Write-Host "`$env:$EnvVar From [$CurrentValue] TO [$NewValue]" -BackgroundColor green
          $Log = [PSCustomObject]@{
              EnvVar = $EnvVar;
              From   = $CurrentValue -split ';' | Out-String;
              To     = $NewValueFull -split ';' | Out-String
          } 
          #理论上可以不用Out-String,但是个别场景(比如后续的Read-Host)会导致输出顺序错乱,所以这里用Out-String强制渲染
          if ($EnvVar -eq 'Path')
          {
              $Log | Format-List 
          }
          else
          {
              $Log | Format-Table -Wrap -AutoSize | Out-String #| Write-Host -ForegroundColor Green
          }
          
          
      }
      if ($Query)
      {
          
          $replay = Read-Host -Prompt 'Enter y to continue,else exit '
          if ($replay -ne 'y')
          {
              return
          }
      }
      # 设置 Scope 级别的 Path 环境变量
      $NewValueFull = Remove-RedundantSemicolon $NewValueFull
      [Environment]::SetEnvironmentVariable($EnvVar, $NewValueFull, $Scope)
  
      # 刷新当前shell的环境变量
      $env_left = "`$env:$EnvVar"
      $NewValueRefresh = $NewValueFull
      #检查,要对path特殊处理
      if ($EnvVar -eq 'Path')
      {
          $CurrentValue = $env:Path  
          # $env:Path -split ';' |Write-Host -ForegroundColor Blue
          $NewValueRefresh = Remove-RedundantSemicolon "$NewValue;$CurrentValue"
      }
      $expression = "$env_left = '$NewValueRefresh'" 
      $expression | Invoke-Expression
      # return $NewValue
      Write-Host "$($env_left):`n$($NewValueFull -split ';' | Out-String)" -BackgroundColor Yellow
  
  }
  ```

### 其他

- 更多相关函数和模块参考仓库:
  - [scripts: 辅助脚本|powershell EnvVar - Gitee.com](https://gitee.com/xuchaoxin1375/scripts/tree/main/modulesByCxxu/EnvVar)

## 环境变量名字太长删不掉

- 部分情况可能将环境变量值作为环境变量名设置成了系统环境变量,可能造成删不掉的局面
  - 例如,`C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Scoop Apps`本来是个path值,但是操作失误设置为了变量名
- 可以借助powertoys的环境变量功能来删除!
- 或者从注册表中相关表项删除它
