# vscode 目录检索_模糊匹配工作空间的目录

> - `ctrl+p`启动`go to file`
> - 匹配目录的时候在目录名后面追加`/`来表示目录名

- ![](https://s2.loli.net/2022/04/07/N7PkJfsqW9FioyY.png)

## 辅助的powershell 函数

```powershell
function searchDirectories
{
    <#     
    .synopsis
    从当前目录开始递归查找具有指定名称的目录
    .Example 
    searchDirectories 'css' 
    searchDirectories -dirFrom_optional ./dir1/  -pattern css 
     #>
    param(
        $pattern,
        $dirFrom_optional = './',
        $isWildcard_optional = 'y',
        $maxDepth=3
    )
    printWorkingDir $dirFrom_optional
    write "max-depth=$maxDepth;if you want to search deeper directory,please modify the maxDepth as you want(0 will be equivalent 10)"
    # $wildPattern="*$pattern*"
    # Write-Output 'searching...'
    if ($isWildcard_optional -eq 'y')
    {
        $pattern = "*$pattern*"

    }
    if($maxDepth -eq 0){
        $maxDepth=10
    }
    Get-ChildItem -Path $Dir -Directory -Recurse -Filter $pattern -followSymlink  -Depth $maxDepth| Select-Object name, FullName 

    PrintBorder --
  
}
```

### focus folder in explorer(ctrl+click)

![image-20220407201803373](https://s2.loli.net/2022/04/07/6sCQZpA9wGhVfti.png)