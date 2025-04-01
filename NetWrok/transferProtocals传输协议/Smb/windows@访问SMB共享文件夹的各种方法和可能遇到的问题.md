[toc]



## abstract

记录windows上使用smb共享文件夹访问共享文件夹服务端文件夹过程中可能遇到的问题(常见问题)

### 匿名访问问题😊

免登录访问共享文件夹问题

- [SMB2 和 SMB3 中的来宾访问被禁用 - Windows Server | Microsoft Learn](https://learn.microsoft.com/zh-cn/troubleshoot/windows-server/networking/guest-access-in-smb2-is-disabled-by-default)

  - SMB1默认支持匿名访问,对于较新系统,需要到控制面板中启动相关windows功能
    - 仅当需要兼容老设备或者实在想要匿名登录时考虑这么做(todo)
  - 新系统配置匿名smb访问比较麻烦,我们可以建立一个简单的windows用户(账号密码很短)来逼近匿名访问的体验
  - 事实上,smb协议的客户端通常由保存链接记录的功能,只要设置一次,后续就不需要输入账号密码,如果是一个人或很少人用,就更不用纠结了,配置一次就不需要再输入账号密码了(顶多smb服务器ip发生变换,但如果真的需要改ip无论是否匿名访问都要改,并不会造成更多麻烦,而且提高了一定的安全性)

### 强制启用匿名访问

- 以下设置可能是无效的

  - 修改策略组

  - 或命令行修改注册表

    - ```bash
      PS C:\Users\cxxu\Desktop> reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters /v "AllowInsecureGuestAuth" /d 1 /t REG_DWORD
      
      The operation completed successfully.
      
      PS C:\Users\cxxu\Desktop> reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters
      
      HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters
          EnablePlainTextPassword    REG_DWORD    0x0
          EnableSecuritySignature    REG_DWORD    0x1
          RequireSecuritySignature    REG_DWORD    0x0
          ServiceDll    REG_EXPAND_SZ    %SystemRoot%\System32\wkssvc.dll
          ServiceDllUnloadOnStop    REG_DWORD    0x1
          AllowInsecureGuestAuth    REG_DWORD    0x1
      ```

- 可以考虑启用smb v1,似乎可以匿名访问,但不建议使用,可以简单创建一个专门访问共享文件夹的简单用户即可



### 共享文件夹文件被病毒查杀软件隔离或删除

- windows defedner这类软件会在权限允许的情况下查杀共享文件夹中的文件(尤其是可执行文件)
- 然而有些**学习版**软件和工具会被windows defender直接隔离删除,这可能不是我们想要的,而且会造成烦恼
- 为了防止这一点,您可以寻找彻底关闭或禁用windows defender的方法(比如修改组策略等,或者相关的一键关闭工具(比如dism++)来禁用defender)
- 或者添加排除项目,比如指定某个目录或者盘符根目录不加入查杀,或者添加文件类型,比如`exe`类型的文件不查杀
- 关闭查杀会造成一定的风险,酌情设置



## 多重连接问题

windows在连接smb方面存在bug,不仅仅是windows设置的显式限制

```powershell
PS> net use X: \\cxxudesk\dfl /user:reader readonly
发生系统错误 1219。

不允许一个用户使用一个以上用户名与服务器或共享资源的多重连接。中断与此服务器或共享资源的所有连接，然后再试一次。
```

windows提示的错误:**不允许 [一个用户] 使用 [一个以上用户名] 与 [服务器或共享资源] 多重连接**

并给出的参考方案:中断与此服务器或共享资源的所有连接，然后再试一次。(实际情况中,这个方法并不是很有效)



```cmd
net use R: \\cxxudesk\dfl /p:yes /savecred
```

