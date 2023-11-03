[toc]

# jupyterLab@在线vscode@vscode notebook@快捷键配置@交互编程环境@在线运行资源CodeSpace

## jupyterLab

- [JupyterLab Documentation — JupyterLab 3.6.2 documentation](https://jupyterlab.readthedocs.io/en/stable/)



## REPLs

- REPLs是指“Read-Eval-Print Loops”的缩写，是一种交互式编程环境，允许用户输入代码片段并立即看到结果。当用户输入代码时，REPL会读取代码、执行代码并打印输出结果。这种环境通常用于快速原型开发、教学和调试等场景。常见的REPLs包括Python的IDLE、Ruby的irb、Node.js的REPL等。

### python IDLE缩写

- Python IDLE的缩写为“Integrated Development and Learning Environment”，即“集成开发和学习环境”。

## VS Code Notebook vs JupyterLab

VS Code Notebook 和 JupyterLab 都是用于数据科学和机器学习的工具，它们都提供了交互式计算环境和数据可视化功能。

然而，它们有一些不同之处：

1. **界面和外观**：VS Code Notebook 具有更现代化、干净的界面，使其更易于使用。JupyterLab 则更加灵活，可以通过插件扩展其功能和界面。
2. **文本编辑器**：VS Code Notebook 使用 VS Code 的文本编辑器，具有更丰富的代码编辑和调试功能。JupyterLab 使用 CodeMirror 编辑器，也具有一些基本的编辑和调试功能。
3. **扩展性和生态系统**：由于 VS Code Notebook 基于 VS Code 编辑器，因此可以使用 VS Code 的插件和扩展进行扩展。JupyterLab 也有一些插件，但其生态系统没有 VS Code 那么丰富。
4. **云支持**：JupyterLab 更加适合在云环境下使用，例如 JupyterHub 和 Google Colab或AWS的SageMaker Studio Lab。
   - VS Code 比较重,目前来说,在线环境更倾向于jupyterLab
   - 但是Vscode可以安装在本地或远程服务器上。

- 总体而言，VS Code Notebook 更适合那些喜欢 VS Code 的用户，需要更好的代码编辑和调试功能；而 JupyterLab 更适合那些需要更强大的扩展性和云支持的用户。
- 本人目前主要用Vscode notebook

## 在线vscode

- [Visual Studio Code for the Web](https://code.visualstudio.com/docs/editor/vscode-web#_opening-a-project)
  - [Opening a project](https://code.visualstudio.com/docs/editor/vscode-web#_opening-a-project)

- [Connecting to a remote Jupyter server from vscode.dev · microsoft/vscode-jupyter Wiki (github.com)](https://github.com/microsoft/vscode-jupyter/wiki/Connecting-to-a-remote-Jupyter-server-from-vscode.dev)



###  github.dev例子

- 原仓库链接:
  - https://github.com/hansonwang99/JavaCollection
- 替换后的链接:
  - [https://github.dev/hansonwang99/JavaCollection](https://github.dev/hansonwang99/JavaCollection)

### vscode.dev例子

- 原仓库链接:
  - https://github.com/hansonwang99/JavaCollection
- 替换后的链接:
  - [https://vscode.dev/github.com/hansonwang99/JavaCollection](https://github.dev/hansonwang99/JavaCollection)

###  用途

- 搜索github仓库文件/代码

- 可以在线浏览github仓库中的代码以及其他文件
- 方便搜索代码
- 方便打开文件
- 方便在线预览审阅代码

## 在线vscode.dev+notebook

- [Jupyter Notebooks on the web (visualstudio.com)](https://code.visualstudio.com/docs/datascience/notebooks-web)

- 如果使用浏览器,用`https://vscode.dev/github/..`的方式,例如`https://vscode.dev/github/JabuMlDev/Speaker-VGG-CCT`,想要运行notebook,需要一个notebook服务器链接(server url)
- 以本地连接为例,可以参考:[starting your own server](https://github.com/microsoft/vscode-jupyter/wiki/Connecting-to-a-remote-Jupyter-server-from-vscode.dev#starting-your-own-server)
  - 主要是本地(localhost)执行`jupyter notebook`后得到的`url`是对于vscode web是不可用的
  - 您可以追加执行`jupyter notebook --no-browser --NotebookApp.allow_origin='*'`
    - 然后用得到的新url再尝试

### 小结@github.dev vs vscode.dev

- "github.dev/" and "vscode.dev/github" are both web-based editors that allow you to edit and commit code directly on GitHub.

  "github.dev" is a new feature that was introduced by GitHub in 2021. It is a web-based editor that allows you to edit files directly in your web browser, without having to leave the GitHub website. When you open a repository in "github.dev", it opens a web-based IDE (Integrated Development Environment) where you can edit, commit, and push changes to the repository.

  "vscode.dev/github" is a similar web-based editor, but it is provided by Microsoft's Visual Studio Code, which is a popular code editor used by many developers. When you open a GitHub repository in "vscode.dev/github", it opens a web-based version of Visual Studio Code where you can edit and commit changes to the repository. It also provides many of the same features as the desktop version of Visual Studio Code, such as syntax highlighting, code completion, and debugging.

  Both "github.dev" and "vscode.dev/github" offer a convenient way to edit code directly on GitHub without having to download and install a desktop editor. They are both free to use and can be accessed from any web browser. However, they have slightly different user interfaces and features, so you may prefer one over the other depending on your preferences and workflow.

- "github.dev" 和 "vscode.dev/github" 都是让你直接在 GitHub 上编辑和提交代码的基于 Web 的编辑器。

  两者都提供了方便的方式，在不需要下载和安装桌面编辑器的情况下，直接在线编辑代码。它们都是免费的，并且可以在任何网络浏览器中使用。然而，它们有不同的用户界面和功能，因此根据你的偏好和工作流程，你可能会更喜欢其中一个。

  从功能上来看，"vscode.dev/github" 更强大一些，因为它是由 Microsoft 的 Visual Studio Code 提供的。它提供了许多与桌面版 Visual Studio Code 相同的功能，包括语法高亮、代码完成和调试等。它还提供了大量的插件和扩展，使得它可以满足许多不同的工作流程和需求。

- 另一方面，"github.dev" 更加简洁和直接。它是一个轻量级编辑器，没有太多复杂的功能，但它可以满足基本的编辑和提交代码的需求。

- 总的来说，"vscode.dev/github" 更强大，提供了更多的功能和扩展，但它也更加复杂和笨重。如果你只需要基本的编辑和提交代码功能，那么 "github.dev" 可能更适合你，而如果你需要更丰富的功能和扩展，那么 "vscode.dev/github" 可能更适合你。

## 在线运行计算资源@github Codespaces

- [About billing for GitHub Codespaces - GitHub Docs](https://docs.github.com/en/billing/managing-billing-for-github-codespaces/about-billing-for-github-codespaces)
- 免费版每个月可以运行100多个小时(平均每天4小时)
- 相当于一台资源首先的临时云主机,可以既可以用浏览器打开也可以用本地的vscode打开

### notebook 的url

- [How to get the current jupyter notebook servers in python? - Stack Overflow](https://stackoverflow.com/questions/41782255/how-to-get-the-current-jupyter-notebook-servers-in-python)

- 在命令行中执行` jupyter notebook`启动服务后,命令行会返回给你一个url

  - 如果您想在notebook 中用python查看这个连接:

    - ```python
      from notebook import notebookapp
      servers = list(notebookapp.list_running_servers())
      print(servers)
      ```

    - ```bash
      [{'base_url': '/', 'hostname': 'localhost', 'notebook_dir': 'D:\\repos\\CCSER\\emotion-recognition-using-speech', 'password': False, 'pid': 9684, 'port': 8888, 'secure': False, 'sock': '', 'token': 'ac4e4b1ed699db8088af6cce640998ec3882b06454976dfb', 'url': 'http://localhost:8888/'}]
      ```

    - 这有局限性,vscode启动的notebook只会返回空列表

  - 使用命令行`jupyter notebook list`效果类似

- 但是用vscode连接到`jupyter notebook`不容易查到运行的notebook实例的url

  

## vscode在编辑器模式下分割@运行代码@PIW模式

- [Working with Jupyter code cells in the Python Interactive window (visualstudio.com)](https://code.visualstudio.com/docs/python/jupyter-support-py)
  - VSCode 的 Python Interactive window 模式是一种交互式 Python 环境，可以让你在 VSCode 中运行 Python 代码，并且可以在一个窗口中查看输出结果和错误信息。 要打开 Python Interactive window，可以按下 Ctrl + Shift + P（Windows 或 Linux）或 Command + Shift + P（Mac），然后输入“Python: Show Python Interactive window”命令并选择它。 在 Python Interactive window 中，你可以输入 Python 代码并按下 Shift + Enter 运行它。你可以使用 Tab 键自动补全代码，使用上下箭头键查看历史命令，以及使用 Ctrl + C 停止正在运行的代码。 在 Python Interactive window 中，你还可以使用 # %% 标记来分割代码块。这个标记表示代码块的开始，可以让你在一个窗口中分别运行不同的代码块。你可以使用 Ctrl + Enter 运行当前代码块，或使用 Shift + Enter 运行当前代码块并跳到下一个代码块。 Python Interactive window 还提供了一些其他功能，如变量检查、代码执行时间、会话保存和恢复等。你可以通过 VSCode 的设置面板来配置这些功能。
  - [Jupyter](https://jupyter-notebook.readthedocs.io/en/latest/) (formerly IPython Notebook) is an open-source project that lets you easily combine Markdown text and executable Python source code on one canvas called a **notebook**. Visual Studio Code supports working with [Jupyter Notebooks natively](https://code.visualstudio.com/docs/datascience/jupyter-notebooks), as well as through Python code files. This topic covers the support offered through Python code files and demonstrates how to:
    - Work with Jupyter-like code cells
    - Run code in the Python Interactive Window
    - View, inspect, and filter variables using the Variables Explorer and Data Viewer
    - Connect to a remote Jupyter server
    - Debug a Jupyter notebook
    - Export a Jupyter notebook
- 这是一个很有用的特性,使得编辑`.py`文件的时候就可以使用jupyter notebook的部分功能
  - 运行py中的一个cell,会启动notebook服务,可以理解为从`.py`创建一个临时的`.ipynb`但是目前只有vscode支持
  - 不妨称该模式为`PIW`
  - 而传统的通用JupyterNotebookNatively称为`JNN`
- 下面介绍快捷键的配置,注意和`.py`下和`.ipynb`(PIW,JNN)下快捷键不通用

## vscode notebook 快捷键🎈

- notebook本身有一套快捷键逻辑,而且分为2中模式

  - command mode
  - common mode

- 直接配置:打开command palette,输入` open keyboard shortcuts`,搜索关键字

- 本人更新换直接全局的快捷键,下面描述以下本人自用的快捷键

  - [keybindings.json modify](https://code.visualstudio.com/docs/getstarted/keybindings#_advanced-customization)

  - 配置文件`keybindings.json`,可以使用`ctrl+p`输入打开

    - 以windows为例,默认位置为`$env:APPDATA\code\user`


#### JNN下的快捷键配置

- 快捷键命令格式:`notebook.cell.<command>`

  - ```json
    {
        "key": "ctrl+m ctrl+m",
        "command": "notebook.cell.changeToMarkdown",
        "when": "notebookEditorFocused  && activeEditor == 'workbench.editor.notebook' && notebookCellType == 'code'"
    },
    {
        "key": "ctrl+m ctrl+c",
        "command": "notebook.cell.changeToCode",
        "when": "notebookEditorFocused  && !notebookOutputFocused && activeEditor == 'workbench.editor.notebook' && notebookCellType == 'markup'"
    },
    {
    "key": "shift+alt+b",
    "command": "notebook.cell.insertCodeCellBelow"
    },
    {
    "key": "shift+alt+a",
    "command": "notebook.cell.insertCodeCellAbove"
    },
    ```

    - 其中,第一个快捷键定义了`ctrl+m ctrl+m`将一个code cell转换为markdown cell
    - 第二个快捷键定义了`ctrl+m ctrl+c`将一个cell转换为code cell
    - 一般默认cell是code cell
    - 后面两个cell是模仿`jetbrains intelligent IDEA`的notebook向上/向下插入一个代码cell
    - 上述代码添加到`keybingdings.json`不会使默认的快捷键失效,但是这不是说不和其他快捷键冲突
    - 根据需要还可以调整when字段

  - cell分割和合并

    - ```json
      {
          "key": "ctrl+shift+-",
          "command": "notebook.cell.split",
          "when": "editorTextFocus && inputFocus && notebookEditorFocused && !notebookOutputFocused"
      },
      ```

  - 删除单元格

    - ```json
        {
          "key": "ctrl+shift+backspace",
          "command": "notebook.cell.delete",
          "when": "notebookEditorFocused  && !notebookOutputFocused"
        },
      ```

  - 清除单元格输出(以下二选一即可,也可以都保留)

    - ```json
      {
         "key": "alt+backspace",
         "command": "notebook.cell.clearOutputs",
         "when": "notebookEditorFocused  && !notebookOutputFocused"
       },
       {
         "key": "alt+delete",
         "command": "notebook.cell.clearOutputs",
         "when": "notebookEditorFocused  && !notebookOutputFocused"
       },
      ```

  - 运行当前cell

    - ```json
        {
          "key": "ctrl+k ctrl+c",
          "command": "notebook.cell.execute",
          "when": "notebookCellListFocused && notebookMissingKernelExtension && !notebookCellExecuting && notebookCellType == 'code' || notebookCellListFocused && !notebookCellExecuting && notebookCellType == 'code' && notebookKernelCount > 0 || notebookCellListFocused && !notebookCellExecuting && notebookCellType == 'code' && notebookKernelSourceCount > 0"
        },
      ```

### PIW下的快捷键配置

- 快捷键命令格式:`jupyter.<command>`

### 小结

- 注意选择对应的模式配置才可以按预期工作
- 此外,如果同一个快捷键绑定了多条命令,要注意作用域`when`的配置:[when clause contexts | Visual Studio Code Extension API](https://code.visualstudio.com/api/references/when-clause-contexts)

