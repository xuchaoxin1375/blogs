[toc]

## ref

- [Graphical User Interfaces with Tk — Python 3.11.3 documentation](https://docs.python.org/3/library/tk.html)

- [Tk图形用户界面(GUI) — Python 3.11.3 文档](https://docs.python.org/zh-cn/3/library/tk.html)

- Tcl/Tk是一种GUI工具包和脚本语言，它们经常一起使用。
- Tcl（Tool Command Language）是一种解释性脚本语言，它被设计用于在应用程序中嵌入脚本语言。
- Tk是一个跨平台的图形用户界面(GUI)工具包，它与Tcl绑定在一起。Tk提供了大量的GUI组件（如窗口、按钮、标签、文本框等），它们可以通过Tcl脚本语言进行控制。
- Tcl/Tk的优点包括：
  1. 跨平台性：Tcl/Tk可以运行在各种操作系统上，包括Windows、Mac OS X和Linux等。
  2. 易学易用：Tcl/Tk的语法简单、易学易用，而且可以编写出功能强大的GUI应用程序。
  3. 可扩展性：Tcl/Tk提供了许多扩展库和C语言API，使得开发者能够轻松地扩展和定制自己的应用程序。
  4. 开源：Tcl/Tk是开源软件，可以免费使用和分发。
- Tcl/Tk的缺点包括：
  1. 性能：Tcl/Tk的性能可能不如其他一些GUI工具包，特别是在处理大量数据、图像和视频等方面。
  2. 界面美观度：Tcl/Tk的默认主题和组件风格可能不如其他GUI工具包，但是可以使用第三方主题和组件库来改善。
- tkinter 包是使用面向对象方式对 Tcl/Tk 进行的一层薄包装。 使用 tkinter，你不需要写 Tcl 代码，但你将需要参阅 Tk 文档，有时还需要参阅 Tcl 文档。
- tkinter 是一组包装器，它将 Tk 的可视化部件实现为相应的 Python 类。 tkinter 的主要特点是速度很快，并且通常直接附带在 Python 中。 虽然它的官方文档做得不好，但还是有许多可用的资源，包括：在线参考、教程、入门书等等。 tkinter 还有众所周知的较过时的外观界面，这在 Tk 8.5 中已得到很大改进。
- 总之，Tcl/Tk是一个强大的GUI工具包和脚本语言，它具有跨平台性、易学易用和可扩展性等优点，但可能不如其他GUI工具包在性能和界面美观度方面。

### Tkinter架构

Tcl/Tk 不是只有单个库，而是由几个不同的模块组成的，每个模块都有各自的功能和各自的官方文档。 Python 的二进制发行版还会再附加一个模块。

- Tcl

  Tcl 是一种动态解释型编程语言，正如 Python 一样。尽管它可作为一种通用的编程语言单独使用，但最常见的用法还是作为脚本引擎或 Tk 工具包的接口嵌入到 C 程序中。Tcl 库有一个 C 接口，用于创建和管理一个或多个 Tcl 解释器实例，并在这些实例中运行 Tcl 命令和脚本，添加用 Tcl 或 C 语言实现的自定义命令。每个解释器都拥有一个事件队列，某些部件可向解释器发送事件交由其处理。与 Python 不同，Tcl 的执行模型是围绕协同多任务而设计的，Tkinter 协调了两者的差别（详见 [Threading model](https://docs.python.org/zh-cn/3/library/tkinter.html#threading-model) ）。

- Tk

  Tk is a [Tcl package](https://wiki.tcl-lang.org/37432) implemented in C that adds custom commands to create and manipulate GUI widgets. Each [`Tk`](https://docs.python.org/zh-cn/3/library/tkinter.html#tkinter.Tk) object embeds its own Tcl interpreter instance with Tk loaded into it. Tk's widgets are very customizable, though at the cost of a dated appearance. Tk uses Tcl's event queue to generate and process GUI events.

- Ttk

  带有主题的 Tk（Ttk）是较新加入的 Tk 部件，相比很多经典的 Tk 部件，在各平台提供的界面更加美观。自 Tk 8.5 版本开始，Ttk 作为 Tk 的成员进行发布。Python 则捆绑在一个单独的模块中， [`tkinter.ttk`](https://docs.python.org/zh-cn/3/library/tkinter.ttk.html#module-tkinter.ttk)。

在内部，Tk 和 Ttk 使用下层操作系统的工具库，例如在 Unix/X11 上是 Xlib，在 macOS 上是 Cocoa，在 Windows 上是 GDI。

当你的 Python 应用程序使用 Tkinter 中的某个类，例如创建一个部件时，[`tkinter`](https://docs.python.org/zh-cn/3/library/tkinter.html#module-tkinter) 模块将首先生成一个 Tcl/Tk 命令字符串。 它会把这个 Tcl 命令字符串传给内部的 `_tkinter` 二进制模块，后者将随后调用 Tcl 解释器来对其求值。 Tcl 解释器随后将对 Tk 和/和 Ttk 包发起调用，它们又将继续对 Xlib, Cocoa 或 GDI 发起调用。

### 工厂函数

- Python中的工厂函数是一种创建和返回其他对象的函数，通常用于简化代码和提高可维护性。
- 以下是一些Python工厂函数的例子：

#### 字典工厂函数

```python
def create_dict(key_value_pairs):
    """
    创建一个字典，其中键值对由key_value_pairs参数指定。
    key_value_pairs参数应该是一个元组列表，每个元组包含键和值。
    """
    return dict(key_value_pairs)
```

使用示例：

```python
my_dict = create_dict([('a', 1), ('b', 2), ('c', 3)])
print(my_dict)  # {'a': 1, 'b': 2, 'c': 3}
```

#### 列表工厂函数

```python
def create_list(*elements):
    """
    创建一个列表，其中元素由elements参数指定。
    elements参数应该是可变数量的位置参数。
    """
    return list(elements)
```

使用示例：

```python
my_list = create_list(1, 2, 3)
print(my_list)  # [1, 2, 3]
```

#### 类工厂函数

- [type()](https://docs.python.org/3/library/functions.html#type)

  - *class* **type**(*object*)
  - *class* **type**(*name*, *bases*, *dict*, ***kwds*)
  - type函数可以用来创建类

- 构造2个等价的类实例

  - ```python
    class X:
        a = 1
    
    X = type('X', (), dict(a=1))
    ```

    

```python
def create_class(class_name, base_classes=None, **kwargs):
    """
    创建一个新的类，其中类名由class_name参数指定，基类由base_classes参数指定。其他关键字参数将被用作类的属性。
    """
    if base_classes is None:
        base_classes = (object,)
    return type(class_name, base_classes, kwargs)
```

使用示例：

```python
my_class = create_class('MyClass', (object,), x=1, y=2)
print(my_class)  # <class '__main__.MyClass'>
print(my_class.x)  # 1
print(my_class.y)  # 2
```

这些工厂函数的例子只是Python中工厂函数的冰山一角，工厂函数可以用于创建各种对象，包括实例、函数、模块等等。使用工厂函数可以使代码更加简洁、可读性更高、更易于维护。

## Tkinter tutorial and resources

### docs

- [TkDocs](https://tkdocs.com/)

  关于使用 Tkinter 创建用户界面的详细教程。 讲解了关键概念，并介绍了使用现代 API 的推荐方式。

- [Tkinter 8.5 参考手册：一种 Python GUI](https://www.tkdocs.com/shipman/)

  详细讲解可用的类、方法和选项的 Tkinter 8.5 参考文档。

### Tcl/Tk 资源:

- [Tk 命令](https://www.tcl.tk/man/tcl8.6/TkCmd/contents.htm)

  有关 Tkinter 所使用的每个底层 Tcl/Tk 命令的完整参考文档。

- [Tcl/Tk 主页](https://www.tcl.tk/)

  额外的文档，以及 Tcl/Tk 核心开发相关链接。

### 书籍:

- [Modern Tkinter for Busy Python Developers](https://tkdocs.com/book.html)

  Mark Roseman 著。 (ISBN 978-1999149567)

- [Python and Tkinter Programming](https://www.packtpub.com/product/python-gui-programming-with-tkinter/9781788835886)

  Alan Moore 著。 (ISBN 978-1788835886)

- [Programming Python](https://learning-python.com/about-pp4e.html)

  Mark Lutz 著；对 Tkinter 进行了精彩的讲解。 (ISBN 978-0596158101)

- 其他

  - [Tcl and the Tk Toolkit (2nd edition)](https://www.amazon.com/exec/obidos/ASIN/032133633X)

    John Ousterhout ，Tcl/Tk 的创造者，与 Ken Jones 合著；未涉及 Tkinter。 (ISBN 978-0321336330)

### 初学者的Tkinter教程

1. [Tkinter官方文档](https://docs.python.org/3/library/tk.html) - Tkinter官方文档包含了Tkinter的所有功能和方法的详细描述，是一个非常全面的资源。
2. [Python Tkinter教程](https://www.tutorialspoint.com/python/python_gui_programming.htm) - 这个教程提供了一个很好的介绍Tkinter基础知识的入门指南。它从Tkinter窗口和小部件的创建开始，一步步介绍了各种小部件的使用方法。
3. [Tkinter教程](https://likegeeks.com/python-gui-examples-tkinter-tutorial/) - 这个教程提供了很多有用的Tkinter小部件的例子，每个例子都有详细的说明和代码。这个教程适合那些想要从实际例子中学习的人。
4. [TkDocs](https://tkdocs.com/tutorial/index.html) - 这个教程是一个很好的Tkinter文档，包含了从基础到高级的各种Tkinter小部件的使用方法和例子。

这些教程都是非常好的资源，可以帮助初学者快速入门Tkinter。

## Hello World 程序[¶](https://docs.python.org/zh-cn/3/library/tkinter.html#a-hello-world-program)

- 让我们先来看一个 Tkinter 的 "Hello World" 应用程序。 这并不是我们所能写出的最简短版本，但也足够说明你所需要了解的一些关键概念。

- ```python
  from tkinter import * 
  from tkinter import ttk 
  root = Tk() 
  btn = ttk.Button(root, text="Hello World")
  btn.grid() 
  root.mainloop()
  ```

  - 这个例子最简单,没有提到布局

- ```python
  from tkinter import *
  from tkinter import ttk
  
  root = Tk()
  
  frm = ttk.Frame(root, padding=10)
  
  label=ttk.Label(frm, text="Hello World!")
  frm.grid()
  label.grid(column=0, row=0)
  
  btn=ttk.Button(frm, text="Quit", command=root.destroy)
  btn.grid(column=1, row=0)
  
  root.mainloop()
  ```

- 在导入语句之后，下一行语句创建了一个 [`Tk`](https://docs.python.org/zh-cn/3/library/tkinter.html#tkinter.Tk) 类的实例，
  - 它会初始化 Tk 并创建与其关联的 Tcl 解释器。
  -  它还会创建一个顶层窗口，名为 root 窗口，它将被作为应用程序的主窗口。
- 下一行创建了一个框架控件
  - 在本示例中它会包含我们即将创建的一个标签和一个按钮。
  -  框架被嵌在 root 窗口内部。
- 下一行创建了一个包含<u>静态文本字符串</u>(`Hellow World!`)的**标签控件**(ttk.Lable)。 
  - `grid()` 方法被用来**指明标签**在包含它的<u>框架控件中的相对布局（定位）</u>，作用类似于 HTML 中的表格。
- 接下来创建了一个按钮控件，并被放置到标签的右侧。 当被按下时，它将调用 root 窗口的 `destroy()` 方法。

- 窗口设计完成.最后，`mainloop()` 方法将所有控件显示出来，并响应用户输入直到程序终结。



### 重要的 Tk 概念

即便是这样简单的程序也阐明了以下关键 Tk 概念:

1. 控件

   Tkinter 用户界面是由一个个 *控件* 组成的。 每个控件都由相应的 Python 对象表示，由 `ttk.Frame`, `ttk.Label` 以及 `ttk.Button` 这样的类来实例化。

2. 控件层级结构

   - 控件按 *层级结构* 来组织。
     -  <u>标签和按钮</u>包含在框架中
     - 框架又包含在**根窗口**中。
   - 当创建每个 *子* 控件时，它的 *父* 控件会作为**控件构造器的第一个参数**被传入。

3. 配置选项

   - 控件具有 *配置选项*，配置选项会改变控件的外观和行为，例如要在标签或按钮中显示的文本。 

   - 不同的控件类会具有不同的**选项集**。

4. 几何管理

   - 小部件在**创建**时不会自动**添加**到用户界面。
   - 一个像``grid``的 *几何管理器* 控制这些小部件在用户界面的位置。

5. 事件循环

   - 只有主动运行一个 *事件循环*，Tkinter 才会对用户的输入做出反应，改变你的程序，以及**刷新显示**。
   - 如果你的程序没有<u>运行事件循环</u>，你的用户界面不会更新。



### Tk Concepts

With your first example behind you, you now have a basic idea of what a Tk program looks like and the type of code you need to write to make it work. In this chapter, we'll step back and look at three broad concepts that you need to know to understand Tk:

-  widgets,

-  geometry management, 

- and event handling

  

### 了解 Tkinter 如何封装 Tcl/Tk

- 当你的应用程序使用 `Tkinter 的类和方法`时，Tkinter 内部汇编`代表 Tcl/Tk 命令的字符串`，并且在连接到你的应用程序的 [`Tk`](https://docs.python.org/zh-cn/3/library/tkinter.html#tkinter.Tk) 实例的 `Tcl 解释器`中执行这些**命令**。

- 无论是试图浏览参考文档，或是试图找到正确的方法或选项，调整一些现有的代码，亦或是调试 Tkinter 应用程序，有时候理解底层 Tcl/Tk 命令是什么样子的会很有用。

- 为了说明这一点，下面是 Tcl/Tk 等价于上面 Tkinter 脚本的主要部分。

  - ```tcl
    ttk::frame .frm -padding 10
    grid .frm
    grid [ttk::label .frm.lbl -text "Hello World!"] -column 0 -row 0
    grid [ttk::button .frm.btn -text "Quit" -command "destroy ."] -column 1 -row 0
    ```

- Tcl 的语法类似于许多 shell 语言，其中第一个单词是要执行的命令，后面是该命令的参数，用空格分隔。不谈太多细节，请注意以下几点：

  - 用于创建窗口小部件（如 `ttk::frame`）的命令对应于 Tkinter 中的 widget 类。

  - Tcl 窗口控件选项（如 `-text`）对应于 Tkinter 中的关键字参数。

  - 在 Tcl 中，小部件是通过 *路径名* 引用的（例如 `.frm.btn`），而 Tkinter 不使用名称，而是使用对象引用。

  - 控件在控件层次结构中的**位置**在其（层次结构）路径名中编码，该路径名使用一个 `.` （点）作为路径分隔符。
    - 根窗口的路径名是 `.` （点）。
    - 在 Tkinter 中，**层次结构**不是通过<u>路径名</u>定义的，而是通过在创建每个子控件时**指定父控件**来定义的。

  - 在 Tcl 中以独立的 *命令* 实现的操作（比如 `grid` 和 `destroy` ）在 Tkinter 控件对象上以 *方法* 表示。
  - 稍后您将看到，在其他时候，Tcl 在控件对象调用的方法，在 Tkinter 也有对应的使用。

### Geometry Management@几何/布局管理

- 在Tkinter中，布局管理器（Layout Manager）用于在窗口中放置和组织小部件。Tkinter提供了三种主要的布局管理器：`pack()`、`grid()`和`place()`。

  这些布局管理器可以根据需要灵活地混合使用。下面是每个布局管理器的详细说明：

  1. `pack()`布局管理器：`pack()`将小部件包装成块，并将它们在容器中垂直或水平地堆叠。它是最简单的布局管理器，但是它的灵活性有限。
  2. `grid()`布局管理器：`grid()`使用网格来放置小部件。与`pack()`不同，`grid()`可以在任何方向上堆叠小部件，并且可以定义小部件所占用的单元格数和行列大小。
  3. `place()`布局管理器：`place()`使用绝对坐标来放置小部件。这使得它非常灵活，但也很难控制。

  在实际使用中，我们可以根据需要将不同的布局管理器结合起来使用。例如，我们可以使用`pack()`将一组小部件水平堆叠，然后使用`grid()`将另一组小部件放置在网格中。

- 除了这三种布局管理器，Tkinter还提供了`Frame`小部件，它可以用作**容器**来组织<u>其他小部件</u>。

  - 我们可以在`Frame`中使用任何布局管理器，以便更好地组织和管理小部件。



#### pack布局管理器@`No Longer Recommended`

- 在过去,pack布局管理器是Tkinter中最简单和最常用的布局管理器之一。
- 然而,现在的tkinter更推荐使用grid,下面依然给出一个吉纳丹的例子
- 它可以将小部件紧凑地放置在窗口中，并根据窗口的大小和调整小部件的大小和位置。pack布局管理器使用`pack()`方法将小部件添加到容器中，它提供了一些选项，可以控制小部件的位置和大小。

以下是一个使用pack布局管理器的简单示例：

```python
import tkinter as tk

root = tk.Tk()

label1 = tk.Label(root, text="Label 1", bg="red")
label1.pack(side="left")

label2 = tk.Label(root, text="Label 2", bg="green")
label2.pack(side="left")

label3 = tk.Label(root, text="Label 3", bg="blue")
label3.pack(side="left")

root.mainloop()
```

- 在这个示例中，我们创建了三个Label小部件，使用pack布局管理器将它们放置在窗口的左侧。
- 我们分别使用`side`参数指定了小部件的位置，可以是`left`、`right`、`top`或`bottom`。
- pack布局管理器还提供了其他选项，例如`fill`和`expand`，可以控制小部件的大小和位置。

#### grid布局管理器

- grid布局管理器是Tkinter中另一种常用的布局管理器，它使用网格来组织小部件。grid布局管理器使用`grid()`方法将小部件添加到容器中，它提供了一些选项，可以控制小部件在网格中的位置和大小。

以下是一个使用grid布局管理器的简单示例：

```python
import tkinter as tk

root = tk.Tk()

label1 = tk.Label(root, text="Label 1", bg="red")
label1.grid(row=0, column=0)

label2 = tk.Label(root, text="Label 2", bg="green")
label2.grid(row=0, column=1)

label3 = tk.Label(root, text="Label 3", bg="blue")
label3.grid(row=1, column=0, columnspan=2)

root.mainloop()
```

在这个示例中，我们创建了三个Label小部件，使用grid布局管理器将它们放置在窗口中。我们使用`row`和`column`参数指定小部件的行和列，可以使用`rowspan`和`columnspan`参数指定小部件的大小。grid布局管理器还提供了其他选项，例如`sticky`和`padx`，可以控制小部件在网格中的位置和大小。

#### place布局管理器

place布局管理器是Tkinter中最灵活的布局管理器之一，它允许开发人员使用绝对坐标来放置小部件。place布局管理器使用`place()`方法将小部件添加到容器中，它提供了一些选项，例如`x`、`y`、`width`和`height`，可以控制小部件的位置和大小。

以下是一个使用place布局管理器的简单示例：

```python
import tkinter as tk

root = tk.Tk()

label1 = tk.Label(root, text="Label 1", bg="red")
label1.place(x=50, y=50)

label2 = tk.Label(root, text="Label 2", bg="green")
label2.place(x=100, y=100)

label3 = tk.Label(root, text="Label 3", bg="blue")
label3.place(x=150, y=150, width=50, height=50)

root.mainloop()
```

在这个示例中，我们创建了三个Label小部件，使用place布局管理器将它们放置在窗口中。我们使用`x`和`y`参数指定小部件的位置，可以使用`width`和`height`参数指定小部件的大小。place布局管理器还提供了其他选项，例如`anchor`和`relx`，可以控制小部件在窗口中的位置和大小。

总之，Tkinter提供了三种常用的布局管理器：pack、grid和place。这些布局管理器可以控制小部件在窗口中的位置和大小。pack布局管理器可以将小部件紧凑地放置在窗口中，grid布局管理器使用网格来组织小部件，place布局管理器允许开发人员使用绝对坐标来放置小部件。根据具体需求选择合适的布局管理器可以帮助开发人员更好地构建用户界面。

### Configuration Options@api常用学习策略

- 如果您不确定如何在 Tkinter 中做一些事情，并且您不能立即在您正在使用的教程或参考文档中找到它，这里有一些策略可以帮助您。首先，请记住，在不同版本的 Tkinter 和 Tcl/Tk 中，各个控件如何工作的细节可能会有所不同。如果您正在搜索文档，请确保它与安装在系统上的 Python 和 Tcl/Tk 版本相对应。
- 在搜索如何使用 API 时，知道正在使用的类、选项或方法的确切名称会有所帮助。
- 无论是在交互式 Python shell 中，还是在 [`print()`](https://docs.python.org/zh-cn/3/library/functions.html#print) 中，都可以帮助你确定你需要什么。

#### configure()@

- 要找出控件上可用的配置选项，请调用其 `configure()` 方法，该方法返回一个字典，其中包含每个对象的各种信息，包括其默认值和当前值。

- 使用 `keys()` 获取每个选项的名称。

  - ```python
    btn = ttk.Button(frm, ...)
    print(btn.configure().keys())
    ```

- eg

  - ```python
    import tkinter as tk
    import tkinter.ttk as ttk
    
    root = tk.Tk()
    frm = ttk.Frame(root)
    # frm.pack()
    
    btn = ttk.Button(frm,text="this is a button")
    # btn.pack()
    
    keys=btn.configure().keys()
    print(keys)#type:ignore
    
    # print(dir(btn))
    print()
    print(set(dir(btn)) - set(dir(frm)),"@{set(dir(btn)) - set(dir(frm))}")
    ```

    - ```python
      dict_keys(['command', 'default', 'takefocus', 'text', 'textvariable', 'underline', 'width', 'image', 'compound', 'padding', 'state', 'cursor', 'style', 'class'])
      
      {'invoke'}
      ```

    - `btn.configure()`

      ```bash
      {'command': ('command', 'command', 'Command', '', ''),
       'default': ('default',
        'default',
        'Default',
        <string object: 'normal'>,
        <string object: 'normal'>),
       'takefocus': ('takefocus',
        'takeFocus',
        'TakeFocus',
        'ttk::takefocus',
        'ttk::takefocus'),
       'text': ('text', 'text', 'Text', '', 'this is a button'),
       'textvariable': ('textvariable', 'textVariable', 'Variable', '', ''),
       'underline': ('underline', 'underline', 'Underline', -1, -1),
       'width': ('width', 'width', 'Width', '', ''),
       'image': ('image', 'image', 'Image', '', ''),
       'compound': ('compound', 'compound', 'Compound', '', ''),
       'padding': ('padding', 'padding', 'Pad', '', ''),
       'state': ('state',
        'state',
        'State',
        <string object: 'normal'>,
        <string object: 'normal'>),
       'cursor': ('cursor', 'cursor', 'Cursor', '', ''),
       'style': ('style', 'style', 'Style', '', ''),
       'class': ('class', '', '', '', '')}
      ```

      

  - As you can see, for each option, Tk will show you the name of theoption and its current value (along with three other attributes whichyou won't normally need to worry about).

    - Ok, if you really want to know, here are the details on the five pieces of data provided for each configuration option. 
    - The most useful are **the first**, which is the option's name, 
    - and the fifth, which is the option's **current value**. 
    - The fourth is **the default value** of the option, or in other words, thevalue it would have if you didn't change it. 
    - The other two relate to something called the **option database**. 
      - We'll touch on it when we discuss menus
      -  The second item is <u>the **name** of the option in the database</u>,
      -  and the third is its **class**.

- 由于大多数控件都有许多共同的配置选项，因此<u>找出特定于特定控件类的配置选项</u>可能会很有用。

- 将**选项列表**与更简单的控件（如框架）的列表进行比较是一种方法。

  - ```python
    print(set(btn.configure().keys()) - set(frm.configure().keys()))
    ```

  - ```bash
    {'text', 'compound', 'image', 'underline', 'textvariable', 'default', 'state', 'command'}
    ```



#### dir()

- 类似地，你可以使用标准函数 [`dir()`](https://docs.python.org/zh-cn/3/library/functions.html#dir) 来查找控件对象的可用方法。

- 如果您尝试一下，您会发现有超过200种常见的控件方法

- 因此再次**确认那些特定于控件类的方法是有帮助**的。

- ```python
  print(dir(btn))
  print(set(dir(btn)) - set(dir(frm)))
  ```

### Widget Introspection

- ```python
  
  from tkinter import ttk 
  from tkinter import *
  root=Tk()
  root.geometry("300x300")
  frame=ttk.Frame(root)
  frame.grid()
  label=ttk.Label(frame,text="Hello World!")
  label.grid()
  
  
  def introspect_hierarchy(w, depth=0):
      """
      使用DFS的策略递归检查参数w的信息
      Prints the class, width, height, x and y coordinates of a tkinter widget and
      its children recursively, with indentation to indicate hierarchy depth.
  
      Args:
          w (tkinter widget): The widget to print information about.
          depth (int): The depth of the widget in the hierarchy. Default is 0.
      """
      indent = "  " * depth
      info = f"{w.winfo_class()} w={w.winfo_width()} h={w.winfo_height()} x={w.winfo_x()} y={w.winfo_y()} rootx={w.winfo_rootx()} rooty={w.winfo_rooty()}"
  
      print(f"{indent}{info}")
  
      for child in w.winfo_children():
          introspect_hierarchy(child, depth + 1)
  
  introspect_hierarchy(root)
  # print_hierarchy(frame)
  # print_hierarchy(label)
  root.mainloop()
  ```

### Event Binding事件绑定

- In tkinter, an **event** is an **action** that occurs in a GUI application, such as clicking a button or pressing a key on the keyboard. 
  - Events are generated <u>by the user or the system</u> and are used to trigger specific code to execute in response.

- To **handle** events in tkinter, you need to **bind** <u>a function or method to an event.</u> 
  - This means that you are associating a specific piece of code with a particular event. 
  - When the specified event occurs, the associated code is executed.

- For example, you might bind a button click event to a function that updates a label on the screen. Here's some sample code that demonstrates this concept:

- ```python
  import tkinter as tk
  
  def update_label():
      label.config(text="Button clicked!")
  
  root = tk.Tk()
  
  button = tk.Button(root, text="Click me!", command=update_label)
  button.pack()
  
  label = tk.Label(root, text="Ready")
  label.pack()
  
  root.mainloop()
  ```

- In this code, we create a `Button` widget and bind its `command` parameter to the `update_label` function. This means that when the button is clicked, the `update_label` function will be called. The function updates the text of the `Label` widget to display "Button clicked!".

- In summary, events in tkinter are actions that occur in a GUI application,
- binding is the process of associating a function or method with a specific event.

### bind api

- [bind manual page - Tk Built-In Commands (tcl.tk)](https://tcl.tk/man/tcl8.6/TkCmd/bind.htm)

### 常用事件

1. <Activate>:
   - Window has become active.
2. <Deactivate>:
   - Window has been deactivated.
3. <MouseWheel>:
   - Scroll wheel on mouse has been moved.
4. <KeyPress>:
   - Key on keyboard has been pressed down.
5. <KeyRelease>:
   - Key has been released.
6. <ButtonPress>:
   - A mouse button has been pressed.
7. <ButtonRelease>:
   - A mouse button has been released.
8. <Motion>:
   - Mouse has been moved.
9. <Configure>:
   - Widget has changed size or position.
10. <Destroy>:
    - Widget is being destroyed.
11. <FocusIn>:
    - Widget has been given keyboard focus.
12. <FocusOut>:
    - Widget has lost keyboard focus.
13. <Enter>:
    - Mouse pointer enters widget.
14. <Leave>:
    - Mouse pointer leaves widget.

#### eg

- 以cavans.bind为例

  ```python
  (method) def bind(
      sequence: str | None = None,
      func: ((Event[Canvas]) -> object) | None = None,
      add: bool | Literal['', '+'] | None = None
  ) -> str
  ```

  

- Bind to this widget at event **SEQUENCE** a call to function FUNC.

  **SEQUENCE** is a string of <u>**concatenated event patterns**</u>. An event pattern is of the form `<MODIFIER-MODIFIER-TYPE-DETAIL>` where 

  - `MODIFIER` is one of Control, Mod2, M2, Shift, Mod3, M3, Lock, Mod4, M4, Button1, B1, Mod5, M5 Button2, B2, Meta, M, Button3, B3, Alt, Button4, B4, Double, Button5, B5 Triple, Mod1, M1.

  -  `TYPE` is one of Activate, Enter, Map, ButtonPress, Button, Expose, Motion, ButtonRelease FocusIn, MouseWheel, Circulate, FocusOut, Property, Colormap, Gravity Reparent, Configure, **KeyPress**, Key, Unmap, Deactivate, KeyRelease Visibility, Destroy, Leave 
  - `DETAIL` is the button number for ButtonPress, ButtonRelease and DETAIL is the `Keysym` for **KeyPress** and KeyRelease. 
  - Examples are <Control-Button-1> for pressing Control and mouse button 1 or <Alt-A> for pressing A and the Alt key (**KeyPress** can be omitted). 
  - An event pattern can also be a `virtual event` of the form `<<AString>>` where AString can be arbitrary. This event can be generated by event_generate.
  -  If events are concatenated they must appear shortly after each other.

- **FUNC** will be called if the event sequence occurs with an instance of Event as argument. If the return value of FUNC is "break" no further bound function is invoked.

- An additional boolean parameter **ADD** specifies whether FUNC will be called **additionally** to the other bound function or whether it will **replace** the previous function.

- Bind will return an **identifier** to allow **deletion** of the bound function with unbind without memory leak.

- If FUNC or SEQUENCE is omitted the bound function or list of bound events are returned.

#### Keysyms@keysyms recognized by Tk

- [keysyms manual page - Tk Built-In Commands (tcl.tk)](https://tcl.tk/man/tcl8.6/TkCmd/keysyms.htm)

#### eg

- ```python
  
  from tkinter import * 
  from tkinter import ttk 
  root = Tk() 
  tip="Starting..."
  label =ttk.Label(root, text=tip) 
  label.grid() 
  #binding event by bind api:
  #鼠标事件移动事件
  label.bind('<Enter>', lambda e: label.configure(text='Moved mouse inside')) 
  label.bind('<Leave>', lambda e: label.configure(text='Moved mouse outside')) 
  #鼠标点击事件
  label.bind('<ButtonPress-1>', lambda e: label.configure(text='Clicked left mouse button')) 
  #这里<ButtonPress>表示事件名称
  #-1(hyphen1)后缀表示鼠标主键(左键)
  #可以<ButtonPress-n>简写为<n>
  #<2>鼠标中键(滚轮键重压)(不常用)
  label.bind('<2>', lambda e: label.configure(text='Clicked middle mouse button')) 
  #<3>等价于<ButtonPress-3>也等价于<Button-3>,也就是鼠标右键事件
  label.bind('<3>', lambda e: label.configure(text='Clicked right ouse button')) 
  # <Double-1>是<Double-ButtonPress-1>的缩写,表示双击鼠标左键
  label.bind('<Double-1>', lambda e: label.configure(text='Double clicked')) 
  # 鼠标长按并右键拖动,显示坐标
  #这个事件包含了鼠标按压联合移动,同时演示了时间参数(e.x,e.y)的使用(鼠标移动返回坐标)
  #这里<B3>鼠标右键(ButtonPress-3),Motion是对鼠标移动的捕获
  
  label.bind('<B3-Motion>', lambda e: label.configure(text='right button drag to %d,%d' % (e.x, e.y))) 
  #启动循环事件
  root.mainloop()
  ```


### Virtual Events

- The events we've seen so far are low-level operating system eventslike mouse clicks and window resizes. Many widgets also generatehigher level or semantic events called virtual events. These areindicated by double angle brackets around the event name, e.g.,<<foo>>.For example, a listbox widget will generate a <<ListboxSelect>>virtual event whenever its selection changes.
-  The same virtual eventis generated whether a user clicked on an item, moved to it using thearrow keys, or some other way. Virtual events avoid the problem ofsetting up multiple, possibly platform-specific event bindings tocapture common changes. 
- The available virtual events for a widgetwill be listed in the documentation for the widget class.Tk also defines virtual events for common operations that aretriggered in different ways for different platforms. These include<<Cut>>, <<Copy>> and <<Paste>>.

- You can define your own virtual events, which can be specific toyour application. This can be a useful way to keep platform-specificdetails isolated in a single module, while you use the virtual eventthroughout your application. Your own code can generate virtualevents that work in exactly the same way that virtual eventsgenerated by Tk do.root.event_generate("<<MyOwnEvent>>")

#### 一个事件绑定多个函数

- tkinter中的Multiple Bindings for an Event:在Tkinter中，可以使用bind方法来将事件绑定到小部件上。
- 如果您为同一个事件绑定了多个函数，这称为“多个绑定”。

- 例如，以下代码将鼠标左键单击事件绑定到一个按钮上：


```python
import tkinter as tk

def func1(event):
    print("function 1")

def func2(event):
    print("function 2")

root = tk.Tk()
button = tk.Button(root, text="Click me")
button.pack()

button.bind("<Button-1>", func1)
button.bind("<Button-1>", func2)

root.mainloop()
```

- 在这个例子中，当单击按钮时，将只会调用`func2`。

  - 因为func1被后来的绑定`func2`所屏蔽

  - ```python
    #button.bind("<Button-1>", func1)
    button.bind("<Button-1>", func2,add=True)
    ```

    - 如果我们将代码中相应片段修改(使用了`add`)参数,那么一个事件可以有序触发多个binding(函数)

    - ```text
      function 1
      function 2
      ```

    

- 您可以通过unbind方法来解除绑定，例如：

```python
button.unbind("<Button-1>", func1)
```

- 这将解除func1与鼠标左键单击事件的绑定。

#### 多个事件绑定到同一个组件/函数

- ```python
  import tkinter as tk
  
  # 创建一个 Tkinter 窗口
  root = tk.Tk()
  
  # 定义一个事件处理函数
  def handle_event_position_info(event):
      print(f'Event {event.type} occurred at ({event.x}, {event.y})')
  
  # 创建一个 Canvas 组件
  canvas = tk.Canvas(root, width=200, height=200)
  
  # 向 Canvas 组件绑定多个事件
  canvas.bind('<Button-1>', handle_event_position_info)
  canvas.bind('<Button-2>', handle_event_position_info)
  canvas.bind('<Button-3>', handle_event_position_info)
  
  # 将 Canvas 组件添加到窗口中
  canvas.pack()
  
  # 进入 Tkinter 主循环
  root.mainloop()
  
  ```

  

## 编写一个feet2meter的长度单位转换程序

- [ Tkdocs · GitCode](https://gitcode.net/xuchaoxin1375/tkdocs)

- 这部分一些细节先跳过,以后再聊

- ```python
  from tkinter import *
  from tkinter import ttk
  
  
  def calculate(*args):
      """Performing the Calculation
  
      As you can clearly see, this routine takes the number of feet from our
      entry widget, does the calculation, and places the result in our label
      widget.
      这里的feet.get()是tkinter中的用法
      feet是一个全局变量(type=StringVar)
      本例中,我需要读取feet的值(用户输入),根据这个值做单位换算,然后通过将计算结果设置到meters中
      读取和设置分别使用StringValue提供的get方法和set方法
      """
      try:
          value = float(feet.get())
          meters.set(int(0.3048 * value * 10000.0 + 0.5) / 10000.0)
      except ValueError:
          pass
  
  
  # Setting up the Main Application Window
  root = Tk()
  root.title("Feet to Meters")
  # Creating a Content Frame
  mainframe = ttk.Frame(root, padding="3 3 12 12")
  mainframe.grid(column=0, row=0, sticky=(N, W, E, S))
  root.columnconfigure(0, weight=1)
  root.rowconfigure(0, weight=1)
  
  # Creating the Entry Widget
  #我们实例化2个可变字符串,它们被渲染在界面上,如果以正确的方式修改它们的值,就可以在界面及时的更新这些值
  feet = StringVar()
  meters = StringVar()
  # Here's where the magic textvariable options we specified
  # when creating the widgets come into play. We specified the global
  # variable feet as the textvariable for the entry, which means that
  # anytime the entry changes, Tk will automatically update the global
  # variable feet. 
  feet_entry = ttk.Entry(mainframe, width=7, textvariable=feet)
  feet_entry.grid(column=2, row=1, sticky=(W, E))
  
  ttk.Label(mainframe, textvariable=meters).grid(column=2, row=2, sticky=(W, E))
  ttk.Button(mainframe, text="Calculate", command=calculate).grid(
      column=3, row=3, sticky=W
  )
  
  ttk.Label(mainframe, text="feet").grid(column=3, row=1, sticky=W)
  ttk.Label(mainframe, text="is equivalent to").grid(column=1, row=2, sticky=E)
  ttk.Label(mainframe, text="meters").grid(column=3, row=2, sticky=W)
  
  
  # adding some polish
  for child in mainframe.winfo_children():
      child.grid_configure(padx=5, pady=5)
  
  feet_entry.focus()
  root.bind("<Return>", calculate)
  # Start the Event Loop
  root.mainloop()
  
  ```

  

### sticky参数<TODO>

- Tkinter中的sticky参数用于指定Widget在其所在的区域中的对齐方式。它可以应用于pack()、grid()和place()等几种布局管理器中。

  sticky参数的取值可以是组合的方向值，如N、S、E、W，也可以是它们的组合，如NE、SW、NW、SE。这些方向值表示Widget在其所在的区域中的对齐方式，如：

  - N：表示Widget在区域的上方对齐
  - S：表示Widget在区域的下方对齐
  - E：表示Widget在区域的右侧对齐
  - W：表示Widget在区域的左侧对齐
  - NE：表示Widget在区域的右上方对齐
  - SW：表示Widget在区域的左下方对齐
  - NW：表示Widget在区域的左上方对齐
  - SE：表示Widget在区域的右下方对齐

  如果需要在多个方向上对齐Widget，可以使用它们的组合，例如"NW"表示Widget在区域的左上方对齐。

  在使用sticky参数时，可以组合多个方向值，表示Widget在其所在区域中的对齐方式。例如，如果将sticky设置为"NS"，则Widget将在其所在区域的上下两侧都对齐。

- 需要注意的是，当使用grid()布局管理器时，sticky参数只能应用于填充单元格的Widget，而不能应用于使用columnspan或rowspan跨越多个单元格的Widget。

- 例如，`sticky`参数被设置为`(W, E)`，这意味着小部件将被左对齐和右对齐。具体来说，这意味着小部件将完全填充其单元格，并将其左边缘对齐网格的左边缘，同时将其右边缘对齐网格的右边缘。

- 这通常用于将小部件放置在窗口的底部，并使其水平居中对齐。

  下面是一个示例代码，演示了`grid()`方法中`sticky`参数的使用：

  ```python
  import tkinter as tk
  
  root = tk.Tk()
  root.geometry("200x100")
  
  label = tk.Label(root, text="Hello, World!")
  label.grid(row=0, column=0, sticky=(tk.W, tk.E))
  
  root.mainloop()
  ```

- 在这个例子中，我们创建了一个`Label`小部件，并将其放置在网格的第一行第一列。

- `sticky`参数被设置为`(W, E)`，以便使标签左对齐和右对齐。这使得标签在窗口中水平居中对齐

- 下面是一个简单的例子，可以让你体验sticky参数的效果。这个例子使用grid()布局管理器，将三个Button Widget放在一个Frame Widget中，并使用sticky参数来指定它们的对齐方式。

  ```python
  import tkinter as tk
  
  root = tk.Tk()
  
  frame = tk.Frame(root, bg="gray", padx=10, pady=10)
  frame.grid(row=0, column=0, sticky="NESW")
  
  btn1 = tk.Button(frame, text="Button 1")
  btn1.grid(row=0, column=0, sticky="W")
  
  btn2 = tk.Button(frame, text="Button 2")
  btn2.grid(row=1, column=0, sticky="E")
  
  btn3 = tk.Button(frame, text="Button 3")
  btn3.grid(row=0, column=1, rowspan=2, sticky="NS")
  
  root.mainloop()
  ```

  在上面的例子中，我们创建了一个Frame Widget，并将其放置在主窗口的第一行第一列。然后我们在Frame Widget中添加了三个Button Widget，分别是Button 1、Button 2和Button 3。

  使用sticky参数，我们指定了Button 1在其所在的区域的左侧对齐，Button 2在其所在的区域的右侧对齐，Button 3在其所在的区域的上下两侧都对齐。最终的效果如下图所示：

  

  从上面的例子中可以看出，使用sticky参数可以方便地对Widget进行对齐，使得布局更加美观和易读。

- 下面是一个稍微改动了一下sticky参数的例子，可以让你更清楚地看出不同参数的效果。在这个例子中，我们将三个Button Widget放在一个Frame Widget中，并使用不同的sticky参数来指定它们的对齐方式。

  ```python
  import tkinter as tk
  
  root = tk.Tk()
  
  frame = tk.Frame(root, bg="gray", padx=10, pady=10)
  frame.grid(row=0, column=0)
  
  btn1 = tk.Button(frame, text="Button 1")
  btn1.grid(row=0, column=0, sticky="W")
  
  btn2 = tk.Button(frame, text="Button 2")
  btn2.grid(row=1, column=0, sticky="E")
  
  btn3 = tk.Button(frame, text="Button 3")
  btn3.grid(row=0, column=1, rowspan=2, sticky="NS")
  
  root.mainloop()
  ```

  - 在上面的例子中，我们将Button 1设置为左对齐，Button 2设置为右对齐，Button 3设置为上下对齐。你可以尝试修改sticky参数的值来观察效果的变化。

  例如，将Button 1的sticky参数设置为"WE"，可以让它在水平方向上占据整个区域；将Button 2的sticky参数设置为"NS"，可以让它在垂直方向上占据整个区域。你还可以尝试组合不同的方向值来看看效果的变化。





