

[toc]

# vscode和jetbrain@对python的支持@pylance@Linting的启用和关闭

- 目前来看,比起pycharm,在编写小代码片段(比如使用jupyter notebook)时,我更倾向于使用vscode编写代码
  - 遗憾的是,vscode的提示功能性能不如jetbrain系列的产品
  - 特别pylance和linting的性能都明显不如jetbrain系列
- jetbrain系列的IDEA和pycharm用的较少,但是编写复杂代码时,jetbrain是更好的选择
  - 尽管启动速度比较慢(进入UI的速度其实不慢,主要是每次启动都要扫描一次环境)
  - 在编码过程中,它的代码格式化性能是比较好的,特别是当文件比较大时,格式化速度比vscode快的多
  - 比如用它的git工具
  - 模块间的依赖分析
  - 规范化

### python interactive🎈

- 首先确保python环境中安装了`notebook`
- [Working with Jupyter code cells in the Python Interactive window (visualstudio.com)](https://code.visualstudio.com/docs/python/jupyter-support-py)
- 由于相关文档不容易找,在此简述一下
  - IDEA也支持相应功能(额外安装python plugins),再使用notebook cell marker,默认是`# %%`用这个注释符号包围住的内容称为一个`python code cell`
  - IDEA显示代码行号的相应位置(也是打debug断点的位置)会出现运行箭头`绿标`(或者使用右键/快捷键`execute cell in console`)

## vscode对python的支持

- [Editing Python Code in Visual Studio Code](https://code.visualstudio.com/docs/python/editing#_enhance-completions-with-ai)

- 该文档是与时俱进的,介绍了vscode对python的最新支持和相关的配置技巧


## jetbrains 对python的支持

- [Python language support | IntelliJ IDEA Documentation (jetbrains.com)](https://www.jetbrains.com/help/idea/python.html#features)
- 或者直接用`pycharm`

### 重构Refactoring

- [Refactoring source code in Visual Studio Code](https://code.visualstudio.com/docs/editor/refactoring)
- 如今的vscode已经提供了一定程度的重构能力:
  - 表达式抽取为变量
  - 复杂函数的分解抽取
  - 自动导包的支持
  - 导包语句的排序和清理多余导包
  - 模块名重构
- 目前来看,vscode对python的重构支持还是不如jetbrain系列的强大,但是基本的重构功能是具备的,大多数情况下是够用的
  - 但是向模块内的方法或类移动到另一个模块这类的重构,vscode不支持,而jetbrain是支持的

#### 代码片段重构@抽取为函数或方法

- Note:

  - 抽取代码片段为函数(方法)时,不要把片段的注释一起选中,这回导致vscode无法正确处理(识别为无法重构:no refactoring available)

  - 期待后期的版本更新可以修复相关问题

  - ```python
            #将解析结果更新回self对象的相应属性上
            if partition == "train":
                self.train_emotions = emotions_tags
                self.train_features = features
                self.train_audio_paths = audio_paths
            elif partition == "test":
                self.test_emotions = emotions_tags
                self.test_features = features
                self.test_audio_paths = audio_paths
            else:
                raise TypeError("Invalid partition, must be either train/test")
      
    ```

  - 重构:

  - ```python
            #将解析结果更新回self对象的相应属性上
            self.update_balanced_attributes(partition, audio_paths, emotions_tags, features)
      
        def update_balanced_attributes(self, partition, audio_paths, emotions_tags, features):
            if partition == "train":
                self.train_emotions = emotions_tags
                self.train_features = features
                self.train_audio_paths = audio_paths
            elif partition == "test":
                self.test_emotions = emotions_tags
                self.test_features = features
                self.test_audio_paths = audio_paths
            else:
                raise TypeError("Invalid partition, must be either train/test")
      
    ```

    

### 代码格式化@python.formatting.

- [Editing Python Code in Visual Studio Code](https://code.visualstudio.com/docs/python/editing#_formatting)
- 在设置中搜索:`python.formatting.provider`,选择(下载)某一个格式化器(比如`black`)

###  选择python解释器

- [select-a-python-interpreter@Get Started Tutorial for Python in Visual Studio Code](https://code.visualstudio.com/docs/python/python-tutorial#_select-a-python-interpreter)

### 使用虚拟环境

- [Using Python Environments in Visual Studio Code](https://code.visualstudio.com/docs/python/environments#_creating-environments)
- 主要面向数据分析和机器学习或者复杂多项目开发的用户
- 我的经验和建议是,如果使用conda来管理python环境,建议只是用conda安装常用的数据分析相关工具包
  - 例如基于numpy以及基于numpy开发的相关包
    - `scipy`
    - `pandas`
    - `matplotlib`
    - `scikit-learn`
  - 对于深度学习,比如
    - `cudatoolkit`
    - `pytorch`可以用conda安装
  - 至于`tensorflow`则是推荐用pip安装
  - 实际上大多数相对冷门的包用pip安装最省事
    - conda安装由于每次需要扫描依赖问题,安装速度远远慢于pip
    - 只要知道项目完整的版本配套,完全使用pip安装所有包也是没问题的,甚至速度要快的多

## hinting@IntelliSence

- [IntelliSense in Visual Studio Code](https://code.visualstudio.com/docs/editor/intellisense)

- IntelliSense is a general term for various code editing features including: 
  - code completion, parameter info, quick info, and member lists. 
- IntelliSense features are sometimes called by other names such as 
  - "code completion", 
  - "content assist", 
  - "code hinting."

## Linting

- [Linting Python in Visual Studio Code](https://code.visualstudio.com/docs/python/linting)

- "Lint"一词最初源于纺织业。在纺织工业中，"lint"是指棉花、亚麻、羊毛等纤维杂质，这些杂质可能会影响纺织品的质量和外观。因此，纺织工人会使用一种叫做"lint roller"的工具来清除这些杂质。

  在软件开发领域中，"lint"这个词开始被用来描述一种静态代码分析工具。这种工具可以扫描代码中的潜在问题和不一致性，类似于清除纺织品中的杂质。由于这种工具的名称中包含"lint"一词，因此这种技术也被称为"linting"。

  在软件开发过程中，使用Linting工具可以帮助开发人员发现代码中的潜在错误和代码风格问题，从而提高代码的质量和可维护性。这些工具可以检查变量名的拼写、函数参数的数量、代码格式、代码注释等方面的问题，并提供相应的建议和修复方法。

- 在VSCode中，Linting是指使用静态代码分析工具来检查代码是否符合一组规则或标准，以帮助开发者发现代码中的潜在错误和不一致性。VSCode支持各种不同的Linting工具和插件，包括ESLint、Pylint、Flake8等。

  要在VSCode中启用Linting，需要安装和配置相应的Linting工具和插件。以下是一些常用的步骤：

  1. 安装相应的Linting工具和插件。例如，要检查Python代码，需要安装`Pylint`或`Flake8`，并在VSCode中安装Python插件。
  2. 在VSCode的设置中配置Linting工具。打开“首选项”>“设置”，搜索“linting”，然后选择相应的Linting工具。例如，要使用Pylint，可以设置“python.linting.pylintEnabled”为true。
  3. 配置Linting规则。每个Linting工具都有一组默认的规则，可以根据自己的需要进行自定义。例如，可以通过设置“python.linting.pylintArgs”来配置Pylint的规则。
  4. 在编辑器中查看Linting结果。当保存文件时，VSCode会自动运行Linting工具并在编辑器中显示结果。可以通过单击错误或警告来查看详细信息，并进行相应的修复。

  总的来说，启用Linting可以帮助开发者发现代码中的潜在问题并提高代码质量。在VSCode中，启用和配置Linting工具和插件相对简单，可以根据自己的需要进行自定义。

### Linter

- [Pylint - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-python.pylint)
- [Flake8 - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-python.flake8)

在Python开发中，有许多不同的Linting工具可供选择。下面是一些常见的Python Linter之间的比较：

1. Pylint: Pylint是Python社区中使用最广泛的Linting工具之一。它可以检查代码中的语法错误、潜在问题和代码风格问题，并提供丰富的配置选项和自定义规则。
2. Flake8: Flake8组合了Pyflakes、Pycodestyle和McCabe三个工具的功能，可以检查Python代码中的语法错误、潜在问题和代码风格问题。它还支持自定义插件和规则。
3. Mypy: Mypy是一个静态类型检查工具，可以检查Python代码中的类型错误和类型注释。它可以帮助开发者在开发过程中发现潜在的类型错误，并提供更好的代码提示和自动补全。
4. Bandit: Bandit是一个安全性扫描工具，可以检查Python代码中的安全漏洞和潜在问题。它可以帮助开发者发现和修复代码中的安全问题，并提高代码的安全性。

### Linting性能问题😂

- 使用Linter可能会使得编写代码的过程中束手束脚
- 而且可能会影响vscode响应速度,视情况启用
- 我猜测jetbrian的`updating skeleton`和`indexing`实现会对python环境进行大量的计算优化,而vscode是没有,因此jetbrain系列产品在提示方面的性能要更好

### 关闭Linting

- 我尝试按照官方教程开启和关闭Linting(比如`flake8`,`pylint`)
- 然而好像没生效,重新启动项目后两个`linter`依然会开始扫描
- 我尝试用`pip uninstall `依然无果(尚不清楚原因)
- 不过,按照了某个linter通常vscode还会自动按照对应的extension
- 目前需要到插件里面手动禁用相关插件才可以彻底关闭linting,紧急在设置或者settings.json中配置无法真正关闭

#### 使配置生效

- 如果对某个Linter做了配置更改(甚至是启用和切换),可能需要重载窗口(Developer:reload window)才会生效

- 比如配置`flake8`忽略对`pep501`规范的检查

  - ```json
        "python.linting.flake8Args": [
            "--ignore=E501",
            "--verbose"
        ]
    ```

  - 也可以用settings配置,additem:`--ignore=E501`

##  pylance

- [Pylance@A performant, feature-rich language server for Python in VS Code - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance)

- Pylance是一款由Microsoft开发的Python语言扩展，它是在Visual Studio Code中使用的一种语言服务器，提供了强大的代码分析、自动补全、代码导航和类型检查等功能。

  Pylance基于Python的类型提示和类型注释，可以在代码中自动推断变量类型，并为开发者提供关于变量类型的实时反馈和建议。它还支持Python 3.10中的新功能（如泛型参数和类型别名），并提供了更好的性能和可扩展性。

  Pylance的主要功能包括：

  1. 基于类型提示的自动补全：根据变量类型和函数参数类型等信息，自动补全代码。
  2. 代码导航：快速跳转到定义，查找引用，浏览类型层次结构和继承关系等。
  3. 强大的代码分析：提供语法检查、类型检查、代码重构等功能，帮助开发者发现和修复潜在的错误和问题。
  4. 支持多种Python版本和框架：可与Python 2和Python 3等多个版本的Python解释器和多个框架（如Django、Flask等）集成。
  5. 可扩展性：支持自定义设置、配置和插件，以满足开发者的不同需求。

  总的来说，Pylance是一款功能强大的Python语言扩展，为开发者提供了更好的代码编辑、自动补全和代码分析体验





### pylance报多余而不该有的错

- 方式1:重载窗口,pylance可以重新扫描新模块
- 方式2:配置extra路径
  - `python.analysis.extraPaths`
    - Used to specify extra search paths for import resolution. This replaces the old `python.autoComplete.extraPaths` setting.
    - Default value: empty array













