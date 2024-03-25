[toc]

## refs

- [How do you turn off windows 10 updates which are really powerful? - Microsoft Q&A](https://learn.microsoft.com/en-us/answers/questions/1351413/how-do-you-turn-off-windows-10-updates-which-are-r)
- [关闭Windows自动更新的6种方法_怎么关闭windows自动更新-CSDN博客](https://blog.csdn.net/qq_41361442/article/details/131085498)

## 策略组

- [Configure Windows Updates Using Group Policy Editor (gpedit.msc) - PCInsider (thepcinsider.com)](https://www.thepcinsider.com/configure-windows-updates-using-group-policy-editor-gpedit/)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/3e068c70688845a29a1d0c96f8f19261.png)

## 注册表方式

- 该方式可能随着windows的变化而在某些版本失效

- 管理员方式打开cmd或powershell

  ```bash
  reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoUpdate /t REG_DWORD /d 1
  ```

- 将上述内容粘贴到命令行中执行(按下回车)

- 更完整的操作过程为:

  - 执行

    ```powershell
    PS C:\Users\cxxu\Desktop> reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoUpdate /t REG_DWORD /d 1
    The operation completed successfully.
    
    
    ```

  - 查询执行结果

    - ```powershell
      PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU
      
      HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU
          UseWUServer    REG_DWORD    0x0
          NoAutoUpdate    REG_DWORD    0x1
      ```

      

  - 其中查询结果出现:`NoAutoUpdate    REG_DWORD    0x1`即可


## 任务计划程序

- windows为任务计划器中配置了一条自动启用更新服务的自动任务
- 这就导致即便我们将更新服务禁用,但是一段时间后系统更新服务又会重新出现
- 当然windows可能还有其他的服务来唤醒它,想要彻底禁用系统更新并不容易

## 其他方法👺

#### 脚本方案

- [tsgrgo/windows-update-disabler: Disable Windows update with a lightweight batch tool. (github.com)](https://github.com/tsgrgo/windows-update-disabler)

#### 软件方案

- [Windows Update Blocker v1.8 (sordum.org)](https://www.sordum.org/9470/windows-update-blocker-v1-8/)
- [Disable Windows 10/11 Automatic Updates With Ease | Win Update Stop](https://www.winupdatestop.com/)

## 修改系统时间

- windows允许计划推迟更新,比如下一周,下一个月
- 而如果把系统时间更改为很多年后(关闭自动校准时间),那么下一次更新日期会相应的变得很遥远
- 但是时间变动会造成很多问题,导致报错,所以通常要把时间改回正确的时间,可能导致延期设置失效



