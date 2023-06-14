[toc]

## OpenWith@选择文件打开方式导致卡死

- 关键在于一个名为`openwith`的进程出现问题
- 该进程有时会卡死,并且无法关闭,这个bug存在很久了,具体参考:[Windows11 - Microsoft Community](https://answers.microsoft.com/zh-hans/windows/forum/all/windows11/96598c01-60ed-4cbc-976a-afa08c9e14e8)
- 主要出现在右键某个文件选择打开方式中选择已安装程序时,如果不是通过鼠标点取而是输入路径(粘贴路径)的时候.
- 通过使用进程管理器检查,发现有一个名为`pick an app`进程(是由`C:\Windows\System32\OpenWith.exe`)这个程序导致的

### 解决方案

- 使用powershell,执行`Stop-Process -Name OpenWith`
- 或通过启动任务管理器找到该进程,并手动杀灭该进程(重启资源管理器不总是有用,而且也没必要,重启机器更没必要)
  - 不过您确实需要的话,可以在powershell中执行`Stop-Process -name explorer`重启资源管理器,某些情况下有用

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/abdd7eaf3b2246e49f9e67e5af300cfa.png)

## windows11任务栏显示秒

- 需要较新的windows版本,且可以在设置中通过GUI设置
- 该功能的开启会增加功耗(use more power)
- 一下提供命令行的控制方式,在powershell或者cmd中输入,可以将他配置到powershell的模块中以便运行

### 显示秒的注册表设置

- 在powershell或cmd中执行:

  - ```bash
    reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSecondsInSystemClock /t REG_DWORD  /d 1
    ```

    

- 实际操作演示:

  ```bash
  PS C:\Users\cxxu\Desktop> reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSecondsInSystemClock /t REG_DWORD  /d 1
  The operation completed successfully.
  ```

  

### 取消显示秒:

- 在powershell或cmd中执行:

  - ```bash
    reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSecondsInSystemClock /f
    ```

  - 这里是使用了`/f`强制删除之前配置的注册表键

- 实际操作:(假设不使用`/f`)

  - ```bash
    PS C:\Users\cxxu\Desktop> reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowSecondsInSystemClock
    Delete the registry value ShowSecondsInSystemClock (Yes/No)? y
    The operation completed successfully.
    ```

    













