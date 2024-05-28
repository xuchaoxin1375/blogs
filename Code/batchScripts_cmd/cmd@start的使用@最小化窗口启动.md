[toc]

## cmd start 用法和文档

- [Start - Start a program - Windows CMD - SS64.com](https://ss64.com/nt/start.html)
- [start | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/start)

### 本地文档

`cmd start` 的概述:**Starts a separate Command Prompt window** to run a specified program or command

```cmd
PS> cmd /c start /?
Starts a separate window to run a specified program or command.

START ["title"] [/D path] [/I] [/MIN] [/MAX] [/SEPARATE | /SHARED]
      [/LOW | /NORMAL | /HIGH | /REALTIME | /ABOVENORMAL | /BELOWNORMAL]
      [/NODE <NUMA node>] [/AFFINITY <hex affinity mask>] [/WAIT] [/B]
      [/MACHINE <x86|amd64|arm|arm64>][command/program] [parameters]

    "title"     Title to display in window title bar.
    path        Starting directory.
    B           Start application without creating a new window. The
                application has ^C handling ignored. Unless the application
                enables ^C processing, ^Break is the only way to interrupt
                the application.
    I           The new environment will be the original environment passed
                to the cmd.exe and not the current environment.
    MIN         Start window minimized.
    MAX         Start window maximized.
```



#### 对于脚本文件

- `cmd start` 运行一个脚本文件时,我们可以指定弹出的窗口的标题,比如我们

  - 创建一个名为`demo.cmd`的脚本文件(比如文件在桌面上),记事本或编辑器打开它并写入

    - ```bash
      
      echo "this is a demo bat file"
      pause
      
      ```

  - 在cmd 中使用start 来运行这个脚本文件:`start "demo script" /max demo.cmd`

    - (这里假设我们的脚本创建在桌面,并且cmd也定位到了桌面,
    - 如果没有,执行:`cd /D %userprofile%/desktop`将工作目录跳转到桌面)

  - 执行后弹出一个全屏显示的cmd窗口(如果有用windows terminal管理shell,可能弹出terminal,shell窗格的标签(标题)为指定的`demo script`)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/8a4607d57f314eb99d1cbf9da84f0035.png)

### 其他GUI程序的title

- 除了上述情形,GUI程序的title通常无法指定,如果指定了,效果和空字符串`“”`一样

## 最小化或最大化窗口启动程序

### cmd start 的MIN和MAX参数

- 最小/大化方式打开一个命令行窗口,可以利用`cmd start`的`/MIN`或`/MAX`参数来实现来实现
- 然而这个参数对于启动一个非命令行窗口时并不起作用(除了少数windows自带应用,比如记事本)
- 例如`start "" /MAX notepad.exe`
  
  - 对于资源管理器就不起作用
  
  - ```cmd
    start "testCmdStart" /min  pwsh -noe -c explorer
    ```
  
    这个命令以最小化方式打开一个pwsh(powershell)窗口(出现在任务栏中),而这个新窗口不会弹出到桌面,但是会执行启动资源管理器(`explorer`)的任务,并且利用`-noe`参数告诉pwsh完成任务后不要自我关闭窗口
  
    这里explorer不收`/min`参数的影响,仍然会弹出窗口到桌面

### GUI方式设置

- 事实上这个设置也不一定有效

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/c842e8403f314d919d623acc38837180.png)

  

