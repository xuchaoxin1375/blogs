[toc]



##  neovim安装

### refs@document

- [neovim/neovim: Vim-fork focused on extensibility and usability (github.com)](https://github.com/neovim/neovim#readme)

- [Installing Neovim · neovim/neovim Wiki (github.com)](https://github.com/neovim/neovim/wiki/Installing-Neovim)

###  用scoop 安装

- 如果您的网络环境允许,scoop安装时不错的选择

- 通过`nvim`可以在终端(powershell)中启动neovim

- (注意不是用`neovim`启动,而是`nvim`)

  - ```bash
                                  NVIM v0.5.1
    ~
    ~                                     Nvim is open source and freely distributable
    ~                                               https://neovim.io/#chat
    ~
    ~                                    type  :help nvim<Enter>       if you are new!
    ~                                    type  :checkhealth<Enter>     to optimize Nvim
    ~                                    type  :q<Enter>               to exit
    ~                                    type  :help<Enter>            for help
    ~
    ~                                               Sponsor Vim development!
    ~                                    type  :help sponsor<Enter>    for information
    ~
    ```

    

### scoop查询neovim安装目录

- ```
  PS C:\Users\cxxu> scoop which nvim
  D:\exes\neovim\bin\nvim.exe
  ```

- 这里的`~`表示用户家目录(%userProfile%)



##  安装vscode extension

- [introduction/download installation](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim)
- 您需要在插件中指定对应系统下的neovim可执行文件的目录



##  插件配置

- by command palette
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/2bdfb2b9038d45ed82a8122908b8b1fc.png)
  - 搜索`neovim path`

- 配置时注意区分linux path/windows path


## 使得配置生效

- 重启窗口

  - ctrl+shift+p:
  - `reload window`

  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/a6df682e3ca64ae8ba31c55f0c1125b5.png)

##  vimrc 配置文件 

- vimrc 在neovim中的相对应的配置文件是`init.vim`(或者是`init.lua`)

  - `:help init.vim`

    - ```bash
        config init.vim init.lua vimrc exrc
              A file that contains initialization commands is generically called
              a "vimrc" or config file.  It can be a Vimscript or Lua file named
              "init.vim" or "init.lua" respectively.  It is an error to use both at
              the same time.  Each line in a "init.vim" is executed as an Ex command
              line.  See also vimrc-intro and base-directories.
        
              The config file is located at:
                      Unix            ~/.config/nvim/init.vim (or init.lua)
                      Windows         ~/AppData/Local/nvim/init.vim (or init.lua)
              or if $XDG_CONFIG_HOME is defined:
                                      $XDG_CONFIG_HOME/nvim/init.vim (or init.lua)
      ```

- 然而,某些情况下您找不到这个文件,可以手动创建

- 根据help 提示,在

  - `%localAppData%\`下创建相应的目录`nvim`
  - 并创建文件`init.vim`
  - 这样就可以完成配置

- windows下重开一个nvim,可以看到效果


#  配置文件和$MYVIMRC
##  neovim配置

###  :help vim.init 

```c
 A file that contains initialization commands is generically called
        a "vimrc" or config file.  It can be a Vimscript or Lua file named
        "init.vim" or "init.lua" respectively.  It is an error to use both at
        the same time.  Each line in a "init.vim" is executed as an Ex command
        line.  See also vimrc-intro and base-directories.

        The config file is located at:
                Unix            ~/.config/nvim/init.vim (or init.lua)
                Windows         ~/AppData/Local/nvim/init.vim (or init.lua)
