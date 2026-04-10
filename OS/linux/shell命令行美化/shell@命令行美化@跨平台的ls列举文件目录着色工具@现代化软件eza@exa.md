[toc]

## abstract

- **eza** is a modern, maintained replacement for the venerable file-listing command-line program `ls` that ships with Unix and Linux operating systems, giving it more features and better defaults. It uses colours to distinguish file types and metadata. It knows about symlinks, extended attributes, and Git. And it’s **small**, **fast**, and just **one single binary**.

  By deliberately making some decisions differently, eza attempts to be a more featureful, more user-friendly version of `ls`.

- **lsd**:This project is a rewrite of GNU `ls` with lots of added features like colors, icons, tree-view, more formatting options etc. The project is heavily inspired by the super [colorls](https://github.com/athityakumar/colorls) project.

`lsd` 和 `eza` 都是现代化的 `ls` 命令替代工具，使用 Rust 编写，支持图标、颜色、树状结构等增强功能。

------

### 功能对比总览

| 特性             | `lsd`                       | `eza`                                                        |
| ---------------- | --------------------------- | ------------------------------------------------------------ |
| 图标支持         | ✅ 默认支持 Nerd Fonts       | ✅ 可通过 `--icons=auto` 控制                                 |
| 树状结构显示     | ✅ `lsd --tree`              | ✅ `eza -T` 或 `eza -R --level N`                             |
| Git 状态显示     | 有限                        | ✅ `eza -l --git` 显示文件的 Git 状态                         |
| 输出格式灵活性   | 中等：支持 grid、long、tree | 高：支持 grid、long、tree、absolute path、hyperlink 等       |
| 文件过滤与排序   | 基础支持                    | 高级支持：按大小、时间、类型、扩展名等排序，支持 `.gitignore` 过滤 |
| 自定义主题       | 有限选择                    | ✅ 支持颜色主题配置（如 `eza-themes` 项目）                   |
| 维护活跃度       | ✅ 活跃                      | ✅ 非常活跃（继承自已停更的 `exa` 项目）                      |
| 安装方式（Arch） | `sudo pacman -S lsd`        | `sudo pacman -S eza`                                         |
| 适合场景         | 美化输出、图标展示          | 高度可定制、适合脚本和高级终端用户                           |

------

### 选择建议

- **如果你注重视觉美化和图标展示**：`lsd` 更简洁，开箱即用，适合日常替代 `ls`。
- **如果你需要更强的功能和脚本集成**：`eza` 提供更丰富的参数和过滤选项，适合自动化和高级用户。

------

🛠️ 示例命令对比

```bash
# lsd 示例
lsd -l         # 类似 ls -l
lsd --tree     # 树状结构显示

# eza 示例
eza -l --git   # 显示 Git 状态
eza -T         # 树状结构显示
eza -l --sort=size --reverse  # 按大小倒序排列
```

------



## eza项目地址

- [eza-community/eza: A modern, maintained replacement for ls (github.com)](https://github.com/eza-community/eza)
  - 是exa的后继项目

### 下载和安装

- [eza/INSTALL.md at main · eza-community/eza (github.com)](https://github.com/eza-community/eza/blob/main/INSTALL.md)

### linux

refs

- [Rust 下载安装加速指南  (zhihu.com)](https://zhuanlan.zhihu.com/p/126201430)

- [linux - How do I fix the Rust error "linker 'cc' not found" for Debian on Windows 10? - Stack Overflow](https://stackoverflow.com/questions/52445961/how-do-i-fix-the-rust-error-linker-cc-not-found-for-debian-on-windows-10)

#### Notes

- linux不同发行版可以有不同的安装方法
- 其中Cargo是通用的linux安装方式,但是需要提前安装Rust Cargo 环境

#### FAQ

- 对于deb/ubuntu系的,先预备安装`sudo apt install build-essential`,以免后续编译失败

- 安装Cargo的时候先设置两个环境变量换为国内源加速:

  - ```bash
    export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
    export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
    ```

- 详情查看上述refs中的第一个链接

### windows

- 安装比较简单,使用winget,scoop 都可以(可能需要代理)

## 效果👺

- ```powershell
  PS>eza --icons -ghilTL 2
  Mode  Size Date Modified Name
  d----    - 18 Mar 19:34   .
  -a--- 331k 18 Mar 18:59  ├──  20240318_185950.mp4
  -a--- 1.2M 18 Mar 19:10  ├──  20240318_191010.mp4
  d----    - 10 Mar 23:22  ├──  ansel
  d-r--    - 18 Mar 19:34  ├── 󰉌 Contacts
  d-r--    - 18 Mar 19:36  ├──  Desktop
  -a--- 1.4k 17 Jan 10:31  │  ├──  blogs_home.lnk
  -a--- 1.4k 19 Jan 14:15  │  ├──  EM.lnk
  -a--- 1.4k 19 Jan 14:14  │  ├──  math.lnk
  -a--- 1.4k 17 Jan 10:33  │  ├──  neep.lnk
  -a---  44k 15 Mar 20:13  │  └──  四边形加固为刚性结构.ggb
  d-r--    - 18 Mar 19:34  ├──  Documents
  d----    - 18 Mar 18:22  │  ├──  Apowersoft
  d----    - 18 Mar 18:03  │  ├──  Captura
  ```

  

- ```bash
  /mnt/c/Users/cxxu/Desktop  $ eza --icons -ghilTL 2                   
             inode Permissions Size User    Group   Date Modified Name
  1125899907235745 drwxrwxrwx     - ubtcxxu ubtcxxu 18 Mar 19:36   .
   281474976901038 .rwxrwxrwx  1.4k ubtcxxu ubtcxxu 17 Jan 10:31  ├──  blogs_home.lnk
   844424930203848 .rwxrwxrwx   282 ubtcxxu ubtcxxu 18 Mar 19:34  ├──  desktop.ini
   281474976901039 .rwxrwxrwx  1.4k ubtcxxu ubtcxxu 19 Jan 14:15  ├──  EM.lnk
   281474976901040 .rwxrwxrwx  1.4k ubtcxxu ubtcxxu 19 Jan 14:14  ├──  math.lnk
   281474976901041 .rwxrwxrwx  1.4k ubtcxxu ubtcxxu 17 Jan 10:33  ├──  nee
  ```

## 其他项目

### exa(deprecated)

- [How to install and use Exa, a modern replacement for the ls command in Ubuntu 16.04 | Our Code World](https://ourcodeworld.com/articles/read/832/how-to-install-and-use-exa-a-modern-replacement-for-the-ls-command-in-ubuntu-16-04)

  - 快速安装

- [Install exa on Ubuntu 20.04 | Lindevs](https://lindevs.com/install-exa-on-ubuntu/)

  - 本方案更加完整:(安装+清理+卸载)


#### 较新版本的linux发行版上安装exa

- `sudo apt install exa`
  - 譬如 ubuntu 21/kali rolling

#### 安装流程(手动通用安装:包括较老版本)

```bash
curl https://sh.rustup.rs -sSf | sh

# Till the date of publication of this article, the latest available download version is the 0.8.0

wget -c https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip
#upzip the tool
unzip exa-linux-x86_64-0.8.0.zip

# Move the unziped binary with the name "exa-linux-x86_64" to "/usr/local/bin/" with the exa name
# so that we can use the program name`exa`directly
sudo mv exa-linux-x86_64 /usr/local/bin/exa
```
###  ls-icons
1. [sebastiencs/ls-icons: ls command with files icons (github.com)](https://github.com/sebastiencs/ls-icons)
  - 这个开源工具安装比较麻烦
    - 需要许多依赖
    - 对网络环境要求较高(耗时)
2. [athityakumar/colorls: A Ruby gem that beautifies the terminal's ls command, with color and font-awesome icons. (github.com)](https://github.com/athityakumar/colorls#installation)
  - 老牌项目,需要ruby/字体 等依赖
  - 注意ruby版本



### powershell上的其他ls美化工具

- [powershell@Get-ChildItem美化@ls文件列表文件图标样式和配色@Terminal-icons.md_powershell ls 着色-CSDN博客](https://blog.csdn.net/xuchaoxin1375/article/details/120933098)



