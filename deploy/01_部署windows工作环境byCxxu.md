## edge

>  可靠的浏览器(edge)

*   Microsoft Account login
*   IDM

从云盘下载常用辅助软件(如果是不限速/版本无要求,可以到官网下载)

*   IDM
*   snipaste
*   ditto
*   powershell
*   winXray
*   clash

如果异常,请尝试修复网络/重启(注销)计算机

## git

>  安装版比较省事

确保命令行中git命令可以运行即可

windows下 `credential`选择 `wincred`

首要的仓库:

> 配置文件

*   config:快速将环配置仓库(config)境变量配置克隆并导入
    *   如有必要,修改%exes%

> scripts:脚本部署

*   对应仓库:[config: my config files (gitee.com)](https://gitee.com/xuchaoxin1375/config)
    *   主要是powershell部署(profile+modules)
    *   $profile配置
        *   使用管理员模式打开powershell(wt)
            *   方式1:
                *   `$PROFILE.AllUsersAllHosts`
                *   `notepad $PROFILE.AllUsersAllHosts`
                *   写入内容
            *   方式2:
                *   将现成的$profile文件在管理员模式下复制一份到指定位置
                *   `cp profile.ps1 $PROFILE.AllUsersAllHosts`

### powershell+windowsTerminal

*   删除被绑定的文件夹
*   修改资源管理器中的特殊符号的标识符
    *   d:\\usersbycxxu
        *   下载
        *   文档
        *   视频
    *   onedrive/
        *   图片
        *   音乐
*   部署符号链接

### 电源计划

*   电源键/盒盖操作（hibernate)
*   battery(低电量阈值设定/危险点量执行操作）
*   配置降噪模式（通电时限制cpu主频）

**安装取消**