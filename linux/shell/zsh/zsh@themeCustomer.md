[toc]



## recommended list of themes

- `rkj-repos`
  - ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210603195554307.png)
- 主题优点：
  - 第一行：提示当前目录，提示日期和时间
  - 第二行：提示当前的git分支及其commit id:
  - 很方便，很直观，很good！
  - 然而,它的开销比较大,对于`wsl`酌情使用.

- 其他推荐:单引号引起来的为主题名:
  - `ys`

  - `junkfood`

  -  和白色背景相配,显示的信息也比较实用,启动较为轻快:

  - `tonotdo`  
  ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210628164132741.png)


## 在~/.zshrc中修改配置

### 配置随机主题(脚本)🎈

- 例如,指定自己喜欢的若干个主题,每次载入zsh,随机加载其中的一个
- 为了方便,可以使用下面的脚本(sed),快速体验(粘贴到shell)中直接运行

- ```bash
  zshrc=~/.zshrc
  echo $zshrc
  sed -Ei 's/(^ZSH_THEME=)(.*)/\1"random"/' $zshrc
  sed -Ei.bak 's/(^#*)(ZSH_THEME_RANDOM.*=)(.*)/\2("ys" "junkfood" "rkj-repos")/' $zshrc
  source $zshrc
  
  #cat -n ~/.zshrc|grep -e random -e RANDOM
  cat   ~/.zshrc|grep -E  '^[^#]'|grep -e random -e THEME -e RANDOM
  
  ```

  - 脚本中的`"ys" "junkfood" "rkj-repos"`可以换成自己喜欢的列表

- 刷新状态:`source ~/.zshrc`

  - 可以反复执行,查看随机加载效果

  - ```bash
    ┌─[cxxu_u22@cxxuWn11] - [~] - [2023-01-02 01:09:48]
    └─[0] <> cat   ~/.zshrc|grep -E  '^[^#]'|grep -e random -e THEME -e RANDOM
    ZSH_THEME="random"
    ZSH_THEME_RANDOM_CANDIDATES=("ys" "junkfood" "rkj-repos")
    ```

    

##  官方主题列表展示
- [Themes · ohmyzsh/ohmyzsh Wiki (github.com)](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)

```bash
[oh-my-zsh] Random theme 'xiong-chiamiov' loaded
┌─[xucahoxin_debian@xuchaoxin] - [~] - [Fri Jan 01, 12:34]

[oh-my-zsh] Random theme 'candy' loaded
xucahoxin_debian@xuchaoxin [12:32:35 PM] [~] 

[oh-my-zsh] Random theme 'darkblood' loaded
┌[xucahoxin_debian@xuchaoxin] [/dev/pts/1] 
└[~]> zsh

z[oh-my-zsh] Random theme 'dallas' loaded
{21-01-01 12:38}xuchaoxin:~ xucahoxin_debian% zsh

[oh-my-zsh] Random theme 'fino-time' loaded
╭─xucahoxin_debian at xuchaoxin in ~ 21-01-01 - 12:40:05
╰─○ 
[oh-my-zsh] Random theme 'maran' loaded
xucahoxin_debian@xuchaoxin:/home/xucahoxin_debian $ zsh

[oh-my-zsh] Random theme 'jonathan' loaded
┌─(~)──────────────────────────────────────────────────────────────────────────────────────────────────────────(xucahoxin_debian@xuchaoxin:pts/1)─┐
└─(12:40:54)──> zsh     

[oh-my-zsh] Random theme 'rkj-repos' loaded
┌─[xucahoxin_debian@xuchaoxin] - [~] - [2021-01-01 12:41:48]
└─[0] <> zsh
```
##  the visual effects:

在random模式下,输入zsh可以查看下一个主题:
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210604092023479.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210604092056992.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210101131315393.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210101131855151.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)