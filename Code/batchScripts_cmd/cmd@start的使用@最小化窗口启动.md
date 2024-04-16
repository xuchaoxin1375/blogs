[toc]

## refs

- [Start - Start a program - Windows CMD - SS64.com](https://ss64.com/nt/start.html)
- [start | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/start)

### title

#### 对于脚本文件

- 通常是start 运行一个脚本文件时,我们可以指定弹出的窗口的标题,比如我们

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

## 最小化或最大化启动程序

### start 的MIN和MAX参数

- 这个功能可以通过指定`/MIN`或`/MAX`来实现
- 然而有时这个参数并不起作用(可能是新系统的问题),例如一些第三方程序,而对于记事本这类windows自带程序往往是起作用的
  - 例如`start "" /MAX notepad.exe`
  - 对于资源管理器就不起作用

### GUI方式设置

- 事实上这个设置也不一定有效

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/c842e8403f314d919d623acc38837180.png)

  

