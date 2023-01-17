@[toc]

#  jupyter的特点

- 相较于IDLE的简单交互,jupyter环境在此基础上提供了类似于matlab的变量空间,您可以方便且直观的观察当前工作空间中具有的哪些变量以及他们的值


- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210626202918585.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)


## 安装jupyter 

- [Project Jupyter | Installing Jupyter](https://jupyter.org/install)
- Installing Jupyter
  - [JupyterLab](https://jupyter.org/install#jupyterlab)
  - [Jupyter Notebook](https://jupyter.org/install#jupyter-notebook)
  - [Voilà  ](https://jupyter.org/install#voilà)

### 安装notebook

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

  - ```bash
    (d:\condaPythonEnvs\pyside6) PS D:\repos\PythonLearn> conda list
    # packages in environment at d:\condaPythonEnvs\pyside6:
    #
    # Name                    Version                   Build  Channel
    anyio                     3.6.2                    pypi_0    pypi
    argon2-cffi               21.3.0                   pypi_0    pypi
    argon2-cffi-bindings      21.2.0                   pypi_0    pypi
    arrow                     1.2.3                    pypi_0    pypi
    asttokens                 2.2.1                    pypi_0    pypi
    attrs                     22.2.0                   pypi_0    pypi
    backcall                  0.2.0                    pypi_0    pypi
    beautifulsoup4            4.11.1                   pypi_0    pypi
    bleach                    5.0.1                    pypi_0    pypi
    bzip2                     1.0.8                he774522_0    defaults
    ca-certificates           2022.10.11           haa95532_0    defaults
    certifi                   2022.12.7       py310haa95532_0    defaults
    cffi                      1.15.1                   pypi_0    pypi
    colorama                  0.4.6                    pypi_0    pypi
    comm                      0.1.2                    pypi_0    pypi
    debugpy                   1.6.5                    pypi_0    pypi
    decorator                 5.1.1                    pypi_0    pypi
    defusedxml                0.7.1                    pypi_0    pypi
    entrypoints               0.4                      pypi_0    pypi
    executing                 1.2.0                    pypi_0    pypi
    fastjsonschema            2.16.2                   pypi_0    pypi
    fqdn                      1.5.1                    pypi_0    pypi
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

    

##  文本编辑界面的jupyter单元格界定标记符:

### 自定义cell maker:

- setting id:`jupyter.defaultCellMarker`

- 利用标记(安装jupyter插件后)
- `#%%`(标记可以后期修改)
- 并执行run(鼠标点击/快捷键出发),可以打开右侧交互窗口
- 例如:
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210626195522747.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
- 定义的单元格:
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210626201822405.png)



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