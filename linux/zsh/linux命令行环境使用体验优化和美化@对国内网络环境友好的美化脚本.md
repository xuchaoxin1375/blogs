[toc]

## Oh my zsh

### 国内推荐安装方式

```bash
# 工作目录设定为用户家目录
cd ~
sudo apt update
sudo apt install zsh curl git  man wget -y
wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
# 由于国内网络问题,可能需要多尝试几次一下source 命令才可以安装成功.(我将其注释掉,采用换源后再执行clone
#source install.sh
#本段代码将修改install.sh中的拉取源,以便您能够冲gitee上成功将需要的文件clone下来.


# 本段代码会再修改前做备份(备份文件名为install.shE)
sed '/(^remote)|(^repo)/I s/^#*/#/ ;
/^#*remote/I a\
REPO=${REPO:-mirrors/oh-my-zsh}\
REMOTE=${REMOTE:-https://gitee.com/${REPO}.git} ' -r ~/install.sh > gitee_install.sh
# 执行安装
source gitee_install.sh


#返回到脚本所在目录(以便执行新的脚本)
cd -
```



## oh-my-zsh 插件

- 这里推荐2个插件
  - [zsh-users/zsh-autosuggestions: Fish-like autosuggestions for zsh (github.com)](https://github.com/zsh-users/zsh-autosuggestions)

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

     



