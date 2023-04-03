[toc]

# 利用vscode 调试代码

## debug abstract

- [Debugging in Visual Studio Code](https://code.visualstudio.com/docs/editor/debugging)
- [Debugger extensions](https://code.visualstudio.com/docs/editor/debugging#_debugger-extensions)

- python语言为例
  - [Debugging configurations for Python apps in Visual Studio Code](https://code.visualstudio.com/docs/python/debugging)
    解决调式运行时文件同目录下的文件资源无法读取的问题

#  创建更改调试配置json文件:

## vscode+python:

- [cwd](https://code.visualstudio.com/docs/python/debugging#_cwd) 

  - Specifies the current working directory for the debugger, which is the base folder for any relative paths used in code. If omitted, defaults to `${workspaceFolder}` (the folder open in VS Code).

    As an example, say `${workspaceFolder}` contains a `py_code` folder containing `app.py`, and a `data` folder containing `salaries.csv`. If you start the debugger on `py_code/app.py`, then the relative paths to the data file vary depending on the value of `cwd`:

    | cwd                             | Relative path to data file |
    | :------------------------------ | :------------------------- |
    | Omitted or `${workspaceFolder}` | `data/salaries.csv`        |
    | `${workspaceFolder}/py_code`    | `../data/salaries.csv`     |
    | `${workspaceFolder}/data`       | `salaries.csv`             |

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210530183148546.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

## 调试的时候进入库@包的源码

- [justMyCode](https://code.visualstudio.com/docs/python/debugging#_justmycode)

  When omitted or set to `true` (the default), restricts debugging to user-written code only. Set to `false` to also enable debugging of standard library functions

- 配置样例:

  - 项目根目录下:`.vscode\launch.json`

    ```python
    {
        // Use IntelliSense to learn about possible attributes.
        // Hover to view descriptions of existing attributes.
        // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
        "version": "0.2.0",
        "configurations": [
            {
                "name": "Python: Go to library code|Current File",
                "type": "python",
                "request": "launch",
                "program": "${file}",
                "console": "integratedTerminal",
                // 设置在调试的时候进入当前文件外的模块/库的源码文件中
                "justMyCode": false
            },
            {
                "name": "Python: justMyCode|Current File",
                "type": "python",
                "request": "launch",
                "program": "${file}",
                "console": "integratedTerminal",
                // 在调试的时候不跳转到当前文件之外的模块/库的源码文件中
                "justMyCode": true
            }
        ]
    }
    ```

  - 可以用command palette 输入`view: show run and debug `

##  code runner插件下的切换

- `ctrl+shift+p:`
- 输入settings进入配置:
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210530184202621.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

- 将python的对应行修改为
  - `"python": " cd $dir \n python $fileName",`

- 即可在运行时自动将目录切换到当前打开的文件所在目录,并顺利调用同目录的资源.

##  result:

- 以PySide2库打开图片为例:
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210530184608851.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)