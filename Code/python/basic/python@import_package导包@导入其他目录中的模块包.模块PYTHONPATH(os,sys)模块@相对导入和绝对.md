[toc]

# python@import_package导包@导入其他目录中的模块包.模块PYTHONPATH(os,sys)模块@相对导入和绝对

## 包和模块

- Python 只有一种模块对象类型，所有模块都属于该类型，无论模块是用 Python、C 还是别的语言实现。 为了帮助组织模块并提供名称层次结构，Python 还引入了 [包](https://docs.python.org/zh-cn/3/glossary.html#term-package) 的概念。
- 你可以把包看成是文件系统中的目录，并把模块看成是目录中的文件
  - 但请不要对这个类比做过于字面的理解，因为包和模块不是必须来自于文件系统。 为了方便理解本文档，我们将继续使用这种目录和文件的类比。
  - 与文件系统一样，包通过层次结构进行组织，在包之内除了一般的模块，还可以有子包。
- 要注意的一个重点概念是<u>**所有包都是模块，但并非所有模块都是包**</u>。
  -  或者换句话说，包只是一种特殊的模块。
  -  特别地，任何具有 `__path__` 属性的模块都会被当作是包。
- 所有模块都有自己的名字。 子包名与其父包名会以**点号**分隔，与 Python 的标准属性访问语法一致。 
- 因此你可能会有一个名为 [`email`](https://docs.python.org/zh-cn/3/library/email.html#module-email) 的包，这个包中又有一个名为 [`email.mime`](https://docs.python.org/zh-cn/3/library/email.mime.html#module-email.mime) 的子包以及该子包中的名为 `email.mime.text` 的子包。

### 包

- Python 定义了两种类型的包，[常规包](https://docs.python.org/zh-cn/3/glossary.html#term-regular-package) 和 [命名空间包](https://docs.python.org/zh-cn/3/glossary.html#term-namespace-package)。 

### 常规包

- 常规包是传统的包类型，它们在 Python 3.2 及之前就已存在。 

  - 常规包通常以一个包含 `__init__.py` 文件的目录形式实现。
  - 当一个常规包被导入时，这个 `__init__.py` 文件会隐式地被执行，它所定义的对象会被绑定到该包命名空间中的名称。
  - `__init__.py` 文件
    - 可以包含与任何其他模块中所包含的 Python 代码相似的代码
    - Python 将在模块被导入时为其添加额外的属性。
  - `__init__.py`文件是必需的，以使Python将包含该文件的目录视为Python包。这可以防止具有相同名称的目录（例如string）无意中隐藏后面的有效模块，因为Python会沿着模块搜索路径依次查找。在最简单的情况下，**init**.py文件可以只是一个空文件，但它也可以执行包的初始化代码或设置后面描述的__all__变量。

- 例如，以下文件系统布局定义了一个最高层级的 `parent` 包和三个子包:

  ```python
  parent/
      __init__.py
      one/
          __init__.py
      two/
          __init__.py
      three/
          __init__.py
  ```

- 导入 `parent.one` 将隐式地执行 相关的`__init__.py`文件:

  - 本例将执行`parent/__init__.py` 和 `parent/one/__init__.py`
  - 后续导入 `parent.two` 或 `parent.three` 则将分别执行 `parent/two/__init__.py` 和 `parent/three/__init__.py`。

### 命名空间包

- 命名空间包是由多个 [部分](https://docs.python.org/zh-cn/3/glossary.html#term-portion) 构成的，每个部分为父包增加一个子包。 

  - 各个部分可能处于文件系统的不同位置。 部分也可能处于 zip 文件中、网络上，或者 Python 在导入期间可以搜索的其他地方。 
  - 命名空间包并不一定会直接对应到文件系统中的对象；它们有可能是无实体表示的虚拟模块。
  - 命名空间包的 `__path__` 属性不使用普通的列表。 而是使用定制的可迭代类型，如果其父包的路径 (或者最高层级包的 [`sys.path`](https://docs.python.org/zh-cn/3/library/sys.html#sys.path)) 发生改变，这种对象会在该包内的下一次导入尝试时自动执行新的对包部分的搜索。

- 命名空间包没有 `parent/__init__.py` 文件。

  -  实际上，在导入搜索期间可能找到多个 `parent` 目录，每个都由不同的部分所提供。 因此 `parent/one` 的物理位置不一定与 `parent/two` 相邻。 
  -  在这种情况下，Python 将为顶级的 `parent` 包创建一个命名空间包，无论是它本身还是它的某个子包被导入。

- 另请参阅 [**PEP 420**](https://peps.python.org/pep-0420/) 了解对命名空间包的规格描述。

  - “package”指的是Python中由import语句定义的包。
  - “distribution”指的是在Python包索引中以独立可安装的形式存储的一组Python模块，由distutils或setuptools安装。
  - “vendor package”指的是由操作系统打包机制（例如，在Linux系统上安装的Debian或Redhat软件包）安装的文件组。
  - “regular package”指的是在Python 3.2及以前实现的包。
  - “portion”指的是一个单独目录中的一组文件（可能存储在zip文件中），这些文件共同对一个命名空间包做出贡献。
  - “legacy portion”指的是使用__path__操作来实现命名空间包的一部分。

  在PEP 420中，这些术语是为了更精确地描述Python中的包和命名空间包的实现方式，以便统一Python社区对包的认识和理解。

## 模块搜索

- 为了开始搜索，Python 需要被导入模块（或者包，对于当前讨论来说两者没有差别）的完整 [限定名称](https://docs.python.org/zh-cn/3/glossary.html#term-qualified-name)。 
  - qualified name -- 限定名称:一个以点号分隔的名称，显示从模块的全局作用域到该模块中定义的某个类、函数或方法的“路径”，相关定义见 [**PEP 3155**](https://peps.python.org/pep-3155/)。对于最高层级的函数和类，限定名称与对象名称一致
  - 此名称可以来自 [`import`](https://docs.python.org/zh-cn/3/reference/simple_stmts.html#import) 语句所带的各种参数
  - 或者来自传给 [`importlib.import_module()`](https://docs.python.org/zh-cn/3/library/importlib.html#importlib.import_module) 或 [`__import__()`](https://docs.python.org/zh-cn/3/library/functions.html#import__) 函数的形参。
- 此名称会在导入搜索的各个阶段被使用，它也可以是指向一个子模块的带点号路径，例如 `foo.bar.baz`。 在这种情况下，Python 会先尝试导入 `foo`，然后是 `foo.bar`，最后是 `foo.bar.baz`。 如果这些导入中的任何一个失败，都会引发 [`ModuleNotFoundError`](https://docs.python.org/zh-cn/3/library/exceptions.html#ModuleNotFoundError)。

## 模块缓存@sys.modules

- 在导入搜索期间首先会被检查的地方是 [`sys.modules`](https://docs.python.org/zh-cn/3/library/sys.html#sys.modules)。 这个映射起到缓存之前导入的所有模块的作用（包括其中间路径）。 因此如果之前导入过 `foo.bar.baz`，则 [`sys.modules`](https://docs.python.org/zh-cn/3/library/sys.html#sys.modules) 将包含 `foo`, `foo.bar` 和 `foo.bar.baz` 条目。 每个键的值就是相应的模块对象。
- 在导入期间，会在 [`sys.modules`](https://docs.python.org/zh-cn/3/library/sys.html#sys.modules) 查找模块名称，如存在则其关联的值就是需要导入的模块，导入过程完成。 然而，如果值为 `None`，则会引发 [`ModuleNotFoundError`](https://docs.python.org/zh-cn/3/library/exceptions.html#ModuleNotFoundError)。 如果找不到指定模块名称，Python 将继续搜索该模块。

### 查找器和加载器@导入器

- 如果指定名称的模块在 [`sys.modules`](https://docs.python.org/zh-cn/3/library/sys.html#sys.modules) 找不到，则将发起调用 Python 的导入协议以查找和加载该模块。 
  - 此协议由两个概念性模块构成，即 [查找器](https://docs.python.org/zh-cn/3/glossary.html#term-finder) 和 [加载器](https://docs.python.org/zh-cn/3/glossary.html#term-loader)。
  - 查找器的任务是确定是否能使用其所知的策略找到该名称的模块。 
  - 同时实现这两种接口的对象称为 [导入器](https://docs.python.org/zh-cn/3/glossary.html#term-importer) —— 它们在确定能加载所需的模块时会返回其自身。
- Python 包含了多个默认查找器和导入器。
  -  第一个知道如何定位内置模块，第二个知道如何定位冻结模块。 
  -  第三个默认查找器会在 [import path](https://docs.python.org/zh-cn/3/glossary.html#term-import-path) 中搜索模块。
     -  [import path](https://docs.python.org/zh-cn/3/glossary.html#term-import-path) 是一个由文件系统路径或 zip 文件组成的位置列表。 它还可以扩展为搜索任意可定位资源，例如由 URL 指定的资源。
     -  import path 由多个位置（或 [路径条目](https://docs.python.org/zh-cn/3/glossary.html#term-path-entry)）组成的**列表**，会被模块的 [path based finder](https://docs.python.org/zh-cn/3/glossary.html#term-path-based-finder) 用来查找导入目标。在导入时，此位置列表通常来自 [`sys.path`](https://docs.python.org/zh-cn/3/library/sys.html#sys.path)，但对次级包来说也可能来自上级包的 `__path__` 属性。
- 导入机制是可扩展的，因此可以加入新的查找器以扩展模块搜索的范围和作用域。
- 查找器并不真正加载模块。 如果它们能找到指定名称的模块，会返回一个 *模块规格说明*，这是对模块导入相关信息的封装，供后续导入机制用于在加载模块时使用。

##  通用方法

- 通过`import sys`模块,对`sys.path`写入新的环境变量
  - 即要用的那个模块的所在目录
  - 这是为例确保要导入的包或模块所在的目录在sys.path中，是Python解释器搜索模块的路径列表。

- 可以调用`sys.path.append()`
  - 该方法插入环境变量(临时的)
  - Note:添加的路径中,原来的空格是怎么样的,就应该是怎么样的,不可以多,也不可以少
    - 否则就算写入环境变量,肯还是找不到对应的模块或者包
    - 还因该注意路劲中的斜杠等问题,推荐使用`raw-string`字符串

### sys.path自动添加当前目录

- 在Python中，当启动一个脚本时，Python解释器会将脚本所在的目录添加到sys.path中，以便能够导入与脚本同一目录下的模块。因此，默认情况下，当前目录会被自动添加到sys.path中。

  例如，在当前目录下有一个名为"module.py"的模块，如果在同一目录下有一个名为"script.py"的脚本，那么在"script.py"中可以直接导入"module.py"，且不需要将当前目录添加到sys.path中。例如：

  ```python
  # script.py
  import module
  
  # do something with module
  ```

  如果在脚本所在的目录之外运行"script.py"，则必须将当前目录添加到sys.path中，否则Python解释器将无法找到"module.py"模块。可以使用以下代码将当前目录添加到sys.path中：

  ```python
  import sys
  sys.path.append('.')
  ```

  这将把当前目录添加到sys.path的末尾，使得Python解释器能够找到当前目录下的模块。

- 试验:

  ```bash
  PS C:\Users\cxxu\Desktop> python -c "import sys;print('\n'.join(sys.path))"|sls desktop
  
  C:\Users\cxxu\Desktop
  ```

  - 例如,windows上,在在powershell中将当前目录调整到desktop(桌面)
  - 执行`python -c "import sys;print('\n'.join(sys.path))"|sls desktop`,可以看到打印了当前目录(桌面目录)
  - 可以切换目录再试试,发现当前目录总是会被添加到`sys.path`
  - 这也是为什么,可以直接以模块名的方式导入兄弟模块

- JetBrains IDE的特性

  - 据说pycharm还会将项目的根目录一起添加到`sys.path`中
  - 但是注意运行方式不是在终端上以`python xxx.py`的方式运行(这样IDE没有机会作额外的处理)
  - 以右键py文件的方式运行,可以将项目根目录添加到`sys.path`中(或快捷键`ctrl+shift+F10`)

- 试验

  - 我在IDEA+python插件的环境下,也会自动添加根目录到sys.path中

    - ```python
      import sys
      for var in sys.path:
          print(var)
      # print(sys.path)
      ```

      

    - ```bash
      D:\condaPythonEnvs\pyside6\python.exe D:\repos\CCSER\emotion-recognition-using-speech\mypackage\subpackage\sys_path_cwd.py 
      D:\repos\CCSER\emotion-recognition-using-speech\mypackage\subpackage
      D:\repos\CCSER\emotion-recognition-using-speech
      D:\repos\ThinkDSP\code
      ```

  - 因此,对于IDE,使用不同的运行方式,在导包方面,可能会有不同的运行结果

  - 为了保证程序的一致性,不建议依赖IDE的这类功能

### 步骤🎈



1. 如果要导入的是**包**（即含有`__init.py__`文件的文件夹）

   - 注意，使用 `from package import item` 时，**item** 可以是包的子模块（或子包），也**可以**是包中定义的函数、类或变量等其他名称。
     - `import` 语句首先测试包中是否定义了 item；
     - 如果未在包中定义，则假定 item 是模块，并尝试加载。
     - 如果找不到 item，则触发 [`ImportError`](https://docs.python.org/zh-cn/3/library/exceptions.html#ImportError) 异常。
   - 相反，使用 `import item.subitem.subsubitem` 句法时，除最后一项外，每个 item 都必须是包；
     - 最后一项可以是模块或包，但**不能**是上一项中定义的类、函数或变量。

2. 如果要导入的是模块（即单个.py文件），

   - 可以使用import 模块名或者from 模块名 import 函数名/类名等语法

3. 如果要导入的包或模块不在当前目录下，而是在上级或下级目录下，可以使用<u>相对路径来指定</u>。

   - 例如，如果要从file4.py中导入上级目录下的file1.py，可以使用以下代码：

   - ```python
     import sys
     sys.path.append("..")	
     import file1
     ```

## 例

- 以下代码您无法直接运行,需要创建对应的目录和添加相应的模块才行
- 但是演示了必要的步骤

### package/module/member层次对应关系:

- 包:目录

  - 添加到`sys.path`中,使得python可以检索到这个目录

- 模块:py文件

  - 上一步成功的情况下,已经可以直接访问该目录下的py文件名(作为模块)

- 子包@子模块

  - 定义再子包中的模块,就叫子模块
  - 如果包A是顶级包
  - 包B是定义在A内,B中包含模块文件fab.py就是包A的子模块(间接模块)
  - 而定义在包A内模块是A的直接模块

- 函数方法/成员:py文件中的函数

- ```python
  import os
  import sys
  
  res=dir(os)
  methods_os = [member for member in dir(os) if callable(getattr(os, member))]
  
  
  # print(methods)
  
  #注意windows下的路径使用`r`,即row string,或者使用双反斜杠backslash来确保路径名被正确解析!否则无法正确识别路径,特别是遇到\r,直接错误.
  
  #告诉python我自定义的名为output的包的路径(使用r'string')
  cxxulib=r'D:\repos\PythonLearn\cxxu_pylib'
  #如果默认路径不含有我自定义的包,那么加入到其中
  if cxxulib not in sys.path:
      sys.path.append(cxxulib)
  #检查自定义包(路径)添加情况
  print(sys.path)
  
  # from output.suboutput.out import hellow_subout
  # hellow_subout()
  #尝试导入自定义包路径下的模块(py文件),假设其名字为out
  #导入包(top level package)
  # import output
  
  #导入子包
  # 注意,您应当将该子包当作一个整体,在后续的引用中要从顶级包(top level package)开始,完整的输入子包路径
  #import 语法在导入和引用的过程中要求是严格!!!
  #您无法使用import 直接导入某个模块内部的类/函数/变量!
  # import output.out
  
  #尝试调用out模块下的table_output函数
  # out.table_output(methods_os,4)#错误引用,需要写全模块路径:
  # output.out.table_output(methods_os,4)
  
  #本试验代码中导入语句中,以带有put后缀的是包(子包);不带有put的为模块文件
  from output.out import table_output
  table_output(methods_os)
  
  from output.out import sayHellow
  sayHellow()
  
  from output.suboutput.out import hellow_subout
  hellow_subout()
  
  from output.suboutput import out
  # help(out)
  out.hellow_subout()
  from output.suboutput.out import hellow_subout as hs
  hs()
  
  ```

  - 本例中提到了导入包和模块以及模块内对象的时候可能遇到的问题
  - 并且注意到,单独的`import`语句和`from ... import ...`有着不同的行为

### 目录结构

- 这是本试验的导入的自定义包的目录结构

  - 刚创建此包(output)时,只含有2个文件
    - `__init__.py`
      - 手动创建,可以没有内容,仅作为这个目录是一个python包的标记而已
    - `out.py`
      - 如果你有多个模块文件,也是可以的
    - 目录`__pycache__`是成功导入该包后生成的缓存文件,不是必须的
  - `D:\repos\PythonLearn\cxxu_pylib`被添加到`sys.path`中

  ```
  (d:\condaPythonEnvs\pytorch_CCSER) #这是我的conda python环境,不必理会
  
  PS D:\repos\PythonLearn\cxxu_pylib> tree_lsd
   .
  ├──  __init__.py
  ├──  output
  │   ├──  __init__.py
  │   ├──  __pycache__
  │   │   └──  out.cpython-310.pyc
  │   ├──  out.py
  │   └──  suboutput
  │       ├──  __.init__.py
  │       ├──  __pycache__
  │       └──  out.py
  └──  readme.md
  ```

  - `output.out.py`

    ```python
    
    def table_output(lst,row_len=3,cell_width='20'):
        for i in range(len(lst)) :
            print(format(lst[i],cell_width),end='\t')
            if (i+1)%row_len==0:
                print()
    def sayHellow():
        print("\n🎈hellow! package by cxxu for output contents formatter")
    def testPackage():
        print("\n😊test package!")
    ```

  - `output.suboutput.out.py`

    - ```python
      def hellow_subout():
          print("@This is a function of module of sub package of out package !")
      ```

## 相对目录导包🎈@包内引用@Intra-package References

- [子包引用](https://docs.python.org/zh-cn/3/tutorial/modules.html#intra-package-references)Intra-package References


### 目录结构@sound

- 例如结构

```bash
sound/                          Top-level package
      __init__.py               Initialize the sound package
      formats/                  Subpackage for file format conversions
              __init__.py
              wavread.py
              wavwrite.py
              aiffread.py
              aiffwrite.py
              auread.py
              auwrite.py
              ...
      effects/                  Subpackage for sound effects
              __init__.py
              echo.py
              surround.py
              reverse.py
              ...
      filters/                  Subpackage for filters
              __init__.py
              equalizer.py
              vocoder.py
              karaoke.py
```

### 绝对导入

- 包中含有多个子包时（与示例中的 `sound` 包一样），可以使用<u>绝对导入</u>引用**兄弟包**中的子模块。
  - 兄弟包和兄弟模块又是两回事
    - 兄弟模块的概念包含了兄弟包
    - `filters`包和`effects`包是兄弟包
  - 例如，要在模块 `sound.filters.vocoder` 中使用 `sound.effects` 包的 `echo` 模块时，可以用 `from sound.effects import echo` 导入。

### 相对导入

- 还可以用 import 语句的 `from module import name` 形式执行相对导入。

- 这些导入语句使用前导句点表示相对导入中的当前包和父包。

- 例如，相对于 `effects.surround` 模块，可以使用：

  ```python
  from . import echo
  from .. import formats
  from ..filters import equalizer
  ```

- 注意，相对导入基于当前模块名。

- 因为**主模块名**是 `"__main__"` ，所以 Python 程序的**主模块**必须始终使用绝对导入。

## 导包试验

### 包目录结构@py_import_demo

- ```
  (d:\condaPythonEnvs\tf210) PS D:\repos\CCSER\py_import_demo> tree_lsd
   .
  ├──  mypackage
  │   ├──  __init__.py
  │   ├──  __pycache__
  │   ├──  fibo.py
  │   ├──  module0.py
  │   ├──  module1.py
  │   ├──  module2.py
  │   ├──  module3.py
  │   ├──  module4.py
  │   ├──  ms.ipynb
  │   └──  subpackage
  │       ├──  __init__.py
  │       ├──  __pycache__
  │       ├──  moduleA.py
  │       ├──  moduleB.py
  │       ├──  moduleB2.py
  │       ├──  moduleB3.py
  │       ├──  moduleC.py
  │       ├──  moduleD.py
  │       ├──  moduleE.py
  │       ├──  sys_path_cwd.py
  │       └──  test_relative_import.py
  └──  py_import_demos.ipynb
  ```
  
  - 目录`py_import_demo`下包含一个目录`mypackage`和一个文件`py_import_demos.ipynb`
  - 多级模块(包)`mypackage`是一个含有2级的包
  - 顶级包为`mypackage`,二级包为`subpackage`

### 绝对导包

#### 临时修改`sys.path`导包

- 尝试导入父目录的module0模块

  ```python
  # moduleA.py
  # 通过临时修改sys.path,可以导入父目录下的模块
  import os,sys
  # sys.path.append(os.pardir)
  sys.path.append("..")
  import module0
  module0.func0()
  ##
  
  ```

#### 导入侄子模块

- ```python
  # module3.py
  if __name__ == "__main__":
      # 导入兄弟模块中的子模块(导入侄子模块)
      import subpackage.moduleD as md  
      # 当moduleD中没有以名字的方式直接导入兄弟模块时,是可以的
      print(md)
  
  ```

  - ```
    PS D:\repos\CCSER\py_import_demo\mypackage>  py module3.py
    <module 'subpackage.moduleD' from 'D:\\repos\\CCSER\\py_import_demo\\mypackage\\subpackage\\moduleD.py'>
    ```

#### 以模块的方式执行绝对导包

- ```python
  # moduleE.py
  ##
  from subpackage.moduleD import funcD
  funcD()
  
  ```

  - 以绝对导入的方式导入moduleC模块所在的包subpackage或者subpackage.moduleD

  - 直接在python 脚本文件的方式执行这部分导模块语句会把报错

  - 您需要在合适的位置,以模块的方式执行`python -m subpackage.moduleE`

  - ```bash
    PS D:\repos\CCSER\py_import_demo\mypackage> python -m subpackage.moduleE
            subpackage dir was append to sys.path by subpackage.__init__.py🎈...
    this is funcD!
    ```

    

### 嵌套导包

##### 例1

- ```python
  #subpackage.__init__.py
  # 增强robustness,避免嵌套导包中的找不到兄弟模块的问题
  import sys 
  import os
  # 获取脚本文件路径
  script_path = os.path.abspath(__file__)
  # 获取脚本所在目录
  script_dir = os.path.dirname(script_path)
  # print(script_dir)
  sys.path.append(script_dir)
  
  # print(sys.path,"🎈🎈")
  # __all__列表定义了当以`from subpacakge import *`的方式导入本包中的模块时,控制哪些子模块会被导入
  __all__=['moduleB','moduleD']
  ```

  -   这是因为,python可以直接导入兄弟模块的实现其实不是语义级别的实现(不是完美)
  -  其原理是通过自动添加被运行的py文件所在目录mypackage到sys.path中,这使得在module2可以访问到兄弟模块(包)subpacakge
  - 但是可以访问到不表示可以顺利导入subpackage中的py文件(比如moduleC,moduleD),还要看subpacakge中文件内容是否具有良好的组织
  - 因为,python不会在你导入兄弟包的时候将兄弟包目录也加入到sys.path中
  - 补充:
    - sys.path.append(os.getcwd())#达不到效果
    - 假设通过执行mypackage.module0,其中有导入mpypackage.subpackage.moduleC(本py文件)的语句
    - 在本文件中检查sys.path,可以发现,不会自动添加本文件所在目录(subpackage),所以subpackage下模块此时是无法直接相互访问
    - 这里导入moduleC的兄弟模块moduleD因之会失败,除非在本模块中及时将subpacakge目录添加到sys.path中
    - 注意,此时的工作目录是由引起嵌套导入的module0所在目录(packaeg)决定的,即使在moduleC.py中查询当前目录,也还是mypackaeg

- ```python
  # module0.py
  ##
  def func0():
      print("this is func0🎈")
  
  if __name__=="__main__":
      print("尝试采用嵌套导入的方式访问moduleD:")
      #嵌套导入
      import subpackage.moduleC as mc 
      mc.funcC()
  
  ```

- ```python
  #subpackage.__init__.py
  # 增强robustness,避免嵌套导包中的找不到兄弟模块的问题
  import sys 
  import os
  # 获取脚本文件路径
  script_path = os.path.abspath(__file__)
  # 获取脚本所在目录
  script_dir = os.path.dirname(script_path)
  # print(script_dir)
  sys.path.append(script_dir)
  
  print("\tsubpackage dir was append to sys.path by subpackage.__init__.py🎈...")
  # print(sys.path,"🎈🎈")
  # __all__列表定义了当以`from subpacakge import *`的方式导入本包中的模块时,控制哪些子模块会被导入
  __all__=['moduleB','moduleD']
  ```

  

- 

  ```python
  # moduleC.py
  ##
  def funcC():
      print("this is funcC!🎈")
      import moduleD as md
      md.funcD()
      import sys
      # print(sys.path)
      print()
      print("sys.path:")
      for var in sys.path:
          print(var)
  ```

- ```bash
  PS D:\repos\CCSER\py_import_demo\mypackage>  py module0.py
  尝试采用嵌套导入的方式访问moduleD:
          subpackage dir was append to sys.path by subpackage.__init__.py🎈...
  this is funcC!🎈
  this is funcD!
  
  sys.path:
  D:\repos\CCSER\py_import_demo\mypackage🎈
  D:\repos\ThinkDSP\code
  D:\repos\CCSER\cxxu_serlib
  C:\new_path_demo
  D:\repos\PythonLearn\cxxu_pylib
  D:\repos\CCSER\py_import_demo\mypackage
  C:\Users\cxxu\miniconda3\python39.zip
  C:\Users\cxxu\miniconda3\DLLs
  C:\Users\cxxu\miniconda3\lib
  C:\Users\cxxu\miniconda3
  C:\Users\cxxu\miniconda3\lib\site-packages
  C:\Users\cxxu\miniconda3\lib\site-packages\win32
  C:\Users\cxxu\miniconda3\lib\site-packages\win32\lib
  C:\Users\cxxu\miniconda3\lib\site-packages\Pythonwin
  D:\repos\CCSER\py_import_demo\mypackage\subpackage🎈
  ```

##### 例2

- ```python
  # module4.py
  import mypackage.subpackage.moduleB as mb
  ```

- 

  ```bash
  (d:\condaPythonEnvs\tf210) PS D:\repos\CCSER\py_import_demo> py -m mypackage.module4
          >>>>>>>>>>subpackage dir was append to sys.path by subpackage.__init__.py🎈...<<<<<<<<<<<
  pwd:🎈 D:\repos\CCSER\py_import_demo
  moduleName: mypackage.subpackage.moduleB @本包含相对导包语句
  you use the module in importing,so the relative import statements will be executed!
  this is funcD!
  this is func1!
  
  
  (d:\condaPythonEnvs\tf210) PS D:\repos\CCSER\py_import_demo> py .\mypackage\module4.py
          >>>>>>>>>>subpackage dir was append to sys.path by subpackage.__init__.py🎈...<<<<<<<<<<<
  pwd:🎈 D:\repos\CCSER\py_import_demo
  moduleName: mypackage.subpackage.moduleB @本包含相对导包语句
  you use the module in importing,so the relative import statements will be executed!
  this is funcD!
  this is func1!
  ```

  

### 相对导入

- ```python
  # moduleB.py
  
  import os
  print("pwd:🎈",os.getcwd())
  
  print("moduleName:",__name__,"@本包含相对导包语句")
  def funcB():
      print('this is funcB@moduleB')
  ##
  # 控制:只有当以模块的方式执行本文件时,才执行以下相对导包语句
  # 如果将本模块文件当作主模块,__name__就会是`__main__`,从而不执行以下语句
  if __name__!="__main__":
      # 使用相对路径的方式导包
      # 导入同目录下的兄弟模块moduleD
      print("you use the module in importing,so the relative import statements will be executed!")
      from .moduleD import funcD
      funcD()
      # 父目录中的模块
      from ..module1 import func1
      func1()
  else:
      print("you use the module as main module,so the relative import statements won't be executed!")
  
  
  ```

- 请跳转到包mypackage目录之外(比如mypackage同级别目录下),执行以模块的方式执行:`python -m mypackage.subpackage.moduleB`

- `python -m mypackage.subpackage.moduleB`告诉了python,我们的**包**的根目录是mypackage,而不是别的东西,这样模块moduleB中的相对导包语句才可以顺利执行

  - 注意包的根目录指多级包的顶级(top-level)对应的目录
  - 本例中,顶级目录是`mypackage`
  - 所以为了使相对导包生效,需要在合适的位置以合适的命令行来执行

- ```bash
  (d:\condaPythonEnvs\tf210) PS D:\repos\CCSER\py_import_demo> py -m mypackage.subpackage.moduleB
          >>>>>>>>>>subpackage dir was append to sys.path by subpackage.__init__.py🎈...<<<<<<<<<<<
  pwd:🎈 D:\repos\CCSER\py_import_demo
  moduleName: __main__ @本包含相对导包语句
  you use the module as main module,so the relative import statements won't be executed!
  ```

##### TODO

- 上面的例子中,我们使用`python -m <moduleName>`的方式运行

- 而`python -m <moduleName>`始终将模块的`__name__`修改为`__main__`

  - 但是在这种情况下,模块中含有编写合理的`相对导入`语句不一定会报错

- ```python
  # moduleB.py
  import os
  print("pwd:🎈",os.getcwd())
  ##
  print("moduleName:",__name__,"@本包含相对导包语句!")
  import sys
  for var in sys.path:
      print(var)
  
  from .moduleD import funcD
  funcD()
  # 父目录中的模块
  from ..module1 import func1
  func1()
  
  def funcB3():
      print("@funcB3")
  ```

  

- ```bash
  (d:\condaPythonEnvs\tf210) PS D:\repos\CCSER\py_import_demo> python -m mypackage.subpackage.moduleB3
          >>>>>>>>>>subpackage dir was append to sys.path by subpackage.__init__.py🎈...<<<<<<<<<<<
  pwd:🎈 D:\repos\CCSER\py_import_demo
  moduleName: __main__ @本包含相对导包语句!
  D:\repos\CCSER\py_import_demo
  D:\repos\ThinkDSP\code
  D:\repos\CCSER\cxxu_serlib
  C:\new_path_demo
  D:\repos\PythonLearn\cxxu_pylib
  D:\repos\CCSER\py_import_demo
  d:\condaPythonEnvs\tf210\python39.zip
  d:\condaPythonEnvs\tf210\DLLs
  d:\condaPythonEnvs\tf210\lib
  d:\condaPythonEnvs\tf210
  d:\condaPythonEnvs\tf210\lib\site-packages
  D:\repos\CCSER\py_import_demo\mypackage\subpackage
  this is funcD!
  this is func1!
  ```

  

- 而用`python <moduleNameFile>`   的方式执行是会报错的

  - ```bash
    (d:\condaPythonEnvs\tf210) PS D:\repos\CCSER\py_import_demo> python .\mypackage\subpackage\moduleB3.py
    pwd:🎈 D:\repos\CCSER\py_import_demo
    moduleName: __main__ @本包含相对导包语句!
    D:\repos\CCSER\py_import_demo\mypackage\subpackage
    D:\repos\ThinkDSP\code
    D:\repos\CCSER\cxxu_serlib
    C:\new_path_demo
    D:\repos\PythonLearn\cxxu_pylib
    D:\repos\CCSER\py_import_demo
    d:\condaPythonEnvs\tf210\python39.zip
    d:\condaPythonEnvs\tf210\DLLs
    d:\condaPythonEnvs\tf210\lib
    d:\condaPythonEnvs\tf210
    d:\condaPythonEnvs\tf210\lib\site-packages
    Traceback (most recent call last):
      File "D:\repos\CCSER\py_import_demo\mypackage\subpackage\moduleB3.py", line 10, in <module>
        from .moduleD import funcD
    ImportError: attempted relative import with no known parent package
    ```

- 通过交互模式下运行导入语句`import moduleB3`也不会报错,而且显示的模块名是`moduleB3`

  - ```python
    Python 3.9.16 (main, Mar  8 2023, 10:39:24) [MSC v.1916 64 bit (AMD64)] on win32
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import mypackage.subpackage.moduleB3
            >>>>>>>>>>subpackage dir was append to sys.path by subpackage.__init__.py🎈...<<<<<<<<<<<
    pwd:🎈 D:\repos\CCSER\py_import_demo
    moduleName: mypackage.subpackage.moduleB3 @本包含相对导包语句!
    
    D:\repos\ThinkDSP\code
    D:\repos\CCSER\cxxu_serlib
    C:\new_path_demo
    D:\repos\PythonLearn\cxxu_pylib
    D:\repos\CCSER\py_import_demo
    d:\condaPythonEnvs\tf210\python39.zip
    d:\condaPythonEnvs\tf210\DLLs
    d:\condaPythonEnvs\tf210\lib
    d:\condaPythonEnvs\tf210
    d:\condaPythonEnvs\tf210\lib\site-packages
    D:\repos\CCSER\py_import_demo\mypackage\subpackage
    this is funcD!
    this is func1!
    ```

    

#### 交互模式下导入含有相对导入语句的模块

- 在交互模式中以恰当的访问名访问含有相对导入语句的模块`moduleB`

  - ```bash
    (d:\condaPythonEnvs\tf210) PS D:\repos\CCSER\py_import_demo> py
    Python 3.9.16 (main, Mar  8 2023, 10:39:24) [MSC v.1916 64 bit (AMD64)] on win32
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import mypackage.subpackage.moduleB as mb
            >>>>>>>>>>subpackage dir was append to sys.path by subpackage.__init__.py🎈...<<<<<<<<<<<
    pwd:🎈 D:\repos\CCSER\py_import_demo
    moduleName: mypackage.subpackage.moduleB @本包含相对导包语句
    you use the module in importing,so the relative import statements will be executed!
    this is funcD!
    this is func1!
    ```

    


#### 错误的执行方式

##### ImportError: attempted relative import with no known parent package

- 基于`moduleB.py`,创建新py文件为`moduleB2.py`,让它在被以主模块执行(`py moduleB2.py`)的方式执行时,打印其模块名

  - python执行主模块(`py`文件)时,主模块是不允许相对导入,而只能用绝对导入

  - 否则就会出现`importError`

  - ```python
    # moduleB2.py
    import os
    print("pwd:🎈",os.getcwd())
    
    print(__name__,"🎈moduleB 包含相对导包语句,如果将本模块作为主模块(__name__='__main__),则相对导包语句不执行!")
    def funcB():
        print('this is funcB@moduleB2')
    
    
    # 父目录中的模块
    from ..module1 import func1
    func1()
    
    
    ```

    

- ```bash
  (d:\condaPythonEnvs\tf210) PS D:\repos\CCSER\py_import_demo\mypackage\subpackage> py moduleB2.py
  __main__ 🎈moduleB 包含相对导包语句,如果将本模块作为主模块(__name__='__main__),则相对导包语句不执行!
  Traceback (most recent call last):
    File "D:\repos\CCSER\py_import_demo\mypackage\subpackage\moduleB2.py", line 9, in <module>
      from ..module1 import func1
  ImportError: attempted relative import with no known parent package
  ```



- ```bash
  PS D:\repos\CCSER\py_import_demo\mypackage\subpackage> py -m moduleB2.py  
  moduleB 🎈
  Traceback (most recent call last):
    File "C:\Users\cxxu\miniconda3\lib\runpy.py", line 188, in _run_module_as_main
      mod_name, mod_spec, code = _get_module_details(mod_name, _Error)
    File "C:\Users\cxxu\miniconda3\lib\runpy.py", line 111, in _get_module_details
      __import__(pkg_name)
    File "D:\repos\CCSER\py_import_demo\mypackage\subpackage\moduleB.py", line 11, in <module>
      from .moduleD import funcD
      
  ImportError: attempted relative import with no known parent package
  ```

  

- 这是由于执行位置的不合适导致的

- 需要将当前目录调整到`PS D:\repos\CCSER\py_import_demo\`下执行


##### ImportError: attempted relative import beyond top-level package

- ```bash
  (d:\condaPythonEnvs\tf210) PS D:\repos\CCSER\py_import_demo\mypackage> py -m subpackage.moduleB2
          subpackage dir was append to sys.path by subpackage.__init__.py🎈...
  pwd:🎈 D:\repos\CCSER\py_import_demo\mypackage
  __main__ 🎈moduleB 包含相对导包语句,如果将本模块作为主模块(__name__='__main__),则相对导包语句不执行!
  Traceback (most recent call last):
    File "d:\condaPythonEnvs\tf210\lib\runpy.py", line 197, in _run_module_as_main
      return _run_code(code, main_globals, None,
    File "d:\condaPythonEnvs\tf210\lib\runpy.py", line 87, in _run_code
      exec(code, run_globals)
    File "D:\repos\CCSER\py_import_demo\mypackage\subpackage\moduleB2.py", line 11, in <module>
      from ..module1 import func1
  ImportError: attempted relative import beyond top-level package
  ```

  - 执行目录是`mypackage`,所以python(`-m`)认为根目录就是`mypackage`
  - 而`moduleB2`位于`subpackage`中包含`from ..modulex import xxx`,其中`..`表示`subpackage`的父目录,也就是`subpackage`;

##### Relative module names not supported

- ```bash
  PS D:\repos\CCSER\py_import_demo\mypackage\subpackage> py -m .\moduleB.py
  C:\Users\cxxu\miniconda3\python.exe: Relative module names not supported
  ```

  - `python -m `不支持的参数相对路径(这不是说模块文件不支持相对路径)

## python command line@命令行

- [1. Command line and environment — Python 3.11.2 documentation](https://docs.python.org/3/using/cmdline.html)

### python -m

- -m mod : run library module as a script (terminates option list)

- When called with `-m module-name`, the given module is located on the Python module path and executed as a script.

- 在Python中，可以使用命令行参数"-m"来执行一个模块作为脚本（module as script），而不必使用Python解释器的交互式界面或单独运行一个脚本文件。

- 具体来说，使用命令行参数"-m"可以执行指定的模块，并将命令行参数后面的所有参数传递给该模块作为命令行参数。例如，以下命令将执行名为"mymodule"的模块，并将命令行参数"arg1"和"arg2"传递给该模块：

  ```python
  python -m mymodule arg1 arg2
  ```

- 在执行模块时，Python解释器将按照模块搜索路径查找指定的模块，并将其导入。然后，Python解释器将执行该模块中的顶层代码，并将命令行参数传递给该模块作为sys.argv列表中的元素。

- 使用命令行参数"-m"可以方便地执行一个模块作为脚本，而无需在命令行中指定模块路径或在代码中使用绝对路径。此外，使用"-m"还可以确保模块是使用Python解释器的正确版本执行的，而不是使用系统默认版本或其他版本的Python解释器执行的。

### PEP 328 – Imports: Multi-Line and Absolute/Relative

- [PEP 328 – Imports: Multi-Line and Absolute/Relative | peps.python.org](https://peps.python.org/pep-0328/)

- 这段文字是PEP 328中的摘要，该PEP提出了两个import语句存在的问题，并提出了解决方案。
  - 第一个问题是长的import语句很难编写，需要进行各种调整以符合Pythonic的风格指南。解决方案是允许用括号括起多个名称，从而允许Python的多行值的标准机制应用。
  - 第二个问题是在处理包时，import语句可能会存在歧义；在一个包内，不清楚import foo是指包内的模块还是包外的模块。解决方案是默认情况下所有import语句都是绝对的（只在sys.path中搜索），对于访问相对于包的导入，则需要特殊的语法（前导点号）。
- 因此，PEP 328提出了使用括号和前导点号来解决import语句存在的问题，使得编写长的import语句更加容易，同时也为包内和包外的模块之间的导入关系提供了更加明确的规则。

# PEP

- PEP是Python Enhancement Proposal的缩写，是Python社区用于提出新特性、改进现有特性或解决问题的文档。PEP通常由Python开发者或社区成员编写，并通过邮件列表或GitHub等方式提交至Python社区进行讨论、修改和最终决策。

  PEP的目的是为Python的发展提供方向和指导，让Python社区能够协同工作，共同推动Python的发展。PEP涵盖了很多方面的内容，包括语言特性、标准库、开发工具、工作流程等等。

  一些重要的PEP包括：

  - PEP 8：Python代码风格指南，规范了Python代码的格式、命名和注释等方面，是Python程序员编写高质量代码的重要参考。
  - PEP 20：Python之禅，包含了Python语言的设计哲学和核心价值观，是Python程序员思考和编码的指南。
  - PEP 257：Python文档字符串约定，规定了如何编写Python函数、类和模块的文档字符串，使得Python代码更易于理解和维护。
  - PEP 484：类型提示语法，引入了一种新的语法来指定Python函数和变量的类型信息，提高了Python代码的可读性和可维护性。
  - PEP 572：表达式中的赋值，引入了一种新的语法来在Python表达式中进行赋值操作，使得Python代码更简洁和易读。

  PEP不仅是Python的发展方向和指导，也是Python社区的文化和传统。通过遵循PEP，Python程序员可以编写高质量的Python代码，同时也可以为Python社区的发展做出贡献。











