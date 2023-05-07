[toc]



## PySimpleGUI

### 底层GUI框架及其状态

- The Underlying GUI Frameworks & Status of Each

- 目前有四个积极开发和维护的 PySimpleGUI“端口”。它们包括：

  - tkinter - 完全完成
  - 使用 Pyside2 的 Qt - Alpha 阶段。并非所有元素的所有功能都已完成
  - WxPython - 开发阶段，预发布版。并非所有元素都已完成。多个窗口存在一些已知问题
  - Remi（Web 浏览器支持）- 开发阶段，预发布版。

  虽然 PySimpleGUI tkinter 端口是 PySimpleGUI 的唯一 100% 完成版本，但其他三个端口在其中具有许多功能，并且被大部分用户积极使用。您可以在文档的顶部看到 Pip 安装次数，以了解每个端口的安装基础的大小。徽章位于标志之后。

### 自行扩展框架@The Chain Link Fence

Maybe you've heard the "Walled Garden" term before. It's a boxing in effect.

While PySimpleGUI has a well-established parameter so you know where the edges are, there is no wall between you and the rest of the GUI framework. There's a chain link fence that's easy to reach through and get full access to the underlying frameworks.

The net result - it's easy to expand features that are not yet available in PySimpleGUI and easy to remove them too. Maybe the Listbox Element doesn't have a mode exposed that you want to enable. No problem, you can access the underlying Listbox Widget and make what is likely 1 or 2 calls and be done.

也许您之前听说过“围墙花园”的术语。这是一种封闭的效果。,“链式栅栏”是一个比喻，用来描述 PySimpleGUI 框架与其他 GUI 框架之间的关系。与“围墙花园”类似，它形成了一种封闭的效果。

虽然 PySimpleGUI 具有一个明确的参数，让您知道边缘在哪里，但在您和其他 GUI 框架之间没有围墙。有一个链式栅栏，很容易穿过它并完全访问底层框架。

最终结果是，很容易扩展 PySimpleGUI 中尚未提供的功能，也很容易删除它们。也许 Listbox 元素没有您想要启用的模式。没问题，您可以访问底层的 Listbox 小部件，并进行可能是一个或两个调用的操作，然后完成。

### The PySimpleGUI "Family"

What's The Big Deal? What is it?
PySimpleGUI wraps tkinter, Qt, WxPython, and Remi so that you get all the same widgets, but you interact with them in a more friendly way that's common across the ports.

What does a wrapper do (Yo! PSG in the house!)? It does the layout, boilerplate code, creates and manages the GUI Widgets for you and presents you with a simple, efficient interface. Most importantly, it maps the Widgets in tkinter/Qt/Wx/Remi into PySimpleGUI Elements. Finally, it replaces the GUIs' event loop with one of our own.

You've seen examples of the code already. The big deal of all this is that anyone can create a GUI simply and quickly that matches GUIs written in the native GUI framework. You can create complex layouts with complex element interactions. And, that code you wrote to run on tkinter will also run on Qt by changing your import statement.

If you want a deeper explanation about <u>architecture of PySimpleGUI</u>, you'll find it on ReadTheDocs in the same document as the Readme & Cookbook. There is a tab at the top with labels for each document.

PySimpleGUI“家族”是什么？
这是什么大不了的事情？它是什么？

PySimpleGUI 将 tkinter、Qt、WxPython 和 Remi 包装起来，使您可以获得所有相同的小部件，但您可以以跨端口共同的更友好的方式与它们交互。

包装器(PSG)的作用是什么？它进行布局、样板代码、为您创建和管理 GUI 小部件，并为您提供简单、高效的界面。

最重要的是，它将 tkinter/Qt/Wx/Remi 中的小部件映射到 PySimpleGUI 元素中。最后，它用我们自己的事件循环替换了 GUI 的事件循环。

您已经看到了代码的示例。所有这些的重要性在于，任何人都可以简单快速地创建与本机 GUI 框架中编写的 GUI 匹配的 GUI。您可以创建具有复杂元素交互的复杂布局。并且，您编写的针对 tkinter 运行的代码也可以通过更改导入语句在 Qt 上运行。

如果您想深入了解 PySimpleGUI 的架构，可以在与自述文件和食谱相同的文档中在 ReadTheDocs 上找到它。顶部有一个选项卡，标有每个文档的标签。

## The "Ports"

There are distinct ports happening as mentioned above. Each has its own location on GitHub under the main project. Heac has its own Readme which is an augmentation of this document... they are meant to be used together.

PySimpleGUI is released on PyPI as 5 distinct packages. 1. PySimpleGUI - tkinter version 2. PySimpleGUI27 - tkinter version that runs on 2.7 3. PySimpleGUIWx - WxPython version 4. PySimpleGUIQt - PySided2 version 5. PySimpleGUIWeb - The web (Remi) version

You will need to install them separately

There is also an accompanying debugger known as imwatchingyou. If you are running the tkinter version of PySimpleGUI, you will not need to install the debugger as there is a version embedded directly into PySimpleGUI.

如上所述，正在进行不同的端口。每个端口都在主项目下的 GitHub 上有自己的位置。每个端口都有自己的自述文件，这是本文档的扩展...它们是要一起使用的。

PySimpleGUI 以 5 个不同的包发布在 PyPI 上。

1.  PySimpleGUI - tkinter 版本 
2.  PySimpleGUI27 - 运行在2.7上的 tkinter 版本 
3.  PySimpleGUIWx - WxPython 版本 
4.  PySimpleGUIQt - PySided2 版本 
5.  PySimpleGUIWeb - Web (Remi) 版本

