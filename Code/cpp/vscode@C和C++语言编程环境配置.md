[toc]



## abstract

- vscode+cpp官方文档教程:
  - [C++ programming with Visual Studio Code](https://code.visualstudio.com/docs/languages/cpp)
    - 这个页面是vscode配置c++环境的首页,指导如何准备编译器以及编译第一个程序
    - 然后给出许多不同编译器下的跟进一步的和更完整的首次配置教程
    - 包括`.vscode`中的相关文件介绍
      - 对于轻量环境,选择GCC编译器是好主意,可以参考以下文档
      - [Get Started with C++ and MinGW-w64 in Visual Studio Code](https://code.visualstudio.com/docs/cpp/config-mingw#_debug-helloworldcpp)
- 图方便开箱即用的话可以用Dev C++:[Dev-C++ Overview - Free Tools - Embarcadero](https://www.embarcadero.com/cn/free-tools/dev-cpp)

## 目录.vscode中的相关文件

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





