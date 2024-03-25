[toc]



## abstract

- powershell上的美化
- 文件列表的图标化

##  预览效果

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/35d07c63a8714c74b3232197f5e08397.png)

## Terminal-Icons模块👺

- [devblackops/Terminal-Icons: A PowerShell module to show file and folder icons in the terminal (github.com)](https://github.com/devblackops/Terminal-Icons)

- 如果图标出现乱码,参考:[terminal-icons-windows.md (github.com)](https://gist.github.com/markwragg/6301bfcd56ce86c3de2bd7e2f09a8839)

### 字体推荐

- 文档指出,需要下载Nerd Font字体才能正确显示图标
- 并且,尤其推荐 [LiberationMono](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/LiberationMono.zip)
  - github上下载比较慢,可以网上搜镜像站加速下载链接
  - [从我提供的123盘下载](https://www.123pan.com/s/l7DKVv-9EZsH.html)
- 有些用户比较顺利,随便一个Nerd Font字体就能工作

### 安装和用法

#### Installation



- To install the module from the [PowerShell Gallery](https://www.powershellgallery.com/):

```
Install-Module -Name Terminal-Icons -Repository PSGallery
```



- You can also install it from [Scoop](https://scoop.sh/):

```
scoop bucket add extras
scoop install terminal-icons
```



#### Usage

- 导入模块

- 使用ls查看文件或子目录列表效果

  - ```bash
    Import-Module -Name Terminal-Icons
    
    Get-Item ./README.md
    
    Get-ChildItem
    
    Get-ChildItem | Format-List
    
    Get-ChildItem | Format-Wide
    ```

- 相关命令

| Command                     | Description                                                  |
| --------------------------- | ------------------------------------------------------------ |
| Add-TerminalIconsColorTheme | Add a Terminal-Icons color theme for the current user.       |
| Add-TerminalIconsIconTheme  | Add a Terminal-Icons icon theme for the current user.        |
| Format-TerminalIcons        | Prepend a custom icon (with color) to the provided file or folder object when displayed. |
| Get-TerminalIconsColorTheme | List the available color themes.                             |
| Get-TerminalIconsIconTheme  | List the available icon themes.                              |
| Get-TerminalIconsTheme      | Get the currently applied color and icon theme.              |
| Remove-TerminalIconsTheme   | Removes a given icon or color theme.                         |
| Set-TerminalIconsColorTheme | **DEPRECATED** Set the Terminal-Icons color theme.           |
| Set-TerminalIconsIconTheme  | **DEPRECATED** Set the Terminal-Icons icon theme.            |
| Set-TerminalIconsTheme      | Set the Terminal-Icons icon and/or color theme.              |
| Show-TerminalIconsTheme     | List example directories and files to show the currently applied color and icon themes. |

- 例如`Show-TerminalIconsTheme`可以列出所有图标

## 跨平台的lsd👺

- `lsd`:[Peltoche/lsd: The next gen ls command (github.com)](https://github.com/Peltoche/lsd#installation)
  - 最容易安装
  - 最跨平台
  - 下载包:[Releases · Peltoche/lsd (github.com)](https://github.com/Peltoche/lsd/releases)



## 其他模块

- 有的已经不维护了,通常使用Terminal-Icons配合合适的字体就足够美观了
- [Davlind/PSColor: Provides simple color highlighting for some PowerShell output (github.com)](https://github.com/Davlind/PSColor)
- [pwsh Color](https://www.powershellgallery.com/packages/Color/2.1.0)
- [pwsh Gallery](https://www.powershellgallery.com/packages/Get-ChildItemColor)

###  PScolor模块



- ![在这里插入图片描述](https://img-blog.csdnimg.cn/fb52f94607c34ace941fa21670ac3e83.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_18,color_FFFFFF,t_70,g_se,x_16)

默认情况下

- 目录为蓝绿色
- 文本文件为金黄色
- 二进制文件为灰色
- 隐藏目录为黑色





###  Get-ChildItemColor

- [pwsh Get-ChildItem](https://github.com/joonro/Get-ChildItemColor)
  - 个人比较喜欢的配色


#### 安装过程

```powershell
PS C:\Windows\System32> Install-Module -AllowClobber Get-ChildItemColor

Untrusted repository
You are installing the modules from an untrusted repository. If you trust this repository, change its
InstallationPolicy value by running the Set-PSRepository cmdlet. Are you sure you want to install the modules from
'PSGallery'?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): y
```



###  自定义颜色

#### res

- [Change PowerShell console syntax highlighting colors of PSReadLine – 4sysops](https://4sysops.com/wiki/change-powershell-console-syntax-highlighting-colors-of-psreadline/#:~:text=And if you want to replace the red,Blue%2C Green%2C Cyan%2C Red%2C Magenta%2C Yellow%2C and White.)
  - 获取颜色查看模块:`Install-Module -Name TMOutput`
    - 执行`help TMOutput`尝试获取相关命令
    - 发现执行`show-TMoutputColor`可以获取颜色列表

- github文档有相关的讨论,不过有人反馈方法不生效,我稍加测试,

  - 发现变量`$GetChildItemColorTable`已经变化了

    - ```
      PS D:\repos\web\webLearn> $GetChildItemColorTable
      
      Name                           Value
      ----                           -----
      File                           {.sh, .rb, .fasl, .cdxml…}
      Match                          {LineNumber, Default, Line, Path}
      Service                        {Stopped, Default, Running}
      ```

    - ```
      PS D:\repos\web\webLearn> $GetChildItemColorTable.File|head
      
      Name                           Value
      ----                           -----
      .sh                            Green
      .rb                            DarkYellow
      .fasl                          DarkYellow
      .cdxml                         DarkYellow
      .dll                           DarkGreen
      .css                           DarkYellow
      .bat                           Green
      ```

#### 默认的文件颜色种类分布

```
PS C:\Users\cxxu> $GetChildItemColorTable.File.Values|group
                                                                                           Count Name                      Group
----- ----                      -----
    1 Blue                      {Blue}
    1 Cyan                      {Cyan}
    2 DarkGreen                 {DarkGreen, DarkGreen}
  104 DarkYellow                {DarkYellow, DarkYellow, DarkYellow, DarkYellow…}
    6 Gray                      {Gray, Gray, Gray, Gray…}
    6 Green                     {Green, Green, Green, Green…}
    5 Red                       {Red, Red, Red, Red…}
    6 Yellow                    {Yellow, Yellow, Yellow, Yellow…}


```



- (该变量类型是hashtable)
  - 检测方法:`$GetChildItemColorTable|gm`,第一行将提示变量类型
- `$GetChildItemColorTable.File[".html"]="Magenta" `

下图中,左侧是可用的颜色参考(名称和对照);右侧展示大概的修改方法(临时)

如果想要永久修改,将语句收集,并写入`$profile`文件中(如果没有则创建之)

![在这里插入图片描述](https://img-blog.csdnimg.cn/4bde1a7fbdd44170a7950625ab94aaaf.png)




##  自动导入并启用着色模块

- 将`Import-Module <moduleNamexxxx>` 写入到`$profile`文件中
- `notepad $profile`(创建文件)并写入即可(具体可以搜索更多资料)

### 其他美化项目

- [命令行美化@跨平台的ls列举文件目录着色工具@现代化软件eza@exa_lsd powershell-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/124094106?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"124094106"%2C"source"%3A"xuchaoxin1375"})





