[toc]

## abstract

- 本文是 [C++@vscode@语言编程环境配置](https://blog.csdn.net/xuchaoxin1375/article/details/138172679)的延续
- 介绍了使用vscode编写C/C++过程中的细节问题

## vscode配置C/C++开发环境常见问题 FAQ



### C/C++共用一组tasks.json/launch.json文件?

- 您可以考虑vscode中新建工作区,来分别配置.vscode中的相关文件
- 也可以让c/c++共用一组配置文件,但是json文件里的task,等可以相对独立,因此也是可以考虑两种语言的build task 和debug方案配置在同一组文件中

### 关于配置文件中的注释

- 在json文件中编写注释是不可靠的

- 顶多是创建一个`comment`字段或者`description`,或者`detail`字段,然后将注释字符串写入到该字段的值下

- 另一方面,使用`vscode command palette`配置tasks.json等文件时,可能会清空掉所有`//`引出的注释,从而导致注释丢失



### 更快地编译运行

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

### 调试时调用外部终端控制台

-  通常没有必要设置为外部终端打开,vscode内的集成终端以及足够使用了;
   - vscode中程序执行完毕后外置终端就会自动退出,除非使用Pause来阻止退出
   - Pause可以在源代码末尾中添加system("Pause");但是这就显得有些繁琐了,Dev C++等IDE会自动执行这个命令,而不需要我们手动设置
-  目前vscode c/c++ extension 没有支持这种自动pause的功能,因此我建议是除非必要或者心理过不去,否则就用vscode继承终端来调试程序的运行(输入和输出数据)



### 二次编译失败问题

- 个别情况下,如果前一次编译运行的程序没有被退出,而新的编译结果名字和上一次编译的名字一样,那么会因为名字被占用导致新的编译结果无法保存而失败

- 这可能表现为`cannot open output file ...`,Permission denied

  - ```bash
    Starting build...
    cmd /c chcp 65001>nul && g++.exe -fdiagnostics-color=always -g C:\repos\C_CPP_ConsoleApps\cpp\hellowworld2.cpp -o C:\repos\C_CPP_ConsoleApps\cpp\a.exe
    C:/msys64/ucrt64/bin/../lib/gcc/x86_64-w64-mingw32/13.2.0/../../../../x86_64-w64-mingw32/bin/ld.exe: cannot open output file C:\repos\C_CPP_ConsoleApps\cpp\a.exe: Permission denied
    
    collect2.exe: error: ld returned 1 exit status
    ```

- 这种情况还可能发生在同一个目录下编译了多个文件,假设它们的编译结果都保存为文件`a.exe`,而在某个a.exe尚未退出时编译了另一个文件,它们恰好在同一个目录下,就会造成失败

- 尽管这种情况很少见,我们通常同一时间同一目录内,仅处理一个程序;但是如果确实需要同时编译运行多个程序,有如下选择

  - 更换编译结果文件名后再编译:既然默认的名字被占用,那么可以切换不同的task配置再编译,或者临时用命令行指定新的`-o`参数后编译

  - 或者如果上一个程序是因为意外卡住,或者我们不需要它继续运行时,可以借助任务管理杀死相关进程后再编译,例如可以用任务管理,也可以用命令行处理

    - powershell查找名为a.exe的进程

      ```powershell
      ps a.exe|select path
      ```

    - 确认路径后手动杀死

      ```powershell
      PS> ps a|select path
      
      Path
      ----
      C:\repos\C_CPP_ConsoleApps\cpp\a.exe
      
      PS> ps a|kill
      
      ```

    - 然后重新尝试编译即可

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

  - 但是执行的时候可能会输出程序内部带出来的中文乱码,我们可以追加参数`-finput-charset=UTF-8 -fexec-charset=gbk`


- 示例

  - ```bash
    PS[BAT:79%][MEM:46.76% (14.82/31.70)GB][22:09:28]
    # [C:\repos\C_CPP_ConsoleApps]
     cat  C:\repos\C_CPP_ConsoleApps\cpp\helloworld.cpp
    #include <iostream>
    #include <vector>
    #include <string>
    #include <iostream>
    #include <windows.h> // For system("pause")
    using namespace std;
    
    int main()
    {
        vector<string> msg{"Hello", "C++", "World", "from", "VS Code", "and the C++ extension!"};
        int i=0;
        for (const string &word : msg)
        {
            ++i;
            cout << word  << " ";
        }
        cout << endl;
        cout << "中文会乱码吗?"<<endl;
    }
    ```

  - ```bash
    PS[BAT:79%][MEM:46.74% (14.82/31.70)GB][22:08:42]
    # [C:\repos\C_CPP_ConsoleApps]
     gcc c:\repos\C_CPP_ConsoleApps\cpp\helloworld.cpp -o demo.exe -lstdc++ -finput-charset=UTF-8 -fexec-charset=gbk
    #或者  g++ .\helloworld.cpp -o demo.exe -finput-charset=UTF-8 -fexec-charset=gbk
    
    PS[BAT:79%][MEM:46.79% (14.83/31.70)GB][22:08:53]
    # [C:\repos\C_CPP_ConsoleApps]
     .\demo.exe
    Hello C++ World from VS Code and the C++ extension!
    中文会乱码吗?
    ```

    

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





