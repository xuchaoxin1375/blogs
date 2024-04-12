[toc]

## 安装python

- 安装python时我们有多种选择
  - 不同系统的方式有所不同,例如linux系统基本都自带python,但是如果版本不满足需要,我们还是需要做升级或者额外安装
  - 对于需要同时使用多个版本的python,使用Conda这类管理软件来管理则是一个常用的做法
- 以windows为例
  1. 官网下载后安装(下载慢,有耐心可以等等,通常是可以下载下来的)
  2. windows命令行工具(比如winget)下载安装(下载慢,甚至下载不下来)
  3. windows 中的Microsoft Store应用商店(下载速度还可以,但是对于老版windows不友好)
  4. 使用**MiniConda**(或Anaconda)来安装python(MiniConda最通用,资源丰富,功能强大,体积会比单独的python安装包大点,但是国内镜像资源多,下载反而是最容易最快的)
  5. 某些论坛其他人通过云盘等方式分享来下载,但是安全性就不能保证了

### 小结

- 考虑到国内的网络环境,我**个人最推荐安装python的方法是用MiniConda简介安装**,好处有
  - 免费跨平台,windows,linux等都可以,新老系统都可以运行
  - 资源丰富,镜像下载快速,而且安装快速(注意是Miniconda快,它够用了;如果是Anaconda因为体积很大,速度就慢不少)
  - 功能强大,可以方便地管理多个python环境

## python下载

### 首推方法:MiniConda安装法

- [Index of /anaconda/miniconda/ | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/?C=M&O=D)
  - 链接具有时效性,如果失效,自行搜索最新链接
  - 按照**时间排序**(从新到旧),选择较新的版本,比如最新版或者上一两个版本都可以
  - 然后如果是windows,就按下`Ctrl+F`搜索`.exe`后缀,通常是x86架构下64位系统的版本(具体根据自己的设备选择),那就是搜索`64.exe`,其他系统类似,苹果(MacOS)找后缀为`.pkg`,linux找后缀`.sh`
  - 作为一个python环境管理工具,后续下载不同python也是简单的时,可以通过换源来高速下载
- Note:
  - Conda很强大,但是对于一个普通用户我们可能用不少全部功能
  - Conda自带一个python版本,例如下载下来的包是:[Miniconda3-py311_24.1.2-0-Windows-x86_64.exe (tsinghua.edu.cn)](https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py311_24.1.2-0-Windows-x86_64.exe)
    - 那么说明软件是MiniConda3版本,而且默认的python版本是py311,即python3.11版本

#### Conda默认python版本

- 安装上述Miniconda包过程中,会有一个选项让你勾选是否将Conda的默认python作为系统的默认python版本
- 如果我们勾上,就可以直接vscode等编辑器识别Conda的python解释器来使用python了;
- 但是这种方式安装的python无法直接在命令行中使用python来启动交互解释器,因为这个安装过程不会将python的家目录和脚本目录注册到Path环境变量中

### 启动

- 安装完Miniconda,可以在开始菜单中搜索`MiniConda`

- 根据自己的习惯,有两个版本powershell版和cmd版,然后将其固定到开始菜单或者创建桌面快捷方式

- 点击默认启动base环境,可以直接调用python

- 输入python即可进入python交互环境

- ```bash
  (base) PS> python
  Python 3.11.7 | packaged by Anaconda, Inc. | (main, Dec 15 2023, 18:05:47) [MSC v.1916 64 bit (AMD64)] on win32
  Type "help", "copyright", "credits" or "license" for more information.
  >>> import sys
  >>> print(sys.executable)
  C:\ProgramData\miniconda3\python.exe
  ```

### 小结

- conda安装和方便(以下指MiniConda)

- 和python官网的安装效果不同在于,conda安装后不会修改path变量,而是创建了2个开始菜单中的快捷方式

