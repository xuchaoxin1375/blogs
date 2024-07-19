[toc]

## 本地edge浏览器由组织管理@功能受限检查

- | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/20067bd2f3c148ef9abad6a6beaefa76.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/8bb4a8ed90954a22ab04370b3e0bd2f3.png) |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | 浏览器输入`edge://management/`检查                           | 通过修改注册表(删除edge条目并重启计算机尝试取消意料之外的组织管理导致的功能设置受限) |      |
  
  - [edge://management/](edge://management/)
  
- 
  查询本地edge浏览器功能受限和策略
  

  - 进入`edge://management/`或`edge://policy/`

### 例:侧边栏功能被禁用

- 关键字:HubsSidebarEnabled,到注册表中删除相应关键字

### 解出限制(删除相关注册表条目)

- 命令行方式:在管理员权限下打开cmd或powershell,输入以下内容并回车执行

  - `reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge`

  - ```bash
    PS C:\Users\cxxu\Desktop> reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge
    
    Permanently delete the registry key HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge (Yes/No)? yes
    The operation completed successfully.
    ```

    

- 手动删除方式:打开注册表编辑器(cmd中输入`regedit`),检查并删除以下条目(如果有的话)

  - ```bash
    HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft
    HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft
    ```

- 进入`edge://policy/`;点击重载策略(`Reload Policies`)按钮

  - 或重启计算机;或登出当前windows账户(sign out) 然后重新登录windows

  - 或管理员权限运行`gpupdate /force`刷新注册表

    - ```bash
      PS C:\Users\cxxu\Desktop> gpupdate /force
      Updating policy...
      
      Computer Policy update has completed successfully.
      User Policy update has completed successfully.
      ```

      

### 解除限制检查

- 如果您的edge不再受组织管理的限制,查询的结果为形如:**"Microsoft Edge is not managed by a company or organization"**的提示



### refs

- [Remove Managed by your organization from Microsoft Edge (winaero.com)](https://winaero.com/remove-managed-by-your-organization-from-microsoft-edge/)
- [Why is Edge saying 'Your browser is managed by your organization'? - Microsoft Community](https://answers.microsoft.com/en-us/microsoftedge/forum/all/why-is-edge-saying-your-browser-is-managed-by-your/00d37e82-ffe4-4d6c-ad64-55bb8cda33ee)



## 页面加载问题

### this page having a problem

- [How to Fix ‘Page is Having a Problem’ Error on Microsoft Edge (appuals.com)](https://appuals.com/microsoft-edge-page-is-having-a-problem-error-on-windows-10-11/)
  - 未必有效果,可以考虑用其他浏览器尝试出问题的网页


## 禁止edge更新👺

### refs

- [如何禁用 Microsoft Edge 自动更新 (Windows, Linux, macOS) ](https://zhuanlan.zhihu.com/p/674072446)
- [How to Disable Updates in Microsoft Edge (winaero.com)](https://winaero.com/how-to-disable-updates-in-microsoft-edge/)

- 基本思路是策略组/防火墙/edgeUpdate.exe文件访问权限控制...


### 利用防火墙进制edge更新

- 分段运行下面的脚本即可,用管理员权限打开一个终端后,不需要打开其界面

- 准备工作:获取`edgeupdater.exe`路径

  - 通常这个路径是:`"C:\Program Files (x86)\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe"`;

  - ```powershell
    # 以管理员权限打开一个shell窗口,保证防火墙能够顺利配置
    # 创建一个正则表达式对象
    $path_raw = 'reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\edgeupdate /v ImagePath' | Invoke-Expression
    $regex = [regex] '"(.*)"'
    # 对字符串执行匹配并获取所有匹配项
    $all_matches = $regex.Matches($path_raw)
    $edge_updater_path = $all_matches[-1].Value -replace '"', ''
    
    Write-Host $edge_updater_path
    #通常这个路径是:"C:\Program Files (x86)\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe"
    
    #设置接下来要操作的防火墙规则名字
    $deu="Disable Edge Updates"
    ```

- 添加防火墙

  - ```bash
    #修改防火墙需要管理员权限,因此在此操作之前,以管理员权限打开一个shell窗口(如果已经处于管理员窗口,则直接执行下面的语句)
    netsh advfirewall firewall add rule name=$deu dir=out action=block program=$edge_updater_path
    ```

### 恢复更新

- ```powershell
  #将禁止edge update的规则禁用,就是恢复edge update
  $deu = "Disable Edge Updates"
  netsh advfirewall firewall set rule name=$deu new enable=no
  
  ```

### powershell函数👺

- ```powershell
  
  function Get-EdgeUpdaterPath
  {
      <# 
      .SYNOPSIS
      获取edge update的路径并返回,通常不会直接调用,而是由Set-EdgeUpdater调用
      #>
      # 以管理员权限打开一个shell窗口,保证防火墙能够顺利配置
      # 创建一个正则表达式对象
      $path_raw = 'reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\edgeupdate /v ImagePath' | Invoke-Expression
      $regex = [regex] '"(.*)"'
      # 对字符串执行匹配并获取所有匹配项
      $all_matches = $regex.Matches($path_raw)
      $edge_updater_path = $all_matches[-1].Value -replace '"', ''
  
      return $edge_updater_path
      #通常这个路径是:"C:\Program Files (x86)\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe"
  
  }
  ```

- ```powershell
  
  function Set-EdgeUpdater
  {
      <# 
      .SYNOPSIS
      设置edge update是否启用(通过配置防火墙实现)
  
      #>
      param(
          [switch]$Enable,
          [switch]$Disable
      )
      $deu = 'Disable Edge Updates'
      if ($Enable)
      {
          #将禁止edge update的规则禁用,就是恢复edge update
          netsh advfirewall firewall set rule name=$deu new enable=no
  
      }
      elseif ($Disable)
      {
          #方案1:删除防火墙规则(比较简单的做法)
          # netsh advfirewall firewall delete rule name=$deu
          # 方案2:禁用防火墙规则(为了避免反复配置相同的规则,需要一定的判断逻辑,更加安全)
          netsh advfirewall firewall show rule name=$deu
          if ($?)
          {
              Write-Output 'there is already a rule of disable edge update,enable it...'
              netsh advfirewall firewall set rule name=$deu new enable=yes
          }
          else
          {
  
              Write-Output 'create a new rule of disable edge update...'
              $edge_updater_path = Get-EdgeUpdaterPath
              #修改防火墙需要管理员权限,因此在此操作之前,以管理员权限打开一个shell窗口(如果已经处于管理员窗口,则直接执行下面的语句)
              netsh advfirewall firewall add rule name=$deu dir=out action=block program=$edge_updater_path
          }
      }
      # 配置完检查结果
      netsh advfirewall firewall show rule name=$deu
  }
  ```

- 运行示例

  - ```bash
     .EXAMPLE
     禁止edge更新
        PS>set-EdgeUpdater -Disable
      
        Rule Name:                            Disable Edge Updates
        ----------------------------------------------------------------------
        Enabled:                              Yes
        Direction:                            Out
        Profiles:                             Domain,Private,Public
        Grouping:
        LocalIP:                              Any
        RemoteIP:                             Any
        Protocol:                             Any
        Edge traversal:                       No
        Action:                               Block
        Ok.
      
        there is already a rule of disable edge update,enable it...
      
        Updated 1 rule(s).
        Ok.
  
  
        Rule Name:                            Disable Edge Updates
        ----------------------------------------------------------------------
        Enabled:                              Yes
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
  
    

### 防火墙状态检查

- 检查防火墙规则

  - ```bash
    $deu="Disable Edge Updates"
    netsh advfirewall firewall show rule name=$deu
    ```

- 结果示例

  ```
  
  <# 
  PS>netsh advfirewall firewall show rule name=$deu
  
  Rule Name:                            Disable Edge Updates
  ----------------------------------------------------------------------
  Enabled:                              Yes
  Direction:                            Out
  Profiles:                             Domain,Private,Public
  Grouping:
  LocalIP:                              Any
  RemoteIP:                             Any
  Protocol:                             Any
  Edge traversal:                       No
  Action:                               Block
  Ok.
   #>
  
  ```

  

### 作用范围

- 上述防火墙配置,对于本机的各个edge版本都同时起作用,包括**正式版和预览版**

#### 个别版本更新

- 假设我想要更新正式版,而预览版保留旧版,则可以打开系统的网络计费模式
- 关闭防火墙规则(恢复edge  update联网)
- 进入正式版edge,打开计费流量仍然下载,更新
- 重新启用防火墙,流量计费可关闭也可不关闭

## edge版本更新日志👺

版本发布日志和功能变迁

- 最近几个版本[Stable Channel Release Notes (microsoft.com)](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-relnote-stable-channel)
- 早期的版本[Stable Channel archived release notes (microsoft.com)](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-relnote-archive-stable-channel)

### 重大功能改动日志

- 110版本推出screen split功能,一个屏幕内打开两个无缝相邻的网页

- 117版本移出了许多功能,比如阅读模式中的语法工具等 [Archived release notes for Microsoft Edge Stable Channel | Microsoft Learn](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-relnote-archive-stable-channel#version-1170204531-september-15-2023)

类似的可以看到预览版的发布日志

## 版本回滚

- refs(不一定管用)
  - [Microsoft Edge rollback for enterprises | Microsoft Learn](https://learn.microsoft.com/en-us/DeployEdge/edge-learnmore-rollback)官方文档
  - [How to rollback previous version of Microsoft Edge - Pureinfotech](https://pureinfotech.com/rollback-previous-version-microsoft-edge/)
  - [Edge-Enterprise/edgeenterprise/edge-learnmore-rollback.md at public · MicrosoftDocs/Edge-Enterprise · GitHub](https://github.com/MicrosoftDocs/Edge-Enterprise/blob/public/edgeenterprise/edge-learnmore-rollback.md)

- 并不容易,考虑使用绿色版(便携版或免安装版)
- 对于edge稳定版,仍然会遇到以下问题(稳定性并不好)
  - edge的更新可能会砍掉一些好用的功能,比如智能复制(smart copy/web copy)
  - 组织策略组限制浏览器功能
  - 使得原本可以浏览的某些网页无法正常工作或浏览
- 使用免安装版本就可以避免这些问题

### 官方旧版本edge下载

- 尽管我们推荐使用免安装版本,但是启动方便可能会和系统自带的edge相互影响,导致数据混乱
- 网络上有卸载edge的工具,我没去试,如果卸载后安装旧版本并且阻止自动更新或许是个方法
- 以下是可以找到旧版本的网站
  - 不太旧的版本:[Download Edge for Business (microsoft.com)](https://www.microsoft.com/en-us/edge/business/download?form=MA13FJ) 这个页面底部提供了不太旧的老版本下载
  - 比较旧的老版本:[Microsoft Update Catalog](https://www.catalog.update.microsoft.com/Search.aspx?q=x64+edge)
    - 这里建议使用IDM等高速下载工具下载比较快

### 使用非稳定版与最新稳定版共存

- 虽然edge正式版卸载和版本回滚不容易,但是可以使用非`Stable`版(`Beta,Dev,Canary`)版本,这些版本不仅可以和正式版共存,还容易卸载和回滚旧版本



### 将最新的edge版本制作为便携版

- [UndertakerBen/PorEdgeUpd: Portable Edge (Chromium) Updater (github.com)](https://github.com/UndertakerBen/PorEdgeUpd)
- 目前无法选择旧版本

### 流行的第三方制作的便携版👺

- [RunningCheese Edge官方版下载|历史版本网盘分享丨绿色版下载丨APP下载-123云盘 (123pan.com)](https://www.123pan.com/s/7bzA-wzxOd)
- [RunningCheese Edge  稳定版 - 奔跑中的奶酪(介绍最新制作的版本 网盘里面有历史版本)](https://www.runningcheese.com/edge)

### 便携版edge使用注意事项

- 许多便携版有附带有配置脚本(.bat)

- 运行以后会影响到系统自带的版本

- 比如我下载了两个便携版的edge,两个文件结构目录如下

  - ```bash
    PS [C:\exes\Edge]> tree_lsd -depth 2
     .
    ├──  Edge113
    │   ├──  App
    │   ├── 󰃨 Cache
    │   ├──  Data
    │   ├──  Tools
    │   ├──  开始.bat
    │   └──  说明.txt
    └──  Edge116
        ├──  116.0.1938.69
        ├──  Edge
        ├──  msedge.exe
        ├──  msedge_proxy.exe
        ├──  version.dll
        ├──  优化.bat
        └──  清理.bat
        
    
    ```

- 我个人不会去执行这里的`bat`脚本文件,这可能改动注册表,可能会导致自带的edge部分出错

### 不同的edge版本混用@切换👺

- 想要同时运行连个不同版本的edge有点麻烦,可以试试沙箱类工具

- 但是不同时间段运行不同edge版本则是相对容易做到的,切换版本前先彻底退出前一个正在运行的edge版本

  - 点击菜单里的关闭edge,而不是仅仅关闭所有标签窗口,特别是有些后台服务或后台插件运行着
  - 或者用命令行来关闭`stop-process -name msedge`(powershell),您可以创建一个该命令行的快捷方式方便切换

- 您可以发现了,这些流行便携版的目录里面有2个`msedge.exe`文件

  - 外层那一个是便携版作者会添加一些自带的插件进去
  - 而**内层**的`msedge.exe`则和系统自带的联系比较紧密:
    - 为了便于讨论,这里假设系统的edge版本为A,便携版内层edge版本为B
    - 当系统没有运行edge(或者执行powershell命令:`stop-process -name msedge`)后,若执行便携版就会运行版本B的edge;若执行系统安装的edge则执行版本A
    - 如果系统已经打开了一个edge,其版本记为X(取值为A,或B),那么接下来无论执行便携版或者系统安装版edge都会打开版本为X的edge

- 我有自己的插件习惯,并在系统自带的edge上安装好了,所以我不会运行便携版外部的`msedge.exe`,而是进入到内部文件中去找`msedge.exe`

  - ```powershell
    PS [C:\exes\Edge]> rvpa .\Edge116\116.0.1938.69\msedge.exe
    
    Path
    ----
    C:\exes\Edge\Edge116\116.0.1938.69\msedge.exe
    
    PS [C:\exes\Edge\Edge113\App]> rvpa .\msedge.exe
    Path
    ----
    C:\exes\Edge\Edge113\App\msedge.exe
    
    ```

- 然后创建对应版本的快捷方式到桌面或对快捷方式改名后固定到开始菜单

### 用便携版代替安装版

- 关闭自带edge开机自启(相关服务);
- 将便携版内层的`msedge.exe`创建快捷方式发送到桌面
- 以后通过该快捷方式浏览网页和文件

### 检查或切换当前浏览器版本👺

如果您混用系统自带的edge版本和便携版edge,有时可能会串台

使用`edge:\\versions`来查看(可以收藏到收藏栏,标记为`EdgeVersionEdge`)

此外,还可以用`stop-process -name msedge`来关闭edge,以便您切换版本运行

## 推荐版本

- 由于edge在117版本移除了SmartCopy(很好用的一个功能,被砍了,微软的常规操作👺)

  - [Smart Copy in Microsoft Edge - Microsoft Community](https://answers.microsoft.com/en-us/microsoftedge/forum/all/smart-copy-in-microsoft-edge/7ae1af52-2c58-4a13-8396-032892d4d52d)
  - [Smart Copy feature disappeared on Microsoft Edge browser. - Microsoft Community](https://answers.microsoft.com/en-us/microsoftedge/forum/all/smart-copy-feature-disappeared-on-microsoft-edge/64e03520-099d-49ef-8cb8-bbe15d3db0ee)

- 我推荐110~115版本的(支持智能复制(web select)和数学求解器以及语法工具还有screen split功能,是功能最多的几个版本)

- 但我推荐这几个本中的选择一个,然后找对应的便携版(这样可以通过一定的方法避免系统自带的冲突),用户可以选择系统自带更新到最新版本(可以体验某些新功能和改进,使用更新的chromium内核版本),也可以使用这些固定的老版本(某些好用的功能没有被阉割)

  - [Microsoft Update Catalog 113](https://www.catalog.update.microsoft.com/Search.aspx?q= x64 edge*113)
  - 搜索支持通配符

  ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/91f5b12876aa46e1a9645a9b71820e1d.png)



