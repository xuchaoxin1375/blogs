[toc]



## 多语言交互式C#运行环境

初步学习C#后,看到`Console.Write`这种类似于`javaScript`中的`Console.log`,容易想到是否也有类似的交互式编程环境

查阅资料发现,Vscode中可以使用Microsoft Vscode提供的相关插件实现交互式运行C#或其他.Net语言的环境

- [Polyglot Programming with Notebooks in Visual Studio Code](https://code.visualstudio.com/docs/languages/polyglot)
- [Polyglot Notebooks - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.dotnet-interactive-vscode)

这个交互式环境功能比较丰富,可以满足初学者学习C#的语法需要,而且不需要建立C#工程项目就可以直接运行代码

事实上,这个插件支持多种语言代码片段的运行,远不止C#这种语言,通过选择不同的kernel,比如选择.Net kernal,就可以运行.net 平台的编程语言

### 应用

许多优秀的教程以notebook的形式呈现,也便于读者学习和实验代码

[GitHub - dotnet/csharp-notebooks: Get started learning C# with C# notebooks powered by .NET Interactive and VS Code.](https://github.com/dotnet/csharp-notebooks)

### 关于插件的安装和环境启动

- 这个插件不像一般的vscode插件那样简单,依赖于.Net Sdk而且启动(初次启动)会安装`.Net Interactive`;
- 除了注意.Net Sdk版本,建议安装完插件后彻底关闭vscode,然后重新打开vscode,否则插件可能不会正常工作

### 功能异常或bug

如果某些时候ployglot notebook中的某些功能不可用(可能依托于.ipynb),比如某个查看变量按钮结果为空白等异常,可以尝试彻底关闭vscode,然后重新启动vscode