[toc]



## powershell 将一批文件中指定字符替换

 

要在 PowerShell 中将一批文件中指定的字符替换，可以使用 `Get-Content` 和 `Set-Content` 命令，或者使用 `Select-String` 和 `ForEach-Object` 来处理。假设你想将所有文件中 `8.0.2` 替换为 `8.1.0`，并且这些文件都在 `c:\phpstudy_pro\Extensions\Apache2.4.39\conf\vhosts\` 目录下，你可以使用以下脚本：

```powershell
# 定义文件路径和要替换的字符
$directoryPath = "c:\phpstudy_pro\Extensions\Apache2.4.39\conf\vhosts\"
$oldString = "8.0.2"
$newString = "8.1.0"

# 获取目录中的所有 .conf 文件
$files = Get-ChildItem -Path $directoryPath -Filter *.conf

# 遍历每个文件并替换指定字符
foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    $updatedContent = $content -replace $oldString, $newString
    Set-Content -Path $file.FullName -Value $updatedContent
}

Write-Output "替换完成"
```

这个脚本的工作原理如下：
1. 定义要处理的目录路径、要替换的旧字符和新字符。
2. 使用 `Get-ChildItem` 获取目录中所有 `.conf` 文件。
3. 遍历每个文件，使用 `Get-Content` 读取文件内容，并使用 `-replace` 操作符将旧字符替换为新字符。
4. 使用 `Set-Content` 将更新后的内容写回文件。
5. 最后输出一条消息表示替换完成。

请确保在运行此脚本之前备份你的文件，以防止意外的数据丢失。

## 使用软件替换

例如vscode这类文本编辑器可以执行替换

用vscode打开你需要替换的文件夹根目录,然后使用全局替换/查找功能,在打开的根目录中搜索指定字符串执行替换