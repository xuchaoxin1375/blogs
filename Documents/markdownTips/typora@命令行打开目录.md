[toc]



##  命令行下用typora打开指定文件夹(目录)

###  配置环境变量或别名
- 需要通过配置别名,使得命令行可以直接输入typora来打开typora软件
- 一下blog可以提供相关设置方法(熟悉这方面的内容可以跳过)

  - [windows_环境变量创建(environment variables/path)和使用(以java环境配置为例说明)+导出/导入环境变量方法+注册表备份_xuchaoxin1375的博客-CSDN博客_创建环境变量](https://blog.csdn.net/xuchaoxin1375/article/details/119189994?ops_request_misc=%7B%22request%5Fid%22%3A%22167437572216782427490102%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fall.%22%7D&request_id=167437572216782427490102&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~pc_rank_34-1-119189994-null-null.142^v71^pc_new_rank,201^v4^add_ask&utm_term=java_home&spm=1018.2226.3001.4187)
  - [powershell_windows:edit_env_permanently 利用powershell来永久修改环境变量_xuchaoxin1375的博客-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/124459768)
- 以windows下的powershell环境为例,检查配置效果

  - 假设已经配置好typora安装目录到环境变量(或者设置好别名alias)

  - ```bash
    PS C:\Users\cxxu> gcm typora|fl
    
    Name            : Typora.exe
    CommandType     : Application
    Definition      : C:\Program Files\Typora\Typora.exe
    Extension       : .exe
    Path            : C:\Program Files\Typora\Typora.exe
    FileVersionInfo : File:             C:\Program Files\Typora\Typora.exe
                      InternalName:     Typora
                      OriginalFilename: Typora.exe
                      FileVersion:      1.4.8
                      FileDescription:  Typora
                      Product:          Typora
                      ProductVersion:   1.4.8
                      Debug:            False
                      Patched:          False
                      PreRelease:       False
                      PrivateBuild:     False
                      SpecialBuild:     False
                      Language:         English (United States)
    
    ```

### 打开目录的命令

- `typora  <dir>`

  - ```bash
    PS C:\Users\cxxu> typora $desktop
    PS C:\Users\cxxu> typora C:\Users\cxxu\desktop
    PS C:\Users\cxxu> typora "C:\Users\cxxu\desktop"
    PS C:\Users\cxxu> cd $desktop
    PS C:\Users\cxxu\Desktop> typora .
    
    ```
  - 上述4中方式效果一致(`$desktop`是我配置了powershell变量,可以简化书写)

  

### 命令行中直接打开指定markdown文件

- 设置默认应用
  - 在桌面上创建一个markdown文件(设文件名为`demo.md`)(如果已经有markdown文件,则不需要创建)
  - 鼠标选中`demo.md`文件,点击鼠标右键,选中打开方式,选择用typora打开(始终用tyora打开)
  - 这是microsoft提供的设置方法:[更改默认程序Windows - Microsoft 支持](https://support.microsoft.com/zh-cn/windows/更改默认程序windows-e5d82cad-17d1-c53b-3505-f10a32e1894d)(包含win11/win10)
  - 选择**"开始** >**设置>** **应用>** **默认应用"**。
  - 若要更改默认应用，可以执行下列操作之一：
    1. **为文件类型或链接类型设置默认值**
       在搜索栏中，输入你需要的文件类型或链接类型，然后从结果列表中选择它。 你可以选择哪个应用可以打开该文件或链接类型。
    2. **为应用程序设置默认值**
       选择应用以查看它可以打开哪些文件类型或链接类型。 如果要更改内容，请选择文件或链接类型，然后选择首选应用。
- 在命令行中输入需要用typora打开的markdown文件路径,回车打开

