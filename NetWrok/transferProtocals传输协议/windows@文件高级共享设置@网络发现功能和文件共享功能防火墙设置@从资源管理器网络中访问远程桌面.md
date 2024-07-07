[toc]

## 高级共享设置

在 Windows 系统中，“高级共享设置（Advanced Sharing Settings）” 允许用户控制文件和打印机共享的行为。

以下是相关设置的详细介绍：

### 常用选项

后面会重新提及并展开介绍

1. **网络发现（Network Discovery）**：
   - **打开网络发现（Turn on network discovery）**：允许你的计算机查看网络中的其他设备，并被其他设备发现。
   - **关闭网络发现（Turn off network discovery）**：阻止你的计算机查看网络中的其他设备，并阻止其他设备发现你的计算机(也就是无法被扫描到,但是如果对方知道您的ip地址,也可以访问到您的设备,比如可以ping 通,提供凭证后依然可以访问到)。
2. **文件和打印机共享（File and Printer Sharing）**：
   - **打开文件和打印机共享（Turn on file and printer sharing）**：允许其他网络用户访问共享的文件和打印机。
   - **关闭文件和打印机共享（Turn off file and printer sharing）**：阻止其他网络用户访问共享的文件和打印机。

### 其他选项

1. **共享文件夹中的公用文件夹共享（Public Folder Sharing）**：
   - **打开共享以便网络上的任何人访问公用文件夹（Turn on sharing so anyone with network access can read and write files in the Public folders）**：允许网络上的任何人访问和更改公用文件夹中的文件。
   - **关闭公用文件夹共享（Turn off Public folder sharing）**：阻止网络上的其他人访问公用文件夹。
2. **媒体流（Media Streaming）**：
   - **选择媒体流选项（Choose media streaming options）**：设置哪些设备可以访问你的媒体库（例如图片、音乐和视频）。
   - **阻止所有设备（Block all devices from accessing my media）**：不允许任何设备访问你的媒体库。
3. **文件共享连接（File Sharing Connections）**：
   - **使用128位加密以帮助保护文件共享连接（Use 128-bit encryption to help protect file sharing connections）**：提供更高的安全性，适用于大多数网络。
   - **允许使用40-或56位加密以便兼容某些设备（Enable file sharing for devices that use 40- or 56-bit encryption）**：适用于需要较低级别加密的旧设备。
4. **密码保护的共享（Password Protected Sharing）**：
   - **启用密码保护共享（Turn on password protected sharing）**：只有使用用户名和密码登录到你的计算机的用户才能访问共享的文件和打印机。
   - **关闭密码保护共享（Turn off password protected sharing）**：允许网络上的任何人访问共享的文件和打印机，即使他们没有登录你的计算机。

这些设置可以在控制面板的“网络和共享中心”中找到(win11之前的系统),或者在设置中直接搜到(win11)，并且根据你的网络环境和安全需求进行相应调整。

### 操作界面说明

实际上,在windows中进入高级共享设置时,有三个组别,而会有一个组别自动展开,取决于当前的网络类型被设置为哪一个类型,如果是Private network,那么就自动展开Private network这个组别，否则就是Public network 这个组别

![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/d3fde0c5995b4096adb66c35e487d3bd.png)



## 网络类型检查和设置(专用网络和公用网络)👺

[在 Windows 中将 Wi-Fi 网络设置为公共或专用网络 - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/在-windows-中将-wi-fi-网络设置为公共或专用网络-0460117d-8d3e-a7ac-f003-7a0da607448d)

这部分操作会影响到高级共享设置的配置

- **公用网络 (建议)** 。 将此用于在家、工作或公共场所连接到的网络。 在大多数情况下，应使用此。 你的电脑将在网络上的其他设备上隐藏。 因此，**不能将电脑用于文件和打印机共享**。
  - 这种情况下,我们仍然可以ping 通,但是无法发现处于该模式的设备
- **专用网络**。 网络上的其他设备可以发现你的电脑，你可以使用电脑进行文件和打印机共享。 你应该知道并信任网络上的人员和设备。

更改类型(Network profile type)

点击任务栏上的网络图标(wifi或有线以太图标,选择属性即可进入设置)

![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/f1fa896ade204c0296ed444e3803be43.png)

### 设置的独立性

- 对于**文件和打印机共享功能**和**网络发现**功能,无论当前网络选项设置为public network 还是private network,都可以通过手动设置来覆盖掉默认的设置
- 也就是说两种网络类型有默认的防火墙设置,例如public network模式下,网络发现默认禁用,您也可以手动启用，而不是非要切换为专用网络(private network)

### Note

如果切换为公用网络,那么网络发现功能自动失效,只有切换回专用网络选项,才会重新生效

切换通常会立即生效(若干秒内);



## 高级共享设置和防火墙👺

