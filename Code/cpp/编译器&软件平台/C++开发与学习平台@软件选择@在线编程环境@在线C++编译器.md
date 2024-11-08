[toc]

## abstract

- 盘点常见的C/C++开发工具
- 向初学者推荐的C/C++开发工具

## 集成编译器的C/C++开发工具(开箱即用)

1. **Microsoft Visual Studio with MSVC**:
   - [Visual Studio: IDE and Code Editor for Software Developers and Teams (microsoft.com)](https://visualstudio.microsoft.com/)
   - 虽然MSVC主要用于Windows平台，但随着近年来的发展，已经具备了跨平台编译能力，可以构建Linux和iOS应用。
   - 特点：商业级IDE，提供了丰富的调试和开发工具，对于Windows原生开发支持完善。

2. **Code::Blocks**
   - [Code::Blocks - Code::Blocks (codeblocks.org)](https://www.codeblocks.org/)
   - Code::Blocks 是一款轻量级、开源的C++ IDE，内置了GCC或Clang编译器支持，可在多种平台上运行。
   - 特点：简单易用，适合初学者快速上手，具有代码高亮、自动补全、调试等功能。

3. **Eclipse CDT**:
   - [Eclipse CDT (C/C++ Development Tooling) | projects.eclipse.org](https://projects.eclipse.org/projects/tools.cdt)
   - Eclipse CDT 包含了一个基于GCC或Clang的C++编译器，通过插件形式实现了跨平台IDE的功能。
   - 特点：开源免费，强大的代码编辑和项目管理工具，适用于多平台开发。

4. 小熊猫C++

   - [小熊猫C++ | 小熊猫C++ (royqh.net)](http://royqh.net/redpandacpp/docsy/docs/)

   - [下载 (royqh.net)](http://royqh.net/redpandacpp/download/)
   - 小熊猫编译器选择比较灵活,如果您本地已经配置好了编译器,比如MinGW或MSYS2,那么小熊猫会自己扫描,可能就不需要配置了;这种情况下,软件大小减少至10MB左右
   - 或者直接下载集成了编译器的版本
   - 即可选择安装版,也可以选择免安装版本
   - 软件界面也比较清晰,是现代化的界面,风格和Dev C++类似
5. DEV C++ 老牌C++运行环境
   - [Home - Dev-C++ Official Website (bloodshed.net)](https://www.bloodshed.net/)
     - 软件不更新很长一段时间了,普通用途不建议继续使用Dev C++
     - 文档:[Additional Resources - Dev-C++ Official Website (bloodshed.net)](https://www.bloodshed.net/Additional-Resources)
   - [Dev-C++ download | SourceForge.net](https://sourceforge.net/projects/orwelldevcpp/)

6. DEV C++的改进分支版本
   -  [Dev-C++ Overview - Free Tools - Embarcadero](https://www.embarcadero.com/cn/free-tools/dev-cpp)

7. vim/emacs/gedit+gcc+gdb:
   - 纯命令行或者UI简陋的编辑器开发组合,完全免费,占用最少的资源,对计算机的配置要求很低,但是仍然可以完成复杂的编码任务,只是对于初学者不太友好;gcc，gdb命令行用法值得学一下


## 学习平台选择推荐👺

### 初学者平台和软件选择

- 对于初学者,推荐用图形界面系统,可以用windows系统(windows10,11个人用户激不激活都能用,只是个性化方面受限,只是windows7老古董会黑屏,但是基本淘汰了)，可以分情况入手

#### 开箱即用的C/C++运行环境

- 最容易入手的Dev C++家族的软件入手,比如小熊猫C++,Embarcadero C++,或者DEV C++本身
- 其次可以选择Code::Blocks或者Microsoft Visual Studio Community版开始,都有友好的用户界面和丰富的教程资源，非常适合学习C++基本语法和概念。

#### 需要稍微配置的环境

- 如果愿意稍微配置一下,那么使用vscode+C/C++ extension 也是很好的选择,可以搜索带有配置文件的相关的仓库,下载下来,几乎就是开箱即用的程度,又有丰富的插件生态,可以用得非常舒服,但是对于大项目来说,还是要用更专业的工具
- 使用CLion的用户也有不少,这个软件比较占用资源

## 在线运行环境👺

- [ Installing an Integrated Development Environment (IDE) – Learn C++ (learncpp.com)](https://www.learncpp.com/cpp-tutorial/installing-an-integrated-development-environment-ide/)	
  - 这里提到了几款在线编译运行环境
  - 实际上在线编译运行环境有很多,但是终归比较受限,所以还是有必要配置本地开发环境


### 普通在线运行环境

- Q: Can I use a web-based compiler?

  Yes, for some things. While your IDE is downloading (or if you’re not sure you want to commit to installing one yet), you can continue this tutorial using a web-based compiler. 

- We recommend one of the following:

  - [TutorialsPoint](https://www.tutorialspoint.com/compile_cpp_online.php)
  - [Wandbox](https://wandbox.org/) (can choose different versions of GCC or Clang)
  - [Godbolt](https://godbolt.org/) (can see assembly)

  Web-based compilers are fine for dabbling and simple exercises. However, they are generally quite limited in functionality -- many won’t allow you to create multiple files or effectively debug your programs, and most don’t support interactive input. You’ll want to migrate to a full IDE when you can.

### 支持代码补全的在线运行环境👺

有一些在线编程环境支持 C++ 代码补全功能，以下是几个推荐的选项：

| **平台**      | **特点**                                                   | **网址**                               |
| ------------- | ---------------------------------------------------------- | -------------------------------------- |
| **OnlineGDB** | 提供在线编译器和调试器，支持代码补全和运行                 | [OnlineGDB](https://www.onlinegdb.com) |
| **Paiza.IO**  | 提供支持多语言的在线编程环境，包括 C++，支持代码补全和运行 | [Paiza.IO](https://paiza.io)           |

这些平台不仅支持 C++ 的代码补全，还提供了运行和调试功能，适合在线编程和学习。你可以根据自己的需求选择合适的平台。

[(C++) | Online editor and compiler (paiza.io)](https://paiza.io/projects/g1amGrjR_S0_o2rIMym-Mw?language=cpp)



### 其他情形

#### 有经验的用户

- 如果偏好命令行工具和开源环境，可以选择GCC或Clang，并搭配简单的文本编辑器（如Vim、Emacs或VS Code等），这样可以更专注于语言本身的学习。
- 用C++学习一些简单编程和算法,可以不用太纠结平台的选择,习惯用那个系统就用那个系统
- 但是到了开发特定软件阶段或者系统编程,那么平台的选择就需要考虑
- 不过即便是linux系统编程,也可以用`vscode`之类的编辑器利用ssh链接,这样,哪怕没有安装图形界面的linux也可以用图形界面的IDE或编辑器编写代码,获得智能补全,错误提示等插件带来的便利

#### 工程级@重量级IDE

对于工程级别的专业的C++编程,可以考虑重量级的IDE,比如Clion,Visual Stuido

- [CLion: A Cross-Platform IDE for C and C++ by JetBrains](https://www.jetbrains.com/clion/) 跨平台
- [Visual Studio: IDE and Code Editor for Software Developers and Teams (microsoft.com)](https://visualstudio.microsoft.com/) 主要适用于windows

### 小结👺

- 对于初级阶段的C++学习或者单纯的算法学习,推荐图形化方案的跨平台和轻量的编程环境
- 纯粹编码推荐开箱即用适合国人的**小熊猫C++**,其他开箱即用的也可以
- 扩展性强的轻量级推荐vscode配合C++插件拓展,里面的AI插件可以提供不少帮助;编译器可以任意选择可用的就行
- 也可以一步到位,使用重量级IDE

## AI辅助

### 开发工具代码补全和AI代码片段生成补全

- 人工智能时代,您的现代IDE可以安装各种各样的人工智能代码插件,帮助您学习代码编写,提高输入效率,提高代码的规范性和乐趣
- 相关插件数量和种类繁多,国内外都有,免费和收费的都有,补全效果也各不相同



## vscode c/c++开发环境配置

- 配置实践参考[Vscode配置C/C++编程环境@配置C和CPP的运行和调试环境@配置过程的相关问题@中文文件名乱码@build和debug方案组合配置-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/138172679?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"138172679"%2C"source"%3A"xuchaoxin1375"})
- 上述链接经过实践提炼,即便对vscode比较陌生,也可以快速配置完毕(需要自行下载安装好编译器)