```
###  创建init.vim

- for windows
  - powershell下可以执行:
    - ` new-item -Type File  ~/AppData/Local/nvim/init.vim -Force`
- for linux
  - `touch  ~/.config/nvim/init.vim  `
####  编辑已创建的配置文件
- `edit $myvimrc`(windows下部分大小写)
- tab可以补全
![在这里插入图片描述](https://img-blog.csdnimg.cn/8621495fd895424c99252a5f04f84836.png)

## vim配置

- ```basH
  . Execute Ex commands, from environment variables and/or files
          An environment variable is read as one Ex command line, where multiple
          commands must be separated with '|' or "<NL>".
                                                                  vimrc exrc
          A file that contains initialization commands is called a "vimrc" file.
          Each line in a vimrc file is executed as an Ex command line.  It is
          sometimes also referred to as "exrc" file.  They are the same type of
          file, but "exrc" is what Vi always used, "vimrc" is a Vim specific
          name.  Also see vimrc-intro.
  
          Places for your personal initializations:
                  Unix            $HOME/.vimrc or $HOME/.vim/vimrc
                  MS-Windows      $HOME/_vimrc, $HOME/vimfiles/vimrc
                                  or $VIM/_vimrc
                  Amiga           s:.vimrc, home:.vimrc, home:vimfiles:vimrc
                                  or $VIM/.vimrc
                  Haiku           $HOME/config/settings/vim/vimrc
  
          The files are searched in the order specified above and only the first
          one that is found is read.
  ```

  


###  :version(👩 for vim)

```csharp
Compiled by team+vim@tracker.debian.org
Huge version without GUI.  Features included (+) or not (-):
+acl               +file_in_path      +mouse_urxvt       -tag_any_white
+arabic            +find_in_path      +mouse_xterm       -tcl
+autocmd           +float             +multi_byte        +termguicolors
+autochdir         +folding           +multi_lang        +terminal
-autoservername    -footer            -mzscheme          +terminfo
-balloon_eval      +fork()            +netbeans_intg     +termresponse
+balloon_eval_term +gettext           +num64             +textobjects
-browse            -hangul_input      +packages          +textprop
++builtin_terms    +iconv             +path_extra        +timers
+byte_offset       +insert_expand     -perl              +title
+channel           +ipv6              +persistent_undo   -toolbar
+cindent           +job               +popupwin          +user_commands
-clientserver      +jumplist          +postscript        +vartabs
-clipboard         +keymap            +printer           +vertsplit
+cmdline_compl     +lambda            +profile           +vim9script
+cmdline_hist      +langmap           -python            +viminfo
+cmdline_info      +libcall           +python3           +virtualedit
+comments          +linebreak         +quickfix          +visual
+conceal           +lispindent        +reltime           +visualextra
+cryptv            +listcmds          +rightleft         +vreplace
+cscope            +localmap          -ruby              +wildignore
+cursorbind        -lua               +scrollbind        +wildmenu
+cursorshape       +menu              +signs             +windows
+dialog_con        +mksession         +smartindent       +writebackup
+diff              +modify_fname      +sodium            -X11
+digraphs          +mouse             -sound             -xfontset
-dnd               -mouseshape        +spell             -xim
-ebcdic            +mouse_dec         +startuptime       -xpm
+emacs_tags        +mouse_gpm         +statusline        -xsmp
+eval              -mouse_jsbterm     -sun_workshop      -xterm_clipboard
+ex_extra          +mouse_netterm     +syntax            -xterm_save
+extra_search      +mouse_sgr         +tag_binary
-farsi             -mouse_sysmouse    -tag_old_static
   system vimrc file: "$VIM/vimrc"
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
      user exrc file: "$HOME/.exrc"
       defaults file: "$VIMRUNTIME/defaults.vim"
  fall-back for $VIM: "/usr/share/vim"
Compilation: gcc -c -I. -Iproto -DHAVE_CONFIG_H -Wdate-time -g -O2 -ffile-prefix-map=/build/vim-8W0Acv/vim-8.2.3995=. -flto=auto -ffat-lto-objects -flto=auto -ffat-lto-objects -fstack-protector-strong -Wformat -Werror=format-security -D_REENTRANT -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1
Linking: gcc -Wl,-Bsymbolic-functions -flto=auto -ffat-lto-objects -flto=auto -Wl,-z,relro
-Wl,-z,now -Wl,--as-needed -o vim -lm -ltinfo -lselinux -lsodium -lacl -lattr -lgpm -L/usr/lib/python3.10/config-3.10-x86_64-linux-gnu -lpython3.10 -lcrypt -ldl -lm -lm
```
####  配置文件信息

```csharp
   system vimrc file: "$VIM/vimrc"
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
      user exrc file: "$HOME/.exrc"
       defaults file: "$VIMRUNTIME/defaults.vim"
  fall-back for $VIM: "/usr/share/vim"
