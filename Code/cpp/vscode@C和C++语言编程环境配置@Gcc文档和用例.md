[toc]



## abstract

- 这里假设用户已经正确安装好了编译器,并且能够顺利启动
  - 可以是任何一款编译器,比如应用最广泛的GCC或其在不同系统上的移植版

- vscode+cpp官方文档教程:
  - [C++ programming with Visual Studio Code](https://code.visualstudio.com/docs/languages/cpp)
    - 这个页面是vscode配置c++环境的首页,指导如何准备编译器以及编译第一个程序
    - 然后给出许多不同编译器下的跟进一步的和更完整的首次配置教程
    - 包括`.vscode`中的相关文件介绍
      - 对于轻量环境,选择GCC编译器是好主意,可以参考以下文档
      - [Get Started with C++ and MinGW-w64 in Visual Studio Code](https://code.visualstudio.com/docs/cpp/config-mingw#_debug-helloworldcpp)
- 图方便开箱即用的话可以用Dev C++:[Dev-C++ Overview - Free Tools - Embarcadero](https://www.embarcadero.com/cn/free-tools/dev-cpp)

## gcc/g++文档和用法

- [GCC online documentation - GNU Project](https://gcc.gnu.org/onlinedocs/)
  - 您可以在线查看或者下载gcc不同版本的详细文档,包括pdf等格式
  - 所有蓝色的链接都是可以跳转的在线网页,或者是可以下载的资源
  - 文档不仅包含gcc也包含g++

- 也可以只查阅最常用的一部分文档,可以用man命令查看,但是使用浏览器会更便于阅读

- [man gcc (1): GNU project C and C++ compiler (manpages.org)](https://manpages.org/gcc)

- [g++(1) - Linux manual page (man7.org)](https://www.man7.org/linux/man-pages/man1/g++.1.html)





### 常见用例

以下是一些常见的GCC/G++编译用法示例：

1. **基本编译与链接**：
   ```bash
   g++ source.cpp -o output
   ```
   这条命令将源文件`source.cpp`编译并链接为可执行文件`output`。默认情况下，G++会自动处理依赖关系，编译所有必要的C++源文件，并链接所需的库。

2. **编译多个源文件**：
   ```bash
   g++ main.cpp func1.cpp func2.cpp -o program
   ```
   当项目包含多个源文件时，可以同时指定它们进行编译和链接。

3. **指定编译标准**：
   ```bash
   g++ -std=c++11 source.cpp -o output
   ```
   使用`-std`选项指定编译器遵循的C++标准版本，如C++11、C++14、C++17、C++20等。

4. **启用警告**：
   ```bash
   g++ -Wall -Wextra source.cpp -o output
   ```
   `-Wall`开启所有基本警告，`-Wextra`启用额外警告。这对于发现潜在编程错误非常有帮助。

5. **优化编译**：
   ```bash
   g++ -O2 source.cpp -o output
   ```
   使用`-O`选项进行优化编译，`-O2`是常用的优化级别。还有更激进的`-O3`和禁用优化的`-O0`。

6. **包含目录**：
   ```bash
   g++ -I/usr/local/include source.cpp -o output
   ```
   使用`-I`选项指定头文件的搜索路径。如果源码中包含了`#include <header.h>`，而`header.h`位于`/usr/local/include`目录下，需要使用此选项。

7. **链接库**：
   ```bash
   g++ source.cpp -L/usr/lib -lmylib -o output
   ```
   `-L`选项指定库文件的搜索路径，`-l`选项指定要链接的库。例如，这里链接名为`mylib`的库。实际链接的是`libmylib.so`或`libmylib.a`文件。

8. **生成调试信息**：
   ```bash
   g++ -g source.cpp -o output
   ```
   使用`-g`选项在生成的可执行文件中包含调试信息，便于使用GDB等调试工具进行调试。

9. **预处理**：
   ```bash
   gcc -E source.c -o preprocessed_source.i
   ```
   使用`-E`选项仅进行预处理，生成预处理后的输出文件`preprocessed_source.i`。

10. **生成汇编代码**：
    ```bash
    g++ -S source.cpp -o assembly.s
    ```
    使用`-S`选项仅进行编译，生成汇编代码文件`assembly.s`，不进行汇编和链接。

以上就是一些GCC/G++编译的常见用法示例。根据实际需求，可能需要组合使用这些选项。

## 目录.vscode中的相关文件说明

- As you go through the tutorial, you will see three files created in a `.vscode` folder in the workspace:
  - `tasks.json` (build instructions)
  - `launch.json` (debugger settings)
  - `c_cpp_properties.json` (compiler path and IntelliSense settings)

### tasks.json

- [tasks.json](https://code.visualstudio.com/docs/cpp/config-mingw#_understanding-tasksjson)
  - 文档还介绍了如何去build多个cpp文件而不仅仅是一个cpp文件,比如build某个cpp所在目录内的所有cpp文件
  - 其中的args字段的配置是比较常用的

### launch.json

- [Customize debugging with launch.json](https://code.visualstudio.com/docs/cpp/config-mingw#_customize-debugging-with-launchjson)

### c_cpp_properties.json

- [c_cpp_properties.json](https://code.visualstudio.com/docs/cpp/config-mingw#_adding-additional-cc-settings)



## IDE或编辑器配置

### vscode配置

- 重点是`.vscode`里面的3个文件
  - `task.json`
  - `launch.json`
  - `c_cpp_properties.json`

- 详细的配置项目说明可以参考vscode的官方文档,通常只需要看c/c++ extension的这部分提到的简单配置即可
  - [Get Started with C++ and MinGW-w64 in Visual Studio Code](https://code.visualstudio.com/docs/cpp/config-mingw#_debug-helloworldcpp)



### 相关指令和快捷键

- | command                            | shutcut(default) | Notes                                                        |
  | ---------------------------------- | ---------------- | ------------------------------------------------------------ |
  | `Start Debugging`                  | `F5`             | 最常用的快捷键,一键编译运行源代码,并且可以设置支持打断点调试 |
  | `Tasks:Run Build Task`             | 无               | 仅编译源代码,可以得到编译后的可执行的二进制文件,但是不会运行,通常是作为`Start Debugging`的第一个步骤,比较少单独使用 |
  | `Debug:Select and Start Debugging` | 无               | 选择一个debug方案,特别是您已经配置了多个方案时,              |
  | `Tasks:Config Default Build Task`  | 无               | 选择默认的task配置,为了适应不同的编译需要,用户在`task.json`和`launch.json`中可以配置多个版本;可以从中选择一个最常用的配置 |
  | `Tasks:Config Task`                | 无               | 配置task,最后会跳转到`tasks.json`文件中的某一个tasks数组中的一个对象,每个对象对应一个task配置 |

- 相关快捷键可以自行修改

- | 相关指令操作                                                 | 说明                                                         |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/7e6d234b46c947cf9e8b07504680ac7a.png) | 我这里配置了3个task,为了名称简洁,以及方便引用,我把各个对象中的`Label`字段简单重名为`task x`的形式;<br />您可以利用这个命令`tasks:configure` |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/a91fcb90ed1d4140bc9670d100d6138c.png) | command paletee中输入:`Run C/C++ File`                       |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/d99f652a21d4448196812f20f71aaa44.png)<br />![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/4de45db50e24487d88be341332005938.png) | `tasks:run build task`可以列出配置在`tasks.json`中的`build task`,(但是如果配置了默认task,可能不会列出全部的task);<br />如果取消掉所有设置默认的task,就会列出所有tasks;<br />选中其中的一个,可以启动编译,顺利的话会得到一个可执行二进制文件;<br /> |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/ca0038cc196543bea188a34ded2108ef.png) | 可以从command palette输入`Debug:Select and Start Debugging`进行选择debug方案 |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/2eafb8ec984e492197cc32596b4480ba.png) | 也可以找到侧边的按钮中得到列表内选择一个debug方案;           |

- 如果刚刚配置好`tasks.json`,`launch.json`但是列表中没有显示出来对应的方案,可以尝试重载vscode窗口(或者重启vscode)
- 如果始终没有,可能是配置文件(json)出错了

### 默认task配置和取消默认

- 在`tasks.json`中的某个task中设置`"group"`对象

- ```bash
  //配置默认的build task(注意不要多个task争抢默认build)
  // 非默认的task的"group"字段配置为:"group":"build",或考虑将"isDefault"设置为false
  "group": {
      "kind": "build",
      "isDefault": false //改为true就表示设置为默认
  },
  ```



## 配置文件

- 下面我给出自己的配置,其特点是基本满足各种编译需求,适用于轻量的`C/C++`编译	
- 在讲具体配置内容之前,先了解以下内容
- `tasks.json`中的`tasks`数组
  - 每个元素是一个对象,视为一个`build task`,分别表示一种build源代码的方案
  - 首先我的建议是取一个合适的`task`名字,在各个`task`对象的`label`字段中配置,名字可以设置的简单一些
    - 不需要担心命名太简单而看不出配置的用途,因为我们可以在detail字段中写入详细的信息
    - 将label字段设置的简单的好处在于`launch.json`中的`preLaunchTask`引用起来就方便,尽管您可以复制粘贴label字段的值代替手动输入到`preLaunchTask`字段😊
- `launch.json`中的`configurations`数组
  - 每个元素是一个对象,可以视为一个`launch`方案,表示如何调试源代码(包括使用哪个调试器(debugger),要启动哪一个build task,调试时要传递什么参数给调试器等)
  - 这里最重要的除了配置正确的调试器路径,还要设置启动正确的task名称,这些名称从`tasks.json`中的label字段查找,比如我在`tasks.json`中配置了3种`build task`方案分别名为`task1,task2,task3`那么合法的名字就只有上述3个
  - 当然默认产生的task 的`label`一般是`C/C++: g++.exe build active file`,这个东西可以按照自己的喜好和方便使用的角度修改
  - `launch.json`中有`name`字段可以写得详细一些,因为我们不需要再引用这里的`name`字段了
  - `name`字段的值会显示在选择debug方案的列表中,供我们辨认不同的debug方案和选择
- 最后`c_cpp_properties.json`文件,不是必须要的,但是如果有需要可以配置一些库的路径,编译标准版本等

### C/C++共用一组tasks.json/launch.json文件?

- 您可以考虑vscode中新建工作区,来分别配置.vscode中的相关文件
- 也可以让c/c++共用一组配置文件,但是json文件里的task,等可以相对独立,因此也是可以考虑两种语言的build task 和debug方案配置在同一组文件中

### 关于注释

- 在json文件中编写注释是不可靠的

- 顶多是创建一个`comment`字段或者`description`,或者`detail`字段,然后将注释字符串写入到该字段的值下

- 另一方面,使用`vscode command palette`配置tasks.json等文件时,可能会清空掉所有`//`引出的注释,从而导致注释丢失

  

### 内容示例👺

- 下面的两个配置文件是经过一定的实践,能够良好并相对舒适得工作
- 如果vscode变动不大,那么直接复制粘贴到自己的C/C++ vscode工程目录中也是可以的

#### tasks.json内容示例

- ```json
  {
      "tasks": [
          {
              "type": "cppbuild",
              "label": "task1",
              "command": "C:\\msys64\\ucrt64\\bin\\g++.exe",
              "args": [
                  "-fdiagnostics-color=always",
                  "-g",
                  "*.cpp", //如果要编译多个c文件,将*.cpp改为*.c;而在这个文件里我另外配了一个task1c,来对*.c文件执行类似的功能
                  "-o",
                  "${fileDirname}\\All.exe"
              ],
              "options": {
                  "cwd": "${fileDirname}"
              },
              "problemMatcher": [
                  "$gcc"
              ],
              //配置默认的build task(注意不要多个task争抢默认build)
              // 非默认的task的"group"字段配置为:"group":"build",或考虑将"isDefault"设置为false
              "group": {
                  "kind": "build",
                  "isDefault": false //改为true就表示设置为默认
              },
              "detail": "build  C++ language files(*.cpp) in the ${fileDirname} directory (not c files) "
          },
          {
              "type": "cppbuild",
              "label": "task1c",
              "command": "C:\\msys64\\ucrt64\\bin\\g++.exe",
              "args": [
                  "-fdiagnostics-color=always",
                  "-g",
                  "*.c",
                  "-o",
                  "${fileDirname}\\All.exe"
              ],
              "options": {
                  "cwd": "${fileDirname}"
              },
              "problemMatcher": [
                  "$gcc"
              ],
              "group": "build",
              "detail": "build C language files(*.c) in the ${fileDirname} directory (rather than c++ files,this is a fork of task1)"
          },
          {
              "type": "cppbuild",
              "label": "task2",
              "command": "C:\\msys64\\ucrt64\\bin\\g++.exe",
              "args": [
                  "-fdiagnostics-color=always",
                  "-g",
                  "${file}", //编译当前打开(active状态,鼠标点击后)的源文件,无法分辨是否为c/c++源代码,因此如果用这个配置来编译其他语言的源代码会出错!或说回来一个简单工程目录文件中通常只有一种语言,但是复杂项目则往往有多种语言代码文件,这时候要小心配置并选择合适的build task,以及后续的debug配置
                  "-o",
                  "${fileDirname}\\a.exe"
              ],
              "options": {
                  "cwd": "${fileDirname}"
              },
              "problemMatcher": [
                  "$gcc"
              ],
              "group": "build",
              "detail": "build active file(c/c++),output a.exe  (For Englis, Chinese characters and other non-English characters)."
          },
          {
              "type": "cppbuild",
              "label": "task3",
              "command": "C:\\msys64\\ucrt64\\bin\\g++.exe",
              "args": [
                  "-fdiagnostics-color=always",
                  "-g",
                  "${file}",
                  "-o",
                  "${fileDirname}\\${fileBasenameNoExtension}.exe"
              ],
              "options": {
                  "cwd": "${fileDirname}"
              },
              "problemMatcher": [
                  "$gcc"
              ],
              "group": "build",
              "detail": "Task generated by Debugger(Default). This is not compatible with Chinese characters or other non-English characters."
          }
      ],
      "version": "2.0.0"
  }
  ```

  

#### launch.json内容示例

- ```json
  {
      "version": "0.2.0",
      "configurations": [
          // 对于一个脚本和C++控制台小程序的工作区,可以存放多种编程语言源文件,比如可以将python的调试配置也可以放进来,和C/C++的debug方案放在一起,充当configurations数组的元素,这样一个工作区可以通过选择包含在本文件的不同的配置来调试不同语言的程序
          // {
          //     "name": "Python Debugger: Current File",
          //     "type": "debugpy",
          //     "request": "launch",
          //     "program": "${file}",
          //     "console": "integratedTerminal"
          // },
          {
              "name": "C/C++: g++.exe build and debug the C++ language files",
              "type": "cppdbg",
              "request": "launch",
              // "program": "${fileDirname}\\${fileBasenameNoExtension}.exe",
              "program": "${fileDirname}\\All.exe",
              "args": [],
              "stopAtEntry": false,
              "cwd": "${fileDirname}",
              "environment": [],
              "externalConsole": false,
              "MIMode": "gdb",
              "miDebuggerPath": "C:\\msys64\\ucrt64\\bin\\gdb.exe",
              "setupCommands": [
                  {
                      "description": "Enable pretty-printing for gdb",
                      "text": "-enable-pretty-printing",
                      "ignoreFailures": true
                  },
                  {
                      "description": "Set Disassembly Flavor to Intel",
                      "text": "-gdb-set disassembly-flavor intel",
                      "ignoreFailures": true
                  }
              ],
              // "preLaunchTask": "C/C++: g++.exe build active file"
              "preLaunchTask": "task1"
          },
          {
              "name": "C/C++: g++.exe build and debug the C language files",
              "type": "cppdbg",
              "request": "launch",
              "program": "${fileDirname}\\All.exe",
              "args": [],
              "stopAtEntry": false,
              "cwd": "${fileDirname}",
              "environment": [],
              "externalConsole": false,
              "MIMode": "gdb",
              "miDebuggerPath": "C:\\msys64\\ucrt64\\bin\\gdb.exe",
              "setupCommands": [
                  {
                      "description": "Enable pretty-printing for gdb",
                      "text": "-enable-pretty-printing",
                      "ignoreFailures": true
                  },
                  {
                      "description": "Set Disassembly Flavor to Intel",
                      "text": "-gdb-set disassembly-flavor intel",
                      "ignoreFailures": true
                  }
              ],
              "preLaunchTask": "task1c"
          },
          {
              "name": "C/C++: g++.exe build and debug active file(For English, Chinese characters and other non-English characters)",
              "type": "cppdbg",
              "request": "launch",
              // "program": "${fileDirname}\\${fileBasenameNoExtension}.exe",
              "program": "${fileDirname}\\a.exe",
              "args": [],
              "stopAtEntry": false,
              "cwd": "${fileDirname}",
              "environment": [],
              "externalConsole": false,
              "MIMode": "gdb",
              "miDebuggerPath": "C:\\msys64\\ucrt64\\bin\\gdb.exe",
              "setupCommands": [
                  {
                      "description": "Enable pretty-printing for gdb",
                      "text": "-enable-pretty-printing",
                      "ignoreFailures": true
                  },
                  {
                      "description": "Set Disassembly Flavor to Intel",
                      "text": "-gdb-set disassembly-flavor intel",
                      "ignoreFailures": true
                  }
              ],
              "preLaunchTask": "task2"
          },
          {
              "name": "C/C++: g++.exe build and debug active file",
              "type": "cppdbg",
              "request": "launch",
              "program": "${fileDirname}\\${fileBasenameNoExtension}.exe",
              "args": [],
              "stopAtEntry": false,
              "cwd": "${fileDirname}",
              "environment": [],
              "externalConsole": false,
              "MIMode": "gdb",
              "miDebuggerPath": "C:\\msys64\\ucrt64\\bin\\gdb.exe",
              "setupCommands": [
                  {
                      "description": "Enable pretty-printing for gdb",
                      "text": "-enable-pretty-printing",
                      "ignoreFailures": true
                  },
                  {
                      "description": "Set Disassembly Flavor to Intel",
                      "text": "-gdb-set disassembly-flavor intel",
                      "ignoreFailures": true
                  }
              ],
              "preLaunchTask": "task3"
          }
      ]
  }
  ```

  

## 参考的仓库

- 您可以在命令行内`git clone https://gitee.com/xuchaoxin1375/C_CPP_ConsoleApps.git`
- 这会拉去一个简单的仓库,里面的vscode配置是基于`Msys2`的
- 如果您安装的也是Msys2的windows GCC环境,并且是默认路径,那么clone下来的仓库内编写的`c/c++`代码就可以直接运行
- 如果您使用的是MinGw,那么修改相应的g++编译器路径也就可以了
- 最后,要注意编译运行单个C/C++代码文件通常选用`task2`的配置
  - 如果要运行的程序被拆分为单个或多个C++源代码文件,他们被组织在各自的目录里面且不包含其他程序的源文件,那么使用`task1`来编译并运行或调试(如果是C源代码,那么使用`task1c`)
  - 如果您的习惯是不同程序的源代码都放到同一个目录,那么使用`task2`比较合适
    - 其限制是每个程序只能存放在一个c/c++文件中(.h头文件除外),否则拆分到多个`.c/.cpp`文件task2识别不了到底哪几个源文件是构成同一个程序,哪些又是不需要参与编译的原文件
  - `task3`是默认的配置,可以编译单个英文名字的c/c++源代码文件,对于中文名字的源代码来说就不友好了,容易报错
- 总的来说,练习OJ题目或者Leetcode题目,使用`task2`来编译,c/c++通吃
- 多文件并且按程序相关性把源文件组织到各自的目录中时,用`task1`或`task1c`编译
- `task3`是默认的，对中文不友好,可以不用
- 另一方面也可以灵活切换编译配置,比如目录`mix/`下是一堆相互独立,或者完全不相关的c/c++源代码文件,他们可能各自都是一个完整的程序源代码,此时把编译模式切换到`task2`
- 反之,假设目录`demos`里面包含了许多文件夹,每个文件夹里各表示一个程序,里面将一个程序的源代码拆分为多份,那么用`task1`或`task1c`去编译
- 当然通常我们用`launch.json`来配置编译和调试(build and debug)一条龙,而不是直接用`tasks.json`来直接编译
- 因此您可以选择command palette中输入`debug: select and start debugging`选择一个方案进行编译调试(我提供的仓库已经组织好了,配置了几种模式)



## 编译中文环境下的源代码文件相关问题

- 根据官方文档的教程,配置后可以良好的编译和调试纯英文下的C++/C程序
- 对于国内用户来说,经常会将文件命名为中文,或者源代码中充斥了大量的中文注释
- 尽管我们提倡在代码中尽可能使用英文,但是对于部分用来说这个要求有点高
- 因此我们还需要解决vscode中编译和调试中文名的C++程序会乱码的问题

## FAQ

### 编译多个源文件😊

- task.json和launch.json分别负责控制编译和调试

- 通常简单的需求只需要在默认生成的文件内稍作修改就可以工作
- 然而对于稍微复杂的编译需求,我们需要进一步的配置
  - 比如配置能够编译/调试多个源文件的情况
  - 配置能够编译/调试中文源文件的情况

#### 源文件组织

- 通常我们将同一个程序(源代码分散到了多个不同源文件)的相关源文件存放到**同一个目录**中,而其他程序的源文件就不要混进来,这样不利于管理和一键编译的配置
- 换句话说,假设您将多个相互独立(或者没有关系的)源文件放到同一个目录,那么一口气将它编译链接就会出问题
  - 尽管我们可以用命令行手动选择要编译哪些源文件,但是不利于我们配置`task.json`进行一键编译
  - 所以这里强调同一个程序有多个源文件时要组织到一个单独的目录中去,并且不要参杂其他程序源文件

### 编译出的可执行文件名中文乱码😊

- 实验发现,对于文件名为中文的C++/C语言源代码编译时得到的`.exe`文件名会是乱码

- 这就导致`launch.json`中默认配置的调试语句找不到编译后的可执行文件,导致调试报错无法进行下去

- 对于简单控制台程序,从实践的角度,通常我们希望编写玩一个c++程序,然后可以一键编译运行或调试,就可以了

- 当然最好能够兼容中文名源文以及英文名源文件

- 现在的问题是遇到中文名源文件,windows上的Gcc(Mingw或其他移植Gcc)的项目编译中文名c++文件在不同场景下有不同的效果

  - ```bash
    PS[BAT:69%][MEM:42.83% (13.58/31.70)GB][21:01:23]
    # [C:\repos\C_CPP_ConsoleApps]
     g++ .\勾股.cpp -o 勾股.exe
    
    PS[BAT:69%][MEM:42.79% (13.56/31.70)GB][21:01:48]
    # [C:\repos\C_CPP_ConsoleApps]
     ls *.exe
    
            Directory: C:\repos\C_CPP_ConsoleApps
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         2024/4/24     21:01         140467 󰣆  勾股.exe
    
    
    ```

  - 上述试验说明,在命令行中手动调用g++来编译没有没有出现文件名乱码的结果

- 然而,vscode中匹配了tasks.json和launch.json进行一键编译运行时确发生了二进制文件中文名称乱码的情况

### 修改tasks.json和launch.json

- 文档中指出,我们可以通过配置

  - `tasks.json`中的编译选项(`-o`后的值(编译结果)为英文硬编码,比如`a.exe`)

    - ```json
      "args": [
          "-fdiagnostics-color=always",
          "-g",
          "${file}",
          "-o",
          "${fileDirname}\\a.exe" //修改这里,默认的值为"${fileDirname}\\${fileBasenameNoExtension}.exe"
      ],
      ```

      

  - 然后再配置`launch.json`中的`program`字段

    - ` "program": "${fileDirname}\\a.exe",`

  - 也就是编译出来的名字总是命名为`a.exe`,然后调试时找的也是同目录下的`a.exe`,避开了中文可能导致的乱码,导致调试器找不到对应的可执行文件报错

- 上述操作虽然没有正面解决中文文件名乱码问题,但是已经能够让我们比较舒服的使用vscode来学习C/C++编程和算法,能够一键编译和运行/调试代码,甚至可以配置一键编译分散在多个源文件的程序,中文文件名确实也不报错了,基础阶段非常够用

- 如果确实需要所有编译出来的可执行文件,那么写个脚本就行

## 早期使用MinGw配置Vscode的C/C++编程环境的探索

- 早期的实践,操作比较稚嫩,有缘可能会回去改改:链接在此[浏览 (csdn.net)](https://blog.csdn.net/xuchaoxin1375/article/details/108942931)





