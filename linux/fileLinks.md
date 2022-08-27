## 创建Hardlink

### 权限要求

- 硬链接的创建需要管理员权限
- 只有文件才可以创建硬链接,文件夹(目录)不可以
  - ```powershell
    PS C:\Users\cxxu\Desktop> New-Item -ItemType HardLink -Path todirr -Target $env:desktop\recycleBin\
    New-Item: A file is required for the operation. The item 'C:\Users\cxxu\desktop\recycleBin\' is not a file.
    ```

### 硬链接作用

可以修改一份文件,同时维护到其他关联文件

### 关于硬链接

- [shell script - Determining if a file is a hard link or symbolic link? - Unix &amp; Linux Stack Exchange](https://unix.stackexchange.com/questions/167610/determining-if-a-file-is-a-hard-link-or-symbolic-link)
- 简单的说,就是电脑磁盘上的文件具有0个/1个或多个名字,这些名字就像路牌/指针,系统可以根据指向文件的指针找到文件所在位置(文件实体/文件数据),根据文件系统的组织方式,不同的目录(文件夹)下可以放置了一系列的文件指针,这些指针体现在用户面前就是一个个 `文件`/`目录文件夹`;

#### 删除文件/目录

那么,当用户删除掉某个 `文件`,这意味这什么?

- 实际上,用户删除掉的只是指向文件的一个指针,如果该指针所绑定的文件恰好就这么一个指针,那么你删除掉该指针,就再也不能找到该文件(在哪里了,效果相当于文件没有了(不可寻));
  - 而一些数据恢复技术也是基于此特点实现的(帮助用户找回文件指针,文件就可用了)
- 而如果某个文件不知有一个指针(名字),那么当其中的一个指针被删除,我们仍然可以通过其他的名字找到该文件,也就是文件仍然可以正常别引用!

#### 硬链接的所绑定的target是谁?

- 实际上,通过上述的分析,我们发现,文件的名字其实是平等的,没有谁绑定谁(在文件系统中)所有的路标都是直接指向文件实体,名字和名字之间并无关联,他们唯一的关联就是都直接指向同一个文件;
- 正因为此,我们可以借助已有的硬链接(某一个文件路径path)来创建同等地位的其他硬链接(同一个文件的新路径)(都指向同一个文件)(新的通往"罗马"的道路))
  - 此外,使用powershell查找某个所谓的硬链接(事实上文件系统呈现给用户的文件一般都是硬链接!(处理一些被创建出来的软连接和符号链接)),linktype都是hardlink!

### 获取文件绝对路径

`    $absTarget = (Get-ChildItem $pattern).FullName`

### 注意事项

> 注意,使用-target 相对路径无法成功创建,需要使用绝对路径
> 幸运的是,我们可以利用pwd来优化这一点

以下函数经过一定的处理,使得用户可以仅仅输入相对路径就可以创建符号连接

```powershell

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
    Write-Output '@注意,Target必须使用绝对路径!'
    Write-Output "@当然,也可以是这样的表达式:`"`$pwd\\file`""
    Write-Output '@带上-target 选项'
    if (Test-Path $Path)
    {
        rmFV $Path
    }
    New-Item -ItemType HardLink -Path $Path -Target $absTarget -Force -Verbose
}
```

- 经过初步测试,该函数能够兼容Target 参数为相对路径以及完整路径的情况

### 使用实例

![在这里插入图片描述](https://img-blog.csdnimg.cn/13bd0a17408d4a7a9a73ffbfc33b66a9.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

```powershell
PS D:\repos\scripts\ModulesByCxxu> sudo  newHardLink -Path t1rofileAll.ps1 -target .\readme.md 
D:\repos\scripts\ModulesByCxxu\readme.md will be target!
@D:\repos\scripts\ModulesByCxxu\readme.md
@注意,Target必须使用绝对路径!
@当然,也可以是这样的表达式:"$pwd\\file"
@带上-target 选项
VERBOSE: Performing the operation "Remove File" on target "D:\repos\scripts\ModulesByCxxu\t1rofileAll.ps1".
VERBOSE: Performing the operation "Create Hard Link" on target "Destination: D:\repos\scripts\ModulesByCxxu\t1rofileAll.ps1".

    Directory: D:\repos\scripts\ModulesByCxxu

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          11/25/2021  7:13 PM            652 t1rofileAll.ps1

PS D:\repos\scripts\ModulesByCxxu> sudo  newHardLink -Path t1rofileAll.ps1 -target $PROFILE.AllUsersAllHosts 
D:\program files\powershell\7\profile.ps1 will be target!                                                                                                                            @D:\program files\powershell\7\profile.ps1                                                                                                                                           @注意,Target必须使用绝对路径!                                                                                                                                                      
@当然,也可以是这样的表达式:"$pwd\\file"
@带上-target 选项
VERBOSE: Performing the operation "Remove File" on target "D:\repos\scripts\ModulesByCxxu\t1rofileAll.ps1".
VERBOSE: Performing the operation "Create Hard Link" on target "Destination: D:\repos\scripts\ModulesByCxxu\t1rofileAll.ps1".

    Directory: D:\repos\scripts\ModulesByCxxu

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           3/10/2022 11:10 AM           2920 t1rofileAll.ps1
```
