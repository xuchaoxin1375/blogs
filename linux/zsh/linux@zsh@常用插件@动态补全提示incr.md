[toc]



## 下载incr地址:

[https://mimosa-pudica.net/zsh-incremental.html](https://mimosa-pudica.net/zsh-incremental.html)

- 值得注意的是,该插件某些场景下比较卡顿,可以不设置为自动启动,在想用的时候通过:
  - source /incr所在目录/incr*.zsh

- 事实上,我认为,shell自带的`tab`提示候选已经足够了,如果在配合轻量的autocomplete插件,则更加高效,但是`incr`虽然可以动态提示,但是开销较大,影响性能
- incr插件本身不依赖于`oh-my-zsh`框架,只需要原始的zsh(zshell)就可以驱动该插件


- 下载时,为了和oh my zsh 插件目录结构相适应,执行如下命令创建目录:

```bash
mkdir -p ~/.oh-my-zsh/plugins/incr/
cd ~/.oh-my-zsh/plugins/incr/
wget http://mimosa-pudica.net/src/incr-0.2.zsh   
```
###  启用脚本

`source incr*.zsh`

##  配置自启

设置自动启动incr动态提示插件:(设置永久有效,当然可以把添加的行注释掉以关闭它)
编辑.zshrc:

```bash
 vim ~/.zshrc   
```

在末尾添加一行:
(ctrl+G),o
```bash
source ~/.oh-my-zsh/plugins/incr/incr*.zsh
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201230074825380.png)
立即生效,执行

```bash
source ~/.zshrc
```

使配置生效.
![在这里插入图片描述](https://img-blog.csdnimg.cn/20201230074431853.png)

[reference link1:How Do I Enable Syntax Highlighting in ZSH](https://linuxhint.com/enable-syntax-highlighting-zsh/#:~:text=What%20is%20ZSH-Syntax-Highlighting%3F%20The%20ZSH%20syntax%20highlighting%20feature%E2%80%94similar,is%20to%20ensure%20we%20have%20the%20shell%20installed.)
[reference link2](https://github.com/zsh-users/zsh-syntax-highlighting) 

<hr>
> 高亮插件不依赖于oh My zsh
##  zsh-syntax-highlighting

### 下载(clone)插件到指定目录
`git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
`
###  在zshrc中注册该插件
Finally, add the zsh-syntax-highlighting as the plugin in your .zshrc file as:

`plugins=( zsh-syntax-highlighting)`

但是一般的,您的插件不只一个,可以写成如下形式
```bash
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
 # zsh-autosuggestions
  #其他插件...
  autojump
  zsh-syntax-highlighting
)
```
###  激活该配置,使插件生效
To apply the changes to your current terminal session, enter the command:

`source ~/.oh-my-zsh/zshrc`

##  zsh-autosuggestion
- 过程和zsh-syntaxhighlith几乎一样
##  reference of auto-suggestions
- [How to Use ZSH Auto-suggestions (linuxhint.com)](https://linuxhint.com/use-zsh-auto-suggestions/)
插件也不依赖于oh my zsh框架(仅依赖于zsh),但是可以整合到oh-my-zsh
- 下载(克隆)
`git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
`
然后添加
```bash
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
 zsh-autosuggestions
  #其他插件...
  autojump
  zsh-syntax-highlighting
)
```
激活
```bash
cd ~
source .zhsrc
```
##  一键批量安装上述两个插件😊
- !!! 执行下述脚本最好切换到bash执行(zsh下执行sed的某些指令可能会提示找不到sed!)

- 包括 zsh-autosuggestion
- zsh-syntax-highlight

## 两个插件克隆成功可能需要多次尝试
1. 下载插件到对应的目录(`.oh-my-zsh`)

  - ```bash
    
    # 将两个插件下载到指定目录下:(git 已经指定好了目录)
    git clone https://gitee.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    
    git clone https://gitee.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    
    ```

2. 进入bash并调用sed来配置.zshrc文件,将相关插件配置到zsh插件(plugins)中

  - ```bash
    #将工作目录转移到家目录
    cd ~
    path=.zshrc
    sed '/(^plugins)/ s/^#*/#/;
    /^#*plugins/ a\
    plugins=(\
        git\
        zsh-syntax-highlighting\
        zsh-autosuggestions\
        # 注意,sed命令的后续不能换行\
    )' -r -iE $path
    
    
    ```

3. 进入到zsh刷新`~/.zshrc`,让zsh的配置生效

  - ```bash
    source ~/.zshrc
    ```
    
    

### 附:加速/clone两个插件

>将github换为gitee,提高clone成功率
```bash

git clone https://gitee.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://gitee.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```