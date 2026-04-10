[toc]
## 主题推荐

- 首要推荐:`rkj-repos`

  - 主题优点：

    - 第一行：提示当前用户@主机名-目录-日期和时间精确到秒
    - 第二行：提示当前的git分支及其commit id:
    - 很方便，很直观，我很爱

  - 然而,它的开销比较大,对于`wsl`酌情使用.
  - 预览:

    - ```bash
      [oh-my-zsh]  theme 'rkj-repos' loaded
      ┌─[cxxu@ubt22] - [~] - [2024-04-10 01:36:40]
      └─[0] <> 
      ```

      

- 其他推荐:单引号引起来的为主题名:

  - `ys`

  - `junkfood`
    - 和白色背景相配,显示的信息也比较实用,启动较为轻快:

  - `tonotdo`  

## ~/.zshrc中修改配置

### 配置随机主题(脚本)🎈

- 例如,指定自己喜欢的若干个主题,每次载入zsh,随机加载其中的一个

- 为了方便,可以使用下面的脚本(sed),快速体验(粘贴到shell)中直接运行

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

  - 脚本中的`"ys" "junkfood" "rkj-repos"`可以换成自己喜欢的列表

- 脚本解释

  - 重点语句:`sed -Ei.bak 's/(^#*\s*)(ZSH_THEME_RANDOM.*=)(.*)/\2("ys" "junkfood" "rkj-repos")/' $zshrc`
  - 这个 `sed` 命令的作用是对 `$zshrc` 文件中的特定行进行搜索和替换，并且备份原文件（`.bak` 扩展名）。通过 `-E` 参数启用扩展正则表达式（ERE），使得正则表达式的写法更为简洁。下面是命令各部分的详细解释：
    - `sed`: 流编辑器，用于处理文本流。
    - `-E`: 选项，启用扩展正则表达式，使得可以使用更简化的正则语法。
    - `-i.bak`: 选项，表示在原地修改文件 (`-i`)，并创建一个备份文件，备份文件名为原文件名后加上 `.bak`。
    - `'s/(^#*\s*)(ZSH_THEME_RANDOM.*=)(.*)/\2("ys" "junkfood" "rkj-repos")/'`: 这是 `sed` 的替换命令（`s` 命令）的具体内容，它的工作原理是：
      - `s` 代表 substitute，即替换操作。
      - `(^#*\s*)`: 第一个括号内的正则表达式匹配行首可能出现的任意数量的井号（`#`）和任意数量的空白符（`\s*`）。
      - `(ZSH_THEME_RANDOM.*=)`: 第二个括号内的正则表达式匹配以 "ZSH_THEME_RANDOM" 开始，直到遇见等号（`=`, `.*` 表示匹配任意字符零次或多次）的部分。
      - `(.*)`: 第三个括号内的正则表达式匹配等号后面的所有内容直到行尾。
      - `\2("ys" "junkfood" "rkj-repos")`: 替换部分，`\2` 引用了第二个括号匹配的内容（即 `ZSH_THEME_RANDOM` 后面跟着等号的部分），后面的字符串 `("ys" "junkfood" "rkj-repos")` 被用来替换第三个括号匹配的内容，即等号后面原来的所有内容。
  - 综上所述，该命令的作用是查找 `demo.txt` 文件中以 `ZSH_THEME_RANDOM` 开头，紧接着等号的行，并将等号后面的内容替换为字符串数组 `("ys" "junkfood" "rkj-repos")`，同时保留 `ZSH_THEME_RANDOM` 后面到等号这部分内容不变。原文件会被修改，并创建一个备份文件 `demo.txt.bak`。


### 查看效果



- 可以反复执行`zsh`,查看随机加载效果

- ```bash
  [oh-my-zsh] Random theme 'ys' loaded
  # cxxu @ ubt22 in ~ [14:16:44]
  $ zsh
  
  [oh-my-zsh] Random theme 'rkj-repos' loaded
  ┌─[cxxu@ubt22] - [~] - [2024-04-10 02:16:45]
  └─[0] <> zsh
  
  [oh-my-zsh] Random theme 'junkfood' loaded
  #( 04/10/24@ 2:16PM )( cxxu@ubt22 ):~
     zsh
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



## 切换下一个主题

- 在random模式下,输入zsh可以查看下一个主题
- 
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210604092023479.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
- ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210604092056992.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210101131315393.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210101131855151.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3h1Y2hhb3hpbjEzNzU=,size_16,color_FFFFFF,t_70)