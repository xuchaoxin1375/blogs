[toc]

## Graph Element@图形元素@sg.Graph

- All you math fans will enjoy this Element... and all you non-math fans will enjoy it even more.
- I've found nothing to be less fun than dealing with a graphic's coordinate system from a GUI Framework. It's always upside down from what I want. (0,0) is in the upper left hand corner.... sometimes... or was it in the lower left? In short, it's a **pain in the ass**.
- How about the ability to get your own location of (0,0) and then using those coordinates instead of what tkinter provides? This results in a very powerful capability - working in your own units, and then displaying them in an area defined in pixels.
- If you've ever been frustrated with where (0,0) is located on some surface you draw on, then fear not, your frustration ends right here. You get to draw using whatever coordinate system you want. Place (0,0) anywhere you want, including not anywhere on your Graph. You could define a Graph that's all negative numbers between -2.1 and -3.5 in the X axis and -3 to -8.2 in the Y axis

There are 3 values you'll need to supply the Graph Element. They are:

- Size of the canvas in pixels
- The lower left (x,y) coordinate of your coordinate system
- The upper right (x,y) coordinate of your coordinate system

After you supply those values you can scribble all of over your graph by creating Graph Figures. Graph Figures are created, and a Figure ID is obtained by calling:

- DrawCircle
- DrawLine
- DrawPoint
- DrawRectangle
- DrawOval
- DrawImage

You can move your figures around on the canvas by supplying the Figure ID the **x,y delta** to move. It does not move to an absolute position, but rather an offset from where the figure is now. (Use Relocate to move to a specific location)

```python
graph.MoveFigure(my_circle, 10, 10)
```

You'll also use this ID to delete individual figures you've drawn:

```python
graph.DeleteFigure(my_circle)
```

所有的数学爱好者都会喜欢这个元素……而所有不喜欢数学的人会更喜欢它。

- 我发现从GUI框架中处理图形坐标系是最不有趣的事情。它总是与我想要的相反。(0,0)在左上角……有时候……或者它是在左下角吗？简而言之，这是一个烦人的问题。
- 如果你能够获取自己的(0,0)位置，然后使用这些坐标代替tkinter提供的坐标，那会怎样呢？这将产生一种非常强大的能力——以自己的单位工作，然后在像素中定义的区域中显示它们。
- 如果你曾经对你绘制的某个表面上的(0,0)位置感到失望，那么不要担心，你的挫败感会在这里结束。你可以使用任何你想要的坐标系进行绘制。将(0,0)放在任何你想要的地方，甚至不在你的图形上。
- 你可以定义一个在X轴上的所有负数(-2.1到-3.5)，在Y轴上的所有负数(-3到-8.2)的图形。

有三个值你需要提供给Graph Element。它们是：

1. 画布的像素大小
2. 你的坐标系的左下角(x,y)坐标
3. 你的坐标系的右上角(x,y)坐标

提供了这些值之后，你可以通过创建Graph Figures在你的图形上涂鸦。通过调用以下方法，可以创建Graph Figures并获得Figure ID：

- DrawCircle
- DrawLine
- DrawPoint
- DrawRectangle
- DrawOval
- DrawImage

你可以通过提供Figure ID和x,y偏移量在画布上移动你的图形。它不会移动到绝对位置，而是从图形现在的位置移动到一个偏移量。(使用Relocate将其移动到特定位置)

- `graph.MoveFigure(my_circle, 10, 10)`
- 你还将使用这个ID来删除你绘制的单个图形：

- `graph.DeleteFigure(my_circle)`

### demos

- 在pysimplegui的demo文件下,执行:`ls -Filter *graph*.py -Recurse`查看相关实例

## Matplotlib Window With GUI Window

