[toc]

## pyside6*可执行文件

- 如果您使用conda来管理python包,那么当你激活到某个安装了pyside6的环境时才能够直接通过软件名字访问一些pyside6的可执行文件
  - 例如,我使用powershell,在激活了环境`pytorch_CCSER`后,可以通过`gcm pyside6*`列出可以直接执行的二进制文件
  - 而且只要激活了环境,在任何目录下都可以以名字直接执行(仿佛配置了环境变量Path那样)
  - 但是推出了虚拟环境,就无法做到上述的直接用软件名启动软件

- ```bash
  (d:\condaPythonEnvs\pytorch_CCSER) PS D:\repos\blogs> gcm pyside6*|select name,source
  
  Name                         Source
  ----                         ------
  pyside6-assistant.exe        d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-assistant.exe
  pyside6-deploy.exe           d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-deploy.exe
  pyside6-designer.exe         d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-designer.exe
  pyside6-genpyi.exe           d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-genpyi.exe
  pyside6-linguist.exe         d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-linguist.exe
  pyside6-lrelease.exe         d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-lrelease.exe
  pyside6-lupdate.exe          d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-lupdate.exe
  pyside6-metaobjectdump.exe   d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-metaobjectdump.exe
  pyside6-project.exe          d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-project.exe
  pyside6-qml.exe              d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-qml.exe
  pyside6-qmlformat.exe        d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-qmlformat.exe
  pyside6-qmlimportscanner.exe d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-qmlimportscanner.exe
  pyside6-qmllint.exe          d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-qmllint.exe
  pyside6-qmlls.exe            d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-qmlls.exe
  pyside6-qmltyperegistrar.exe d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-qmltyperegistrar.exe
  pyside6-qtpy2cpp.exe         d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-qtpy2cpp.exe
  pyside6-rcc.exe              d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-rcc.exe
  pyside6-uic.exe              d:\condaPythonEnvs\pytorch_CCSER\Scripts\pyside6-uic.exe
  ```

- 主要可执行文件的目录自查:
  
  - 您应该自行在powershell中激活相应环境后,执行命令`gcm pyside6*|select Source| sls designer,uic,rcc`查询自己的结果
  
  ```powershell
  (d:\condaPythonEnvs\pyside6) PS D:\repos\blogs\python> gcm pyside6*|select Source| sls designer,uic,rcc
  
  @{Source=d:\condaPythonEnvs\pyside6\Scripts\pyside6-designer.exe}
  @{Source=d:\condaPythonEnvs\pyside6\Scripts\pyside6-rcc.exe}
  @{Source=d:\condaPythonEnvs\pyside6\Scripts\pyside6-uic.exe}
  ```
  
  - 如果您的系统没有power shell,那么可以通过`where.exe`来查询路径(前提还是要激活环境)
  - Note:尽管您使用`pip show pyside6`查询pyside6的安装路径,遗憾的是,相关可执行文件并不在库目录,而在`Script`目录下
  

### pycharm@idea配置外部工具

- 配置入口:search everywhere->find action:`settings external tool`

#### pyside6-uic的配置

- 将上述路径分别填写:

  - Name,Group等不是重点
  - Program:填写上述命令
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/72eb1370f6ed4691bcef51710a70a610.png)

