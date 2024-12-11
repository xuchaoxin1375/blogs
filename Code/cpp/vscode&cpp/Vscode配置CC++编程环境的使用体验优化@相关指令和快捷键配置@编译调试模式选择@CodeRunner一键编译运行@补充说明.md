[toc]



## 快速编译运行👺

如果您的编程场景相对简单,比如仅仅是写一些算法题(比如学生党)或者是检查验证某些语言特性或验证猜想,这类用途下只要将所有代码放到同一个源文件中(`.c/.cpp`)中,那么使用快捷键快速编译运行将会是更快捷的方法

您当然可以选择通用而灵活的命令行做编译运行操作,但是远不如快捷键来的方便,不过对于复杂编译场景或需求,还是用命令比较合适,比如需要频繁修改编译参数,或者需要编译多个文件等复杂情况

vscode中编译和调试可以分开,编译环节可以使用命令`Run build task`(command palette),或者使用快捷键启动,这么做可以实现快速编译,跳过调试(gdb)部分,但是不会自动运行编译出来的程序,仍然不够快捷

### code runner插件方案👺

主打快捷地编译运行,不考虑复杂的编译需求和方案选项,也不考虑调试操作,但是这已经能够满足基本的c/c++编程环境的需要了

这里的快捷键快速编译运行采用的方案是使用插件:

[Code Runner - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)

本方案是相对独立的方案,甚至不需要使用c/c++扩展,只要安装了c/c++编译器,安装code runner插件,配置环境变量或者提供编译器程序的绝对路径

- 这个方案虽然简单,但是意味着补全和提示,断点调试功能会受到影响,所以仍然建议配置以下c/c++插件,code runner 插件作为快速编译运行的选项灵活使用(可以选择独立或不同版本的编译器,提供编译器绝对路径即可)

为了兼容中文源文件名的编译,这里给出`c/cpp`两种语言的源文件编译的配置json

这里默认将编译结果的文件名设置为`a.exe`,并且运行也是用这个名字

你可以选择将编译结果总是放到统一的位置,并始终使用同一个名字`a.exe`便于定位可执行文件,比如总是将编译结果放到项目的根目录下(由于名字都是同一个,因此编译不同程序会替代或覆盖之前的`a.exe`,这对于联系c/c++问题不大)

#### 解决中文乱码

在linux系统下(或windows wsl),以我的使用经验,编译运行包含中午路径的代码不会出现乱码,因此编程环境天生要比windows更加友好,如果你的机器配置不太老旧,或者条件允许,即便你用的是windows,那使用wsl也是一个推荐选项

对于英文系统,或者中文系统编译运行成功但是输出的中文乱码,使用`chcp 65001`可以尝试解决中文乱码,注意使用chcp指定活动代码是有技巧的,不是随便用的;要将chcp语句放到编译运行语句同一行

### 简单配置👺

这里提供的配置参考仅针对编译单个源文件的情况,也没有使用编码指定参数` -finput-charset,-fexec-charset`

对于linux下，code runner 可以配置如下(不需要特别处理中文乱码)

```bash
//linux
"c": " gcc    $fullFileName -o \"$workspaceRoot/a.exe\" ; eval \"$workspaceRoot/a.exe\" ",
"cpp": " g++    $fullFileName -o \"$workspaceRoot/a.exe\" ; eval \"$workspaceRoot/a.exe\" ",

```

对于windows下,code runner配置如下(需要用chcp在运行时使用utf-8编码防止乱码)

下面这个配置其实兼容linux,但是由两个语句是linux理解不了的,所以在linux上会慢一点

为了将输出结果和终端命令行可读性更好,这里设置了一个空行,间隔命令行和输出

```json
// Windows
"c": " gcc    $fullFileName -o \"$workspaceRoot/a.exe\" &&  chcp 65001 >$null; echo '' ;. \"$workspaceRoot/a.exe\" ",
"cpp": " g++    $fullFileName -o \"$workspaceRoot/a.exe\" && chcp 65001 >$null;echo '' ; . \"$workspaceRoot/a.exe\" ",
```

运行结果

```powershell
PS>  g++    "c:\repos\c_cpp_consoleapps\zh测试中文目录\helloworld你好世界Pause.cpp" -o "c:\repos\c_cpp_consoleapps/a.exe" ; if ($?) { chcp 65001 >$null;echo '' ; . "c:\repos\c_cpp_consoleapps/a.exe"  }

Hello World!(你好,世界123)

```