- windows的网络发现功能,以及文件和打印机共享功能的配置都是属于防火墙的配置,配置方式有多种
- 中英文版系统的防火墙规则名不同,您需要根据自己的系统实际情况来运行

![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/18e26b4c9ea64606b476cdeb1b91d538.png)

### 命令行方式👺

- 以下两个命令分别启用**文件和打印机共享**功能和**网络发现功能**

  - 其实我们只需要启用第一个就可以了满足**共享文件(夹)**的需求
  - 当然启用第二个可以方便我们在网络中相互访问

- **文件和打印机共享命令**：

  ```cmd
  #对于中文系统
  netsh advfirewall firewall set rule group="文件和打印机共享" new enable=Yes
  #对于英文系统
  netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
  ```

  - 启用文件和打印机共享功能，开放相关端口，允许网络中的其他设备访问共享资源。

- **网络发现命令**：

  ```cmd
  #对于中文系统
  netsh advfirewall firewall set rule group="网络发现" new enable=Yes
  #对于英文系统
  netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
  ```

  - 启用网络发现功能，使计算机能够发现并被网络中的其他设备发现，增强设备互联和资源共享能力。

- 这两条命令常用于配置家庭或小型办公室网络，以确保设备之间能够方便、安全地共享和访问资源。

  - 您可以复制粘贴以下内容,一并启用

    ```cmd
    #对于中文系统
    netsh advfirewall firewall set rule group="文件和打印机共享" new enable=Yes
    netsh advfirewall firewall set rule group="网络发现" new enable=Yes
    #对于英文系统
    netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
    netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
    
    ```


#### 演示操作

- 演示:以**管理员方式**启动cmd(或powershell)运行上述命令(回车执行)

  - 中文

    ```powershell
    PS C:\Users\cxxu\Desktop> netsh advfirewall firewall set rule group="网络发现" new enable=Yes
    
    已更新 62 规则。
    确定。
    
    PS C:\Users\cxxu\Desktop> netsh advfirewall firewall set rule group="文件和打印机共享" new enable=Yes
    
    已更新 48 规则。
    确定。
    
    ```

    

  - 英文

    ```bash
    PS C:\Users\cxxu\Desktop> netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
    
    Updated 48 rule(s).
    Ok.
    
    PS C:\Users\cxxu\Desktop> netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
    
    Updated 62 rule(s).
    Ok.
    ```

#### 封装为powershell函数

```powershell

function Set-NetworkDiscovery
{
    <#
    .SYNOPSIS
        设置网络网络发现
    .EXAMPLE
        PS> Set-NetworkDiscovery -state on
    .EXAMPLE
        PS> Set-NetworkDiscovery -state off
    #>
    
    param(
        [ValidateSet('on', 'off')]
        [string]
        $state = 'on'
    )
    $switch = ($state -eq 'on') ? 'yes':'no'
    # Write-Host $switch
    netsh advfirewall firewall set rule group="Network Discovery" new enable=$switch

}

function Set-NetworkFileAndPrinterSharing
{
    <#
    .SYNOPSIS
        设置文件和打印机共享
    .EXAMPLE
        PS> Set-NetworkFileAndPrinterSharing -state on
    .EXAMPLE
        PS> Set-NetworkFileAndPrinterSharing -state off
    #>
    
    param(
        [ValidateSet('on', 'off')]
        [string]
        $state = 'on'
    )
    $switch = ($state -eq 'on') ? 'yes':'no'
    # Write-Host $switch
    netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=$switch

}
```



### 使用图形界面方式配置

- 打开设置或控制面板中的高级共享设置页面,这一步可以通过执行以下命令快速完成

  ```cmd
  control /name Microsoft.NetworkAndSharingCenter /page Advanced
  
  ```

- 然后在弹出的页面中选择相应的开关即可(页面中有3个组别,一般只需要操作自动展开的那个组别中暴露的开关即可)



## 网络发现

网络发现（Network Discovery）是 Windows 操作系统中的一项功能，它允许计算机在本地网络中相互发现和通信。当网络发现功能开启时，你的计算机可以看到网络(通常是局域网)中的其他设备，并且其他设备也能发现你的计算机。

虽然网络发现功能不是访问其他设备的必要功能,但是启用改功能有利于(方便)网络中的其他用户或设备之间相互访问



### 网络发现功能的详细介绍

#### 网络发现的作用👺
- **发现其他设备**：允许计算机在同一网络中发现和浏览其他设备（如计算机、打印机和网络存储设备）。
- **被其他设备发现**：使你的计算机能够被网络中的其他设备发现和访问。
- **简化网络共享**：使文件和打印机共享更加简单和直观，**不需要手动输入设备的 IP 地址或名称**。
- 网络发现功能不仅限于windows设备之间相互发现,其他系统也可以发现,比如手机端某些文件管理器(cx file explorer等)可以扫描网络中的可用设备

