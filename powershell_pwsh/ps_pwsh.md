[toc]

# powershell_进程任务管理/服务管理/(查看/关闭/停止/移除&windows移除mysql服务

## references



- [PowerShell Get-Process | Parameters in PowerShell Get-Process (educba.com)](https://www.educba.com/powershell-get-process/)

## 获取软件版本

- 根据进程名称获取软件版本
- `ps -FileVersionInfo  -Name *edge* `
- 
### 指定输出格式

- [Format-Table - PowerShell - SS64.com](https://ss64.com/ps/format-table.html)

### 按名称分组统计进程

- `ps |group ProcessName |sort Name`

- ```powershell
  PS C:\Users\cxxu> ps |group ProcessName |Sort Name                  
  
  Count Name                      Group
  ----- ----                      -----
      1 aix-node                  {System.Diagnostics.Process (aix-node)}
      6 Apifox                    {System.Diagnostics.Process (Apifox), System.Diagnostics.…
      1 audiodg                   {System.Diagnostics.Process (audiodg)}
      1 backgroundTaskHost        {System.Diagnostics.Process (backgroundTaskHost)}
      1 ChsIME                    {System.Diagnostics.Process (ChsIME)}
      4 Clash for Windows         {System.Diagnostics.Process (Clash for Windows), System.D…
      1 clash-core-service        {System.Diagnostics.Process (clash-core-service)}
      1 clash-win64               {System.Diagnostics.Process (clash-win64)}
     16 Code                      {System.Diagnostics.Process (Code), System.Diagnostics.Pr…
     14 conhost                   {System.Diagnostics.Process (conhost), System.Diagnostics…
      1 copilot-agent-win         {System.Diagnostics.Process (copilot-agent-win)}
      2 csrss                     {System.Diagnostics.Process (csrss), System.Diagnostics.P…
   .....
      1 IntelCpHDCPSvc            {System.Diagnostics.Process (IntelCpHDCPSvc)}
      1 IntelCpHeciSvc            {System.Diagnostics.Process (IntelCpHeciSvc)}
      1 jhi_service               {System.Diagnostics.Process (jhi_service)}
      1 KwService                 {System.Diagnostics.Process (KwService)}
      
      1 WmiPrvSE                  {System.Diagnostics.Process (WmiPrvSE)}
      2 WUDFHost                  {System.Diagnostics.Process (WUDFHost), System.Diagnostic…
      1 ZhuDongFangYu             {System.Diagnostics.Process (ZhuDongFangYu)}
  ```

### 查看特定进程组(通配符支持)


----- ----                      -----
```powershell
PS C:\Users\cxxu> ps *wechat*|group ProcessName |ft -wrap

Count Name                      Group
1 WeChat                    {System.Diagnostics.Process (WeChat)}
2 WeChatAppEx               {System.Diagnostics.Process (WeChatAppEx), System.Diagnostics.Process (WeChatAppEx)}
6 WechatBrowser             {System.Diagnostics.Process (WechatBrowser), System.Diagnostics.Process (WechatBrowser), System.Diagnostics.Process (WechatBrowser), System.Diagnostics.Pr
                            ocess (WechatBrowser)…}
1 WeChatPlayer              {System.Diagnostics.Process (WeChatPlayer)}
```

### 关闭特定进程


#### by Name

- 先借助ps命令查找到相关进程信息
  - id
  - processName

```powershell
PS C:\Users\cxxu> ps idm*

 NPM(K)    PM(M)      WS(M)     CPU(s)      Id  SI ProcessName
 ------    -----      -----     ------      --  -- -----------
     37    12.58      16.67     114.84    9980   3 IDMan

PS C:\Users\cxxu> stop -Name IDMan
     
```

## Microsoft 为windows 提供的辅助工具集合:Sysinternals

- [Sysinternals - Windows Sysinternals | Microsoft Docs](https://docs.microsoft.com/zh-cn/sysinternals/)

### 进程管理/监视扩展工具



- [PsList - Windows Sysinternals | Microsoft Docs](https://docs.microsoft.com/zh-cn/sysinternals/downloads/pslist)

## 第三方开源命令行进程工具

跨平台:

- btm(bottom)
- procs

其他:

- ntop(for windows)
- htop (for linux)

















# windows_powershell/cmd_移除服务(remove service)/移除mysql服务

## references

- [sc.exe delete | Microsoft Docs](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/sc-delete)
- [Remove-Service (Microsoft.PowerShell.Management) - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/remove-service?view=powershell-7.2)

## powershell方式

### powershell_查找服务/检查服务状态

* 查找服务(以mysql为例)

```powersehll
PS C:\Users\cxxu> gsv *mysql*

Status   Name               DisplayName
Stopped  MySQL              MySQL
```

### 停止服务

- `stop-service`

```powershell

NAME
    Stop-Service

SYNOPSIS
    Stops one or more running services.
```



### powershell 删除服务

#### 管理员模式下删除指定服务

- `remove-service`命令

非管理员模式下删除:

> Remove-Service: Failed to configure the service 'mysql (MySQL)' due to the following error: Access is denied.. Run PowerShell as admin and run your command again.

```
PS C:\Users\cxxu> remove-service -Name mysql

#执行顺利,没有返回消息

```



## sc(老式方法)

> - 可以在cmd 环境下运行

### sc.exe 位置



```cmd
PS C:\Users\cxxu> where.exe sc
C:\Windows\System32\sc.exe
```



### Syntax



```
sc.exe [<servername>] delete [<servicename>]
```

### Examples

To delete the service subkey **NewServ** from the registry on the local computer, type:

Copy

```
sc.exe delete NewServ
```


```cmd



DESCRIPTION:
        SC is a command line program used for communicating with the
        Service Control Manager and services.
USAGE:
        sc <server> [command] [service name] <option1> <option2>...


        The option <server> has the form "\\ServerName"
        Further help on commands can be obtained by typing: "sc [command]"
        Commands:
          query-----------Queries the status for a service, or
                          enumerates the status for types of services.
          queryex---------Queries the extended status for a service, or
                          enumerates the status for types of services.
          start-----------Starts a service.
          pause-----------Sends a PAUSE control request to a service.
          interrogate-----Sends an INTERROGATE control request to a service.
          continue--------Sends a CONTINUE control request to a service.
          stop------------Sends a STOP request to a service.
          config----------Changes the configuration of a service (persistent).
          description-----Changes the description of a service.
          failure---------Changes the actions taken by a service upon failure.
          failureflag-----Changes the failure actions flag of a service.
          sidtype---------Changes the service SID type of a service.
          privs-----------Changes the required privileges of a service.
          managedaccount--Changes the service to mark the service account 
                          password as managed by LSA.
          qc--------------Queries the configuration information for a service.
          qdescription----Queries the description for a service.
          qfailure--------Queries the actions taken by a service upon failure.
          qfailureflag----Queries the failure actions flag of a service.
          qsidtype--------Queries the service SID type of a service.
          qprivs----------Queries the required privileges of a service.
          qtriggerinfo----Queries the trigger parameters of a service.
          qpreferrednode--Queries the preferred NUMA node of a service.
          qmanagedaccount-Queries whether a services uses an account with a 
                          password managed by LSA.
          qprotection-----Queries the process protection level of a service.
          quserservice----Queries for a local instance of a user service template.
          delete----------Deletes a service (from the registry).
          create----------Creates a service. (adds it to the registry).
          control---------Sends a control to a service.
          sdshow----------Displays a service's security descriptor.
          sdset-----------Sets a service's security descriptor.
          showsid---------Displays the service SID string corresponding to an arbitrary name.
          triggerinfo-----Configures the trigger parameters of a service.
          preferrednode---Sets the preferred NUMA node of a service.
          GetDisplayName--Gets the DisplayName for a service.
          GetKeyName------Gets the ServiceKeyName for a service.
          EnumDepend------Enumerates Service Dependencies.

        The following commands don't require a service name:
        sc <server> <command> <option>
          boot------------(ok | bad) Indicates whether the last boot should
                          be saved as the last-known-good boot configuration
          Lock------------Locks the Service Database
          QueryLock-------Queries the LockStatus for the SCManager Database
EXAMPLE:
        sc start MyService


QUERY and QUERYEX OPTIONS:
        If the query command is followed by a service name, the status
        for that service is returned.  Further options do not apply in
        this case.  If the query command is followed by nothing or one of
        the options listed below, the services are enumerated.
    type=    Type of services to enumerate (driver, service, userservice, all)
             (default = service)
    state=   State of services to enumerate (inactive, all)
             (default = active)
    bufsize= The size (in bytes) of the enumeration buffer
             (default = 4096)
    ri=      The resume index number at which to begin the enumeration
             (default = 0)
    group=   Service group to enumerate
             (default = all groups)

SYNTAX EXAMPLES
sc query                - Enumerates status for active services & drivers
sc query eventlog       - Displays status for the eventlog service
sc queryex eventlog     - Displays extended status for the eventlog service
sc query type= driver   - Enumerates only active drivers
sc query type= service  - Enumerates only Win32 services
sc query state= all     - Enumerates all services & drivers
sc query bufsize= 50    - Enumerates with a 50 byte buffer
sc query ri= 14         - Enumerates with resume index = 14
sc queryex group= ""    - Enumerates active services not in a group
sc query type= interact - Enumerates all interactive services
sc query type= driver group= NDIS     - Enumerates all NDIS drivers

```

## windows_后台服务管理

