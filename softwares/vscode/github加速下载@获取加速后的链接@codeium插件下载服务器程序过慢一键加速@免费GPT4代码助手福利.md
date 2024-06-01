[toc]



## github加速下载辅助函数(powershell)👺

获取github资源的加速链接文件/仓库加速

```powershell
function Get-SpeedupUri{

    <#
    .SYNOPSIS
    链接修改(包括拼接和替换加速域名)
    如果是其他替换域名的方式,可以修改实现代码,这里隐藏获取链接的方式

    .DESCRIPTION

    比如,可以用于github资源下载加速,通过在源链接前面追加加速镜像链接来提高下载速度
    .EXAMPLE
    获取加速修改后的链接(默认为追加头域名)
    PS C:\> Get-SpeedUpUri -Uri https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0-win-64bit-build1.zip
    https://hub.fgit.cf/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0-win-64bit-build1.zip
    另一种方式
    PS C:\> Get-SpeedUpUri -Uri https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0-win-64bit-build1.zip -Option InsteadOf
    https://hub.fgit.cf/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0-win-64bit-build1.zip
    .EXAMPLE
    加速下载github release
    PS C:\Users\cxxu\Desktop> $link=Get-SpeedUpUri https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0-win-64bit-build1.zip

    PS C:\Users\cxxu\Desktop> Invoke-WebRequest -Uri $link

    StatusCode        : 200
    StatusDescription : OK

    #>
    param (
        # 被加速的链接,比如github release 的链接,或githubusercontent的链接;至于能不能 够加速需要看源是否支持,比较好的源都支持
        $Uri,
        # 源可能会失效,默认的源可能会失效,可以找找新的源
        $Prefix = 'https://mirror.ghproxy.com/',

        # 其他通过替换域名的方式加速
        $OriginDomain = 'github.com',
        #替换成加速域名(可能会失效,需要到fastgit更新一下域名)
        $InsteadOf = 'hub.fgit.cf',

        [validateSet('Prefix', 'InsteadOf')]$Option = 'Prefix',
        [switch]$NotToClipboard


    )

    switch ($Option)
    {
        'Prefix' { $uri = $prefix + $Uri }
        'InsteadOf' { $uri = $Uri -replace $OriginDomain, $InsteadOf }
        Default {}
    }
    # Write-Host $uri -ForegroundColor Blue
    if (! $NotToClipboard)
    {
        $uri | Set-Clipboard
    }
    return  $uri
}
```

### 使用专业下载器

- 即使加速镜像返回的链接比原链接要快,但是想要更好的下载速度还需要一款多线程下载工具
- 您可以用得到的链接使用专业的下载工具下载,例如IDM等,或者跨平台的其他下载器,当然更方便的是使用aria2(c)下载

### 克隆加速

- 克隆github仓库的加速资源有很多,比如使用cgit克隆
- [cgit: cgit是一个github快速下载器，使用国内镜像，clone速度可达10M/s。 (gitee.com)](https://gitee.com/killf/cgit)
- [网达极客社区 (gitclone.com)](https://www.gitclone.com/)
  - [Speed up github - 网达极客社区 (gitclone.com)](https://www.gitclone.com/docs/howto/howto_github)

- 使用gitee,gitcode等托管站导入github加速代码仓库(但是release等文件不容易下载)

### 综合加速

- [GitHub 文件加速 - Moeyy](https://moeyy.cn/gh-proxy)

- [FastGitORG/document: 📄 FastGit Document (github.com)](https://github.com/fastgitorg/document)
  - [Fastgit | FastGit UK Document](https://doc.fastgit.org/zh-cn/guide.html)
  - 经常变动域名,可以搜索fastgit后查看文档说明

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
      $lastVersionItem = Resolve-Path $codeiumExtensionPath | Sort-Object -Property Name -Descending | Select-Object -First 1
  
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