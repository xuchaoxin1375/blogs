

## 快捷方式执行命令行或打开文件

- 假设我想要通过双击桌面上的某个快捷方式来运行某个命令行,可以考虑使用快捷方式来实现.

### 直接打开某个文件

- 可以通过资源管理器浏览到指定文件,然后右键创建快捷方式(或发送到桌面)

## 创建快捷方式

- | ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/a44077e0e9eb873f55ebd3935969299b.png) | ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/fa7390b8d9417e53d9300b8387bf8be6.png) |      |
  | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
  | 输入以下选择:1.路径字符串/2.命令字符串                       | 为快捷方式起名字(可以不带后缀,名字自己能够看懂意思就可以),<br />例子中是我想要typora直接打开存放我的blog的目录,<br />因此取名`Typora_open_blogs` |      |
  |                                                              |                                                              |      |

### eg:快捷方式运行命令

- 例如我希望某个快捷方式系统调用typora直接打开某个目录:
  - `"C:\Program Files\typora\typora.exe d:\repos\blogs\python"`
  - 其中,`"C:\Program Files\typora\typora.exe`是typora.exe的路径(如果您配置了环境变量,可以直接用软件名代替(例如这里的:(`typora.exe`))
  - 而` d:\repos\blogs\python"`是我希望传递给`typora.exe`的参数
- ![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/b7eae52630e41185e89646e7d8152148.png)