####  网络发现的工作原理
网络发现使用多种协议来实现设备的发现和通信，包括：
- **LLMNR（Link-Local Multicast Name Resolution）**：用于在本地网络中解析主机名。
- **UPnP（Universal Plug and Play）**：用于自动发现和配置网络设备。
- **NetBIOS over TCP/IP**：一种用于局域网的旧协议。

#### 启用和配置网络发现👺

##### GUI方式启用网络发现
1. [我如何启用网络发现？ (microsoft.com)](https://support.microsoft.com/zh-cn/windows/在-windows-中通过网络共享文件-b58704b2-f53a-4b82-7bc1-80f9994725bf#ID0EFBBBBD-button)
   
   这个文档介绍了启用网络发现的一个简单方案,可以检查是否已经开启以及快捷开启网络发现,还有其他方案,比如在设置或开始菜单里搜**高级共享设置**等方式打开,win10之前的系统可以在控制面板中设置,详情可以另见它文

##### 通过命令提示符启用网络发现
1. **打开命令提示符**：
   - 按 `Win + R`，输入 `cmd`，然后按 Enter。

2. **输入命令启用网络发现**：
   
   - 使用**管理员**身份运行输入以下命令并按 Enter：
     ```cmd
     netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
     ```
   
   - 实际操作
   
     ```cmd
     PS> netsh advfirewall firewall set rule group="Network Discovery" new enable=yes
     
     Updated 62 rule(s).
     Ok.
     ```
   
     如果您想要关闭网络发现,那么把上述命令行中的`yes`改为`no`即可
   
     该方法亲测有效

##### 检查网络发现功能的启用情况

- 在资源管理器中的网络页面如果没有提示您启用网络发现，则表明该功能已经打开
- 也可以在设置中搜索,其实检查方法和启用方法类似

#### 验证网络发现是否生效

##### 使用文件资源管理器
1. 打开“文件资源管理器”。
2. 点击左侧的“网络”。
3. 如果能看到其他设备，说明网络发现功能正常。



### 用例👺

#### 访问远程主机

![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/5f72bf1df5bd48de878963161da22526.png)

仍然以上面的例子,我们可以还通过地址`\\REDMIBOOKPC`来访问名为`REDMIBOOKPC`的主机(通过win+R打开运行窗口,输入`\\REDMIBOOKPC`即可)

还可以通过`\\REDMIBOOKPC\share`来访问`REDMIBOOKPC`的共享目录`share`

或者命令行(cmd或者powershell都可以),用`start`命令打开地址

其实windows不区分路径大小写,因此`\\redmibookpc`和`\\REDMIBOOKPC`是一样的效果

```powershell
PS> start \\redmibookpc
```

如果不启用,则可以增强隐蔽性,但是此时想要访问关闭了网络发现功能的设备资源(比如共享文件夹)时需要知道对方的ip地址

若上述主机的ip地址为`192.168.1.198`访问方式变为`\\192.168.1.198`的方式来访问

#### 访问远程桌面👺

启用网络发现后,还可以方便地请求远程桌面链接,用于访问共享文件夹的用户凭证也可以用来访问远程桌面,如果之前访问过共享文件夹,那么可以直接通过资源管理器中的network(网络页面内右键选择远程桌面)远程控制

### FAQ

#### 资源管理器的网络页加载耗时

- 由于windwos会扫描可用的设备,所以需要一定时间,而且对于系统在扫描网络设备期间可能造成资源管理器加载缓慢和卡顿

**无法发现其他设备**

- 确保所有设备都连接到同一网络。

- 确保其他设备的网络发现功能也已启用。

- 检查防火墙设置，确保没有阻止网络发现。

- 上述配置正确的话,一般不会出问题,另一个问题是循环访问

  - 假设局域网内有2个设备A,B
  - 设备A通过网络发现功能在资源管理器中扫描到并访问了B的共享文件夹
  - 此时设备B尝试扫描A可能会找不到,如果是这样,可以考虑先断开A对B的访问,然后让B访问A

  - 远程桌面确实不允许循环控制

- 对于无法被发现的设备,可以重新开关一下**网络发现**功能,刷新一下状态(或者断开网络重新连接)

**网络类型设置**：

- 确保网络类型设置为“私人”网络，而不是“公用”网络，因为在公用网络中，网络发现通常是关闭的。

**服务状态**：

- 确保以下服务已启动并设置为自动：
  - **Function Discovery Resource Publication**
  - **SSDP Discovery**
  - **UPnP Device Host**

## 文件和打印机共享

Windows操作系统中的文件和打印机共享功能（File and Printer Sharing）允许不同计算机之间共享文件和打印机资源，从而提高办公效率和资源利用率。

[windows@局域网或蓝牙文件传输@共享文件夹@就近共享-CSDN博客](https://cxxu1375.blog.csdn.net/article/details/139986333)
