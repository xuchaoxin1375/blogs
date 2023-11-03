[toc]



## windows  path
```ps1

PS C:\Users\cxxu_11> $env:Path  -split ';'
D:\Program Files\PowerShell\7
C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.9.1942.0_x64__8wekyb3d8bbwe
C:\WINDOWS\system32
C:\WINDOWS
C:\WINDOWS\System32\Wbem
C:\WINDOWS\System32\WindowsPowerShell\v1.0\
C:\WINDOWS\System32\OpenSSH\
C:\Program Files\Microsoft SQL Server\130\Tools\Binn\
D:\program files\vmware\bin\
D:\exes\pcmaster
C:\Program Files\dotnet\
D:\Program Files\nodejs\
D:\exes\python-3.9.5-embed-amd64
```

###  variable
```ps1

PS C:\Users\cxxu_11> $env:PSModulePath -split ';'
d:\usersByCxxu\DocumentsAll\PowerShell\Modules
C:\Program Files\PowerShell\Modules
d:\program files\powershell\7\Modules
C:\Program Files\WindowsPowerShell\Modules
C:\Windows\system32\WindowsPowerShell\v1.0\Modules
```

###  搜索环境变量
###  在Path中搜索
```ps1
function envInPath
{
    param (
        $pattern = "*"
    )

    Write-Output "😎😎😎within Path:"
    if ($pattern -eq "*")
    {
        $env:path -split ';'
        return
    }
    $env:path -split ';' | Select-String -Pattern $pattern
}

Write-Output "test the function:(该实例搜索了Path变量中是否有和sql相关的值)"
envInPath 'git'
```
###  在path之外的地方搜索

```ps1
function envNoPath
{
    param (
        [string]$pattern = "*"
    )

    Write-Output "😊😊😊without Path"
    if ($pattern -eq "*")
    {
        printenv | Select-String 'path=' -NotMatch
        return
    }
    printenv | Select-String 'path=' -NotMatch | Select-String -Pattern $pattern
}
Write-Output "test the function:envNoPath:to find environment without path env:"
envNoPath 'git' 
```
###  整合版搜索脚本(函数):
配合以上函数使用
```ps1
function envAll
{
    param (
        $pattern="*"
    )
    envNoPath $pattern
    envInPath $pattern
}
```
###  整合版函数(带选项)
```ps1
function envSearch
{
    param (
        $pattern="*",
        $isContainPath = "all"
    )
    if ($isContainPath -eq "p")
    {
        Write-Output "...within path....." 
        envInPath $pattern
    }
    elseIf ($isContainPath -eq "n" -or $isContentPath -eq "np") 
    {
        Write-Output "...within nonPath.....`\n"
        envNoPath $pattern
    }
    else
    {
        Write-Output "... env all ....."
        envAll $pattern
    }
}

```
###  效果:
函数带有默认参数,无参运行时,将返回所有的值.
![在这里插入图片描述](https://img-blog.csdnimg.cn/e74426ee9cb647f4b83deb79b82dfdb7.png)

##  linux PATH



### refenrece

- [bash - How to display $PATH as one directory per line? - Ask Ubuntu](https://askubuntu.com/questions/600018/how-to-display-path-as-one-directory-per-line)

### solution1

- `echo -e "${PATH/:/\n}"`

- ```bash
  # cxxu @ cxxuAli in ~ [14:49:34]
  $ echo "${PATH//:/$'\n'}"
  /usr/node/node-v16.14.2-linux-x64/bin/$'
  '/home/cxxu/.cargo/bin$'
  '/usr/local/sbin$'
  '/usr/local/bin$'
  '/usr/sbin$'
  '/usr/bin$'
  '/sbin$'
  '/bin$'
  '/usr/games$'
  '/usr/local/games$'
  '/snap/bin
  ```

- 

### solution2

- ` echo $PATH|sed 's/:/\n/g'|sort`

```
# cxxu @ cxxuAli in ~ [14:58:49]
$ echo $PATH|sed 's/:/\n/g'|sort
/bin
/home/cxxu/.cargo/bin
/sbin
/snap/bin
/usr/bin
/usr/games
/usr/local/bin
/usr/local/games
/usr/local/sbin
/usr/node/node-v16.14.2-linux-x64/bin/
/usr/sbin
```



### 简化书写PATH

复制环境变量

`export P=$PATH`

- 写入配置文件,长期生效









