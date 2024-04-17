[toc]

## abstract

- linux@命令行助手@Man手册补充工具@tldr@example



## 解释给定的命令行

- [explainshell.com - match command-line arguments to their help text](https://explainshell.com/)



## 命令行工具用法相关项目

- [tldr-pages/tldr: 📚 Collaborative cheatsheets for console commands (github.com)](https://github.com/tldr-pages/tldr)
- [Command Line Interface Pages](https://github.com/command-line-interface-pages) allows you to write standardized help pages for CLI, directories and configs.
- [Cheat](https://github.com/cheat/cheat) allows you to create and view interactive cheatsheets on the command-line. It was designed to help remind *nix system administrators of options for commands that they use frequently, but not frequently enough to remember.
- [cheat.sh](https://cheat.sh/) Aggregates cheat sheets from multiple sources (including tldr-pages) into 1 unified interface.
- [devhints](https://devhints.io/) Rico's cheatsheets are not just focused on the command-line and include a plethora of other cheatsheets related to programming.
- [eg](https://github.com/srsudar/eg) provides detailed examples with explanations on the command-line. Examples come from the repository, but `eg` supports displaying custom examples and commands alongside the defaults.
- [kb](https://github.com/gnebbia/kb) is a minimalist command-line knowledge base manager. kb can be used to organize your notes and cheatsheets in a minimalist and clean way. It also supports non-text files.
- [navi](https://github.com/denisidoro/navi) is an interactive cheatsheet tool, which allows you to browse through specific examples or complete commands on the fly.
- [bropages (deprecated)](http://bropages.org/) are a highly readable supplement to man pages. It shows concise, common-case examples for Unix commands. The examples are submitted by the user base, and can be voted up or down; the best entries are what people see first when they look up a command.

tldr及其相关项目简介

- tldr是一个社区共建的项目，为命令行工具提供了简化的、实用的使用示例。不同于详尽复杂的man手册，它主要展示简洁且实际的操作案例，方便用户快速查阅和理解命令行工具的基本用法。

其他相关项目：

1. Command Line Interface Pages（CLI Pages）：允许用户为命令行工具、目录和配置文件编写标准化的帮助文档。
2. Cheat：设计用于帮助*nix系统管理员创建和查看命令行交互式速查表，以便在不频繁使用某些命令时能快速回忆起其选项。
3. cheat.sh：整合了包括tldr在内的多个来源的速查表数据，提供统一的查询接口。
4. devhints（Rico的速查表）：不仅关注命令行工具，还涵盖了大量与编程相关的其他速查表。
5. eg：在命令行中提供带有详细解释的例子，例子来源于仓库，并支持显示自定义的例子和命令。
6. kb：是一款极简主义的命令行知识库管理工具，可用于组织你的笔记和速查表，支持非文本文件类型。
7. navi：是一款交互式的速查表工具，可让用户即时浏览特定实例或完整命令。
8. bropages（已废弃）：是man手册的一个补充，提供Unix命令的简洁、常见使用场景示例。这些示例由用户提交并可以投票进行排序，最受欢迎的条目会优先展示给查询该命令的用户。





## tldr

### 在线版tldr(推荐)😊

- 连接来自于tldr项目文档[tldr InBrowser.App](https://tldr.inbrowser.app/)

  - 系统有浏览器的话,就可以打开,浏览体验比命令行内的要好
  - 免安装(需要联网)

  

### 离线版

- github release下载离线手册
- 建议下载en版,比较全(zh中文版不全)
  - 可以是zip,里面是markdown文件
  - 也可以是pdf文件
- 最大的文件是包含了所有语言的版本,没有必要下载

### 命令行版

- 安装可以参考文档
- 容易遇到报错,不太稳定

## eg

- [srsudar/eg: Useful examples at the command line. (github.com)](https://github.com/srsudar/eg)

- ```bash
  (base) #( 04/17/24@ 9:28PM )( cxxu@ColorfulCxxu ):/mnt/c/Users/cxxu/Desktop
     pip install eg
  Looking in indexes: https://pypi.tuna.tsinghua.edu.cn/simple
  Collecting eg
    Downloading https://pypi.tuna.tsinghua.edu.cn/packages/5f/3f/f55eef404adae2d5429728722d6a81ad6ac50a80e9b47be046cfbe97bc44/eg-1.2.2.tar.gz (53 kB)
       ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 53.7/53.7 kB 552.1 kB/s eta 0:00:00
    Preparing metadata (setup.py) ... done
  Building wheels for collected packages: eg
    Building wheel for eg (setup.py) ... done
    Created wheel for eg: filename=eg-1.2.2-py3-none-any.whl size=67519 sha256=78402f784b7714f85beabad8694eac767c314970ad1b111dc23165440af7c1e4
    Stored in directory: /home/cxxu/.cache/pip/wheels/56/79/b3/8b31a239778737c4095f6122cdb5162c7752c464693be1b76d
  Successfully built eg
  Installing collected packages: eg
  Successfully installed eg-1.2.2
  ```

## cheat

- [Installing and Using the cheat Command on Linux | Linode](https://www.linode.com/docs/guides/linux-cheat-command/)

- ```bash
  cd /tmp \
    && wget https://github.moeyy.xyz/https://github.com/cheat/cheat/releases/download/4.4.2/cheat-linux-amd64.gz \
    && gunzip cheat-linux-amd64.gz \
    && chmod +x cheat-linux-amd64 \
    && sudo mv cheat-linux-amd64 /usr/local/bin/cheat
  ```

  

