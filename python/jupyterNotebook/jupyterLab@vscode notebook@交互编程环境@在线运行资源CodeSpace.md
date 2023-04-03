[toc]

# jupyterLab@vscode notebook@交互编程环境@在线运行资源CodeSpace

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

### 在线vscode

- [Visual Studio Code for the Web](https://code.visualstudio.com/docs/editor/vscode-web#_opening-a-project)
- [Opening a project](https://code.visualstudio.com/docs/editor/vscode-web#_opening-a-project)
  - 从github 仓库链接打开
  - 可以用来临时浏览仓库

- [Connecting to a remote Jupyter server from vscode.dev · microsoft/vscode-jupyter Wiki (github.com)](https://github.com/microsoft/vscode-jupyter/wiki/Connecting-to-a-remote-Jupyter-server-from-vscode.dev)

### 在线vscode.dev+notebook

- [Jupyter Notebooks on the web (visualstudio.com)](https://code.visualstudio.com/docs/datascience/notebooks-web)

- 如果使用浏览器,用`https://vscode.dev/github/..`的方式,例如`https://vscode.dev/github/JabuMlDev/Speaker-VGG-CCT`,想要运行notebook,需要一个notebook服务器链接(server url)
- 以本地连接为例,可以参考:[starting your own server](https://github.com/microsoft/vscode-jupyter/wiki/Connecting-to-a-remote-Jupyter-server-from-vscode.dev#starting-your-own-server)
  - 主要是本地(localhost)执行`jupyter notebook`后得到的`url`是对于vscode web是不可用的
  - 您可以追加执行`jupyter notebook --no-browser --NotebookApp.allow_origin='*'`
    - 然后用得到的新url再尝试

### 在线运行计算资源@github Codespaces

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

  

## vscode notebook 快捷键

- notebook本身有一套快捷键逻辑,而且分为2中模式

  - command mode
  - common mode

- 直接配置:打开command palette,输入` open keyboard shortcuts`,搜索关键字

- 本人更新换直接全局的快捷键,下面描述以下本人自用的快捷键

  - [keybindings.json modify](https://code.visualstudio.com/docs/getstarted/keybindings#_advanced-customization)

  - 配置文件`keybindings.json`,可以使用`ctrl+p`输入打开

    - 以windows为例,默认位置为`$env:APPDATA\code\user`

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

      

