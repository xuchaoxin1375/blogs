[toc]



## 环境搭建  🎈

### php用途

[PHP: 安装前需要考虑的事项 - Manual](https://www.php.net/manual/zh/install.general.php)

安装前，首先需要知道想用 PHP 来做什么。PHP 主要用在两个领域，分别在 [PHP 能做什么](https://www.php.net/manual/zh/introduction.php#intro-whatcando) 一节中进行了描述：

- 网站和 web 应用程序（服务器端脚本）,这是主要的应用场景
- 命令行脚本(相对小众的应用场景,其他语言例如python和shell语言在脚本方面更受欢迎)

#### 对于web

在通常情况下，需要三样东西：PHP 自身、一个 web 服务器和一个 web 浏览器。

> 通常你已经拥有了一个 web 浏览器，并且在你使用的操作系统中，也可能已经内置了 web 服务器.

如果需要自己配置服务器和 PHP，有两个方法将 PHP 连接到服务器上。

- 对于很多服务器，PHP 均有一个直接的**模块接口**（也叫做 SAPI）。这些服务器包括 Apache、Microsoft Internet Information Server、Netscape 和 iPlanet 等服务器。
- 如果你使用的 web 服务器不支持 PHP 模块接口，还可以将其作为 CGI 或 **FastCGI** 处理器来使用。这意味着可以使用 PHP 的 CGI 可执行程序来**处理所有服务器上的 PHP 文件请求**。

#### 对于命令行脚本

如果你对 PHP 命令行脚本感兴趣（例如在离线状态下，根据传递给脚本的参数，自动生成一些图片，或处理一些文本文件），可以参考 [PHP 在命令行模式下的使用](https://www.php.net/manual/zh/features.commandline.php) 章节。在这种情况下，不再需要 web 服务器和 web 浏览器支持。

## 下载和安装 PHP

不同平台的安装方案有所不同,本文主要讨论windows平台

[PHP: Downloads](https://www.php.net/downloads.php)

- [PHP: 安装与配置 - Manual](https://www.php.net/manual/zh/install.php)

- [PHP: 手动安装预编译的二进制文件 - Manual](https://www.php.net/manual/zh/install.windows.manual.php)  

为了将php用于web,除了安装php本身,还要安装服务软件(例如apache,nginx等这类软件中的一个,尽管操作系统可能自带其他web服务器)

## windows平台上的版本选择

[PHP: Windows 系统下的安装 - Manual](https://www.php.net/manual/zh/install.windows.php)

### windows官方安装包

[PHP For Windows: Binaries and sources Releases](https://windows.php.net/download#php-8.4)

#### 通过scoop安装

另见scoop的安装和部署相关资料

如果已经有可用的scoop,则执行`scoop install php`即可自动安装和配置环境变量

对于较新的php版本,可能会让你安装vcredist2022 提供必要的运行库

#### 通过phpstudy安装

集成环境，例如phpstudy(小皮), XAMPP（包含 Apache、MySQL、PHP 和 Perl）或 WAMP/MAMP。    



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

### 命令行脚本

[PHP: 在 Windows 系统的命令行上运行 PHP - Manual](https://www.php.net/manual/zh/install.windows.commandline.php)

```php
<?php
// hello_cli.php
// 1. 在命令行输出文字
echo "==========================\n";
echo "   欢迎使用 PHP 命令行工具\n";
echo "==========================\n\n";
// 运行命令: php hello_cli.php a1 a2
print_r($argv); 
?>

```

```bash
(base) #⚡️[Administrator@CXXUDESK][~\Desktop][9:43:42] PS >
 php hello_cli.php a1 a2
==========================
   欢迎使用 PHP 命令行工具
==========================

Array
(
    [0] => hello_cli.php
    [1] => a1
    [2] => a2
)
```

#### windows上简化命令行输入(php脚本运行方式)

本节在官方文档有相关章节,并给出了注册表片段

如果该片段不生效,可以尝试如下片段

> 省略脚本的.php后缀

```powershell
# 临时生效（当前会话）
$ext=".php"
$env:PATHEXT += ";$ext"
# $new="$([Environment]::GetEnvironmentVariable('PATHEXT', 'Machine'));$ext"

# 永久生效(当前用户作用域,可以免去管理员权限,如果要设置系统级PATHEXT,就需要管理员权限)
[Environment]::SetEnvironmentVariable("PATHEXT",$env:PATHEXT , "User")
```

省略命令行`php.exe`

> 注意,这里最后一行的php.exe路径字符串(`C:\\php\\php.exe`)需要根据读者的实际情况修改!

创建reg文本文件(例如`py.reg`,右键打开方式->文本编辑器(记事本或者vscode等都可以))

```ini
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.php]
@="phpfile"
"Content Type"="application/php"

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\phpfile]
@="PHP Script"

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\phpfile\shell]
@="Open"

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\phpfile\shell\Open]
@="&Open"

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\phpfile\shell\Open\command]
@="\"C:\\php\\php.exe\" \"%1\" %*"
```

此时,还要排查以前安装过的程序是否对`.php`文件绑定了默认打开方式,可以通过在桌面创建一个`demo.php`文件,然后右键此文件->打开方式,更换到你最新绑定的php程序.

> 检查并切换.php默认打开方式的步骤可以在执行上述注册表修改之前就处理,设置完毕后,`.php`文件的图标应该显示为php的图标.

如果正确配置,则如下效果:(假设当前目录下有一个`hello_cli.php`文件)

```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][10:10:39] PS >
 ./hello_cli a1 a2
==========================
   欢迎使用 PHP 命令行工具
==========================

Array
(
    [0] => C:\Users\Administrator\Desktop\hello_cli.php
    [1] => a1
    [2] => a2
)
```

如果要把`./hello_cli`进一步省略为`hello_cli`,那么需要将.php文件所在目录添加到Path环境变量中,或者将.php文件放到已经注册到Path环境变量中的路径里.

在windows系统上设置其他语言的脚本文件的简化运行方式也是类似的手法和流程.

## php和服务器软件

为了把php用于网站,仅仅安装php是不够的.

我们可以把 PHP 比作一个**“厨师”**，而服务器软件 Apache/Nginx 就是**“服务员”**。

------

### 1. 为什么通常需要 Apache 或 Nginx？

PHP 本身虽然能处理代码，但它并不擅长直接和成千上万的网络用户“聊天”。这就是为什么我们需要 Web 服务器软件：

- **分工协作：**
  - **服务员（Apache/Nginx）：** 站在门口（监听 80/443 端口），负责接收客人的点单（HTTP 请求），处理静态资源（图片、CSS、JS），并把 PHP 订单交给厨师。
  - **厨师（PHP）：** 躲在厨房里，只负责烧菜（执行 `.php` 脚本），把烧好的菜（生成的 HTML）交给服务员端出去。
- **并发管理：** Apache 和 Nginx 能够高效地同时处理成百上千个用户的访问，而 PHP 解释器如果直接暴露在公网上，性能和安全性都难以保障。

------

### 2. 三种常见的配合方式

根据你选择的软件，PHP 与它们的“沟通方式”略有不同：

1. **Apache + `mod_php`：** 这是最经典的组合。PHP 像一个插件一样直接“装”在 Apache 里面，配置简单，适合初学者。

2. **Nginx + PHP-FPM：** 这是目前**最流行**的高性能组合。Nginx 不直接运行 PHP，而是通过一个叫 `PHP-FPM` 的独立进程来传递任务。它的速度更快，资源占用更低。

3. php内置开发服务器（例外情况）：[PHP: 内置 Web Server - Manual](https://www.php.net/manual/zh/features.commandline.webserver.php)

   如果你只是为了学习，不想安装复杂的软件，PHP 自带了一个简单的服务器。你只需要在命令行输入：

   ```bash
   php -S localhost:8000
   ```

   这样你就能在浏览器访问了。**但注意：这仅供本地测试，绝对不能用于正式网站。**

------

### 3. 它们是如何工作的？（工作流程）

当你访问一个php网站的某个链接（如 `index.php`）时，发生的步骤如下：

1. **客户端(浏览器等)**向 **Nginx/Apache** 发送请求。
2. **服务器软件**发现后缀是 `.php`，意识到自己处理不了。
3. **服务器软件**将请求转发给 **PHP 解释器**。
4. **PHP** 执行代码（可能还会去查数据库），生成 HTML 字符串。
5. **PHP** 将 HTML 传回给 **服务器软件**。
6. **服务器软件**将 HTML 返回给你的**浏览器**。

在这个过程中,php没有直接和客户端打交道,而是隔了一层服务器

------

### 4. 总结：我该选哪个？

| **场景**             | **推荐方案**                 | **理由**                     |
| -------------------- | ---------------------------- | ---------------------------- |
| **刚开始学习**       | 使用 **XAMPP** (内置 Apache) | 一键安装，配置最省心。       |
| **正式项目/上线**    | **Nginx + PHP-FPM**          | 性能最强，抗压能力出色。     |
| **临时测试一行代码** | **PHP 内置服务器**           | 快捷，无需安装任何额外软件。 |

## Server API (服务器应用程序接口)

简单来说，**SAPI** 是 PHP 与外部世界（尤其是 Web 服务器，如 Apache 或 Nginx）进行通信的“桥梁”或“翻译官”。

### 为什么需要 SAPI？

PHP 脚本本身无法直接处理 HTTP 请求，它需要一个媒介。不同的 Web 环境就像不同的国家，而 SAPI 就是 PHP 为这些环境提供的特定“翻译版本”。

### 常见的 SAPI 类型

在 Web 开发中，你最常遇到的是以下几种：

- **FPM (FastCGI Process Manager)**：
  - **最主流**。它是目前生产环境（配合 Nginx）的标配。
  - **特点**：独立进程管理，性能高，适合高并发 Web 应用。
- **Apache 2.0 Handler (mod_php)**：
  - **传统方式**。将 PHP 解释器作为 Apache 的一个模块直接嵌入。
  - **特点**：配置简单，但每个 Apache 进程都要加载 PHP，比较耗内存。
- **CLI (Command Line Interface)**：
  - **命令行模式**。你在终端运行 `php test.php` 时使用的就是这种 SAPI。
  - **特点**：没有超时限制，不处理 HTTP 报头。
- **CGI (Common Gateway Interface)**：
  - **老牌方式**。每次请求都启动一个新进程。
  - **特点**：性能较低，现在已基本被 FastCGI 取代。

| **组件**                      | **作用**                                |
| ----------------------------- | --------------------------------------- |
| **Web 服务器** (Nginx/Apache) | 接收用户的 HTTP 请求。                  |
| **SAPI 层**                   | 将 HTTP 请求数据包装成 PHP 能懂的格式。 |
| **PHP 内核**                  | 执行代码，处理业务逻辑。                |

### 如何查看你当前使用的 SAPI？

如果你想知道你的 Web 环境使用的是哪种 SAPI，只需在 PHP 脚本中执行以下代码：



```PHP
echo php_sapi_name();
```

或者运行 `php -v` 查看命令行版本。





## php和服务器的通信

进入 PHP 服务器的世界后，你会发现这不只是“一个软件”，而是一套**分工协作的生态系统**。要理解这些细分概念，我们需要拆解请求从进入服务器到代码执行的每一个环节。

以下是 PHP 领域中最关键的几个底层概念：

------

### 1. Web 服务器与 PHP 的桥梁：SAPI

**SAPI (Server Application Programming Interface)** 是 PHP 的“接口层”。它决定了 PHP 如何与外界（比如 Apache 或 Nginx）沟通。

常见的 SAPI 模式：

- **CLI (Command Line Interface)：** 你在终端输入 `php -v` 时使用的模式，不需要 Web 服务器。
- **PHP-FPM (FastCGI Process Manager)：** 现代 Web 开发的标准。
- **Module (如 Apache 的 mod_php)：** 将 PHP 直接作为服务器的一个子模块运行。

------

### 2. 进程管理的核心：PHP-FPM

如果你使用 Nginx，就必须理解 **PHP-FPM**。它是一个独立的进程管理器，负责调度 PHP 解释器。

- **Master 进程：** 像“包工头”，负责监听请求、管理 Worker 进程的开启和关闭。
- **Worker 进程：** 像“工人”，真正负责解析 PHP 代码。一个 Worker 同时只能处理一个请求。
- **动态/静态模式：** 你可以配置服务器始终保持 50 个工人（静态），或者根据忙碌程度自动增减（动态）。

------

### 3. 通讯协议：FastCGI

Nginx 和 PHP-FPM 之间是如何对话的？它们说的是 **FastCGI** 协议。

- **CGI (Common Gateway Interface)：** 老前辈。每来一个请求就开启一个进程，处理完就杀掉。效率极低。
- **FastCGI：** 进化版。进程启动后不销毁，而是反复重复使用，极大地提高了性能。

------

### 4. 关键配置：php.ini vs php-fpm.conf

你会发现 PHP 有多个配置文件，它们管辖的范围不同：

| **配置文件**     | **作用范围**     | **典型例子**                                          |
| ---------------- | ---------------- | ----------------------------------------------------- |
| **php.ini**      | **代码逻辑配置** | 内存限制 (`memory_limit`)、上传大小、错误报告、时区。 |
| **php-fpm.conf** | **运行进程配置** | 监听哪个端口、开启多少个子进程、超时时间。            |

------

### 5. 加速：OPcache

PHP 是一种解释型语言，默认情况下，每次请求都要把代码重新“翻译”一遍，这很浪费。

- **OPcache** 是 PHP 内置的缓存机制。
- 它将 PHP 代码翻译后的**字节码 (Opcode)** 存储在内存中。下一次请求时，直接运行内存里的机器码，速度提升通常在 **3-10 倍**以上。

------

### 6. 扩展 (Extensions)

PHP 本身功能有限，很多高级功能是靠“外挂”实现的：

- **Core Extensions：** 自带的，如 `mysqli`（连数据库）、`json`、`curl`。
- **PECL：** 官方扩展库，比如 `Redis`、`Swoole`。通常需要通过 `pecl install` 命令单独安装并编译。

------

### 总结

一个典型的现代 PHP 请求路径是：

**用户浏览器** → (HTTP协议) → **Nginx** → (FastCGI协议) → **PHP-FPM (Master → Worker)** → **PHP 解释器 (加载 OPcache)** → **执行结果返回**。

## 配置php web编程环境🎈

可以使用 Visual Studio Code、PHPStorm 等编辑器，它们支持语法高亮、调试插件等功能。  

本节介绍vscode方案

### vscode+php

插件:

- [Live Server - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer)
- 配合浏览器插件辅助实现实时预览php修改结果
  - 此插件还有另一个分支的插件,支持php热更新,但是有局限性(依赖于`.php`文件具有较完整的html结构,否则渲染会出问题,表现出更新迟缓甚至空白!)[Five Server- Visual Studio Marketplace --- Live Server (Five Server) - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=yandeu.five-server)

- [PHP Server - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=brapifra.phpserver)
  - vscode有php server插件,可以充当服务器的角色,并且支持切换不同的php版本
  - 使用`php server:open`指令或者右键找到预览指令查看php运行结果

- [Open I - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=Kingleo.openurl)
  - vscode中打开预览指定url链接,而不用跳转到外部浏览器

### php代码片段|代码模板🎈

- [PHP Awesome Snippets - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=hakcorp.php-awesome-snippets)

  - 提供了几种php标签的简写代码片段,通过tab/回车键接受片段展开(更多详见文档🎈)

  - **php tags**

    | Snippet | Note                   | Output        |
    | :------ | ---------------------- | :------------ |
    | php     | php tag (complete)     | `<?php ...?>` |
    | po      | php tag **open** only  | `<?php...`    |
    | pc      | php tag **close** only | `?>`          |
    | peco    | php **echo** shorthand | `<?= ... ?>`  |

  - 当然这个插件还有在php tags内部的代码片段

- [PHP Snippets from PHPStorm - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=phiter.phpstorm-snippets)

  - 这个插件主要在`<?php ?>`内部编写php代码时使用


## php和opcache

OPcache 是 PHP 的**字节码缓存**扩展，用于提升 PHP 性能。

- 【无 OPcache】每次请求都要重复编译 : `.php`文件 → 词法分析 → 语法分析 → 编译 → 字节码 → 执行 → 输出 
- 【有 OPcache】编译一次，多次使用 : `.php`文件 → 词法分析 → 语法分析 → 编译 → 字节码 → 缓存到内存,执行→输出,后续请求直接从内存读取字节码执行(但是对于频繁改动php源码的情况要小心,需要检测文件变动适时重新编译字节码,可以修改php设置)



### OPcache 配置详解

查看当前配置(windows为例)

```bash
php -i | findstr opcache
```

查看配置文件路径以及相关文件中配置项位置.

```powershell
(base) #⚡️[Administrator@CXXUDESK][C:\repos\phpStarter][16:48:27]{Git:main} PS >
 php --ini
Configuration File (php.ini) Path: C:\WINDOWS
Loaded Configuration File:         C:\phpstudy_pro\Extensions\php\php7.4.3nts\php.ini
Scan for additional .ini files in: (none)
Additional .ini files parsed:      (none)

(base) #⚡️[Administrator@CXXUDESK][C:\repos\phpStarter][16:49:17]{Git:main} PS >
 sls 'opcache.revalidate_freq' C:\phpstudy_pro\Extensions\php\php7.4.3nts\php.ini

C:\phpstudy_pro\Extensions\php\php7.4.3nts\php.ini:1799:opcache.revalidate_freq=0
C:\phpstudy_pro\Extensions\php\php7.4.3nts\php.ini:1918:opcache.revalidate_freq=60
```

> 如果发现配置文件中有多处位置出现了同一个配置项,则要小心,最后一个配置项会覆盖前面的.

常用配置项 (php.ini)

```ini
[opcache]
; 启用/禁用 OPcache
opcache.enable=1
opcache.enable_cli=0          ; CLI 模式下是否启用

; 内存配置
opcache.memory_consumption=128      ; 缓存大小 (MB)
opcache.max_accelerated_files=10000 ; 最大缓存文件数

; 缓存验证（关键配置！）
opcache.validate_timestamps=1       ; 是否检查文件修改
opcache.revalidate_freq=2           ; 检查频率（秒）,如果设置为0表示始终检查

; 性能优化
opcache.save_comments=1             ; 保留注释（框架需要）
opcache.fast_shutdown=1             ; 快速关闭
```

---

修改完配置一定要运行`php -i`配合过滤工具查看相关项目是否发生了更改.

### 配置:开发环境 vs 生产环境

#### 开发环境配置

```ini
; 开发环境 - 每次都检查文件变化
opcache.enable=1
opcache.validate_timestamps=1
opcache.revalidate_freq=0          ; 每次请求都检查
```

或者在命令行中提供选项直接禁用：
```bash
php -S localhost:5001 -d opcache.enable=0
```

#### 生产环境配置

```ini
; 生产环境 - 最大性能
opcache.enable=1
opcache.validate_timestamps=0      ; 不检查文件变化（重要！）
opcache.memory_consumption=256
opcache.max_accelerated_files=20000
opcache.interned_strings_buffer=16
```

---

###  OPcache 下的问题和措施

1. 修改代码不生效

```php
// 问题：生产环境 validate_timestamps=0 时
// 修改代码后必须手动清除缓存

// 解决方案：
<?php
opcache_reset();  // 清除所有缓存

// 或清除单个文件
opcache_invalidate('/path/to/file.php', true);
```

2. 部署时缓存问题

```bash
# 部署脚本中添加
php -r "opcache_reset();"

# 或重启 PHP-FPM
sudo systemctl restart php-fpm
```

3. 内存不足

```
PHP Warning: opcache.memory_consumption is too low
```

解决：增加 `opcache.memory_consumption` 值

---

### 监控 OPcache 状态

命令行查看

```php
<?php
// opcache_status.php
$status = opcache_get_status();
print_r([
    '内存使用' => round($status['memory_usage']['used_memory'] / 1024 / 1024, 2) . ' MB',
    '命中率' => round($status['opcache_statistics']['hits'] / 
               ($status['opcache_statistics']['hits'] + $status['opcache_statistics']['misses']) * 100, 2) . '%',
    '缓存文件数' => $status['opcache_statistics']['num_cached_scripts'],
]);
```

可视化工具

推荐使用 [opcache-gui](https://github.com/amnuts/opcache-gui)：

```bash
# 下载单文件版本放到项目中
wget https://raw.githubusercontent.com/amnuts/opcache-gui/master/index.php -O opcache-gui.php
```

---

🔄 OPcache 与其他缓存对比

```
┌──────────────────┬─────────────────────────────────────┐
│     缓存类型      │              作用                   │
├──────────────────┼─────────────────────────────────────┤
│ OPcache          │ 缓存 PHP 编译后的字节码              │
│ APCu             │ 缓存用户数据（变量、对象）            │
│ Redis/Memcached  │ 分布式缓存（Session、数据）          │
│ 浏览器缓存        │ 缓存静态资源（CSS、JS、图片）        │
└──────────────────┴─────────────────────────────────────┘
```

### php缓存配置最佳实践总结

| 环境     | 建议配置                                                    |
| -------- | ----------------------------------------------------------- |
| **开发** | `opcache.enable=0` 或 `revalidate_freq=0`                   |
| **测试** | `opcache.enable=1` + `validate_timestamps=1`                |
| **生产** | `opcache.enable=1` + `validate_timestamps=0` + 部署时清缓存 |

```bash
# 开发环境启动命令
php -S localhost:5001 -d opcache.enable=0 -d display_errors=1
```



--------------------------------------------------

## php页面预览

下面这些方案各有优缺点.

方案0依赖最少,其他方案都是带自动重载php页面.

其他方案自动重载,但是如果文件变更过大或者某次变更导致语法错误,可能会导致自动重载失效,这时候可能要重启插件(php服务)

### 方案0

不依赖插件,仅靠php内置服务器(注意端口的指定和opcache的配置)

例如:

```php
 php -S localhost:5001 -d opcache.enable=0 -d display_errors=1
```

这样可以按照web的方式使用php,但是php文件发生更改后需要手动刷新页面.

### 方案1

借助单个支持自动重载的vscode插件,例如:(都可以通过command palette启动php server)

- [PHP-enabled Live Local Server - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=t-myk.php-enabled-live-local-server)
- [PHP Built In Server - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=davidfreer.php-built-in-server)

这个插件调用php内置服务器,不同的是提供了源码变更后自动重载的效果,并且此方案不强制要求包含特定的html标签

但是一定要注意`opcache`的问题,开发/学习阶段建议停用此功能,并且通过`php -i`检查是否配置生效.

尤其是`opcache.revalidate_freq`设置为0,如果开发阶段启用`opcache`的话

示例代码

```php
<?php

echo "Hello World!\n";
$v = 100;
echo "</br>";
echo "\n";

?>

```



### 方案2

[Five Server|Live Server (Five Server) - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=yandeu.five-server)

使用five server插件,好处是安装的插件就这一个

> 缺点是对`.php`文件中的html代码结构完整性有要求.否则可能出现渲染错误或一片空白,对源代码文件的更新没有正确反应到渲染结果上.
>
> 例如,five server 终端(terminal)提示:`does not contain required HTML tags.`
>
> ```bash
>   Five Server running at:
>   > Network:  http://192.168.1.9:5500
>   > Local:    http://localhost:5500
>   > Network:  http://....1:5500
> 09:23:32 File: c:\repos\phpStarter\index.php does not contain required HTML tags.
> 09:23:35 File: c:\repos\phpStarter\index.php does not contain required HTML tags. (x2)
> 09:23:36 [Five Server] change detected index.php
> 
> ```

而正常情况(支持自动重载的情况)提示类似于;

> ```bash
>   Five Server running at:
>   > Network:  http://192.168.1.9:5500
>   > Local:    http://localhost:5500
>   > Network:  http://...:5500
> 09:25:14 [Five Server] change detected hello.php (x6)
> 09:25:16 [Five Server] change detected hello.php (x7)
> 
> ```
>
> 

大多数**高级功能**默认情况下处于禁用状态。
可以在设置中启用它们，也可以在工作区根目录中配置 `fiveserver.config.js` 文件来启用它们。

笔记：

- **即时更新**和**高亮**功能适用于 `.html` 和 `.php` 文件。
- 所有远程日志都将在名为“Five Server”的新终端中显示。
- 功能 `highlight` ， `injectBody` 和 `remoteLogs` 默认处于禁用状态。
- 要使用 `highlight` 功能，必须先激活 `injectBody` 。
- `injectBody` 会执行一些简单的 HTML 验证。使用 `injectBody` 时，如果您的 HTML 页面无效，则会显示一条消息。
- 要暂时禁用单个 HTML 标签的 `highlight` ，请添加 **H。**
  示例： `<div H>Don't highlight me</div>`

> 插件提供了视频教程
>
> 虽然 Five Server 可以渲染、显示和实时重载 PHP 代码，但它并不提供完整的 PHP 服务器功能。如果您想开发大型 PHP 应用，则需要手动将客户端 Five Server 脚本与您的 PHP 文件链接起来。请参阅 [five-server-with-php](https://github.com/yandeu/five-server-with-php) 。

下面到片段示例是可以自动更新的,html文档内嵌的php代码位于`body`标签中.

```php
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <style>

        h1 { color: #4F46E5; }
        .time { color: #6B7280; font-size: 1.2rem; }
    </style>
</head>
<body>
    <div class="card">
        <h1>PHP 自动刷新测试(five server)</h1>
        <p class="time">
            <?php 
                // 每次刷新页面，这里的时间都会更新
                echo "当前服务器时间: " . date("H:i:s"); 
            ?>
        </p>
        <p>试着修改这段文字并保存，看浏览器是否自动变动。</p>
    </div>
</body>
</html>
```



### 方案3(过时方案)

这里会用到浏览器插件

- 需要区分包含php的服务器(地址)和liveServer预览服务器(地址)

  - 例如本地localhost的3000端口运行php网站,而在5500端口运行自动更新php页面更改的服务
- 这个构成php实时预览开发环境的服务器组件可以都用vscode插件实现:

  1. php server:[PHP in Visual Studio Code](https://code.visualstudio.com/docs/languages/php)
     - vscode中`php server`端口配置入口id:`phpserver.port`(默认一般是3000端口)
     - 启动php server服务:通过command palette,输入`php server:reload server`
     - 遇到bug无法自动刷新,也可以考虑重启php server
  2. live server
     - vscode中live server端口配置入口id:`liveServer.settings.port`(跳转到json配置文件中编辑,或者右下角的Port:xxxx(一般是5500),如果发生修改,需要重启live server才能生效新端口)
- live server只是提供一个实时预览的支持,我们要在vscode的live server 插件配置中启用`use web ext`选项

  - 打开vscode设置,搜索设置项的id:`liveServer.settings.useWebExt`或者url:

    ```INI
    vscode://settings/liveServer.settings.useWebExt
    ```

#### 浏览器插件下载

- [GitHub - ritwickdey/live-server-web-extension: It makes your existing server live. This is a browser extension that helps you to live reload feature for dynamic content (PHP, Node.js, ASP.NET -- Whatever, it doesn't matter)](https://github.com/ritwickdey/live-server-web-extension#setup)
  - edge/chrome[Live Server Web Extension - Chrome Web Store](https://chromewebstore.google.com/detail/live-server-web-extension/fiegdmejfepffgpnejdinekhfieaogmj)
  - [Live Server Web Extension – Get this Extension for 🦊 Firefox (en-US)](https://addons.mozilla.org/en-US/firefox/addon/live-server-web-extension/)
- ![在这里插入图片描述](https://i-blog.csdnimg.cn/direct/fb968df9daa841d68df3dc613684fdcb.png)

#### 实时预览动态演示图

![自动热重载php代码](https://i-blog.csdnimg.cn/direct/bb4c6509e6d144babe23cd46694d8c40.gif)

