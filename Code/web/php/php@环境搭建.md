[toc]



## 环境搭建  🎈

### 下载和安装 PHP

[PHP: Downloads](https://www.php.net/downloads.php)

- [PHP: 安装与配置 - Manual](https://www.php.net/manual/zh/install.php)

- [PHP: 手动安装预编译的二进制文件 - Manual](https://www.php.net/manual/zh/install.windows.manual.php)  




### 其他方式

### windows官方安装包

[PHP For Windows: Binaries and sources Releases](https://windows.php.net/download#php-8.4)

#### windows平台 通过scoop安装

另见scoop的安装和部署相关资料

如果已经有可用的scoop,则执行`scoop install php`即可自动安装和配置环境变量

对于较新的php版本,可能会让你安装vcredist2022 提供必要的运行库

#### 通过phpstudy安装

集成环境，例如phpstudy(小皮), XAMPP（包含 Apache、MySQL、PHP 和 Perl）或 WAMP/MAMP。    

## windows平台上的版本选择

### Which version do I choose? 我该选择哪个版本？

不同的服务器有不同的推荐选择

#### IIS

If you are using PHP as FastCGI with IIS you should use the Non-Thread Safe (NTS) versions of PHP.
如果您使用 IIS 作为 FastCGI 的 PHP，您应该使用非线程安全 (NTS) 版本的 PHP。

#### Apache

Please use the Apache builds provided by [Apache Lounge](http://apachelounge.com/). They provide VC15 and VS16 builds of Apache for x86 and x64. We use their binaries to build the Apache SAPIs.
请使用 Apache Lounge 提供的 Apache 构建。他们为 x86 和 x64 提供了 Apache 的 VC15 和 VS16 构建。我们使用他们的二进制文件来构建 Apache SAPIs。

With Apache, using the apache2handler SAPI, you have to use the Thread Safe (TS) versions of PHP.
使用 Apache 和 apache2handler SAPI 时，必须使用 PHP 的线程安全（TS）版本。

#### VS16 & VS17

More recent versions of PHP are built with VS16 or VS17 (Visual Studio 2019 or 2022 compiler respectively) and include improvements in performance and stability.
更新的 PHP 版本使用 VS16 或 VS17（分别对应 Visual Studio 2019 或 2022 编译器）编译，并包含性能和稳定性的改进。

\- The VS16 and VS17 builds require to have the *Visual C++ Redistributable for Visual Studio 2015-2022* [x64](https://aka.ms/vs/17/release/vc_redist.x64.exe) or [x86](https://aka.ms/vs/17/release/vc_redist.x86.exe) installed
\- VS16 和 VS17 版本需要安装 Visual Studio 2015-2022 的 Visual C++ 运行库 x64 或 x86 版本

#### TS and NTS

**TS** refers to multithread capable builds. **NTS** refers to single thread only builds. Use case for **TS** binaries involves interaction with a multithreaded **SAPI** and PHP loaded as a module into a web server. For **NTS** binaries the widespread use case is interaction with a web server through the FastCGI protocol, utilizing no multithreading (but also for example CLI).
TS 指的是支持多线程的构建。NTS 指的是仅支持单线程的构建(适合多进程而非多线程)。

TS 二进制文件的用例涉及与多线程 SAPI 交互，以及将 PHP 作为模块加载到 Web 服务器中。

对于 NTS 二进制文件，广泛的使用案例是通过 FastCGI 协议与 Web 服务器交互，不使用多线程（例如 CLI）。

[PHP 扩展：TS 与 NTS 版本的选择-百度开发者中心](https://developer.baidu.com/article/details/3301235)

## 配置php编程环境  

- 可以使用 Visual Studio Code、PHPStorm 等编辑器，它们支持语法高亮、调试插件等功能。  

### vscode+php

#### 预览

- [PHP Server - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=brapifra.phpserver)

  - vscode有php server插件,可以充当服务器的角色,并且支持切换不同的php版本
  - 使用`php server:open`指令或者右键找到预览指令查看php运行结果

- [Live Server - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer)

  - 配合浏览器插件辅助实现实时预览php修改结果

- [Open I - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=Kingleo.openurl)
  - vscode中打开预览指定url链接,而不用跳转到外部浏览器

### 代码片段|代码模板🎈

- [PHP Awesome Snippets - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=hakcorp.php-awesome-snippets)

  - 提供了几种php标签的简写代码片段,通过tab/回车键接受片段展开(更多详见文档🎈)

  - **php tags**

    | Snippet | Note               | Output        |
    | :------ | ------------------ | :------------ |
    | php     | php tag (complete) | `<?php ...?>` |
    | po      | php tag open only  | `<?php...`    |
    | pc      | php tag close only | `?>`          |
    | peco    | php echo shorthand | `<?= ... ?>`  |

  - 当然这个插件还有在php tags内部的代码片段

- [PHP Snippets from PHPStorm - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=phiter.phpstorm-snippets)

  - 这个插件主要在`<?php ?>`内部编写php代码时使用

  

--------------------------------------------------

### php+web实时预览

- [Vscode实现PHP在浏览器实时预览_live server web extension-CSDN博客](https://blog.csdn.net/m0_66441341/article/details/125129775)
  
  - 这里会用到浏览器插件
  - 需要区分包含php的服务器(地址)和liveServer预览服务器(地址)
  - 这个构成php实时预览开发环境的服务器可以都用vscode插件实现:
  
    1. php server
       - vscode中php server端口配置入口id:`phpserver.port`(默认一般是3000端口)
       - 启动服务:通过command palette,输入`php server:reload server`
       - 遇到bug无法自动刷新,也可以考虑重启php server
    2. live server
       - vscode中live server端口配置入口id:`liveServer.settings.port`(跳转到json配置文件中编辑,或者右下角的Port:xxxx(一般是5500),如果发生修改,需要重启live server才能生效新端口)
  - live server只是提供一个实时预览的支持,我们要在vscode的live server 插件配置中启用`use web ext`选项
  
    - 打开vscode设置,搜索设置项的id:`liveServer.settings.useWebExt`或者url:
  
      ```INI
      vscode://settings/liveServer.settings.useWebExt
      ```
  
- 浏览器插件下载
  - [GitHub - ritwickdey/live-server-web-extension: It makes your existing server live. This is a browser extension that helps you to live reload feature for dynamic content (PHP, Node.js, ASP.NET -- Whatever, it doesn't matter)](https://github.com/ritwickdey/live-server-web-extension#setup)
    - edge/chrome[Live Server Web Extension - Chrome Web Store](https://chromewebstore.google.com/detail/live-server-web-extension/fiegdmejfepffgpnejdinekhfieaogmj)
    - [Live Server Web Extension – Get this Extension for 🦊 Firefox (en-US)](https://addons.mozilla.org/en-US/firefox/addon/live-server-web-extension/)
  - ![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/fb968df9daa841d68df3dc613684fdcb.png)

### 实时预览动态演示图

![](assets/live-server-web-extension.gif)

