[toc]

## abstract

- 利用powershell `select-string`扫描包含特定字符串的文件

### 素材

- ```powershell
  PS 🕰️1:37:04 AM [C:\repos\scripts\testDir] 🔋100%→ls -R -file |foreach{write "File:$_";cat $_;write "`n"}
  File:C:\repos\scripts\testDir\demo.ps1
  
  
  File:C:\repos\scripts\testDir\f1
  text2
  text3
  text abc
  
  
  File:C:\repos\scripts\testDir\f2
  !text abc
  
  
  File:C:\repos\scripts\testDir\f3
  xt abc
  
  
  File:C:\repos\scripts\testDir\dir_test\f4
  text x abc
  
  ```

### 扫描指定目录下所有包含特定内容的文件

- ```powershell
  function search_contents
  {
      param(
          #选择需要扫描的目录路径,默认为当前路径
          $path = '.',
          $content_pattern = 'text',
          $file_pattern = '*',
          #使用groupby进行分组(每个文件在匹配到的所有行及其行数统计,所有存在被匹配行的文件总数统计),并将分组结果输出为表格,支持进一步排序
          [switch]$TableViewGroup
      )
      $res = Get-ChildItem -Path $path -R -File -FollowSymlink $file_pattern | Select-String -Pattern $content_pattern
      $sum = $($res | Group-Object -Property Filename).Count
      if ($TableViewGroup)
      {
          $res = $res | Select-Object Filename, LineNumber, Line | Group-Object -Property Filename 
          $res = $res | Format-Table -AutoSize
      }
      Write-Output $res
      Write-Host args: -ForegroundColor DarkMagenta -BackgroundColor Cyan
      $params = "
          path = $path,
          content_pattern = $content_pattern,
          file_pattern = $file_pattern,
          TableViewGroup=$TableViewGroup"
      Write-Host $params -ForegroundColor Yellow
  
      Write-Host "Total files matched pattern_contents:$sum" -ForegroundColor 'Blue' #-BackgroundColor Yellow
  
      <# 
      .SYNOPSIS
      扫描指定目录下所有包含特定内容的文件，输出文件名，行号，行内容
      支持切换为分组显示,并将分组结果输出为表格
      
      .EXAMPLE
      PS 🕰️1:24:27 AM [C:\repos\scripts\testDir] 🔋100%→search_contents  -content_pattern tex
  
      f1:1:text2
      f1:2:text3
      f1:3:text abc
      f2:1:!text abc
      dir_test\f4:1:text x abc
      args:
  
              path = .,
              content_pattern = tex,
              file_pattern = *,
              TableViewGroup=False
      Total files matched pattern_contents:4
      .EXAMPLE
      PS 🕰️1:24:29 AM [C:\repos\scripts\testDir] 🔋100%→search_contents  -content_pattern tex -TableViewGroup
  
      Count Name     Group
      ----- ----     -----
          3 f1       {@{Filename=f1; LineNumber=1; Line=text2}, @{Filename=f1; LineNumber=2; Line=text3}, @{Filename=f1; Lin…
          1 f2       {@{Filename=f2; LineNumber=1; Line=!text abc}}
          1 f4       {@{Filename=f4; LineNumber=1; Line=text x abc}}
  
      args:
  
              path = .,
              content_pattern = tex,
              file_pattern = *,
              TableViewGroup=True
      Total files matched pattern_contents:4
      #>
      
  }
  
  ```

  



