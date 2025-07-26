[toc]



## abstract

wordpress后台登录密码的修改方法有许多,对于普通用户,可以利用旧密码登录到后台,然后在用户管理中修改指定用户的密码

而如果是密码忘记,或者有大量网站需要批量修改密码的情况下,可以考虑使用wp-cli来批量修改,并且这通常被认为是最可靠的方法(虽然速度不是最快的),可以避免加密方式的差异导致的潜在问题(后续会提到)

还有其他方法(不一定可靠,但是操作简单),比如你打算为一批wordpress站点全部修改为同一个密码,这时你可以登录到你的某一个wordress后台,然后将其中的用户(比如admin密码修改为你的新密码)然后通过数据库管理软件,查询此站的数据库中对应的`wp_users`表中的`user_pass`字段,这个字段中的密码是被加密的;然后通过编写脚本的方式操作数据库,将全部wp站点的此表中的`user_pass`修改为相同的值

然而,之所以说这个方法不可靠,是因为不同wordpress网站的加密方式可能不同(即便密码相同,但是加密方式的差异导致存储在数据库中的密码密文会不同),这就导致了多个站使用相同的密码密文覆盖,对应的明文密码也可能不同,就导致新密码在有的站点可以登录,但是有的站点的后台登录不进去

本文主要介绍如何使用wordpress的命令行工具wp-cli来实现密码重置或者批量更新操作

## wp-cli工具修改wp后台指定用户的密码

wp-cli工具是跨平台的,主要支持linux(有完整的功能支持),对于windows提供有限支持,但是大多数功能都是可以用的,修改密码也能工作

### windows

在windows上运行wp-cli工具并不复杂,这里跳过安装步骤的介绍(另见它文),主要介绍如何修改密码,以及当密码中存在特殊字符的情况下如何正确修改

下面使用cmd和powershell来说明

> 执行wp命令前,要求将目录切换到目标wordpress站点的根目录下,否则wp命令找不到网站位置就无法执行修改操作

在cmd中

```cmd
C:\sites\wp_sites\1.it>wp user update admin --user_pass="your_password"
Success: Updated user 1.
```

在powershell中

```powershell
PS> wp user update admin --user_pass='"your_password"'
Success: Updated user 1.
```

注意到,其中的`admin`是你要配置密码的管理员用户名,而`your_password`是你要应用的新密码

尤其是新密码中可能包含一些特殊符号,为了让shell和wp-cli可以正确解释这新密码字符串,通常建议使用`""`来包裹

而且在powershell中,`""`又有一定的特殊含义,因此为了让powershell正确解释新密码,还要再加一层单引号在外部,最后密码写成`'"your_password"'`的形式

#### 常见的错误举例

```powershell
PS> $p='CP&^sM'
PS> wp user update admin --user_pass="$p"
Success: Updated user 1.
'sM' 不是内部或外部命令，也不是可运行的程序
或批处理文件。
```

这个修改过程报错了,并且根据错误可以估计出运行这个命令行时,内部将密码字符串中的`sM`附近解释错误(可能是`&`或`^`符号,将其截断)

```powershell
PS> wp user update admin --user_pass='"CP&^sM"'
Success: Updated user 1.
```

## linux

wp-cli(即wp命令)工具对于权限比较敏感和谨慎,通常要运行于非root用户或权限下,比如使用已经存在的普通用户www的角色来执行wp命令(假设你曾经创建过普通用户www,比如使用宝塔隐含创建www用户)

如果确实想要在root角色下运行wp命令行,可借用已有的普通用户角色身份来运行

考虑到执行在root用户下调用wp默认会报警并不会执行有效操作),因此这里针对root用户使用`sudo -u www wp`来代替直接调用`wp` 来调用wp-cli的功能

### 批量操作

通过shell调用和循环语句,可以实现批量修改