您需要单独安装它们。

还有一个附带的调试器，称为 imwatchingyou。如果您正在运行 PySimpleGUI 的 tkinter 版本，您将不需要安装调试器，因为有一个版本直接嵌入到 PySimpleGUI 中。

### Qt Version

Qt was the second port after tkinter. It is the 2nd most complete with the original PySimpleGUI (tkinter) being the most complete and is likely to continue to be the front-runner. All of the Elements are available on PySimpleGUIQt.

As mentioned previously each port has an area. For Qt, you can learn more on the PySimpleGUIQt GitHub site. There is a separate Readme file for the Qt version that you'll find there. This is true for all of the PySimpleGUI ports.

Give it a shot if you're looking for something a bit more "modern". PySimpleGUIQt is currently in Alpha. All of the widgets are operational but some may not yet be full-featured. If one is missing and your project needs it, log an Issue. It's how new features are born.

Here is a summary of the Qt Elements with no real effort spent on design clearly. It's an example of the "test harness" that is a part of each port. If you run the PySimpleGUI.py file itself then you'll see one of these tests.

As you can see, you've got a full array of GUI Elements to work with. All the standard ones are there in a single window. So don't be fooled into thinking PySimpleGUIQt is barely working or doesn't have many widgets to choose from. You even get TWO "Bonus Elements" - Dial and Stretch

Qt 是在 tkinter 之后的第二个端口。它是第二个最完整的版本，原始的 PySimpleGUI（tkinter）是最完整的，并且很可能会继续保持领先地位。所有元素都可以在 PySimpleGUIQt 上使用。

如前所述，每个端口都有一个区域。有关 Qt 的更多信息，请访问 PySimpleGUIQt GitHub 网站。您会在那里找到一个单独的 Qt 版本的自述文件。这对于所有 PySimpleGUI 端口都是正确的。

如果您正在寻找一些更“现代”的东西，请尝试一下。PySimpleGUIQt 目前处于 Alpha 阶段。所有小部件都可操作，但有些可能尚未具有完整的功能。如果缺少某个元素并且您的项目需要它，请记录问题。这是新功能产生的方式。

以下是没有花费太多设计精力的 Qt 元素摘要。这是每个端口的一部分的“测试工具”的示例。如果您运行 PySimpleGUI.py 文件本身，则会看到其中一个测试。

正如您所看到的，您拥有全套 GUI 元素可供使用。所有标准元素都在单个窗口中。

因此，不要被误导以为 PySimpleGUIQt 几乎不起作用，或者没有太多小部件可供选择。

您甚至可以获得两个“奖励元素”——刻度盘和拉伸。

### Android Version

- PySimpleGUI runs on Android devices with the help of either the PyDroid3 app or the Termux app.
-  Both are capable of running tkinter programs which means both are capable of running PySimpleGUI.

- PyDroid3 和 Termux 都是流行的移动应用程序，可以在 Android 设备上运行 Python 代码。但是，它们之间有一些关键的区别。

  PyDroid3 是一个带有完整功能的 Python 3 IDE。它包括代码编辑器、Python 解释器和包管理器，以及访问各种 Python 库的功能。PyDroid3 还支持许多流行的 Python 库，例如 NumPy、Pandas 和 Matplotlib，使其成为在移动设备上进行数据分析和科学计算的绝佳选择。

  另一方面，Termux 是一个终端仿真器和 Linux 环境，提供访问各种命令行工具和实用程序的功能。它允许在 Android 设备上运行各种 Linux 包和实用程序，包括 Python 解释器。Termux 高度可定制，可以用于创建具有像 Vim 或 Emacs 这样的工具的完整功能开发环境。

  总之，PyDroid3 是一个带有代码编辑器、解释器和包管理器的完整功能 Python 环境，而 Termux 是一个终端仿真器和 Linux 环境，提供访问各种命令行工具和实用程序的功能。这两个应用程序都可以用于在 Android 设备上运行 Python 代码，但根据您的需求，它们具有不同的目的和优点。