- 这里需要注意`Arguments`的配置

  - 获取程序帮助:(以`pyside6-uic.exe`)为例

    - 终端执行`pyside6-uic -h`

    - ```bash
      (d:\condaPythonEnvs\pyside6) PS D:\repos\blogs\python> pyside6-uic -h
      Usage: D:\condaPythonEnvs\pyside6\Lib\site-packages\PySide6\uic [options] [uifile]
      Qt User Interface Compiler version 6.4.2
      
      Options:
        -?, -h, --help                  Displays help on commandline options.
        --help-all                      Displays help including Qt specific options.
        -v, --version                   Displays version information.
        -d, --dependencies              Display the dependencies.
        -o, --output <file>             Place the output into <file>
        -a, --no-autoconnection         Do not generate a call to
                                        QObject::connectSlotsByName().
        -p, --no-protection             Disable header protection.
        -n, --no-implicit-includes      Disable generation of #include-directives.
        --postfix <postfix>             Postfix to add to all generated classnames.
        --tr, --translate <function>    Use <function> for i18n.
        --include <include-file>        Add #include <include-file> to <file>.
        -g, --generator <python|cpp>    Select generator.
        -c, --connections <pmf|string>  Connection syntax.
        --idbased                       Use id based function for i18n
        --from-imports                  Python: generate imports relative to '.'
        --rc-prefix                     Python: Generate "rc_file" instead of
                                        "file_rc" import
        --star-imports                  Python: Use * imports
      
      Arguments:
        [uifile]                        Input file (*.ui), otherwise stdin.
      ```

  - 一般的,我们用`pyside6-uic`将`qtDesigner`设计生成的`.ui`文件翻译为`.py`文件

  - 因此根据`pyside6-uic`的使用说明,可以使用`-o`参数将翻译结果输出到指定文件

  - 这在终端中很容易执行,处理`-o`参数,还可以使用`>`将内容导入到指定文件

  - 但是在IDEA/PyCharm中(后面简称为`IDE`,需要注意它不会在指定的终端中执行,也就是说`>`可能方法不会生效,而应该使用`-o`参数

  - 此外,为`.ui`文件输出为`.py`文件的文件名式相同的(只是后缀不同),应该在IDE中使用**宏**(`Macro`)替换(这类似于C语言中的宏那样的作用)

    - 参考文档:
      - [External tools settings | IntelliJ IDEA Documentation (jetbrains.com)](https://www.jetbrains.com/help/idea/2022.3/settings-tools-external-tools.html?utm_source=product&utm_medium=link&utm_campaign=IU&utm_content=2022.3#tool_settings)
      - [Built-in IDE macros | IntelliJ IDEA Documentation (jetbrains.com)](https://www.jetbrains.com/help/idea/2022.3/built-in-macros.html)
      - [Path variables | IntelliJ IDEA Documentation (jetbrains.com)](https://www.jetbrains.com/help/idea/2022.3/absolute-path-variables.html)

- 我推荐的`argument`参数:

  - `$FilePath$ -o ui_$FileNameWithoutExtension$.py`
    - 保留`ui`,这样生成的文件形如`ui.xxxx.py`可以帮助我们清楚的了解这个生成的`.py`是从`.ui`转换而来的

- ref:[Using .ui files from Designer or QtCreator with QUiLoader and pyside6-uic - Qt for Python](https://doc.qt.io/qtforpython/tutorials/basictutorial/uifiles.html)

#### pyside6-designer和pyside6-rcc的配置步骤类似

### 常用的Macros



- | `$FileNameWithoutExtension$` | The name of the file without the extension. This removes only one occurrence of a period followed by an extension.For example, if the file is **hello.txt.txt**, the `$FileNameWithoutExtension$` macro will return **hello.txt**. |
  | ---------------------------- | ------------------------------------------------------------ |
  | `$FileName$`                 | The name of the current file (including all extensions).     |
  | `$FilePath$`                 | The absolute path to the current file.                       |



## 开始@tutorial@pyside🎈

- [Your First QtWidgets Application - Qt for Python](https://doc.qt.io/qtforpython/tutorials/basictutorial/widgets.html)
- [PySide tutorials — PySide v1.0.7 documentation (srinikom.github.io)](https://srinikom.github.io/pyside-docs/tutorials/index.html)
- [Create Python GUIs with PySide2 — Simple GUIs to full apps](https://www.pythonguis.com/pyside6/)

## refs

- [Qt Designer Manual](https://doc.qt.io/qt-6/qtdesigner-manual.html)
- [Pycharm中配置PyQt/PySide开发工具Qt Designer、PyUIC、PyRcc（详细](https://blog.csdn.net/python_sy/article/details/127427968)









