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


## 禁止edge更新

### refs

- [如何禁用 Microsoft Edge 自动更新 (Windows, Linux, macOS) ](https://zhuanlan.zhihu.com/p/674072446)
- [How to Disable Updates in Microsoft Edge (winaero.com)](https://winaero.com/how-to-disable-updates-in-microsoft-edge/)

- 基本思路是策略组/防火墙/edgeUpdate.exe文件访问权限控制...

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

