[toc]

### 递归定位目录下的符号链接

```powershell
#⚡️[Administrator@CXXUDESK][C:\repos\locoySpider][19:10:18][UP:0.01Days]{Git:main}
PS> ls

    Directory: C:\repos\locoySpider

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----            2025/2/5    14:16                标签数据处理
d----            2025/2/5    16:35                采集插件
d----            2025/2/5    14:16                采集规则调试
d----            2025/2/5    18:48                采集规则模板Updating
d----            2025/2/5    11:51                采集流程说明
d----            2025/2/5    18:39                辅助软件
d----            2025/2/5    11:51                网站后台管理
d----            2025/2/5    11:51                已建站点发布记录
d----            2025/2/5    11:44                assets
d----            2025/2/5    11:51                Plugins
d----            2025/2/5    11:51                wp网站设计和调整
-a---           2024/8/21     0:36        4281856 lsd.exe
-a---            2025/2/5    15:19           8852 ReadMe.md
-a---            2025/2/5    15:07           2254 tree.ps1


#⚡️[Administrator@CXXUDESK][C:\repos\locoySpider][19:10:19][UP:0.01Days]{Git:main}
PS> ls -Recurse -Filter assets

    Directory: C:\repos\locoySpider

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----            2025/2/5    11:44                assets

    Directory: C:\repos\locoySpider\assets

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\Plugins

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\wp网站设计和调整

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\已建站点发布记录

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\网站后台管理

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\辅助软件

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\采集插件

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\采集流程说明

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\采集规则模板Updating

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d----            2025/2/5    18:42                assets


```

### 尝试移除这些符号

```powershell

#⚡️[Administrator@CXXUDESK][C:\repos\locoySpider][19:11:35][UP:0.01Days]{Git:main}
PS> ls -Recurse -Filter assets|%{$_.Attributes}
Directory
Directory, ReparsePoint
Directory, ReparsePoint
Directory, ReparsePoint
Directory, ReparsePoint
Directory, ReparsePoint
Directory, ReparsePoint
Directory, ReparsePoint
Directory, ReparsePoint
Directory



#⚡️[Administrator@CXXUDESK][C:\repos\locoySpider][19:12:54][UP:0.01Days]{Git:main}
PS> ls -Recurse -Filter assets|?{$_.Attributes.ToString() -like '*reparsePoint*'}

    Directory: C:\repos\locoySpider\assets

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\Plugins

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\wp网站设计和调整

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\已建站点发布记录

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\网站后台管理

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\辅助软件

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\采集插件

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\

    Directory: C:\repos\locoySpider\采集流程说明

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
l----            2025/2/5    11:28                assets -> C:\Share\df\LocoySpider\assets\




#⚡️[Administrator@CXXUDESK][C:\repos\locoySpider][19:14:22][UP:0.01Days]{Git:main}
PS> ls -Recurse -Filter assets|?{$_.Attributes.ToString() -like '*ReparsePoint*'}|%{Remove-Item $_ -Verbose }
VERBOSE: Performing the operation "Remove Directory" on target "C:\repos\locoySpider\wp网站设计和调整\assets".
VERBOSE: Performing the operation "Remove Directory" on target "C:\repos\locoySpider\已建站点发布记录\assets".
VERBOSE: Performing the operation "Remove Directory" on target "C:\repos\locoySpider\网站后台管理\assets".
VERBOSE: Performing the operation "Remove Directory" on target "C:\repos\locoySpider\辅助软件\assets".
VERBOSE: Performing the operation "Remove Directory" on target "C:\repos\locoySpider\采集插件\assets".
VERBOSE: Performing the operation "Remove Directory" on target "C:\repos\locoySpider\采集流程说明\assets".

```



### 命令行

```powershell
ls -Recurse -Filter assets|?{$_.Attributes.ToString() -like '*ReparsePoint*'}|%{Remove-Item $_ -Verbose }
```