- 如果需要在任意命令行中直接可以运行python,需要配置解释器的路径到环境变量Path中,方法和教程很多这里不赘述

- 如果您主要使用powershell,那么配置环境变量就不是必须的

- 操作方法详细可参考:[ Conda的使用(csdn.net)](https://blog.csdn.net/xuchaoxin1375/article/details/128509823)

- 下面是大致的步骤:

  - 以管理员方式打开一个powershell窗口,收入

    - `set-executionPolicy byPass`

  - 先从开始菜单找到miniConda提供的2个命令行快捷方式,选择powershell的那个,以**管理员方式打开**

  - 输入

    - ```powershell
      conda init powershell
      conda config --set auto_activate_base false
      ```

    - 执行完毕后关闭窗口

  - 全新打开一个powershell,就可以直接调用conda命令

  - 然后激活一个环境,默认环境为例:`conda activate`

  - 输入python即可进行交互:

    - ```bash
      PS C:\Users\cxxu> conda activate base #进入conda base环境,base省略不写也可以
      (base) PS C:\Users\cxxu> python #输入python进入交互环境
      Python 3.11.7 | packaged by Anaconda, Inc. | (main, Dec 15 2023, 18:05:47) [MSC v.1916 64 bit (AMD64)] on win32
      Type "help", "copyright", "credits" or "license" for more information.
      >>> 
      #退出
      (base) PS C:\Users\cxxu> 
      ```

      

      

## python环境变量

- 以python3.11为例,从python官网下载的python3.11可以在path变量中注册两个值:

  - 这里我为所有用户安装,所以注册的路径是`C:\program Files`开头的

    ```
    C:\Program Files\Python311\Scripts\
    C:\Program Files\Python311\
    ```

### 检查python安装路径

- 如果不是python官网下载的安装版如何查看当前启动的python是安装在哪里?

- 假设当前命令行中输入python可以进入交互模式

  - 利用powershell查询

    ```powershell
    PS> gcm python|select Version ,Source
    
    Version        Source
    -------        ------
    3.11.9150.1013 C:\Program Files\Python311\python.exe
    ```

  - 利用cmd中的where命令查询

    - ```powershell
      PS>where.exe python
      C:\Program Files\Python311\python.exe
      C:\Users\cxxu\AppData\Local\Microsoft\WindowsApps\python.exe
      ```

      - 后者是Microsoft植入的跳转到应用商店下载的一个启动器,通常不用管
      - 如果您的设备尚未安装可以立即执行的python,则会跳出第二条内容
      - 无法直接查询到conda的python安在哪里

    - 对于conda安装的python,需要先激活一个环境查看

      ```bash
      (base) C:\Users\cxxu>where python
      C:\ProgramData\miniconda3\python.exe
      ```

      - 这里我们就查到了conda安装的python默认位置
      - 不同的环境python解释器位置也不同

- python内置方法查看:启动python,粘贴以下内容查询

  - ```bash
    import sys
    print(sys.executable)
    ```

  - 例如:

    - ```bash
      >>> import sys
      >>> print(sys.executable)
      C:\ProgramData\miniconda3\python.exe
      ```

## 其他下载资源

### python安装包国内镜像

- 官网下载往往是很慢的,可以考虑国内源下载
  - 华为源[Index of python-local (huaweicloud.com)](https://mirrors.huaweicloud.com/python/)
  - 链接可能会失效

### Microsoft Store下载

- 从windows store下载,这里的速度一般还可以,但是安装路径和安装选项不是那么灵活和易于改动
- [Python 3 - Microsoft Apps](https://apps.microsoft.com/detail/9nrwmjp3717k?hl=en-us&gl=US)

### pip 换源下载

- [python@python@本地文档@帮助系统@pip@配置和换源_pip更换国内源-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/121534377)

## 初学者资源

- [在 Windows 上使用 Python（初学者） | Microsoft Learn](https://learn.microsoft.com/zh-cn/windows/python/beginners)





