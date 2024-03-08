[toc]



## powershell操作环境变量

- 所作修改长期有效,重启仍然有效
- 关于查看环境变量,[另见它文](https://blog.csdn.net/xuchaoxin1375/article/details/121435951)

### 范围说明

- 以下函数支持用户级别和系统级别的更改
- 默认更改用户级别,系统级别的更改需要以管理员方式运行shell才行
- 总的来说,这些函数调用简单有效,能够自动更新当前powershell中的环境变量

### 更新环境变量

- ```powershell
  
  function Update-EnvVar
  {
      <# 
      .SYNOPSIS
      更新所有环境变量的修改(包括添加新值/移除已有值/修改值),并且会指出那些环境变量被修改了以及修改前后是什么样的
      鉴于Path变量的特殊性,本函数不会处理Path变量
      Update-EnvVar本身不会修改[Environment]中的环境变量,即不会影响系统保存的环境变量,无论是用户级还是系统,只更新当前shell中的环境变量
      对于多个shell窗口同时发生修改环境变量的情形时很有用,当然如果您习惯用GUI修改环境变量,本方法也可以将您的修改同步到当前shell(除了Path变量外)
  
  
      通常调用Set-EnvVar 或Add-EnvVar 更改var环境变量时,会自动更新当前shell的var环境变量($env:var查询到的值)
      但是如果在多个不同的shell窗口内分别调用了Set-EnvVar或Add-EnvVar，那么可能会造成变量信息的不一致
      为了避免这种情况，可以调用此函数更新所有shell的环境变量
      注意本函数以[Environment]对象中存储的环境变量信息为准,如果当前shell的环境变量不同于[Environment]中查询到的那样,则会更新为[Environment]中查询到的值
  
      如果当前shell有不存在于[Environment]中的环境变量,则认为是改shell环境的临时环境变量,调用本函数并不会更改或影响到这些变量
      这些情况是存在的,有些场合下我们只需要创建临时的环境变量而不需要写入系统保存
  
      默认读取的是User级别的环境变量
      .#>
      param(
  
          $Scope = 'User'
      )
      $envs = [System.Environment]::GetEnvironmentVariables($Scope)
      $envs.GetEnumerator() | Where-Object { $_.Key -ne 'Path' } | ForEach-Object {
          # Write-Output "$($_.Name)=$($_.Value)"
          $env_left = "`$env:$($_.Name)"
          $expressoin = "$env_left='$($_.Value)'"
          $current_value = $env_left | Invoke-Expression
          if ($current_value -ne $_.Value)
          {
              Write-Host "$env_left from [$(Invoke-Expression($env_left))] `t to `t [$($_.Value)]" -BackgroundColor Magenta
              $expressoin | Invoke-Expression
          }
      }
  }
  ```

  

### 添加环境变量

- ```powershell
  
  function Add-EnvVar
  {
      <# 
  .SYNOPSIS
  添加环境变量(包括创建新变量及其取值,为已有变量添加取值),并且立即更新所作的更改
  这里我们利用$expression | Invoke-Expression等方法来手动立即更新当前powershell上下文的环境变量,实现不需要重启更新环境变量
  👺为了确保一致性,且无在不同的powershell窗口分别使用本函数,否则会造成修改覆盖造成修改丢失
  虽然本函数能够刷新当前powershell上下文的环境变量，但是其他shell进程却不会跟着刷新
  
  当对一个已经存在变量添加值时,会在头部插入新值;(有些时候末尾会带有分号,导致查询出来的值可能存在2个来连续的分号)
  这时候可以判断移除最后一个分号，然后再添加新值,头插方式也行
  .EXAMPLE
  PS BAT [10:58:25 PM] [C:\Users\cxxu\Desktop]
  [🔋 100%] MEM:72.79% [5.71/7.85] GB |add-envVar -env_var new2 -new_value v2
  v2
  .EXAMPLE
  PS BAT [10:58:33 PM] [C:\Users\cxxu\Desktop]
  [🔋 100%] MEM:72.74% [5.71/7.85] GB |add-envVar -env_var new2 -new_value v3 -V
  $env:new2 = 'v2;v3'
  v2;v3
  .EXAMPLE
  以管理员权限运行powershell,可以配置系统级别的环境变量
  PS BAT [11:16:24 PM] [C:\Users\cxxu\Desktop]
  [🔋 100%] MEM:73.80% [5.79/7.85] GB |add-envVar -env_var new -new_value v1 -Scope Machine
  v1
  .EXAMPLE
  PS>(Get-EnvVar -Key Path -Scope U|select -ExpandProperty value) -split ';'
  C:\Program Files\PowerShell\7
  C:\Users\cxxu\scoop\shims
  C:\Users\cxxu\AppData\Local\Programs\oh-my-posh\bin
  C:\Users\cxxu\.dotnet\tools
  
  PS>Add-EnvVar -env_var Path -Scope User -new_value NewValueDemo
  NewValueDemo;C:\Program Files\PowerShell\7;C:\Users\cxxu\scoop\shims;C:\Users\cxxu\AppData\Local\Programs\oh-my-posh\bin;C:\Users\cxxu\.dotnet\tools;
  PS>(Get-EnvVar -Key Path -Scope U|select -ExpandProperty value) -split ';'
  NewValueDemo
  C:\Program Files\PowerShell\7
  C:\Users\cxxu\scoop\shims
  C:\Users\cxxu\AppData\Local\Programs\oh-my-posh\bin
  C:\Users\cxxu\.dotnet\tools
  
  #>
      param (
          
          $env_var = 'new',
          $new_value = 'demo_new',
          # choose User or Machine,the former is default(no need for Administrator priviledge)
          # the Machine scope need Administrator priviledge
          [ValidateSet('Machine', 'User')]
          $Scope = 'User',
          [switch]$V,
          [switch]$Query
      )
      # 同步环境变量
      Update-EnvVar -Scope $Scope
      # 先获取当前用户或机器级别的 环境变量 值
      $current_value = [Environment]::GetEnvironmentVariable($env_var, $Scope)
      #查询当前值,能够区分不同Scope的环境变量(例如用户变量和系统变量都有Path,如果只想插入一个新值到用户Path,就要用上述方法访问)
      
  
      # $current_value = "`$env:$env_var" | Invoke-Expression #无法区分用户和系统的path变量
  
      # 添加新路径到现有 Path
      #$current_value如果没有提前设置值,则返回null,而不是'',不能用$current_value -ne '' 判断是否新变量,直接用$current_value 即可
      $new_value = $current_value  ? "$new_value;$current_value" : $new_value 
      # Write-Output $new_value
      
      
      # 清除当前会话的 Path 缓存变量
      # '$env:' + "$env_var" + '="new_value"' |iex
      # Write-Output
      $env_left = "`$env:$env_var"
      $expression = "$env_left = '$new_value'" 
      if ($V -or $Query)
      {
          Write-Host $expression -BackgroundColor green
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
      [Environment]::SetEnvironmentVariable($env_var, $new_value, $Scope)
      # 刷新当前shell的环境变量
      $expression | Invoke-Expression
      # return $new_value
      Write-Host "$($env_left)=$new_value" -BackgroundColor Yellow
  
  }
  
  ```
  
  

### 移除指定的环境变量

- ```powershell
  
  function Remove-EnvVar
  {
      <# 
      .SYNOPSIS
      移除环境变量
      .EXAMPLE
      批量移除(借助Get-EnvVar 和管道符可以先做模糊匹配,然后通过foreach(%)循环删除,即便本函数暂不支持直接接受管道符输入):    
      Get-EnvVar new*|select name|%{Remove-EnvVar -env_var $_.Name}
  
      #>
      param (
          
          $env_var = '',
          
          # choose User or Machine,the former is default(no need for Administrator priviledge)
          # the Machine scope need Administrator priviledge
          [ValidateSet('Machine', 'User')]
          $Scope = 'User'
      )
      $current_value = "`$env:$env_var" | Invoke-Expression 
      #虽然也可以考虑用Get-EnvVar -key $env_var|select value 查询当前值,但这不一定都是已经生效的值
      # 添加新路径到现有 Path
      #$current_value如果没有提前设置值,则返回null,而不是'',不能用$current_value -ne '' 判断是否新变量,直接用$current_value 即可
      $new_value = $current_value  ? "$current_value;$new_value" : $new_value 
      # Write-Output $new_value
      
      # $expression = "`$env:$env_var = '$new_value'" 
      #当前shell上下文中移掉该环境变量
      if ("`$env:$env_var" | Invoke-Expression)
      {
          # 设置 Scope 级别的 Path 环境$env_var变量为空,从而清除该环境变量(.Net检测到空字符串就移除掉该变量,而不仅仅设置为空字符串)
          [Environment]::SetEnvironmentVariable($env_var, '', $Scope)
          Remove-Item env:$env_var
      }
      else
      {
          Write-Host "No [$env_var] was found! Nothing to Remove."
      }
  
  }
  
  ```

### 修改环境变量

- 组合调用上述两个函数即可

  - ```powershell
    
    function Set-EnvVar
    {
        <# 
        .SYNOPSIS
        将已有的环境变量值做修改(增/改/删)
        如果只希望对已有的环境变量添加一个值,例如Path变量追加一个取值,则使用Add-EnvVar处理
        如果想要编辑多个值的变量,例如修改Path变量(删除它的一个路径值),这类情况建议打开gui操作
        当然本命令也是可以改的,在终端中处理字符串却不会比GUI容易执行这类修改
    
    
        .EXAMPLE
        #将new3这个环境变量设置为v3p,无论原来的值是多少(如果原来没有这个环境变量,则新添加一个环境变量)
        Set-EnvVar -env_var new3 -new_value v3p
        .EXAMPLE
        PS>Set-EnvVar -env_var new3 -new_value v3R
        v3R
        PS>$env:new3
        v3R
        PS>Set-EnvVar -env_var new3 -new_value v3S
        v3S
        PS>$env:new3
        v3S
        .EXAMPLE
        PS>$env:new100
        PS>Set-EnvVar -env_var new100 -new_value v100
        v100
        PS>$env:new100
        v100
        .EXAMPLE
        #移除环境变量
        PS>Set-EnvVar -env_var new100 -new_value ''
        PS>$env:new100
        PS>
        #>
        param (                                
            $env_var = '',
            $new_value = 'new_value',
            $Scope = 'User'
        )
        #移除旧值(如果旧值非空的话)
        Remove-EnvVar -env_var $env_var -Scope $Scope
        #添加新值
        Add-EnvVar -env_var $env_var -new_value $new_value -Scope $Scope
    }
    
    ```

  

  