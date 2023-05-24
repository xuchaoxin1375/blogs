[toc]

## 将mathtype添加到word中

- 先安装office,再安装mathtype,那么这个过程是自动的
- 如果是先安装mathtype,再安装office,那么有以下选择:
  - 重新安装一遍mathtype(比较简单,不需要说明)
  - 执行文件操作

### ref

- [查看、管理和安装 Microsoft 365 程序的加载项 - Microsoft 支持](https://support.microsoft.com/zh-cn/office/查看-管理和安装-microsoft-365-程序的加载项-16278816-1948-4028-91e5-76dca5380f8d?ns=powerpnt&version=19&syslcid=2052&uilcid=2052&appver=zpp190&helpid=133771&ui=zh-cn&rs=zh-cn&ad=cn)

### 查看office安装路径

- 通常,如果是自己通过安装包/安装器安装,那么默认路径形如`C:\Program Files\Microsoft Office\root\Office16`
- 有时并不是这样,但是可以通过开始菜单搜索到office(比如word/ppt/excel)的快捷方式
- 然后右键快捷方式,打开文件所在位置
  - 这时您的窗口跳转到形如`C:\ProgramData\Microsoft\Windows\Start Menu\Programs`的目录
  - 然后右键某个office应用的图标,点击属性,就可以查看到安装目录
- 还有其他方法查看快捷方式指向的目录
  - 使用powershell命令行的方式查看[powershell@CLI命令行创建和修改windows快捷方式shortcuts_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/129276484)
  - 使用第三方工具,例如[voidtools|everything](https://www.voidtools.com/zh-cn/)
  - 它们都是很有用的工具

### 命令行法

- 首选,用**管理员权限(方式**打开powershell

- 本方法默认对office 2016或者更高的版本有效(安装路径默认的情况下,建议按照上述方法查找到office安装目录)

  - ```powershell
    PS C:\Program Files (x86)\MathType\Office Support\64> ls
    
            Directory: C:\Program Files (x86)\MathType\Office Support\64
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         9/23/2019   8:33 PM         263781   MathType AddIn (PowerPoint 2010).ppam
    -a---         9/23/2019   8:33 PM         263473   MathType AddIn (PowerPoint 2013).ppam
    -a---         9/23/2019   8:33 PM         263473   MathType AddIn (PowerPoint 2016).ppam
    --r--         9/23/2019   8:33 PM         952660   MathType Commands 2010.dotm
    --r--         9/23/2019   8:33 PM         952660   MathType Commands 2013.dotm
    lar--         9/23/2019   8:33 PM         952660   MathType Commands 2016.dotm
    la---         9/23/2019   8:33 PM          28160   WordCmds.dot
    ```

    



- 关闭所有office应用🎈(如果有打开的文档,保存后关闭)

- 函数:创建硬链接的工具函数(必须)

  - ```powershell
    
    function newHardLink
    {
        param(
            $Path = 'slides.md',
            [String]$target 
        )
        # 下面这段判断处理可有可无
        <# if ($target.ToString().StartsWith(".\")) {
            $target=$target.TrimStart(".\")
        } #>
        # $absTarget = "$pwd\" + "$target"
        $absTarget = (Get-ChildItem $target).FullName
        Write-Output "$absTarget will be target!"
        # $absTarget = Invoke-Expression $absTarget
        Write-Output "@$absTarget"
        # $absTarget = $pwdPrefix + $target
    
        if (Test-Path $Path)
        {
            rm -force -R $Path
        }
        New-Item -ItemType HardLink -Path $Path -Target $absTarget -Force -Verbose
    }
    #设置别名
    set-alias hardlink newHardLink
    
    
    ```

    

- 命令行操作(加载mathtype的powershell命令行脚本,您可能需要检查一下(修正)

  - 位数

  - 软件安装路径

  - 版本(2016之前还是之后)

- 如果是较新版本,一般不需要改动

  ```powershell
  #默认位64位的office,如果不是,则改为32
  #请使用管理员模式运行!🎈
  $bits=64
  $mathtype_home="C:\Program Files (x86)\mathtype";
  $mathPage="$mathtype_home\mathpage\$bits"
  $office_startup="C:\Program Files\Microsoft Office\root\Office16\STARTUP"
  $ofs="$mathtype_home\Office Support\$bits"
  #$ofs="$mathtype_ofs"
  $MPW="MathPage.wll"
  $MC_dotm="MathType Commands 2016.dotm"
  $MC_ppam="MathType AddIn (PowerPoint 2016).ppam"
  $WC_dot="WordCmds.dot"
  
  cd "$office_startup";
  #ofs files
  $MC_dotm,$WC_dot|%{hardlink -path $_ -target "$ofs\$_"}
  
  hardlink -path $MPW -target "$mathpage\$MPW"
  
  $ppt_addins="$home\AppData\Roaming\Microsoft\AddIns"
  hardlink -path "$ppt_addins\$MC_ppam" -target "$ofs\$MC_ppam"
  
  
  
  
  
  ```

### Note

- 如果您的Mathtype和Office不是安装在同一个目录下的,那么将无法顺利使用`hardlink`函数创建硬链接,这是一令人遗憾的限制,硬链接不像直接复制那样会占用额外的磁盘

- 如果无法用`hardlink`,那么可以将`hardlink`替换为`copy`,同时,删除掉`-target`(也可以把``target`替换为`destination` 

#### 附

- 测试版(仅用于观察运行过程,请使用上面一段)

  ```powershell
  #默认位64位的office,如果不是,则改为32
  #请使用管理员模式运行!🎈
  $bits=64
  $mathtype_home="C:\Program Files (x86)\mathtype";
  $mathPage="$mathtype_home\mathpage\$bits"
  $office_startup="C:\Program Files\Microsoft Office\root\Office16\STARTUP"
  $ofs="$mathtype_home\Office Support\$bits"
  #$ofs="$mathtype_ofs"
  $MPW="MathPage.wll"
  $MC_dotm="MathType Commands 2016.dotm"
  $MC_ppam="MathType AddIn (PowerPoint 2016).ppam"
  $WC_dot="WordCmds.dot"
  #测试语句
  # $MPW,$MC_ppam,$WC_dot|%{hardlink -path $_ -target ""}
  #$ht={$MPW=$mathpage;$MC_dotm=$ofs;$MC_ppam=$ofs;$WC_dot=$fos}
  
  cd "$office_startup";
  #ofs files
  $MC_dotm,$WC_dot|%{hardlink -path $_".test" -target "$ofs\$_"}
  
  hardlink -path $MPW+".test" -target "$mathpage\$MPW"
  
  $ppt_addins="$home\AppData\Roaming\Microsoft\AddIns"
  hardlink -path "$ppt_addins\$MC_ppam"+".teset" -target "$ofs\$MC_ppam"
  
  
  ```

### PPT中使用mathtype

- 如果您已经顺利运行了上述脚本,那么打开powerpoint
- 点击文件->选项->加载项->[管理:COM加载项(旁边小三角型)]->[PowerPoint加载项]->[转到]->[添加]->双击[`MathType AddIn (PowerPoint 2016).ppam`文件]->确认即可