- 更多内容参考官网[[android version](https://www.pysimplegui.org/en/latest/#android-version)]

### repl.it

repl.it 是一个基于云的集成开发环境（IDE），允许您在各种编程语言中编写、运行和调试代码，包括 Python。它提供了一个用户友好的界面和各种功能，例如代码协作、版本控制和实时共享。

repl.it 的主要优点之一是它消除了在本地机器上安装任何软件的需要，因为所有开发都在云中完成。这使得它成为一个方便的选择，适用于那些刚开始学习编程或者没有强大计算机的人。

repl.it 还提供了各种模板和示例，可以快速开始您的 Python 项目。此外，它还支持流行的 Python 库和框架，例如 Flask、Django 和 NumPy。

总之，repl.it 是一个适用于所有级别的 Python 开发人员的优秀工具，无论您是初学者还是经验丰富的程序员。它提供了一种方便和可访问的方式，在云中编写、运行和共享代码，对于任何想要学习或实践 Python 的人来说都是一个宝贵的资源。

### repl.it Version

Want to really get your mind blown? Check out this PySimpleGUI program running in your web browser.

Thanks to the magic of repl.it and Remi it's possible to run PySimpleGUI code in a browser window without having Python running on your computer. This should be viewed as a teaching and demonstration aid. It is not meant to be a way of serving up web pages. It wouldn't work any way as each user forks and gets their own, completely different, workspace.

There are 2 ports of PySimpleGUI that run on repl.it - PySimpleGUI and PySimpleGUIWeb.

repl.it 版本
想要真正震惊自己的思维吗？在您的 Web 浏览器中运行此 PySimpleGUI 程序。

由于 repl.it 和 Remi 的神奇之处，可以在浏览器窗口中运行 PySimpleGUI 代码，而无需在计算机上运行 Python。这应该被视为教学和演示工具。它不是提供网页的方法。无论如何，每个用户都会派生并获得自己完全不同的工作空间。

在 repl.it 上有两个 PySimpleGUI 端口 - PySimpleGUI 和 PySimpleGUIWeb。

## 官方文档

以下是官方文档主页的主要大纲

- Python GUIs for Humans
- PySimpleGUI User's Manual
- Jump-Start
- 2021 Updates....
- About The PySimpleGUI Documentation System
- Platforms
- The PySimpleGUI "Family"
- Support
- Learning Resources
- The Quick Tour
- Some Examples
- Pi Windows
- Games
- Windows Programs That Look Like Windows Programs
- Background - Why PySimpleGUI Came to Be
- Features
- Getting Started with PySimpleGUI
- PEP8 Bindings For Methods and Functions
- High Level API Calls - Popup's
- Progress Meters!
- Debug Output (easy_print = Print = eprint)
- Custom window API Calls (Your First window)
- Copy these design patterns!
- Building Custom Windows
- Themes - Automatic Coloring of Your Windows
- Window Object - Beginning a window
- Layouts🎈
- Generated Layouts (For sure want to read if you have > 5 repeating elements/rows)
- Elements
- SystemTray
- Global Settings
- Persistent windows (Window stays open after button click)
- Updating Elements (changing element's values in an active window)
- Cursors - Setting for Elements and Windows
- Keyboard & Mouse Capture
- Menus
- TTK & TTK Scrollbars
- Running Multiple Windows
- The PySimpleGUI Debugger
- User Settings API
- Timer API
- Extending PySimpleGUI
- Troubleshooting
- Debug Output
- "Demo Programs" Applications
- Creating a Windows .EXE File
- Creating a Mac App File
- Known Issues
- Contributing to PySimpleGUI

### 基于消息传递而非事件驱动的GUI开发框架

- The Non-OO and Non-Event-Driven Model

The two "advanced concepts" that beginning Python students have with GUIs are the use of classes and callbacks with their associated communication and coordination mechanisms (semaphores, queues, etc)

How do you make a GUI interface easy enough for first WEEK Python students?

This meant classes could be used to build and use it, but classes can not be part of the code the user writes. Of course, an OO design is quite possible to use with PySimpleGUI, but it's not a ***requirement\***. The sample code and docs stay away from writing new classes in the user space for the most part.

What about those pesky callbacks? They're difficult for beginners to grasp and they're a bit of a pain in the ass to deal with. The way PySimpleGUI got around events was to utilize ***a "message passing" architecture\*** instead.

Instead of a user function being called when there's some event, instead the information is "passed" to the user when they call the function `Window.read()`

***Everything\*** is returned through this `Window.read` call. Of course the underlying GUI frameworks still perform callbacks, but they all happen inside of PySimpleGUI where they are turned into messages to pass to you.

All of the boilerplate code, the event handling, widget creation, frames containing widgets, etc, are **exactly the same** objects and calls that you would be writing if you wrote directly in tkinter, Qt, etc. With all of this code out of the way and done for you, that leaves you with the task of doing something useful with the information the user entered. THAT, after all, is the goal here.... getting user information and acting on it.

The full complement of Widgets are available to you via PySimpleGUI Elements. And those widgets are presented to you in a unique and fun way.

If you wish to learn more about the Architecture of PySimpleGUI, take a look at the [Architecture document located on ReadTheDocs](https://pysimplegui.readthedocs.io/en/latest/architecture/).

- PySimpleGUI中的非OO(面向对象)和Non-Event-Driven(非事件驱动)模型是为了让初学者更容易理解和使用GUI界面而设计的。
- 在传统的GUI编程中，使用类和回调函数是必须的，但对于初学者来说，这些概念往往比较难以理解和应用，因此PySimpleGUI提供了一种更简单的方式来创建GUI界面。

- PySimpleGUI采用了一种“消息传递”架构来避免使用回调函数。当用户调用Window.read()函数时，所有的信息都通过这个函数返回给用户，而不是通过回调函数来处理。
- PySimpleGUI中所有的部件和调用都与传统的GUI框架（如tkinter、Qt等）中的代码相同，但是PySimpleGUI将所有的繁琐的事件处理和部件创建都做好了，让用户只需要关注处理用户输入的信息。
- PySimpleGUI提供了完整的部件，可以通过PySimpleGUI Elements来使用。这些部件以独特有趣的方式展示给用户，更容易理解和使用。
- 如果您想了解更多关于PySimpleGUI的架构和设计，请查看ReadTheDocs上的架构文档。

### 框架发展状况

- PySimpleGUI是一个可定制性高、易于编程、稳定的GUI界面，受到了广泛的欢迎。在第一年中，其Pip安装量已经超过了35万次。项目每天有超过300人访问GitHub，并且已经获得了1800个星星。当前，PySimpleGUI已经有4个端口，并且正在不断扩展与其他技术的集成。现在是尝试PySimpleGUI的好时机，您只需要花费5到10分钟就可以了解它的基本功能。
- 需要注意的是，当使用尚未完成的端口时需要谨慎。目前，PySimpleGUI的tkinter版本是唯一完整的版本。Qt版本已经完成了所有的元素，但并未完成每个元素的所有选项。PySimpleGUIWeb是下一个完整性最高的版本，最后是PySimpleGUIWx。

### 功能特点@Features

- PySimpleGUI易于使用，但对于更高级的程序员来说，它具有显著的深度。其功能集远远超出了初学者程序员的要求，涵盖了复杂多窗口GUI所需的必要功能。

  PySimpleGUI的“简单”部分在于编写GUI的付出的努力，而不是您能够创建的程序的复杂性。它确实很“简单”……而且并不局限于简单问题。

  PySimpleGUI的特点包括：

  1. 支持多个GUI框架，包括tkinter、Qt、WxPython和Remi（用于基于Web的GUI）。
  2. 大量的小部件，包括按钮、输入框、复选框、单选按钮、滑块等等。
  3. 可定制的主题和样式，允许开发人员创建独特的品牌GUI。
  4. 支持单窗口和多窗口应用程序。
  5. 自动调整大小和布局管理，使GUI在不同的屏幕大小和分辨率上表现出色。
  6. 跨平台支持Windows、macOS和Linux。
  7. 与其他Python库和框架（如NumPy和TensorFlow）的集成。
  8. 使用Matplotlib内置支持绘图和绘制。
  9. 通过“消息传递”架构简化事件处理，消除了复杂的回调函数的需求。
  10. 与Python的并发和多进程模块轻松集成，以处理后台任务和长时间运行的过程。

- While simple to use, PySimpleGUI has significant depth to be explored by more advanced programmers. The feature set goes way beyond the requirements of a beginner programmer, and into the required features needed for complex multi-windowed GUIs.

  **The SIMPLE part of PySimpleGUI is how much effort \*you\* expend to write a GUI, not the complexity of the program you are able to create.** It's literally "simple" to do... and it is not limited to simple problems.

- <u>Features of PySimpleGUI include:</u>

  - Support for Python versions 2.7 and 3
  - Text
  - Single Line Input
  - Buttons including these types:
    - File Browse
    - Files Browse
    - Folder Browse
    - SaveAs
    - Normal button that returns event
    - Close window
    - Realtime
    - Calendar chooser
    - Color chooser
    - Button Menu
  - TTK Buttons or "normal" TK Buttons
  - Checkboxes
  - Radio Buttons
  - Listbox
  - Option Menu
  - Menubar
  - Button Menu
  - Slider
  - Spinner
  - Dial
  - Graph
  - Frame with title
  - Icons
  - Multi-line Text Input
  - Scroll-able Output
  - Images
  - Tables
  - Trees
  - Progress Bar Async/Non-Blocking Windows
  - Tabbed windows
  - Paned windows
  - Persistent Windows
  - Multiple Windows - Unlimited number of windows can be open at the same time
  - Redirect Python Output/Errors to scrolling window
  - 'Higher level' APIs (e.g. MessageBox, YesNobox, ...)
  - Single-Line-Of-Code Progress Bar & Debug Print
  - Complete control of colors, look and feel
  - Selection of pre-defined palettes
  - Button images
  - Horizontal and Vertical Separators
  - Return values as dictionary
  - Set focus
  - Bind return key to buttons
  - Group widgets into a column and place into window anywhere
  - Scrollable columns
  - Keyboard low-level key capture
  - Mouse scroll-wheel support
  - Get Listbox values as they are selected
  - Get slider, spinner, combo as they are changed
  - Update elements in a live window
  - Bulk window-fill operation
  - Save / Load window to/from disk
  - Borderless (no titlebar) windows (very classy looking)
  - Always on top windows
  - Menus with ALT-hotkey
  - Right click pop-up menu
  - Tooltips
  - Clickable text
  - Transparent windows
  - Movable windows
  - Animated GIFs
  - No async programming required (no callbacks to worry about)
  - Built-in debugger and REPL
  - User expandable by accessing underlying GUI Framework widgets directly
  - Exec APIs - wrapper for subprocessing and threading
  - UserSettings APIs - wrapper for JSON and INI files

### 按照🎈

- [Getting Started with PySimpleGUI](https://www.pysimplegui.org/en/latest/#getting-started-with-pysimplegui)

- 通常只要`pip install --upgrade PySimpleGUI `

### 从这里开始

- 从这里开始步入正轨:[START HERE - User Manual with Table of Contents (pysimplegui.org)](https://www.pysimplegui.org/en/latest/#start-here-user-manual-with-table-of-contents)
- 注意,文档中有些链接可能是无效的!
- 在线环境文档和可运行环境[Trinket](https://pysimplegui.trinket.io/demo-programs#/demo-programs/multi-threaded-work)
  - 这个运行出来的窗口基本上就是看看样子

### 浏览方式🎈🎈

- 官方文档说实话做的不是很好(模块化做的不好),站主把太多内容塞到同一个网页里面,

#### 借助浏览器插件生成更好的文档大纲(outling@heading)

- 傍边虽然有页面内容的大纲,但是看起来不方便,可以考虑使用浏览器扩展来增强阅读体验:
  - [HeadingsMap - Microsoft Edge Addons](https://microsoftedge.microsoft.com/addons/detail/headingsmap/bokekiiaddinealohkmhjcgfanndmcgo)
  - [Smart TOC - Microsoft Edge Addons👌❤️](https://microsoftedge.microsoft.com/addons/detail/smart-toc/iaolkehclkpehgahmbpcjoilglcfffab)
- 对比:
  - 在折叠/自动折叠大纲等方面第二款会更强大,,悬浮窗支持拖动,在阅读超长的文章时,可以用它来快速浏览大的标题
  - 但是第二款有些功能收费,可以考虑配合着使用

### 搜索🎈

- 尽管文档的模块化做的不好,但是可以考虑使用网站自身提供的搜索功能
  - 例如,我们通过某个demo发现了有关ButtonMenu的组件,现在想要知道这个组件的使用方法和说明,
  - 可以在网站内搜索:[ Search (pysimplegui.org)](https://www.pysimplegui.org/en/latest/#)
- [buttonmenu](https://www.pysimplegui.org/en/latest/#buttonmenu-element)

### PySimpleGUI学习路径🎈

- The Documentation
  - Resist the urge to "Google It"
  - The old-school way, "Read the Documenation", **for this project, will be the most efficient path.**
  - PySimpleGUI Documentation - [http://www.PySimpleGUI.org](http://www.pysimplegui.org/)
  - Here you will find the main doc, the Cookbook, the Call Reference, the Readme... all in 1 location.
- This readme document on GitHub and in the main documentation
  - PySimpleGUI GitHub: [http://www.PySimpleGUI.com](http://www.pysimplegui.com/)
- The Cookbook - Recipes to get you going and quick
  - [http://Cookbook.PySimpleGUI.org](http://cookbook.pysimplegui.org/)
  - The online Interactive eCookbook is also available - [http://eCookbook.PySimpleGUI.org](http://ecookbook.pysimplegui.org/)
- The Demo Programs - Start hacking on one of these running solutions
  - [http://Demos.PySimpleGUI.org](http://demos.pysimplegui.org/)
  - The easiest way to obtain and use them is by pip installing `psgdemos`
- The Udemy Course! "The Official PySimpleGUI Course"
  - The is ONE and only 1 video course on the Internet that helps the PySimpleGUI financially.
  - http://udemy.pysimplegui.org/
  - There are 61 lessons that will teach you all aspects of PySimpleGUI
  - It was a year in the making and covers features up through end of 2021
  - It's the best course I've ever written and recorded (says Mike). Each lesson is compact, consise, focused, easy to understand
- The YouTube videos - If you like instructional videos, there are 15+ videos.
  - **Caution** is advised... these videos are from 2020. **Much** has changed since they were made. They are still quite valid as what you're taught will work. But, you're missing 2 years of intense development that are not represented in these lessons. The Udemy course is a more complete and current course.
  - 2020 to 2022 update - https://youtu.be/lRuvKfilJnA-Lists a few of the many changes to PySimpleGUI since the 2020 lessons were recorded.
  - [5 part series of basics](https://www.youtube.com/playlist?list=PLl8dD0doyrvHMoJGTdMtgLuHymaqJVjzt)
  - [10 part series of more detail](https://www.youtube.com/playlist?list=PLl8dD0doyrvGyXjORNvirTIZxKopJr8s0)

Everything is geared towards giving you a "quick start" whether that be a Recipe or a Demo Program. The idea is to give you something running and let you hack away at it. As a developer this saves tremendous amounts of time.

You **start** with a working program, a GUI on the screen. Then have at it. If you break something (`"a happy little accident"` as Bob Ross put it), then you can always backtrack a little to a known working point.

A high percentage of users report both learning PySimpleGUI and completing their project in a single day.

This isn't a rare event and it's not bragging. GUI programming doesn't HAVE to be difficult by definition and PySimpleGUI has certainly made it much much more approachable and easier (not to mention simpler).

But there will be times that you need to read documentation, look at examples, when pushing into new, unknown territory. Don't guess... or more specifically, don't guess and then give up when it doesn't work.

所有的东西都旨在为您提供“快速启动”，无论是“Recipe”还是“Demo Program”。其想法是给您一个正在运行的东西，让您进行修改。作为开发人员，这可以节省大量时间。

您从一个工作程序开始，屏幕上有一个GUI。然后开始修改它。如果您弄坏了什么（正如Bob Ross所说的“一个开心的小意外”），那么您可以回溯到一个已知的工作点。

<u>高比例的用户报告称，他们在一天内学会了PySimpleGUI并完成了他们的项目。</u>

<u>这并不是一个罕见的事件，也不是在吹嘘。GUI编程本质上并不一定难以实现，而且PySimpleGUI确实使其更加易于接近和使用（更不用提更简单了）</u>。

但是，在进入新的、未知的领域时，有时您需要阅读文档、查看示例。不要猜测...或者更具体地说，当它不起作用时，不要猜测并放弃。

### 软件开发中的cookbook@recipe

- 在软件开发中，"cookbook" 和 "recipe" 通常指的是一组经过测试和验证的代码和指令，用于执行特定的任务或实现特定的功能。"cookbook" 和 "recipe" 的概念与烹饪有些类似，"cookbook" 就像一个菜谱，提供了一系列可靠的指导，帮助开发人员在开发过程中遵循最佳实践，而 "recipe" 则类似于一道菜的配方，提供了一组特定的指令和代码，用于实现特定的功能。
- 在一些编程社区和开源项目中，"cookbook" 和 "recipe" 通常用于描述一些常见的编程任务和问题的解决方案。例如，一个 "cookbook" 可能包含了一系列常用的代码段和示例，如字符串处理、文件操作、数据结构等。而一个 "recipe" 则可能是一个更具体的代码示例，用于解决一个特定的问题，如图像处理、机器学习等。
- "cookbook" 和 "recipe" 可以作为开发人员的参考资料，帮助他们快速解决问题和实现特定的功能。同时，这些代码示例也可以被其他开发人员复用和修改，以满足他们自己的需求。

- “recipe”可以翻译为“代码模板”、“指令集”或“代码示例集”，表示一组经过测试和验证的代码和指令，用于执行特定的任务或实现特定的功能。和烹饪食谱类似，软件开发中的“recipe”提供了一种可靠的方法，使开发人员可以快速创建和部署软件。
- 在一些编程社区和开源项目中，也存在名为“recipes”的代码仓库，其中包含了大量针对不同任务和场景的代码示例和模板。这些“recipes”通常由社区成员提交和维护，旨在帮助其他开发人员更快地实现特定的功能或解决特定的问题。

### 学习工具@Tools

These tools were created to help you achieve a steady stream of these little successes.

- This readme and its example pieces of code
- The Cookbook & eCoobook - Copy, paste, run, success
- Demo Programs - Copy these small programs to give yourself an instant head-start
- Documentation shown in your IDE (docstrings) means you do not need to open any document to get the full assortment of options available to you for each Element & function call

The initial "get up and running" portion of PySimpleGUI should take you less than 5 minutes (the 5 minute challenge). ***The goal is 5 minutes from your decision "I'll give it a try" to having your first window up on the screen\***. "Oh wow, it was that easy?!"

- 这些工具旨在帮助您实现这些小成功的稳定流。

  - 此自述文件及其示例代码.

  - 食谱和电子书 - 复制、粘贴、运行、成功

  - 演示程序- 复制这些小程序，立即获得启动优势

  - IDE 中显示的文档（docstrings），意味着您不需要打开任何文档，即可获取每个元素和函数调用的完整选项集。

- PySimpleGUI 的最初“起步”部分应该不到 5 分钟（5 分钟挑战）。目标是从您的决定“我试试”到在屏幕上有您的第一个窗口不到 5 分钟。“哦，哇，这么容易！”

## PySimpleGUI编程规范

- By following some simple coding conventions you'll be able to copy / paste demo program code into your code with minimal or no modifications. Your code will be understandable by other PySimpleGUI programmers as well.

- The primary *suggested* conventions are:

  - `import PySimpleGUI as sg`
  - Name your Window `window`
  - Name the return values from reading your window `event` and `values`
  - Name your layout `layout`
  - Use `window[key]` to lookup elements
  - For keys that are strings, follow this pattern `'-KEY-'`

  Of course you don't have to follow *any* of these. They're suggestions, but if you do follow them, your code is a lot easier to understand by someone else.

## 第一个程序🎈

- [The Quick Tour (pysimplegui.org)](https://www.pysimplegui.org/en/latest/#the-quick-tour)



## 布局设计

### 使用Qt Designer设计UI后转换

- There actually is a PySimpleGUI Window Designer that uses Qt's window designer. It's outside the scope of this document however. You'll find the project here: https://github.com/nngogol/PySimpleGUIDesigner

### layout(编写复杂布局的个人推荐规范)🎈

- 在布局(layout)设计这里,主要内容是布局`sg.Element(s)`(表示若干个基本sg组件序列(用逗号分割))
- 序列中的基本元素会被布局为该行内的元素
- 如果我们用一个中括号将元素序列打包,不妨称这类元素为行元素向量(检查行向量或向量)
- 为了在列方向上进行布局,我们需要构造基于行向量的序列
- 构造好序列后,再用一个方括号将他们整个的打包成一个高阶的列表(就是二级列表)
- 之所以这里不用矩阵类比,因为个行向量的元素可以是不等长的
- 建议遵守这样的规范来定义布局或者子布局.通常布局的类型为list[list[element]],也就是说,是一个关于sg组件元素的二轴数组布局,不妨称之为基础布局.
- 不同的子布局要构成一个更复杂的布局,主要有两种方式
  - 使用容器级的组件,他们可以接收一个基础布局作为参数,构造出`sg.Container`,使得一个基础布局表现得跟一个`sg.Element`一样
    - 容器级(`Container`)的组件比如`sg.Col,sg.Pane,...`
  - 然后可以根据需要进一步对`sg.Container`做更复杂的布局
- 此外,有些开发者习惯定义子布局,并赋值个一个变量,建议始终为子布局的变量名以`_layout`结尾(或`_sublayout`)
  - 这样,在整合总布局的时候容易根据变量名做出判断
- 而对于容器级的组件,例如`sg.Pane(sublayout,..)`,可以将其赋值给以`_Container`为后缀的变量名
- 这些规范有利于编写易于维护的pysimpleGUI程序

----



- 据我观察,通常布局的类型为list[list[element]],也就是说,是一个关于sg组件元素的二轴数组布局,不妨称之为基础布局.

-   并且,若我们将排放在同一行的元素,(称他们为一个元素序列),元素序列的包含sg.<element>个数可以是>=1的

-   从这个角度理解,那么布局可以理解为`元素序列`按照shape=(-1,1)的形状排放

-   尽管有这样的嵌套约束,但是PySimpleGui提供了一些用于嵌套的组件,例如sg.Column

-   我们可以基础布局作为Column组件的参数,然后我可以将Column作为组件放到一个新的基础组件中,这样就好像嵌套一个更深的层布局

-   在实践中,比较少用过度变量,但是用来作为划分(设计)用途还是不错的,甚至设计完毕后可以销毁这些临时子布局变量

- ```python
  asthetic_layout = [
      [sg.T("Anything that you would use for asthetics is in this tab!")],
      [sg.Image(data=sg.DEFAULT_BASE64_ICON, k="-IMAGE-")],
      [
          sg.ProgressBar(100, orientation="h", size=(20, 20), key="-PROGRESS BAR-"),
          sg.Button("Test Progress bar"),
      ],
  ]
  ```

### def

- 主要在定义右键菜单的选项时进行菜单内容设计
- 注意这里的列表内基本元素都是字符串

- ```python
  menu_def = [["&Application", ["E&xit"]], ["&Help", ["&About"]]]
  right_click_menu_def = [
      [],
      ["Edit Me", "Versions", "Nothing", "More Nothing", "Exit"],
  ]
  graph_right_click_menu_def = [
      [],
      ["Erase", "Draw Line", "Draw", ["Circle", "Rectangle", "Image"], "Exit"],
  ]
  ```

## PySimpleGUI的设计模式

- All of your PySimpleGUI programs will utilize one of these 2 design patterns depending on the type of window you're implementing.
- [Pattern 1 A - "One-shot Window" - Read a window one time then close it](https://www.pysimplegui.org/en/latest/#pattern-1-a-one-shot-window-read-a-window-one-time-then-close-it)
- [Pattern 1 B - "One-shot Window" - Read a window one time then close it (compact format)](https://www.pysimplegui.org/en/latest/#pattern-1-b-one-shot-window-read-a-window-one-time-then-close-it-compact-format)
- [Pattern 2 A - Persistent window (multiple reads using an event loop)](https://www.pysimplegui.org/en/latest/#pattern-2-a-persistent-window-multiple-reads-using-an-event-loop)
- [Pattern 2 B - Persistent window (multiple reads using an event loop + updates data in window)](https://www.pysimplegui.org/en/latest/#pattern-2-b-persistent-window-multiple-reads-using-an-event-loop-updates-data-in-window)

- "Copy-these-design-patterns" 可以翻译为“复制这些设计模式”。在软件开发中，设计模式是一些经过验证的、可重用的解决问题的方案，可以帮助开发人员更快地构建高质量的软件。"Copy-these-design-patterns" 的意思是鼓励开发人员复制这些经过验证的设计模式，以便在自己的项目中使用。这些设计模式可能包括特定的代码结构、算法、数据结构等，可以帮助开发人员解决常见的编程问题和挑战。使用这些设计模式可以提高代码的可读性、可维护性和可扩展性，同时也可以减少错误和重复代码的数量。
- [Copy these design patterns! (pysimplegui.org)](https://www.pysimplegui.org/en/latest/#copy-these-design-patterns)

## 重要变量@事件和值🎈

- [Return values (pysimplegui.org)](https://www.pysimplegui.org/en/latest/#return-values)

- ```python
  event,values=sg.Window(layout,...).read()
  ```

  - Window对象的read()方法在接收被启用(可识别)的事件后,回返回两个值
    - 一个是event,另一个是事件对应传递的值values,values是一个字典,包含了因事件产生的所有值

### 对None值的检查

- [Recipe - Pattern 2A - Persistent window (multiple reads using an event loop) (pysimplegui.org)](https://www.pysimplegui.org/en/latest/cookbook/#recipe-pattern-2a-persistent-window-multiple-reads-using-an-event-loop)
  - 这个例子初步展示了window.read()方法在哪些情况返回None

- 前面提到,如果没有显式地为一个组件设置`key`参数,那么第一个缺失显示key的组件会被编号为0(例如一个在创建的时候没有传入key参数的sg.Button())

- 如果您使用:

  - ```python
    if event:
        xxx
    ```

    - 这类判断方法可能会出现意外的情况
    - 所以更建议使用`if event is None:`来判断

### event🎈

- [Events (pysimplegui.org)](https://www.pysimplegui.org/en/latest/#events)

  - The first parameter `event` describes **why** the read completed. Events are one of these:

    For all Windows:

    - Button click
    - Window closed using X

  - For Windows that have specifically enabled these. Please see the appropriate section in this document to learn about how to enable these and what the event return values are.

    - Keyboard key press
    - Mouse wheel up/down
    - Menu item selected
    - An Element Changed (slider, spinner, etc.)
    - A list item was clicked
    - Return key was pressed in input element
    - Timeout waiting for event
    - Text was clicked
    - Combobox item chosen
    - Table row selected
    - etc.

    ***Most\*** of the time the event will be a button click or the window was closed. The other Element-specific kinds of events happen when you set `enable_events=True` when you create the Element.

  - 第一个参数 event 描述了读取完成的原因。事件类型如下：

    对于所有的 Windows：

    - 按钮单击
    - 使用 X 关闭窗口

  - 对于特别启用了以下事件的 Windows,请参阅本文档中的相应部分，了解如何启用这些事件以及事件返回值是什么。

    - 键盘按键
    - 鼠标滚轮向上/向下
    - 选择菜单项
    - 元素更改（滑块、微调框等）
    - 单击了列表项
    - 在输入元素中按下回车键
    - 等待事件超时
    - 单击了文本
    - 选择了组合框项(Combobox/Drop/..)
    - 选择了表格行
    - 等等。

  - 大多数情况下，事件将是一个按钮单击或窗口已关闭。当您创建元素时设置 enable_events=True 时，其他特定元素类型的事件发生。

- The `event` is what caused the read to return. It could be a button press, some text clicked, a list item chosen, etc, or `WIN_CLOSED` if the user closes the window using the X.

- The `values` is a dictionary of values of all the input-style elements. Dictionaries use keys to define entries. If your elements do not specificy a key, one is provided for you. These auto-numbered keys are ints starting at zero.

- This design pattern does not specify a `key` for the `InputText` element, so its key will be auto-numbered and is zero in this case. Thus the design pattern can get the value of whatever was input by referencing `values[0]`

- 在PySimpleGUI中，`event`和`values`是处理GUI事件和用户输入的两个重要变量。具体来说：

  - `event`变量表示导致GUI窗口读取返回的事件，可以是按钮按下、文本点击、列表项选择等事件，或者是`WIN_CLOSED`事件，表示用户使用X关闭了窗口。在处理GUI事件时，通常需要根据`event`变量的值来执行相应的操作，比如更新界面、执行计算或者退出程序等。

  - `values`变量是一个字典，包含了所有输入式元素的值。字典使用键来定义条目。如果你的元素没有指定键，则会为你提供一个。这些自动编号的键是从零开始的整数。

    在某些设计模式中，可能没有为`InputText`元素指定一个`key`，所以它的键会自动编号，并且在这种情况下是零。因此，设计模式可以通过引用`values[0]`来获取输入的值。

- 一般来说,如果某个sg组件被创建时传入了key参数(设为`keyName`),如果允许该组件触发事件(传入`enable_event=True`)那么,由操作了该组件而发出的event名字就是`keyName`

  

#### 编写小demo来查看组件被操作后返回的event

- ```python
  import PySimpleGUI as sg
  
  ##
  # 定义GUI布局
  layout = [
      [sg.Combo(values=["a", "b"], default_value="a", enable_events=True, key="-COMBO-")],
  ]
  
  # 创建窗口并运行事件循环
  window = sg.Window("My Window", layout)
  while True:
      event, values = window.read()
  
      if event == sg.WINDOW_CLOSED:
          break
  
      if event is not None:
          print(event, values)
          print()
  window.close()
  
  ```

  - 注意这里使用了`enable_events`参数,使得我们对他进行操作可以捕获相关的wond.read()返回的event,values

  - ```bash
    (d:\condaPythonEnvs\tf2.10) PS D:\repos\CCSER\SER\SG\demo_programs>  py demo2.py
    -COMBO- {'-COMBO-': 'b'}
    
    -COMBO- {'-COMBO-': 'a'}
    
    ```

  - 可以看到,我们点击上述例程创建出来的窗口中的下拉框中的某个选项的时候,终端会输出相关的内容:

    - event=`-COMBO-`,这正是我们对Combo组件设定的key值
    - 而values字典从`{'-COMBO-': 'b'}`变化到`{'-COMBO-': 'a'}`,可以看出我的点击操作是先点击了下拉框的条目b,然后点击了条目a
    - 这样的操作使得名为(`-COMBO-`)组件对应的值从"b"变为"a"

### values

- 有时,window.read()返回的`event,values`中的`values`字典只包含一个key-value,例如:

  - ```python
    import PySimpleGUI as sg
    
    ##
    # 定义GUI布局
    text="demo_Checkbox",
    layout = [
        [sg.Checkbox(text, default=True, enable_events=True, key="CB")],
        [sg.Text("AText",key="AText",enable_events=True)],
        [sg.Button("OK",key="BtnOK")]
    ]
    
    # 创建窗口并运行事件循环
    window = sg.Window("My Window", layout)
    while True:
        event, values = window.read()
    
        if event == sg.WINDOW_CLOSED:
            break
    
        if event is not None:
            print(event, values)
            print()
    
    window.close()
    
    ```

    - ```
      (d:\condaPythonEnvs\tf2.10) PS D:\repos\CCSER\SER\SG\demo_programs>  py demo2.py
      AText {'CB': True}
      
      CB {'CB': False}
      
      CB {'CB': True}
      
      BtnOK {'CB': True}
      ```

    - 分别点击一次文本组件,2次Checkbox组件,1次按钮,终端上输出的内容如上

    - 可以看到输出values总是`{'CB':False}`,说明只有`CB`这个key对应的组件会保存某个值(最简单的值时bool值)

    - 而文本组件和按钮组件的操作分别引起了事件循环的响应`AText,BtnOk`

    - 但是他们没有存储值得特性

- ```python
  import PySimpleGUI as sg
  
  ##
  # 定义GUI布局
  text="demo_Checkbox",
  layout = [
      [sg.Checkbox(text, default=True, enable_events=True, key="CB")],
      [sg.Text("AText",key="AText",enable_events=True)],
      [sg.Listbox(["l1","l2","l3","l4"],default_values="l1",size=(10,5),enable_events=True,key="LB")],
      [sg.Button("OK",key="BtnOK")]
  ]
  
  # 创建窗口并运行事件循环
  window = sg.Window("My Window", layout,resizable=True,)
  while True:
      event, values = window.read()
  
      if event == sg.WINDOW_CLOSED:
          break
  
      if event is not None:
          print(event, values)
          print()
  
  window.close()
  
  ```

  - ```bash
    (d:\condaPythonEnvs\tf2.10) PS D:\repos\CCSER\SER\SG\demo_programs>  py demo2.py                    
    LB {'CB': True, 'LB': ['l2']}
    
    LB {'CB': True, 'LB': ['l3']}
    
    CB {'CB': False, 'LB': ['l3']}
    
    BtnOK {'CB': False, 'LB': ['l3']}
    ```

    - 前2行都是LB的事件,可以看出,我的操作中,先依次点击listBox中的选项
      - 此外,因为values中的LB字段的值分别为:`L2,L3`,可以指第一次点击L2,第2次点击L3
      - 至于字典中的CB的值在此时还保持为True,说明对应的组件是默认值被设置为True
    - 第3行是CB的事件,并且注意到CB的值发生翻转,那么就是我点击了CB组件
    - 最后是`BtnOK`事件,此时的values字典值没有发生变化

## 事件循环@回调

- [The Event Loop / Callback Functions (pysimplegui.org)](https://www.pysimplegui.org/en/latest/#the-event-loop-callback-functions)