```
####  编辑配置文件



- 进入到vim普通模式
- 如果要编辑系统范围内的默认vim配置
- `:edit $VIM/vimrc`
- 其余配置文件类似操作

### 配置文件作用域

####  全局配置文件(linux)

- 为所有用户配置的默认值
- usually by creating `/etc/vimrc` or `/etc/vim/vimrc`
  - `vimrc`是文件而不是目录!
- Depends on `your version` of `vim and linux/unix`
  - `centos` use the former one,the `ubuntu` use the later one

##### 例如:配置所有用户自动打开行号显示

- 配置脚本:

  - ```bash
    
    cat /etc/vim/vimrc |tail
    sudo tee -a /etc/vim/vimrc <<eof
    set nu
    eof
    
    cat /etc/vim/vimrc |tail
    
    ```

    


####  用户个人配置文件(linux)

- 检查是否存在个人用户配置文件`ls ~ -al|grep .vim`

- ```bash
  ls ~ -al|grep .vim
  -rw------- 1 cxxu_u22 cxxu_u22   7213 Jan  1 13:55 .viminfo
  -rw-r--r-- 1 root     root          7 Jan  1 13:52 etcvimrc
  ```

  

- 如果没有`.vimrc`文件,手动创建一个
- 用户的个人配置将覆盖系统的默认配置.

##  ref docs

### 使用本地参考文档:
- 	`:h vimrc`

####  例如 neovim下执行

```csharp
 Load user config (execute Ex commands from files, environment, …).
        An environment variable (e.g. $VIMINIT) is read as one Ex command
        line, where multiple commands must be separated with '|' or <NL>.
                                        config init.vim init.lua vimrc exrc
        A file that contains initialization commands is generically called
        a "vimrc" or config file.  It can be a Vimscript or Lua file named
        "init.vim" or "init.lua" respectively.  It is an error to use both at
        the same time.  Each line in a "init.vim" is executed as an Ex command
        line.  See also vimrc-intro and base-directories.

        The config file is located at:
                Unix            ~/.config/nvim/init.vim (or init.lua)
                Windows         ~/AppData/Local/nvim/init.vim (or init.lua)
        or if $XDG_CONFIG_HOME is defined:
                                $XDG_CONFIG_HOME/nvim/init.vim (or init.lua)
                                    If Nvim was started with "-u {file}" then {file} is used as the config
        and all initializations until 5. are skipped. $MYVIMRC is not set.
        "nvim -u NORC" can be used to skip these initializations without
        reading a file.  "nvim -u NONE" also skips plugins and syntax
        highlighting.  -u
  If Nvim was started with -es all initializations until 5. are
        skipped.
                                                system-vimrc sysinit.vim
     a. The system vimrc file is read for initializations.  If
        nvim/sysinit.vim file exists in one of $XDG_CONFIG_DIRS, it will be
        used.  Otherwise the system vimrc file is used. The path of this file
        is given by the :version command.  Usually it's "$VIM/sysinit.vim".

                                                VIMINIT EXINIT $MYVIMRC
     b. Locations searched for initializations, in order of preference:
        -  $VIMINIT environment variable (Ex command line).
        -  User config: $XDG_CONFIG_HOME/nvim/init.vim.
        -  Other config: {dir}/nvim/init.vim where {dir} is any directory
           in $XDG_CONFIG_DIRS.
        -  $EXINIT environment variable (Ex command line).
        $MYVIMRC is set to the first valid location unless it was already
        set or when using $VIMINIT.

     c. If the 'exrc' option is on (which is NOT the default), the current
        directory is searched for two files.  The first that exists is used,
        the others are ignored.
        -  The file ".nvimrc"
        -  The file ".exrc"
```
###  编辑$VIMRC效果
- 创建完对应文件后,就有这样的效果

- ![在这里插入图片描述](https://img-blog.csdnimg.cn/a78a9405cfe1427aa9477979f270780e.png)

###  在线文档(推荐)
* [Open vimrc file | Vim Tips Wiki | Fandom](https://vim.fandom.com/wiki/Open_vimrc_file)
* [Example vimrc | Vim Tips Wiki | Fandom](https://vim.fandom.com/wiki/Example_vimrc)