- [Matplotlib Window With GUI Window](https://www.pysimplegui.org/en/latest/cookbook/#matplotlib-window-with-gui-window)

### demos

- ```python
  from matplotlib import use
  import PySimpleGUI as sg
  # import PySimpleGUIQt as sg; use('qt5agg')
  import matplotlib.pyplot as plt
  
  """
      Simultaneous PySimpleGUI Window AND a Matplotlib Interactive Window
      A number of people have requested the ability to run a normal PySimpleGUI window that
      launches a MatplotLib window that is interactive with the usual Matplotlib controls.
      It turns out to be a rather simple thing to do.  The secret is to add parameter block=False to plt.show()
  """
  
  def draw_plot():
      plt.plot([0.1, 0.2, 0.5, 0.7])
      plt.show(block=False)
  
  layout = [[sg.Button('Plot'), sg.Cancel(), sg.Button('Popup')]]
  
  window = sg.Window('Have some Matplotlib....', layout)
  
  while True:
      event, values = window.read()
      if event in (sg.WIN_CLOSED, 'Cancel'):
          break
      elif event == 'Plot':
          draw_plot()
      elif event == 'Popup':
          sg.popup('Yes, your application is still running')
  window.close()
  
  ```

- 这是个最简单的例子,点击`plot`弹出一个`matplotlib`窗口,同时旧窗口还是可以操作(点击`popup`可以证明这一点,点击`cancel`将关闭所有窗口)

- 这种用法和pysimplegui本身关系不大,绘图的窗口和pysimplegui关联性不强,也没有什么技巧

- 们一般对将绘制的图嵌入到pysimplegui中比较感兴趣

## Canvas Element@`sg.Canvas`

- In my opinion, the tkinter Canvas Widget is the most powerful of the tkinter widget.
-  While I try my best to completely isolate the user from anything that is tkinter related, the Canvas Element is the one exception. 
- It enables integration with a number of other packages, often with spectacular results.
- However, there's another way to get that power and that's through the **Graph Element**, an even MORE powerful Element as it uses a Canvas that you can directly access if needed. 
- The Graph Element has a large number of drawing methods that the Canvas Element does not have. 
- Plus, if you need to, you can access the Graph Element's "Canvas" through a member variable.

To get a <u>`tkinter Canvas Widget`</u> from PySimpleGUI, follow these steps:

- Add Canvas Element to your window
- Layout your window 
- Call `window.Finalize()` - this is a critical step you must not forget 
- Find the Canvas Element by looking up using key
- Your Canvas Widget Object will be the found_element.TKCanvas

-  Draw on your canvas to your heart's content 

* Call `window.read()` - Nothing will appear on your canvas until you call Read

See `Demo_Matplotlib.py` for a Recipe you can copy.

# matplotlib backend

- [Backends — Matplotlib documentation](https://matplotlib.org/stable/users/explain/backends.html)

## backend

- A lot of documentation on the website and in the mailing lists refers to the "**backend**" and many new users are confused by this term. Matplotlib targets many different use cases and output formats. 
  - Some people use Matplotlib interactively from the Python shell and have plotting windows pop up when they type commands. 
  - Some people run [Jupyter](https://jupyter.org/) notebooks and draw inline plots for quick data analysis. 
  - Others embed Matplotlib into graphical user interfaces like PyQt or PyGObject to build rich applications. 
  - Some people use Matplotlib in batch scripts to generate postscript images from numerical simulations, and still others run web application servers to dynamically serve up graphs.

- To support all of these use cases, <u>Matplotlib can target different outputs, and each of these capabilities is called a backend;</u> 

- 网站和邮件列表中的许多文档都提到了“后端”，这个术语让许多新用户感到困惑。Matplotlib面向许多不同的用例和输出格式。有些人在Python shell中交互使用Matplotlib，并在键入命令时弹出绘图窗口。有些人运行Jupyter笔记本并绘制内联图以进行快速数据分析。其他人将Matplotlib嵌入到图形用户界面中，例如PyQt或PyGObject，以构建丰富的应用程序。有些人在批处理脚本中使用Matplotlib生成来自数值模拟的Postscript图像，还有些人运行Web应用程序服务器以动态提供图形。

  为了支持所有这些用例，Matplotlib可以针对不同的输出，并且每个这样的功能被称为后端；

## frontend

- the "**frontend**" is the user facing code, i.e., the plotting code, whereas the "backend" does all the hard work behind-the-scenes to make the figure. 
- “前端”是用户面向的代码，即绘图代码，而“后端”则在幕后完成所有艰难的工作以生成图形。

### 后端类型

- There are **two types of backends**: 
  - **user interface backends** (for use in PyQt/PySide, PyGObject, Tkinter, wxPython, or macOS/Cocoa); also referred to as **"interactive backends"**) and
  -  **hardcopy backends** to make image files (PNG, SVG, PDF, PS; also referred to as **"non-interactive backends"**).
- 有两种类型的后端：用户界面后端（用于PyQt / PySide，PyGObject，Tkinter，wxPython或macOS / Cocoa；也称为“交互式后端”）
- 硬拷贝后端以生成图像文件（PNG，SVG，PDF，PS；也称为“非交互式后端”）。

### AGG

- AGG是一种图形渲染库，全称为Anti-Grain Geometry。
- 它是一个高质量、平台无关的2D图形库，用于绘制矢量图形和栅格图像。
- Matplotlib可以使用AGG作为其中一种后端，以生成高质量的栅格图像，例如PNG、JPEG、PDF等。
- AGG后端支持抗锯齿和Alpha通道等高级特性，可以生成平滑、清晰的图像。

### 配置后端

#### Note@不区分大小写

The names of builtin backends case-insensitive; e.g., 'QtAgg' and 'qtagg' are equivalent.

#### 三种配置方式

There are three ways to configure your backend:

- The `rcParams["backend"]` parameter in your `matplotlibrc` file

- The [`MPLBACKEND`](https://matplotlib.org/stable/users/faq/environment_variables_faq.html#envvar-MPLBACKEND) environment variable

- The function [`matplotlib.use()`](https://matplotlib.org/stable/api/matplotlib_configuration_api.html#matplotlib.use)

- Here is a detailed description of the configuration methods:

  1. Setting `rcParams["backend"]` in your `matplotlibrc` file:

     ```
     backend : qtagg   # use pyqt with antigrain (agg) rendering
     ```

     

     See also [Customizing Matplotlib with style sheets and rcParams](https://matplotlib.org/stable/tutorials/introductory/customizing.html).

  2. Setting the [`MPLBACKEND`](https://matplotlib.org/stable/users/faq/environment_variables_faq.html#envvar-MPLBACKEND) environment variable:

     You can set the environment variable either for your current shell or for a single script.

     On Unix:

     ```
     > export MPLBACKEND=qtagg
     > python simple_plot.py
     
     > MPLBACKEND=qtagg python simple_plot.py
     ```

     

     On Windows, only the former is possible:

     ```
     > set MPLBACKEND=qtagg
     > python simple_plot.py
     ```

     

     Setting this environment variable will override the `backend` parameter in *any* `matplotlibrc`, even if there is a `matplotlibrc` in your current working directory. Therefore, setting [`MPLBACKEND`](https://matplotlib.org/stable/users/faq/environment_variables_faq.html#envvar-MPLBACKEND) globally, e.g. in your `.bashrc` or `.profile`, is discouraged as it might lead to counter-intuitive behavior.

  3. If your script depends on a specific backend you can use the function [`matplotlib.use()`](https://matplotlib.org/stable/api/matplotlib_configuration_api.html#matplotlib.use):

     ```
     import matplotlib
     matplotlib.use('qtagg')
     ```

     This should be done before any figure is created, otherwise Matplotlib may fail to switch the backend and raise an ImportError.

     Using [`use`](https://matplotlib.org/stable/api/matplotlib_configuration_api.html#matplotlib.use) will require changes in your code if users want to use a different backend. Therefore, you should avoid explicitly calling [`use`](https://matplotlib.org/stable/api/matplotlib_configuration_api.html#matplotlib.use) unless absolutely necessary.

     使用`use`需要动到代码文件,因此通常情况下尽量不要使用,否则会增加维护负担(类似于html中使用内联样式)

#### 在matplotlibrc文件中使用rcParams["backend"]参数：

matplotlibrc文件是控制matplotlib行为的配置文件。您可以在该文件中设置各种参数，包括后端参数。要在该文件中设置后端，请找到rcParams字典并将其设置为所需的后端名称。例如，要将后端设置为Qt5Agg，请在文件中添加以下行：

 

```python
backend: Qt5Agg
```

#### 使用MPLBACKEND环境变量：

您可以通过设置MPLBACKEND环境变量来配置后端。在您的终端中，使用以下命令将环境变量设置为所需的后端名称：

 

```python
export MPLBACKEND=Qt5Agg
```

这将把后端设置为Qt5Agg。请注意，这种方法只对当前终端会话有效。

#### 使用matplotlib.use()函数：

您还可以在Python代码中使用matplotlib.use()函数来设置后端。例如，要将后端设置为Qt5Agg，请在代码中添加以下行：



```python
import matplotlib
matplotlib.use('Qt5Agg')
```

请注意，您必须在导入任何其他matplotlib模块之前调用此函数。此外，如果您在Jupyter笔记本中使用此方法，则应在笔记本的第一行中包含以下行：

 

```python
%matplotlib inline
```

这将确保Jupyter笔记本使用所选的后端来绘制图形。

#### 配置间的优先级

- If there is more than one configuration present, the last one from the list takes precedence;
-  e.g. calling [`matplotlib.use()`](https://matplotlib.org/stable/api/matplotlib_configuration_api.html#matplotlib.use) will override the setting in your `matplotlibrc`.

#### 默认行为

- Without a backend explicitly set, Matplotlib automatically detects a usable backend based on what is available on your system and on whether a GUI event loop is already running. 
- The first usable backend in the following list is selected: MacOSX, QtAgg, GTK4Agg, Gtk3Agg, TkAgg, WxAgg, Agg. The last, Agg, is a non-interactive backend that can only write to files. It is used on Linux, if Matplotlib cannot connect to either an X display or a Wayland display.
- 如果没有显式设置后端，Matplotlib会根据您的系统上可用的后端以及GUI事件循环是否已经在运行来自动检测可用的后端。
- 在下面的列表中，第一个可用的后端将被选择：MacOSX、QtAgg、GTK4Agg、Gtk3Agg、TkAgg、WxAgg、Agg。
  - 最后一个后端Agg是一个非交互式的后端，只能将图形写入文件。
  - 如果Matplotlib无法连接到X display或Wayland display，则在Linux上使用它。

#### X display和Wayland display

- X display和Wayland display是Linux系统上的两种图形显示协议。
  - X display（也称为X11或X Window System）是最常见的Linux图形显示协议之一。它允许远程计算机通过网络连接到图形应用程序的运行实例，因此它非常适合用于远程计算机的图形应用程序。在基于X的系统上，Matplotlib可以使用X显示器来显示图形窗口。
  - Wayland display是一种相对较新的Linux图形显示协议，旨在替代X display。与X display不同，Wayland display更加现代化和安全，具有更好的性能和更低的延迟。
  - 但是，由于它的相对较新，一些应用程序可能不支持它。在基于Wayland的系统上，Matplotlib可以使用Wayland显示器来显示图形窗口。

## 后端的选择@The builtin backends

By default, Matplotlib should automatically select a default backend which allows both interactive work and plotting from scripts, with output to the screen and/or to a file, so at least initially, you will not need to worry about the backend. The most common exception is if your Python distribution comes without [`tkinter`](https://docs.python.org/3/library/tkinter.html#module-tkinter) and you have no other GUI toolkit installed. This happens with certain Linux distributions, where you need to install a Linux package named `python-tk` (or similar).

- If, however, you want to write graphical user interfaces, or a web application server ([Embedding in a web application server (Flask)](https://matplotlib.org/stable/gallery/user_interfaces/web_application_server_sgskip.html)), or need a better understanding of what is going on, read on. To make things easily more customizable for graphical user interfaces, <u>Matplotlib separates the concept of the renderer (the thing that actually does the drawing) from the canvas (the place where the drawing goes).</u> 
- The **canonical** renderer for user interfaces is `Agg` which uses the [Anti-Grain Geometry](http://agg.sourceforge.net/antigrain.com/) C++ library to make a raster (pixel) image of the figure; 
- it is used by the `QtAgg`, `GTK4Agg`, `GTK3Agg`, `wxAgg`, `TkAgg`, and `macosx` backends. An alternative renderer is based on the Cairo library, used by `QtCairo`, etc.

### 渲染引擎

For the rendering engines, users can also distinguish between [vector](https://en.wikipedia.org/wiki/Vector_graphics) or [raster](https://en.wikipedia.org/wiki/Raster_graphics) renderers. Vector graphics languages issue drawing commands like "draw a line from this point to this point" and hence are **scale free**. Raster backends generate a pixel representation of the line whose accuracy depends on a DPI setting.

- 对于Matplotlib的渲染引擎，用户还可以区分矢量或光栅渲染器。
- 矢量图形语言发出绘制命令，如“从这个点画一条线到这个点”，因此**不受缩放的影响**。
- 光栅后端生成线的像素表示，其准确性取决于DPI设置。

- 矢量渲染器使用数学公式和几何图形来描述图像，因此图像可以随意缩放而不失真。常见的矢量渲染器包括PDF、SVG和EPS等。
- 光栅渲染器使用像素网格来描述图像，并将图像分解为像素，每个像素都有其颜色和亮度值。因此，光栅图像不能无限缩放而不失真，其精度取决于所使用的DPI（每英寸点数）值。常见的光栅渲染器包括PNG、JPEG和BMP等。
- Matplotlib的默认后端Agg是一个光栅渲染器，它会生成像素化的图像。但是，Matplotlib还提供了一些矢量后端，例如PDF和SVG，可以生成无损矢量图像。

### 什么默认使用raster渲染器?

- Matplotlib的默认后端Agg使用光栅渲染器，主要是为了性能和兼容性考虑。
- 光栅渲染器可以快速生成图像，特别是对于大型或复杂的图像，它可以提供更好的渲染性能。相比之下，矢量渲染器需要更多的计算和内存来绘制图像，因此在某些情况下可能会更慢。
- 此外，光栅渲染器常常能够更好地与不同的操作系统和硬件兼容，因为它们生成的图像格式（如PNG、JPEG等）是标准的图像格式，可以在几乎任何系统上查看。相比之下，矢量图像格式如PDF、SVG等可能需要特定的软件或浏览器才能查看，这可能会限制其兼容性。
- 然而，如果您需要绘制高质量、可无限缩放的图像，则可以选择使用矢量渲染器，例如PDF或SVG后端。这些后端可以生成无损矢量图像，保留图像的所有细节和信息，并且可以随意缩放。

- Here is a summary of the Matplotlib **renderers** (there is an eponymous **backend** for each)

#### 非交互式后端

- "Eponymous" 是一个形容词，用来形容一个事物的名称和这个事物本身是相同的，即名称和事物的本体相同。
- 在Matplotlib的上下文中，每个渲染器都有一个相应的后端，这个<u>后端的名称和渲染器本身的名称相同</u>，因此可以使用 "eponymous" 来形容这种关系

- these are *non-interactive backends*, capable of writing to a file

| Renderer | Filetypes         | Description                                                  |
| -------- | ----------------- | ------------------------------------------------------------ |
| AGG      | png               | [raster](https://en.wikipedia.org/wiki/Raster_graphics) graphics -- high quality images using the [Anti-Grain Geometry](http://agg.sourceforge.net/antigrain.com/) engine. |
| PDF      | pdf               | [vector](https://en.wikipedia.org/wiki/Vector_graphics) graphics -- [Portable Document Format](https://en.wikipedia.org/wiki/Portable_Document_Format) output. |
| PS       | ps, eps           | [vector](https://en.wikipedia.org/wiki/Vector_graphics) graphics -- [PostScript](https://en.wikipedia.org/wiki/PostScript) output. |
| SVG      | svg               | [vector](https://en.wikipedia.org/wiki/Vector_graphics) graphics -- [Scalable Vector Graphics](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics) output. |
| PGF      | pgf, pdf          | [vector](https://en.wikipedia.org/wiki/Vector_graphics) graphics -- using the [pgf](https://ctan.org/pkg/pgf) package. |
| Cairo    | png, ps, pdf, svg | [raster](https://en.wikipedia.org/wiki/Raster_graphics) or [vector](https://en.wikipedia.org/wiki/Vector_graphics) graphics -- using the [Cairo](https://www.cairographics.org/) library (requires [pycairo](https://www.cairographics.org/pycairo/) or [cairocffi](https://pythonhosted.org/cairocffi/)). |

##### 保存绘图为图片的api

To save plots using the non-interactive backends, use the `matplotlib.pyplot.savefig('filename')` method.



These are the user interfaces and renderer combinations supported;

 these are *interactive backends*, capable of displaying to the screen and using appropriate renderers from the table above to write to a file:这些是支持的用户界面和渲染器组合；这些是交互式后端，能够显示到屏幕并使用上面表格中适当的渲染器来写入文件：

| Backend   | Description                                                  |
| --------- | ------------------------------------------------------------ |
| QtAgg     | Agg rendering in a [Qt](https://qt.io/) canvas (requires [PyQt](https://riverbankcomputing.com/software/pyqt/intro) or [Qt for Python](https://doc.qt.io/qtforpython/), a.k.a. PySide). This backend can be activated in IPython with `%matplotlib qt`. The Qt binding can be selected via the [`QT_API`](https://matplotlib.org/stable/users/faq/environment_variables_faq.html#envvar-QT_API) environment variable; see [Qt Bindings](https://matplotlib.org/stable/api/backend_qt_api.html#qt-bindings) for more details. |
| ipympl    | Agg rendering embedded in a Jupyter widget (requires [ipympl](https://www.matplotlib.org/ipympl)). This backend can be enabled in a Jupyter notebook with `%matplotlib ipympl`. |
| GTK3Agg   | Agg rendering to a [GTK](https://www.gtk.org/) 3.x canvas (requires [PyGObject](https://wiki.gnome.org/action/show/Projects/PyGObject) and [pycairo](https://www.cairographics.org/pycairo/)). This backend can be activated in IPython with `%matplotlib gtk3`. |
| GTK4Agg   | Agg rendering to a [GTK](https://www.gtk.org/) 4.x canvas (requires [PyGObject](https://wiki.gnome.org/action/show/Projects/PyGObject) and [pycairo](https://www.cairographics.org/pycairo/)). This backend can be activated in IPython with `%matplotlib gtk4`. |
| macosx    | Agg rendering into a Cocoa canvas in OSX. This backend can be activated in IPython with `%matplotlib osx`. |
| TkAgg     | Agg rendering to a [Tk](https://www.tcl.tk/) canvas (requires [TkInter](https://docs.python.org/3/library/tk.html)). This backend can be activated in IPython with `%matplotlib tk`. |
| nbAgg     | Embed an interactive figure in a Jupyter classic notebook. This backend can be enabled in Jupyter notebooks via `%matplotlib notebook`. |
| WebAgg    | On `show()` will start a tornado server with an interactive figure. |
| GTK3Cairo | Cairo rendering to a [GTK](https://www.gtk.org/) 3.x canvas (requires [PyGObject](https://wiki.gnome.org/action/show/Projects/PyGObject) and [pycairo](https://www.cairographics.org/pycairo/)). |
| GTK4Cairo | Cairo rendering to a [GTK](https://www.gtk.org/) 4.x canvas (requires [PyGObject](https://wiki.gnome.org/action/show/Projects/PyGObject) and [pycairo](https://www.cairographics.org/pycairo/)). |
| wxAgg     | Agg rendering to a [wxWidgets](https://www.wxwidgets.org/) canvas (requires [wxPython](https://www.wxpython.org/) 4). This backend can be activated in IPython with `%matplotlib wx`. |

#### eg 在jupyter notebook中使用qt渲染出图

- 将这段代码粘贴到jupyter notebook上运行

  ```python
  %matplotlib 
  
  import matplotlib.pyplot as plt
  import numpy as np
  
  # 生成数据
  x = np.linspace(0, 10, 100)
  y = np.sin(x)
  
  # 绘制图形
  fig, ax = plt.subplots()
  ax.plot(x, y)
  
  # 显示图形界面
  plt.show()
  ```

#### conda notebook环境中提示错误问题😂

- Error:`Failed to import any qt binding`
- 这可能时conda环境过于复杂或混合使用conda install 和 pip install 安装了相关包(notebook,matplotlib)
- 可以尝试创建一个一个全新的环境来后体验相关功能

## matplotlib@tkagg



- Matplotlib 是一个流行的 Python 绘图库，它提供了各种绘图功能，包括折线图、散点图、柱状图、等高线图等。

- TkAgg 是 Matplotlib 的一个**后端**，它可以将 Matplotlib 绘图输出到 Tkinter 窗口中。

- 下面是一个简单的示例，展示如何使用 Matplotlib TkAgg 后端在 Tkinter 窗口中绘制一条简单的折线图：

  - ```python
    import tkinter as tk
    import matplotlib.pyplot as plt
    from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
    
    # Create tkinter window
    root = tk.Tk()
    root.geometry('500x500')
    
    # Create matplotlib figure
    fig = plt.Figure()
    ax = fig.add_subplot(111)
    x = [1, 2, 3, 4, 5]
    y = [2, 4, 3, 1, 5]
    ax.plot(x, y)
    
    # Add matplotlib figure to tkinter window
    canvas = FigureCanvasTkAgg(fig, master=root)
    canvas.get_tk_widget().pack()
    
    # Start tkinter event loop
    tk.mainloop()
    ```

  

- 在这个例子中，我们首先创建了一个 `Tkinter` 窗口，并指定了其大小为 500x500。

- 然后，我们创建了一个 `Matplotlib Figure` 对象，并向其中添加一个 `Axes 子图`。

  - 在这个子图中，我们使用 `plot` 方法绘制了一个简单的折线图。

- 接下来，我们使用 `FigureCanvasTkAgg` 类将 `Matplotlib Figure 对象(fig)`添加到 `Tkinter 窗口`中。

  - 我们首先将 Matplotlib Figure 对象传递给 `FigureCanvasTkAgg` 类的构造函数
  - 然后使用 `get_tk_widget` 方法**获取一个 Tkinter 组件**，该组件包含了 Matplotlib 绘图的输出。

- 最后，我们使用 `pack` 方法将该**组件添加到 Tkinter 窗口中的某个位置**。

- 我们使用 `mainloop` 方法启动 Tkinter 事件循环，以便用户可以与窗口进行交互。

- 这只是一个简单的示例，但它展示了如何使用 Matplotlib TkAgg 后端在 Tkinter 窗口中绘制图形。

  - 你可以使用 Matplotlib 绘制各种类型的图形，并将它们嵌入到 Tkinter 窗口中。

## 动态添加组件@extend_layout🎈

### extend_layout

- Adds new rows to an existing container element inside of this window If the container is a scrollable Column, you need to also call the contents_changed() method

- 下面是一个示例代码，演示如何使用 `extend_layout` 方法向一个容器元素添加新行：

```python
import PySimpleGUI as sg

# 创建一个包含一个按钮的列
col = [[sg.Button('Button 1')]]

# 创建 PySimpleGUI 窗口
layout = [[sg.Column(col, scrollable=True, size=(200, 200))]]
window = sg.Window('Extend Layout Example', layout)

# 在列中添加两个新的按钮
new_buttons = [[sg.Button(f'Button {i+2}')] for i in range(2)]
window.extend_layout(window['-COLUMN-'], new_buttons)

# 更新窗口内容
window['-COLUMN-'].contents_changed()

# 处理事件循环
while True:
    event, values = window.read()
    if event == sg.WINDOW_CLOSED:
        break

# 关闭窗口
window.close()
```

- 在这个示例代码中，我们首先创建了一个包含一个按钮的列，并将其添加到一个具有滚动条的容器中。
- 然后，我们使用 `extend_layout` 方法向该列中添加两个新按钮，并调用 `contents_changed` 方法来更新窗口内容。最后，我们进入 PySimpleGUI 的事件循环，等待用户关闭窗口。
- 当用户关闭窗口时，我们调用 `close` 方法来关闭窗口。需要注意的是，如果你向一个具有滚动条的容器中添加新行，则必须调用 `contents_changed` 方法来告诉 PySimpleGUI 更新滚动条的位置。



