[toc]

## ref

- [How can I execute a Windows command line in background? - Super User](https://superuser.com/questions/198525/how-can-i-execute-a-windows-command-line-in-background)
- [stbrenner/SilentCMD: SilentCMD executes a batch file without opening the command prompt window. (github.com)](https://github.com/stbrenner/SilentCMD)

## 前言

- 符号链接和硬链接是好东西,但是他们各自有局限性:
  - 符号链接只能链接文件夹,无法链接文件,可以跨分区链接文件夹
  - 硬链接只能链接文件,且无法跨分区链接文件
- 快捷方式`lnk`可以作为上述技术的补充:
  - Windows 快捷方式是一种特殊的文件类型，它可以链接到其他文件或文件夹，并提供了以下功能和特点：
    1. 快速访问：使用快捷方式可以快速访问目标文件或文件夹，而无需在 Windows 资源管理器中浏览到其所在的位置。
    2. 自定义图标：您可以为快捷方式设置自定义图标，以便更轻松地识别和区分不同的快捷方式。
    3. 可移动性：快捷方式是独立于目标文件或文件夹的文件，因此可以轻松地将它们复制或移动到其他位置。
- 相比之下，软链接和硬链接是一种在 Unix/Linux 系统上常见的链接文件类型,windows也早已支持类似的技术。
- 它们与 Windows 快捷方式类似，但有一些区别：
  1. 链接方式：软链接和硬链接是通过文件系统上的特殊链接文件来创建的，而 Windows 快捷方式是一个独立的文件。
  2. 目标文件类型： Windows 快捷方式可以链接到文件或文件夹,还可以用来作为某个命令行的快捷键
  3. 硬链接的限制：硬链接只能在同一文件系统上创建，而软链接可以跨越不同分区。
- 总的来说，Windows 快捷方式、软链接和硬链接都是在计算机上创建链接的方式。它们各自具有不同的功能和特点，可以根据不同的需求选择使用。

## 快捷方式执行命令行或打开文件

- 假设我想要通过双击桌面上的某个快捷方式来运行某个命令行,可以考虑使用快捷方式来实现.

### eg:直接打开某个文件

- 可以通过资源管理器浏览到指定文件,然后右键创建快捷方式(或发送到桌面)

## 创建快捷方式

- | ![在这里插入图片描述](https://img-blog.csdnimg.cn/c4b6c1e6f9a34d8d850fdd5457bf2321.png) | ![在这里插入图片描述](https://img-blog.csdnimg.cn/c7f1624f43da49628b295429062209cb.png) |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | 输入以下选择:1.路径字符串/2.命令字符串                       | 为快捷方式起名字(可以不带后缀,名字自己能够看懂意思就可以),<br />例子中是我想要typora直接打开存放我的blog的目录,<br />因此取名`Typora_open_blogs` |      |
  |                                                              |                                                              |      |

### eg:快捷方式运行命令

- 例如我希望某个快捷方式系统调用typora直接打开某个目录:
  - `"C:\Program Files\typora\typora.exe d:\repos\blogs\python"`
  - 其中,`"C:\Program Files\typora\typora.exe`是typora.exe的路径(如果您配置了环境变量,可以直接用软件名代替(例如这里的:(`typora.exe`))
  - 而` d:\repos\blogs\python"`是我希望传递给`typora.exe`的参数
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/3cac44258a7b4cba938318cfb5865195.png)



