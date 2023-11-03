[toc]

# powershell@foreach@foreach-object@continue的行为

## ref

- [about Continue - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_continue?view=powershell-7.3)
- [powershell - Why does 'continue' behave like 'break' in a Foreach-Object? - Stack Overflow](https://stackoverflow.com/questions/7760013/why-does-continue-behave-like-break-in-a-foreach-object)

## foreach@foreach-object

- [about Foreach - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_foreach?view=powershell-7.3)
  - powershell/module/microsoft.powershell.core/about/about_foreach
  - 这是一个powershell 遍历可迭代对象的基本语法,属于循环(loop)中的一种
  - 不妨称它为`loop-foreach`
- [ForEach-Object (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/foreach-object?view=powershell-7.3)
  - powershell/module/microsoft.powershell.core/foreach-object
  - 这是一个powershell cmdlet(powershell命令),不是一种循环,可能是基于基本语法编制而成的功能性命令
  - 不妨称它为`cmdlet-foreach`
- 这一点区别将会在使用continue的时候显现出来
  - continue放在在某个Loop中时(比如foreach),那么它的行为就像c语言那样
  - 如果是放在foreach-object(有时候简写为foreach,区分loop-foreach),充当`scriptblock`
  - 这时候,会尝试跳过最近的loop语法层(如果存在的话)

- [What is a PowerShell command? - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/powershell-commands?view=powershell-7.3)

### What is a cmdlet?

- Cmdlets are **native PowerShell commands**, not stand-alone executables. 
- Cmdlets are collected into PowerShell modules that can be loaded on demand. 
- Cmdlets can be written in any compiled .NET language or in the PowerShell scripting language itself.

## break@continue

- [about Break - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_break?source=recommendations&view=powershell-7.3)
- [about Continue - PowerShell | Microsoft Learn](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_continue?view=powershell-7.3)

## 案例

### foreach@continue

#### loop-foreach

- ```powershell
  Write-Output 'foreach-loop'
  $l = 1..5
  foreach ($elem in $l)
  {
      if ($elem -eq 3)
      {
          continue;
          # not return here
      }
      Write-Output $elem
  }
  ```

#### cmdlet-foreach

- ```powershell
  Write-Output 'foreach-object(cmdlet)'
  1..5 | ForEach-Object {
      if ($_ -eq 3 )
      {
          return 
          #not continue here
      }
      Write-Output $_
  
  }
  ```

#### 运行结果

- ```bash
  foreach-loop
  1
  2
  4
  5
  foreach-object(cmdlet)
  1
  2
  4
  5
  ```

### 其他方案

- 加一层`if-else`可以在cmdlet中模拟`continue`的字面行为
  - 但是这增加了不必要的代码
  - 而且不够优雅
- 做过滤的时候`where-object`有时候比`foreach-object`更加合适

