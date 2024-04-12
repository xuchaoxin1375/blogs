[toc]

## 快速linux命令行美化指南

- 主要适配于Debian系的linux发行版
- 由于不同发行版换源的动作各有差异,这里就不展开了(默认用户都搞定了,最好还搞定了ssh链接)
- 主要介绍利用Oh my zsh来美化,并且在国内网络环境下也能够快速下载安装的开门见山的脚本集合
- 理想情况下,不需要太多时间就可以完成部署
- 我在 ubuntu,linux Mint两个发行版上试验过,都可以良好运行(windows wsl 子系统也没问题)

## Oh my zsh

### 官网

- https://github.com/ohmyzsh/ohmyzsh
- 镜像加速站:[Gitee 极速下载/oh-my-zsh](https://gitee.com/mirrors/oh-my-zsh)

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

1. 进入bash下载插件到对应的目录(`.oh-my-zsh`)

   - ```bash
     # 将两个插件下载到指定目录下:(git 已经指定好了目录)
     git clone https://gitee.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
     
     git clone https://gitee.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
     
     ```

2. 在bash下调用sed来配置.zshrc文件,将相关插件配置到zsh插件(plugins)中

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
     
     #检查配置文件是否有相应的行
     cat ~/.zshrc|grep  -e zsh-syntax-highlighting -e zsh-autosuggestions
     
     
     ```

3. 进入到zsh刷新`~/.zshrc`,让zsh的配置生效

   - ```bash
     source ~/.zshrc
     ```

4. 合并版

   - 等候后续改进
     - 将各个能够单独运行脚本制作成shell文件,打包制作成一个仓库
     - 用户克隆下来执行安装程序


   

## 配置oh my zsh主题

- ```bash
  zshrc=~/.zshrc
  echo $zshrc
  # 利用sed并启用扩展正则原地修改,将Zsh主题设置为随机
  sed -Ei 's/(^ZSH_THEME=)(.*)/\1"random"/' $zshrc
  #设置随机选择的主题的列表为ys,junkfood,rkj-repos;具体可以改成自己喜欢的主题
  sed -Ei.bak 's/(^#*\s*)(ZSH_THEME_RANDOM.*=)(.*)/\2("ys" "junkfood" "rkj-repos")/' $zshrc
  #检查修改结果
  cat   ~/.zshrc|grep -E  '^[^#]'|grep -e random -e THEME -e RANDOM|cat -n
  #刷新配置结果
  source $zshrc
  
  
  ```

  

