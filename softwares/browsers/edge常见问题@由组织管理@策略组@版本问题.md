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

## edge版本更新日志

- [Microsoft Edge release notes for Stable Channel | Microsoft Learn](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-relnote-stable-channel#version-1170204531-september-15-2023)

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

### 使用非稳定版与最新稳定版共存

- 虽然edge正式版卸载和版本回滚不容易,但是可以使用非`Stable`版(`Beta,Dev,Canary`)版本,这些版本不仅可以和正式版共存,还容易卸载和回滚旧版本

## 推荐版本

- 由于edge在117版本移除了SmartCopy(很好用的一个功能,被砍了,微软的常规操作👺)

  - [Smart Copy in Microsoft Edge - Microsoft Community](https://answers.microsoft.com/en-us/microsoftedge/forum/all/smart-copy-in-microsoft-edge/7ae1af52-2c58-4a13-8396-032892d4d52d)
  - [Smart Copy feature disappeared on Microsoft Edge browser. - Microsoft Community](https://answers.microsoft.com/en-us/microsoftedge/forum/all/smart-copy-feature-disappeared-on-microsoft-edge/64e03520-099d-49ef-8cb8-bbe15d3db0ee)

- 我推荐116版本的Beta版(支持智能复制和数学求解器)

  - [Microsoft Update Catalog](https://www.catalog.update.microsoft.com/Search.aspx?q=beta x64 edge*116)
  - 搜索支持通配符

  ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/91f5b12876aa46e1a9645a9b71820e1d.png)



