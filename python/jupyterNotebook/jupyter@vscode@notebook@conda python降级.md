[toc]

#  jupyter的特点

- 相较于IDLE的简单交互,jupyter环境在此基础上提供了类似于matlab的变量空间,您可以方便且直观的观察当前工作空间中具有的哪些变量以及他们的值


- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210626202918585.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)


## 安装jupyter 的产品

- [Project Jupyter | Installing Jupyter](https://jupyter.org/install)
- 有三个产品
  - [JupyterLab](https://jupyter.org/install#jupyterlab)
  - [Jupyter Notebook](https://jupyter.org/install#jupyter-notebook)(重点)
  - [Voilà  ](https://jupyter.org/install#voilà)

- Jupyter是一个开源计算工具，支持多种编程语言，用于创建和共享文档，包括代码、方程式等。而Notebook则是 Jupyter 的一种应用程序，它为用户提供了一个交互式的环境，可以在其中编辑、运行、存储和共享 Jupyter 笔记本。

  因此，Jupyter 和 Notebook 的关系是，Jupyter 是一个支持多种编程语言的开源计算工具，而 Notebook 则是其中的一个应用程序，提供了一个交互式环境，用于编辑和运行 Jupyter 笔记本。同时，Jupyter 还支持其他应用程序，如 JupyterLab 等。

### 安装notebook

#### pip 方式安装

- `pip install notebook`

- ```bash
  (d:\condaPythonEnvs\pyside6) PS D:\repos\PythonLearn> pip install notebook
  Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple
  Collecting notebook
    Downloading https://pypi.tuna.tsinghua.edu.cn/packages/db/40/2d321ba572dc9a94a090d92c9826291a1dcee1e05bc6c1d641ce419b701d/notebook-6.5.2-py3-none-any.whl (439 kB)
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 439.1/439.1 kB 1.7 MB/s eta 0:00:00
       ...
  ```

- 检查安装情况:

  - 上述代码是再conda创建的环境(pyside6)中使用pip安装

  - 可以使用`conda list` 列出包的变化;使用`pip list`也可以

    - powershell:`pip list|sls jupyter`
  
  - ```bash
    (d:\condaPythonEnvs\pyside6) PS D:\repos\PythonLearn> conda list
    # packages in environment at d:\condaPythonEnvs\pyside6:
    #
    # Name                    Version                   Build  Channel
    ...
    
    idna                      3.4                      pypi_0    pypi
    ipykernel                 6.20.1                   pypi_0    pypi
    ipython                   8.8.0                    pypi_0    pypi
    ipython-genutils          0.2.0                    pypi_0    pypi
    isoduration               20.11.0                  pypi_0    pypi
    jedi                      0.18.2                   pypi_0    pypi
    jinja2                    3.1.2                    pypi_0    pypi
    jsonpointer               2.3                      pypi_0    pypi
    jsonschema                4.17.3                   pypi_0    pypi
    jupyter-client            7.4.9                    pypi_0    pypi
    jupyter-core              5.1.3                    pypi_0    pypi
    jupyter-events            0.6.3                    pypi_0    pypi
    jupyter-server            2.1.0                    pypi_0    pypi
    jupyter-server-terminals  0.4.4                    pypi_0    pypi
    jupyterlab-pygments       0.2.2                    pypi_0    pypi
    libffi                    3.4.2                hd77b12b_6    defaults
    markupsafe                2.1.1                    pypi_0    pypi
    matplotlib-inline         0.1.6                    pypi_0    pypi
    ....
    ```
  
  - ```bash
    (d:\condaPythonEnvs\pyside6) PS D:\repos\PythonLearn> pip list
    Package                  Version
    ------------------------ -----------
    anyio                    3.6.2
    argon2-cffi              21.3.0
    argon2-cffi-bindings     21.2.0
    arrow                    1.2.3
    asttokens                2.2.1
    attrs                    22.2.0
    autopep8                 2.0.1
    backcall                 0.2.0
    beautifulsoup4           4.11.1
    bleach                   5.0.1
    certifi                  2022.12.7
    cffi                     1.15.1
    colorama                 0.4.6
    comm                     0.1.2
    debugpy                  1.6.5
    decorator                5.1.1
    defusedxml               0.7.1
    entrypoints              0.4
    executing                1.2.0
    fastjsonschema           2.16.2
    fqdn                     1.5.1
    idna                     3.4
    ipykernel                6.20.1
    ipython                  8.8.0
    ipython-genutils         0.2.0
    isoduration              20.11.0
    jedi                     0.18.2
    Jinja2                   3.1.2
    jsonpointer              2.3
    jsonschema               4.17.3
    jupyter_client           7.4.9
    jupyter_core             5.1.3
    jupyter-events           0.6.3
    jupyter_server           2.1.0
    jupyter_server_terminals 0.4.4
    jupyterlab-pygments      0.2.2
    ```
  

#### jupyter notebook 使用文档

- [The Jupyter Notebook — Jupyter Notebook 6.5.3 documentation (jupyter-notebook.readthedocs.io)](https://jupyter-notebook.readthedocs.io/en/stable/index.html)

### jupyter 安装信息

- ```bash
  PS C:\Users\cxxu\Desktop> jupyter --version
  Selected Jupyter core packages...
  IPython          : 8.8.0
  ipykernel        : 6.20.1
  ipywidgets       : not installed
  jupyter_client   : 7.4.9
  jupyter_core     : 5.1.3
  jupyter_server   : 2.1.0
  jupyterlab       : not installed
  nbclient         : 0.7.2
  nbconvert        : 7.2.7
  nbformat         : 5.7.3
  notebook         : 6.5.2
  qtconsole        : not installed
  traitlets        : 5.8.1
  ```

- 上面查询出的有版本号的packages可以作为有效的`subcommand`

  - 例如`jupyter notebook`
    - `jupyter nbconvert`

- `jupyter <subcommand> `命令帮助:

  - 例如

    ```bash
    (d:\condaPythonEnvs\pt2.0) PS D:\repos\CCSER\d2l-zh> jupyter nbconvert -h
    This application is used to convert notebook files (*.ipynb)
            to various other formats.
    
            WARNING: THE COMMANDLINE INTERFACE MAY CHANGE IN FUTURE RELEASES.
    
    Options
    =======
    The options below are convenience aliases to configurable class-options,
    as listed in the "Equivalent to" description-line of the aliases.
    To see all configurable class-options for some <cmd>, use:
        <cmd> --help-all
    ...
    --to=<Unicode>
        The export format to be used, either one of the built-in formats
                ['asciidoc', 'custom', 'html', 'latex', 'markdown', 'notebook', 'pdf', 'python', 'qtpdf', 'qtpng', 'rst', 'script', 'slides', 'webpdf']
                or a dotted object name that represents the import path for an
                ``Exporter`` class
        Default: ''
        Equivalent to: [--NbConvertApp.export_format]
    ...
    --output=<Unicode>
        overwrite base name use for output files.
                    can only be used when converting one notebook at a time.
        Default: ''
        Equivalent to: [--NbConvertApp.output_base]
    --output-dir=<Unicode>
        Directory to write output(s) to. Defaults
                                      to output to the directory of each notebook. To recover
                                      previous default behaviour (outputting to the current
                                      working directory) use . as the flag value.
        Default: ''
        Equivalent to: [--FilesWriter.build_directory]
    ```

### notebook(.ipynb)导出为其他格式@markdown等格式@格式转换🎈

- [nbconvert: Convert Notebooks to other formats — nbconvert 7.2.10 documentation](https://nbconvert.readthedocs.io/en/latest/)

#### 命令行方式

- [Sharing and Publishing Jupyter Notebooks: Exporting the Jupyter Notebook (reproducible-science-curriculum.github.io)](https://reproducible-science-curriculum.github.io/publication-RR-Jupyter/02-exporting_the_notebook/index.html)

- 命令行方式特别擅长于配合脚本语言,批量转换和脚本化

  - ```bash
    (d:\condaPythonEnvs\pt2.0) PS D:\repos\CCSER\d2l-zh\chapter_preliminaries> jupyter nbconvert .\linear-algebra.ipynb --to markdown --output demo.md
    [NbConvertApp] Converting notebook .\linear-algebra.ipynb to markdown
    [NbConvertApp] Writing 16668 bytes to demo.md
    ```

#### GUI方式

- 打开notebook,选择download as ,选择格式即可

### conda 安装🎈notebook

- Install Anaconda or Miniconda if you don’t have it already

- Open a terminal (Anaconda Prompt) and type `conda install jupyter notebook` and press enter

- Wait for the installation to finish and then launch Jupyter Notebook by typing jupyter notebook in the terminal.

- 激活需要安装jupyter notebook的环境后开始安装

  ```bash
  (d:\condaPythonEnvs\ser_keras2_2) PS D:\repos\CCSER\Speech-Emotion-Recognition> conda install jupyter notebook
  Collecting package metadata (current_repodata.json): done
  ....
  ```

  


### 运行@启动 notebook

- `jupyter notebook`

  ```
  Verifying transaction: done
  Executing transaction: done
  (d:\condaPythonEnvs\ser_keras2_2) PS D:\repos\CCSER\Speech-Emotion-Recognition> jupyter notebook
  [I 19:10:43.905 NotebookApp] The port 8888 is already in use, trying another port.
  [I 19:10:43.907 NotebookApp] Serving notebooks from local directory: D:\repos\CCSER\Speech-Emotion-Recognition
  [I 19:10:43.907 NotebookApp] Jupyter Notebook 6.4.3 is running at:
  [I 19:10:43.907 NotebookApp] http://localhost:8889/?token=285f567f2a4562439eccb00e4407e863c8ead92de4eecb6d
  [I 19:10:43.907 NotebookApp]  or http://127.0.0.1:8889/?token=285f567f2a4562439eccb00e4407e863c8ead92de4eecb6d
  [I 19:10:43.907 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
  [C 19:10:43.915 NotebookApp]
  
      To access the notebook, open this file in a browser:
          file:///C:/Users/cxxu/AppData/Roaming/jupyter/runtime/nbserver-19244-open.html
      Or copy and paste one of these URLs:
          http://localhost:8889/?token=285f567f2a4562439eccb00e4407e863c8ead92de4eecb6d
       or http://127.0.0.1:8889/?token=285f567f2a4562439eccb00e4407e863c8ead92de4eecb6d
  d:\condaPythonEnvs\ser_keras2_2\lib\json\encoder.py:257: UserWarning: date_default is deprecated since jupyter_client 7.0.0. Use jupyter_client.jsonutil.json_default.
    return _iterencode(o, 0)
  ```

  

#### 强力安装

- `conda install -n <envName> ipykernel --update-deps --force-reinstall`
  - 如果您用vscode运行jupyter notebook,在没有安装相关依赖时会提示上述命令

## 快捷键🎈

- [The Jupyter Notebook — Jupyter Notebook 6.5.3 documentation (jupyter-notebook.readthedocs.io)](https://jupyter-notebook.readthedocs.io/en/stable/notebook.html#keyboard-shortcuts)
- [Jupyter Notebook Shortcuts. What is Jupyter Notebook? | by Ventsislav Yordanov | Towards Data Science](https://towardsdatascience.com/jypyter-notebook-shortcuts-bf0101a98330)

# notebook 第三方客户端@编辑器

- 类似于vim,notebook分为command mode和edit mode
- First, we need to know that they are **2 modes** in the *Jupyter Notebook App*: **command mode** and **edit mode**. I’ll start with the shortcuts shared between the two modes.

## vscode+notebook🎈

- [Working with Jupyter Notebooks in Visual Studio Code](https://code.visualstudio.com/docs/datascience/jupyter-notebooks)

##  文本编辑界面的jupyter单元格界定标记符

### 自定义cell maker:

- setting id:`jupyter.defaultCellMarker`

- 利用标记(安装jupyter插件后)

- `#%%`(标记可以后期修改)

- 并执行run(鼠标点击/快捷键出发),可以打开右侧交互窗口

- 例如:
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210626195522747.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
  
  



##  配置相关快捷键:

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210626195722466.png)

##  eg:(自用方案)

###  run above:
- Ctrl+k Ctrl+t

###  run current cell:
- ctrl+k ctrl+c

###  insert cell below position:
- ctrl+k ctrl+j

- 或者
- ctrl+k ctrl+p

###  insert cell below:
- ctrl+k ctrl+j

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210626202022640.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)



#  直接编辑.jpynb文件

- 我更喜欢传统界面,许多快捷键比较习惯,其他插件的效果也能不受影响:

##  直接编辑.jpynb文件
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210626195820354.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

#  notebook 异常排除

- 当您的jupyter页面中含有多段代码的时候,如果发现在尝试执行全部执行的时候无法全部执行,那么可以看前面的代码中是否有出错(这会打断执行流)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/8f4532c9fbfc412fbb16d49047986ca7.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAeHVjaGFveGluMTM3NQ==,size_20,color_FFFFFF,t_70,g_se,x_16)

##  使用建议

- 纯jupyter(.ipynb)笔记模式文件虽好,但是在编辑大量逻辑的代码时,还是使用文本编辑模式会更加得心应手一些
  - 大纲视图之类的显示的更加全面,代码也更加紧凑,快捷键也更加习惯
  - 好在jupyter笔记本可以导出为python script文件,这样就可以在文本编辑模式中进行调试等操作(两种模式的切换不会太麻烦)



## 新建jupyter notebook文件

- new create a jupyter file:

- 您可以直接在工作目录下新建文件:以ipynb为后缀的文件

- 也使用 ctrl+shift+p:输入指令`new jupyter`创建
  - 但不那么推荐(需要手动选择保存目录)

## conda python版本降级

- [anaconda - conda install downgrade python version - Stack Overflow](https://stackoverflow.com/questions/43630002/conda-install-downgrade-python-version)

- 激活需要降级的conda环境

- 执行安装特定python版本的指令

  - `conda install python=3.xx.xx`

- Note:

  - 如果你已经基于高版本的python安装许多依赖于高版本的库(包),那么上述命令可能会在依赖方面报错
  - 您可以考虑删除掉依赖于高版本的包,然后重新执行上述命令进行python降级
  - 对于vscode等编辑器或其他IDE,降级成功后需要重启软件,来获取降级后的python版本信息

  

# handcalcs

- the handcalcs github/tutorial:用jupyter notebook可以渲染出公式的一个项目

- 试验片段:

  - ```python
    ##
    import handcalcs.render
    from math import pi,sqrt
    
    %%render
    a = 2
    b = 3
    c = 2*a + b/3
    x= -b+sqrt( b**2 +4*a*c )/(2*a)
    %%tex
    a = 2
    b = 3
    c = 2*a + b/3
    x= -b+sqrt( b**2 +4*a*c )/(2*a)
    ##
    
    ```

    

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/5d0e49827e0041a7b2cd3ab13b2dc237.png)

- [https://github.com/connorferster/handcalcs](https://github.com/connorferster/handcalcs)

- 使用`%%tex`可以生成latex公式:

  - ```bash
    \[
    \begin{aligned}
    a &= 2 
    \\
    b &= 3
    \\
    c &= 2 \cdot a + \frac{ b }{ 3 }  = 2 \cdot 2 + \frac{ 3 }{ 3 } &= 5.000  
    \\
    x &= \left( - b \right) + \frac{ \sqrt { \left( b \right) ^{ 2 } + 4 \cdot a \cdot c } }{ 2 \cdot a }  = \left( - 3 \right) + \frac{ \sqrt { \left( 3 \right) ^{ 2 } + 4 \cdot 2 \cdot 5.000 } }{ 2 \cdot 2 } &= -1.250  
    \end{aligned}
    \]
    ```

    

- $$
  \begin{aligned}
  a &= 2 
  \\
  b &= 3
  \\
  c &= 2 \cdot a + \frac{ b }{ 3 }  = 2 \cdot 2 + \frac{ 3 }{ 3 } &= 5.000  
  \\
  x &= \left( - b \right) + \frac{ \sqrt { \left( b \right) ^{ 2 } + 4 \cdot a \cdot c } }{ 2 \cdot a }  = \left( - 3 \right) + \frac{ \sqrt { \left( 3 \right) ^{ 2 } + 4 \cdot 2 \cdot 5.000 } }{ 2 \cdot 2 } &= -1.250  
  \end{aligned}
  $$

- 某些版本存在bug,上述代码可以在`1.6.0`正常渲染出来