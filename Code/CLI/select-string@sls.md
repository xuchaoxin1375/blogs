## abstract

- PowerShell 中的 `Select-String` 命令是一个强大的工具，用于搜索输入文本（无论是字符串还是文件内容）中的特定模式。它支持正则表达式，类似于 Unix/Linux 中的 `grep` 命令或 Windows 自带的 `findstr.exe` 工具。
- [Select-String (Microsoft.PowerShell.Utility) - PowerShell | Microsoft Learn](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/Select-String?view=powershell-7.4)

- [参数(选项)](https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.utility/Select-String?view=powershell-7.4#parameters)

### 基本语法：
```powershell
Select-String [-Pattern] <string> [[-Path] <string[]>] [-CaseSensitive] [-SimpleMatch] 
              [-Quiet] [-Context <int>] [-List] [-AllMatches] [-Encoding <string>] 
              [-NotMatch] [-Raw] [<CommonParameters>]
```

#### 参数说明：

- **-Pattern** `<string>`：必填参数，指定要搜索的正则表达式模式。

- **-Path** `<string[]>`：指定要搜索的文件路径列表。可以是单个文件名、多个文件名或通配符表达式。默认情况下，如果没有指定 `-Path`，`Select-String` 将从管道中接收输入。

- **-CaseSensitive**：当设置时，搜索会区分大小写。

- **-SimpleMatch**：不使用正则表达式进行匹配，而是进行简单的文本匹配。

- **-Quiet**：只返回一个布尔值，表示是否存在匹配项，而不显示匹配行的具体信息。

- **-Context** `<int>`：显示匹配行的上下文，即在其前后显示指定数量的行。

    示例：`-Context 5` 会显示匹配行及其前后的各5行内容。

- **-List**：仅显示包含至少一个匹配项的文件名，而不显示匹配行的内容。

- **-AllMatches**：在每一行中查找所有匹配项，而不是仅仅输出第一个匹配。

- **-Encoding** `<string>`：指定文件的编码类型，如 ASCII、Unicode 或 UTF8 等。

- **-NotMatch**：与 `-Match` 相反，显示不匹配给定模式的行。

- **-Raw**：将整个文件视为单行来处理，这对于处理多行匹配特别有用。

### 演示文本

- 以下文本作为素材

  ```
  The British Broadcasting Corporation (BBC) is a British public service broadcaster headquartered at Broadcasting House in London, England. 
  Originally established in 1922 as the British Broadcasting Company, it evolved into its current state with its current name on New Year's Day 1927. 
  The oldest and largest local and global broadcaster by stature and by number of employees, the BBC employs over 21,000 staff in total, of whom approximately 17,900 are in public-sector broadcasting.[1][2][3][4][5]
  
  Select-String cmdlet 使用正则表达式匹配来搜索输入字符串和文件中的文本模式。 可以使用 Select-String，它类似于 UNIX 中的 grep 或 Windows 中的 findstr.exe。
  
  Select-String 基于文本行。 默认情况下，Select-String 将查找每行中的第一个匹配项，并且对于每个匹配项，它都将显示文件名、行号和包含该匹配项的行中的所有文本。 
  ```

- powershell中创建文本对象(在powershell中直接粘贴以下内容并回车执行)

  ```powershell
  $text=@"
  The British Broadcasting Corporation (BBC) is a British public service broadcaster headquartered at Broadcasting House in London, England. 
  
  --------- beginning of error
  2023-02-14 16:37:45.895 12345/com.example.app E/AndroidRuntime: FATAL EXCEPTION: main
      Process: com.example.app, PID: 12345
      java.lang.NullPointerException: Attempt to invoke virtual method 'void android.widget.Button.setOnClickListener(android.view.View$OnClickListener)' on a null object reference
          at com.example.app.MainActivity.onViewCreated(MainActivity.java:42)
          at androidx.fragment.app.FragmentManagerImpl.moveToState(FragmentManagerImpl.java:892)
  
  Select-String cmdlet 使用正则表达式匹配来搜索输入字符串和文件中的文本模式。 可以使用 Select-String，它类似于 UNIX 中的 grep 或 Windows 中的 findstr.exe。
  
  Select-String 基于文本行。 默认情况下，Select-String 将查找每行中的第一个匹配项，并且对于每个匹配项，它都将显示文件名、行号和包含该匹配项的行中的所有文本。 
  "@
  
  
  
  ```

- 写出为文件`demo.txt`

  ```powershell
  
  PS 🕰️9:02:34 PM [C:\Users\cxxu\Desktop] 🔋100% $text>demo.txt
  PS 🕰️9:02:40 PM [C:\Users\cxxu\Desktop] 🔋100% ls .\demo.txt
  
          Directory: C:\Users\cxxu\Desktop
  
  
  Mode                LastWriteTime         Length Name
  ----                -------------         ------ ----
  -a---         2/12/2024   9:02 PM            502 󰈙  demo.txt
  ```

  





