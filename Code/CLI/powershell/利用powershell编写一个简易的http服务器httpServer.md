[toc]

## powershell一键启动

一键启动脚本内容(powershell,兼容windows powershell和powershell7+)

```powershell
irm https://gitee.com/xuchaoxin1375/scripts/raw/main/PS/Tools/Tools.psm1|iex
sleep 0.5
help Start-HTTPServer
#可以指定参数选择服务器根目录和端口
start-httpServer

```

一键启动依赖于互联网,会从gitee下载代码运行

如果要离线运行,参考最后一节,或者部署上述脚本仓库[scripts: 实用脚本集合,以powershell模块为主(针对powershell 7开发) 支持一键部署,改善windows下的shell实用体验](https://gitee.com/xuchaoxin1375/scripts)

---



如果部署相关仓库pwsh模块,可以使用`Start-HttpserverBG`来启动一个后台httpServer进程

可以配合一下方法查询相关进程

### 检查相关进程

```powershell
@("*pwsh*","*powershell*")|%{ps -Name $_ } |?{$_.CommandLine -like '*httpServer*'}
```

例如:

```powershell
@("*pwsh*","*powershell*")|%{ps -Name $_ } |?{$_.CommandLine -like '*httpServer*'}

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
     84    45.52     116.32       1.91   12084   2 pwsh
```

杀死查询结果

```powershell
ps -Id 12084 |kill
```



## 源码

可以跳过不看,如果源码不可用,则可以将下面代码拷贝到powershell的配置文件或者自动导入模块中,然后用powershell命令行收入`Start-HttpServer`也能离线(不联网)启动本地服务器

更直接的用法是将内容复制保存到一个`.ps1`脚本文件中,然后通过右键,选择以powershell方式运行(建议用pwsh而非自带的powershell.exe)即可启动服务

windows powershell.exe对于中文(utf8)编码的脚本可能会乱码报错,因此下面的代码纯英文



```powershell
# If you need to set the service start path, modify the parameters on the last line.
# By default, the desktop is set as the server directory, and the port is 8080.

function Format-FileSize
{
    param([long]$Size)
    
    if ($Size -gt 1GB) { return "{0:N2} GB" -f ($Size / 1GB) }
    if ($Size -gt 1MB) { return "{0:N2} MB" -f ($Size / 1MB) }
    if ($Size -gt 1KB) { return "{0:N2} KB" -f ($Size / 1KB) }
    return "$Size B"
}

function Get-MimeType
{
    param([string]$Extension)
    
    $MimeTypes = @{
        ".txt"  = "text/plain; charset=utf-8"
        ".ps1"  = "text/plain; charset=utf-8"
        ".py"   = "text/plain; charset=utf-8"
        ".htm"  = "text/html; charset=utf-8"
        ".html" = "text/html; charset=utf-8"
        ".css"  = "text/css; charset=utf-8"
        ".js"   = "text/javascript; charset=utf-8"
        ".json" = "application/json; charset=utf-8"
        ".jpg"  = "image/jpeg"
        ".jpeg" = "image/jpeg"
        ".png"  = "image/png"
        ".gif"  = "image/gif"
        ".pdf"  = "application/pdf"
        ".xml"  = "application/xml; charset=utf-8"
        ".zip"  = "application/zip"
        ".md"   = "text/markdown; charset=utf-8"
        ".mp4"  = "video/mp4"
        ".mp3"  = "audio/mpeg"
        ".wav"  = "audio/wav"
    }
    
    $key = $Extension.ToLower()
    if ($MimeTypes.ContainsKey($key))
    {
        return $MimeTypes[$key]
    }
    return "application/octet-stream"
}


function Get-DirectoryListing
{
    param($RelativePath, $Items)
    
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Index of /$RelativePath</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { text-align: left; padding: 8px; border-bottom: 1px solid #ddd; }
        th { background-color: #f2f2f2; }
        tr:hover { background-color: #f5f5f5; }
        a { text-decoration: none; color: #0066cc; }
        .size { text-align: right; }
        .date { white-space: nowrap; }
    </style>
</head>
<body>
    <h1>Index of /$RelativePath</h1>
    <table>
        <tr>
            <th>Name</th>
            <th class="size">Size</th>
            <th class="date">Last Modified</th>
        </tr>
"@

    if ($RelativePath)
    {
        $html += "<tr><td><a href='../'>..</a></td><td></td><td></td></tr>"
    }

    # Process folders and files separately and sort by name
    $Folders = $Items | Where-Object { $_.PSIsContainer } | Sort-Object Name
    $Files = $Items | Where-Object { !$_.PSIsContainer } | Sort-Object Name

    # Display folders first
    foreach ($Item in $Folders)
    {
        $Name = $Item.Name
        $LastModified = $Item.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        $EncodedName = [System.Web.HttpUtility]::UrlEncode($Name)
        
        $html += "<tr><td><a href='$EncodedName/'>$Name/</a></td><td class='size'>-</td><td class='date'>$LastModified</td></tr>"
    }

    # Display files next
    foreach ($Item in $Files)
    {
        $Name = $Item.Name
        $Size = Format-FileSize $Item.Length
        $LastModified = $Item.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        $EncodedName = [System.Web.HttpUtility]::UrlEncode($Name)
        
        $html += "<tr><td><a href='$EncodedName'>$Name</a></td><td class='size'>$Size</td><td class='date'>$LastModified</td></tr>"
    }

    $html += @"
    </table>
    <footer style="margin-top: 20px; color: #666; font-size: 12px;">
        Total $($Folders.Count) folders, $($Files.Count) files
    </footer>
</body>
</html>
"@

    return $html
}

function Start-HTTPServer
{
    <#
    .SYNOPSIS
    Starts a simple HTTP file server.

    .DESCRIPTION
    Serves a specified local folder as the root directory of an HTTP server, defaulting to port 8080.

    .PARAMETER Path
    Specifies the local folder path to be used as the server root directory.

    .PARAMETER Port
    Specifies the port number the HTTP server should listen on, defaulting to 8080.

    .EXAMPLE
    Start-HTTPServer -Path "C:\Share" -Port 8000
    Serves the C:\Share folder as root at port 8000.

    .EXAMPLE
    Start-HTTPServer
    Serves the current directory as root at port 8080.
    #>

    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Path = (Get-Location).Path,
        
        [Parameter(Position = 1)]
        [int]$Port = 8080
    )

    Add-Type -AssemblyName System.Web
    try
    {
        # Validate path exists
        if (-not (Test-Path $Path))
        {
            throw "The specified path '$Path' does not exist."
        }

        # Create HTTP listener
        $Listener = New-Object System.Net.HttpListener
        $Listener.Prefixes.Add("http://+:$Port/")

        # Try to start the listener
        try
        {
            $Listener.Start()
        }
        catch
        {
            throw "Cannot start HTTP server, possibly due to insufficient permissions or port already in use: $_"
        }

        Write-Host "HTTP server has started:"
        Write-Host "Root directory: $Path"
        Write-Host "Address: http://localhost:$Port/"
        Write-Host "Press Ctrl+C to stop the server (it may take a few seconds, if you can't wait consider closing the corresponding command line window)"

        while ($Listener.IsListening)
        {
            # Wait for request
            $Context = $Listener.GetContext()
            $Request = $Context.Request
            $Response = $Context.Response
            
            # URL decode request path
            $DecodedPath = [System.Web.HttpUtility]::UrlDecode($Request.Url.LocalPath)
            $LocalPath = Join-Path $Path $DecodedPath.TrimStart('/')
            
            # Set response header, support UTF-8
            $Response.Headers.Add("Content-Type", "text/html; charset=utf-8")
            
            # Handle directory request
            if ((Test-Path $LocalPath) -and (Get-Item $LocalPath).PSIsContainer)
            {
                $LocalPath = Join-Path $LocalPath "index.html"
                if (-not (Test-Path $LocalPath))
                {
                    # Generate directory listing
                    $Content = Get-DirectoryListing $DecodedPath.TrimStart('/') (Get-ChildItem (Join-Path $Path $DecodedPath.TrimStart('/')))
                    $Buffer = [System.Text.Encoding]::UTF8.GetBytes($Content)
                    $Response.ContentLength64 = $Buffer.Length
                    $Response.OutputStream.Write($Buffer, 0, $Buffer.Length)
                    $Response.Close()
                    continue
                }
            }

            # Handle file request
            if (Test-Path $LocalPath)
            {
                $File = Get-Item $LocalPath
                $Response.ContentType = Get-MimeType $File.Extension
                $Response.ContentLength64 = $File.Length
                
                # Add filename encoding support
                $FileName = [System.Web.HttpUtility]::UrlEncode($File.Name)
                $Response.Headers.Add("Content-Disposition", "inline; filename*=UTF-8''$FileName")
                
                $FileStream = [System.IO.File]::OpenRead($File.FullName)
                $FileStream.CopyTo($Response.OutputStream)
                $FileStream.Close()
            }
            else
            {
                # Return 404
                $Response.StatusCode = 404
                $Content = "404 - File not found"
                $Buffer = [System.Text.Encoding]::UTF8.GetBytes($Content)
                $Response.ContentLength64 = $Buffer.Length
                $Response.OutputStream.Write($Buffer, 0, $Buffer.Length)
            }

            $Response.Close()
        }
    }
    finally
    {
        if ($Listener)
        {
            $Listener.Stop()
            $Listener.Close()
        }
    }
}

function Start-HTTPServerBG
{
    param (
        # Default shell is Windows PowerShell, if PowerShell 7+ (or pwsh) is installed, use pwsh instead;
        # By default, need to add Start-HTTPServer to PowerShell configuration file or PowerShell auto-import module, otherwise Start-HTTPServerBG command will not be available, leading to start failure.
        # $shell = "powershell",
        $shell = "pwsh", # Personally prefer pwsh
        $path = "$home\Desktop",
        $Port = 8080
    )
    Write-Verbose "Trying to start HTTP server..." -Verbose
    # $PSBoundParameters 
    $params = [PSCustomObject]@{
        shell = $shell
        path  = $path
        Port  = $Port
    }
    Write-Output $params # Cannot directly output literal object with Write-Output, it will be treated as a string
    # Write-Output $shell, $path, $Port
    # $exp = "Start-Process -WindowStyle Hidden -FilePath $shell -ArgumentList { {c Start-HTTPServer -path $path -port $Port } -PassThru"
    # Write-Output $exp
    # $ps = $exp | Invoke-Expression
    
    # $func = ${Function:Start-HTTPServer} # Since the complete code of Start-HTTPServer is too scattered, just writing this way cannot obtain the complete Start-HTTPServer function
    $ps = Start-Process -FilePath $shell -ArgumentList "-c Start-HTTPServer -path $path -port $Port" -PassThru
    # Debug start-process syntax
    # $ps = Start-Process -FilePath pwsh -ArgumentList "-c", "Get-Location;Pause "

    return $ps
    
}

# Modify as needed
Start-HTTPServer -Path "$home\Desktop" -Port 8080

```

