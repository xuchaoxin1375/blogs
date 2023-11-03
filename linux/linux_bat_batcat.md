# linux/windows_powershell_bat_batcat(语法高亮文件查看命令行工具)/bat主题设置

## references

- [sharkdp/bat: A cat(1) clone with wings. (github.com)](https://github.com/sharkdp/bat)

### linux

#### 通用方式

- 安装以及使用说明

- [sharkdp/bat: A cat(1) clone with wings. (github.com)](https://github.com/sharkdp/bat#installation)

- > ubuntu通用安装方法/最新版本(早于20.xx也可以适用),可以通过下载deb包进行安装

  #### 较新发行版使用较新的包管理工具安装

  - 安装完成后,调用名字可能是`batcat`(而不是`bat`)
    - 可以考虑配置别名或者创建一个指定名字的符号链接到`batcat`

  ### windows

> - chocolate方式安装
>   - 经过试验,可以正常安装
>   - 注意chocolate的安装需要花费一些时间
>
> - scoop方式
>   - 我操作过程中报了一个错误(如果遇到busybox包冲突,将busybox工具集卸载(再重装))

### 主题设置

> - 在0.20版本,我没有成功通过命令行设置默认主题(`--theme`)没有反应
>
> - ```bash
>   #( 05/10/22@12:45PM )( cxxu@CxxuWin11 ):~
>      bat -V
>   bat 0.20.0
>   ```
>
> - 可以使用环境变量`BAT-THEME`的方式设置主题
>
>   - windows可以使用GUI/powershell对象配置永久环境变量
>   - linux可以写入某一个配置文件中,实现永久配置

#### 适用于白色/浅色背景的主题

> - 浅色主题下,可以使用`GitHub`

##### 效果

> ![image-20220510130255464](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220510130255464.png)
>
> ![image-20220510130145482](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220510130145482.png)