#### 其他候选参考配置

```json
"c": " gcc  -finput-charset=UTF-8 -fexec-charset=gbk $fullFileName -o \"$workspaceRoot\\a.exe\" &&  . \"$workspaceRoot\\a.exe\"",
"cpp": " g++  -finput-charset=UTF-8 -fexec-charset=gbk  $fullFileName -o \"$workspaceRoot\\a.exe\" &&  . \"$workspaceRoot\\a.exe\" ",
```

如果想要把不同目录下的文件编译的结果放回该目录,那么使用下面的一组配置

```json
"c": "cd $dir && g++ -std=c++11 -finput-charset=UTF-8 -fexec-charset=gbk \"$fileName\" -o \"a.exe\" &&  .\\\"a.exe\"",
"cpp": "cd $dir && g++ -std=c++11 -finput-charset=UTF-8 -fexec-charset=gbk \"$fileName\" -o \"a.exe\" &&  .\\\"a.exe\"",


```

如果你想要保留源文件的名字(兼容中文),也是可以的,这里使用`-finput-charset=UTF-8 -fexec-charset=gbk`来指定中文文件名编码,并且使用了预设变量` $fileName,$fileNameWithoutExt`等

```json
"c": "cd $dir && g++ -std=c++11 -finput-charset=UTF-8 -fexec-charset=gbk \"$fileName\" -o \"$fileNameWithoutExt.exe\" &&  .\\\"$fileNameWithoutExt.exe\"",

"cpp": "cd $dir && g++.exe -std=c++11 -finput-charset=UTF-8 -fexec-charset=gbk \"$fileName\" -o \"$fileNameWithoutExt.exe\" &&  .\\\"$fileNameWithoutExt.exe\"",

```

额外可选的,你可以指定不存在于path变量指定的目录中的g++/gcc编译器,而选择使用指定目录下的编译器也是可以的,例如

```json
"cpp": "cd $dir && C:\\exes\\RedPanda-CPP\\mingw64\\bin\\g++.exe -std=c++11 -finput-charset=UTF-8 -fexec-charset=gbk \"$fileName\" -o \"$fileNameWithoutExt.exe\" &&  .\\\"$fileNameWithoutExt.exe\"",
```

相关配置文档:(详情查看上述链接)

#### Code Runner Configuration

- Make sure the executor PATH of each language is set in the environment variable. 
- You could also add entry into `code-runner.executorMap` to set the executor PATH. e.g. To set the executor PATH for ruby, php and html:

```json
{
    "code-runner.executorMap": {
        "javascript": "node",
        "php": "C:\\php\\php.exe",
        "python": "python",
        "perl": "perl",
        "ruby": "C:\\Ruby23-x64\\bin\\ruby.exe",
        "go": "go run",
        "html": "\"C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe\"",
        "java": "cd $dir && javac $fileName && java $fileNameWithoutExt",
        "c": "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt"
    }
}
```

**Supported customized parameters**👺

1. `$workspaceRoot`: The path of the folder opened in VS Code
2. `$dir`: The directory of the code file being run
3. `$dirWithoutTrailingSlash`: The directory of the code file being run without a trailing slash
4. `$fullFileName`: The full name of the code file being run
5. `$fileName`: The base name of the code file being run, that is the file without the directory
6. `$fileNameWithoutExt`: The base name of the code file being run without its extension
7. `$driveLetter`: The drive letter of the code file being run (Windows only)
8. `$pythonPath`: The path of Python interpreter (set by `Python: Select Interpreter` command)

**Please take care of the back slash and the space in file path of the executor**

- Back slash: please use `\\`
- If there ares spaces in file path, please use `\"` to surround your file path

### 利用vscode profiles设置多套配置

vscode profiles 是vscode的一项强大特性,能够为你隔离不同的vscode环境,在不同的profile配置下,可以定制各自profile下的插件启用和配置,比如可以配置linux下的C/C++变成环境,和windows下的C/C++编程环境进行独立自定义

