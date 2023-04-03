[toc]

## refs

- [file - Editing shortcut (.lnk) properties with Powershell - Stack Overflow](https://stackoverflow.com/questions/484560/editing-shortcut-lnk-properties-with-powershell)

### powershell functions for manipulate shortcut files(.lnk@.url)

- 以下是一组经过精简的版本

  - 其中最主要的是`getShortcutInfo`和`setShortCut`

- ```powershell
  
  function createShortcut
  {
      <# 
      .SYNOPSIS
      创建一个快捷方式,该功能被集成到setShortcut,这里只是为了语义强调单独列出来 #>
      param( 
          $path = './demo.lnk',
          $TargetPathProp = "$home"
      )
      $Shell = New-Object -ComObject ('WScript.Shell')
      # New-Item $path
      # $path = (Resolve-Path $path)
      # Remove-Item $path
      Write-Output $path
      if (!($path -match '.*\.(lnk|url)$'))
      {
          return "🎈the extension of the $path must be url or lnk !"
      }
      $sct = $Shell.CreateShortcut($path)
      # $Favorite.TargetPath = 'http://www.yoururl.com';
      $sct.TargetPath = $TargetPathProp
      $sct.Save()
  }
  function getShortcutInfo
  {
      <# 获取已经存在的快捷方式lnk文件的信息 #>
      param(
          $path
      )
      $shell = New-Object -ComObject WScript.Shell
      if(Test-Path $path){
          $path = Resolve-Path $path #获取绝对路径(使用相对路径的话可能会受到当前路径或环境的影响)
      }elseif ($path -match "\./*") {
          
         $path=(Join-Path -Path (Get-Location).Path -ChildPath $path)
      }
      $shortcut = $shell.CreateShortcut($path)
      return $shortcut
  }
  function getShortcutInfoBasic
  {
      <# 
      .SYNOPSIS
      获取主要的信息(通常我们对快捷方式的跳转目录最感兴趣)
      主要应用于开始菜单中固定的常用程序的快捷方式,从中提取跳转的目标路径 #>
      param (
          $path
      )
      $res = (getShortcutInfo $path | Select-Object TargetPath)
      $targetPath = $res.targetPath
      $targetPath | Set-Clipboard
      # $targetPath
      Write-Output "$res`n🎈 the targetPath was set to clipboard!"
      #我将快捷方式的目标路径复制到剪切板中
  }
  function getShortcutTargetPath
  {
      <# 
      .SYNOPSIS
      获取主要的信息(通常我们对快捷方式的跳转目录最感兴趣)
      .EXAMPLE
      PS C:\ProgramData\Microsoft\Windows\Start Menu\Programs> getShortcutInfoBasic .\yyy.lnk|cd      
      PS D:\repos\CCSER> 
      #>
      param (
          $path
      )
      $res = (getShortcutInfo $path | Select-Object TargetPath)
      $targetPath = $res.targetPath
      $targetPath
  }
  function setShortcut
  {
      <# 
      .SYNOPSIS
      对已存在的快捷方式进行修改
      如果不存在相应快捷方式,则创建一个TODO #>
      param(
          $path,
          $TargetPathProperty,
          $Description = "edited by $env:username $(gdt)",
          $argumentsProp = '',
          $hotkeyProp = '',
          $WindowStyleProp = '',
          $IconLocation = ''
      )
      $shortcut = getShortcutInfo($path)
      $shortcut.TargetPath = $TargetPathProperty
      $shortcut.Description = $Description
      #处理次要属性
      if ($hotkeyProp)
      {
          $shortcut.HotKey = $hotkeyProp
      }
      if ($argumentsProp)
      {
          $shortcut.Arguments = $argumentsProp
      }
      if ($WindowStyleProp)
      {
          $shortcut.WindowStyle = $WindowStyleProp
      }
      if ($IconLocationProp)
      {
          $shortcut.IconLocation = $IconLocationProp
      }
      
      # save changes
      $shortcut.Save()
      getShortcutInfoBasic -path $path
  }
  
  
  ```

### 目录解析

- 从给定的快捷方式解析出绑定的目标位置目录(具有鲁棒性)

- 根据解析指定的快捷方式,如果该快捷方式是一个目录则直接返回该目录
  否则该快捷方式是指向一个文件,那么会被解析成目标文件所在的目录

- 

  ```powershell
  
  function getShortcutTargetDir
  {
      <# 
  .SYNOPSIS
  根据解析指定的快捷方式,如果该快捷方式是一个目录则直接返回该目录
  否则该快捷方式是指向一个文件,那么会被解析成目标文件所在的目录
  .EXAMPLE
  PS C:\ProgramData\Microsoft\Windows\Start Menu\Programs> getShortcutTargetDir '.\Word.lnk' |cd
  PS C:\Program Files\Microsoft Office\root\Office16> getShortcutTargetDir C:\Users\cxxu\desktop\test.lnk |cd
  PS D:\repos>
      #>
      param (
          $path
      )
      $target = (getShortcutTargetPath $path)
  
      #slow method:
      # $targetType = (Get-Item $target)
      # if ($targetType -is [System.IO.fileInfo])
      # {
      #     return $targetType.DirectoryName 
      # }
  
      #faster method:
      if ( [System.IO.File]::Exists($target))
      {
          $targetFileInfo = [System.IO.FileInfo]$target
          return $targetFileInfo.DirectoryName 
      }
      #  | ForEach-Object { $_.DirectoryName }#ok,too
      return $target
  
  }
  ```

  

### 例

- 
  
  ```bash
  #获取某个快捷方式的信息
  PS C:\ProgramData\Microsoft\Windows\Start Menu\Programs> getshortcutInfo .\yyy.lnk
  
  FullName         : C:\ProgramData\Microsoft\Windows\Start Menu\Programs\yyy.lnk
  Arguments        : 
  Description      : edited by cxxu 03/01/2023 10:21:48
  Hotkey           : Alt+9
  IconLocation     : ,0
  RelativePath     : 
  TargetPath       : D:\repos\CCSER
  WindowStyle      : 1
  WorkingDirectory : 
  
  # 修改描述为kkk
  PS C:\ProgramData\Microsoft\Windows\Start Menu\Programs> setShortcut -path ./yyy.lnk -TargetPathProp D:\repos\CCSER\ -Description "kkk"
  @{TargetPath=D:\repos\CCSER}
  🎈 the targetPath was set to clipboard!
  PS C:\ProgramData\Microsoft\Windows\Start Menu\Programs> getshortcutInfo .\yyy.lnk
  
  FullName         : C:\ProgramData\Microsoft\Windows\Start Menu\Programs\yyy.lnk
  Arguments        : 
  Description      : kkk
  Hotkey           : Alt+9
  IconLocation     : ,0
  RelativePath     : 
  TargetPath       : D:\repos\CCSER
  WindowStyle      : 1
  WorkingDirectory : 
  
  #设置当前目录下的一个名为`yyy.lnk`的快捷方式
  PS C:\ProgramData\Microsoft\Windows\Start Menu\Programs> setShortcut -path ./yyy.lnk -TargetPathProp D:\repos\CCSER\ 
  @{TargetPath=D:\repos\CCSER}
  🎈 the targetPath was set to clipboard!
  #
  PS C:\ProgramData\Microsoft\Windows\Start Menu\Programs> getshortcutInfo .\yyy.lnk
  
  FullName         : C:\ProgramData\Microsoft\Windows\Start Menu\Programs\yyy.lnk
  Arguments        : 
  Description      : edited by cxxu 03/01/2023 10:23:25
  Hotkey           : Alt+9
  IconLocation     : ,0
  RelativePath     : 
  TargetPath       : D:\repos\CCSER
  WindowStyle      : 1
  WorkingDirectory : 
  
  
  PS C:\ProgramData\Microsoft\Windows\Start Menu\Programs>
  ```

### 例

- 用命令行跳转到快捷方式指定的目录:

  - ```powershell
    PS C:\ProgramData\Microsoft\Windows\Start Menu\Programs> getShortcutTargetPath .\new.lnk|cd
    
    PS D:\repos\CCSER> 
    
    ```

    