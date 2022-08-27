[toc]

# linux_命令行助手:(manpages supplement)/获取linux命令用法示例的若干辅助命令行工具(cheat/tldr)

## references

- [CLI cheat sheets - which one do you prefer? | Linux.org](https://www.linux.org/threads/cli-cheat-sheets-which-one-do-you-prefer.21422/)

- [linux_/linux_python报警warning/pip检查/提示找不到pip安装的包/将python包安装路径加入到系统变量(linux PATH)](https://blog.csdn.net/xuchaoxin1375/article/details/124101857?csdn_share_tail={"type"%3A"blog"%2C"rType"%3A"article"%2C"rId"%3A"124101857"%2C"source"%3A"xuchaoxin1375"}&ctrtid=3P4Wv)

  - linux下如果有多个版本的python3,容易出现各种,问题,可以通过这个链接排查/解决问题

  - > 本文介绍的工具有些需要使用python pip 来安装,故在此一提.

## 我的推荐

- tldr

  - > - tldr 相对较全,几乎都可以查到,甚至可以查找bash中的运算符
    >
    > - 可以任选一个版本使用
    > - [tldr vs tealdeer - compare differences and reviews? | LibHunt](https://www.libhunt.com/compare-tldr-vs-tealdeer)

  - 该工具有许多版本的实现

  - npm版的安装简单,反应速度稍慢

    - 自动更新缓存

  - Rust版,安装时占用许多资源,但是使用的时候性能好,有色彩

    - 又叫`tealdeer`
    - 需要手动更新缓存
    - 可以取别名简化命令(下方查询双中括号的用法)
    - ![image-20220430184300650](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220430184300650.png)

  - 其中python版的不太稳定

- `eg`(by python)

## ltdr(python pip/nodejs based)

### ltdr工具介绍



> - too long don't read(tldr)
>
> Simplified and community-driven man pages

#### 获取帮助

```
┌─[cxxu@cxxuAli] - [~] - [2022-04-11 02:08:13]
└─[0] <>  tldr -h
- Usage: tldr command [options]
Simplified and community-driven man pages...
```

### 在线版tldr

> - 在线tldr工具[tldr | simplified, community driven man pages (ostera.io)](https://tldr.ostera.io/)

### 安装一个本地版本

- 环境预备:安装/配置nodejs&npm
- `npm -g install tldr`

- python 下也有相应的tldr

## manly(python based)

> - 解释您的命令所带的选项
> - 类似工具还有`explainshells`
>   - 还有在线网站

```
┌─[cxxu@cxxuAli] - [~/.local/lib/python3.8/site-packages] - [2022-04-11 02:27:24]
└─[0] <> manly -h
usage: manly [-h] [-v] ...

Explain how FLAGS modify a COMMAND's behaviour.

positional arguments:
  command

optional arguments:
  -h, --help     show this help message and exit
  -v, --version  display version information and exit.
# 例子
example:
    $ manly rm --preserve-root -rf

    rm - remove files or directories
    ================================

        -f, --force
                ignore nonexistent files and arguments, never prompt

        --preserve-root
                do not remove '/' (default)

        -r, -R, --recursive
                remove directories and their contents recursively
```

## bropages(gem&ruby based)

> - 使用体验:一般
>

### #ruby 环境安装

```bash
sudo apt install ruby-full
# 检查版本
ruby --version
```

### #安装gem+bropages

```basH
# gem可以安装bropages
sudo apt install gem
#环境准备完毕,开始下载build bropages
sudo gem install bropages
```

### 使用

#### 获取帮助

 `bro -h`

### 查询某个命令

`bro <commandName>`

#### 示例:bro top

```
┌─[cxxu@cxxuAli] - [~] - [2022-04-11 11:44:19]
└─[0] <> bro top
/var/lib/gems/2.5.0/gems/commander-4.1.5/lib/commander/user_interaction.rb:328: warning: constant ::NIL is deprecated
commander-4.1.5/lib/commander/user_interaction.rb:328: warning: constant ::Bignum is deprecated
4 entries for top -- submit your own example with "bro add top"

# order by memory
top -o %MEM

        bro thanks      to upvote (4)
        bro ...no       to downvote (0)

......................................................................................................................................................................................

# monitor the process with pid 1, 2, and 3
top -p 1, 2, 3

        bro thanks 2    to upvote (5)
        bro ...no 2     to downvote (2)

......................................................................................................................................................................................

# Run the top command once, and only show the header and first 8 processes
# Can be further parsed with '| awk ...' in various scripts
top -n 1 | head -n 15

        bro thanks 3    to upvote (3)
        bro ...no 3     to downvote (1)
```



## cheat(dependent/go based/python pip based)

- [Installing and Using the cheat Command on Linux | Linode](https://www.linode.com/docs/guides/linux-cheat-command/)

### install from github release
####  cheat 脚本化安装(预备:获取cheat包)


> -  可以安装到最新版本
> - 分为两部分
>   - cheat 程序工具
>   - cheatsheet/管理工具+ 数据字典(可以手动下载,也可以由cheat自动clone)
>     - [cheat/cheat: cheatsheet)](https://github.com/cheat/cheat#cheatsheets)

- 手动选择下载包

  - [Releases · cheat/cheat (github.com)](https://github.com/cheat/cheat/releases)
    - 可以使用wget 下载合适自己版本的包
    - 如果下不下来,可以在windows浏览器下载,然后用`scp`等方式发送的linux
  - [https://gitee.com/mirrors_cheat/cheat.git](https://gitee.com/mirrors_cheat/cheat.git)
    -  国内镜像(可以clone,但似乎没有release可以下载)
   - cheatsheet(数据源:gitee镜像)
   - [mirrors_cheat/cheatsheets (gitee.com)](https://gitee.com/mirrors_cheat/cheatsheets)

#####  reference(optional)
- 包的解压与权限修改+使用

  - [Installing and Using the cheat Command on Linux | Linode](https://www.linode.com/docs/guides/linux-cheat-command/)
####  正式安装
> 获取到合适自己系统的包后
> 我整合了安装脚本,可以复制粘贴直接运行
>
- 下例子中以`cheat-linux-amd64.gz`为例进行安装(最主流的包)
```bash
gzip -dk cheat-linux-amd64.gz
sudo mv cheat-linux-amd64 /usr/local/bin/cheat
sudo chmod +x /usr/local/bin/cheat
cheat --version
# 准备cheatsheet 数据源以及配置
mkdir -p ~/.config/cheat #如果报错,请删除掉这一行
cd ~/.config/cheat
echo "---
# The editor to use with 'cheat -e <sheet>'. Defaults to $EDITOR or $VISUAL.
editor: vim

# Should 'cheat' always colorize output?
colorize: true

# Which 'chroma' colorscheme should be applied to the output?
# Options are available here:
#   https://github.com/alecthomas/chroma/tree/master/styles
style: monokai

# Which 'chroma' "formatter" should be applied?
# One of: "terminal", "terminal256", "terminal16m"
formatter: terminal16m

# Through which pager should output be piped? (Unset this key for no pager.)
pager: less -FRX

# The paths at which cheatsheets are available. Tags associated with a cheatpath
# are automatically attached to all cheatsheets residing on that path.
#
# Whenever cheatsheets share the same title (like 'tar'), the most local
# cheatsheets (those which come later in this file) take precedent over the
# less local sheets. This allows you to create your own "overides" for
# "upstream" cheatsheets.
#
# But what if you want to view the "upstream" cheatsheets instead of your own?
# Cheatsheets may be filtered via 'cheat -t <tag>' in combination with other
# commands. So, if you want to view the 'tar' cheatsheet that is tagged as
# 'community' rather than your own, you can use: cheat tar -t community
cheatpaths:

  # Paths that come earlier are considered to be the most "global", and will
  # thus be overridden by more local cheatsheets. That being the case, you
  # should probably list community cheatsheets first.
  #
  # Note that the paths and tags listed below are placeholders. You may freely
  # change them to suit your needs.
  #
  # Community cheatsheets must be installed separately, though you may have
  # downloaded them automatically when installing 'cheat'. If not, you may
  # download them here:
  #
  # https://github.com/cheat/cheatsheets
  #
  # Once downloaded, ensure that 'path' below points to the location at which
  # you downloaded the community cheatsheets.
  - name: community
    path: /home/cxxu/.config/cheat/cheatsheets/community
    tags: [ community ]
    readonly: true

  # If you have personalized cheatsheets, list them last. They will take
  # precedence over the more global cheatsheets.
  - name: personal
    path: /home/cxxu/.config/cheat/cheatsheets/personal
    tags: [ personal ]
    readonly: false

  # While it requires no configuration here, it's also worth noting that
  # 'cheat' will automatically append directories named '.cheat' within the
  # current working directory to the 'cheatpath'. This can be very useful if
  # you'd like to closely associate cheatsheets with, for example, a directory
  # containing source code.
  #
  # Such "directory-scoped" cheatsheets will be treated as the most "local"
  # cheatsheets, and will override less "local" cheatsheets. Likewise,
  # directory-scoped cheatsheets will always be editable ('readonly: false').%" > conf.yml
cd cheatsheets
mkdir personal 

```
###  cheat 原生安装

> 可能因为网络问题,导致clone失败,如果这样,可以多试几次,或者采用上述的脚本安装
> - 中途可能提示没有配置文件而需要从 github clone

  - ```
    # cxxu @ CxxuWin11 in ~ [20:04:13] C:130
    $ cheat ls
    A config file was not found. Would you like to create one now? [Y/n]: y
    Would you like to download the community cheatsheets? [Y/n]: y
    
    Cloning into '/home/cxxu/.config/cheat/cheatsheets/community'...
    remote: Enumerating objects: 1118, done.
    remote: Counting objects: 100% (278/278), done.
    remote: Compressing objects: 100% (33/33), done.
    remote: Total 1118 (delta 256), reused 245 (delta 245), pack-reused 840
    Receiving objects: 100% (1118/1118), 284.04 KiB | 488.00 KiB/s, done.
    Resolving deltas: 100% (491/491), done.
    Created config file: /home/cxxu/.config/cheat/conf.yml
    Please read this file for advanced configuration information.
    
    # cxxu @ CxxuWin11 in ~ [20:08:59]
    $ cheat -v
    4.2.3
    
    
    ```

    - 简单使用

    - ```bash
      # cxxu @ CxxuWin11 in ~ [20:13:18]
      $ cheat top
      
      # To update every <interval> samples:
      top -i <interval>
      
      # To set the delay between updates to <delay> seconds:
      top -s <delay>
      
      # To set event counting to accumulative mode:
      top -a
      
      # To set event counting to delta mode:
      top -d
      
      ```



## eg(by python)

- `pip install eg`
  - 使用体验:较好
  - ![image-20220430184902677](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220430184902677.png)

