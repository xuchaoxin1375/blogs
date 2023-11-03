[toc]

## ref

- [(Windows) 创建出站端口规则 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/security/threat-protection/windows-firewall/create-an-outbound-port-rule)
- [Windows Defender Firewall with Advanced Security (Windows) | Microsoft Learn](https://learn.microsoft.com/en-us/windows/security/threat-protection/windows-firewall/windows-firewall-with-advanced-security)
- [组策略 Windows) 高级安全性的 Windows 防火墙 (管理 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/security/threat-protection/windows-firewall/open-the-group-policy-management-console-to-windows-firewall-with-advanced-security)

## 打开防火墙控制面板

- [windows-itpro-docs/open-windows-firewall-with-advanced-security.md at public · MicrosoftDocs/windows-itpro-docs (github.com)](https://github.com/MicrosoftDocs/windows-itpro-docs/blob/public/windows/security/threat-protection/windows-firewall/open-windows-firewall-with-advanced-security.md)
  - [使用高级安全性打开Windows Defender防火墙 (Windows) | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/security/threat-protection/windows-firewall/open-windows-firewall-with-advanced-security?source=recommendations)
  - [List Of Microsoft Management .MSC Files In Windows (itechtics.com)](https://www.itechtics.com/msc-files/)
- 直接在命令行工具中输入`wf.msc`
  - powershell中允许你只输入`wf`回车启动

## 常用部分

## 限制某个软件联网

- 主要是限制指定软件发送请求(出站请求(outbound Request))来实现组织软件主动联网
  - 所谓的`站`(就是主机host,一般可以理解为计算机)

## 利用命令行操作

- [Windows Defender Firewall with Advanced Security Administration with Windows PowerShell (Windows) | Microsoft Learn](https://learn.microsoft.com/en-us/windows/security/threat-protection/windows-firewall/windows-firewall-with-advanced-security-administration-with-windows-powershell)

- [How to Allow or Block or a Program in Windows Firewall (winbuzzer.com)](https://winbuzzer.com/2021/12/26/windows-firewall-how-to-allow-or-block-or-a-program-from-accessing-the-internet-xcxwbt/)

### powershell

- [Where is Powershell NetSecurity module? - Stack Overflow](https://stackoverflow.com/questions/15262426/where-is-powershell-netsecurity-module)
- 防火墙管理功能的NetSecurity模块似乎只有服务器版本的windows server powershell
- 个人电脑中是没有相应模块的

### netsh

- [Use netsh advfirewall firewall context - Windows Server | Microsoft Learn](https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/netsh-advfirewall-firewall-control-firewall-behavior)

#### 权限说明

- 执行防火墙配置,需要管理员权限
- 因此,您应当使用管理员方式打开一个终端,以便后续操作可以顺利执行

#### 新增防火墙规则

- `netsh advfirewall firewall add rule ?`

  - ```bash
    
    Usage: add rule name=<string>
          dir=in|out
          action=allow|block|bypass
          [program=<program path>]
          [service=<service short name>|any]
          [description=<string>]
          [enable=yes|no (default=yes)]
          [profile=public|private|domain|any[,...]]
          [localip=any|<IPv4 address>|<IPv6 address>|<subnet>|<range>|<list>]
       .............
    ```

  - 自行输入上述命令查阅文档

- 例如:禁止火狐浏览器联网

  - ```bash
    PS D:\Program Files\Mozilla Firefox> netsh advfirewall firewall add rule dir=out action=block program="D:\Program Files\Mozilla Firefox\firefox.exe" name="blockFirefox" description="createByNetsh"  enable=yes
    Ok.
    ```

    

##### 防火墙规则命名建议

- 通常,不建议建立两个同名的规则,应为防火墙配置命令是通过规则名字来区分规则,如果同名,可能会造成副作用

#### 查看已有的防火墙规则

- ```bash
  
  Usage: show rule name=<string>
        [profile=public|private|domain|any[,...]]
        [type=static|dynamic]
        [verbose]
  
  Remarks:
  
        - Displays all matching rules as specified by name and optionally,
          profiles and type. If verbose is specified all matching rules are
          displayed.
  
  Examples:
  
        Display all dynamic inbound rules:
        netsh advfirewall firewall show rule name=all dir=in type=dynamic
  
        Display all the settings for all inbound rules called
        "allow browser":
        netsh advfirewall firewall show rule name="allow browser" verbose
  ```

  

- 查看已知的某个具体防火墙规则配置(比如我想查看名为blockfirefox)的防火墙规则

  - ```bash
    netsh advfirewall firewall show rule name=blockfirefox
    ```

  - ```bash
    
    Rule Name:                            blockFirefox
    ----------------------------------------------------------------------
    Enabled:                              No
    Direction:                            Out
    Profiles:                             Domain,Private,Public
    Grouping:                             
    LocalIP:                              Any
    RemoteIP:                             Any
    Protocol:                             Any
    Edge traversal:                       No
    Action:                               Block
    
    Rule Name:                            blockFirefox
    ----------------------------------------------------------------------
    Enabled:                              No
    Direction:                            Out
    Profiles:                             Domain,Private,Public
    Grouping:                             
    LocalIP:                              Any
    RemoteIP:                             Any
    Protocol:                             Any
    Edge traversal:                       No
    Action:                               Block
    Ok.
    
    ```

    - 上面出现了两条规则的详情,是因为我有两条规则重名了
    - 通常,如果匹配到多条规则,就应该小心,这种情况下,建议使用`wf.msc`GUI程序修改其中的一条规则为新的名字

- 列举并查看所有已存在的防火墙规则配置

  - ```bash
    netsh advfirewall firewall show rule name=all
    ```

    

#### 修改已有防火墙规则

- 例如

  - ```bash
    PS C:\Users\cxxu\Desktop> netsh advfirewall firewall set rule name="blockFirefox" new enable=no
    
    Updated 2 rule(s).
    Ok.
    ```



## 利用GUI操作

### 文档参考

- 更换语言可以在网址中的`zh-cn`和`en-us`修改实现互换

- [Create an Outbound Program or Service Rule (Windows) | Microsoft Learn](https://learn.microsoft.com/en-us/windows/security/threat-protection/windows-firewall/create-an-outbound-program-or-service-rule)

- [(Windows) 创建出站程序或服务规则 | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/security/threat-protection/windows-firewall/create-an-outbound-program-or-service-rule)

  

### 具体操作

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/661079f33f6048b6ad79dfa1351a511c.png)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/186747a235024d0f9a022674f5bd65bf.png)

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/a0d78b97c7ef45e0a8ad14ec3fdb53a6.png)
- 注意,最后一步的名字最好取的清楚一点(只要自己能够认出这个规则是干什么的就行)
  - 这样便于找到创建的规则进行修改/删除
  - 为了便于称呼,把刚才创建的名字记为RE(上例中RE=blockSublimeText)

### 取消控制/禁用

- 如果需要回复被禁止联网的软件,可以回到防火墙**出站**设置界面,找到RE,右键规则,进行禁用/启用规则

## 第三方软件控制

- 例如第三方杀毒软件或者管家,卫士,提供的联网控制功能,甚至可以控制分配给每个软件的带宽
- 但是可能引入额外的开销,所以如果追求简单轻量,使用自带的防火墙来控制基本的软件联网是不错的选择

