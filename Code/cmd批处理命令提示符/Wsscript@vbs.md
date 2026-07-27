[toc]

## vbs

- windows中vbs脚本的执行器默认是:[wscript | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows-server/administration/windows-commands/wscript#syntax)

## Note

### 编码问题

- 有些中文编码会导致错误,例如

  - ```vbscript
    ' 开启严格变量声明（防止拼写错误引起的未声明变量错误）
    Option Explicit
    
    ' 创建WScript.Shell对象
    Dim WshShell
    Set WshShell = WScript.CreateObject("WScript.Shell")
    
    ' 显示一个消息框
    WshShell.Popup "你好！这是你在Windows Script Host中运行的第一个VBScript脚本。", 0, "欢迎信息"
    
    ' 释放对象占用的资源
    Set WshShell = Nothing
    ```

  - 其中消息框打印中文可能导致出错,使用英文可以避免这类错误

  - ```vbscript
    ' 开启严格变量声明（防止拼写错误引起的未声明变量错误）
    Option Explicit
    
    ' 创建WScript.Shell对象
    Dim WshShell
    Set WshShell = WScript.CreateObject("WScript.Shell")
    
    ' 显示一个消息框
    WshShell.Popup "Hello! This is the first VBScript script you run in Windows Script Host", 0, "welcome infomation"
    
    ' 释放对象占用的资源
    Set WshShell = Nothing
    ```

    