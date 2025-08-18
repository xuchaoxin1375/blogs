[toc]

## abstract



### write-*系列cmdlet命令

```powershell
PS> gcm write-* |?{$_.Source -like 'Microsoft*'}|select Name,CommandType

Name              CommandType
----              -----------
Write-Debug            Cmdlet
Write-Error            Cmdlet
Write-Host             Cmdlet
Write-Information      Cmdlet
Write-Output           Cmdlet
Write-Progress         Cmdlet
Write-Verbose          Cmdlet
Write-Warning          Cmdlet
```

这些是 PowerShell 中用于输出不同类型信息的cmdlet。

## 基础信息

1. Write-Debug:
   - 用于输出调试信息
   - 只有在启用调试模式($DebugPreference = "Continue")时才会显示
   - 输出带有"DEBUG:"前缀的黄色文本

2. Write-Error:
   - 用于报告错误
   - 将错误信息写入错误流（stderr）
   - 默认显示红色文本

3. Write-Host:
   - 直接将输出写入控制台
   - 可以设置文本颜色和背景颜色
   - 输出不会传递到管道或重定向到文件

4. Write-Information:
   - 用于输出脚本的常规信息
   - 可以被重定向到特定的信息流
   - 在 PowerShell 5.0 及以上版本可用

5. Write-Output:
   - 将对象发送到管道的下一个命令
   - 如果是管道中的最后一个命令，则输出到控制台
   - 输出可以被重定向到文件

6. Write-Progress:
   - 在 PowerShell 命令窗口中显示进度栏
   - 用于长时间运行的操作，显示完成百分比
   - 不影响命令输出

7. Write-Verbose:
   - 用于输出详细信息
   - 只有在启用详细模式($VerbosePreference = "Continue")时才会显示
   - 输出带有"VERBOSE:"前缀的黄色文本

8. Write-Warning:
   - 用于输出警告信息
   - 默认显示黄色文本
   - 输出带有"WARNING:"前缀

### 对比总结：

1. 输出目的：
   - 调试信息：Write-Debug
   - 错误信息：Write-Error
   - 常规信息：Write-Host, Write-Information, Write-Output
   - 进度信息：Write-Progress
   - 详细信息：Write-Verbose
   - 警告信息：Write-Warning

2. 输出流：
   - 标准输出：Write-Output
   - 错误流：Write-Error
   - 信息流：Write-Information
   - 直接到控制台：Write-Host

3. 管道行为：
   - 可以传递到管道：Write-Output
   - 不传递到管道：Write-Host, Write-Error, Write-Debug, Write-Verbose, Write-Warning, Write-Information, Write-Progress

4. 颜色编码：
   - 红色：Write-Error
   - 黄色：Write-Debug, Write-Verbose, Write-Warning
   - 可自定义：Write-Host

5. 条件显示：
   - 需要特定设置：`Write-Debug ($DebugPreference), Write-Verbose ($VerbosePreference)`
   - 始终显示：Write-Host, Write-Error, Write-Warning, Write-Output

6. 特殊用途：
   - 进度显示：Write-Progress
   - 信息流控制：Write-Information

## powershell耗时任务的进度展示或者中间过程查看

有些耗时任务会有返回值,如果要取得返回值,并且同事查看处理过程的进度或者报告,会需要额外的工作

例如,我要扫描并换一批wordpress网站的插件,假设这些网站存放在`C:\sites\wp_sites\`下

显示进度或输出中间报告的方案有多种,下面给出若干方案的例子

```powershell

# 指定需要被更新插件的wordpress站总目录
# $wp_sites_dir = 'D:\wordpress\'
$wp_sites_dir = 'C:\sites\wp_sites\'
$pattern = '*\wp-content\plugins\*'

# 需要更新的插件(提前解压),下面的数组中一行一个插件目录
$plugin_sources = @'

W:\wp_sites\wp_plugins\price_pay\hellotopay
# W:\wp_sites\wp_plugins\price_pay\public-payment-for-woo
C:\Share\df\wp_sites\wp_plugins\price_pay\woo-nexpay

'@
$plugin_sources = $plugin_sources -replace '#.*', ' ' -replace '[",;\r\n]', ' ' -replace "'" , ' ' -replace '\s+', ' ' 
$plugin_sources = $plugin_sources.Trim() -split ' '

# Write-Output $plugin_sources
# pause


```

列出所有wp-content/plugins插件目录

```powershell
# 列出所有wp-content/plugins插件目录
$plugin_pattern = $pattern.TrimEnd('\*')
Write-Verbose "plugin_pattern: $plugin_pattern"
$plugin_dirs_target = [System.Collections.ArrayList]@()
```



### 方案1

```powershell

# 方案1(看使用进度条显示扫描进度)
# $plugin_dirs_target = Get-ChildItem -Path $wp_sites_dir -Recurse -Directory -Filter '*plugins' | Where-Object { $_.FullName -like $plugin_pattern }
$site_dirs = (Get-ChildItem -Directory $wp_sites_dir)
$tasks = $site_dirs.Length
## 方案1.1
# $i = 0
# foreach ($site_dir in $site_dirs)
# {
#     $item = Get-ChildItem -Path $site_dir -Recurse -Directory -Filter '*plugins' | Where-Object { $_.FullName -like $plugin_pattern }
#     # $item = Get-ChildItem -Path $_ -Recurse -Directory -Filter '*plugins' | Where-Object { $_.FullName -like $plugin_pattern }
#     $plugin_dirs_target.Add($item)

#     $completed = ($i / $tasks * 100) 
#     $completed = [math]::Round($completed, 2)
#     Write-Progress -Activity "Scanning for plugins" -Status "Scanned $i of $tasks directories" -PercentComplete $completed
#     Write-Host "scanning $site_dir..."
#     $i += 1
# }
## 方案1.2
$site_dirs | ForEach-Object -Begin {
    # $i = 0
    Write-Host "Scanning..."
} -Process {
    # Write-Host "scanning [$_] "
    $item = Get-ChildItem -Path $_ -Recurse -Directory -Filter '*plugins' | Where-Object { $_.FullName -like $plugin_pattern }
    if(!$item)
    {
        return
    }
    
    # 方案a
    
    #add方法有返回值,因此种类使用> $null情况输出,或者可以利用此特性
    # 可以在begin中或者前面设置$i=0
    # $plugin_dirs_target.Add($item) > $null
    # $i++

    # 方案b
    $i = $plugin_dirs_target.Add($item)
    $completed = (($i) / $tasks * 100) 
    $completed = [math]::Round($completed, 2)
    Write-Progress -Activity "Scanning for plugins" -Status "Scanned $i of $tasks directories($completed %)" -PercentComplete $completed
     
}


```



### 方案2

直接边遍历,边检查输出过程

```powershell
# 方案2(直接边遍历,边检查输出过程)

# Get-ChildItem -Path $wp_sites_dir -Recurse -Directory -Filter '*plugins' | Where-Object { $_.FullName -like $plugin_pattern } | ForEach-Object {
#     Write-Host "$($_.FullName)"
#     $plugin_dirs_target += $_.FullName
# }
```