[Profiles in Visual Studio Code](https://code.visualstudio.com/docs/editor/profiles)

### 直接配置

- 使用`launch.json`启动编译和调试虽然可以一键执行,但是速度比较慢

- 要知道直接用g++命令行编译是很快的,所以我们可以设法改进这一点

- 我们可以用Code Runner插件来快速执行编译并直接运行,而不是编译后启动调试运行

  - [Code Runner - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)

- 我们以hellow，world为例

  - 配置后按下快捷键可以有如下效果

    ```bash
    PS C:\repos\C_CPP_ConsoleApps> cd "c:\repos\C_CPP_ConsoleApps\cpp\" ; if ($?) { g++ -std=c++11 "hellowworld2.cpp" -o "hellowworld2.exe" } ; if ($?) {  .\"hellowworld2.exe" }
    Hello World!
    ```

  - 如果使用默认的`start debugging`,速度要慢上许多

    - ```cmd
      PS C:\repos\C_CPP_ConsoleApps>  & 'c:\Users\cxxu\.vscode\extensions\ms-vscode.cpptools-1.20.3-win32-x64\debugAdapters\bin\WindowsDebugLauncher.exe' '--stdin=Microsoft-MIEngine-In-pcmtfxlj.w4p' '--stdout=Microsoft-MIEngine-Out-f12ge22g.01f' '--stderr=Microsoft-MIEngine-Error-i3ud5s4n.nq2' '--pid=Microsoft-MIEngine-Pid-cwud2zvq.q2k' '--dbgExe=C:\msys64\ucrt64\bin\gdb.exe' '--interpreter=mi' 
      Hello World!
      ```

    

- 配置`tasks.json`(不推荐)

  - ```bash
    "args": [
            "-fdiagnostics-color=always",
            // "-g",
            "${file}",
            "-o",
            "${fileDirname}\\a.exe",
            "&&",
            "a.exe"
        ],
    ```

  - 您或许考虑创建一个task令其编译完成后追加运行

  - 但是这并不好用,估计vscode c++ extension并没有打算让用户这么用

    - 如果仅仅是输出hello,world 这种程序还要,但是如果先要输入,那么build task就会被卡住

## 相关指令和快捷键👺

- | command                            | shutcut(default) | Notes                                                        |
  | ---------------------------------- | ---------------- | ------------------------------------------------------------ |
  | `Debug:start Debugging`            | `F5`             | 最常用的快捷键,一键编译运行源代码,并且可以设置支持打断点调试 |
  | `Tasks:Run Build Task`             | 无               | 仅编译源代码,可以得到编译后的可执行的二进制文件,但是不会运行,通常是作为`Start Debugging`的第一个步骤,比较少单独使用 |
  | `Debug:Select and Start Debugging` | 无               | 选择一个debug方案,特别是您已经配置了多个方案时,              |
  | `Tasks:Config Default Build Task`  | `ctrl+shift+b`   | 选择默认的task配置,为了适应不同的编译需要,用户在`task.json`和`launch.json`中可以配置多个版本;可以从中选择一个最常用的配置 |
  | `Task:Run task`                    | 无               | 你配置了task.json中有多个可选的方案时,可以用`run task`指令选择一个方案来编译(构建) |
  | `Tasks:Config Task`                | 无               | 配置task,最后会跳转到`tasks.json`文件中的某一个tasks数组中的一个对象,每个对象对应一个task配置 |


相关快捷键可以自行修改

- | 相关指令操作                                                 | 说明                                                         |
  | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | ![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/c4acc7ef22124293a42c315684134f3c.png) | 代码构建任务(执行编译操作);其中`run task`在你配置了task.json中有多个可选的方案时,可以用`run task`指令选择一个方案来编译(构建),该指令默认没有快捷键,可以自己配;<br />另一个类似的是`run task build`,会执行配置为默认的task构建方案. |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/7e6d234b46c947cf9e8b07504680ac7a.png) | 我这里配置了3个task,为了名称简洁,以及方便引用,我把各个对象中的`Label`字段简单重名为`task x`的形式;<br />您可以利用这个命令`tasks:configure` |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/a91fcb90ed1d4140bc9670d100d6138c.png) | command paletee中输入:`Run C/C++ File`                       |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/d99f652a21d4448196812f20f71aaa44.png)<br />![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/4de45db50e24487d88be341332005938.png) | `tasks:run build task`可以列出配置在`tasks.json`中的`build task`,(但是如果配置了默认task,可能不会列出全部的task);<br />如果取消掉所有设置默认的task,就会列出所有tasks;<br />选中其中的一个,可以启动编译,顺利的话会得到一个可执行二进制文件;<br /> |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/ca0038cc196543bea188a34ded2108ef.png) | 可以从command palette输入`Debug:Select and Start Debugging`进行选择debug方案 |
  | ![在这里插入图片描述](https://img-blog.csdnimg.cn/direct/2eafb8ec984e492197cc32596b4480ba.png) | 也可以找到侧边的按钮中得到列表内选择一个debug方案;           |
  
- 如果刚刚配置好`tasks.json`,`launch.json`但是列表中没有显示出来对应的方案,可以尝试重载vscode窗口(或者重启vscode)

- 如果始终没有,可能是配置文件(json)出错了

### 默认task配置和取消默认

- 在`tasks.json`中的某个task中设置`"group"`对象

- ```powershell
  //配置默认的build task(注意不要多个task争抢默认build)
  // 非默认的task的"group"字段配置为:"group":"build",或考虑将"isDefault"设置为false
  "group": {
      "kind": "build",
      "isDefault": false //改为true就表示设置为默认
  },
  ```



- ## 配置文件补充介绍(可选 推荐阅读)👺

  - 下面我给出自己的配置,其特点是基本满足各种编译需求,适用于轻量的`C/C++`编译	
  - 在讲具体配置内容之前,先了解以下内容
  - `tasks.json`中的`tasks`数组
    - 每个元素是一个对象,视为一个`build task`,分别表示一种build源代码的方案
    - 首先我的建议是取一个合适的`task`名字,在各个`task`对象的`label`字段中配置,名字可以设置的简单一些
      - 不需要担心命名太简单而看不出配置的用途,因为我们可以在detail字段中写入详细的信息
      - 将label字段设置的简单的好处在于`launch.json`中的`preLaunchTask`引用起来就方便,尽管您可以复制粘贴label字段的值代替手动输入到`preLaunchTask`字段😊
  - `launch.json`中的`configurations`数组
    - 每个元素是一个对象,可以视为一个`launch`方案,表示如何调试源代码(包括使用哪个调试器(debugger),要启动哪一个build task,调试时要传递什么参数给调试器等)
    - 这里最重要的除了配置正确的调试器路径,还要设置启动正确的task名称,这些名称从`tasks.json`中的label字段查找,比如
      - 在`tasks.json`中配置了3种`build task`方案分别名为`task1,task2,task3`那么合法的名字就只有上述3个
      - 当然你也可以派生出其他配置,比如`task1c`,`task2c`等
      - 根据需要选择不同的配置来构建(编译代码),相关指令有`run task`,`run build task`(前者更灵活,后者可以设置默认后更快捷)
    - 当然默认产生的task 的`label`一般是`C/C++: g++.exe build active file`,这个东西可以按照自己的喜好和方便使用的角度修改
    - `launch.json`中有`name`字段可以写得详细一些,因为我们不需要再引用这里的`name`字段了
    - `name`字段的值会显示在选择debug方案的列表中,供我们辨认不同的debug方案和选择
  - 最后`c_cpp_properties.json`文件,不是必须要的,但是如果有需要可以配置一些库的路径,编译标准版本等

### 使用vscode预置变量和环境变量

- [Visual Studio Code Variables Reference](https://code.visualstudio.com/docs/editor/variables-reference#_environment-variables)

- Visual Studio Code（VS Code）支持在调试和任务配置文件以及某些特定设置中使用变量替换。这些变量通过 `${variableName}` 语法在 `launch.json` 和 `tasks.json` 文件中的键值字符串内实现替换。

- 用户环境变量和系统环境变量的引用:假设我配置了用户环境变量`MSYS2_MINGW`,并且确认了该值的有效性

  - ```powershell
    PS> $env:MSYS2_MINGW
    C:\msys64\ucrt64\bin
    ```

    

  - ```powershell
    PS[BAT:79%][MEM:32.00% (10.14/31.70)GB][22:02:08]
    # [C:\repos\C_CPP_ConsoleApps]
      ls $env:MSYS2_MINGW |where{$_.Name -like "gcc.*" -or $_.Name  -like "g++.*" -or $_.Name -like "gdb.*"}
    
            Directory: C:\msys64\ucrt64\bin
    
    
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a---         2023/12/2      2:14        2721152 󰣆  g++.exe
    -a---         2023/12/2      2:14        2718592 󰣆  gcc.exe
    -a---         2023/12/4     21:52       10370879 󰣆  gdb.exe
    ```

    

  - 我在配置C/C++的试验中,发现引用环境变量仅在`launch.json`中是有效的

    - ```powershell
      "miDebuggerPath": "${env:MSYS2_MINGW}\\gdb"
      ```

  - 然而,在`tasks.json`中引用环境变量是无效的


## 环境变量的使用

### 使用环境变量的好处

- 如果将相关路径(gcc,g++,gdb所在路径)添加到`Path`路径中,那么就可以直接用名字`gcc,g++,gdb`来代替绝对路径

  - 如果是用户级别的环境变量,不需要管理员权限,否则需要管理员权限
  - 总之这个任务很简单,资料也很丰富,这里不赘述;但是配置了以后很有用,
  - 对于windows系统这类给出几个途径
    - 命令行输入` SystemPropertiesAdvanced.exe`或者开始菜单中输入` 环境变量`或者`path`搜索就可以打开配置环境变量的控制面板,点击环境变量进行配置
    - 用户级别和系统级别的Path任选其一将路径添加到Path变量中即可;
    - 老手也可以选择用命令行配置,比如`setx`,powershell还可以用` [Environment]::SetEnvironmentVariable()`来配置
  - 配置完毕后需要重启终端(打开全新终端),而且老终端中启动的程序要全部关掉重新打开才能检测到新环境变量的变化!比如vscode

### 环境变量可能引起的问题

- 生产环境的环境变量配置需要考虑的问题更多,配置环境变量虽然能够提供方便,但是可能引入潜在的混淆的机会
- 但是对于学习环境,配置环境变量是方便和可行的,也是很平常的事情



### 检查编译器所在目录是否正确配置进Path变量

- 上面的路径配置不是必须的,但确实很有用,可以带来便利的操作

- 通过以下命令来检查是否配置成功

  ```powershell
  gcc --version
  g++ --version
  gdb --version
  
  
  ```

- ```powershell
  PS[BAT:79%][MEM:34.73% (11.01/31.70)GB][22:07:20]
  # [C:\repos\scripts]
  PS> gcc --version
  gcc.exe (Rev3, Built by MSYS2 project) 13.2.0
  Copyright (C) 2023 Free Software Foundation, Inc.
  This is free software; see the source for copying conditions.  There is NO
  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  
  
  PS[BAT:79%][MEM:36.41% (11.54/31.70)GB][22:18:52]
  # [C:\repos\scripts]
  PS> g++ --version
  g++.exe (Rev3, Built by MSYS2 project) 13.2.0
  Copyright (C) 2023 Free Software Foundation, Inc.
  This is free software; see the source for copying conditions.  There is NO
  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  
  
  PS[BAT:79%][MEM:36.41% (11.54/31.70)GB][22:18:52]
  # [C:\repos\scripts]
  PS> gdb --version
  GNU gdb (GDB) 14.1
  Copyright (C) 2023 Free Software Foundation, Inc.
  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
  This is free software: you are free to change and redistribute it.
  There is NO WARRANTY, to the extent permitted by law.
  ```

- 上述命令各自没有报错,返回了各自的版本号,这说明配置是正确的

### 简化编译器和调试器的路径

- 经过上述的Path变量配置,我们可以在vscode中得到以下效果
- 可在任意终端中直接用`gcc,g++,gdb`来带直接调用相应的软件
- 可以简化vscode中的相关配置(末尾的逗号是json中的不同字段的分割符)
  - `tasks.json`中的` "command": "C:\\msys64\\ucrt64\\bin\\g++.exe",`可以简化为` "command": "g++",`
  - `launch.json`中的`"miDebuggerPath": "C:\\msys64\\ucrt64\\bin\\gdb.exe",`简单用`gdb`来代替,即可以简化为`"miDebuggerPath": "gdb",`
- 不仅如此,如果用的不是Msys2安装的`gcc,g++,gdb`而是其他方式安装的,比如直接用的MinGw安装的,那么我们也不需要去改动vscode中的配置文件,只需修改一下`Path`环境变量中`gcc,g++,gdb`的所在目录即可(通常这三个组件都是同一个目录)