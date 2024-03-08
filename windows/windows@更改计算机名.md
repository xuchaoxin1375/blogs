[toc]



##  修改计算机名👺

###  CLI (powershell)

- 进入到**管理模式,切记**下运行(**run as administator**)

- `rename-computer <yourNewComputerName>`

  - DESCRIPTION

    > This cmdlet is only available on the Windows platform. The `Rename-Computer` cmdlet renames the local computer
    > or a remote computer. It renames one computer in each command.

    This cmdlet was introduced in Windows PowerShell 3.0.

- 例如:

  - ```powershell
    PS C:\Users\cxxu> Rename-Computer CxxuWin10
    WARNING: The changes will take effect after you restart the computer DESKTOP-CO17BQC.
    ```

    

###  GUI

- [重命名 Windows  电脑 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/重命名-windows-10-电脑-750bc75d-8ff8-e99a-b9dc-04dff566ae74)

####  win 10或更老系统

- 命令行中输入`systemPropertiesAdvanced.exe`,进入系统属性(手动右键我的电脑也行)
- 点击计算机名,包含更名菜单(注意不是描述,描述下有个更名按钮)
- 比较容易报错,推荐用上述的powershell的方式更改
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/5131f66de7bb41099c43bf275ae1c144.png)

#### 较新windows

- 开始菜单搜`计算机名`进入修改即可