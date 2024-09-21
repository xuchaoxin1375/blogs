[toc]



## vscode codeium手动下载服务器

- [Release language-server- · Exafunction/codeium (github.com)ll](https://github.com/Exafunction/codeium/releases)

首先打开vscode,当codeium需要下载server时会看到右下角的提示,一般情况下下载很慢,而且经常会因为超时而导致下载失败

这里提供了一个脚本用来解决超时下载失败的问题(如果您codeium插件目录下一点都没有下载下来,那么脚本可能有无能为力)

### 使用要求

- 这里github release 加速镜像链接,并用aria2下载;并且用7z进行解压
  - 所以您的计算机必须安装aria2和7z才能够有正常运行下面脚本的基础(其中aria2可以用其他命令行下载代替,比如powershell自带的`invoke-webrequest`,但是速度往往是不理想的
  - 此外aria2(或者说`aria2c`,我为其取了别名为`aria2`)和7z需要配置进Path变量,才可以直接调用
- 如果您愿意手动下载,并执行文件目录移动等操作也是可以的,只是没有一键运行的便利

### codeium extension for vscode 下载安装脚本(powershell)👺

- 这依赖于提供的加速下载辅助函数,先运行辅助函数,再运行以下脚本

  - 可以直接复制粘贴到powershell中(包含一个函数定义和一个调用命令语句)

- 加速说明

  - 虽然这里使用镜像加速,并且调用了aria2c下载,但是任然可能遇到速度受限的情况
  - 您可以考虑更改加速连接的获取模式,或者考虑获取链接后调用IDM这类更高速的下载器进行下载
  - 手动下载的包请移动到桌面(不容易发生歧义,也最直观的位置)然后,确保名字为`language_server_windows_x64.exe.gz`
  - 然后重新执行以下`Update-CodeiumVScodeExtension`函数调用语句

- ```powershell
  function Update-CodeiumVScodeExtension
  {
      param(
          [ValidateSet('aria2c', 'default')]$Downloader = 'aria2c'
      )
      <# 
      .SYNOPSIS
      加速下载并更新vscode中codeium插件
      当打开vscode时codeium自动更新下载了一些内容后下不动了,或者太慢了,就可以关闭vscode,然后执行本函数
  
      #>
  
      $vscodeExtensions = '~\.vscode\extensions'
      $codeiumExtensionPath = (Resolve-Path "$vscodeExtensions\codeium*")
      #ls $vscodeExtensions\codeium*
      $lastVersionItem = Resolve-Path $codeiumExtensionPath | Sort-Object -Property Name |sort -Descending | Select-Object -First 1
  
      $Name = $lastVersionItem | Select-Object -ExpandProperty Path
      $v = $Name | Set-Clipboard -PassThru #打印最新版本并且复制版本号到剪切板,形如 `codeium.codeium-1.8.40`
      $versionNumber = ("$v" -split '-')[1] #版本好字符串,形如1.8.40
      Write-Host $versionNumber -background Magenta
  
      $release_page_uri = "https://github.com/Exafunction/codeium/releases/tag/language-server-v$versionNumber"
      $uri = "https://github.com/Exafunction/codeium/releases/download/language-server-v$versionNumber/language_server_windows_x64.exe.gz"
  
      $speedUri = Get-SpeedUpUri $uri
      Write-Host $speedUri -BackgroundColor Blue
      #invoke-webrequest $speedUri
      $desktop = "$env:userprofile\desktop"
      $fileName = 'language_server_windows_x64.exe.gz'
      $f = "$desktop\$fileName"
      if ( -not (Test-Path $f))
      { 
          switch ($Downloader)
          {
              'aria2c'
              { 
  
                  aria2c $speedUri -d $desktop -o $fileName;break
              }
              'default'{
  
                  Invoke-WebRequest -Uri $speedUri -OutFile $f;break
              }
              Default {
                  
              }
          }
      }
  
      #$serverDir="$desktop\codeium_lsw"
      $serverDir = Resolve-Path "$lastVersionItem\dist\*"
      $serverDir = Get-ChildItem "$lastVersionItem\dist\*" -Directory | Where-Object { $_.Name.Length -ge 20 }
      7z x $f -o"$serverDir"
  
      #清理文件
      Remove-Item $f -Verbose 
      Remove-Item "$serverDir/*.download"
  
  }
  
  ```




- [Release language-server · Exafunction/codeium (github.com)](https://github.com/Exafunction/codeium/releases/tag/language-server-v1.8.37)

### 说明

- 方法可能会失效,比如提供服务器的仓库不在工作,或者codeium 插件改变了结构目录组织