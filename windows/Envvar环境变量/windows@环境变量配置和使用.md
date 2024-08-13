[toc]



## 环境变量

当某个值反复(频繁)被用到,可以考虑为该变量(某个path路径值,当然也可以是其他值(任意字符串,但不可以过分长)设置环境变量,这样可以通过环境变量来快速引用某个值(经常是目录)

还有其他的一些好处:

- Constant special item ID list (CSIDL) values provide a way to identify folders that applications use frequently but may not have the same name or location on any given computer.
- For example, the system folder may be C:\Windows on one computer and C:\Winnt on another. 



##  GUI方法

- 打开系统属性
  - 开始菜单搜索`path`,或者`Edit the system environment variables`,直接跳转到system property界面
  - 更通用的方法:可以通过`Win+R`打开运行窗口或者任意一个命令行窗口(`cmd/powershell`)输入`SystemPropertiesAdvanced.exe `回车执行

- 选择`Environment Variables`按钮,进入配置

###  实例:配置java_home
- [PATH and CLASSPATH (The Java™ Tutorials > Essential Java Classes > The Platform Environment) (oracle.com)](https://docs.oracle.com/javase/tutorial/essential/environment/paths.html)

## 命令行方式配置

- 分别介绍古老而通用的setx以及powershell的方法配置

### 使用Setx命令行工具配置环境变量👺

- [Setting Windows PowerShell environment variables - Stack Overflow](https://stackoverflow.com/questions/714877/setting-windows-powershell-environment-variables)
- [saving-changes-to-environment-variables/about Environment Variables - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables?view=powershell-7.2#saving-changes-to-environment-variables)
- [setx | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/setx)

- On Windows, there are three methods for making `a persistent change` to `an environment variable:` 
  1. setting them in your profile, (仅限从powershell中使用)
  2. using the **SetEnvironmentVariable** method,(此处介绍的方法)
  3. using the System Control Panel.(传统方法)

`setx` 是 Windows 操作系统中的命令行工具，用于设置用户或系统的环境变量，并且这些设置是永久性的，会在新打开的命令提示符窗口中生效。以下是 `setx` 命令的一些常用操作和示例：

### 基本语法

```cmd
setx variable value [/M]
```

- `variable`：你想要设置或修改的环境变量名。
- `value`：你想要赋予该环境变量的值。如果路径中包含空格，记得用双引号将路径包围起来。
- `/M`：可选参数，用于设置系统环境变量，如果不加此参数，默认设置用户环境变量。

### 示例

1. **设置用户环境变量**

   ```cmd
   setx MY_VAR "SomeValue"
   ```

   这将在用户的环境变量中创建一个名为 `MY_VAR` 的变量，其值为 `SomeValue`。

2. **设置系统环境变量**

   ```cmd
   setx MY_SYS_VAR "SystemValue" /M
   ```

   此命令会在系统的环境变量中创建一个名为 `MY_SYS_VAR` 的变量，值为 `SystemValue`。

3. **添加路径到 PATH 变量**

   ```cmd
   setx PATH "%PATH%;C:\NewFolder\bin" /M
   ```

   这个命令会将 `C:\NewFolder\bin` 添加到现有的系统 PATH 变量中，注意使用了 `%PATH%` 来保留原有的 PATH 值。

### 注意事项

- `setx` 设置的环境变量不会影响当前已经打开的命令提示符会话，只会影响后续新打开的窗口。
- 如果变量名已存在，`setx` 会覆盖原有变量的值。
- 在使用包含空格的路径时，确保整个路径被双引号包围。
- 确保 `setx.exe` 可执行文件存在于 `%systemroot%\system32\` 目录下，这是 Windows Vista 及之后版本的标准位置。对于较早的操作系统如 Windows XP，可能需要单独下载 `setx.exe`。
- 使用 `setx` 后，最好重启命令提示符或登录用户以确保环境变量生效。

以上就是关于 `setx` 命令的基本使用方法和示例。

### set和setx

- `set` 和 `setx` 都是 Windows 系统中用于设置环境变量的命令。

  `set` 命令用于设置当前会话的环境变量。这些变量只在当前命令提示符窗口中有效，当你关闭这个窗口后，这些变量也就失效了。

  示例：假设你需要将 `C:\myfolder` 添加到系统的 Path 环境变量中，你可以使用以下命令：

  ```
  Copy Codeset PATH=%PATH%;C:\myfolder
  ```

  注意，此命令只对当前命令提示符窗口有效，如果你打开新的命令提示符窗口，这个环境变量就不存在了。

  `setx` 命令用于设置永久的环境变量，它会将环境变量写入到用户或者系统的注册表中，因此即使你关闭当前命令提示符窗口，这些环境变量仍然存在。

  示例：要将 `C:\myfolder` 添加到系统的 Path 环境变量中，你可以使用以下命令：

  ```
  Copy Codesetx PATH "%PATH%;C:\myfolder"
  ```

  注意，使用 `setx` 命令设置的环境变量不会立即生效，你必须重新启动命令提示符窗口或者注销并重新登录用户账户才能生效。

### 配置用户级环境变量@local environment

- ```cmd
  PS D:\repos\blogs> setx MACHINE Brand1
  
  SUCCESS: Specified value was saved.
  ```

- 配置当前用户,不需要管理员权限就行

### 配置系统级环境变量@ system environment

- ```cmd
  PS D:\repos\blogs> setx MACHINE "Brand1 Computer" /m
  
  SUCCESS: Specified value was saved.
  ```

  - 该操作需要管理员模式
  - 如果某个名字有空格,使用引号包裹起来

### 引用系统变量中的Path变量

- To set the *MYPATH* environment variable in the local environment to use the search <u>path defined in the *PATH* environment variable</u>, type:

- ```cmd
  PS D:\repos\blogs> setx MYPATH %PATH%
  
  SUCCESS: Specified value was saved.
  ```

### 为环境变量追加新值

- ```cmd
  PS D:\repos\configs\env> setx PYTHONPATH "C:\new_path_demo;$env:PYTHONPATH"
  
  SUCCESS: Specified value was saved.
  ```

- 这个命令有风险!(但如果您要修改的变量本身不长,则可以考虑使用该方法)

#### Note@Warning

- 然而,这个命令似乎不是很适合追加新的值到系统Path变量中,容易遇到字符数超过的问题

  - ```cmd
    PS D:\repos\configs\env> setx /M PATH  "$env:path;value_by_setx"
    
    WARNING: The data being saved is truncated to 1024 characters.
    
    SUCCESS: Specified value was saved.
    ```

  - 这个动作可能导致你的环境变量丢失,因为新的值如果超过1024字节,超过部分就会丢失

- 您可以尝试其他命令行工具,或者使用下面的powershell版本

### powershell版👺

- 另见它文:[powershell@修改@删除@添加环境变量_powershell 添加环境变量-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/136134368)

## 总结

- 配置新变量和单值变量可以考虑用`setx`方案,但是不适合配置变量值很长的情况,例如不适合用来配置`PATH`变量,因为它的取值通常是包括各种各样的目录,容易因为过长而被截断,造成数据丢失
- powershell版本的更适合用来追加新值到`path`中



## 使用环境变量👺

### 引用java_home:

用`%java_home%`的形式来引用
这个值可以被win+r(运行程序)使用:


### 可以被cmd使用
查询变量java_home的值:
`echo %java_home%`

###  可以被资源管理器中的地址栏所引用
![在这里插入图片描述](https://img-blog.csdnimg.cn/75fae381c2934ea180353b374a2fa186.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)



####  使用path

- Path变量中的各个值(一般仅保存文件夹(目录)),Path中记录的目录下的子目录或文件都可以被直接引用:
- 比如,我将D:\这个目录添加为Path变量的一个值,同时假设D:\目录下有文件a.txt,目录a 等,那么我们就可以用win+R或cmd中输入a.txt直接打开a.txt(而无需输入a.txt所在目录)
####  查看Path变量的所有值:
###  cmd
在cmd中输入`path`或者`each %path%`
(注意不是%path%)

```bash
C:\Users\cxxu\Desktop>path
PATH=C:\Program Files\PowerShell\7;C:\exes\aria2;C:\exes\;C:\Program Files\PowerShell\7;C:\Program Files\Python311\Scripts\;...
# 或者
C:\Users\cxxu\Desktop>echo %path%
C:\Program Files\PowerShell\7;C:\exes\aria2;C:\exes\;C:\Program Files\PowerShell\7;C:\Program Files\Python311\Scripts\;...
```


###  powershell
`$env:Path  -split ';'`

## 补充

###  节约Path变量值的字符数(推荐做法)

### refs
DOS limits the path to 122 bytes. Every command is limited to 127 bytes; however, 127 - 5 (minus 5 because of PATH=) = 122.
基于此,建议将重复使用的目录前缀单独作为一个变量创建,然后在path中引用该变量(%variableName%),可以达到简化字符串长度的目的(这种限制似乎可以被破解(安装python的时候有一个相关功能))

比如我将`d:\onedrive - pop.zjgsu.edu.cn`提取为单独的环境变量`org`
==注意,单独的环境变量值末尾不宜带有`'\'`==
==否则在转义时会容易出错(用path命令检查可知/win+r报错也可知)==
(当然取决于您在path中的variable中是否使用`\`来连接了)
![在这里插入图片描述](https://img-blog.csdnimg.cn/9b0e39db97d3401ca395acb7c489dd93.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/1c6146419a63424491d48f6bfebc5c2c.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)


详见参考资料:
- [How to set the path and environment variables in Windows](https://www.computerhope.com/issues/ch000549.htm#dospath)
- [MS-DOS and Windows command line path command](https://www.computerhope.com/pathhlp.htm)

[toc] 



## 环境变量

- 通常,环境变量可以细分为
  - 系统环境变量
  - 用户环境变量
- 如果您的计算机只是个人使用,那么通常使用**用户环境变量**已经足够了,并且相关配置在使用命令行的时候不需要进入到管理模式就可以执行
- 但是如果您的计算机包含多个用户,并且希望所有用户都能够用一些共同的环境变量配置,则需要配置**系统环境变量**
- 由于系统环境变量更加具体,所以用户环境变量的值会覆盖掉系统环境变量中的同名变量

### 补充

- 在Windows操作系统中，系统环境变量是所有用户共享的环境变量，用户环境变量是每个用户私有的环境变量。具体来说：

  - 系统环境变量：是在Windows操作系统启动时就加载的环境变量，对所有用户和所有进程都可见。可以在控制面板的“系统”窗口中设置系统环境变量，或者在注册表中的“`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment`”键下设置系统环境变量。
  - 用户环境变量：是每个用户私有的环境变量，只对该用户可见。可以在控制面板的“用户账户”窗口中设置用户环境变量，或者在注册表中的“`HKEY_CURRENT_USER\Environment`”键下设置用户环境变量。

  系统环境变量和用户环境变量都是用来存储系统配置和用户配置的参数信息，例如PATH、TEMP等变量。在编程和系统管理中，常常需要读取和修改这些环境变量的值，以便正确地配置系统和程序。

### HKLM

- "HKLM"代表的是Windows操作系统注册表中的"HKEY_LOCAL_MACHINE"主键，是一个系统范围内的注册表分支，包含了计算机硬件和系统软件的配置信息。

- 其下包含了众多子项和键值，用于存储系统、硬件和软件的配置信息。

  在"HKLM"下的子项包括：

  - HARDWARE：包含了计算机硬件信息；
  - SAM：包含了Windows安全账户管理器信息；
  - SECURITY：包含了Windows安全信息；
  - SOFTWARE：包含了计算机上已安装的所有软件的配置信息；
  - SYSTEM：包含了Windows操作系统的配置信息。

  "HKLM"是Windows操作系统注册表中的一个重要部分，包含了大量的系统配置信息，因此一般不建议用户随意修改或删除其中的信息。如果需要修改或删除"HKLM"中的信息，建议先备份注册表，以免操作失误导致系统故障。

## 列出或查找环境变量值👺

- 另见他文

### 使用reg命令查看

- 例如:

- ```python
  reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH
  ```

- 在windows上,任何长期有效配置环境变量的方式都需要直接或间接操作注册表

- 只不过有些工具简化了相关流程

- 



##  FAQ

- 恢复系统默认环境变量配置
  - [Win10 64位系统环境变量默认值（PATH变量原始值）-联想知识库 (lenovo.com.cn)](https://iknow.lenovo.com.cn/detail/158099.html)

###  使用环境变量前,您需要做的扫尾(状态更新工作)
环境变量修改(添加)完成后,请关闭所有配置窗口(一般有两层窗口,需要点击确认两次,然后关闭相关窗口:
![在这里插入图片描述](https://img-blog.csdnimg.cn/bbc17e5927334b6aa04c285566c6e2a9.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)
####  options up to you
- 关闭已开启(如果有的话)的cmd/powershell/terminal窗口,然后重新开启(如果您要使用刚配置(修改)的环境变量




###  变量配置不成功
如果您确信您的操作是正确的,但是依然没有办法使用该变量
最可能的原因是使用了过多的中间变量(超过2次)
不过,无论是什么原因,都可以利用powershell来检查问题(检查之前确保关闭所有已经打开的powershell(或者windows terminal),然后重新打开一个powershell专门检查(否则无法检测到刚配置的变量)
<hr>

然后借助powershell打开powershell 的`$env:YourEnvName`来查询结果
如果返回了内容,说明配置的值成功写入到系统注册表中
但是,如果您的环境变量引用了超过二重的中间变量,那么系统解析出来的路径将包含有基础变量(以`%`标记出来的)部分,这就导致环境变量无法正常提供服务(解决方案就是减少嵌套)(换句话说,使用绝对路径配置的环境变量就不存在引用过度的问题)
<hr>


演示查询和使用:
(以下终端是经过本人一定的配置才有的效果)
譬如,我想查询`pwsh`这个变量是否被成功配置:
![在这里插入图片描述](https://img-blog.csdnimg.cn/f4b5d6a2a250434080393859f415b616.png)
powershell 返回的路径是一个不带`%`的绝对路径,说明该变量可以被正常使用

某些复杂字符串(而不单单是长路径)都可以通过环境变量记录到系统当中,并以类似的方式查询该字符串
此外,如果我们将某个路径(或者环境变量)添加到path变量中(作为path值数组中的一个元素值),那么powershell 配合PSReadLineKeyHandler 功能模块可以实现补全功能(预览)
甚至,可以使用通配符来查询环境变量下可以搜索到的文件/目录
![在这里插入图片描述](https://img-blog.csdnimg.cn/f3015f4eaf7f41e3934e3910128fa9a3.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)


对于老电脑,可通过`cmd`中运行`set` 命令但是看不到刚配置的环境变量
(或者用`echo yourNewEnvVariable`的形式查询是否配置成功(注意,==查询之前请务必打开新的终端,否则检测不到刚配置的变量.==

某些时候,也可以考虑重启计算机
###  环境变量的非shell(terminal)使用
==windows在这一方面做的不是那么完美==
(特别是win+r(也就是run)窗口在输入某些环境变量时而可以打开,时而说找不到路径(或许是'run'程序的锅吧)
![run窗口](https://img-blog.csdnimg.cn/1770e0ad70bb41019b5402ee963d243d.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_10,color_FFFFFF,t_70,g_se,x_16)
<p align="center">run窗口</p>
<hr>


##  其他可以检查的地方
### 不要在路径变量前面留有空白字符!
(通过cmd下 `set >> env.txt`
输出各个变量值来检查)

打开输出文件:直接在cmd中(接续上一条指令的提示符)输入:
`env.txt`打开查看
![在这里插入图片描述](https://img-blog.csdnimg.cn/b2f3f1b7cd434e91ab8b2aea2756a7d5.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_14,color_FFFFFF,t_70,g_se,x_16)
###  检查path中的值结尾的'\'
如果您发现形如`%variableName%\`的值再path中没有效果,那么可以尝试将`\`去掉保存后重新尝试

单独设置环境变量会比较灵活(复用性好;可以使用`\`来连接相对论路径(可读性也更好)
但是要用%号引用

在path变量中设置目录值:只需要将目标文件(目录)所在的父目录添加到path中的值即可),这样就可以直接用过文件名(目录名)来打开目标
###  仍然不行?
我在配置过程中遇到了使用terminal(cmd)可以访问,但是win+R访问不了的情况,这种可能是由于path中引用的是其他变量的形式(而不是采用采用绝对路径)(前面也提到过)
如果是以路径字面量(而不是将路径赋值给某个其他的环境变量,然后再path中引用的方式)成功率几乎是百分之百

虽然为路径单独设置一个环境变量会比较好管理,但是缺点是成功率不高.
估计是windows对变量引用层数解析限制(不超过2重)

